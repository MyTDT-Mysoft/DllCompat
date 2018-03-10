type TimerQueue
  pPrev     as TimerQueue ptr
  pNext     as TimerQueue ptr  
  pRealCB   as WAITORTIMERCALLBACK
  pRealParm as PVOID  
  dwTID     as dword
  hThread   as handle
end type

static shared as TimerQueue ptr pTimerQueueFirst,pTimerQueueLast
'static shared as CRITICAL_SECTION tTimerSync1
static shared as any ptr tTimerSync1, tTimerSync2

tTimerSync1 = MutexCreate() 'InitializeCriticalSection( @tTimerSync1 )
tTimerSync2 = MutexCreate()

sub TestTimerProc(lpParameter as PVOID, TimerOrWaitFired as WINBOOL)
  DEBUG_MsgTrace("lpParamater=%08X TimerOrWaitFired=%08X!",lpParameter,TimerOrWaitFired)
end sub
sub TimerQueueProcTramp()
  'DEBUG_MsgTrace("Trampoline!")  
  MutexUnlock(tTimerSync2)    
  SuspendThread(GetCurrentThread())
  DEBUG_MsgTrace("you should never see this!")    
end sub  
sub TimerQueueProc(lpParameter as PVOID, TimerOrWaitFired as WINBOOL)
  DEBUG_MsgTrace("Thread: %i Wrapper=0x%08X",GetCurrentThreadID(),lpParameter)
  with *cptr(TimerQueue ptr,lpParameter)        
    'EnterCriticalSection( @tTimerSync1 )
    MutexLock( tTimerSync1 )
    do'omy
      dim as CONTEXT tCtx = any          
      tCtx.ContextFlags = CONTEXT_FULL
      dim as integer iPauseCount = 1
      const cThreadFlags = THREAD_GET_CONTEXT or THREAD_SET_CONTEXT or THREAD_SUSPEND_RESUME or THREAD_QUERY_INFORMATION
      .hThread = OpenThread( cThreadFlags , false , .dwTID ) 
      if .hThread = 0 then
        DEBUG_MsgTrace("Failed to open thread: %X (Error %08X)",.dwTID,GetLastError())
        exit do
      end if
      
      'suspend target thread
      DEBUG_MsgTrace("Suspending = %i",SuspendThread(.hThread))
      #if 0
      do 
        var iResu = SuspendThread(.hThread)
        if iResu = 1 then 
          DEBUG_MsgTrace("Failed to get suspend thread: %X (Error %08X)",.dwTID,GetLastError())        
          exit do,do
        end if
        if iResu > 0 then iPauseCount = iResu+1
        'iPauseCount += 1
        exit do
      loop
      #endif
      
      'get thread current context
      if GetThreadContext( .hThread , @tCtx )=false then 
        DEBUG_MsgTrace("Failed to get thread context: %X (Error %08X)",.dwTID,GetLastError())        
        exit do
      end if
      'create sync barrier for the trampoline
      MutexLock( tTimerSync2 )
      'backup and modify it to point to the callback
      var tOldEIP = tCtx.EIP, tOldESP = tCtx.ESP
      
      tCtx.EIP = @TestTimerProc 'cast(DWORD,.pRealCB)
      tCtx.ESP -= sizeof(DWORD)*3
      cptr(any ptr ptr,tCtx.ESP)[0] = @TimerQueueProcTramp
      cptr(any ptr ptr,tCtx.ESP)[1] = .pRealParm
      cptr( DWORD  ptr,tCtx.ESP)[2] = TimerOrWaitFired
      
      #if 0
      
      'set the new context and resume thread
      if SetThreadContext( .hThread, @tCtx )=false then
        DEBUG_MsgTrace("Failed to set thread context: %X (Error %08X)",.dwTID,GetLastError())
        exit do
      end if
      
      'DEBUG_MsgTrace("Resuming = %i",ResumeThread( .hThread ))
      
      'while ResumeThread( .hThread )>1
      '  '
      'wend
      
      'if ResumeThread( .hThread )>0 then
      '  DEBUG_MsgTrace("Failed to set resume thread (on callback): %X (Error %08X)",.dwTID,GetLastError())
      '  exit do
      'end if
      'wait for callback trampoline to release the CS
      'sleep 1,1
      MutexLock( tTimerSync2 )
      'suspend and set previous context back
      var iSusp = SuspendThread(.hThread)
      DEBUG_MsgTrace("Suspending = %i",iSusp)
      
      tCtx.ContextFlags = CONTEXT_FULL
      tCtx.ESP = tOldESP : tCtx.EIP = tOldEIP
      SetThreadContext( .hThread, @tCtx )
      
      'resume the thread on it's original form...
      for N as integer = 1 to iSusp+1 'iPauseCount
      DEBUG_MsgTrace("Resuming = %i",ResumeThread( .hThread ))
      next N      
      
      #endif
      
      ResumeThread( .hThread )
      MutexUnlock( tTimerSync2 )
      
      exit do
    loop'ed
    if .hThread then CloseHandle(.hThread): .hThread=0
    'LeaveCriticalSection( @tTimerSync1 )
    MutexUnlock( tTimerSync1 )
    
    
    '.pRealCB( .pRealParm , TimerOrWaitFired )
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
    
    var pTemp = cast(TimerQueue ptr,callocate(sizeof(TimerQueue)))
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
    var Result = CreateTimerQueueTimer(phNewTimer,TimerQueue,_NewCB,pTemp,DueTime,Period,Flags)
    DEBUG_MsgTrace("TID=%i Parm=%08X Result=%i New=%08X Queue=%08X (Wrapper=%08X)",GetCurrentThreadID(),Parameter,Result,*phNewTimer,TimerQueue,pTemp)
    
    return Result    
  end function
end extern