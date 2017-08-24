#define fbc -dll -Wl "advapi3x.dll.def" -x ..\bin\advapi3x.dll

#include "windows.bi"
#include "crt.bi"
#include "..\MyTDT\detour.bas"

#define DebugFailedCalls
#define DebugBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONERROR)
#define NotifyBox(_MSG) Messagebox(null,_MSG,__FUNCTION__ ":" & __LINE__,MB_SYSTEMMODAL or MB_ICONWARNING)

#ifndef RRF_ZEROONFAILURE
  const RRF_ZEROONFAILURE = &h20000000
  const RRF_NOEXPAND      = &h10000000
#endif

extern "windows-ms"
  #undef RegGetValueA
  
  UndefAllParams()
  #define P1 hkey as HKEY
  #define P2 lpSubKey as zstring ptr
  #define P3 lpValue as zstring ptr
  #define P4 dwFlags as DWORD
  #define P5 pdwType as LPDWORD
  #define P6 pvData as PVOID
  #define P7 pcbData as LPDWORD  
  function RegGetValueA( P1 , P2 , P3 , P4 , P5 , P6 , P7 ) as long export
    dim as zstring ptr pSub = cast(zstring ptr,iif(lpSubKey,lpSubKey,@"<null>"))
    dim as zstring ptr pVal = cast(zstring ptr,iif(lpValue,lpValue,@"<null>"))
    dim as zstring*256 zDebug
    sprintf(zDebug,!"RegGetValueA( *SubKey=%s , Value=%s , Flags% = 0x%08X )\r\n",pSub,pVal,dwFlags)
    OutputDebugString(zDebug)
    return ERROR_INVALID_PARAMETER
  end function
  
  UndefAllParams()
  #undef RegGetValuew  
  #define P1 hKey as HKEY
  #define P2 lpSubKey as lpwstr
  #define P3 lpValue as lpwstr
  #define P4 dwFlags as DWORD
  #define P5 pdwType as LPDWORD
  #define P6 pvData as PVOID
  #define P7 pcbData as LPDWORD  
  function RegGetValueW( P1 , P2 , P3 , P4 , P5 , P6 , P7 ) as long export
    DebugBox("Yay!")
    dim as HKEY hSubKey = null
    if lpSubKey andalso lpSubKey[0]<>null then 'want subkey so opening it...
      var iResu = RegOpenKeyW( hKey , lpSubKey , @hSubKey )      
      if iResu <> ERROR_SUCCESS then 
        #ifdef DebugFailedCalls
          DebugBox( "RegOpenKeyW failed Error: 0x"+hex$(iResu) )
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
        DebugBox( "RegQueryValueExW failed Error: 0x"+hex$(iResu) )
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
end extern

