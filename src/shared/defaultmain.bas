#include "windows.bi"
#include "win\winbase.bi"
#include "includes\win\float.bi"

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