#define fbc -dll -Wl "comdlg3x.dll.def" -x ..\..\bin\dll\comdlg3x.dll -i ..\..\

#include "windows.bi"
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
  
  UndefAllParams()
  #define P1 hinstDLL    as HINSTANCE
  #define P2 fdwReason   as DWORD
  #define P3 lpvReserved as LPVOID
  function DllMain(P1, P2, P3) alias "DllMain" as BOOL
    select case(fdwReason)
     case DLL_PROCESS_ATTACH
       __main()
       fb_Init(0, NULL, 0)
       DEBUG_MsgTrace("Dll attached.");
     case DLL_PROCESS_DETACH
     case DLL_THREAD_ATTACH
     case DLL_THREAD_DETACH
    end select

    return 1
 end function
end extern