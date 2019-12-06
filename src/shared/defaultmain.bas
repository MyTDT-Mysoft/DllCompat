#include "windows.bi"
#include "win\winbase.bi"
#include "includes\win\float.bi"
#include "helper.bas"

'These allow you to encase functions in extern "windows-ms"
#undef DllGetClassObject
#undef DllCanUnloadNow
#undef DllUnregisterServer
#undef DllRegisterServer

'available defines: ENABLE_THREADCALLS, CUSTOM_MAIN
'be sure to call renamed DLLMAIN from your own, when using CUSTOM_MAIN

#ifdef CUSTOM_MAIN
  #define _MAINNAME DLLMAIN_DEFAULT
#else
  #define _MAINNAME DLLMAIN
#endif

declare function fbMain alias "DllMainCRTStartup" (handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as integer

extern "windows-ms"
  function _MAINNAME(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as HRESULT
    select case uReason
      case DLL_PROCESS_ATTACH
        dim as DWORD fpuState = _controlfp(0, 0)
        dim as integer ret = fbMain(handle, uReason, Reserved)
        #ifndef ENABLE_THREADCALLS
          DisableThreadLibraryCalls(handle)
        #endif
        _controlfp(fpuState, &hFFFFFFFF)
        return ret
      case DLL_PROCESS_DETACH
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select
    return fbMain(handle, uReason, Reserved)
  end function
end extern