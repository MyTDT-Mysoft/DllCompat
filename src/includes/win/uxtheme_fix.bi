#pragma once
'#include once "commctrl.bi"

#undef HTHEME
#undef DTT_CALLBACK_PROC
#undef WINDOWTHEMEATTRIBUTETYPE
#undef _DTTOPTS
#undef DTTOPTS
#undef PDTTOPTS

type HTHEME as HANDLE

type DTT_CALLBACK_PROC as function(byval hdc as HDC, byval pszText as LPWSTR, byval cchText as long, byval prc as LPRECT, byval dwFlags as UINT, byval lParam as LPARAM) as long

type WINDOWTHEMEATTRIBUTETYPE as long
enum
  WTA_NONCLIENT = 1
end enum

type _DTTOPTS
  dwSize as DWORD
  dwFlags as DWORD
  crText as COLORREF
  crBorder as COLORREF
  crShadow as COLORREF
  iTextShadowType as long
  ptShadowOffset as POINT
  iBorderSize as long
  iFontPropId as long
  iColorPropId as long
  iStateId as long
  fApplyOverlay as WINBOOL
  iGlowSize as long
  pfnDrawTextCallback as DTT_CALLBACK_PROC
  lParam as LPARAM
end type
type DTTOPTS as _DTTOPTS
type PDTTOPTS as _DTTOPTS ptr