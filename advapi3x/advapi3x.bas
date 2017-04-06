#define fbc -dll -Wl "advapi3x.dll.def" -x ..\bin\advapi3x.dll

#include "windows.bi"
#include "crt.bi"

extern "windows-ms"
  #undef RegGetValueA
  function RegGetValueA( hkey as HKEY, lpSubKey as zstring ptr , lpValue as zstring ptr, dwFlags as DWORD, pdwType as LPDWORD, pvData as PVOID, pcbData as LPDWORD) as long export
    dim as zstring ptr pSub = cast(zstring ptr,iif(lpSubKey,lpSubKey,@"<null>"))
    dim as zstring ptr pVal = cast(zstring ptr,iif(lpValue,lpValue,@"<null>"))
    dim as zstring*256 zDebug
    sprintf(zDebug,!"RegGetValueA( *SubKey=%s , Value=%s , Flags% = 0x%08X )\r\n",pSub,pVal,dwFlags)
    OutputDebugString(zDebug)
    return ERROR_INVALID_PARAMETER
  end function
end extern

