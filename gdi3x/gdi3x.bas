#define fbc -dll -Wl "gdi3x.dll.def" -x ..\bin\gdi3x.dll

#include "windows.bi"
#include "win\ddk\ddk_ntstatus.bi"

#include "..\MyTDT\Helper.bas"

#ifndef NSTATUS
type NTSTATUS as long
#endif

#undef D3DKMT_CREATEDCFROMMEMORY
type D3DKMT_CREATEDCFROMMEMORY as any ptr 

#undef D3DKMT_DESTROYDCFROMMEMORY
type D3DKMT_DESTROYDCFROMMEMORY as any ptr

extern "windows-ms"

'https://msdn.microsoft.com/en-us/library/windows/hardware/ff546826%28v=vs.85%29.aspx
#undef D3DKMTCreateDCFromMemory
function D3DKMTCreateDCFromMemory( pData as D3DKMT_CREATEDCFROMMEMORY ptr ) as NTSTATUS export
  UnimplementedFunction()
  return STATUS_NOT_SUPPORTED
end function

'https://msdn.microsoft.com/en-us/library/windows/hardware/ff546908%28v=vs.85%29.aspx
#undef D3DKMTDestroyDCFromMemory
function D3DKMTDestroyDCFromMemory( pData as D3DKMT_DESTROYDCFROMMEMORY ptr ) as NTSTATUS export
  UnimplementedFunction()
  return STATUS_SUCCESS
end function  

end extern

