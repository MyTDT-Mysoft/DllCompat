#define fbc -dll -Wl "iphlpapx.dll.def" -x ..\..\..\bin\dll\iphlpapx.dll -i ..\..\

#include "windows.bi"
#include "win\iphlpapi.bi"
'#include "win\netioapi.bi" 'needed NETIO_STATUS definition not available to pre-v6 winNT. Jerks.
#include "shared\helper.bas"

type NETIO_STATUS as DWORD

extern "windows-ms"
  UndefAllParams()
  #define P1 InterfaceIndex as NET_IFINDEX
  #define P2 InterfaceLuid as PNET_LUID
  function ConvertInterfaceIndexToLuid(P1, P2) as NETIO_STATUS export
    return 0
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as const NET_LUID ptr
  #define P2 InterfaceIndex as PNET_IFINDEX
  function ConvertInterfaceLuidToIndex(P1, P2) as NETIO_STATUS export
    return 0
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as const NET_LUID ptr
  #define P2 InterfaceName as PSTR
  #define P3 Length as SIZE_T
  function ConvertInterfaceLuidToNameA(P1, P2, P3) as NETIO_STATUS export
    return 0
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as const NET_LUID ptr
  #define P2 InterfaceName as PWSTR
  #define P3 Length as SIZE_T
  function ConvertInterfaceLuidToNameW(P1, P2, P3) as NETIO_STATUS export
    return 0
  end function
  
  UndefAllParams()
  #define P1 InterfaceName as const CHAR ptr
  #define P2 InterfaceLuid as PNET_LUID
  function ConvertInterfaceNameToLuidA(P1, P2) as NETIO_STATUS export
    return 0
  end function
  
  UndefAllParams()
  #define P1 InterfaceName as const WCHAR ptr
  #define P2 InterfaceLuid as PNET_LUID
  function ConvertInterfaceNameToLuidW(P1, P2) as NETIO_STATUS export
    return 0
  end function
end extern