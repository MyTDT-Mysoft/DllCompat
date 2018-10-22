#define fbc -dll -Wl "avrt.dll.def" -x ..\..\..\bin\dll\avrt.dll -i ..\..\

#include "windows.bi"
#include "includes\win\avrt.bi"
#include "includes\win\extraerrs.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 AvrtHandle                as _In_  HANDLE
  #define P2 SystemResponsivenessValue as _Out_ PULONG
  function AvQuerySystemResponsiveness(AvrtHandle as HANDLE, SystemResponsivenessValue as PULONG) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 AvrtHandle as _In_ HANDLE
  function AvRevertMmThreadCharacteristics(P1) as BOOL
    return 1
  end function
  
  UndefAllParams()
  #define P1 Context            as _Out_    PHANDLE
  #define P2 Period             as _In_     PLARGE_INTEGER
  #define P3 ThreadOrderingGuid as _Inout_  GUID ptr
  #define P4 Timeout            as _In_opt_ PLARGE_INTEGER
  function AvRtCreateThreadOrderingGroup(P1, P2, P3, P4) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context            as _Out_    PHANDLE
  #define P2 Period             as _In_     PLARGE_INTEGER
  #define P3 ThreadOrderingGuid as _Inout_  GUID ptr
  #define P4 Timeout            as _In_opt_ PLARGE_INTEGER
  #define P5 TaskName           as _In_     LPCSTR
  function AvRtCreateThreadOrderingGroupExA(P1, P2, P3, P4, P5) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context            as _Out_    PHANDLE
  #define P2 Period             as _In_     PLARGE_INTEGER
  #define P3 ThreadOrderingGuid as _Inout_  GUID ptr
  #define P4 Timeout            as _In_opt_ PLARGE_INTEGER
  #define P5 TaskName           as _In_     LPCWSTR
  function AvRtCreateThreadOrderingGroupExW(P1, P2, P3, P4, P5) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as _In_ HANDLE
  function AvRtDeleteThreadOrderingGroup(P1) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context            as _Out_ PHANDLE
  #define P2 ThreadOrderingGuid as _In_  GUID ptr
  #define P3 Before             as _In_  BOOL
  function AvRtJoinThreadOrderingGroup(P1, P2, P3) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as _In_ HANDLE
  function AvRtLeaveThreadOrderingGroup(P1) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as _In_ HANDLE
  function AvRtWaitOnThreadOrderingGroup(P1) as BOOL
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 FirstTask  as _In_    LPCSTR
  #define P2 SecondTask as _In_    LPCSTR
  #define P3 TaskIndex  as _Inout_ LPDWORD
  function AvSetMmMaxThreadCharacteristicsA(P1, P2, P3) as HANDLE
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return null
  end function
  
  UndefAllParams()
  #define P1 FirstTask  as _In_    LPCWSTR
  #define P2 SecondTask as _In_    LPCWSTR
  #define P3 TaskIndex  as _Inout_ LPDWORD
  function AvSetMmMaxThreadCharacteristicsW(P1, P2, P3) as HANDLE
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return null
  end function
  
  UndefAllParams()
  #define P1 TaskName  as _In_    LPCWSTR
  #define P2 TaskIndex as _Inout_ LPDWORD
  function AvSetMmThreadCharacteristicsW(P1, P2) as HANDLE
    if not TaskName then
        SetLastError(ERROR_INVALID_TASK_NAME)
        return null
    endif
    if not TaskIndex then
        SetLastError(ERROR_INVALID_HANDLE)
        return null
    endif
    return cast(HANDLE, &h12345678)
  end function
  
  UndefAllParams()
  #define P1 TaskName  as _In_    LPCSTR
  #define P2 TaskIndex as _Inout_ LPDWORD
  function AvSetMmThreadCharacteristicsA(P1, P2) as HANDLE
    dim as HANDLE ret
    dim as LPWSTR strn = null
    if TaskName then
      dim as DWORD lenny = (lstrlenA(TaskName)+1)
      strn = HeapAlloc(GetProcessHeap(), 0, lenny*sizeof(WCHAR))
      if not strn then
        SetLastError(ERROR_OUTOFMEMORY)
        return null
      endif
      MultiByteToWideChar(CP_ACP, 0, TaskName, lenny, strn, lenny)
    endif
    ret = AvSetMmThreadCharacteristicsW(strn, TaskIndex)
    HeapFree(GetProcessHeap(), 0, strn)
    return ret
  end function
  
  UndefAllParams()
  #define P1 AvrtHandle as _In_ HANDLE
  #define P2 Priority   as _In_ AVRT_PRIORITY
  function AvSetMmThreadPriority(P1, P2) as BOOL
    return FALSE
  end function
end extern

#include "shared\defaultmain.bas"