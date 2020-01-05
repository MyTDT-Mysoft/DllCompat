#pragma once

extern "windows-ms"
  UndefAllParams()
  #define P1 InterfaceGuid as const GUID ptr
  #define P2 InterfaceLuid as NET_LUID ptr
  declare function ConvertInterfaceGuidToLuid(P1, P2) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceIndex as _In_  NET_IFINDEX
  #define P2 InterfaceLuid  as _Out_ NET_LUID ptr
  declare function ConvertInterfaceIndexToLuid(P1, P2) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceLuid as const NET_LUID ptr
  #define P2 InterfaceGuid as GUID ptr
  declare function ConvertInterfaceLuidToGuid(P1, P2) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceLuid  as _In_  const NET_LUID ptr
  #define P2 InterfaceIndex as _Out_ PNET_IFINDEX
  declare function ConvertInterfaceLuidToIndex(P1, P2) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceLuid as _In_  const NET_LUID ptr
  #define P2 InterfaceName as _Out_ PSTR
  #define P3 Length        as _In_  SIZE_T
  declare function ConvertInterfaceLuidToNameA(P1, P2, P3) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceLuid as _In_  const NET_LUID ptr
  #define P2 InterfaceName as _Out_ PWSTR
  #define P3 Length        as _In_  SIZE_T
  declare function ConvertInterfaceLuidToNameW(P1, P2, P3) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceName as _In_  const CHAR ptr
  #define P2 InterfaceLuid as _Out_ NET_LUID ptr
  declare function ConvertInterfaceNameToLuidA(P1, P2) as NETIO_STATUS
  
  UndefAllParams()
  #define P1 InterfaceName as _In_  const WCHAR ptr
  #define P2 InterfaceLuid as _Out_ NET_LUID ptr
  declare function ConvertInterfaceNameToLuidW(P1, P2) as NETIO_STATUS
end extern