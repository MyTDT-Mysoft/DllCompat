#include "windows.bi"

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