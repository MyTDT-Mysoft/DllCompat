#define fbc -s gui res\xp_LoadLibrarydll.rc
#include "windows.bi"

type Results
  gmhA as ubyte
  gmheA as ubyte
  llA as ubyte
  lleA as ubyte
  e_gmhA as ubyte
  e_gmheA as ubyte
  e_llA as ubyte
  e_lleA as ubyte
end type

var sAPP = "DllTest v0.1 By Mysoft"
var sDLL = command
dim h as HMODULE = NULL
dim r as Results

if len(sDLL)=0 then
  messagebox(null,!"Tests if a .dll can be loaded...\r\n\r\n" _
  !"usage: \r\n" _
  !"dll_test <file.dll>" _
  ,sAPP,MB_SYSTEMMODAL or MB_ICONQUESTION)
  system
end if
dim h2 as HMODULE = LoadLibraryA(sDLL)
'-----------------------------------------------
h = GetModuleHandleA(sDLL)
if h then
  r.gmhA = 1
  'do not FreeLibrary
else
  r.e_gmhA = GetLastError()
end if
'-----
GetModuleHandleExA(0, sDLL, @h)
if h then
  r.gmheA = 1
  FreeLibrary(h)
else
  r.e_gmheA = GetLastError()
end if
'-----
h = LoadLibraryA(sDLL)
if h then
  r.llA = 1
  FreeLibrary(h)
else
  r.e_llA = GetLastError()
end if

h = LoadLibraryExA(sDLL, NULL, 0)
if h then 
  r.lleA = 1
  FreeLibrary(h)
else
  r.e_lleA = GetLastError()
end if
'-----
if h2 then FreeLibrary(h2)

var rString = _
"GetModuleHandleA: "  +str(r.gmhA)+  !"\nErrcode: "+hex(r.e_gmhA) +!"\n\n" _
"GetModuleHandleExA: "+str(r.gmheA)+ !"\nErrcode: "+hex(r.e_gmheA)+!"\n\n" _
"LoadLibraryA: "      +str(r.llA)+   !"\nErrcode: "+hex(r.e_llA)  +!"\n\n" _
"LoadLibraryExA: "    +str(r.lleA)+  !"\nErrcode: "+hex(r.e_lleA) +!"\n\n"
messagebox(null, rString ,!"Results for '"+sDLL+"'", MB_SYSTEMMODAL or MB_ICONINFORMATION)

