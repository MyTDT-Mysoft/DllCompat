const CLIP_MAXHWND = 256

static shared clip_servHwnd as HWND
static shared clip_servEvt  as HANDLE
static shared clip_servThr  as HANDLE
static shared clip_hwndArr(CLIP_MAXHWND) as HWND
static shared clip_hwndCount as long = 0

extern "windows-ms"
  function clip_servWndCB(hwnd as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
    static isInit as BOOL = FALSE
    static hwndNextViewer as HWND
    
    select case uMsg
      case WM_CREATE
        hwndNextViewer = SetClipboardViewer(hwnd)
        return 0
      case WM_DESTROY
        ChangeClipboardChain(hwnd, hwndNextViewer)
        PostQuitMessage(0)
        return 0
      case WM_DRAWCLIPBOARD
        SendMessageA(hwndNextViewer, uMsg, wParam, lParam)
        if isInit then
          for i as integer = 0 to CLIP_MAXHWND
            if clip_hwndArr(i)<>NULL then SendMessageA(clip_hwndArr(i), WM_CLIPBOARDUPDATE, 0, 0)
          next
        else
          isInit = TRUE
        end if
        return 0
      case WM_CHANGECBCHAIN
        if cast(HWND, wParam)=hwndNextViewer then
          hwndNextViewer = cast(HWND, lParam)
        elseif hwndNextViewer<>NULL then
          SendMessageA(hwndNextViewer, uMsg, wParam, lParam)
        end if
        return 0
    end select
    return DefWindowProcA(hwnd, uMsg, wParam, lParam)
  end function
  
  function clip_servThrCB(lpParam as LPVOID) as DWORD
    const serviceClass = "dllcompat.user3x.clipServ"
    dim hinst as HINSTANCE = cast(HINSTANCE, lpParam)
    dim wc as WNDCLASSEXA
    dim msg as MSG
    dim isClassReg as BOOL
    
    wc.cbSize = sizeof(WNDCLASSEXA)
    wc.hInstance = hinst
    wc.lpfnWndProc = @clip_servWndCB
    wc.lpszClassName = @serviceClass
    
    if RegisterClassExA(@wc)=0 then goto FAIL
    isClassReg = TRUE
    clip_servHwnd = CreateWindowEx(WS_EX_LEFT, @serviceClass, NULL, 0, 0, 0, 0, 0, HWND_MESSAGE, NULL, hinst, NULL)
    if clip_servHwnd=NULL then goto FAIL
    
    while GetMessageA(@msg, 0, 0, 0) > 0
      'TranslateMessage(@msg)
      DispatchMessage(@msg)
    wend
    
    UnregisterClassA(serviceClass, hinst)
    clip_servThr = NULL
    SetEvent(clip_servEvt)
    return 0
    
    FAIL:
    if isClassReg then UnregisterClassA(serviceClass, hinst)
    clip_servThr = NULL
    return 1
  end function
end extern

sub clip_initService()
  dim thrID as DWORD
  clip_servEvt = CreateEventA(NULL, FALSE, FALSE, NULL)
  if clip_servEvt=NULL then return
  clip_servThr = CreateThread(NULL, 0, cast(LPTHREAD_START_ROUTINE, @clip_servThrCB), u3x_dllHandle, 0, @thrID)
end sub

sub clip_destroyService()
  if clip_servThr<>NULL then
    SendMessageA(clip_servHwnd, WM_CLOSE, 0, 0)
    WaitForSingleObject(clip_servEvt, INFINITE)
  end if
  if clip_servEvt<>NULL then CloseHandle(clip_servEvt)
end sub

extern "windows-ms"
  UndefAllParams()
  #define P1 hwnd as HWND
  function AddClipboardFormatListener(P1) as BOOL export
    for i as integer = 0 to CLIP_MAXHWND
      if clip_hwndArr(i)=hwnd then
         SetLastError(E_INVALIDARG)
         return FALSE      
      end if
    next
    for i as integer = 0 to CLIP_MAXHWND
      if clip_hwndArr(i)=NULL then
        clip_hwndArr(i) = hwnd
        
        if InterlockedIncrement(@clip_hwndCount)=1 then clip_initService()
        return TRUE
      end if
    next
    SetLastError(E_OUTOFMEMORY)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  function RemoveClipboardFormatListener(P1) as BOOL export
    for i as integer = 0 to CLIP_MAXHWND
      if clip_hwndArr(i)=hwnd then
        clip_hwndArr(i) = NULL
        
        if InterlockedDecrement(@clip_hwndCount)=0 then clip_destroyService()
        return TRUE
      end if
    next
    SetLastError(E_INVALIDARG)
    return FALSE
  end function
end extern