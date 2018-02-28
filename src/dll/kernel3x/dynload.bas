#define DLOAD_DLLNUM 10
#define DLOAD_MAXLEN 24
#define DLOAD_DLLNAMES _
"advapi32.dll", "credui.dll",  "gdi32.dll", _
"kernel32.dll", "msvcrt.dll",  "opengl32.dll", _
"powrprof.dll", "shell32.dll", "user32.dll", _
"ws2_32.dll"

static shared as zstring*DLOAD_MAXLEN dll_Anames(DLOAD_DLLNUM) = {DLOAD_DLLNAMES}
static shared as wstring*DLOAD_MAXLEN dll_Wnames(DLOAD_DLLNUM) = {DLOAD_DLLNAMES}



extern "windows-ms"
  UndefAllParams()
  #define P1 lpModuleName as LPCSTR
  function _GetModuleHandleA alias "GetModuleHandleA"(P1) as HMODULE export
      return GetModuleHandleA(lpModuleName)
  end function

  UndefAllParams()
  #define P1 lpModuleName as LPCWSTR
  function _GetModuleHandleW alias "GetModuleHandleW"(P1) as HMODULE export
      return GetModuleHandleW(lpModuleName)
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExA alias "GetModuleHandleExA"(P1, P2, P3) as BOOL export
      return GetModuleHandleExA(dwFlags, lpModuleName, phModule)
  end function

  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 lpModuleName as LPCWSTR
  #define P3 phModule as HMODULE ptr
  function _GetModuleHandleExW alias "GetModuleHandleExW"(P1, P2, P3) as BOOL export
      return GetModuleHandleExW(dwFlags, lpModuleName, phModule)
  end function

  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  function _LoadLibraryA alias "LoadLibraryA"(P1) as HMODULE export
      return LoadLibraryA(lpFileName)
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  function _LoadLibraryW alias "LoadLibraryW"(P1) as HMODULE export
      return LoadLibraryW(lpFileName)
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExA alias "LoadLibraryExA"(P1, P2, P3) as HMODULE export
      return LoadLibraryExA(lpFileName, hFile, dwFlags)
  end function
  
  UndefAllParams()
  #define P1 lpFileName as LPCWSTR
  #define P2 hFile as HANDLE
  #define P3 dwFlags as DWORD
  function _LoadLibraryExW alias "LoadLibraryExW"(P1, P2, P3) as HMODULE export
      return LoadLibraryExW(lpFileName, hFile, dwFlags)
  end function
end extern