#define fbc -s gui res\xp_LoadLibrarydll.rc
#include "windows.bi"

type Results
  GetModuleHandleA as ubyte
  GetModuleHandleExA as ubyte
  LoadLibraryA as ubyte
  LoadLibraryExA as ubyte
end type

var sAPP = "DllTest v0.1 By Mysoft"
var sDLL = command$
dim h as HMODULE = NULL
dim r as Results

if len(sDLL)=0 then
  messagebox(null,!"Tests if a .dll can be loaded...\r\n\r\n" _
  !"usage: \r\n" _
  !"dll_test <file.dll>" _
  ,sAPP,MB_SYSTEMMODAL or MB_ICONQUESTION)
  system
end if

'-----------------------------------------------
h = GetModuleHandleA(sDLL) 'no increment
if h then r.GetModuleHandleA = 1
GetModuleHandleExA(0, sDLL, @h) 'increments
if h then r.GetModuleHandleExA = 1
FreeLibrary(h)
h = LoadLibraryA(sDLL) 'increments
if h then r.LoadLibraryA = 1
FreeLibrary(h)
h = LoadLibraryExA(sDLL,NULL,0) 'increments
if h then r.LoadLibraryExA = 1
FreeLibrary(h)

var rString = _
"GetModuleHandleA: "+str(r.GetModuleHandleA)+!"\n" _
"GetModuleHandleExA: "+str(r.GetModuleHandleExA)+!"\n"+ _
"LoadLibraryA: "+str(r.LoadLibraryA)+!"\n" _
"LoadLibraryExA: "+str(r.LoadLibraryExA)+!"\n"
messagebox(null, rString ,!"Results for '"+sDLL+"'", MB_SYSTEMMODAL or MB_ICONINFORMATION)

