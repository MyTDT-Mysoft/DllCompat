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
"ntdll",    "ntdll",   _
"opengl32", "opengl3x",_
"powrprof", "powrprox",_
"shell32",  "shell3x", _
"user32",   "user3x",  _
"uxtheme",  "uxthemx", _
"ws2_32",   "ws2_3x"  
#define DLOAD_DLLNUM 16*2
#define DLOAD_MAXLEN 24
static shared as zstring*DLOAD_MAXLEN dllNamesA(DLOAD_DLLNUM) = {DLOAD_DLLNAMES}
static shared as wstring*DLOAD_MAXLEN dllNamesW(DLOAD_DLLNUM) = {DLOAD_DLLNAMES}

#define NOSUBSTITUTION rem

sub fixImpA(path as LPCSTR ptr)
  dim as int i, j
  
  NOSUBSTITUTION return
  for i=0 to DLOAD_DLLNUM-1 step 2
    if StrStrIA(*path, dllNamesA(i+0)) then
        DEBUG_MsgTrace("Dynload substitution for %s", *path)
        *path = @dllNamesA(i+1)
        exit for
    end if
  next i
end sub

sub fixImpW(path as LPCWSTR ptr)
  dim as int i, j
  
  NOSUBSTITUTION return
  for i=0 to DLOAD_DLLNUM-1 step 2
    if StrStrIW(*path, dllNamesW(i+0)) then
        DEBUG_MsgTrace("Dynload substitution for %ls", *path)
        *path = @dllNamesW(i+1)
        exit for
    end if
  next i
end sub

extern "windows-ms"
  UndefAllParams()
  #define P1 lpModuleName as LPCSTR
  function _GetModuleHandleA alias "GetModuleHandleA"(P1) as HMODULE export
    fixImpA(@lpModuleName)
    DEBUG_WhoCalledInit()
    dim ret as HMODULE
    
    ret = GetModuleHandleA(lpModuleName)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s", lpModuleName)
    end if
    
    return ret
  end function

  UndefAllParams()
  #define P1 lpModuleName as LPCWSTR
  function _GetModuleHandleW alias "GetModuleHandleW"(P1) as HMODULE export
    fixImpW(@lpModuleName)
    DEBUG_WhoCalledInit()
    dim ret as HMODULE
    
    ret = GetModuleHandleW(lpModuleName)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %ls", lpModuleName)
    end if
    
    return ret
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExA alias "GetModuleHandleExA"(P1, P2, P3) as BOOL export
    fixImpA(@lpModuleName)
    DEBUG_WhoCalledInit()
    dim ret as BOOL
    
    ret = GetModuleHandleExA(dwFlags, lpModuleName, phModule)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s", lpModuleName)
    end if
    
    return ret
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCWSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExW alias "GetModuleHandleExW"(P1, P2, P3) as BOOL export
    fixImpW(@lpModuleName)
    DEBUG_WhoCalledInit()
    dim ret as BOOL
    
    ret = GetModuleHandleExW(dwFlags, lpModuleName, phModule)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %ls", lpModuleName)
    end if
    
    return ret
  end function

  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  function _LoadLibraryA alias "LoadLibraryA"(P1) as HMODULE export
    fixImpA(@lpFileName)
    DEBUG_WhoCalledInit()
    dim ret as HMODULE
    
    ret = LoadLibraryA(lpFileName)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s", lpFileName)
    end if
    
    return ret
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  function _LoadLibraryW alias "LoadLibraryW"(P1) as HMODULE export
    fixImpW(@lpFileName)
    DEBUG_WhoCalledInit()
    dim ret as HMODULE
    
    ret = LoadLibraryW(lpFileName)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %ls", lpFileName)
    end if
    
    return ret
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExA alias "LoadLibraryExA"(P1, P2, P3) as HMODULE export
    fixImpA(@lpFileName)
    DEBUG_WhoCalledInit()
    dim ret as HMODULE
    
    ret = LoadLibraryExA(lpFileName, hFile, dwFlags)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %s", lpFileName)
    end if
    
    return ret
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExW alias "LoadLibraryExW"(P1, P2, P3) as HMODULE export
    fixImpW(@lpFileName)
    DEBUG_WhoCalledInit()
    dim ret as HMODULE
    
    ret = LoadLibraryExW(lpFileName, hFile, dwFlags)
    if ret=0 then
      DEBUG_WhoCalledResult()
      DEBUG_MsgTrace("Dynload FAIL: %ls", lpFileName)
    end if
    
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
end extern