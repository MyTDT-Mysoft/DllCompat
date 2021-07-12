#define fbc -dll -Wl "kernel3x.dll.def" -i ..\..\ -x ..\..\..\bin\dll\kernel3x.dll 
'"c:\windows\kernel3x.dll"'
'G:\downloads\app\kernel3x.dll

#define DebugDisableExceptions

#include "windows.bi"
#include "win\winnls.bi"
#include "shared\detour.bas"
#include "includes\win\wintern.bi"
#include "includes\win\fix_winnt.bi"
#include "includes\win\fix_winbase.bi"
#include "shared\helper.bas"
#include "win\psapi.bi"
#include "win\shlwapi.bi"


#include "fiber.bas"
#include "dynload.bas"
#include "locale.bas"
#include "console.bas"
#include "file.bas"

dim shared as any ptr pInitMutex
dim shared as HANDLE hKernel
dim shared as LARGE_INTEGER ulFreq

pInitMutex = CreateMutexA(NULL,FALSE,NULL)
hKernel = GetModuleHandleA("kernel32.dll")

dim shared pfWow64RevertWow64FsRedirection as function( OldValue as PVOID ptr ) as bool
pfWow64RevertWow64FsRedirection = cast(any ptr,GetProcAddress(hKernel,"Wow64RevertWow64FsRedirection"))
  
dim shared pfWow64DisableWow64FsRedirection as function( OldValue as PVOID ptr ) as bool
pfWow64DisableWow64FsRedirection = cast(any ptr,GetProcAddress(hKernel,"Wow64DisableWow64FsRedirection"))
  

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

extern "windows-ms"
  'just to force it to load TLS dependencies library
  sub StaticDependencyListTLS_Dummy() 
    var Dummy = @StaticDependencyListTLS
  end sub
  
  UndefAllParams()
  #define P1 dwDesiredAccess as DWORD
  #define P2 bInheritHandle  as BOOL
  #define P3 dwProcessId     as DWORD
  function fnOpenProcess alias "OpenProcess"(P1, P2, P3) as HANDLE
    'PROCESS_QUERY_LIMITED_INFORMATION flag is invalid in XP
    'so we turn it to closest valid flag
    if (dwDesiredAccess and PROCESS_QUERY_LIMITED_INFORMATION) then
      dwDesiredAccess = (dwDesiredAccess and (not PROCESS_QUERY_LIMITED_INFORMATION)) or PROCESS_QUERY_INFORMATION
    end if
    return OpenProcess(dwDesiredAccess, bInheritHandle, dwProcessId)
  end function
  
  UndefAllParams()
  #define P1 InitOnce  as _Inout_     PINIT_ONCE
  #define P2 InitFn    as _In_        PINIT_ONCE_FN
  #define P3 Parameter as _Inout_opt_ PVOID
  #define P4 Context   as _Out_opt_   LPVOID ptr
  function InitOnceExecuteOnce(InitOnce as any ptr ptr, InitFn as any ptr, Parameter as any ptr, Context as any ptr) as bool export    
    if InitOnce=0 or InitFn=0 then 
      DEBUG_MsgTrace("Bad Parameters")
      return false
    end if
    if Context then
      DEBUG_MsgTrace("Using context???")
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
      DEBUG_MsgTrace("Initialization failed")
      return False
    end if
  end function
  
  UndefAllParams()
  #define P1 ConditionVariable as _Out_ PCONDITION_VARIABLE
  sub InitializeConditionVariable(ConditionVariable as any ptr ptr) export
    if ConditionVariable=NULL then 
      DEBUG_MsgTrace("Bad parameters")
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
      DEBUG_MsgTrace("Bad parameters")
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
      DEBUG_MsgTrace("Bad parameters")
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
      DEBUG_MsgTrace("Bad parameters")
      exit sub
    end if    
    SetEvent(*ConditionVariable)
  end sub
  
  UndefAllParams()
  #define P1 lpCriticalSection as _Out_ LPCRITICAL_SECTION
  #define P2 dwSpinCount       as _In_  DWORD
  #define P3 Flags             as _In_  DWORD
  function InitializeCriticalSectionEx(P1, P2, P3) as BOOL export
    for i as int = 0 to 4096
    if InitializeCriticalSectionAndSpinCount(lpCriticalSection, dwSpinCount) then return TRUE
    next
    return FALSE    
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
  function fnGetLogicalProcessorInformation alias "GetLogicalProcessorInformation" (pBuffer as any ptr,ReturnLength as DWORD ptr) as BOOL export
    SetLastError(1): return FALSE
  end function
  #endif
  
  UndefAllParams()
  #define P1 lpVersionInfo    as _In_ LPOSVERSIONINFOEXW
  #define P2 dwTypeMask       as _In_ DWORD
  #define P3 dwlConditionMask as _In_ DWORDLONG
  function fnVerifyVersionInfoW alias "VerifyVersionInfoW"(P1, P2, P3) as BOOL export
    return TRUE 'hehe
  end function
  
  UndefAllParams()
  #define P1 lpVersionInfo    as _In_ LPOSVERSIONINFOEXW
  #define P2 dwTypeMask       as _In_ DWORD
  #define P3 dwlConditionMask as _In_ DWORDLONG
  function fnVerifyVersionInfoA alias "VerifyVersionInfoA"(P1, P2, P3) as BOOL export
    return TRUE 'hehe
  end function  

  UndefAllParams()
  #define P1 Thread as _In_ HANDLE
  function fnGetThreadId alias "GetThreadId"(P1) as DWORD export
            
    'trying to validate the thread handle and give a useful return code
    dim as DWORD dwResu = any
    
    if GetExitCodeThread(Thread,@dwResu)=0 then 
      var iErr = GetLastError()
      DEBUG_MsgTrace("GetThreadId ERROR = " & hex(iErr))
      return 0    
    end if
    
    'get thread ClientID from nt function, (succeeded with GetCurrentThreadID)
    dim as THREAD_BASIC_INFO tInfo = any
    dim as NTSTATUS ntResu = any
    
    ntResu = NtQueryInformationThread( GetCurrentThread , _
      ThreadBasicInformation , @tInfo , sizeof(tInfo), null )
    
    if ntResu then 
      DEBUG_MsgTrace("GetThreadId NTSTATUS = " & hex(ntResu))
      SetLastError(RtlNtStatusToDosError(ntResu))
      return 0 'NTSTATUS with error
    else
      DEBUG_MsgTrace("GetThreadId TID = " & tInfo.ClientId.UniqueThread)
    end if
    return cast(DWORD, tInfo.ClientId.UniqueThread)
  end function
  
  UndefAllParams()
  #define P1 Thread as _In_ HANDLE
  function fnGetProcessIdOfThread alias "GetProcessIdOfThread"(P1) as DWORD export
    dim as THREAD_BASIC_INFO ThreadBasic = any
    dim as NTSTATUS Status

    Status = NtQueryInformationThread(Thread, ThreadBasicInformation, @ThreadBasic, _
      sizeof(THREAD_BASIC_INFO), NULL)
      
    if Status then
      SetLastError(RtlNtStatusToDosError(Status))
      return 0
    end if

    return cast(DWORD, ThreadBasic.ClientId.UniqueProcess)
  end function
  
  UndefAllParams()
  function GetTickCount64() as ULONGLONG export
    dim as LARGE_INTEGER ulCounter = any
    
    if ulFreq.QuadPart then
      QueryPerformanceCounter(@ulCounter)
      return ulCounter.QuadPart \ (ulFreq.QuadPart \ 1000)
    else 'MS says this does not happen in XP and above
      return GetTickCount()
    end if
  end function
  
  UndefAllParams()
  function fnGetCurrentProcessorNumber alias "GetCurrentProcessorNumber"() as DWORD export
    return 0
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
  #define P1 StackSizeInBytes as _Inout_ PULONG
  #undef SetThreadStackGuarantee
  function SetThreadStackGuarantee(P1) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 hFile        as _In_     HANDLE
  #define P2 lpOverlapped as _In_opt_ LPOVERLAPPED
  function CancelIoEx(P1, P2) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hThread      as _In_     HANDLE
  function CancelSynchronousIo(P1) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function  

  UndefAllParams()  
  #define P1 hProcess  _In_    as HANDLE
  #define P2 dwFlags   _In_    as DWORD
  #define P3 lpExeName _Out_   as LPSTR
  #define P4 lpdwSize  _Inout_ as PDWORD 
  function QueryFullProcessImageNameA(P1,P2,P3,P4) as WINBOOL export
    dim as DWORD iResu = 0
    
    if lpdwSize=0 then 
      SetLastError(ERROR_INVALID_PARAMETER)
      return 0
    end if
    
    if (dwFlags and PROCESS_NAME_NATIVE) then
      iResu = GetProcessImageFileNameA(hProcess,lpExeName,*lpdwSize)
    else    
      iResu = GetModuleFilenameExA(hProcess,null,lpExeName,*lpdwSize)
    end if
    
    if iResu then 
      DEBUG_MsgTrace("hProcess=%X dwFlags=%X lpExeName=%08X lpDwSize=%08X(%i) Resu=(%i):'%s'", hProcess , dwFlags , lpExeName , lpdwSize , iResu , lpExeName )
      *lpdwSize = iResu: return 1
    else
      return 0
    end if

  end function
  
  UndefAllParams()  
  #define P1 hProcess  _In_    as HANDLE
  #define P2 dwFlags   _In_    as DWORD
  #define P3 lpExeName _Out_   as LPWSTR
  #define P4 lpdwSize  _Inout_ as PDWORD 
  function QueryFullProcessImageNameW(P1,P2,P3,P4) as WINBOOL export
    dim as DWORD iResu = 0
    
    if lpdwSize=0 then 
      SetLastError(ERROR_INVALID_PARAMETER)
      return 0
    end if
    
    if (dwFlags and PROCESS_NAME_NATIVE) then
      iResu = GetProcessImageFileNameW(hProcess,lpExeName,*lpdwSize)
    else    
      iResu = GetModuleFilenameExW(hProcess,null,lpExeName,*lpdwSize)
    end if
    
    if iResu then 
      DEBUG_MsgTrace("hProcess=%X dwFlags=%X lpExeName=%08X lpDwSize=%08X(%i) Resu=(%i):'%S'", hProcess , dwFlags , lpExeName , lpdwSize , iResu , lpExeName )
      *lpdwSize = iResu: return 1
    else
      return 0
    end if

  end function
  
  UndefAllParams()
  #define P1 lpEventAttributes as LPSECURITY_ATTRIBUTES
  #define P2 lpName            as LPCSTR
  #define P3 dwFlags           as DWORD
  #define P4 dwDesiredAccess   as DWORD
  function CreateEventExA(P1, P2, P3, P4) as HANDLE export
    dim isManualReset as BOOL = iif(dwFlags and CREATE_EVENT_MANUAL_RESET, TRUE, FALSE)
    dim isSignaled as BOOL    = iif(dwFlags and CREATE_EVENT_INITIAL_SET, TRUE, FALSE)
    
    return CreateEventA(lpEventAttributes, isManualReset, isSignaled, lpName)
  end function
  
  UndefAllParams()
  #define P1 lpEventAttributes as LPSECURITY_ATTRIBUTES
  #define P2 lpName            as LPCWSTR
  #define P3 dwFlags           as DWORD
  #define P4 dwDesiredAccess   as DWORD
  function CreateEventExW(P1, P2, P3, P4) as HANDLE export
    dim isManualReset as BOOL = iif(dwFlags and CREATE_EVENT_MANUAL_RESET, TRUE, FALSE)
    dim isSignaled as BOOL    = iif(dwFlags and CREATE_EVENT_INITIAL_SET, TRUE, FALSE)
    
    return CreateEventW(lpEventAttributes, isManualReset, isSignaled, lpName)
  end function
  
  UndefAllParams()
  #define P1 lpMutexAttributes as LPSECURITY_ATTRIBUTES
  #define P2 lpName            as LPCSTR
  #define P3 dwFlags           as DWORD
  #define P4 dwDesiredAccess   as DWORD
  function CreateMutexExA(P1, P2, P3, P4) as HANDLE export
    dim isInitialOwner as BOOL = iif(dwFlags and CREATE_MUTEX_INITIAL_OWNER, TRUE, FALSE)
    
    return CreateMutexA(lpMutexAttributes, isInitialOwner, lpName)
  end function
  
  UndefAllParams()
  #define P1 lpMutexAttributes as LPSECURITY_ATTRIBUTES
  #define P2 lpName            as LPCWSTR
  #define P3 dwFlags           as DWORD
  #define P4 dwDesiredAccess   as DWORD
  function CreateMutexExW(P1, P2, P3, P4) as HANDLE export
    dim isInitialOwner as BOOL = iif(dwFlags and CREATE_MUTEX_INITIAL_OWNER, TRUE, FALSE)
    
    return CreateMutexW(lpMutexAttributes, isInitialOwner, lpName)
  end function
  
  UndefAllParams()
  #define P1 lpSemaphoreAttributes as LPSECURITY_ATTRIBUTES
  #define P2 lInitialCount         as LONG
  #define P3 lMaximumCount         as LONG
  #define P4 lpName                as LPCSTR
  #define P5 dwFlags               as DWORD
  #define P6 dwDesiredAccess       as DWORD
  function CreateSemaphoreExA(P1, P2, P3, P4, P5, P6) as HANDLE export
    return CreateSemaphoreA(lpSemaphoreAttributes, lInitialCount, lMaximumCount, lpName)
  end function
  
  UndefAllParams()
  #define P1 lpSemaphoreAttributes as LPSECURITY_ATTRIBUTES
  #define P2 lInitialCount         as LONG
  #define P3 lMaximumCount         as LONG
  #define P4 lpName                as LPCWSTR
  #define P5 dwFlags               as DWORD
  #define P6 dwDesiredAccess       as DWORD
  function CreateSemaphoreExW(P1, P2, P3, P4, P5, P6) as HANDLE export
    return CreateSemaphoreW(lpSemaphoreAttributes, lInitialCount, lMaximumCount, lpName)
  end function
  
  UndefAllParams()
  #define P1 pExceptionRecord   as _In_opt_ LPSECURITY_ATTRIBUTES
  #define P2 pContextRecord     as _In_opt_ PCONTEXT
  #define P3 dwFlags            as _In_     DWORD
  sub fnRaiseFailFastException alias "RaiseFailFastException"(P1,P2,P3) export
    ExitProcess(1)
  end sub
  
  UndefAllParams()
  function GetErrorMode() as UINT export
    dim mode as UINT = SetErrorMode(0)
    'WARN: possible threading issues
    SetErrorMode(mode)
    
    return mode
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
  
  function fnWow64RevertWow64FsRedirection alias "Wow64RevertWow64FsRedirection" ( OldValue as PVOID ptr  ) as BOOL export
    return iif(pfWow64RevertWow64FsRedirection,pfWow64RevertWow64FsRedirection(OldValue),true)
  end function
  
  function fnWow64DisableWow64FsRedirection alias "Wow64DisableWow64FsRedirection" ( OldValue as PVOID ptr ) as BOOL export
    return iif(pfWow64DisableWow64FsRedirection,pfWow64DisableWow64FsRedirection(OldValue),true)
  end function  
    
end extern

#define ENABLE_THREADCALLS
#define CUSTOM_MAIN
#include "shared\defaultmain.bas"

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as BOOL
    select case uReason
      case DLL_PROCESS_ATTACH
        if QueryPerformanceFrequency(@ulFreq) = 0 then
          ulFreq.QuadPart = 0
        end if
      case DLL_PROCESS_DETACH
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select
    return DLLMAIN_DEFAULT(handle, uReason, Reserved)
  end function
end extern

'---------------- APP SPECIFIC INCLUDES ---------------------
'should we add a define check? 

'#include "..\..\AppHaxes\keycastow_kernel32.bas"
'#include "..\..\AppHaxes\mischief_kernel32.bas"
  

