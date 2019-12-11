#pragma once

#include "windows.bi"

#undef MOD_NOREPEAT
#undef HGESTUREINFO__
#undef HGESTUREINFO
#undef tagGESTUREINFO
#undef GESTUREINFO
#undef PGESTUREINFO 
#undef PCGESTUREINFO
#undef _TOUCHINPUT
#undef TOUCHINPUT
#undef PTOUCHINPUT
#undef tagCHANGEFILTERSTRUCT
#undef CHANGEFILTERSTRUCT
#undef PCHANGEFILTERSTRUCT

const MOD_NOREPEAT = &h4000

type HGESTUREINFO__
  unused as long
end type
type HGESTUREINFO as HGESTUREINFO__ ptr

type tagGESTUREINFO
  cbSize as UINT
  dwFlags as DWORD
  dwID as DWORD
  hwndTarget as HWND
  ptsLocation as POINTS
  dwInstanceID as DWORD
  dwSequenceID as DWORD
  ullArguments as ULONGLONG
  cbExtraArgs as UINT
end type
type GESTUREINFO as tagGESTUREINFO
type PGESTUREINFO as tagGESTUREINFO ptr
type PCGESTUREINFO as const GESTUREINFO ptr

type _TOUCHINPUT
  x as LONG
  y as LONG
  hSource as HANDLE
  dwID as DWORD
  dwFlags as DWORD
  dwMask as DWORD
  dwTime as DWORD
  dwExtraInfo as ULONG_PTR
  cxContact as DWORD
  cyContact as DWORD
end type
type TOUCHINPUT as _TOUCHINPUT
type PTOUCHINPUT as _TOUCHINPUT ptr

type tagCHANGEFILTERSTRUCT
  cbSize as DWORD
  ExtStatus as DWORD
end type
type CHANGEFILTERSTRUCT as tagCHANGEFILTERSTRUCT
type PCHANGEFILTERSTRUCT as tagCHANGEFILTERSTRUCT ptr