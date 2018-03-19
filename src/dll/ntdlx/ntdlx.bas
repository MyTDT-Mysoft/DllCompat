#define fbc -dll -Wl "ntdlx.dll.def" -i ..\..\ -x ..\..\..\bin\dll\ntdlx.dll

#include "windows.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 crit as RTL_CRITICAL_SECTION ptr
  function RtlIsCriticalSectionLockedByThread(P1) as BOOL export
    return crit->OwningThread = ULongToHandle(GetCurrentThreadId()) andalso crit->RecursionCount
  end function
end extern