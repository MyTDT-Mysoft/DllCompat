#define fbc -dll -Wl "ntdlx.dll.def" -i ..\..\ -x ..\..\..\bin\dll\ntdlx.dll

#include "windows.bi"
#include "win\winnt.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 crit as RTL_CRITICAL_SECTION ptr
  function RtlIsCriticalSectionLockedByThread(P1) as BOOL export
    return crit->OwningThread=ULongToHandle(GetCurrentThreadId()) andalso crit->RecursionCount
  end function
  
  UndefAllParams()
  #define P1 dwOSMajorVersion       as DWORD
  #define P2 dwOSMinorVersion       as DWORD
  #define P3 dwSpMajorVersion       as DWORD
  #define P4 dwSpMinorVersion       as DWORD
  #define P5 pdwReturnedProductType as PDWORD
  function RtlGetProductInfo(P1, P2, P3, P4, P5) as BOOL export
    if pdwReturnedProductType=NULL then return FALSE
    'PRODUCT_PROFESSIONAL_WMC
    *pdwReturnedProductType = PRODUCT_UNDEFINED
    
    return TRUE
  end function
end extern



  'RtlInitializeSRWLock
  'RtlReleaseSRWLockExclusive
  'RtlAcquireSRWLockExclusive
  'RtlReleaseSRWLockShared
  'RtlAcquireSRWLockShared
  'RtlSleepConditionVariableSRW










#include "shared\defaultmain.bas"