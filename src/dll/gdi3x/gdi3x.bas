#define fbc -dll -Wl "gdi3x.dll.def" -x ..\..\..\bin\dll\gdi3x.dll -i ..\..\

'#define CaveManDebug OutputDebugString
#define CaveManDebug rem

#include "windows.bi"
#include "win\ddk\ddk_ntstatus.bi"
#include "crt\limits.bi"
#include "GdiDib.bas"
#include "shared\helper.bas"

#ifndef NSTATUS
type NTSTATUS as long
#endif

extern "windows-ms"
  UndefAllParams()
  #define P1 desc as _Inout_ D3DKMT_CREATEDCFROMMEMORY ptr
  #undef D3DKMTCreateDCFromMemory
  function D3DKMTCreateDCFromMemory(P1) as NTSTATUS export
    type d3dddi_format_info
      as D3DDDIFORMAT format
      as uinteger     bit_count
      as DWORD        compression
      as uinteger     palette_size
      as DWORD        mask_r, mask_g, mask_b
    end type
    dim as d3dddi_format_info ptr format = NULL
    dim as BITMAPINFO ptr bmpInfo = NULL
    dim as BITMAPV5HEADER ptr bmpHeader = NULL
    dim as HBITMAP bitmap
    dim as uinteger i
    dim as HDC dc
    
    static as d3dddi_format_info format_info(...) = { _
        ( D3DDDIFMT_R8G8B8,   24, BI_RGB,       0,   &h00000000, &h00000000, &h00000000 ), _
        ( D3DDDIFMT_A8R8G8B8, 32, BI_RGB,       0,   &h00000000, &h00000000, &h00000000 ), _
        ( D3DDDIFMT_X8R8G8B8, 32, BI_RGB,       0,   &h00000000, &h00000000, &h00000000 ), _
        ( D3DDDIFMT_R5G6B5,   16, BI_BITFIELDS, 0,   &h0000F800, &h000007E0, &h0000001F ), _
        ( D3DDDIFMT_X1R5G5B5, 16, BI_BITFIELDS, 0,   &h00007C00, &h000003E0, &h0000001F ), _
        ( D3DDDIFMT_A1R5G5B5, 16, BI_BITFIELDS, 0,   &h00007C00, &h000003E0, &h0000001F ), _
        ( D3DDDIFMT_A4R4G4B4, 16, BI_BITFIELDS, 0,   &h00000F00, &h000000F0, &h0000000F ), _
        ( D3DDDIFMT_X4R4G4B4, 16, BI_BITFIELDS, 0,   &h00000F00, &h000000F0, &h0000000F ), _
        ( D3DDDIFMT_P8,       8,  BI_RGB,       256, &h00000000, &h00000000, &h00000000 ) }
	
	DEBUG_MsgTrace("Function Called")
    
    if desc = NULL orelse desc->pMemory = NULL then return STATUS_INVALID_PARAMETER

    'WARN: checkme
    'for (i = 0; i < sizeof(format_info) / sizeof(*format_info); ++i)
    for i = 0 to (ubound(format_info) - 1)
      if format_info(i).format = desc->Format then  
          format = @format_info(i)
          exit for
      end if
    next i
    
    if format = NULL then return STATUS_INVALID_PARAMETER

    if desc->Width > (UINT_MAX and (not 3)) \ (format->bit_count \ 8) then return STATUS_INVALID_PARAMETER
    if desc->Pitch = 0 orelse desc->Height = 0 then return STATUS_INVALID_PARAMETER
    if desc->Pitch < (((desc->Width * format->bit_count + 31) shr 3) and (not 3)) then return STATUS_INVALID_PARAMETER

    dc = CreateCompatibleDC(desc->hDeviceDc)
    if desc->hDeviceDc = NULL orelse dc = NULL then return STATUS_INVALID_PARAMETER

    bmpInfo = HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(*bmpInfo) + (format->palette_size * sizeof(RGBQUAD)))
    bmpHeader = HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(*bmpHeader))
    if bmpInfo = NULL orelse bmpHeader = NULL then goto _ERR
	
    bmpHeader->bV5Size        = sizeof(*bmpHeader)
    bmpHeader->bV5Width       = desc->Width
    bmpHeader->bV5Height      = desc->Height
    bmpHeader->bV5SizeImage   = desc->Pitch
    bmpHeader->bV5Planes      = 1
    bmpHeader->bV5BitCount    = format->bit_count
    bmpHeader->bV5Compression = BI_BITFIELDS
    bmpHeader->bV5RedMask     = format->mask_r
    bmpHeader->bV5GreenMask   = format->mask_g
    bmpHeader->bV5BlueMask    = format->mask_b
    
    bmpInfo->bmiHeader.biSize         = sizeof(BITMAPINFOHEADER)
    bmpInfo->bmiHeader.biWidth        = desc->Width
    bmpInfo->bmiHeader.biHeight       = -clng(desc->Height)
    bmpInfo->bmiHeader.biPlanes       = 1
    bmpInfo->bmiHeader.biBitCount     = format->bit_count
    bmpInfo->bmiHeader.biCompression  = format->compression
    bmpInfo->bmiHeader.biClrUsed      = format->palette_size
    bmpInfo->bmiHeader.biClrImportant = format->palette_size
    
    if desc->pColorTable then
      for i=0 to (format->palette_size-1)
        bmpInfo->bmiColors(i).rgbRed   = desc->pColorTable[i].peRed
        bmpInfo->bmiColors(i).rgbGreen = desc->pColorTable[i].peGreen
        bmpInfo->bmiColors(i).rgbBlue  = desc->pColorTable[i].peBlue
        bmpInfo->bmiColors(i).rgbReserved = 0
      next i
    end if
    
    bitmap = CreateBitmap(desc->Width, desc->Height, 1, format->bit_count, desc->pMemory)
    if bitmap = NULL then goto _ERR
    
    desc->hDc = dc
    desc->hBitmap = bitmap
    DEBUG_MsgTrace("hDc %X | %X || %X", OBJ_MEMDC,  GetObjectType(desc->hDc), desc->hDc)
    DEBUG_MsgTrace("hBitmap %X | %X || %X", OBJ_BITMAP, GetObjectType(desc->hBitmap), desc->hBitmap)
    SelectObject(dc, bitmap)
    return STATUS_SUCCESS
    
    _ERR:
    DEBUG_MsgTrace("Error GOTO")
    if bmpInfo   then HeapFree(GetProcessHeap(), 0, bmpInfo)
    if bmpHeader then HeapFree(GetProcessHeap(), 0, bmpHeader)
    DeleteDC(dc)
    return STATUS_INVALID_PARAMETER
  end function
  
  UndefAllParams()
  #define P1 desc as _Inout_ D3DKMT_CREATEDCFROMMEMORY ptr
  #undef D3DKMTDestroyDCFromMemory
  function D3DKMTDestroyDCFromMemory(P1) as NTSTATUS export
    if desc = NULL then return STATUS_INVALID_PARAMETER
    
    DEBUG_MsgTrace("Function Called")

    if GetObjectType(desc->hDc)     <> OBJ_MEMDC  then
      DEBUG_MsgTrace("STATUS_INVALID_PARAMETER hDc")
      DEBUG_MsgTrace("hDc %X | %X || %X", OBJ_MEMDC, GetObjectType(desc->hDc), desc->hDc)
      'return STATUS_INVALID_PARAMETER
    end if
    if GetObjectType(desc->hBitmap) <> OBJ_BITMAP then
      DEBUG_MsgTrace("STATUS_INVALID_PARAMETER hBitmap")
      DEBUG_MsgTrace("hBitmap %X | %X || %X", OBJ_BITMAP, GetObjectType(desc->hBitmap), desc->hBitmap)
      'return STATUS_INVALID_PARAMETER
    end if
    DeleteObject(desc->hBitmap)
    DeleteDC(desc->hDc)

    return STATUS_SUCCESS
  end function
end extern

