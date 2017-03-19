#define fbc -Wl "shell3x.dll.def" -dll

#include "windows.bi"
#include "win/ole2.bi"

extern "windows-ms"
  function SHGetKnownFolderPath (prfid as any ptr,Flags as dword,hToken as handle,ppwPath as wstring ptr ptr) as hresult export
    var sTemp = exepath+"\"
    dim as wstring ptr pw = CoTaskMemAlloc(len(sTemp)*2+2)
    if pw then return E_FAIL
    *pw = sTemp: *ppwPath = pw
    return S_OK
  end function
end extern

#ifdef TODO
  https://msdn.microsoft.com/pt-br/library/windows/desktop/bb775966(v=vs.85).aspx
  #	Time of Day	Thread	Module	API	Return Value	Return Address	Error	Duration
  85622	7:19:23.041 AM	1	mGBA.exe	CoCreateInstance ( {dc1c5a9c-e88a-4dde-a5a1-60f82a20aef7}, NULL, CLSCTX_INPROC_SERVER, IFileOpenDialog, 0x0498c954 )	REGDB_E_CLASSNOTREG	0x005d47a5	0x80040154 = Classe não registrada 	0.0005038
#endif