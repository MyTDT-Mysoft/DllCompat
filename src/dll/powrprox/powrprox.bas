#define fbc -dll -x ..\..\bin\dll\powrporx.dll -i ..\..\
'-Wl "powrporx.dll.def"

#include "windows.bi"
#include "shared\helper.bas"

static shared NullSchemeGuid as GUID

extern "windows-ms"
  UndefAllParams()
  #define P1 UserRootPowerKey as _In_opt_ HKEY
  #define P2 ActivePolicyGuid as _Out_    GUID ptr ptr
  function PowerGetActiveScheme(P1, P2) as DWORD export
    *ActivePolicyGuid = @NullSchemeGuid
    return 0
  end function
  
  UndefAllParams()
  #define P1 UserRootPowerKey as _In_opt_ HKEY
  #define P2 SchemeGuid       as _In_     const GUID ptr
  function PowerSetActiveScheme(P1, P2) as DWORD export
    return 0
  end function
end extern

#include "shared\defaultmain.bas"