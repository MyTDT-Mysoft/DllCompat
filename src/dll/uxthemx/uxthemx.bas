#include "windows.bi"
#include "win\uxtheme.bi"
#include "shared\helper.bas"
#include "includes\win\uxtheme_fix.bi"

extern "windows-ms"
  UndefAllParams()
  #define P1 hTheme as HTHEME
  #define P2 hdc as HDC
  #define P3 iPartId as integer
  #define P4 iStateId as integer
  #define P5 pszText as LPCWSTR
  #define P6 iCharCount as integer
  #define P7 dwFlags as DWORD
  #define P8 pRect as LPRECT
  #define P9 pOptions as const DTTOPTS ptr
  function DrawThemeTextEx(P1, P2, P3, P4, P5, P6, P7, P8, P9) as HRESULT export
    return 0
  end function
  
  UndefAllParams()
  #define P1 hTheme as HTHEME
  #define P2 iPartId as integer
  #define P3 iStateIdFrom as integer
  #define P4 iStateIdTo as integer
  #define P5 iPropId as integer
  #define P6 pdwDuration as DWORD ptr
  function GetThemeTransitionDuration(P1, P2, P3, P4, P5, P6) as HRESULT export
    return 0
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 eAttribute as WINDOWTHEMEATTRIBUTETYPE 'enum
  #define P3 pvAttribute as PVOID
  #define P4 cbAttribute as DWORD
  function SetWindowThemeAttribute(P1, P2, P3, P4) as HRESULT export
    return 0
  end function
end extern