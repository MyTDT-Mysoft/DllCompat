#pragma once
'Multimedia class scheduler API definitions

#define THREAD_ORDER_GROUP_INFINITE_TIMEOUT (-1LL)

enum _AVRT_PRIORITY
  AVRT_PRIORITY_LOW = -1
  AVRT_PRIORITY_NORMAL
  AVRT_PRIORITY_HIGH
  AVRT_PRIORITY_CRITICAL
end enum
type AVRT_PRIORITY as _AVRT_PRIORITY
type PAVRT_PRIORITY as _AVRT_PRIORITY ptr

extern "windows-ms"
  declare function AvQuerySystemResponsiveness(byval as HANDLE, byval as PULONG) as BOOL
  declare function AvRevertMmThreadCharacteristics(byval as HANDLE) as BOOL
  declare function AvRtCreateThreadOrderingGroup(byval as PHANDLE, byval as PLARGE_INTEGER, byval as GUID ptr, byval as PLARGE_INTEGER) as BOOL
  declare function AvRtCreateThreadOrderingGroupExA(byval as PHANDLE, byval as PLARGE_INTEGER, byval as GUID ptr, byval as PLARGE_INTEGER, byval as LPCSTR) as BOOL
  declare function AvRtCreateThreadOrderingGroupExW(byval as PHANDLE, byval as PLARGE_INTEGER, byval as GUID ptr, byval as PLARGE_INTEGER, byval as LPCWSTR) as BOOL
  declare function AvRtDeleteThreadOrderingGroup(byval as HANDLE) as BOOL
  declare function AvRtJoinThreadOrderingGroup(byval as PHANDLE, byval as GUID ptr, byval as BOOL) as BOOL
  declare function AvRtLeaveThreadOrderingGroup(byval as HANDLE) as BOOL
  declare function AvRtWaitOnThreadOrderingGroup(byval as HANDLE) as BOOL
  declare function AvSetMmMaxThreadCharacteristicsA(byval as LPCSTR, byval as LPCSTR, byval as LPDWORD) as HANDLE
  declare function AvSetMmMaxThreadCharacteristicsW(byval as LPCWSTR, byval as LPCWSTR, byval as LPDWORD) as HANDLE
  declare function AvSetMmThreadCharacteristicsA(byval as LPCSTR, byval as LPDWORD) as HANDLE
  declare function AvSetMmThreadCharacteristicsW(byval as LPCWSTR, byval as LPDWORD) as HANDLE
  declare function AvSetMmThreadPriority(byval as HANDLE, byval as AVRT_PRIORITY) as BOOL
end extern