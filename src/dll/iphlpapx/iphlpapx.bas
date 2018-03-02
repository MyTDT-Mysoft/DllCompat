#define fbc -dll -Wl "iphlpapx.dll.def" -x ..\..\..\bin\dll\iphlpapx.dll -i ..\..\

#include "windows.bi"
#include "win\iphlpapi.bi"
'#include "win\netioapi.bi" 'needed NETIO_STATUS definition not available to pre-v6 winNT. Jerks.
#include "win\ifdef.bi"
#include "shared\helper.bas"
#include "includes\win\ifdef_fix.bi"

type NETIO_STATUS as DWORD

extern "windows-ms"
  UndefAllParams()
  #define P1 InterfaceIndex as NET_IFINDEX
  #define P2 InterfaceLuid as PNET_LUID
  function ConvertInterfaceIndexToLuid(P1, P2) as NETIO_STATUS export
    dim row as MIB_IFROW

    if InterfaceLuid=0 then
      return ERROR_INVALID_PARAMETER
    end if
    memset(InterfaceLuid, 0, sizeof(*InterfaceLuid))

    row.dwIndex = InterfaceIndex
    if GetIfEntry(@row)=0 then
      return ERROR_FILE_NOT_FOUND
    end if

    InterfaceLuid->Info.Reserved     = 0
    InterfaceLuid->Info.NetLuidIndex = InterfaceIndex
    InterfaceLuid->Info.IfType       = row.dwType
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as const NET_LUID ptr
  #define P2 InterfaceIndex as PNET_IFINDEX
  function ConvertInterfaceLuidToIndex(P1, P2) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW

    if InterfaceLuid=0 orelse InterfaceIndex=0 then
      return ERROR_INVALID_PARAMETER
    end if

    row.dwIndex = InterfaceLuid->Info.NetLuidIndex
    ret = GetIfEntry(@row)
    if ret then
      return ret
    end if
    
    *InterfaceIndex = InterfaceLuid->Info.NetLuidIndex
    return NO_ERROR
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