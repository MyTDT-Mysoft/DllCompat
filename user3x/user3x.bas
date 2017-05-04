#define fbc -dll -Wl "user3x.dll.def" -x ..\bin\user3x.dll
#include "user3x.bi"

#include "windows.bi"
'#include "..\MyTDT\detour.bas"

extern "windows-ms"
  function CloseTouchInputHandle (hTouchInput as HANDLE) as BOOL export
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  function GetTouchInputInfo (hTouchInput as HANDLE, cInputs as UINT, pInputs as PTOUCHINPUT, cbSize as Integer) as BOOL export
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  function RegisterTouchWindow (hWnd as HWND, ulFlags as ULONG) as BOOL export
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
end extern