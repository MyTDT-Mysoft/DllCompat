#define fbc -dll -Wl "iphlpapx.dll.def" -i ..\..\ -x ..\..\..\bin\dll\iphlpapx.dll 

#include "windows.bi"
#include "win\winbase.bi"
#include "win\iphlpapi.bi"
#include "win\ifdef.bi"
#include "includes\win\fix_netioapi.bi"
#include "includes\win\fix_ifdef.bi"
#include "shared\helper.bas"

#include "includes\win\dll_iphlpapx.bi"

function getRowByName(InterfaceName as const WCHAR ptr, prow as PMIB_IFROW) as DWORD
  dim iftSize as ULONG = 0
  dim pift as PMIB_IFTABLE
  dim ret as DWORD
  dim nameLen as int
  
  if InterfaceName=NULL  then return ERROR_INVALID_PARAMETER
  nameLen = lstrlenW(InterfaceName)
  if nameLen+1 > MAX_INTERFACE_NAME_LEN then return ERROR_INVALID_NAME
  
  ret = GetIfTable(NULL, @iftSize, FALSE) : if ret<>ERROR_INSUFFICIENT_BUFFER then return ret
  pift = GlobalAlloc(GMEM_FIXED, iftSize) : if pift=NULL then return ERROR_NOT_ENOUGH_MEMORY
  ret = GetIfTable(NULL, @iftSize, FALSE) : if ret<>NO_ERROR then
    GlobalFree(pift)
    return ret
  end if
  
  for i as int = 0 to pift->dwNumEntries-1
    if lstrcmpW(InterfaceName, pift->table(i).wszName)=0 then
      *prow = pift->table(i)
      ret = NO_ERROR
      exit for
    end if
  next
  
  GlobalFree(pift)
  return ret
end function




extern "windows-ms"
  UndefAllParams()
  #define P1 InterfaceGuid as const GUID ptr
  #define P2 InterfaceLuid as NET_LUID ptr
  function ConvertInterfaceGuidToLuid(P1, P2) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW
    
    if InterfaceGuid=NULL orelse InterfaceLuid=NULL then return ERROR_INVALID_PARAMETER
    
    row.dwIndex = InterfaceGuid->Data1
    ret = GetIfEntry(@row) : if ret<>NO_ERROR then return ret
    
    'WARN: improvisation; see ConvertInterfaceLuidToGuid
    InterfaceLuid->Info.Reserved = 0
    InterfaceLuid->Info.NetLuidIndex = InterfaceGuid->Data1
    InterfaceLuid->Info.IfType = row.dwType
    
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceIndex as _In_  NET_IFINDEX
  #define P2 InterfaceLuid  as _Out_ NET_LUID ptr
  declare function ciitl(P1, P2) as NETIO_STATUS
  function ConvertInterfaceIndexToLuid(P1, P2) as NETIO_STATUS export
    dim row as MIB_IFROW
    
    if InterfaceLuid=NULL then return ERROR_INVALID_PARAMETER
    ZeroMemory(InterfaceLuid, sizeof(NET_LUID))
    
    row.dwIndex = InterfaceIndex
    if GetIfEntry(@row)=0 then return ERROR_FILE_NOT_FOUND
    
    InterfaceLuid->Info.Reserved = 0
    InterfaceLuid->Info.NetLuidIndex = InterfaceIndex
    InterfaceLuid->Info.IfType = row.dwType
    
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as const NET_LUID ptr
  #define P2 InterfaceGuid as GUID ptr
  function ConvertInterfaceLuidToGuid(P1, P2) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW
    
    if InterfaceLuid=NULL orelse InterfaceGuid=NULL then return ERROR_INVALID_PARAMETER

    row.dwIndex = InterfaceLuid->Info.NetLuidIndex
    ret = GetIfEntry(@row) : if ret<>NO_ERROR then return ret

    ZeroMemory(InterfaceGuid, sizeof(GUID))
    'WARN: improvisation
    'MIB_IFROW.dwIndex: This index value may change when a network adapter is disabled and then enabled, and should not be considered persistent
    'this very likely also applies to NET_LUID.NetLuidIndex
    InterfaceGuid->Data1 = InterfaceLuid->Info.NetLuidIndex
    
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid  as _In_  const NET_LUID ptr
  #define P2 InterfaceIndex as _Out_ PNET_IFINDEX
  function ConvertInterfaceLuidToIndex(P1, P2) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW

    if InterfaceLuid=NULL orelse InterfaceIndex=NULL then return ERROR_INVALID_PARAMETER

    row.dwIndex = InterfaceLuid->Info.NetLuidIndex
    ret = GetIfEntry(@row) : if ret<>NO_ERROR then return ret
    
    *InterfaceIndex = InterfaceLuid->Info.NetLuidIndex
    
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as _In_  const NET_LUID ptr
  #define P2 InterfaceName as _Out_ PSTR
  #define P3 Length        as _In_  SIZE_T
  function ConvertInterfaceLuidToNameA(P1, P2, P3) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW

    if InterfaceLuid=NULL orelse InterfaceName=NULL then return ERROR_INVALID_PARAMETER

    row.dwIndex = InterfaceLuid->Info.NetLuidIndex
    ret = GetIfEntry(@row) : if ret<>NO_ERROR then return ret 
    
    if Length < lstrlenW(row.wszName)+1 then return ERROR_NOT_ENOUGH_MEMORY
    ret = WideCharToMultiByte(CP_ACP, WC_COMPOSITECHECK, @row.wszName, -1, InterfaceName, Length, NULL, NULL) : if ret<>0 then return ret
    
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceLuid as _In_  const NET_LUID ptr
  #define P2 InterfaceName as _Out_ PWSTR
  #define P3 Length        as _In_  SIZE_T
  function ConvertInterfaceLuidToNameW(P1, P2, P3) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW

    if InterfaceLuid=NULL orelse InterfaceName=NULL then return ERROR_INVALID_PARAMETER

    row.dwIndex = InterfaceLuid->Info.NetLuidIndex
    ret = GetIfEntry(@row)
    DEBUG_MsgTrace("return %d, index %d", ret, row.dwIndex)
    if ret<>NO_ERROR then return ret

    if Length < lstrlenW(row.wszName)+1 then return ERROR_NOT_ENOUGH_MEMORY
    lstrcpyW(InterfaceName, row.wszName)
    
    return NO_ERROR
  end function
  
  UndefAllParams()
  #define P1 InterfaceName as _In_  const CHAR ptr
  #define P2 InterfaceLuid as _Out_ NET_LUID ptr
  function ConvertInterfaceNameToLuidA(P1, P2) as NETIO_STATUS export
    dim ifaceName as wstring*MAX_INTERFACE_NAME_LEN
    dim ret as DWORD
    dim row as MIB_IFROW
    dim nameLen as int
    
    if InterfaceName=NULL orelse InterfaceLuid=NULL then return ERROR_INVALID_PARAMETER
    
    nameLen = lstrlenA(InterfaceName)
    if nameLen+1 > MAX_INTERFACE_NAME_LEN then return ERROR_INVALID_NAME
    MultiByteToWideChar(CP_ACP, 0, InterfaceName, -1, @ifaceName, nameLen+1)
    
    ret = getRowByName(@ifaceName, @row) : if ret<>NO_ERROR then return ret
    ret = ConvertInterfaceIndexToLuid(row.dwIndex, InterfaceLuid)
    
    return ret
  end function
  
  UndefAllParams()
  #define P1 InterfaceName as _In_  const WCHAR ptr
  #define P2 InterfaceLuid as _Out_ NET_LUID ptr
  function ConvertInterfaceNameToLuidW(P1, P2) as NETIO_STATUS export
    dim ret as DWORD
    dim row as MIB_IFROW
    dim nameLen as int
    
    if InterfaceLuid=NULL then return ERROR_INVALID_PARAMETER
    
    ret = getRowByName(InterfaceName, @row) : if ret<>NO_ERROR then return ret
    ret = ConvertInterfaceIndexToLuid(row.dwIndex, InterfaceLuid)
    
    return ret
  end function
end extern

#include "shared\defaultmain.bas"