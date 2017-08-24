#define fbc -s gui res\LoadLibrary_dlltest.rc
#include "windows.bi"

var sAPP = "DllTest v0.1 By Mysoft"
var sDLL = command$
if len(sDLL)=0 then
  messagebox(null,!"Tests if a .dll can be loaded...\r\n\r\n" _
  !"usage: \r\n" _
  !"dll_test <file.dll>" _
  ,sAPP,MB_SYSTEMMODAL or MB_ICONQUESTION)
  system
end if
if LoadLibrary(sDLL)=0 then
  messagebox(null,!"Failed to load '"+sDLL+"'", _
  sAPP,MB_SYSTEMMODAL or MB_ICONERROR)
else
  messagebox(null,!"Library loaded sucessfully", _
  sAPP,MB_SYSTEMMODAL or MB_ICONINFORMATION)
end if

