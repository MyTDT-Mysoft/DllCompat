#define fbc -dll -Wl "shell3x.dll.def" -x ..\..\bin\dll\shell3x.dll -i ..\..\

#include "windows.bi"
#include "win\shellapi.bi"
#include "win\shtypes.bi"
#include "win\ole2.bi"
#include "includes\win\shellapi_fix.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
    #define P1 pidl as PCIDLIST_ABSOLUTE
    #define P2 riid as REFIID
    #define P3 ppv as any ptr ptr
  function SHCreateItemFromIDList(P1, P2, P3) as HRESULT export
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 pszPath as PCWSTR
  #define P2 pbc as IBindCtx ptr
  #define P3 riid as REFIID
  #define P4 ppv as any ptr ptr
  function SHCreateItemFromParsingName(P1, P2, P3, P4) as HRESULT export
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 identifier as const NOTIFYICONIDENTIFIER ptr
  #define P2 iconLocation as RECT ptr
  function Shell_NotifyIconGetRect(P1, P2) as HRESULT export
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 rfid as REFKNOWNFOLDERID
  #define P2 dwFlags as DWORD
  #define P3 hToken as HANDLE
  #define P4 ppidl as PIDLIST_ABSOLUTE ptr
  function SHGetKnownFolderIDList(P1, P2, P3, P4) as HRESULT export
    return E_INVALIDARG
  end function
  
  UndefAllParams()
  #define P1 rfid as REFKNOWNFOLDERID
  #define P2 dwFlags as DWORD
  #define P3 hToken as HANDLE
  #define P4 ppszPath as PWSTR ptr
  function SHGetKnownFolderPath(P1, P2, P3, P4) as HRESULT export
    var sTemp = exepath+"\"
    dim as wstring ptr pw = CoTaskMemAlloc(len(sTemp)*2+2)
    if pw then return E_FAIL
    *pw = sTemp: *ppszPath = pw
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 siid as SHSTOCKICONID
  #define P2 uFlags as UINT
  #define P3 psii as SHSTOCKICONINFO ptr
  function SHGetStockIconInfo(P1, P2, P3) as HRESULT export
    return E_INVALIDARG
  end function
end extern

/'
SHGetKnownFolderPath
https://msdn.microsoft.com/pt-br/library/windows/desktop/bb775966(v=vs.85).aspx
#	Time of Day	Thread	Module	API	Return Value	Return Address	Error	Duration
85622	7:19:23.041 AM	1	mGBA.exe	CoCreateInstance ( {dc1c5a9c-e88a-4dde-a5a1-60f82a20aef7}, NULL, CLSCTX_INPROC_SERVER, IFileOpenDialog, 0x0498c954 )	REGDB_E_CLASSNOTREG	0x005d47a5	0x80040154 = Classe não registrada 	0.0005038
'/