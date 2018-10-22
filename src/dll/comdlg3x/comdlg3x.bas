#define fbc -dll -Wl "comdlg3x.dll.def" -x ..\..\bin\dll\comdlg3x.dll -i ..\..\

#include "windows.bi"
#include "includes\win\float.bi"
#include "shared\helper.bas"

extern "windows-ms"

  UndefAllParams()
  #define P1 rclsid as REFCLSID
  #define P2 riid   as REFIID
  #define P3 ppv    as LPVOID ptr
  function DllGetClassObject(P1, P2, P3) as HRESULT export
    *ppv = NULL
    return CLASS_E_CLASSNOTAVAILABLE
  end function
  
  UndefAllParams()
  function DllCanUnloadNow() as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  function DllRegisterServer() as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  function DllUnregisterServer() as HRESULT export
    return S_OK
  end function
end extern

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as integer
    select case uReason
      case DLL_PROCESS_ATTACH
        dim fpuState as DWORD = _control87(0, 0)
        fb_Init(0, NULL, 0)
        _control87(fpuState, &hFFFF)
        DisableThreadLibraryCalls(handle)
      case DLL_PROCESS_DETACH
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select     
    return 1
  end function
end extern