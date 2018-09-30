#define fbc -dll -Wl "kernel3x.dll.def" -i ..\..\ -x ..\..\..\bin\dll\kernel3x.dll 
'"c:\windows\kernel3x.dll"'
'G:\downloads\app\kernel3x.dll

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
#include "win\psapi.bi"
#include "win\shlwapi.bi"


#include "fiber.bas"
#include "dynload.bas"
#include "locale.bas"

dim shared as any ptr pInitMutex
dim shared as handle hKernel

pInitMutex = CreateMutex(NULL,FALSE,NULL)
hKernel = GetModuleHandle("kernel32.dll")

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
  function CancelIoEx(P1, P2) as BOOL export
    DEBUG_AlertNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function  

  UndefAllParams()  
  #define P1 hProcess  _In_    as HANDLE
  #define P2 dwFlags   _In_    as DWORD
  #define P3 lpExeName _Out_   as LPSTR
  #define P4 lpdwSize  _Inout_ as PDWORD 
  function QueryFullProcessImageNameA(P1,P2,P3,P4) as WINBOOL export
    dim as WINBOOL iResu = 0
    
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

'---------------- APP SPECIFIC INCLUDES ---------------------
'should we add a define check? 

'#include "..\..\AppHaxes\keycastow_kernel32.bas"
'#include "..\..\AppHaxes\mischief_kernel32.bas"
  

