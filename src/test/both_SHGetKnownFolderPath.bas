#include "windows.bi"
#include "win\Shlobj.bi"
#include "crt\stdio.bi"
#include "crt\string.bi"

type SHGKFP_t as function(rfid as REFKNOWNFOLDERID, dwFlags as DWORD, hToken as HANDLE, ppszPath as PWSTR ptr) as HRESULT

sub test(modname as zstring ptr)
  dim pfun as SHGKFP_t
  dim wtpath as wstring ptr
  dim hret as HRESULT
  dim hand as HANDLE
  
  hand = GetModuleHandle(modname)
  if hand = 0 then hand = LoadLibrary(modname)
  if hand = 0 then return
  pfun = cast(SHGKFP_t, GetProcAddress(hand, "SHGetKnownFolderPath"))
  if pfun = 0 then return
  
  pfun(@FOLDERID_RoamingAppData, 0, 0, @wtpath)
  if hret=S_OK then 
    printf(!"Modname: %s\nPath: %ls\nLen: %d\n", modname, wtpath, wcslen(wtpath))
    CoTaskMemFree(wtpath)
  else
    printf("SHGetKnownFolderPath() has failed with code: %X\n", hret)
  end if
end sub

test("shell32.dll")
test("shell3x.dll")