#define fbc -dll -Wl "shell3x.dll.def" -x ..\..\bin\dll\shell3x.dll -i ..\..\

#include "windows.bi"
#include "crt\string.bi"
#include "win\shellapi.bi"
#include "win\shlobj.bi"
#include "win\shtypes.bi"
#include "win\ole2.bi"
#include "includes\win\shellapi_fix.bi"
#include "includes\win\shlobj_fix.bi"
#include "includes\win\knownfolders_fix.bi"
#include "shared\helper.bas"

#include "shellpath.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 pidl as _In_  PCIDLIST_ABSOLUTE
  #define P2 riid as _In_  REFIID
  #define P3 ppv  as _Out_ any ptr ptr
  function SHCreateItemFromIDList(P1, P2, P3) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 pszPath as _In_     PCWSTR
  #define P2 pbc     as _In_opt_ IBindCtx ptr
  #define P3 riid    as _In_     REFIID
  #define P4 ppv     as _Out_    any ptr ptr
  function SHCreateItemFromParsingName(P1, P2, P3, P4) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 identifier   as _In_  const NOTIFYICONIDENTIFIER ptr
  #define P2 iconLocation as _Out_ RECT ptr
  function Shell_NotifyIconGetRect(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 rfid    as _In_  REFKNOWNFOLDERID
  #define P2 dwFlags as _In_  DWORD
  #define P3 hToken  as _In_  HANDLE
  #define P4 ppidl   as _Out_ PIDLIST_ABSOLUTE ptr
  function SHGetKnownFolderIDList(P1, P2, P3, P4) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 rfid     as _In_     REFKNOWNFOLDERID
  #define P2 dwFlags  as _In_     DWORD
  #define P3 hToken   as _In_opt_ HANDLE
  #define P4 ppszPath as _Out_    PWSTR ptr
  function SHGetKnownFolderPath(P1, P2, P3, P4) as HRESULT export
    dim wtpath as wstring*1024 = any
    dim hret as HRESULT
    dim csid as int
    dim flg as int
    dim pw as wstring ptr
    'static as zstring ptr WPATH_FIXME        = @"\_OS\FIXME"
    
    csid = 0
    if kfid2clsid(rfid, @csid)=FALSE then
      DEBUG_MsgTrace("Unimplemented KNOWNFOLDERID: " + str(rfid))
      return E_FAIL
    end if
    
    'TODO check following in windows or copy-paste from WINE
    'CSIDL_FLAG_CREATE with CSIDL_FLAG_DONT_VERIFY
    'KF_FLAG_NOT_PARENT_RELATIVE w/o KF_FLAG_DEFAULT_PATH
    flg = SHGFP_TYPE_CURRENT
    'if dwFlags and KF_FLAG_DEFAULT then
    'if dwFlags and KF_FLAG_SIMPLE_IDLIST then
    'if dwFlags and KF_FLAG_NOT_PARENT_RELATIVE then
    'if dwFlags and KF_FLAG_INIT then
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
    'win10 and win8 specific flags
    'KF_FLAG_NO_PACKAGE_REDIRECTION, KF_FLAG_FORCE_PACKAGE_REDIRECTION, KF_FLAG_RETURN_FILTER_REDIRECTION_TARGET, KF_FLAG_FORCE_APP_DATA_REDIRECTION
    'KF_FLAG_NO_APPCONTAINER_REDIRECTION, KF_FLAG_FORCE_APPCONTAINER_REDIRECTION
    
    hret = SHGetFolderPathW(NULL, csid, NULL, flg, @wtpath)
    if hret<>S_OK then return hret
    
    pw = CoTaskMemAlloc(len(wtpath)*2+2)
    if pw=NULL then return E_FAIL
    *pw = wtpath: *ppszPath = pw
    'var sTemp = exepath + *WPATH_FIXME
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 siid   as         SHSTOCKICONID
  #define P2 uFlags as         UINT
  #define P3 psii   as _Inout_ SHSTOCKICONINFO ptr
  function SHGetStockIconInfo(P1, P2, P3) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_INVALIDARG
  end function
end extern

/'
SHGetKnownFolderPath
https://msdn.microsoft.com/pt-br/library/windows/desktop/bb775966(v=vs.85).aspx
#	Time of Day	Thread	Module	API	Return Value	Return Address	Error	Duration
85622	7:19:23.041 AM	1	mGBA.exe	CoCreateInstance ( {dc1c5a9c-e88a-4dde-a5a1-60f82a20aef7}, NULL, CLSCTX_INPROC_SERVER, IFileOpenDialog, 0x0498c954 )	REGDB_E_CLASSNOTREG	0x005d47a5	0x80040154 = Classe não registrada 	0.0005038
'/