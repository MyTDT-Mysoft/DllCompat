#define fbc -dll -Wl "kernel3x.dll.def" -x ..\..\..\bin\dll\kernel3x.dll -i ..\..\

#define DebugFailedCalls

#define DebugBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONERROR)
#define NotifyBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONWARNING)

#include "windows.bi"
#include "win\winnls.bi"
#include "shared\detour.bas"
#include "includes\win\wintern.bi"
#include "shared\helper.bas"

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

#ifndef _OSVERSIONINFOEXA
type _OSVERSIONINFOEXA
	dwOSVersionInfoSize as DWORD
	dwMajorVersion as DWORD
	dwMinorVersion as DWORD
	dwBuildNumber as DWORD
	dwPlatformId as DWORD
	szCSDVersion as zstring * 128
	wServicePackMajor as WORD
	wServicePackMinor as WORD
	wSuiteMask as WORD
	wProductType as UBYTE
	wReserved as UBYTE
end type
#endif

#ifndef _OSVERSIONINFOEXW
type _OSVERSIONINFOEXW
	dwOSVersionInfoSize as DWORD
	dwMajorVersion as DWORD
	dwMinorVersion as DWORD
	dwBuildNumber as DWORD
	dwPlatformId as DWORD
	szCSDVersion as wstring * 128
	wServicePackMajor as WORD
	wServicePackMinor as WORD
	wSuiteMask as WORD
	wProductType as UBYTE
	wReserved as UBYTE
end type
#endif

extern "windows-ms"
  
  'just to force it to load TLS dependencies library
  sub StaticDependencyListTLS_Dummy() 
    var Dummy = @StaticDependencyListTLS
  end sub
  
  function InitOnceExecuteOnce (pInit as any ptr ptr,pFN as any ptr,pParm as any ptr,pContext as any ptr) as bool export    
    if pInit=0 or pFN=0 then 
      messagebox(null,"Bad Parameters","InitOnceExecuteOnce",MB_SYSTEMMODAL)
      return false
    end if
    if pContext then
      messagebox(null,"Using context???","InitOnceExecuteOnce",MB_SYSTEMMODAL)
    end if
    WaitForSingleObject(pInitMutex,INFINITE)
    if pInit[0]=0 then
      pInit[0] = CreateEvent(NULL,TRUE,FALSE,NULL)    
      ReleaseMutex(pInitMutex)
    else
      var hEvent = pInit[0]
      ReleaseMutex(pInitMutex)      
      WaitForSingleObject(hEvent,INFINITE)      
      WaitForSingleObject(pInitMutex,INFINITE)
      if pInit[0] then 
        ReleaseMutex(pInitMutex)
        SetLastError(0):return true
      end if
      pInit[0]=0:CloseHandle(hEvent)            
      ReleaseMutex(pInitMutex)
      SetLastERror(ERROR_INVALID_PARAMETER)
      return false
    end if
    
    dim pCall as function (as any ptr,as any ptr,as any ptr) as bool = pFN
    if pCall(pInit,pParm,pContext) then      
      SetEvent(pInit[0]):return True
    else      
      WaitForSingleObject(pInitMutex,INFINITE)
      var hMutex = pInit[0]
      pInit[0]=0:SetEvent(hMutex)      
      ReleaseMutex(pInitMutex)
      messagebox(null,"Initialization failed","InitOnceExecuteOnce",MB_SYSTEMMODAL)
      return False
    end if
  end function
  sub InitializeConditionVariable(pCondVar as any ptr ptr) export
    if pCondVar=0 then 
      messagebox(null,"InitializeConditionVariable","InitializeConditionVariable",MB_SYSTEMMODAL)
      exit sub
    end if
    *pCondVar = CreateEvent(NULL,FALSE,FALSE,NULL)
  end sub
  function SleepConditionVariableCS(pCondVar as any ptr ptr,pCrit as any ptr,dwMili as dword) as bool export        
    if pCondVar=0 orelse *pCondVar=0 orelse pCrit=0 then 
      messagebox(null,"SleepConditionVariableCS","SleepConditionVariableCS",MB_SYSTEMMODAL)
      return false
    end if        
    if dwMili then LeaveCriticalSection(pCrit)    
    var iResu = WaitForSingleObject(*pCondVar,dwMili)
    var x = GetLastError()
    if dwMili then EnterCriticalSection(pCrit)
    SetLastError(x)
    return iif(iResu,false,true)
  end function
  sub WakeAllConditionVariable(pCondVar as any ptr ptr) export
    if pCondVar=0 orelse *pCondVar=0 then 
      messagebox(null,"WakeAllConditionVariable","WakeAllConditionVariable",MB_SYSTEMMODAL)
      exit sub
    end if
    'PulseEvent(*pCondVar)    
    for CNT as integer = 0 to 999
      if SetEvent(*pCondVar) = 0 then exit for
      if WaitForSingleObject(*pCondVar,0) <> WAIT_TIMEOUT then exit for      
    next CNT    
  end sub
  sub WakeConditionVariable(pCondVar as any ptr ptr) export              
    if pCondVar=0 orelse *pCondVar=0 then 
      messagebox(null,"WakeConditionVariable","WakeConditionVariable",MB_SYSTEMMODAL)
      exit sub
    end if    
    SetEvent(*pCondVar)
  end sub
  
  #undef InterlockedCompareExchange64
  function InterlockedCompareExchange64 naked cdecl (pDestination as longint ptr,Exchange as longint,Comparand as longint) as longlong export
    #define pDestination_ esp+12
    #define Exchange_ esp+16
    #define Comparand_ esp+24
    asm
      push ebx
      push ebp
      mov ebp,[pDestination_]
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
  
  function InitializeCriticalSectionEx(lpCriticalSection as LPCRITICAL_SECTION,dwSpinCount as dword,Flags as dword) as bool export
    return InitializeCriticalSectionAndSpinCount(lpCriticalSection,dwSpinCount)    
  end function
  
  function GetSystemDefaultLocaleName(lpwLocaleName as wstring ptr,cchLocaleName as integer) as integer export
    if lpwLocaleName=null or cchLocaleName <= 1 then
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

  function _GetVersionExW alias "GetVersionExW" (pVerW as _OSVERSIONINFOEXW ptr) as integer export
    if pVerW = 0 then SetLastError(ERROR_INVALID_PARAMETER): return false
    if pVerW->dwOSVersionInfoSize < offsetof(_OSVERSIONINFOEXW,wServicePackMajor) then
      SetLastError(ERROR_INVALID_PARAMETER): return false
    end if
    pVerW->dwMajorVersion = 6: pVerW->dwMinorVersion = 1 '6.1 (Vista)
    pVerW->dwBuildNumber = 9999: pVerW->dwPlatformId = VER_PLATFORM_WIN32_NT
    pVerW->szCSDVersion = wstr("Service Pack 2")
    if pVerW->dwOSVersionInfoSize >= sizeof(_OSVERSIONINFOEXW) then
      pVerW->wServicePackMajor=2: pVerW->wServicePackMinor=0
      pVerW->wSuiteMask = -1: pVerW->wProductType = VER_NT_WORKSTATION
    end if
    return true
  end function
  function _GetVersionExA alias "GetVersionExA" (pVerA as _OSVERSIONINFOEXA ptr) as integer export
    if pVerA = 0 then SetLastError(ERROR_INVALID_PARAMETER): return false
    if pVerA->dwOSVersionInfoSize < offsetof(_OSVERSIONINFOEXA,wServicePackMajor) then
      SetLastError(ERROR_INVALID_PARAMETER): return false
    end if
    pVerA->dwMajorVersion = 6: pVerA->dwMinorVersion = 1 '6.1 (Vista)
    pVerA->dwBuildNumber = 9999: pVerA->dwPlatformId = VER_PLATFORM_WIN32_NT
    pVerA->szCSDVersion = "Service Pack 2"
    if pVerA->dwOSVersionInfoSize >= sizeof(_OSVERSIONINFOEXW) then
      pVerA->wServicePackMajor=2: pVerA->wServicePackMinor=0
      pVerA->wSuiteMask = -1: pVerA->wProductType = VER_NT_WORKSTATION
    end if
    return true
  end function
  
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

  UndefAllParams()
  #define P1 pBuffer       as SYSTEM_LOGICAL_PROCESSOR_INFORMATION ptr
  #define P2 pReturnLength as DWORD ptr
  #undef GetLogicalProcessorInformation
  function GetLogicalProcessorInformation alias "GetLogicalProcessorInformation" (P1,P2) as integer export
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
  
  function _VerifyVersionInfoW alias "VerifyVersionInfoW" (lpVerW as _OSVERSIONINFOEXW ptr,dwType as dword,dwCond as dword) as integer export
    return true 'hehe
  end function  
  function _VerifyVersionInfoA alias "VerifyVersionInfoA" (lpVerA as _OSVERSIONINFOEXA ptr,dwType as dword,dwCond as dword) as integer export
    return true 'hehe
  end function  

  function _GetThreadId alias "GetThreadId"(Thread as HANDLE) as DWORD export
            
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
  #define P1 hFile as HANDLE
  #define P2 lpszFilePath as LPWSTR
  #define P3 cchFilePath as DWORD
  #define P4 dwFlags as DWORD
  function GetFinalPathNameByHandleW(P1,P2,P3,P4) as dword export
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
  
  function GetTickCount64() as ulongint export
    dim as ulongint ulFreq = any, ulCounter = any 
    QueryPerformanceFrequency( cptr(LARGE_INTEGER ptr,@ulFreq ) )
    QueryPerformanceCounter( cptr(LARGE_INTEGER ptr,@ulCounter ) )
    return ulCounter\(ulFreq\1000)
  end function
  
  function GetNumaNodeProcessorMaskEx( Node as ushort , ProcessorMask as GROUP_AFFINITY ptr ) as integer export
    MacroStubFunction()
    return 0
  end function
  
  function SetThreadGroupAffinity(hThread as HANDLE, GroupAffinity as GROUP_AFFINITY ptr , PGROUP_AFFINITY as GROUP_AFFINITY ptr) as integer export
    MacroStubFunction()
    return 0    
  end function
  
end extern

#if 0
  dim shared as any ptr OrgProc
  dim shared as hwnd SplashWnd
  function MyProc( hwnd as hwnd , msg as integer , wparam as wparam , lparam as lparam ) as lresult
    'OutputDebugString("msg=0x"+hex$(msg,8))
    
    static as integer N = 1
    
    select case msg 
    case WM_TIMER
      dim as rect tTemp    
      GetWindowRect( SplashWnd , @tTemp )    
      if tTemp.left<>0 and tTemp.Top <> 0 then      
        select case N              
        case 1        
          dim as point mypt = type(683,406)
          ClientToScreen( SplashWnd , @mypt )        
          SetCursorPos( mypt.x , mypt.y )    
          if GetForegroundWindow()<> SplashWnd then 
            SetForegroundWindow( SplashWnd )
          end if
          N = 2
        case 2
          mouse_event( MOUSEEVENTF_LEFTDOWN , 0 , 0 , 0 , 0 )
          N = 3
        case 3
          mouse_event( MOUSEEVENTF_LEFTUP , 0 , 0 , 0 , 0 )
          N = 1                        
          OutputDebugString(!"Clicking!\r\n")
          exit function      
        case else
          N += 1
          if N > 10 then N = 1
        end select
      end if  
    case WM_LBUTTONUP
      function = CallWindowProc( OrgProc , hwnd , msg , wparam , lparam )    
      N = 4 : OutputDebugString(!"Button up!\r\n")
      exit function
    case WM_DESTROY    
      KillTimer( SplashWnd , WM_USER+99 )
    end select
    
    return CallWindowProc( OrgProc , hwnd , msg , wparam , lparam )
  end function
  
  UndefAllParams()
  #define P1 dwExStyle as DWORD
  #define P2 lpClassName as any ptr 'W/A
  #define P3 lpWindowName as any ptr 'W/A
  #define P4 dwStyle as DWORD
  #define P5 x as integer
  #define P6 y as integer
  #define P7 nWidth as integer
  #define P8 nHeight as integer
  #define P9 hWndParent as hwnd
  #define P10 hMenu as HMENU
  #define P11 hInstance as HINSTANCE
  #define P12 lpParam as any ptr
  dim shared pfCreateWindowExW as function (P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12) as hwnd
  function CreateWindowExW_Detour(P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12) as hwnd
    'OutputDebugString("CreateWindowExW_Detour")
    if (dwStyle and WS_CHILD)=0 then dwExStyle or= (WS_EX_COMPOSITED or WS_EX_LAYERED) 
    return pfCreateWindowExW( dwExStyle , lpClassName , lpWindowName , _
    dwStyle , x , y , nWidth , nHeight , hWndParent , hMenu , hInstance , lpParam )
  end function
  dim shared pfCreateWindowExA as function (P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12) as hwnd
  function CreateWindowExA_Detour(P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12) as hwnd
    'OutputDebugString("CreateWindowExA_Detour")
    
    #if 0
      if (dwStyle and WS_CHILD)=0 andalso cuint(lpClassName) > &hFFFF then     
        if *cptr(zstring ptr,lpClassName)="MischiefSplashScreen" then
          iSkip = 1: dwStyle or= WS_VISIBLE: x=0:y=0      
          SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL)
        end if
      end if
    #endif
    
    'dwExStyle or= WS_EX_LAYERED
    var hResu = pfCreateWindowExA( dwExStyle , lpClassName , lpWindowName , _
    dwStyle , x , y , nWidth , nHeight , hWndParent , hMenu , hInstance , lpParam )
    
    #if 0
      var iSkip = 0
      if hResu andalso iSkip then
        *cptr(long ptr,@OrgProc) = SetWindowLong(hResu,GWL_WNDPROC,clng(@MyProc))    
        SetTimer( hResu , WM_USER+99 , 1 , null )    
        SplashWnd = hResu
      end if
    #endif
    
    return hResu
  end function
  
  dim shared pfChoosePixelFormat as function (hdc as hdc, ppfd as PIXELFORMATDESCRIPTOR ptr) as integer
  function ChoosePixelFormat_Detour(hdc as hdc, ppfd as PIXELFORMATDESCRIPTOR ptr) as integer
    OutputDebugString(!"ChoosePixelFormat_Detour\r\n")  
    'ppfd->dwFlags or= (PFD_SUPPORT_OPENGL or PFD_DRAW_TO_BITMAP)
    'ppfd->dwFlags and= (not (PFD_DRAW_TO_WINDOW))
    'ppfd->iLayerType = PFD_MAIN_PLANE
    return pfChoosePixelFormat(hdc,ppfd)
  end function
  
  'SetDetourLibrary("gdi32")
  'CreateDetour(ChoosePixelFormat)
  
  SetDetourLibrary("user32")
  CreateDetour(CreateWindowExA)
  CreateDetour(CreateWindowExW)
#endif