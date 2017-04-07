#define fbc -dll -Wl "credux.dll.def" -x ..\bin\credux.dll

#include "windows.bi"

#include "..\win\credux.bi"
#include "..\win\wincred.bi"
#include "..\MyTDT\detour.bas"



function TreatCredFlags(inflags as DWORD, outflags as DWORD ptr) as DWORD
  *outflags = &H00
  'flag mapping
  if inflags and CREDUIWIN_GENERIC then
    *outflags or= CREDUI_FLAGS_GENERIC_CREDENTIALS
  endif
  if inflags and CREDUIWIN_CHECKBOX then
    *outflags or= CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX
  endif
  if inflags and CREDUIWIN_AUTHPACKAGE_ONLY then
    'no idea
  endif
  if inflags and CREDUIWIN_IN_CRED_ONLY then
    'no idea
  endif
  if inflags and CREDUIWIN_ENUMERATE_ADMINS then
    *outflags or= CREDUI_FLAGS_REQUEST_ADMINISTRATOR
  endif
  if inflags and CREDUIWIN_ENUMERATE_CURRENT_USER then
    'no idea
  endif
  if inflags and CREDUIWIN_SECURE_PROMPT then
    'don't care, probably win7 thing
  endif
  if inflags and CREDUIWIN_PREPROMPTING then
    'no idea, probably don't care
  endif
  if inflags and CREDUIWIN_PACK_32_WOW then
    'irrelevant, winXP x86
  endif
  
  'mutual exclusivity checks
  'TODO: check what happens if we set such flags simultaneously, an replicate
  'CREDUIWIN_GENERIC !! SECURE_PROMPT
  'CREDUIWIN_AUTHPACKAGE_ONLY !! CREDUIWIN_IN_CRED_ONLY
  return ERROR_SUCCESS
end function

extern "windows-ms"
  UndefAllParams()
  #define P1 pUiInfo as PCREDUI_INFOW
  #define P2 dwAuthError as DWORD
  #define P3 pulAuthPackage as ULONG ptr
  #define P4 pvInAuthBuffer as LPCVOID
  #define P5 ulInAuthBufferSize as ULONG
  #define P6 ppvOutAuthBuffer as LPVOID ptr
  #define P7 pulOutAuthBufferSize as ULONG ptr
  #define P8 pfSave as BOOL ptr
  #define P9 dwFlags as DWORD
  function CredUIPromptForWindowsCredentialsW(P1, P2, P3, P4, P5, P6, P7, P8, P9) as DWORD export
    var retVal
    dim as DWORD newFlags
    dim as wstring*(CREDUI_MAX_USERNAME_LENGTH+1)      usernameBuf
    dim as wstring*(CREDUI_MAX_PASSWORD_LENGTH+1)      passwordBuf
    dim as wstring*(CREDUI_MAX_DOMAIN_TARGET_LENGTH+1) domainBuf
    var maxUserName = CREDUI_MAX_USERNAME_LENGTH
    var maxPassword = CREDUI_MAX_PASSWORD_LENGTH
    var maxDomain   = CREDUI_MAX_DOMAIN_TARGET_LENGTH
    
    SecureZeroMemory(usernameBuf, CREDUI_MAX_USERNAME_LENGTH)
    SecureZeroMemory(passwordBuf, CREDUI_MAX_PASSWORD_LENGTH)
    SecureZeroMemory(domainBuf  , CREDUI_MAX_DOMAIN_TARGET_LENGTH)
    
    'TODO: deal with pulling user and pass from pvInAuthBuffer
    'dwFlags of these two fucntions are NOT the same
    var retErr = treatcredflags(dwFlags, @newFlags)
    if retErr <> ERROR_SUCCESS then
      'TODO: return proper error according to flag
      return ERROR_OUT_OF_PAPER
    endif
    
    
    
    
    /'
    P1  pUiInfo as PCREDUI_INFOW,
    P2  pszTargetName as PCWSTR,
    P3  pContext as PCtxtHandle,
    P4  dwAuthError as DWORD,
    P5  pszUserName as PWSTR,
    P6  ulUserNameBufferSize as ULONG,
    P7  pszPassword as PWSTR,
    P8  ulPasswordBufferSize as ULONG,
    P9  save as WINBOOL ptr,
    P10 dwFlags as DWORD
    '/
    retVal = CredUIPromptForCredentialsW(pUiInfo, @domainBuf, NULL, dwAuthError, @usernameBuf, P6, @pszPassword, P8, pfSave, newFlags)
    SecureZeroMemory(usernameBuf, CREDUI_MAX_USERNAME_LENGTH)
    SecureZeroMemory(passwordBuf, CREDUI_MAX_PASSWORD_LENGTH)
    SecureZeroMemory(domainBuf  , CREDUI_MAX_DOMAIN_TARGET_LENGTH)
    return retVal
  end function
  
  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 pAuthBuffer as PVOID
  #define P3 cbAuthBuffer as DWORD
  #define P4 pszUserName as LPWSTR
  #define P5 pcchMaxUserName as DWORD ptr
  #define P6 pszDomainName as LPWSTR
  #define P7 pcchMaxDomainname as DWORD ptr
  #define P8 pszPassword as LPWSTR
  #define P9 pcchMaxPassword as DWORD ptr
  function CredUnPackAuthenticationBufferW (P1, P2, P3, P4, P5, P6, P7, P8, P9) as BOOL export
    'TODO: treat flags
    return FALSE
  end function
end extern









