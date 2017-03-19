#define fbc -Wl "vcruntime140.dll.def" -dll

'#define MyDebug

#include "windows.bi"
#include "..\MyTDT\detour.bas"

#ifdef MyDebug
Messagebox(null,"Python Program Started","Block Wallpaper",MB_SYSTEMMODAL or MB_ICONINFORMATION)
#endif

dim shared pfSystemParametersInfoA as function(as ulong,as ulong,as any ptr,as ulong) as bool
dim shared pfSystemParametersInfoW as function(as ulong,as ulong,as any ptr,as ulong) as bool

function SystemParametersInfoA_Detour(P1 as ulong,P2 as ulong,P3 as any ptr,P4 as ulong) as bool
  if P1=SPI_SETDESKWALLPAPER then
    #ifdef MyDebug
    Messagebox(null,"Wallpaper changing blocked","Block Wallpaper",MB_ICONWARNING or MB_SYSTEMMODAL)
    #endif
    return false
  end if
  return pfSystemParametersInfoA(P1,P2,P3,P4)
end function
function SystemParametersInfoW_Detour(P1 as ulong,P2 as ulong,P3 as any ptr,P4 as ulong) as bool
  if P1=SPI_SETDESKWALLPAPER then
    #ifdef MyDebug
    Messagebox(null,"Wallpaper changing blocked","Block Wallpaper",MB_ICONWARNING or MB_SYSTEMMODAL)
    #endif
    return false
  end if
  return pfSystemParametersInfoW(P1,P2,P3,P4)
end function

SetDetourLibrary("user32.dll")
CreateDetour(SystemParametersInfoA)
CreateDetour(SystemParametersInfoW)





