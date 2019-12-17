#define fbc -dll -Wl "shell3x.dll.def" -x ..\..\bin\dll\shell3x.dll -i ..\..\

#include "windows.bi"
#include "crt\string.bi"
#include "win\shellapi.bi"
#include "win\shlobj.bi"
#include "win\shtypes.bi"
#include "win\ole2.bi"

#include "shared\helper.bas"
#include "includes\lib\comhelper.h"
#include "includes\win\fix_shellapi.bi"
#include "includes\win\fix_shlobj.bi"
#include "includes\win\fix_shobjidl.bi"
#include "includes\win\fix_knownfolders.bi"
#include "includes\win\dll_shell3x.bi"

#include "shell3x.bi"
#include "shellpath.bas"
#include "shellcom.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 identifier   as _In_  const NOTIFYICONIDENTIFIER ptr
  #define P2 iconLocation as _Out_ RECT ptr
  function fnShell_NotifyIconGetRect alias "Shell_NotifyIconGetRect"(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 cidl          as UINT
  #define P2 rgpidl        as PCIDLIST_ABSOLUTE_ARRAY
  #define P3 ppsiItemArray as IShellItemArray ptr ptr
  function fnSHCreateShellItemArrayFromIDLists alias "SHCreateShellItemArrayFromIDLists"(P1, P2, P3) as HRESULT export
    dim psia as ShellItemArrayImpl ptr
    
    if ppsiItemArray=NULL then return E_INVALIDARG
    *ppsiItemArray = NULL
    if cidl=0 then return E_INVALIDARG
    
    psia = create_ShellItemArray(cidl)
    if psia=NULL then return E_OUTOFMEMORY
    
    for i as int = 0 to cidl-1
      dim outOffset as int = cidl - psia->itemCount
      
      if not SUCCEEDED(SHCreateItemFromIDList(rgpidl[i], @IID_IShellItem, @(psia->ptrArr[i - outOffset]))) then
        psia->itemCount-=1
      end if
    next
    
    if psia->itemCount > 0 then
      *ppsiItemArray = psia
      return S_OK
    else
      IUnknown_Release(psia)
      return E_FAIL
    end if
  end function
  
  UndefAllParams()
  #define P1 pidl as _In_  PCIDLIST_ABSOLUTE
  #define P2 riid as _In_  REFIID
  #define P3 ppv  as _Out_ any ptr ptr
  function fnSHCreateItemFromIDList alias "SHCreateItemFromIDList"(P1, P2, P3) as HRESULT export
    if IsEqualGUID(riid, @IID_IShellItem) then
      dim psi as IShellItem ptr
      dim hr as HRESULT
      
      *ppv = NULL
      hr = SHCreateShellItem(NULL, NULL, pidl, @psi)
      if SUCCEEDED(hr) then *ppv = psi
      
      return hr
    else
      dim guidstr as zstring*(GUIDSTR_SIZE+1)
      
      chelp_GUID2strA(guidstr, riid)
      DEBUG_MsgTrace("IID of %s not recognized yet.", guidstr)
      return E_INVALIDARG
    end if
  end function
  
  UndefAllParams()
  #define P1 pszPath as _In_     PCWSTR
  #define P2 pbc     as _In_opt_ IBindCtx ptr
  #define P3 riid    as _In_     REFIID
  #define P4 ppv     as _Out_    any ptr ptr
  function fnSHCreateItemFromParsingName alias "SHCreateItemFromParsingName"(P1, P2, P3, P4) as HRESULT export
    dim pidl as PIDLIST_ABSOLUTE
    dim hr as HRESULT
    
    hr = SHParseDisplayName(pszPath, pbc, @pidl, 0, NULL)
    
    if SUCCEEDED(hr) then
      hr = SHCreateItemFromIDList(pidl, riid, ppv)
      ILFree(pidl)
    end if
    
    return hr
  end function
  
  UndefAllParams()
  #define P1 rfid    as _In_  REFKNOWNFOLDERID
  #define P2 dwFlags as _In_  DWORD
  #define P3 hToken  as _In_  HANDLE
  #define P4 ppidl   as _Out_ PIDLIST_ABSOLUTE ptr
  function fnSHGetKnownFolderIDList alias "SHGetKnownFolderIDList"(P1, P2, P3, P4) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 rfid     as _In_     REFKNOWNFOLDERID
  #define P2 dwFlags  as _In_     DWORD
  #define P3 hToken   as _In_opt_ HANDLE
  #define P4 ppszPath as _Out_    PWSTR ptr
  function fnSHGetKnownFolderPath alias "SHGetKnownFolderPath"(P1, P2, P3, P4) as HRESULT export
    dim wtpath as wstring*1024 = any
    dim hret as HRESULT
    dim csid as int
    dim flg as int
    dim pw as wstring ptr
    dim clsidStr as wstring*40
    'static as wstring*16 WPATH_FIXME = wstr(".\_OS\FIXME")
    
    csid = 0
    if kfid2clsid(rfid, @csid)=FALSE then
      StringFromGUID2(rfid, @clsidStr, sizeof(clsidStr)/2)
      DEBUG_MsgTrace("Unimplemented KNOWNFOLDERID: %ls", @clsidStr)
      return E_FAIL
    end if
    
    'TODO check following in windows or copy-paste from WINE
    'CSIDL_FLAG_CREATE with CSIDL_FLAG_DONT_VERIFY
    'KF_FLAG_NOT_PARENT_RELATIVE w/o KF_FLAG_DEFAULT_PATH
    flg = SHGFP_TYPE_CURRENT
    'if dwFlags and KF_FLAG_DEFAULT then
    'if dwFlags and KF_FLAG_SIMPLE_IDLIST then
    'if dwFlags and KF_FLAG_NOT_PARENT_RELATIVE then
    'if dwFlags and KF_FLAG_ALIAS_ONLY then
    if dwFlags and KF_FLAG_DEFAULT_PATH then
      flg = SHGFP_TYPE_DEFAULT
    end if
    if dwFlags and KF_FLAG_NO_ALIAS then
      csid or= CSIDL_FLAG_NO_ALIAS 'no effect on SHGetFolderPath
    end if
    if dwFlags and KF_FLAG_DONT_UNEXPAND then
      csid or= CSIDL_FLAG_DONT_UNEXPAND
    end if
    if dwFlags and KF_FLAG_DONT_VERIFY then
      csid or= CSIDL_FLAG_DONT_VERIFY
    end if
    if dwFlags and KF_FLAG_CREATE then
      csid or= CSIDL_FLAG_CREATE
    end if
    if dwFlags and KF_FLAG_INIT then
      csid or= CSIDL_FLAG_PER_USER_INIT
    end if
    'win10 and win8 specific flags
    'KF_FLAG_NO_PACKAGE_REDIRECTION, KF_FLAG_FORCE_PACKAGE_REDIRECTION, KF_FLAG_RETURN_FILTER_REDIRECTION_TARGET, KF_FLAG_FORCE_APP_DATA_REDIRECTION
    'KF_FLAG_NO_APPCONTAINER_REDIRECTION, KF_FLAG_FORCE_APPCONTAINER_REDIRECTION
    
    hret = SHGetFolderPathW(NULL, csid, NULL, flg, @wtpath)
    if hret<>S_OK then return hret
    
    pw = CoTaskMemAlloc(len(wtpath)*2+2)
    if pw=NULL then return E_FAIL
    *pw = wtpath: *ppszPath = pw
    
    SetLastError(S_OK)
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 siid   as         SHSTOCKICONID
  #define P2 uFlags as         UINT
  #define P3 psii   as _Inout_ SHSTOCKICONINFO ptr
  function fnSHGetStockIconInfo alias "SHGetStockIconInfo"(P1, P2, P3) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_INVALIDARG
  end function
end extern

'-------------------------------------------------------------------------------------------

#define CUSTOM_MAIN
#include "shared\defaultmain.bas"

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as BOOL
    select case uReason
      case DLL_PROCESS_ATTACH
        cbase_init(handle, NULL, 0)
      case DLL_PROCESS_DETACH
        cbase_destroy()
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select
    return DLLMAIN_DEFAULT(handle, uReason, Reserved)
  end function
end extern