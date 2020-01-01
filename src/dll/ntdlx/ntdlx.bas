#define fbc -dll -Wl "ntdlx.dll.def" -i ..\..\ -x ..\..\..\bin\dll\ntdlx.dll

#include "windows.bi"
#include "win\winnt.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 Destination as _Inout_ LONGLONG ptr
  #define P2 Exchange    as _In_    LONGLONG
  #define P3 Comparand   as _In_    LONGLONG
  function RtlInterlockedCompareExchange64 naked(P1, P2, P3) as LONGLONG export
    #define Destination_ esp+12
    #define Exchange_ esp+16
    #define Comparand_ esp+24
    asm
      push ebx
      push ebp
      mov ebp,[Destination_]
      mov ebx,[Exchange_+0]
      mov ecx,[Exchange_+4]
      mov eax,[Comparand_+0]
      mov edx,[Comparand_+4]
      lock cmpxchg8b [ebp]
      pop ebp
      pop ebx
      ret 20
    end asm        
  end function
  
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