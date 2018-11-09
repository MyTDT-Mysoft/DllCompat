#include "dynload.bi"

#define STRFIND_LIM 2048
#define INSA(x) cast(ubyte,  iif(((x-65) and &hFF)>=26, 0+x, x+32))
#define INSW(x) cast(ushort, iif(((x-65) and &hFF)>=26 or (x and &hFF00), 0+x, (x+32) and &hFF))
function strFindIAA(hay as const zstring ptr, needle as const zstring ptr) as const zstring ptr
  dim as integer i, off
  off = 0
  if hay=NULL or needle=NULL then return NULL
  for i=0 to STRFIND_LIM
    if needle[off]=0 then return @hay[i-off]
    if hay[i]=0      then return NULL
    off = iif(INSA(hay[i])=INSA(needle[off]), off+1, 0)
  next i
  return NULL
end function
function strFindIWA(hay as const wstring ptr, needle as const zstring ptr) as const wstring ptr
  dim as integer i, off
  off = 0
  if hay=NULL or needle=NULL then return NULL
  for i=0 to STRFIND_LIM
    if needle[off]=0 then return @hay[i-off]
    if hay[i]=0      then return NULL
    off = iif(INSW(hay[i])=INSA(needle[off]), off+1, 0)
  next i
  return NULL
end function
'---------------------------------------------------------------------

function treatA(pIn as LPCSTR, hFile as HANDLE, dwFlags as DWORD, funType as BYTE) as HMODULE
  dim as HMODULE h
  dim as integer i
  dim as LPCSTR repl = NULL
  dim as BOOL fail = FALSE
  
  fail or= pIn=NULL
  fail or= funType=GETMOD andalso dwFlags and GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS
  if fail=FALSE then
    for i=0 to ubound(mapCommon)
      if strFindIAA(pIn, mapCommon(i).targ) then
        repl = mapCommon(i).repl
      end if
    next i
    if repl=NULL then repl = pIn
  end if
  
  if funType=GETMOD then
    if repl<>pIn andalso GetModuleHandleA(pIn) andalso GetModuleHandleA(repl)=NULL then LoadLibraryA(repl)
    'MySoft mentions using flag to never unload
    GetModuleHandleExA(dwFlags, repl, @h)
  else
    h = LoadLibraryExA(repl, hFile, dwFlags)
  end if
  
  return h
end function

function treatW(pIn as LPCWSTR, hFile as HANDLE, dwFlags as DWORD, funType as BYTE) as HMODULE
  dim as HMODULE h
  dim as integer i
  dim as LPCSTR repl = NULL
  dim as BOOL fail = FALSE
  
  fail or= pIn=NULL
  fail or= funType=GETMOD andalso dwFlags and GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS
  if fail=FALSE then
    for i=0 to ubound(mapCommon)
      if strFindIWA(pIn, mapCommon(i).targ) then
        repl = mapCommon(i).repl
      end if
    next i
  end if
  
  if repl=NULL then
    if funType=GETMOD then
      GetModuleHandleExW(dwFlags, pIn, @h)
    else
      h = LoadLibraryExW(pIn, hFile, dwFlags)
    end if
  else
    if funType=GETMOD then
      if GetModuleHandleW(pIn) andalso GetModuleHandleA(repl)=NULL then LoadLibraryA(repl)
      GetModuleHandleExA(dwFlags, repl, @h)
    else
      h = LoadLibraryExA(repl, hFile, dwFlags)
    end if
  end if
  
  return h
end function
'---------------------------------------------------------------------

extern "windows-ms"
  #macro DEBUG_TestDynload(_NAME, _TYPE)
    if h=NULL then
      DEBUG_WhoCalledResult()
      #if _TYPE=T_ANSI
        DEBUG_MsgTrace("Dynload FAIL: %s", _NAME)
      #elseif _TYPE=T_WIDE
        DEBUG_MsgTrace("Dynload FAIL: %ls", _NAME)
      #endif
    end if
  #endmacro

  UndefAllParams()
  #define P1 lpModuleName as LPCSTR
  function _GetModuleHandleA alias "GetModuleHandleA"(P1) as HMODULE export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatA(lpModuleName, NULL, GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, GETMOD)
    DEBUG_TestDynload(lpModuleName, T_ANSI)
    return h
  end function

  UndefAllParams()
  #define P1 lpModuleName as LPCWSTR
  function _GetModuleHandleW alias "GetModuleHandleW"(P1) as HMODULE export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatW(lpModuleName, NULL, GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, GETMOD)
    DEBUG_TestDynload(lpModuleName, T_WIDE)
    return h
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExA alias "GetModuleHandleExA"(P1, P2, P3) as BOOL export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatA(lpModuleName, NULL, dwFlags, GETMOD)
    DEBUG_TestDynload(lpModuleName, T_ANSI)
    return h<>NULL
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCWSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExW alias "GetModuleHandleExW"(P1, P2, P3) as BOOL export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatW(lpModuleName, NULL, dwFlags, GETMOD)
    DEBUG_TestDynload(lpModuleName, T_WIDE)
    return h<>null
  end function

  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  function _LoadLibraryA alias "LoadLibraryA"(P1) as HMODULE export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatA(lpFileName, NULL, 0, LOADLIB)
    DEBUG_TestDynload(lpFileName, T_ANSI)
    return h
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  function _LoadLibraryW alias "LoadLibraryW"(P1) as HMODULE export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatW(lpFileName, NULL, 0, LOADLIB)
    DEBUG_TestDynload(lpFileName, T_WIDE)
    return h
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExA alias "LoadLibraryExA"(P1, P2, P3) as HMODULE export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatA(lpFileName, hFile, dwFlags, LOADLIB)
    DEBUG_TestDynload(lpFileName, T_ANSI)
    return h
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExW alias "LoadLibraryExW"(P1, P2, P3) as HMODULE export
    DEBUG_WhoCalledInit()
    dim as HMODULE h
    h = treatW(lpFileName, hFile, dwFlags, LOADLIB)
    DEBUG_TestDynload(lpFileName, T_WIDE)
    return h
  end function
  
  UndefAllParams()
  #define P1 hModule as HMODULE
  #define P2 lpProcName as LPCSTR
  function _GetProcAddress alias "GetProcAddress"(P1, P2) as FARPROC export
    DEBUG_WhoCalledInit()
    dim as zstring*MAX_PATH temp
    dim as FARPROC h
    h = GetProcAddress(hModule, lpProcName)
    if hModule andalso h=NULL then
      if GetModuleFileNameA(hModule, @temp, MAX_PATH)=0 then
        temp = "NONE"
      end if
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s > %s", @temp, lpProcName)
    end if
    return h
  end function
  
  UndefAllParams()
  #define P1 hModule as HMODULE
  function _FreeLibrary alias "FreeLibrary"(P1) as BOOL export
    return FreeLibrary(hModule)
  end function
  
  UndefAllParams()
  #define P1 hModule as HMODULE
  #define P2 dwExitCode as DWORD
  sub _FreeLibraryAndExitThread alias "FreeLibraryAndExitThread"(P1, P2) export
    FreeLibraryAndExitThread(hModule, dwExitCode)
    'if _FreeLibrary(hModule) then ExitThread(dwExitCode)
  end sub
  
end extern