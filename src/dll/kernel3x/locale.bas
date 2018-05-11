extern "windows-ms"
  UndefAllParams()
  #define P1 lpLocaleName  as _Out_ LPWSTR
  #define P2 cchLocaleName as _In_  int
  function GetSystemDefaultLocaleName(P1, P2) as int export
    if lpLocaleName=null or cchLocaleName <= 1 then
      SetLastError(ERROR_INSUFFICIENT_BUFFER): return 0
    end if
    dim as wstring*85 wLocale = any
    var iPos = GetLocaleInfoW(LOCALE_SYSTEM_DEFAULT, LOCALE_SISO639LANGNAME,@wLocale, 32)
    if iPos = 0 or iPos > cchLocaleName then
      SetLastError(ERROR_INSUFFICIENT_BUFFER): return 0
    end if
    wLocale[iPos-1] = asc("-")
    var iPos2 = GetLocaleInfoW(LOCALE_SYSTEM_DEFAULT,LOCALE_SISO3166CTRYNAME,@wLocale+iPos,16)
    iPos += iPos2
    if iPos2 = 0 or iPos > cchLocaleName then
      SetLastError(ERROR_INSUFFICIENT_BUFFER): return 0
    end if
    return iPos
  end function
  
  UndefAllParams()
  #define P1 lpLocaleName         as _In_opt_  LPCWSTR
  #define P2 dwMapFlags           as _In_      DWORD
  #define P3 lpSrcStr             as _In_      LPCWSTR
  #define P4 cchSrc               as _In_      int
  #define P5 lpDestStr            as _Out_opt_ LPWSTR
  #define P6 cchDest              as _In_      int
  #define P7 lpVersionInformation as _In_opt_  LPNLSVERSIONINFO
  #define P8 lpReserved           as _In_opt_  LPVOID
  #define P9 sortHandle           as _In_opt_  LPARAM
  function LCMapStringEx(P1,P2,P3,P4,P5,P6,P7,P8,P9) as int export
    select case lpLocaleName
    case NULL      
      DEBUG_MsgTrace("User Default Locale")
    case else
      DEBUG_MsgTrace("Locale:'%ls'",lpLocaleName)
    end select
    'DEBUG_AlertNotImpl()
    'SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 flags      as _In_      DWORD
  #define P2 numlangs   as _Out_     PULONG
  #define P3 langbuffer as _Out_opt_ PZZWSTR
  #define P4 bufferlen  as _Inout_   PULONG
  function GetUserPreferredUILanguages(P1, P2, P3, P4) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
    
  end function  
  
  UndefAllParams()
  #define P1 flags      as _In_      DWORD
  #define P2 numlangs   as _Out_     PULONG
  #define P3 langbuffer as _Out_opt_ PZZWSTR
  #define P4 bufferlen  as _Inout_   PULONG
  function GetThreadPreferredUILanguages(P1, P2, P3, P4) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 lpLocaleName as _In_opt_  LPCWSTR
  #define P2 LCType       as _In_      LCTYPE
  #define P3 lpLCData     as _Out_opt_ LPWSTR
  #define P4 cchData      as _In_      int
  function GetLocaleInfoEx(P1, P2, P3, P4) as int export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 lpLocaleName as _In_ LPCWSTR
  function IsValidLocaleName(P1) as BOOL export
    DEBUG_MsgNotImpl()
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 Locale  as _In_      LCID
  #define P2 lpName  as _Out_opt_ LPWSTR
  #define P3 cchName as _In_      int
  #define P4 dwFlags as _In_      DWORD
  function LCIDToLocaleName(P1, P2, P3, P4) as int export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
end extern