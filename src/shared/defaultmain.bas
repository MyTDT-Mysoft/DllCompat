#include "windows.bi"
#include "win\winbase.bi"
#include "includes\win\float.bi"
#include "helper.bas"

declare function fbMain alias "DllMainCRTStartup" (handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as integer

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as integer
    dim as integer ret
    select case uReason
      case DLL_PROCESS_ATTACH
        '_fpreset()
        'dim fpuState as DWORD = _control87(0, 0) 
        '_control87(fpuState, &hFFFF)
        'DisableThreadLibraryCalls(handle)
      case DLL_PROCESS_DETACH
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select
    return fbMain(handle, uReason, Reserved)
  end function
end extern