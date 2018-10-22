#define fbc -dll -Wl "ntdlx.dll.def" -i ..\..\ -x ..\..\..\bin\dll\ntdlx.dll

#include "windows.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 crit as RTL_CRITICAL_SECTION ptr
  function RtlIsCriticalSectionLockedByThread(P1) as BOOL export
    'HACK! Satisfies WineD3D, probably breaks other things.
    SleepEx(1, TRUE)
    return TRUE
    'return crit->OwningThread = ULongToHandle(GetCurrentThreadId()) andalso crit->RecursionCount
  end function
end extern

#include "shared\defaultmain.bas"