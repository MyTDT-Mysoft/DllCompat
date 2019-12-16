#pragma once

extern "windows"
  UndefAllParams()
  #define P1 pUiInfo as PCREDUI_INFOA
  #define P2 dwAuthError as DWORD
  #define P3 pulAuthPackage as ULONG ptr
  #define P4 pvInAuthBuffer as LPCVOID
  #define P5 ulInAuthBufferSize as ULONG
  #define P6 ppvOutAuthBuffer as LPVOID ptr
  #define P7 pulOutAuthBufferSize as ULONG ptr
  #define P8 pfSave as BOOL ptr
  #define P9 dwFlags as DWORD
  declare function CredUIPromptForWindowsCredentialsA(P1, P2, P3, P4, P5, P6, P7, P8, P9) as DWORD
  
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
  declare function CredUIPromptForWindowsCredentialsW(P1, P2, P3, P4, P5, P6, P7, P8, P9) as DWORD
  
  UndefAllParams()
  #define P1 dwFlags as DWORD
  #define P2 pAuthBuffer as PVOID
  #define P3 cbAuthBuffer as DWORD
  #define P4 pszUserName as LPSTR
  #define P5 pcchMaxUserName as DWORD ptr
  #define P6 pszDomainName as LPSTR
  #define P7 pcchMaxDomainname as DWORD ptr
  #define P8 pszPassword as LPSTR
  #define P9 pcchMaxPassword as DWORD ptr
  declare function CredUnPackAuthenticationBufferA(P1, P2, P3, P4, P5, P6, P7, P8, P9) as BOOL
  
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
  declare function CredUnPackAuthenticationBufferW(P1, P2, P3, P4, P5, P6, P7, P8, P9) as BOOL
end extern