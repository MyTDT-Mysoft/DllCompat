#define fbc -dll -Wl "user3x.dll.def" -x ..\..\bin\dll\user3x.dll -i ..\..\

#include "windows.bi"
#include "shared\helper.bas"
#include "includes\win\user32_fix.bi"

#ifndef HGESTUREINFO
  type HGESTUREINFO as HANDLE
#endif
#ifndef PGESTUREINFO
  type PGESTUREINFO as any ptr
#endif

extern "windows-ms"
  UndefAllParams()
  #define P1 hTouchInput as HANDLE
  function CloseTouchInputHandle(P1) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hTouchInput as HANDLE
  #define P2 cInputs as UINT
  #define P3 pInputs as PTOUCHINPUT
  #define P4 cbSize as Integer
  function GetTouchInputInfo(P1, P2, P3, P4) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hWnd as HWND
  #define P2 ulFlags as ULONG
  function RegisterTouchWindow(P1, P2) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hGestureInfo as HGESTUREINFO
  #define P2 pGestureInfo as PGESTUREINFO
  function GetGestureInfo (P1, P2) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hGestureInfo as HGESTUREINFO
  function CloseGestureInfoHandle(P1) as BOOL export
    MacroStubFunction()
    SetLastError(0)
    return TRUE
  end function
  
  UndefAllParams()
  #define P1 message as UINT
  #define P2 dwFlag as DWORD
  function ChangeWindowMessageFilter(P1, P2) as BOOL export
    MacroStubFunction()
    SetLastError(0)
    return TRUE
  end function
  
  UndefAllParams()
  #define P1 hWnd as HWND
  #define P2 message as UINT
  #define P3 action as DWORD
  #define P4 pChangeFilterStruct as PCHANGEFILTERSTRUCT
  function ChangeWindowMessageFilterEx(P1, P2, P3, P4) as BOOL export
    MacroStubFunction()
    SetLastError(0)
    return TRUE
  end function
  
  #undef UpdateLayeredWindowIndirect
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 pULWInfo as const UPDATELAYEREDWINDOWINFO ptr
  function UpdateLayeredWindowIndirect(P1, P2) as BOOL export
    dim ret as BOOL
    dim flags as DWORD
    
    flags = pULWInfo->dwFlags
    if flags and ULW_EX_NORESIZE then
      'TODO:
      '<gigaherz> wouldn't you want to check that before calling UpdateLayeredWindow?
      '<gigaherz> doing some kind of GetWindowRect and checking the dimensions?
    end if
    
    'WINE says this flag is not valid for UpdateLayeredWindow
    'we clear it out
    flags = flags and (not ULW_EX_NORESIZE)
    ret   = UpdateLayeredWindow( _
      hwnd, _
      pULWInfo->hdcDst, _
      cast(POINT ptr,         pULWInfo->pptDst), _
      cast(SIZE ptr,          pULWInfo->psize), _
      pULWInfo->hdcSrc, _
      cast(POINT ptr,         pULWInfo->pptSrc), _
      pULWInfo->crKey, _
      cast(BLENDFUNCTION ptr, pULWInfo->pblend), _
      flags _
    )
    return ret
  end function
end extern
