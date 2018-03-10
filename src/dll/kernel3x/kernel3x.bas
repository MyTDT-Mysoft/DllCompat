#define fbc -dll -Wl "kernel3x.dll.def" -i ..\..\ -x ..\..\..\bin\dll\kernel3x.dll 
'-x G:\downloads\app\kernel3x.dll

#define DebugFailedCalls
#define DebugDisableExceptions

#define DebugBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONERROR)
#define NotifyBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONWARNING)
#include "windows.bi"
#include "win\winnls.bi"
#include "shared\detour.bas"
#include "includes\win\wintern.bi"
#include "includes\win\winnt_fix.bi"
#include "includes\win\winbase_fix.bi"
#include "shared\helper.bas"

#include "dynload.bas"

dim shared as any ptr pInitMutex
pInitMutex = CreateMutex(NULL,FALSE,NULL)

'includes TLS static dependencies optiona library
#inclib "TlsDeps"
extern StaticDependencyListTLS alias "StaticDependencyListTLS" as any ptr

extern "windows"
  #ifndef GetLocaleInfoW
  declare function GetLocaleInfoW (byval as LCID, byval as LCTYPE, byval as LPWSTR, byval as integer) as integer
  #endif
end extern

#ifndef SYSTEM_LOGICAL_PROCESSOR_INFORMATION
type slpi_ProcessorCore        
    Flags as ubyte
  end type
  type slpi_NumaNode
    NodeNumber as integer
  end type
  type SYSTEM_LOGICAL_PROCESSOR_INFORMATION
    as ULONG_PTR ProcessorMask
    as integer Relationship
    union 
      ProcessorCore as slpi_ProcessorCore
      NumaNode      as slpi_NumaNode        
    end union
    as integer Cache
    as ulongint Reserved(2-1)
  end type
#endif

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
    DEBUG_MsgTrace("Fiber %08X got created... but global fiber state allocation failed :(",pFiber)
    exit sub
  end if
  
  with *pGlobalFiberData
    if .iFiberAlloc=0 then
      .iFiberAlloc += 16
      .pFiberArray = allocate(sizeof(PVOID)*.iFiberAlloc)
      if .pFiberArray=0 then
        DEBUG_MsgTrace("Fiber %08X got created... but allocation for fiber array failed :(",pFiber)
      end if
    elseif (.iFiberCount+1) >= .iFiberAlloc then          
      .iFiberAlloc += 16
      .pFiberArray = reallocate(.pFiberArray,sizeof(PVOID)*.iFiberAlloc)
      if .pFiberArray=0 then
        DEBUG_MsgTrace("Fiber %08X got created... but reallocation for fiber array failed :(",pFiber)
      end if      
    end if      
    .pFiberArray[.iFiberCount] = pFiber
    .iFiberCount = .iFiberCount+1
  end with
end sub
sub _RemoveFiberFromArray( pFiber as FIBER ptr )
  if pGlobalFiberData = NULL then 
    DEBUG_MsgTrace("Fiber %08X is to be deleted... but global fiber is not allocated @_@",pFiber)
    exit sub
  end if
  
  'looking for this fiber on the array (slooow)
  with *pGlobalFiberData
    for I as integer = 0 to .iFiberCount-1
      if .pFiberArray[I] = pFiber then
        'Fiber found... so callback must be called 
        DEBUG_MsgTrace("TODO: callback on all indexes for the fiber %08X...",pFiber)
        if I <> .iFiberCount-1 then
          swap .pFiberArray[I], .pFiberArray[.iFiberCount-1]
        end if
        .iFiberCount -= 1
        exit sub
      end if
    next I
  end with
  DEBUG_MsgTrace("Fiber is to be deleted... but not found on the fiber array @_@",pFiber)
end sub

extern "windows-ms"
  'just to force it to load TLS dependencies library
  sub StaticDependencyListTLS_Dummy() 
    var Dummy = @StaticDependencyListTLS
  end sub
  
  UndefAllParams()
  #define P1 InitOnce  as _Inout_     PINIT_ONCE
  #define P2 InitFn    as _In_        PINIT_ONCE_FN
  #define P3 Parameter as _Inout_opt_ PVOID
  #define P4 Context   as _Out_opt_   LPVOID ptr
  function InitOnceExecuteOnce(InitOnce as any ptr ptr, InitFn as any ptr, Parameter as any ptr, Context as any ptr) as bool export    
    if InitOnce=0 or InitFn=0 then 
      messagebox(null,"Bad Parameters","InitOnceExecuteOnce",MB_SYSTEMMODAL)
      return false
    end if
    if Context then
      messagebox(null,"Using context???","InitOnceExecuteOnce",MB_SYSTEMMODAL)
    end if
    WaitForSingleObject(pInitMutex,INFINITE)
    if InitOnce[0]=0 then
      InitOnce[0] = CreateEvent(NULL,TRUE,FALSE,NULL)    
      ReleaseMutex(pInitMutex)
    else
      var hEvent = InitOnce[0]
      ReleaseMutex(pInitMutex)      
      WaitForSingleObject(hEvent,INFINITE)      
      WaitForSingleObject(pInitMutex,INFINITE)
      if InitOnce[0] then 
        ReleaseMutex(pInitMutex)
        SetLastError(0):return true
      end if
      InitOnce[0]=0:CloseHandle(hEvent)            
      ReleaseMutex(pInitMutex)
      SetLastERror(ERROR_INVALID_PARAMETER)
      return false
    end if
    
    dim pCall as function (as any ptr,as any ptr,as any ptr) as bool = InitFn
    if pCall(InitOnce, Parameter, Context) then      
      SetEvent(InitOnce[0]):return True
    else      
      WaitForSingleObject(pInitMutex,INFINITE)
      var hMutex = InitOnce[0]
      InitOnce[0]=0:SetEvent(hMutex)      
      ReleaseMutex(pInitMutex)
      messagebox(null,"Initialization failed","InitOnceExecuteOnce",MB_SYSTEMMODAL)
      return False
    end if
  end function
  
  UndefAllParams()
  #define P1 ConditionVariable as _Out_ PCONDITION_VARIABLE
  sub InitializeConditionVariable(ConditionVariable as any ptr ptr) export
    if ConditionVariable=0 then 
      messagebox(null,"InitializeConditionVariable","InitializeConditionVariable",MB_SYSTEMMODAL)
      exit sub
    end if
    *ConditionVariable = CreateEvent(NULL,FALSE,FALSE,NULL)
  end sub
  
  UndefAllParams()
  #define P1 ConditionVariable as _Inout_ PCONDITION_VARIABLE 
  #define P2 CriticalSection   as _Inout_ PCRITICAL_SECTION
  #define P3 dwMilliseconds    as _In_    DWORD
  function SleepConditionVariableCS(ConditionVariable as any ptr ptr, CriticalSection as any ptr, dwMilliseconds as dword) as BOOL export        
    if ConditionVariable=0 orelse *ConditionVariable=0 orelse CriticalSection=0 then 
      messagebox(null,"SleepConditionVariableCS","SleepConditionVariableCS",MB_SYSTEMMODAL)
      return false
    end if        
    if dwMilliseconds then LeaveCriticalSection(CriticalSection)    
    var iResu = WaitForSingleObject(*ConditionVariable,dwMilliseconds)
    var x = GetLastError()
    if dwMilliseconds then EnterCriticalSection(CriticalSection)
    SetLastError(x)
    return iif(iResu,false,true)
  end function
  
  UndefAllParams()
  #define P1 ConditionVariable as _Inout_ PCONDITION_VARIABLE
  sub WakeAllConditionVariable(ConditionVariable as any ptr ptr) export
    if ConditionVariable=0 orelse *ConditionVariable=0 then 
      messagebox(null,"WakeAllConditionVariable","WakeAllConditionVariable",MB_SYSTEMMODAL)
      exit sub
    end if
    'PulseEvent(*ConditionVariable)    
    for CNT as integer = 0 to 999
      if SetEvent(*ConditionVariable) = 0 then exit for
      if WaitForSingleObject(*ConditionVariable,0) <> WAIT_TIMEOUT then exit for      
    next CNT    
  end sub
  
  UndefAllParams()
  #define P1 ConditionVariable as _Inout_ PCONDITION_VARIABLE
  sub WakeConditionVariable(ConditionVariable as any ptr ptr) export              
    if ConditionVariable=0 orelse *ConditionVariable=0 then 
      messagebox(null,"WakeConditionVariable","WakeConditionVariable",MB_SYSTEMMODAL)
      exit sub
    end if    
    SetEvent(*ConditionVariable)
  end sub
  
  UndefAllParams()
  #define P1 Destination as _Inout_ LONGLONG ptr
  #define P2 Exchange    as _In_    LONGLONG
  #define P3 Comparand   as _In_    LONGLONG
  #undef InterlockedCompareExchange64
  function InterlockedCompareExchange64 naked cdecl(P1, P2, P3) as LONGLONG export
    #define Destination_ esp+12
    #define Exchange_ esp+16
    #define Comparand_ esp+24
    asm
      push ebx
      push ebp
      mov ebp,[Destination_]
      mov ebx,[Exchange_+0]
      mov ecx,[Exchange_+4]
      mov eax,[Comparand_+0]
      mov edx,[Comparand_+4]
      lock cmpxchg8b [ebp]
      pop ebp
      pop ebx
      ret
    end asm        
  end function
  
  UndefAllParams()
  #define P1 lpCriticalSection as _Out_ LPCRITICAL_SECTION
  #define P2 dwSpinCount       as _In_  DWORD
  #define P3 Flags             as _In_  DWORD
  function InitializeCriticalSectionEx(P1, P2, P3) as BOOL export
    return InitializeCriticalSectionAndSpinCount(lpCriticalSection,dwSpinCount)    
  end function
  
  UndefAllParams()
  #define P1 lpLocaleName  as _Out_ LPWSTR
  #define P2 cchLocaleName as _In_  int
  function GetSystemDefaultLocaleName(P1, P2) as int export
    if lpLocaleName=null or cchLocaleName <= 1 then
      SetLastError(ERROR_INSUFFICIENT_BUFFER): return 0
    end if
    dim as wstring*85 wLocale = any
    var iPos = GetLocaleInfoW(LOCALE_SYSTEM_DEFAULT, LOCALE_SISO639LANGNAME,@wLocale, 32)
    if iPos = 0 or iPos > cchLocaleName then
      SetLastError(ERROR_INSUFFICIENT_BUFFER): return 0
    end if
    wLocale[iPos-1] = asc("-")
    var iPos2 = GetLocaleInfoW(LOCALE_SYSTEM_DEFAULT,LOCALE_SISO3166CTRYNAME,@wLocale+iPos,16)
    iPos += iPos2
    if iPos2 = 0 or iPos > cchLocaleName then
      SetLastError(ERROR_INSUFFICIENT_BUFFER): return 0
    end if
    return iPos
  end function

  UndefAllParams()
  #define P1 lpVersionInfo as _Inout_ LPOSVERSIONINFOEXW 'LPOSVERSIONINFOW
  function fnGetVersionExW alias "GetVersionExW"(P1) as BOOL export
    if lpVersionInfo = 0 then SetLastError(ERROR_INVALID_PARAMETER): return false
    if lpVersionInfo->dwOSVersionInfoSize < offsetof(_OSVERSIONINFOEXW,wServicePackMajor) then
      SetLastError(ERROR_INVALID_PARAMETER): return false
    end if
    lpVersionInfo->dwMajorVersion = 6: lpVersionInfo->dwMinorVersion = 1 '6.1 (Vista)
    lpVersionInfo->dwBuildNumber = 9999: lpVersionInfo->dwPlatformId = VER_PLATFORM_WIN32_NT
    lpVersionInfo->szCSDVersion = wstr("Service Pack 2")
    if lpVersionInfo->dwOSVersionInfoSize >= sizeof(_OSVERSIONINFOEXW) then
      lpVersionInfo->wServicePackMajor=2: lpVersionInfo->wServicePackMinor=0
      lpVersionInfo->wSuiteMask = -1: lpVersionInfo->wProductType = VER_NT_WORKSTATION
    end if
    return true
  end function
  
  UndefAllParams()
  #define P1 lpVersionInfo as _Inout_ LPOSVERSIONINFOEXA 'LPOSVERSIONINFOA
  function fnGetVersionExA alias "GetVersionExA"(P1) as BOOL export
    if lpVersionInfo = 0 then SetLastError(ERROR_INVALID_PARAMETER): return false
    if lpVersionInfo->dwOSVersionInfoSize < offsetof(_OSVERSIONINFOEXA,wServicePackMajor) then
      SetLastError(ERROR_INVALID_PARAMETER): return false
    end if
    lpVersionInfo->dwMajorVersion = 6: lpVersionInfo->dwMinorVersion = 1 '6.1 (Vista)
    lpVersionInfo->dwBuildNumber = 9999: lpVersionInfo->dwPlatformId = VER_PLATFORM_WIN32_NT
    lpVersionInfo->szCSDVersion = "Service Pack 2"
    if lpVersionInfo->dwOSVersionInfoSize >= sizeof(_OSVERSIONINFOEXW) then
      lpVersionInfo->wServicePackMajor=2: lpVersionInfo->wServicePackMinor=0
      lpVersionInfo->wSuiteMask = -1: lpVersionInfo->wProductType = VER_NT_WORKSTATION
    end if
    return true
  end function
  
  UndefAllParams()
  #define P1 pBuffer       as _Out_   SYSTEM_LOGICAL_PROCESSOR_INFORMATION ptr
  #define P2 pReturnLength as _Inout_ DWORD ptr
  #undef GetLogicalProcessorInformation
  function GetLogicalProcessorInformation alias "GetLogicalProcessorInformation"(P1,P2) as integer export
    if pBuffer=null then 
      if pReturnLength then
        *pReturnLength = sizeof(SYSTEM_LOGICAL_PROCESSOR_INFORMATION)
        SetLastError(ERROR_INSUFFICIENT_BUFFER)
      else
        SetLastError(1)
      end if
      return 0
    else
      dim as dword dwProc,dwSys
      GetProcessAffinityMask(GetCurrentProcess(),@dwProc,@dwSys)
      pBuffer->ProcessorMask  = dwSys
      pBuffer->RelationShip = 0
      pBuffer->ProcessorCore.Flags = 0
      return 1
    end if
  end function  
  'SYSTEM_LOGICAL_PROCESSOR_INFORMATION
  #if 0
  function _GetLogicalProcessorInformation alias "GetLogicalProcessorInformation" (pBuffer as any ptr,ReturnLength as DWORD ptr) as bool export
    SetLastError(1): return 0
  end function
  #endif
  
  UndefAllParams()
  #define P1 lpVersionInfo    as _In_ LPOSVERSIONINFOEXW
  #define P2 dwTypeMask       as _In_ DWORD
  #define P3 dwlConditionMask as _In_ DWORDLONG
  function fnVerifyVersionInfoW alias "VerifyVersionInfoW"(P1, P2, P3) as BOOL export
    return true 'hehe
  end function
  
  UndefAllParams()
  #define P1 lpVersionInfo    as _In_ LPOSVERSIONINFOEXW
  #define P2 dwTypeMask       as _In_ DWORD
  #define P3 dwlConditionMask as _In_ DWORDLONG
  function fnVerifyVersionInfoA alias "VerifyVersionInfoA"(P1, P2, P3) as BOOL export
    return true 'hehe
  end function  

  UndefAllParams()
  #define P1 Thread as _In_ HANDLE
  function fnGetThreadId alias "GetThreadId"(P1) as DWORD export
            
    'trying to validate the thread handle and give a useful return code
    dim as DWORD dwResu = any
    if GetExitCodeThread(Thread,@dwResu)=0 then 
      var iErr = GetLastError()
      messagebox(null,"GetThreadId ERROR = " & hex$(iErr),null,MB_SYSTEMMODAL or MB_ICONERROR)
      return 0    
    end if
    
    'get thread ClientID from nt function, (succeeded with GetCurrentThreadID)
    dim as THREAD_BASIC_INFO tInfo = any
    dim as NTSTATUS ntResu = any
    ntResu = NtQueryInformationThread( GetCurrentThread , _
    ThreadBasicInformation , @tInfo , sizeof(tInfo), null )
    
    if ntResu then 
      messagebox(null,"GetThreadId NTSTATUS = " & hex$(ntResu),null,MB_SYSTEMMODAL or MB_ICONERROR)
      return 0 'NTSTATUS with error
    else
      messagebox(null,"GetThreadId TID = " & tInfo.ClientId.UniqueThread,null,MB_SYSTEMMODAL or MB_ICONERROR)
    end if
    return cast(DWORD, tInfo.ClientId.UniqueThread)
  end function
  
  UndefAllParams()
  #define P1 hFile        as _In_  HANDLE
  #define P2 lpszFilePath as _Out_ LPWSTR
  #define P3 cchFilePath  as _In_  DWORD
  #define P4 dwFlags      as _In_  DWORD
  function GetFinalPathNameByHandleW(P1,P2,P3,P4) as DWORD export
    DebugBox("Yay!")
    'cchFilePath is in TCHARS (i.e. wchars for this one)... and doesnt include the space for NULL
    var iFilePathSz = (cchFilePath+1)*sizeof(wstring*1)
    
    'basic flags check
    const cAllVolumeOptions =  VOLUME_NAME_GUID or VOLUME_NAME_NT or VOLUME_NAME_NONE
    var iBadFlags = (dwFlags and (not (FILE_NAME_OPENED or cAllVolumeOptions)))
    if hFile=null orelse lpszFilePath=null orelse iBadFlags then
      #ifdef DebugFailedCalls
        if iBadFlags then
          DebugBox("Bad flags were used... 0x" & iBadFlags)
        elseif lpszFilePath=null then
          DebugBox("null lpszFilePath")
        elseif hFile=null then
          DebugBox("null hFile")
        end if
      #endif
      SetLastError( ERROR_INVALID_PARAMETER )
      return 0
    end if
    
    'basic handle check
    var iType = GetFileType( hFile )
    if iType = 0 then 
      #ifdef DebugFailedCalls
        var iTempErr = GetLastError()
        DebugBox("bad file type? (not a file?)")
        SetLastError(iTempErr)
      #endif
      return 0 
    end if
    
    'this may not be implemented correctly... so warning when used
    if (dwFlags and FILE_NAME_OPENED) then
      NotifyBox("flag FILE_NAME_OPENED used...")
    end if
    
    'expecting a DOS volume? [\\?\Drive:\Path\File.Ext]
    if (dwFlags and cAllVolumeOptions)=0 then 'VOLUME_NAME_DOS
      '// Get the file size.
      dim as DWORD dwFileSizeHi = 0
      dim as DWORD dwFileSizeLo = GetFileSize(hFile, @dwFileSizeHi)
      if dwFileSizeLo = 0 andalso dwFileSizeHi = 0 then
        #ifdef DebugFailedCalls
          DebugBox("Filesize=0 so can't map to get name...")
        #endif
        SetLastError( ERROR_FILE_NOT_FOUND )
        return 0
      end if
      NotifyBox("flag VOLUME_NAME_DOS used...")
    end if
    
    'expecting a GUID volume? [\\?\Volume{GUID}\Path\File.Ext]
    if (dwFlags and VOLUME_NAME_GUID) then
      NotifyBox("flag VOLUME_NAME_GUID used...")
      return 0
    end if
    
    'expecting a NT volume? [\Device\HarddiskVolume?\Path\File.Ext]
    if (dwFlags and VOLUME_NAME_NT) then            
      var iTempSz = cchFilePath + sizeof(OBJECT_NAME_INFORMATION) 
      var pTemp = cptr(POBJECT_NAME_INFORMATION, allocate(iTempSz))      
      
      if pTemp = 0 then
        #ifdef DebugFailedCalls
          DebugBox("out of memory allocating buffer...")
        #endif
        SetLastError( ERROR_NOT_ENOUGH_MEMORY )
        return 0
      end if      
      
      var iResu = NtQueryObject(hFile, ObjectNameInformation, pTemp , iTempSz , @iTempSz )
      if iResu <> STATUS_SUCCESS then
        #ifdef DebugFailedCalls
          DebugBox("NtQueryInformationFile Error 0x" & hex$(iResu))
        #endif
        SetLastError(ERROR_PATH_NOT_FOUND) 'need better error handling?
      end if
      
      NotifyBox("flag VOLUME_NAME_NT used")
      
    end if
    
    'expecting no volume?  [\Path\File.Ext]
    if (dwFlags and VOLUME_NAME_NONE) then
      var iTempSz = ((cchFilePath+1)*sizeof(wstring*1)) + sizeof(FILE_NAME_INFORMATION) 
      var pTemp = cptr(PFILE_NAME_INFORMATION, allocate(iTempSz))      
      dim as IO_STATUS_BLOCK tStatBlock
      
      if pTemp = 0 then
        #ifdef DebugFailedCalls
          DebugBox("out of memory allocating buffer...")
        #endif
        SetLastError( ERROR_NOT_ENOUGH_MEMORY )
        return 0
      end if
      
      var iResu = NtQueryInformationFile( hFile , @tStatBlock ,  pTemp , iTempSz , FileNameInformation )
      if iResu <> STATUS_SUCCESS then
        #ifdef DebugFailedCalls
          DebugBox("NtQueryInformationFile Error 0x" & hex$(iResu))
        #endif
        SetLastError(ERROR_PATH_NOT_FOUND) 'need better error handling?
        return 0
      end if
      
      var iSz = pTemp->FileNameLength       
      if (iSz+sizeof(wstring*1)) > iFilePathSz then        
        memcpy( lpszFilePath , @(pTemp->FileName) , iFilePathSz ) 'copy what fits
        lpszFilePath[cchFilePath] = 0 'set the null char
        #ifdef DebugFailedCalls
          DebugBox("NtQueryInformationFile ERROR_INSUFFICIENT_BUFFER" & hex$(iResu))
        #endif
        SetLastError( ERROR_INSUFFICIENT_BUFFER )
        return iSz
      end if      
      
      memcpy( lpszFilePath , @(pTemp->FileName) , (iSz+sizeof(wstring*1)) )
      lpszFilePath[ iSz\sizeof(wstring*1) ] = 0 'set the last null char
      SetLastError( ERROR_SUCCESS )      
      return iSz\(sizeof(wstring*1))
    end if
  end function
  
  UndefAllParams()
  function GetTickCount64() as ULONGLONG export
    dim as ulongint ulFreq = any, ulCounter = any 
    QueryPerformanceFrequency( cptr(LARGE_INTEGER ptr,@ulFreq ) )
    QueryPerformanceCounter( cptr(LARGE_INTEGER ptr,@ulCounter ) )
    return ulCounter\(ulFreq\1000)
  end function
  
  UndefAllParams()
  #define P1 Node          as _In_  USHORT
  #define P2 ProcessorMask as _Out_ PGROUP_AFFINITY
  function GetNumaNodeProcessorMaskEx(P1, P2) as BOOL export
    DEBUG_MsgNotImpl()
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hThread               as _In_      HANDLE
  #define P2 GroupAffinity         as _In_      const GROUP_AFFINITY ptr
  #define P3 PreviousGroupAffinity as _Out_opt_ PGROUP_AFFINITY
  function SetThreadGroupAffinity(P1, P2, P3) as BOOL export
    DEBUG_MsgNotImpl()
    return FALSE    
  end function
  
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
    DEBUG_MsgTrace("FlsFree(%i)",.dwFlsIndex)
  end function
  
  UndefAllParams()
  #define P1 dwFlsIndex as _In_ DWORD
  function FlsGetValue(P1) as PVOID export
    if pGlobalFiberData = 0 then SetLastError(0): return 0
    if dwFlsIndex > FlsMaxSlot then SetLastError(ERROR_INVALID_PARAMETER): return 0
    
    var pFiber = fnIsThreadAFiber()
    dim as PVOID ptr pSlotArray = 0
    if pFiber=0 then 'IF not in a fiber... then use a temp FLS from TLS
      DEBUG_MsgTrace("Querying index %i but current thread is not a fiber!",dwFlsIndex)
      pSlotArray = TlsGetValue( pGlobalFiberData->iThreadTLS )
      if PSlotArray = 0 then SetLastError(0):return 0
    else
      with pFiber->FiberContext
        if *cptr( DWORD ptr , @.ExtendedRegisters(512-8) ) <> &hF1BEDA7A then
          DEBUG_MsgTrace("Index %i was queried from fiber %08X but magic doesnt match...",dwFlsIndex,pFiber)
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
      DEBUG_MsgTrace("Querying index %i but current thread is not a fiber!",dwFlsIndex)
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
          DEBUG_MsgTrace("Index %i was queried from fiber %08X but magic doesnt match...",dwFlsIndex,pFiber)
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
      DEBUG_MsgTrace("Conversion from fiber to thread... but this is not a fiber...")
    else
      _RemoveFiberFromArray( pFiber )
    end if    
    return ConvertFiberToThread()
  end function
  
  UndefAllParams()
  #define P1 hFile                as _In_ HANDLE
  #define P2 FileInformationClass as _In_ FILE_INFO_BY_HANDLE_CLASS
  #define P3 lpFileInformation    as _In_ LPVOID
  #define P4 dwBufferSize         as _In_ DWORD
  function SetFileInformationByHandle(P1, P2, P3, P4) as BOOL export
    DEBUG_AlertNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 StackSizeInBytes as _Inout_ PULONG
  #undef SetThreadStackGuarantee
  function SetThreadStackGuarantee(P1) as BOOL export
    DEBUG_AlertNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 lpLocaleName         as _In_opt_  LPCWSTR
  #define P2 dwMapFlags           as _In_      DWORD
  #define P3 lpSrcStr             as _In_      LPCWSTR
  #define P4 cchSrc               as _In_      int
  #define P5 lpDestStr            as _Out_opt_ LPWSTR
  #define P6 cchDest              as _In_      int
  #define P7 lpVersionInformation as _In_opt_  LPNLSVERSIONINFO
  #define P8 lpReserved           as _In_opt_  LPVOID
  #define P9 sortHandle           as _In_opt_  LPARAM
  function LCMapStringEx(P1,P2,P3,P4,P5,P6,P7,P8,P9) as int export
    select case lpLocaleName
    case NULL      
      DEBUG_MsgTrace("User Default Locale")
    case else
      DEBUG_MsgTrace("Locale:'%ls'",lpLocaleName)
    end select
    'DEBUG_AlertNotImpl()
    'SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 flags      as _In_      DWORD
  #define P2 numlangs   as _Out_     PULONG
  #define P3 langbuffer as _Out_opt_ PZZWSTR
  #define P4 bufferlen  as _Inout_   PULONG
  function GetUserPreferredUILanguages(P1, P2, P3, P4) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hFile                as _In_  HANDLE
  #define P2 FileInformationClass as _In_  FILE_INFO_BY_HANDLE_CLASS
  #define P3 lpFileInformation    as _Out_ LPVOID
  #define P4 dwBufferSize         as _In_  DWORD
  function GetFileInformationByHandleEx(P1, P2, P3, P4) as BOOL export
    dim status as NTSTATUS
    dim io as IO_STATUS_BLOCK

    #define CASE_NOTIMPL _
    FileStreamInfo, FileCompressionInfo, FileAttributeTagInfo, _
    FileRemoteProtocolInfo, FileFullDirectoryInfo, FileFullDirectoryRestartInfo, _
    FileStorageInfo, FileAlignmentInfo, FileIdExtdDirectoryInfo, _
    FileIdExtdDirectoryRestartInfo
    
    #define CASE_BADPARAM _
    FileRenameInfo, FileDispositionInfo, FileAllocationInfo, _
    FileIoPriorityHintInfo, FileEndOfFileInfo, else
    
    select case as const FileInformationClass
      case CASE_NOTIMPL
        DEBUG_MsgTrace("%p, %u, %p, %u\n", hFile, FileInformationClass, lpFileInformation, dwBufferSize )
        SetLastError(ERROR_CALL_NOT_IMPLEMENTED)
        return FALSE
      case FileBasicInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileBasicInformation)
      case FileStandardInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileStandardInformation)
      case FileNameInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileNameInformation)
      case FileIdInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileIdInformation)
      case FileIdBothDirectoryRestartInfo, FileIdBothDirectoryInfo
        status = NtQueryDirectoryFile(hFile, NULL, NULL, NULL, @io, lpFileInformation, dwBufferSize, FileIdBothDirectoryInformation, FALSE, NULL, (FileInformationClass = FileIdBothDirectoryRestartInfo))
      case else 'CASE_BADPARAM
        SetLastError(ERROR_INVALID_PARAMETER)
        return FALSE
    end select

    if status <> STATUS_SUCCESS then
      SetLastError(RtlNtStatusToDosError(status))
      return FALSE
    end if
    return TRUE
  end function
  
  UndefAllParams()
  #define P1 hFile        as _In_     HANDLE
  #define P2 lpOverlapped as _In_opt_ LPOVERLAPPED
  function CancelIoEx(P1, P2) as BOOL
    DEBUG_AlertNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  #ifdef DebugDisableExceptions
  'experimental... the other exception functions need to be added...
  'but it will help with programs that crashes and are " internally handled to be 'safe' "
  UndefAllParams()
  #define P1 lpTopLevelExceptionFilter as _In_ LPTOP_LEVEL_EXCEPTION_FILTER
  function fnSetUnhandledExceptionFilter alias "SetUnhandledExceptionFilter"(P1) as any ptr export
    return 0
  end function
  #endif
    
end extern

'---------------- APP SPECIFIC INCLUDES ---------------------
'should we add a define check? 

'#include "..\..\AppHaxes\keycastow_kernel32.bas"
'#include "..\..\AppHaxes\mischief_kernel32.bas"
  

