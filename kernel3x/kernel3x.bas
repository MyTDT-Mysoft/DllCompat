#define fbc -gen gcc -r -Wl "kernel3x.dll.def" -dll

#include "windows.bi"
#include "win\winnls.bi"

#include "MyTDT\detour.bas"

dim shared as any ptr pInitMutex
pInitMutex = CreateMutex(NULL,FALSE,NULL)

extern "windows"
declare function GetLocaleInfoW (byval as LCID, byval as LCTYPE, byval as LPWSTR, byval as integer) as integer
end extern

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

extern "windows-ms"
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

  UndefAll()
  #define P1 pBuffer       as SYSTEM_LOGICAL_PROCESSOR_INFORMATION ptr
  #define P2 pReturnLength as DWORD ptr
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
    

  
  function _VerifyVersionInfoW alias "VerifyVersionInfoW" (lpVerW as _OSVERSIONINFOEXW ptr,dwType as dword,dwCond as dword) as integer export
    return true 'hehe
  end function  
  function _VerifyVersionInfoA alias "VerifyVersionInfoA" (lpVerA as _OSVERSIONINFOEXA ptr,dwType as dword,dwCond as dword) as integer export
    return true 'hehe
  end function  
  
  'SYSTEM_LOGICAL_PROCESSOR_INFORMATION
  #if 0
  function _GetLogicalProcessorInformation alias "GetLogicalProcessorInformation" (pBuffer as any ptr,ReturnLength as DWORD ptr) as bool export
    SetLastError(1): return 0
  end function
  #endif
  
end extern

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

UndefAll()
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
  var iSkip = 0
  if (dwStyle and WS_CHILD)=0 andalso cuint(lpClassName) > &hFFFF then     
    if *cptr(zstring ptr,lpClassName)="MischiefSplashScreen" then
      iSkip = 1: dwStyle or= WS_VISIBLE: x=0:y=0      
      SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL)
    end if
  end if
  'dwExStyle or= WS_EX_LAYERED
  var hResu = pfCreateWindowExA( dwExStyle , lpClassName , lpWindowName , _
  dwStyle , x , y , nWidth , nHeight , hWndParent , hMenu , hInstance , lpParam )
  if hResu andalso iSkip then
    *cptr(long ptr,@OrgProc) = SetWindowLong(hResu,GWL_WNDPROC,clng(@MyProc))    
    SetTimer( hResu , WM_USER+99 , 1 , null )    
    SplashWnd = hResu
  end if
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
#if 0
SetDetourLibrary("user32")
CreateDetour(CreateWindowExA)
CreateDetour(CreateWindowExW)
#endif
