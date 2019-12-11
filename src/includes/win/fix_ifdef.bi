#pragma once
#include once "win\ipifcons.bi"

'FBC does not support 64bit wide bitfields on x86, as of v1.05
#undef _NET_LUID_Info
#undef _NET_LUID
#undef NET_LUID
#undef PNET_LUID
#undef IF_LUID
#undef PIF_LUID
    
type _NET_LUID_Info field=1
  union
    Reserved       : 24 as ULONG
    type
      __R16             as ushort    
      __R8         :  8 as ULONG
      NetLuidIndex : 24 as ULONG
      IfType            as ushort
    end type
  end union
end type

union _NET_LUID
  Value as ULONG64	
  Info as _NET_LUID_Info	
end union

type NET_LUID as _NET_LUID
type PNET_LUID as _NET_LUID ptr
type IF_LUID as NET_LUID
type PIF_LUID as NET_LUID ptr

/'type _NET_LUID_Info
	Reserved:24 as ULONG64
	NetLuidIndex:24 as ULONG64
	IfType:16 as ULONG64
end type

union _NET_LUID
	Value as ULONG64
	Info as _NET_LUID_Info
end union'/
