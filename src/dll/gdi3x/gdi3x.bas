#define fbc -dll -Wl "gdi3x.dll.def" -x ..\bin\gdi3x.dll

'#define CaveManDebug OutputDebugString
#define CaveManDebug rem

#include "windows.bi"
#include "win\ddk\ddk_ntstatus.bi"
#include "..\MyTDT\Helper.bas"
#include "crt\limits.bi"
#include "GdiDib.bas"

#ifndef NSTATUS
type NTSTATUS as long
#endif

extern "windows-ms"

#undef D3DKMTCreateDCFromMemory
function D3DKMTCreateDCFromMemory( pDesc as D3DKMT_CREATEDCFROMMEMORY ptr ) as NTSTATUS export  
  
  TRACE( "Function Called" )  
  
  type d3dddi_format_info
    as D3DDDIFORMAT format
    as uinteger     bit_count
    as DWORD        compression
    as uinteger     palette_size
    as DWORD        mask_r, mask_g, mask_b
  end type
  dim as d3dddi_format_info ptr format = NULL
  dim as BITMAPOBJ ptr bmp = NULL
  dim as HBITMAP bitmap
  dim as uinteger I
  dim as HDC dc

  CaveManDebug( __LINE__ & !"\r\n" )

  static as d3dddi_format_info format_info(...) = { _
      ( D3DDDIFMT_R8G8B8,   24, BI_RGB,       0,   &h00000000, &h00000000, &h00000000 ), _
      ( D3DDDIFMT_A8R8G8B8, 32, BI_RGB,       0,   &h00000000, &h00000000, &h00000000 ), _
      ( D3DDDIFMT_X8R8G8B8, 32, BI_RGB,       0,   &h00000000, &h00000000, &h00000000 ), _
      ( D3DDDIFMT_R5G6B5,   16, BI_BITFIELDS, 0,   &h0000F800, &h000007E0, &h0000001F ), _
      ( D3DDDIFMT_X1R5G5B5, 16, BI_BITFIELDS, 0,   &h00007C00, &h000003E0, &h0000001F ), _
      ( D3DDDIFMT_A1R5G5B5, 16, BI_BITFIELDS, 0,   &h00007C00, &h000003E0, &h0000001F ), _
      ( D3DDDIFMT_P8,       8,  BI_RGB,       256, &h00000000, &h00000000, &h00000000 ) }
  
  CaveManDebug( __LINE__ & !"\r\n" )

  if pDesc=null then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if

  'TRACE("memory %p, format %#x, width %u, height %u, pitch %u, device dc %p, color table %p.\n",
  '      desc->pMemory, desc->Format, desc->Width, desc->Height,
  '      desc->Pitch, desc->hDeviceDc, desc->pColorTable)

  if pDesc->pMemory=null then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if

  CaveManDebug( __LINE__ & !"\r\n" )

  for I = 0 to ubound(format_info)    
     if format_info(i).format = pDesc->Format then        
        format = @format_info(i)
        exit for
      end if
  next I
  
  CaveManDebug( __LINE__ & !"\r\n" )
  
  if (format=null) then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if

  CaveManDebug( __LINE__ & !"\r\n" )

  if pDesc->Width > ((UINT_MAX and (not 3)) \ (format->bit_count \ 8)) then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if
  if (pDesc->Pitch=null) orelse pDesc->Pitch < get_dib_stride( pDesc->Width, format->bit_count ) then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if
  if (pDesc->Height=null) orelse pDesc->Height > (UINT_MAX \ pDesc->Pitch) then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER    
  end if

  #if 0
    if (pDesc->Width > ((UINT_MAX and (not 3)) \ (format->bit_count \ 8)) orelse _
    (pDesc->Pitch=null) orelse pDesc->Pitch < get_dib_stride( pDesc->Width, format->bit_count ) orelse _
    (pDesc->Height=null) orelse pDesc->Height > (UINT_MAX \ pDesc->Pitch)) then 
      OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
      return STATUS_INVALID_PARAMETER
    end if
  #endif

  CaveManDebug( __LINE__ & !"\r\n" )

  if (pDesc->hDeviceDc=null) then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if
  dc = CreateCompatibleDC( pDesc->hDeviceDc )      
  if (dc=null) then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if
  
  CaveManDebug( __LINE__ & !"\r\n" )
  
  do
    
    CaveManDebug( __LINE__ & !"\r\n" )
    bmp = HeapAlloc( GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(*bmp) )
    if (bmp=null) then 
      OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
      exit do 'goto error_
    end if

    CaveManDebug( __LINE__ & !"\r\n" )

    bmp->dib.dsBm.bmWidth      = pDesc->Width
    bmp->dib.dsBm.bmHeight     = pDesc->Height
    bmp->dib.dsBm.bmWidthBytes = pDesc->Pitch
    bmp->dib.dsBm.bmPlanes     = 1
    bmp->dib.dsBm.bmBitsPixel  = format->bit_count
    bmp->dib.dsBm.bmBits       = pDesc->pMemory

    CaveManDebug( __LINE__ & !"\r\n" )

    bmp->dib.dsBmih.biSize         = sizeof(bmp->dib.dsBmih)
    bmp->dib.dsBmih.biWidth        = pDesc->Width
    bmp->dib.dsBmih.biHeight       = -clng(pDesc->Height)
    bmp->dib.dsBmih.biPlanes       = 1
    bmp->dib.dsBmih.biBitCount     = format->bit_count
    bmp->dib.dsBmih.biCompression  = format->compression
    bmp->dib.dsBmih.biClrUsed      = format->palette_size
    bmp->dib.dsBmih.biClrImportant = format->palette_size

    CaveManDebug( __LINE__ & !"\r\n" )

    bmp->dib.dsBitfields(0) = format->mask_r
    bmp->dib.dsBitfields(1) = format->mask_g
    bmp->dib.dsBitfields(2) = format->mask_b

    if (format->palette_size) then        
        CaveManDebug( __LINE__ & !"\r\n" )
        bmp->color_table = HeapAlloc( GetProcessHeap(), 0, format->palette_size * sizeof(*bmp->color_table) )
        if (bmp=null) then
          OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
          exit do 'goto error
        end if
        CaveManDebug( __LINE__ & !"\r\n" )
        if (pDesc->pColorTable) then        
          CaveManDebug( __LINE__ & !"\r\n" )
          for i=0 to (format->palette_size-1)          
            bmp->color_table[i].rgbRed      = pDesc->pColorTable[i].peRed
            bmp->color_table[i].rgbGreen    = pDesc->pColorTable[i].peGreen
            bmp->color_table[i].rgbBlue     = pDesc->pColorTable[i].peBlue
            bmp->color_table[i].rgbReserved = 0
          next i        
        else
          CaveManDebug( __LINE__ & !"\r\n" )
          memcpy( bmp->color_table, get_default_color_table( format->bit_count ), _
          format->palette_size * sizeof(*bmp->color_table) )
        end if
        CaveManDebug( __LINE__ & !"\r\n" )
    end if

    CaveManDebug( __LINE__ & !"\r\n" )

    'bitmap = alloc_gdi_handle( bmp, OBJ_BITMAP, &dib_funcs )
    bitmap = CreateCompatibleBitmap( dc , 1 , 1 )
    if (bitmap=null) then 
      CaveManDebug( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
      exit do
    end if
    
    CaveManDebug( __LINE__ & !"\r\n" )
    
    pDesc->hDc = dc
    pDesc->hBitmap = bitmap
    SelectObject( dc, bitmap )
    CaveManDebug( "STATUS_SUCCESS " & __LINE__ & !"\r\n" )
    return STATUS_SUCCESS
    
  loop

  CaveManDebug( __LINE__ & !"\r\n" )
  'error:
  if (bmp) then HeapFree( GetProcessHeap(), 0, bmp->color_table )
  HeapFree( GetProcessHeap(), 0, bmp )
  DeleteDC( dc )
  return STATUS_INVALID_PARAMETER
end function

#undef D3DKMTDestroyDCFromMemory
function D3DKMTDestroyDCFromMemory( pDesc as D3DKMT_DESTROYDCFROMMEMORY ptr ) as NTSTATUS export
  
  if (pDesc=null) then return STATUS_INVALID_PARAMETER
  'TRACE("dc %p, bitmap %p.\n", desc->hDc, desc->hBitmap)
  TRACE( "Function Called" )

  var iChk = GetObjectType( pDesc->hDc ) <> OBJ_MEMDC 
  if iChk orelse GetObjectType( pDesc->hBitmap ) <> OBJ_BITMAP then 
    OutputDebugString( "STATUS_INVALID_PARAMETER " & __LINE__ & !"\r\n" )
    return STATUS_INVALID_PARAMETER
  end if
  
  DeleteObject( pDesc->hBitmap )
  DeleteDC( pDesc->hDc )
  
  OutputDebugString( "STATUS_SUCCESS " & __LINE__ & !"\r\n" )
  return STATUS_SUCCESS

end function

#if 0
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
#endif

end extern

