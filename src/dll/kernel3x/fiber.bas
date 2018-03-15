#define VERBOSE rem
'#define VERBOSE

const FlsMaxSlot = 127
' --- structure that holds our fiber indexes ---
type GlobalFiberDataStruct field=1
  hFiberMutex as CRITICAL_SECTION 
  iThreadTLS  as DWORD
  iFiberCount as DWORD
  iFiberAlloc as DWORD
  pFiberArray as FIBER ptr ptr
  iLastIndex as DWORD
  iLastFreed as DWORD    
  FlsSlotsUsed(FlsMaxSlot) as ubyte
  FlsCallBack(FlsMaxSlot)  as PFLS_CALLBACK_FUNCTION    
end type
static shared as GlobalFiberDataStruct ptr pGlobalFiberData = NULL  
sub _InitGlobalFibers()
  pGlobalFiberData = callocate(sizeof(GlobalFiberDataStruct))
  if pGlobalFiberData then
    InitializeCriticalSection( @pGlobalFiberData->hFiberMutex )
    pGlobalFiberData->iThreadTLS = TlsAlloc()
    pGlobalFiberData->iLastIndex = 0
    pGlobalFiberData->iLastFreed = -1
  end if
  if pGlobalFiberData=0 orelse pGlobalFiberData->iThreadTLS=0 then
    DEBUG_AlertNotImpl()
  end if    
end sub
sub _AddFiberToArray( pFiber as FIBER ptr )
  if pGlobalFiberData = NULL then _InitGlobalFibers()      
  if pGlobalFiberData = NULL then 
    VERBOSE DEBUG_MsgTrace("Fiber %08X got created... but global fiber state allocation failed :(",pFiber)
    exit sub
  end if
  
  with *pGlobalFiberData
    if .iFiberAlloc=0 then
      .iFiberAlloc += 16
      .pFiberArray = allocate(sizeof(PVOID)*.iFiberAlloc)
      if .pFiberArray=0 then
        VERBOSE DEBUG_MsgTrace("Fiber %08X got created... but allocation for fiber array failed :(",pFiber)
      end if
    elseif (.iFiberCount+1) >= .iFiberAlloc then          
      .iFiberAlloc += 16
      .pFiberArray = reallocate(.pFiberArray,sizeof(PVOID)*.iFiberAlloc)
      if .pFiberArray=0 then
        VERBOSE DEBUG_MsgTrace("Fiber %08X got created... but reallocation for fiber array failed :(",pFiber)
      end if      
    end if      
    .pFiberArray[.iFiberCount] = pFiber
    .iFiberCount = .iFiberCount+1
  end with
end sub
sub _RemoveFiberFromArray( pFiber as FIBER ptr )
  if pGlobalFiberData = NULL then 
    VERBOSE DEBUG_MsgTrace("Fiber %08X is to be deleted... but global fiber is not allocated @_@",pFiber)
    exit sub
  end if
  
  'looking for this fiber on the array (slooow)
  with *pGlobalFiberData
    for I as integer = 0 to .iFiberCount-1
      if .pFiberArray[I] = pFiber then
        'Fiber found... so callback must be called 
        VERBOSE DEBUG_MsgTrace("TODO: callback on all indexes for the fiber %08X...",pFiber)
        if I <> .iFiberCount-1 then
          swap .pFiberArray[I], .pFiberArray[.iFiberCount-1]
        end if
        .iFiberCount -= 1
        exit sub
      end if
    next I
  end with
  VERBOSE DEBUG_MsgTrace("Fiber is to be deleted... but not found on the fiber array @_@",pFiber)
end sub



extern "windows-ms"
  UndefAllParams()
  function fnIsThreadAFiber alias "IsThreadAFiber"() as FIBER ptr export
    var pTemp = GetCurrentFiber()
    if pTemp = cast(any ptr,&h1E00) or pTemp=NULL then return 0
    if IsBadReadPtr(pTemp,sizeof(FIBER)-8) then return 0
    return pTemp
  end function  
  
  UndefAllParams()
  #define P1 dwFlsIndex as _In_ DWORD
  function FlsFree(P1) as BOOL export
    if pGlobalFiberData = NULL then
      SetLastError(ERROR_OUTOFMEMORY)
      return 0
    end if
    if dwFlsIndex > FlsMaxSlot orelse pGlobalFiberData->FlsSlotsUsed(dwFlsIndex)=0 then
      SetLastError(ERROR_INVALID_PARAMETER)
      return 0
    end if
    VERBOSE DEBUG_MsgTrace("FlsFree(%i)",.dwFlsIndex)
  end function
  
  UndefAllParams()
  #define P1 dwFlsIndex as _In_ DWORD
  function FlsGetValue(P1) as PVOID export
    if pGlobalFiberData = 0 then SetLastError(0): return 0
    if dwFlsIndex > FlsMaxSlot then SetLastError(ERROR_INVALID_PARAMETER): return 0
    
    var pFiber = fnIsThreadAFiber()
    dim as PVOID ptr pSlotArray = 0
    if pFiber=0 then 'IF not in a fiber... then use a temp FLS from TLS
      VERBOSE DEBUG_MsgTrace("Querying index %i but current thread is not a fiber!",dwFlsIndex)
      pSlotArray = TlsGetValue( pGlobalFiberData->iThreadTLS )
      if PSlotArray = 0 then SetLastError(0):return 0
    else
      with pFiber->FiberContext
        if *cptr( DWORD ptr , @.ExtendedRegisters(512-8) ) <> &hF1BEDA7A then
          VERBOSE DEBUG_MsgTrace("Index %i was queried from fiber %08X but magic doesnt match...",dwFlsIndex,pFiber)
          return 0
        end if
        pSlotArray = *cptr( PVOID ptr , @.ExtendedRegisters(512-4) )
        if pSlotArray = 0 then return 0
      end with
    end if
    return pSlotArray[dwFlsIndex]
  end function
  
  UndefAllParams()
  #define P1 dwFlsIndex as _In_     DWORD
  #define P2 lpFlsData  as _In_opt_ PVOID
  function FlsSetValue(P1, P2) as BOOL export
    if pGlobalFiberData = 0 then _InitGlobalFibers
    if pGlobalFiberData = 0 then SetLastError(ERROR_OUTOFMEMORY): return false
    if dwFlsIndex > FlsMaxSlot then SetLastError(ERROR_INVALID_PARAMETER): return false
    
    var pFiber = fnIsThreadAFiber()
    dim as PVOID ptr pSlotArray = 0
    if pFiber=0 then 'IF not in a fiber... then use a temp FLS from TLS
      VERBOSE DEBUG_MsgTrace("Querying index %i but current thread is not a fiber!",dwFlsIndex)
      pSlotArray = TlsGetValue( pGlobalFiberData->iThreadTLS )      
      if pSlotArray = 0 then 'if the temp FLS is not allocated... allocate it now
        PSlotArray = callocate( sizeof(PVOID)*(FlsMaxSlot+1) )
        if pSlotArray = 0 then SetLastError(ERROR_OUTOFMEMORY): return false
        'and set that on a TLS if allocation went ok
        TlsSetValue( pGlobalFiberData->iThreadTLS , pSlotArray )
      end if
    else
      'Is a Fiber...
      with pFiber->FiberContext
        'Does the FLS magic is there? if not it's a bug!!!
        if *cptr( DWORD ptr , @.ExtendedRegisters(512-8) ) <> &hF1BEDA7A then
          VERBOSE DEBUG_MsgTrace("Index %i was queried from fiber %08X but magic doesnt match...",dwFlsIndex,pFiber)
          return 0
        end if
        'Get FLS array for this fiber... 
        pSlotArray = *cptr( PVOID ptr , @.ExtendedRegisters(512-4) )
        if pSlotArray = 0 then 'Not Allocated yet? do it now
          pSlotArray = callocate( sizeof(PVOID)*(FlsMaxSlot+1) )
          if pSlotArray = 0 then SetLastError(ERROR_OUTOFMEMORY): return false
          'and set that on the fiber context is allocation went ok
          *cptr( PVOID ptr , @.ExtendedRegisters(512-4) ) = pSlotArray
        end if
      end with
    end if
    
    pSlotArray[dwFlsIndex] = lpFlsData
    return true
  end function
  
  UndefAllParams()
  #define P1 lpCallback as _In_ PFLS_CALLBACK_FUNCTION
  function FlsAlloc(P1) as DWORD export
    dim as DWORD dwSlot = 0
    if pGlobalFiberData = NULL then _InitGlobalFibers()      
    if pGlobalFiberData = NULL then SetLastError(ERROR_OUTOFMEMORY): return 0
    if (pGlobalFiberData->iLastFreed) <> -1 then
      dwSlot = pGlobalFiberData->iLastFreed
      pGlobalFiberData->iLastFreed = -1
    else
      for dwSlot = 1 to pGlobalFiberData->iLastIndex
        if pGlobalFiberData->FlsSlotsUsed(dwSlot)=0 then exit for
      next dwSlot
    end if
    
    pGlobalFiberData->FlsSlotsUsed(dwSlot) = 1
    pGlobalFiberData->FlsCallBack(dwSlot) = lpCallback
    if dwSlot > (pGlobalFiberData->iLastIndex) then
      pGlobalFiberData->iLastIndex = dwSlot
    end if

    return dwSlot
  end function
  
  'if pGlobalFiberData = NULL then _InitGlobalFibers()      
  'if pGlobalFiberData = NULL then SetLastError(ERROR_OUTOFMEMORY): return 0
  
  UndefAllParams()
  #define P1 dwStackCommitSize  as _In_     SIZE_T
  #define P2 dwStackReserveSize as _In_     SIZE_T
  #define p3 dwFlags            as _In_     DWORD
  #define P4 lpStartAddress     as _In_     LPFIBER_START_ROUTINE
  #define P5 lpParameter        as _In_opt_ LPVOID
  function fnCreateFiberEx alias "CreateFiberEx"(P1, P2, P3, P4, P5) as LPVOID export
    dim as FIBER ptr pFiber = any
    pFiber = CreateFiberEx( dwStackCommitSize , dwStackReserveSize , dwFlags , lpStartAddress , lpParameter )
    if pFiber = 0 then return 0
    with pFiber->FiberContext
      *cptr( DWORD ptr , @.ExtendedRegisters(512-8) ) = &hF1BEDA7A
      *cptr( DWORD ptr , @.ExtendedRegisters(512-4) ) = NULL 'pointer to FLS
    end with
    
    _AddFiberToArray( pFiber )    
    return pFiber
  end function
  
  UndefAllParams()
  #define P1 dwStackSize    as _In_     SIZE_T
  #define P2 lpStartAddress as _In_     LPFIBER_START_ROUTINE
  #define P3 lpParameter    as _In_opt_ LPVOID
  function fnCreateFiber alias "CreateFiber"(P1, P2, P3) as LPVOID export
    return fnCreateFiberEx( 0 , 0 , FIBER_FLAG_FLOAT_SWITCH , lpStartAddress , lpParameter )
  end function

  UndefAllParams()
  #define P1 lpParameter as _In_opt_ LPVOID
  function fnConvertThreadToFiber alias "ConvertThreadToFiber"(P1) as LPVOID export
    dim as FIBER ptr pFiber = any
    pFiber = ConvertThreadToFiber( lpParameter )
    if pFiber = 0 then return 0
    with pFiber->FiberContext
      *cptr( DWORD ptr , @.ExtendedRegisters(512-8) ) = &hF1BEDA7A
      *cptr( DWORD ptr , @.ExtendedRegisters(512-4) ) = NULL 'pointer to FLS
    end with
    _AddFiberToArray( pFiber )
    return pFiber
  end function
  
  UndefAllParams()
  #define P1 lpParameter as _In_opt_ LPVOID
  #define P2 dwFlags     as _In_     DWORD
  function fnConvertThreadToFiberEx alias "ConvertThreadToFiberEx"(P1,P2) as LPVOID export
    'dwFlags parameter only allows to create a faster fiber that doesnt save FPU
    'so, we don't have that... then we just create a normal one :)
    return fnConvertThreadToFiber( lpParameter )
  end function
  
  UndefAllParams()
  function fnConvertFiberToThread alias "ConvertFiberToThread"() as BOOL export
    var pFiber = fnIsThreadAFiber()        
    if pFiber=0 then
      VERBOSE DEBUG_MsgTrace("Conversion from fiber to thread... but this is not a fiber...")
    else
      _RemoveFiberFromArray( pFiber )
    end if    
    return ConvertFiberToThread()
  end function
end extern