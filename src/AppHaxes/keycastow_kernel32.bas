type TimerQueue
  pPrev     as TimerQueue ptr
  pNext     as TimerQueue ptr  
  pRealCB   as WAITORTIMERCALLBACK
  pRealParm as PVOID  
  dwTID     as dword
  hThread   as handle
end type

const TimerMaxQueuedItems = 1023
static shared as TimerQueue ptr pTimerQueueFirst,pTimerQueueLast
static shared as TimerQueue ptr pTimerCallBacks(TimerMaxQueuedItems)
static shared as integer iTimerReadCB, iTimerWriteCB
static shared as CRITICAL_SECTION tTimerSync
static shared as handle hTimerEvent

InitializeCriticalSection( @tTimerSync )
hTimerEvent = CreateEvent( null , true , false , null )

UndefAllParams()
#define P1 lpMsg as LPMSG
#define P2 hWnd as HWND
#define P3 wMsgFilterMin as UINTEGER
#define P4 wMsgFilterMax as UINTEGER
dim shared pfGetMessageW as function (P1,P2,P3,P4) as WINBOOL
#if 0
function GetMessageW_Detour(P1,P2,P3,P4) as WINBOOL  
  do    
    var iResu = MsgWaitForMultipleObjects(1,@hTimerEvent,false,INFINITE,QS_ALLINPUT)    
    if iResu = WAIT_OBJECT_0+1 then
      'DEBUG_MsgTrace("Message...")
      return pfGetMessageW(lpMsg,hWnd,wMsgFilterMin,wMsgFilterMax)      
    end if
    do 
      EnterCriticalSection( @tTimerSync )
      if iTimerWriteCB = iTimerReadCB then exit do      
      static as DWORD CurTID = 0
      var NewTID = GetCurrentThreadID()
      if NewTID <> CurTID then 
        DEBUG_MsgTrace("Callback... TID=%i",NewTID)
        CurTID = NewTID
      end if
      var dwCB = cptr(DWORD_PTR,pTimerCallBacks( iTimerReadCB )) 
      with *cptr(TimerQueue ptr,dwCB and (not 1))
        .pRealCB( .pRealParm , (dwCB and 1) )
      end with
      iTimerReadCB = (iTimerReadCB+1) and TimerMaxQueuedItems
      LeaveCriticalSection( @tTimerSync )
    loop
    LeaveCriticalSection( @tTimerSync )
  loop
end function
#endif

function GetMessageW_Detour(P1,P2,P3,P4) as WINBOOL  
  do    
    if PeekMessageW(lpMsg,hWnd,wMsgFilterMin,wMsgFilterMax,false) then
      return pfGetMessageW(lpMsg,hWnd,wMsgFilterMin,wMsgFilterMax)      
    end if
    if WaitForSingleObject( hTimerEvent , 1 ) = 0 then    
      EnterCriticalSection( @tTimerSync )
      if iTimerWriteCB = iTimerReadCB then
        ResetEvent(hTimerEvent)
        LeaveCriticalSection( @tTimerSync )
        continue do
      end if
      
      static as DWORD CurTID = 0
      var NewTID = GetCurrentThreadID()
      if NewTID <> CurTID then 
        DEBUG_MsgTrace("Callback... TID=%i",NewTID)
        CurTID = NewTID
      end if      
      var dwCB = cptr(DWORD_PTR,pTimerCallBacks( iTimerReadCB )) 
      with *cptr(TimerQueue ptr,dwCB and (not 1))
        .pRealCB( .pRealParm , (dwCB and 1) )
      end with
      iTimerReadCB = (iTimerReadCB+1) and TimerMaxQueuedItems
      if iTimerWriteCB = iTimerReadCB then ResetEvent(hTimerEvent)
      LeaveCriticalSection( @tTimerSync )
    end if    
  loop
end function


SetDetourLibrary("user32")
CreateDetour(GetMessageW)

sub TimerQueueProc(lpParameter as PVOID, TimerOrWaitFired as WINBOOL)
  'DEBUG_MsgTrace("Thread: %i Wrapper=0x%08X",GetCurrentThreadID(),lpParameter)
  with *cptr(TimerQueue ptr,lpParameter)        
    do
      EnterCriticalSection( @tTimerSync )
      if ((iTimerWriteCB+1) and TimerMaxQueuedItems) = iTimerReadCB then
        DEBUG_MsgTrace("Queue FULL!")
        LeaveCriticalSection( @tTimerSync )        
        sleepex(250,0)
        continue do
      end if
      'DEBUG_MsgTrace("Queue Added %i",iTimerWriteCB)
      pTimerCallBacks(iTimerWriteCB) = lpParameter+iif(TimerOrWaitFired,1,0)
      iTimerWriteCB = (iTimerWriteCB+1) and TimerMaxQueuedItems
      SetEvent( hTimerEvent )
      LeaveCriticalSection( @tTimerSync )
      exit do
    loop
  end with
end sub

extern "windows-ms"
  UndefAllParams()
  #define P1 phNewTimer as PHANDLE
  #define P2 TimerQueue as HANDLE
  #define P3 Callback as WAITORTIMERCALLBACK
  #define P4 Parameter as PVOID
  #define P5 DueTime as DWORD
  #define P6 Period as DWORD
  #define P7 Flags as ULONG 
  function fnCreateTimerQueueTimer alias "CreateTimerQueueTimer" (P1,P2,P3,P4,P5,P6,P7) as WINBOOL export        
        
    EnterCriticalSection( @tTimerSync )
    var pTemp = cast(TimerQueue ptr,callocate(sizeof(TimerQueue)))
    do
      if (cuint(pTemp) and 1) = 0 then exit do
      var pNew = cast(TimerQueue ptr,callocate(sizeof(TimerQueue)))
      deallocate(pTemp): pTemp = pNew
    loop 
    
    if pTemp = 0 then 
      DEBUG_MsgTrace("failed to allocate queue wrapper")
      return false
    end if
    
    'add to linked list
    with *pTemp
      .pPrev = pTimerQueueLast
      .pNext = 0
      .pRealCB = Callback
      .pRealParm = Parameter
      .dwTID = GetCurrentThreadID()
    end with    
    if pTimerQueueLast then 
      pTimerQueueLast->pNext = pTemp
    else
      pTimerQueueFirst = pTemp
    end if    
    pTimerQueueLast = pTemp
    
    #define _NewCB cast(WAITORTIMERCALLBACK,@TimerQueueProc)
    Flags = WT_EXECUTEINTIMERTHREAD or WT_EXECUTEONLYONCE

    var Result = CreateTimerQueueTimer(phNewTimer,TimerQueue,_NewCB,pTemp,DueTime,Period,Flags)    
    DEBUG_MsgTrace("TID=%i Parm=%08X Result=%i New=%08X Queue=%08X (Wrapper=%08X)",GetCurrentThreadID(),Parameter,Result,*phNewTimer,TimerQueue,pTemp)
    
    LeaveCriticalSection( @tTimerSync )
    return Result    
  end function
end extern