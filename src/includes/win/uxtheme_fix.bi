#pragma once
'#include once "commctrl.bi"

type HTHEME as HANDLE

const DTT_TEXTCOLOR = culng(1u shl 0)
const DTT_BORDERCOLOR = culng(1u shl 1)
const DTT_SHADOWCOLOR = culng(1u shl 2)
const DTT_SHADOWTYPE = culng(1u shl 3)
const DTT_SHADOWOFFSET = culng(1u shl 4)
const DTT_BORDERSIZE = culng(1u shl 5)
const DTT_FONTPROP = culng(1u shl 6)
const DTT_COLORPROP = culng(1u shl 7)
const DTT_STATEID = culng(1u shl 8)
const DTT_CALCRECT = culng(1u shl 9)
const DTT_APPLYOVERLAY = culng(1u shl 10)
const DTT_GLOWSIZE = culng(1u shl 11)
const DTT_CALLBACK = culng(1u shl 12)
const DTT_COMPOSITED = culng(1u shl 13)
const DTT_VALIDBITS = culng(culng(culng(culng(culng(culng(culng(culng(culng(culng(culng(culng(DTT_TEXTCOLOR or DTT_BORDERCOLOR) or DTT_SHADOWCOLOR) or DTT_SHADOWTYPE) or DTT_SHADOWOFFSET) or DTT_BORDERSIZE) or DTT_FONTPROP) or DTT_COLORPROP) or DTT_STATEID) or DTT_CALCRECT) or DTT_APPLYOVERLAY) or DTT_GLOWSIZE) or DTT_COMPOSITED)
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

extern "Windows"
  #undef GetThemeFont
  declare function GetThemeFont(byval hTheme as HTHEME, byval hdc as HDC, byval iPartId as long, byval iStateId as long, byval iPropId as long, byval pFont as LOGFONTW ptr) as HRESULT
end extern