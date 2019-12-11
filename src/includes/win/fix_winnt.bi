#pragma once
#if 0
type _OSVERSIONINFOEXA
	dwOSVersionInfoSize as DWORD
	dwMajorVersion as DWORD
	dwMinorVersion as DWORD
	dwBuildNumber as DWORD
	dwPlatformId as DWORD
	szCSDVersion as zstring * 128
	wServicePackMajor as WORD
	wServicePackMinor as WORD
	wSuiteMask as WORD
	wProductType as UBYTE
	wReserved as UBYTE
end type
type OSVERSIONINFOEXA as _OSVERSIONINFOEXA
type POSVERSIONINFOEXA as _OSVERSIONINFOEXA ptr
type LPOSVERSIONINFOEXA as _OSVERSIONINFOEXA ptr

type _OSVERSIONINFOEXW
	dwOSVersionInfoSize as DWORD
	dwMajorVersion as DWORD
	dwMinorVersion as DWORD
	dwBuildNumber as DWORD
	dwPlatformId as DWORD
	szCSDVersion as wstring * 128
	wServicePackMajor as WORD
	wServicePackMinor as WORD
	wSuiteMask as WORD
	wProductType as UBYTE
	wReserved as UBYTE
end type
type OSVERSIONINFOEXW as _OSVERSIONINFOEXW
type POSVERSIONINFOEXW as _OSVERSIONINFOEXW ptr
type LPOSVERSIONINFOEXW as _OSVERSIONINFOEXW ptr
type RTL_OSVERSIONINFOEXW as _OSVERSIONINFOEXW
type PRTL_OSVERSIONINFOEXW as _OSVERSIONINFOEXW ptr
#endif