#pragma once

extern "windows"
  UndefAllParams()
  #define P1 identifier   as _In_  const NOTIFYICONIDENTIFIER ptr
  #define P2 iconLocation as _Out_ RECT ptr
  declare function Shell_NotifyIconGetRect(P1, P2) as HRESULT
  
  UndefAllParams()
  #define P1 cidl          as UINT
  #define P2 rgpidl        as PCIDLIST_ABSOLUTE_ARRAY
  #define P3 ppsiItemArray as IShellItemArray ptr ptr
  declare function SHCreateShellItemArrayFromIDLists(P1, P2, P3) as HRESULT
  
  UndefAllParams()
  #define P1 pidl as _In_  PCIDLIST_ABSOLUTE
  #define P2 riid as _In_  REFIID
  #define P3 ppv  as _Out_ any ptr ptr
  declare function SHCreateItemFromIDList(P1, P2, P3) as HRESULT
  
  UndefAllParams()
  #define P1 pszPath as _In_     PCWSTR
  #define P2 pbc     as _In_opt_ IBindCtx ptr
  #define P3 riid    as _In_     REFIID
  #define P4 ppv     as _Out_    any ptr ptr
  declare function SHCreateItemFromParsingName(P1, P2, P3, P4) as HRESULT

  UndefAllParams()
  #define P1 rfid    as _In_  REFKNOWNFOLDERID
  #define P2 dwFlags as _In_  DWORD
  #define P3 hToken  as _In_  HANDLE
  #define P4 ppidl   as _Out_ PIDLIST_ABSOLUTE ptr
  declare function SHGetKnownFolderIDList(P1, P2, P3, P4) as HRESULT

  UndefAllParams()
  #define P1 rfid     as _In_     REFKNOWNFOLDERID
  #define P2 dwFlags  as _In_     DWORD
  #define P3 hToken   as _In_opt_ HANDLE
  #define P4 ppszPath as _Out_    PWSTR ptr
  declare function SHGetKnownFolderPath(P1, P2, P3, P4) as HRESULT

  UndefAllParams()
  #define P1 siid   as         SHSTOCKICONID
  #define P2 uFlags as         UINT
  #define P3 psii   as _Inout_ SHSTOCKICONINFO ptr
  declare function SHGetStockIconInfo(P1, P2, P3) as HRESULT
end extern