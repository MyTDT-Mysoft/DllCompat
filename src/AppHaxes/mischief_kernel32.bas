dim shared as any ptr OrgProc
dim shared as hwnd SplashWnd
function MyProc( hwnd as hwnd , msg as integer , wparam as wparam , lparam as lparam ) as lresult
  'OutputDebugString("msg=0x"+hex(msg,8))
  
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

