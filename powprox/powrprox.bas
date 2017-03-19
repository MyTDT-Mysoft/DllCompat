#define fbc -dll -x "powrprox.dll"
'-Wl "kernel3x.dll.def"

#include "windows.bi"

static shared as ubyte NullSchemeGuid(15)

extern "windows-ms"  
  function PowerGetActiveScheme(UserRootPowerKey as any ptr,ActivePolicyGuid as any ptr ptr) as DWORD export
    *ActivePolicyGuid = @NullSchemeGuid(0):return 0
  end function
  function PowerSetActiveScheme(UserRootPowerKey as any ptr,ActivePolicyGuid as any ptr ptr) as DWORD export
    return 0
  end function
end extern


