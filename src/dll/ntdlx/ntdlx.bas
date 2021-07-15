#define fbc -dll -Wl "ntdlx.dll.def" -i ..\..\ -x ..\..\..\bin\dll\ntdlx.dll

#include "windows.bi"
#define NTSTATUS DWORD
#include "win\ddk\ddk_ntstatus.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 KeyedEventHandle   as _In_ HANDLE
  #define P2 Key                as _In_ PVOID
  #define P3 Alertable          as _In_ BOOLEAN
  #define P4 Timeout            as _In_ PLARGE_INTEGER
  declare function NtWaitForKeyedEvent(P1, P2, P3, P4) as NTSTATUS
  
  UndefAllParams()
  #define P1 KeyedEventHandle   as _In_ HANDLE
  #define P2 Key                as _In_ PVOID
  #define P3 Alertable          as _In_ BOOLEAN
  #define P4 Timeout            as _In_ PLARGE_INTEGER
  declare function NtReleaseKeyedEvent(P1, P2, P3, P4) as NTSTATUS
end extern


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

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'InitOnce functions
  
  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  sub RtlRunOnceInitialize(P1) export
    ponce->Ptr = NULL
  end sub

  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  #define P2 flags                    as ULONG
  #define P3 context                  as any ptr ptr
  function RtlRunOnceBeginInitialize(P1, P2, P3) as DWORD export
    if flags and RTL_RUN_ONCE_CHECK_ONLY then
      dim as ULONG_PTR value = cast(ULONG_PTR, ponce->Ptr)
      
      if flags and RTL_RUN_ONCE_ASYNC then return STATUS_INVALID_PARAMETER
      if (value and 3) <> 2 then return STATUS_UNSUCCESSFUL
      if context then *context = cast(any ptr, value and (not 3))
      return STATUS_SUCCESS
    end if

    do
      dim as ULONG_PTR vnext, value = cast(ULONG_PTR, ponce->Ptr)
      
      select case (value and 3)
        case 0  'first time
          if 0=InterlockedCompareExchangePointer( @ponce->Ptr, _
                                                  cast(any ptr, iif(flags and RTL_RUN_ONCE_ASYNC, 3, 1)), 0 ) _
              then return STATUS_PENDING
              
        case 1  'in progress, wait
          if flags and RTL_RUN_ONCE_ASYNC then return STATUS_INVALID_PARAMETER
          vnext = value and (not 3)
          
          if InterlockedCompareExchangePointer( @ponce->Ptr, cast(any ptr, cast(ULONG_PTR, @vnext) or 1), _
                                                 cast(any ptr, value) ) = cast(any ptr, value) _
              then NtWaitForKeyedEvent( 0, @vnext, FALSE, NULL )
              
        case 2  'done
          if context then *context = cast(any ptr, value and (not 3))
          return STATUS_SUCCESS
        
        case 3  'in progress, async
          if 0=(flags and RTL_RUN_ONCE_ASYNC) then return STATUS_INVALID_PARAMETER
          return STATUS_PENDING
          
      end select
    loop
  end function

  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  #define P2 flags                    as ULONG
  #define P3 context                  as any ptr
  function RtlRunOnceComplete(P1, P2, P3) as DWORD export
    if cast(ULONG_PTR, context) and 3 then return STATUS_INVALID_PARAMETER
    
    if flags and RTL_RUN_ONCE_INIT_FAILED then
      if context then return STATUS_INVALID_PARAMETER
      if flags and RTL_RUN_ONCE_ASYNC then return STATUS_INVALID_PARAMETER
    else 
      context = cast(any ptr, cast(ULONG_PTR, context) or 2)
    end if
    
    do
      dim as ULONG_PTR value = cast(ULONG_PTR, ponce->Ptr)
    
      select case (value and 3)
        case 1  'in progress
          if InterlockedCompareExchangePointer( @ponce->Ptr, context, cast(any ptr, value) ) <> cast(any ptr, value) _
              then exit select
          value and= not 3
          while value
              dim as ULONG_PTR vnext = *cast(ULONG_PTR ptr, value)
              NtReleaseKeyedEvent( 0, cast(any ptr, value), FALSE, NULL )
              value = vnext
          wend
          return STATUS_SUCCESS
        
        case 3  'in progress, async
          if 0=(flags and RTL_RUN_ONCE_ASYNC) then return STATUS_INVALID_PARAMETER
          if InterlockedCompareExchangePointer( @ponce->Ptr, context, cast(any ptr, value) ) <> cast(any ptr, value) _
              then exit select
          return STATUS_SUCCESS
    
        case else
          return STATUS_UNSUCCESSFUL
          
      end select
    loop
  end function


  UndefAllParams()
  #define P1 ponce                    as RTL_RUN_ONCE ptr
  #define P2 func                     as PRTL_RUN_ONCE_INIT_FN
  #define P3 param                    as any ptr
  #define P4 context                  as any ptr ptr
  function RtlRunOnceExecuteOnce(P1, P2, P3, P4) as DWORD export
    dim as DWORD ret = RtlRunOnceBeginInitialize( ponce, 0, context )
    
    if ret <> STATUS_PENDING then return ret
    
    if 0=func( ponce, param, context ) then
      RtlRunOnceComplete( ponce, RTL_RUN_ONCE_INIT_FAILED, NULL )
      return STATUS_UNSUCCESSFUL
    end if
    
    return RtlRunOnceComplete( ponce, 0, iif(context, *context, NULL))
  end function
  
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SRW lock functions

  'RtlInitializeSRWLock
  'RtlReleaseSRWLockExclusive
  'RtlAcquireSRWLockExclusive
  'RtlReleaseSRWLockShared
  'RtlAcquireSRWLockShared
  'RtlSleepConditionVariableSRW
end extern













#include "shared\defaultmain.bas"