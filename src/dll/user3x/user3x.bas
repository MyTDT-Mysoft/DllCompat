#define fbc -dll -Wl "user3x.dll.def" -x ..\..\bin\dll\user3x.dll -i ..\..\
#include "user3x.bi"

#include "windows.bi"
#include "shared\helper.bas"

#ifndef HGESTUREINFO
  type HGESTUREINFO as HANDLE
#endif
#ifndef PGESTUREINFO
  type PGESTUREINFO as any ptr
#endif

extern "windows-ms"
  function CloseTouchInputHandle (hTouchInput as HANDLE) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  function GetTouchInputInfo (hTouchInput as HANDLE, cInputs as UINT, pInputs as PTOUCHINPUT, cbSize as Integer) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  function RegisterTouchWindow (hWnd as HWND, ulFlags as ULONG) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return FALSE
  end function
  
  function GetGestureInfo (hGestureInfo as HGESTUREINFO, pGestureInfo as PGESTUREINFO) as BOOL export
    MacroStubFunction()
    SetLastError(E_NOTIMPL)
    return false
  end function
  
  function CloseGestureInfoHandle(hGestureInfo as HGESTUREINFO) as BOOL export
    MacroStubFunction()
    SetLastError(0)
    return true
  end function
  
  function ChangeWindowMessageFilter(message as UINT, dwFlag as DWORD) as BOOL export
    MacroStubFunction()
    SetLastError(0)
    return true
  end function
  
  function ChangeWindowMessageFilterEx(hWnd as HWND, message as UINT, action as DWORD, pChangeFilterStruct as PCHANGEFILTERSTRUCT) as BOOL export
    MacroStubFunction()
    SetLastError(0)
    return true
  end function
end extern
