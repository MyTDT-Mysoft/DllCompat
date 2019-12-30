#define fbc -dll -Wl "advapi3x.dll.def" -x ..\..\bin\dll\advapi3x.dll -i ..\..\

#include "windows.bi"
#include "crt.bi"
#include "shared\helper.bas"

#define DebugFailedCalls
#define DebugBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONERROR)
#define NotifyBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONWARNING)

#ifndef RRF_ZEROONFAILURE
  const RRF_ZEROONFAILURE = &h20000000
  const RRF_NOEXPAND      = &h10000000
#endif

extern "windows-ms"
  UndefAllParams()
  #define P1 hkey     as _In_        HKEY
  #define P2 lpSubKey as _In_opt_    LPCSTR
  #define P3 lpValue  as _In_opt_    LPCSTR
  #define P4 dwFlags  as _In_opt_    DWORD
  #define P5 pdwType  as _Out_opt_   LPDWORD
  #define P6 pvData   as _Out_opt_   PVOID
  #define P7 pcbData  as _Inout_opt_ LPDWORD
  #undef RegGetValueA
  function RegGetValueA(P1, P2, P3, P4, P5, P6, P7) as LONG export
    dim as zstring ptr pSub = cast(zstring ptr,iif(lpSubKey,lpSubKey,@"<null>"))
    dim as zstring ptr pVal = cast(zstring ptr,iif(lpValue,lpValue,@"<null>"))
    dim as zstring*256 zDebug
    sprintf(zDebug,!"RegGetValueA( *SubKey=%s , Value=%s , Flags% = 0x%08X )\r\n",pSub,pVal,dwFlags)
    OutputDebugString(zDebug)
    return ERROR_INVALID_PARAMETER
  end function
  
  UndefAllParams()
  #define P1 hKey     as _In_        HKEY
  #define P2 lpSubKey as _In_opt_    LPCWSTR
  #define P3 lpValue  as _In_opt_    LPCWSTR
  #define P4 dwFlags  as _In_opt_    DWORD
  #define P5 pdwType  as _Out_opt_   LPDWORD
  #define P6 pvData   as _Out_opt_   PVOID
  #define P7 pcbData  as _Inout_opt_ LPDWORD  
  #undef RegGetValueW 
  function RegGetValueW(P1 , P2 , P3 , P4 , P5 , P6 , P7) as LONG export
    DebugBox("Yay!")
    dim as HKEY hSubKey = null
    if lpSubKey andalso lpSubKey[0]<>null then 'want subkey so opening it...
      var iResu = RegOpenKeyW( hKey , lpSubKey , @hSubKey )      
      if iResu <> ERROR_SUCCESS then 
        #ifdef DebugFailedCalls
          DebugBox( "RegOpenKeyW failed Error: 0x"+hex(iResu) )
        #endif
        if pvData andalso (dwFlags and RRF_ZEROONFAILURE) then
          memset( pvData , 0 , *pcbData )
        end if
        return iResu 'failed to open subkey...
      end if
      hKey = hSubKey
    end if
    
    if (dwFlags and RRF_NOEXPAND) then NotifyBox("RRF_NOEXPAND flag specified...")
    
    dim as DWORD dwType = 0, dwDataSz
    var iResu = RegQueryValueExW( hKey , lpValue , NULL , @dwType , pvData , @dwDataSz )
    if hSubKey then RegCloseKey( hKey )    
    if pdwType then *pdwType = dwType
    if pcbData then *pcbData = dwType else if pvData then iResu = ERROR_INVALID_PARAMETER
    
    if iResu <> ERROR_SUCCESS then
      #ifdef DebugFailedCalls
        DebugBox( "RegQueryValueExW failed Error: 0x"+hex(iResu) )
      #endif
      if pvData andalso (dwFlags and RRF_ZEROONFAILURE) then
        memset( pvData , 0 , *pcbData )
      end if      
      return iResu
    end if    
    
    #define CheckFlag(_A,_B) (dwFlags and (_A)) andalso dwType=(_B)
    do
      if (dwFlags and RRF_RT_ANY)=RRF_RT_ANY then exit do 'any value so whatever :)
      if CheckFlag(RRF_RT_REG_DWORD    ,REG_DWORD    ) then exit do
      if CheckFlag(RRF_RT_REG_SZ       ,REG_SZ       ) then exit do
      if CheckFlag(RRF_RT_REG_BINARY   ,REG_BINARY   ) then exit do
      if CheckFlag(RRF_RT_REG_EXPAND_SZ,REG_EXPAND_SZ) then exit do
      if CheckFlag(RRF_RT_REG_MULTI_SZ ,REG_MULTI_SZ ) then exit do
      if CheckFlag(RRF_RT_REG_NONE     ,REG_NONE     ) then exit do
      if CheckFlag(RRF_RT_REG_QWORD    ,REG_QWORD    ) then exit do      
      'All acceptable types failed...
      return ERROR_FILE_NOT_FOUND
    loop
    
    'TODO: !Must do Null check!
    if pvData then
      select case dwType
      case REG_SZ, REG_EXPAND_SZ
        if dwDataSz>2 andalso *cptr(ushort ptr,pvData+dwDataSz-2)<>0 then        
          *cptr(ushort ptr,pvData+dwDataSz)=0: *pcbData += 2
        end if
      case REG_MULTI_SZ        
        if dwDataSz<4 orelse *cptr(ulong ptr,pvData+dwDataSz-4)<>0 then
          if dwDataSz <2 orelse *cptr(ushort ptr,pvData+dwDataSz-2)<>0 then
              *cptr(ulong ptr,pvData+dwDataSz)=0: *pcbData += 4
          else
              *cptr(ushort ptr,pvData+dwDataSz-2)=0: *pcbData += 2
          end if
        end if        
      end select
    end if
    
    return iResu
  end function
  
  UndefAllParams()
  #define P1 hKey       as HKEY
  #define P2 lpSubKey   as LPCSTR
  #define P3 samDesired as REGSAM
  #define P4 Reserved   as DWORD
  function fnRegDeleteKeyExA alias "RegDeleteKeyExA"(P1, P2, P3, P4) as LSTATUS export
    if samDesired and KEY_WOW64_32KEY then
      return RegDeleteKeyA(hKey, lpSubKey)
    end if
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hKey       as HKEY
  #define P2 lpSubKey   as LPCWSTR
  #define P3 samDesired as REGSAM
  #define P4 Reserved   as DWORD
  function fnRegDeleteKeyExW alias "RegDeleteKeyExW"(P1, P2, P3, P4) as LSTATUS export
    if samDesired and KEY_WOW64_32KEY then
      return RegDeleteKeyW(hKey, lpSubKey)
    end if
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hKey         as _In_      HKEY
  #define P2 pszValue     as _In_opt_  LPCWSTR
  #define P3 pszOutBuf    as _Out_opt_ LPWSTR
  #define P4 cbOutBuf     as _In_      DWORD
  #define P5 pcbData      as _Out_opt_ LPDWORD
  #define P6 Flags        as _In_      DWORD
  #define P7 pszDirectory as _In_opt_  LPCWSTR
  #undef RegLoadMUIStringW
  function RegLoadMUIStringW(P1, P2, P3, P4, P5, P6, P7) as long export
    NotifyBox( "RegLoadMUIStringW" )
    return ERROR_CALL_NOT_IMPLEMENTED
  end function
  
end extern

#include "shared\defaultmain.bas"