#define fbc -dll -Wl "user3x.dll.def" -x ..\..\bin\dll\user3x.dll -i ..\..\

#include "windows.bi"
#include "shared\helper.bas"
#include "includes\win\user32_fix.bi"

extern "windows-ms"
  UndefAllParams()
  #define P1 hWnd        as _In_opt_ HWND
  #define P2 id          as _in_     int
  #define P3 fsModifiers as _in_     UINT
  #define P4 vk          as _in_     UINT
  function fnRegisterHotKey alias "RegisterHotKey"(P1, P2, P3, P4) as BOOL export
    dim newModifiers as UINT
    newModifiers = fsModifiers and (not MOD_NOREPEAT)
    'TODO: replicate MOD_NOREPEAT behaviour in XP
    return RegisterHotKey(hWnd, id, newModifiers, vk)
  end function

  UndefAllParams()
  #define P1 hTouchInput as _In_ HANDLE
  function CloseTouchInputHandle(P1) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hTouchInput as _In_  HANDLE
  #define P2 cInputs     as _In_  UINT
  #define P3 pInputs     as _Out_ PTOUCHINPUT
  #define P4 cbSize      as _In_  int
  function GetTouchInputInfo(P1, P2, P3, P4) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hWnd    as _In_ HWND
  #define P2 ulFlags as _In_ ULONG
  function RegisterTouchWindow(P1, P2) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hGestureInfo as _In_  HGESTUREINFO
  #define P2 pGestureInfo as _Out_ PGESTUREINFO
  function GetGestureInfo(P1, P2) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hGestureInfo as HGESTUREINFO
  function CloseGestureInfoHandle(P1) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(0)
    return TRUE
  end function
  
  UndefAllParams()
  #define P1 message as _In_ UINT
  #define P2 dwFlag  as _In_ DWORD
  function ChangeWindowMessageFilter(P1, P2) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(0)
    return TRUE
  end function
  
  UndefAllParams()
  #define P1 hWnd                as _In_        HWND
  #define P2 message             as _In_        UINT
  #define P3 action              as _In_        DWORD
  #define P4 pChangeFilterStruct as _Inout_opt_ PCHANGEFILTERSTRUCT
  function ChangeWindowMessageFilterEx(P1, P2, P3, P4) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(0)
    return TRUE
  end function
  
  #undef UpdateLayeredWindowIndirect
  UndefAllParams()
  #define P1 hwnd     as _In_ HWND
  #define P2 pULWInfo as _In_ const UPDATELAYEREDWINDOWINFO ptr
  function UpdateLayeredWindowIndirect(P1, P2) as BOOL export
    dim ret as BOOL
    dim flags as DWORD
    
    if pULWInfo=0 orelse pULWInfo->cbSize <> sizeof(*pULWInfo) then
      SetLastError(ERROR_INVALID_PARAMETER)
      return FALSE
    end if
    
    'TODO: UpdateLayeredWindow always redraws whole window. Handle partial redrawing.
    flags = pULWInfo->dwFlags
    if flags and ULW_EX_NORESIZE then
      'TODO:
      '<gigaherz> wouldn't you want to check that before calling UpdateLayeredWindow?
      '<gigaherz> doing some kind of GetWindowRect and checking the dimensions?
    end if
    
    'flag invalid for UpdateLayeredWindow, according to WINE. Clear it.
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
