#define NOSUBSTITUTION 0
#define DLOAD_MAXLEN   24

'"TlsDeps",  "TlsDeps",_
#define DLOAD_DLLNAMES _
"advapi32", "advapi3x",_
"avrt",     "avrt",    _
"credui",   "credux",  _
"dwmapi",   "dwmapi",  _
"gdi32",    "gdi3x",   _
"gdiplus",  "gdipluz", _
"iphlpapi", "iphlpapx",_
"kernel32", "kernel3x",_
"msvcrt",   "msvcrz",  _
"ntdll",    "ntdlx",   _
"opengl32", "opengl3x",_
"powrprof", "powrprox",_
"shell32",  "shell3x", _
"user32",   "user3x",  _
"uxtheme",  "uxthemx", _
"ws2_32",   "ws2_3x"  

static shared as zstring*DLOAD_MAXLEN dllNamesA(...) = {DLOAD_DLLNAMES}
static shared as wstring*DLOAD_MAXLEN dllNamesW(...) = {DLOAD_DLLNAMES}

#macro DEBUG_TestDynloadA(_NAME)
  scope
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s", _NAME)
    end if
  end scope
#endmacro

#macro DEBUG_TestDynloadW(_NAME)
  scope
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %ls", _NAME)
    end if
  end scope
#endmacro

sub fixImpA(pIn as LPCSTR ptr, pOut as LPCSTR ptr, isRev as INT)
  dim as int i, j
  dim as LPCSTR s0, s1
  
  *pOut = *pIn
  if NOSUBSTITUTION then return
  for i=0 to ubound(dllNamesA) step 2
    s0 = @dllNamesA(i+((isRev+0) and 1))
    s1 = @dllNamesA(i+((isRev+1) and 1))
    if StrStrIA(*pIn, s0) then
      DEBUG_MsgTrace("Dynload substitution for %s", *pIn)
      *pOut = s1
      exit for
    end if
  next i
end sub

sub fixImpW(pIn as LPCWSTR ptr, pOut as LPCWSTR ptr, isRev as INT)
  dim as int i, j
  dim as LPCWSTR s0, s1
  
  *pOut = *pIn
  if NOSUBSTITUTION then return
  for i=0 to ubound(dllNamesW) step 2
    s0 = @dllNamesW(i+((isRev+0) and 1))
    s1 = @dllNamesW(i+((isRev+1) and 1))
    if StrStrIW(*pIn, s0) then
      DEBUG_MsgTrace("Dynload substitution for %ls", *pIn)
      *pOut = s1
      exit for
    end if
  next i
end sub

function lleA(lpFileName as LPCSTR, hFile as HANDLE, dwFlags as DWORD) as HMODULE
  dim as LPCSTR repName
  fixImpA(@lpFileName, @repName, 0)
  return LoadLibraryExA(repName, hFile, dwFlags)
end function

function lleW(lpFileName as LPCWSTR, hFile as HANDLE, dwFlags as DWORD) as HMODULE
  dim as LPCWSTR repName
  fixImpW(@lpFileName, @repName, 0)
  return LoadLibraryExW(repName, hFile, dwFlags)
end function

function gmheA(dwFlags as DWORD, lpModuleName as LPCSTR, phModule as HMODULE ptr) as BOOL export
  dim as LPCSTR repName
  dim retval as BOOL
  if (dwFlags and GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS)=0 then fixImpA(@lpModuleName, @repName, 0)
  retval = GetModuleHandleExA(dwFlags, repName, phModule)
  if retval=0 andalso NOSUBSTITUTION=0 then
    if GetModuleHandleA(lpModuleName) then
      DEBUG_MsgTrace("Dynload leaky LoadLibraryExA %s", repName)
      lleA(repName, NULL, 0)
      retval = GetModuleHandleExA(dwFlags, repName, phModule)
    end if
  end if
  return retval
end function

function gmheW(dwFlags as DWORD, lpModuleName as LPCWSTR, phModule as HMODULE ptr) as BOOL export
  dim as LPCWSTR repName
  dim retval as BOOL
  if (dwFlags and GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS)=0 then fixImpW(@lpModuleName, @repName, 0)
  retval = GetModuleHandleExW(dwFlags, repName, phModule)
  if retval=0 andalso NOSUBSTITUTION=0 then
    if GetModuleHandleW(lpModuleName) then
      DEBUG_MsgTrace("Dynload leaky LoadLibraryExW %ls", repName)
      lleW(repName, NULL, 0)
      retval = GetModuleHandleExW(dwFlags, repName, phModule)
    end if
  end if
  return retval
end function


extern "windows-ms"
  UndefAllParams()
  #define P1 lpModuleName as LPCSTR
  function _GetModuleHandleA alias "GetModuleHandleA"(P1) as HMODULE export
    dim ret as hModule
    DEBUG_WhoCalledInit()
    gmheA(GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, lpModuleName, @ret)
    DEBUG_TestDynloadA(lpModuleName)
    return ret
  end function

  UndefAllParams()
  #define P1 lpModuleName as LPCWSTR
  function _GetModuleHandleW alias "GetModuleHandleW"(P1) as HMODULE export
    dim ret as hModule
    DEBUG_WhoCalledInit()
    gmheW(GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, lpModuleName, @ret)
    DEBUG_TestDynloadW(lpModuleName)
    return ret
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExA alias "GetModuleHandleExA"(P1, P2, P3) as BOOL export
    dim ret as BOOL
    DEBUG_WhoCalledInit()
    ret = gmheA(dwFlags, lpModuleName, phModule)
    DEBUG_TestDynloadA(lpModuleName)
    return ret
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCWSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExW alias "GetModuleHandleExW"(P1, P2, P3) as BOOL export
    dim ret as BOOL
    DEBUG_WhoCalledInit()
    ret = gmheW(dwFlags, lpModuleName, phModule)
    DEBUG_TestDynloadW(lpModuleName)
    return ret
  end function

  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  function _LoadLibraryA alias "LoadLibraryA"(P1) as HMODULE export
    dim ret as HMODULE
    DEBUG_WhoCalledInit()
    ret = lleA(lpFileName, NULL, 0)
    DEBUG_TestDynloadA(lpFileName)
    return ret
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  function _LoadLibraryW alias "LoadLibraryW"(P1) as HMODULE export
    dim ret as HMODULE
    DEBUG_WhoCalledInit()
    ret = lleW(lpFileName, NULL, 0)
    DEBUG_TestDynloadW(lpFileName)
    return ret
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExA alias "LoadLibraryExA"(P1, P2, P3) as HMODULE export
    dim ret as HMODULE
    DEBUG_WhoCalledInit()
    ret = lleA(lpFileName, hFile, dwFlags)
    DEBUG_TestDynloadA(lpFileName)
    return ret
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExW alias "LoadLibraryExW"(P1, P2, P3) as HMODULE export
    dim ret as HMODULE
    DEBUG_WhoCalledInit()
    ret = lleW(lpFileName, hFile, dwFlags)
    DEBUG_TestDynloadW(lpFileName)
    return ret
  end function
  
  UndefAllParams()
  #define P1 hModule as HMODULE
  #define P2 lpProcName as LPCSTR
  function _GetProcAddress alias "GetProcAddress"(P1, P2) as FARPROC export
    DEBUG_WhoCalledInit()
    dim ret as FARPROC
    dim zModname as zstring*4096 = any
    
    ret = GetProcAddress(hModule, lpProcName)
    if hModule andalso ret=0 then
      if GetModuleFileNameA(hModule, @zModname, 4096)=0 then
        zModname = "NONE"
      end if
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s > %s", @zModname, lpProcName)
    end if
    
    return ret
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