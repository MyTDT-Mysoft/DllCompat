#define fbc -dll -Wl "avrt.dll.def" -x ..\..\..\bin\dll\avrt.dll -i ..\..\

#include "windows.bi"
#include "shared\helper.bas"
#include "includes\win\avrt.bi"
#include "includes\win\extraerrs.bi"

extern "windows-ms"
  UndefAllParams()
  #define P1 AvrtHandle as HANDLE
  #define P2 SystemResponsivenessValue as PULONG
  function AvQuerySystemResponsiveness(AvrtHandle as HANDLE, SystemResponsivenessValue as PULONG) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 AvrtHandle as HANDLE
  function AvRevertMmThreadCharacteristics(P1) as BOOL
    return 1
  end function
  
  UndefAllParams()
  #define P1 Context as PHANDLE
  #define P2 Period as PLARGE_INTEGER
  #define P3 ThreadOrderingGuid as GUID ptr
  #define P4 Timeout as PLARGE_INTEGER
  function AvRtCreateThreadOrderingGroup(P1, P2, P3, P4) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as PHANDLE
  #define P2 Period as PLARGE_INTEGER
  #define P3 ThreadOrderingGuid as GUID ptr
  #define P4 Timeout as PLARGE_INTEGER
  #define P5 TaskName as LPCSTR
  function AvRtCreateThreadOrderingGroupExA(P1, P2, P3, P4, P5) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as PHANDLE
  #define P2 Period as PLARGE_INTEGER
  #define P3 ThreadOrderingGuid as GUID ptr
  #define P4 Timeout as PLARGE_INTEGER
  #define P5 TaskName as LPCWSTR
  function AvRtCreateThreadOrderingGroupExW(P1, P2, P3, P4, P5) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as HANDLE
  function AvRtDeleteThreadOrderingGroup(P1) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as PHANDLE
  #define P2 ThreadOrderingGuid as GUID ptr
  #define P3 Before as BOOL
  function AvRtJoinThreadOrderingGroup(P1, P2, P3) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as HANDLE
  function AvRtLeaveThreadOrderingGroup(P1) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Context as HANDLE
  function AvRtWaitOnThreadOrderingGroup(P1) as BOOL
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 FirstTask as LPCSTR
  #define P2 SecondTask as LPCSTR
  #define P3 TaskIndex as LPDWORD
  function AvSetMmMaxThreadCharacteristicsA(P1, P2, P3) as HANDLE
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return null
  end function
  
  UndefAllParams()
  #define P1 FirstTask as LPCWSTR
  #define P2 SecondTask as LPCWSTR
  #define P3 TaskIndex as LPDWORD
  function AvSetMmMaxThreadCharacteristicsW(P1, P2, P3) as HANDLE
    UnimplementedFunction()
    SetLastError(ERROR_OUT_OF_PAPER)
    return null
  end function
  
  UndefAllParams()
  #define P1 TaskName as LPCSTR
  #define P2 TaskIndex as LPDWORD
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
  #define P1 TaskName as LPCWSTR
  #define P2 TaskIndex as LPDWORD
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
  #define P1 AvrtHandle as HANDLE
  #define P2 Priority as AVRT_PRIORITY
  function AvSetMmThreadPriority(P1, P2) as BOOL
    return FALSE
  end function
end extern