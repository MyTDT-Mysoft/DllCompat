function get_default_color_table( bpp as integer ) as RGBQUAD ptr
  static as RGBQUAD table_1(2-1) = _
  { _
      ( &h00, &h00, &h00 ), ( &hff, &hff, &hff ) _
  } 
  static as RGBQUAD table_4(16-1) = _
  { _
      ( &h00, &h00, &h00 ), ( &h00, &h00, &h80 ), ( &h00, &h80, &h00 ), ( &h00, &h80, &h80 ), _
      ( &h80, &h00, &h00 ), ( &h80, &h00, &h80 ), ( &h80, &h80, &h00 ), ( &h80, &h80, &h80 ), _
      ( &hc0, &hc0, &hc0 ), ( &h00, &h00, &hff ), ( &h00, &hff, &h00 ), ( &h00, &hff, &hff ), _
      ( &hff, &h00, &h00 ), ( &hff, &h00, &hff ), ( &hff, &hff, &h00 ), ( &hff, &hff, &hff ) _
  }
  static as RGBQUAD table_8(256-1) = _
  {_      
      ( &h00, &h00, &h00 ), ( &h00, &h00, &h80 ), ( &h00, &h80, &h00 ), ( &h00, &h80, &h80 ), _
      ( &h80, &h00, &h00 ), ( &h80, &h00, &h80 ), ( &h80, &h80, &h00 ), ( &hc0, &hc0, &hc0 ), _
      ( &hc0, &hdc, &hc0 ), ( &hf0, &hca, &ha6 ), ( &h00, &h20, &h40 ), ( &h00, &h20, &h60 ), _
      ( &h00, &h20, &h80 ), ( &h00, &h20, &ha0 ), ( &h00, &h20, &hc0 ), ( &h00, &h20, &he0 ), _
      ( &h00, &h40, &h00 ), ( &h00, &h40, &h20 ), ( &h00, &h40, &h40 ), ( &h00, &h40, &h60 ), _
      ( &h00, &h40, &h80 ), ( &h00, &h40, &ha0 ), ( &h00, &h40, &hc0 ), ( &h00, &h40, &he0 ), _
      ( &h00, &h60, &h00 ), ( &h00, &h60, &h20 ), ( &h00, &h60, &h40 ), ( &h00, &h60, &h60 ), _
      ( &h00, &h60, &h80 ), ( &h00, &h60, &ha0 ), ( &h00, &h60, &hc0 ), ( &h00, &h60, &he0 ), _
      ( &h00, &h80, &h00 ), ( &h00, &h80, &h20 ), ( &h00, &h80, &h40 ), ( &h00, &h80, &h60 ), _
      ( &h00, &h80, &h80 ), ( &h00, &h80, &ha0 ), ( &h00, &h80, &hc0 ), ( &h00, &h80, &he0 ), _
      ( &h00, &ha0, &h00 ), ( &h00, &ha0, &h20 ), ( &h00, &ha0, &h40 ), ( &h00, &ha0, &h60 ), _
      ( &h00, &ha0, &h80 ), ( &h00, &ha0, &ha0 ), ( &h00, &ha0, &hc0 ), ( &h00, &ha0, &he0 ), _
      ( &h00, &hc0, &h00 ), ( &h00, &hc0, &h20 ), ( &h00, &hc0, &h40 ), ( &h00, &hc0, &h60 ), _
      ( &h00, &hc0, &h80 ), ( &h00, &hc0, &ha0 ), ( &h00, &hc0, &hc0 ), ( &h00, &hc0, &he0 ), _
      ( &h00, &he0, &h00 ), ( &h00, &he0, &h20 ), ( &h00, &he0, &h40 ), ( &h00, &he0, &h60 ), _
      ( &h00, &he0, &h80 ), ( &h00, &he0, &ha0 ), ( &h00, &he0, &hc0 ), ( &h00, &he0, &he0 ), _
      ( &h40, &h00, &h00 ), ( &h40, &h00, &h20 ), ( &h40, &h00, &h40 ), ( &h40, &h00, &h60 ), _
      ( &h40, &h00, &h80 ), ( &h40, &h00, &ha0 ), ( &h40, &h00, &hc0 ), ( &h40, &h00, &he0 ), _
      ( &h40, &h20, &h00 ), ( &h40, &h20, &h20 ), ( &h40, &h20, &h40 ), ( &h40, &h20, &h60 ), _
      ( &h40, &h20, &h80 ), ( &h40, &h20, &ha0 ), ( &h40, &h20, &hc0 ), ( &h40, &h20, &he0 ), _
      ( &h40, &h40, &h00 ), ( &h40, &h40, &h20 ), ( &h40, &h40, &h40 ), ( &h40, &h40, &h60 ), _
      ( &h40, &h40, &h80 ), ( &h40, &h40, &ha0 ), ( &h40, &h40, &hc0 ), ( &h40, &h40, &he0 ), _
      ( &h40, &h60, &h00 ), ( &h40, &h60, &h20 ), ( &h40, &h60, &h40 ), ( &h40, &h60, &h60 ), _
      ( &h40, &h60, &h80 ), ( &h40, &h60, &ha0 ), ( &h40, &h60, &hc0 ), ( &h40, &h60, &he0 ), _
      ( &h40, &h80, &h00 ), ( &h40, &h80, &h20 ), ( &h40, &h80, &h40 ), ( &h40, &h80, &h60 ), _
      ( &h40, &h80, &h80 ), ( &h40, &h80, &ha0 ), ( &h40, &h80, &hc0 ), ( &h40, &h80, &he0 ), _
      ( &h40, &ha0, &h00 ), ( &h40, &ha0, &h20 ), ( &h40, &ha0, &h40 ), ( &h40, &ha0, &h60 ), _
      ( &h40, &ha0, &h80 ), ( &h40, &ha0, &ha0 ), ( &h40, &ha0, &hc0 ), ( &h40, &ha0, &he0 ), _
      ( &h40, &hc0, &h00 ), ( &h40, &hc0, &h20 ), ( &h40, &hc0, &h40 ), ( &h40, &hc0, &h60 ), _
      ( &h40, &hc0, &h80 ), ( &h40, &hc0, &ha0 ), ( &h40, &hc0, &hc0 ), ( &h40, &hc0, &he0 ), _
      ( &h40, &he0, &h00 ), ( &h40, &he0, &h20 ), ( &h40, &he0, &h40 ), ( &h40, &he0, &h60 ), _
      ( &h40, &he0, &h80 ), ( &h40, &he0, &ha0 ), ( &h40, &he0, &hc0 ), ( &h40, &he0, &he0 ), _
      ( &h80, &h00, &h00 ), ( &h80, &h00, &h20 ), ( &h80, &h00, &h40 ), ( &h80, &h00, &h60 ), _
      ( &h80, &h00, &h80 ), ( &h80, &h00, &ha0 ), ( &h80, &h00, &hc0 ), ( &h80, &h00, &he0 ), _
      ( &h80, &h20, &h00 ), ( &h80, &h20, &h20 ), ( &h80, &h20, &h40 ), ( &h80, &h20, &h60 ), _
      ( &h80, &h20, &h80 ), ( &h80, &h20, &ha0 ), ( &h80, &h20, &hc0 ), ( &h80, &h20, &he0 ), _
      ( &h80, &h40, &h00 ), ( &h80, &h40, &h20 ), ( &h80, &h40, &h40 ), ( &h80, &h40, &h60 ), _
      ( &h80, &h40, &h80 ), ( &h80, &h40, &ha0 ), ( &h80, &h40, &hc0 ), ( &h80, &h40, &he0 ), _
      ( &h80, &h60, &h00 ), ( &h80, &h60, &h20 ), ( &h80, &h60, &h40 ), ( &h80, &h60, &h60 ), _
      ( &h80, &h60, &h80 ), ( &h80, &h60, &ha0 ), ( &h80, &h60, &hc0 ), ( &h80, &h60, &he0 ), _
      ( &h80, &h80, &h00 ), ( &h80, &h80, &h20 ), ( &h80, &h80, &h40 ), ( &h80, &h80, &h60 ), _
      ( &h80, &h80, &h80 ), ( &h80, &h80, &ha0 ), ( &h80, &h80, &hc0 ), ( &h80, &h80, &he0 ), _
      ( &h80, &ha0, &h00 ), ( &h80, &ha0, &h20 ), ( &h80, &ha0, &h40 ), ( &h80, &ha0, &h60 ), _
      ( &h80, &ha0, &h80 ), ( &h80, &ha0, &ha0 ), ( &h80, &ha0, &hc0 ), ( &h80, &ha0, &he0 ), _
      ( &h80, &hc0, &h00 ), ( &h80, &hc0, &h20 ), ( &h80, &hc0, &h40 ), ( &h80, &hc0, &h60 ), _
      ( &h80, &hc0, &h80 ), ( &h80, &hc0, &ha0 ), ( &h80, &hc0, &hc0 ), ( &h80, &hc0, &he0 ), _
      ( &h80, &he0, &h00 ), ( &h80, &he0, &h20 ), ( &h80, &he0, &h40 ), ( &h80, &he0, &h60 ), _
      ( &h80, &he0, &h80 ), ( &h80, &he0, &ha0 ), ( &h80, &he0, &hc0 ), ( &h80, &he0, &he0 ), _
      ( &hc0, &h00, &h00 ), ( &hc0, &h00, &h20 ), ( &hc0, &h00, &h40 ), ( &hc0, &h00, &h60 ), _
      ( &hc0, &h00, &h80 ), ( &hc0, &h00, &ha0 ), ( &hc0, &h00, &hc0 ), ( &hc0, &h00, &he0 ), _
      ( &hc0, &h20, &h00 ), ( &hc0, &h20, &h20 ), ( &hc0, &h20, &h40 ), ( &hc0, &h20, &h60 ), _
      ( &hc0, &h20, &h80 ), ( &hc0, &h20, &ha0 ), ( &hc0, &h20, &hc0 ), ( &hc0, &h20, &he0 ), _
      ( &hc0, &h40, &h00 ), ( &hc0, &h40, &h20 ), ( &hc0, &h40, &h40 ), ( &hc0, &h40, &h60 ), _
      ( &hc0, &h40, &h80 ), ( &hc0, &h40, &ha0 ), ( &hc0, &h40, &hc0 ), ( &hc0, &h40, &he0 ), _
      ( &hc0, &h60, &h00 ), ( &hc0, &h60, &h20 ), ( &hc0, &h60, &h40 ), ( &hc0, &h60, &h60 ), _
      ( &hc0, &h60, &h80 ), ( &hc0, &h60, &ha0 ), ( &hc0, &h60, &hc0 ), ( &hc0, &h60, &he0 ), _
      ( &hc0, &h80, &h00 ), ( &hc0, &h80, &h20 ), ( &hc0, &h80, &h40 ), ( &hc0, &h80, &h60 ), _
      ( &hc0, &h80, &h80 ), ( &hc0, &h80, &ha0 ), ( &hc0, &h80, &hc0 ), ( &hc0, &h80, &he0 ), _
      ( &hc0, &ha0, &h00 ), ( &hc0, &ha0, &h20 ), ( &hc0, &ha0, &h40 ), ( &hc0, &ha0, &h60 ), _
      ( &hc0, &ha0, &h80 ), ( &hc0, &ha0, &ha0 ), ( &hc0, &ha0, &hc0 ), ( &hc0, &ha0, &he0 ), _
      ( &hc0, &hc0, &h00 ), ( &hc0, &hc0, &h20 ), ( &hc0, &hc0, &h40 ), ( &hc0, &hc0, &h60 ), _
      ( &hc0, &hc0, &h80 ), ( &hc0, &hc0, &ha0 ), ( &hf0, &hfb, &hff ), ( &ha4, &ha0, &ha0 ), _
      ( &h80, &h80, &h80 ), ( &h00, &h00, &hff ), ( &h00, &hff, &h00 ), ( &h00, &hff, &hff ), _
      ( &hff, &h00, &h00 ), ( &hff, &h00, &hff ), ( &hff, &hff, &h00 ), ( &hff, &hff, &hff ) _
  }

  select case bpp
  case  1  : return @table_1(0)
  case  4  : return @table_4(0)
  case  8  : return @table_8(0)
  case else: return NULL
  end select
  
end function

enum D3DDDIFORMAT  
  D3DDDIFMT_UNKNOWN                  = 0
  D3DDDIFMT_R8G8B8                   = 20
  D3DDDIFMT_A8R8G8B8                 = 21
  D3DDDIFMT_X8R8G8B8                 = 22
  D3DDDIFMT_R5G6B5                   = 23
  D3DDDIFMT_X1R5G5B5                 = 24
  D3DDDIFMT_A1R5G5B5                 = 25
  D3DDDIFMT_A4R4G4B4                 = 26
  D3DDDIFMT_R3G3B2                   = 27
  D3DDDIFMT_A8                       = 28
  D3DDDIFMT_A8R3G3B2                 = 29
  D3DDDIFMT_X4R4G4B4                 = 30
  D3DDDIFMT_A2B10G10R10              = 31
  D3DDDIFMT_A8B8G8R8                 = 32
  D3DDDIFMT_X8B8G8R8                 = 33
  D3DDDIFMT_G16R16                   = 34
  D3DDDIFMT_A2R10G10B10              = 35
  D3DDDIFMT_A16B16G16R16             = 36
  D3DDDIFMT_A8P8                     = 40
  D3DDDIFMT_P8                       = 41
  D3DDDIFMT_L8                       = 50
  D3DDDIFMT_A8L8                     = 51
  D3DDDIFMT_A4L4                     = 52
  D3DDDIFMT_V8U8                     = 60
  D3DDDIFMT_L6V5U5                   = 61
  D3DDDIFMT_X8L8V8U8                 = 62
  D3DDDIFMT_Q8W8V8U8                 = 63
  D3DDDIFMT_V16U16                   = 64
  D3DDDIFMT_W11V11U10                = 65
  D3DDDIFMT_A2W10V10U10              = 67
  D3DDDIFMT_UYVY                     = CVI("UYVY")
  D3DDDIFMT_R8G8_B8G8                = CVI("RGBG")
  D3DDDIFMT_YUY2                     = CVI("YUU2")
  D3DDDIFMT_G8R8_G8B8                = CVI("GRGB")
  D3DDDIFMT_DXT1                     = CVI("DXT1")
  D3DDDIFMT_DXT2                     = CVI("DXT2")
  D3DDDIFMT_DXT3                     = CVI("DXT3")
  D3DDDIFMT_DXT4                     = CVI("DXT4")
  D3DDDIFMT_DXT5                     = CVI("DXT5")
  D3DDDIFMT_D16_LOCKABLE             = 70
  D3DDDIFMT_D32                      = 71
  D3DDDIFMT_D15S1                    = 73
  D3DDDIFMT_D24S8                    = 75
  D3DDDIFMT_D24X8                    = 77
  D3DDDIFMT_D24X4S4                  = 79
  D3DDDIFMT_D16                      = 80
  D3DDDIFMT_D32F_LOCKABLE            = 82
  D3DDDIFMT_D24FS8                   = 83
  D3DDDIFMT_D32_LOCKABLE             = 84
  D3DDDIFMT_S8_LOCKABLE              = 85
  D3DDDIFMT_S1D15                    = 72
  D3DDDIFMT_S8D24                    = 74
  D3DDDIFMT_X8D24                    = 76
  D3DDDIFMT_X4S4D24                  = 78
  D3DDDIFMT_L16                      = 81
'#if (D3D_UMD_INTERFACE_VERSION >= D3D_UMD_INTERFACE_VERSION_WDDM1_3)
  D3DDDIFMT_G8R8                     = 91
  D3DDDIFMT_R8                       = 92
'#endif 
  D3DDDIFMT_VERTEXDATA               = 100
  D3DDDIFMT_INDEX16                  = 101
  D3DDDIFMT_INDEX32                  = 102
  D3DDDIFMT_Q16W16V16U16             = 110
  D3DDDIFMT_MULTI2_ARGB8             = cvi("METI")
  D3DDDIFMT_R16F                     = 111
  D3DDDIFMT_G16R16F                  = 112
  D3DDDIFMT_A16B16G16R16F            = 113
  D3DDDIFMT_R32F                     = 114
  D3DDDIFMT_G32R32F                  = 115
  D3DDDIFMT_A32B32G32R32F            = 116
  D3DDDIFMT_CxV8U8                   = 117
  D3DDDIFMT_A1                       = 118
  D3DDDIFMT_A2B10G10R10_XR_BIAS      = 119
  D3DDDIFMT_DXVACOMPBUFFER_BASE      = 150
  D3DDDIFMT_PICTUREPARAMSDATA        = D3DDDIFMT_DXVACOMPBUFFER_BASE+0
  D3DDDIFMT_MACROBLOCKDATA           = D3DDDIFMT_DXVACOMPBUFFER_BASE+1
  D3DDDIFMT_RESIDUALDIFFERENCEDATA   = D3DDDIFMT_DXVACOMPBUFFER_BASE+2
  D3DDDIFMT_DEBLOCKINGDATA           = D3DDDIFMT_DXVACOMPBUFFER_BASE+3
  D3DDDIFMT_INVERSEQUANTIZATIONDATA  = D3DDDIFMT_DXVACOMPBUFFER_BASE+4
  D3DDDIFMT_SLICECONTROLDATA         = D3DDDIFMT_DXVACOMPBUFFER_BASE+5
  D3DDDIFMT_BITSTREAMDATA            = D3DDDIFMT_DXVACOMPBUFFER_BASE+6
  D3DDDIFMT_MOTIONVECTORBUFFER       = D3DDDIFMT_DXVACOMPBUFFER_BASE+7
  D3DDDIFMT_FILMGRAINBUFFER          = D3DDDIFMT_DXVACOMPBUFFER_BASE+8
  D3DDDIFMT_DXVA_RESERVED9           = D3DDDIFMT_DXVACOMPBUFFER_BASE+9
  D3DDDIFMT_DXVA_RESERVED10          = D3DDDIFMT_DXVACOMPBUFFER_BASE+10
  D3DDDIFMT_DXVA_RESERVED11          = D3DDDIFMT_DXVACOMPBUFFER_BASE+11
  D3DDDIFMT_DXVA_RESERVED12          = D3DDDIFMT_DXVACOMPBUFFER_BASE+12
  D3DDDIFMT_DXVA_RESERVED13          = D3DDDIFMT_DXVACOMPBUFFER_BASE+13
  D3DDDIFMT_DXVA_RESERVED14          = D3DDDIFMT_DXVACOMPBUFFER_BASE+14
  D3DDDIFMT_DXVA_RESERVED15          = D3DDDIFMT_DXVACOMPBUFFER_BASE+15
  D3DDDIFMT_DXVA_RESERVED16          = D3DDDIFMT_DXVACOMPBUFFER_BASE+16
  D3DDDIFMT_DXVA_RESERVED17          = D3DDDIFMT_DXVACOMPBUFFER_BASE+17
  D3DDDIFMT_DXVA_RESERVED18          = D3DDDIFMT_DXVACOMPBUFFER_BASE+18
  D3DDDIFMT_DXVA_RESERVED19          = D3DDDIFMT_DXVACOMPBUFFER_BASE+19
  D3DDDIFMT_DXVA_RESERVED20          = D3DDDIFMT_DXVACOMPBUFFER_BASE+20
  D3DDDIFMT_DXVA_RESERVED21          = D3DDDIFMT_DXVACOMPBUFFER_BASE+21
  D3DDDIFMT_DXVA_RESERVED22          = D3DDDIFMT_DXVACOMPBUFFER_BASE+22
  D3DDDIFMT_DXVA_RESERVED23          = D3DDDIFMT_DXVACOMPBUFFER_BASE+23
  D3DDDIFMT_DXVA_RESERVED24          = D3DDDIFMT_DXVACOMPBUFFER_BASE+24
  D3DDDIFMT_DXVA_RESERVED25          = D3DDDIFMT_DXVACOMPBUFFER_BASE+25
  D3DDDIFMT_DXVA_RESERVED26          = D3DDDIFMT_DXVACOMPBUFFER_BASE+26
  D3DDDIFMT_DXVA_RESERVED27          = D3DDDIFMT_DXVACOMPBUFFER_BASE+27
  D3DDDIFMT_DXVA_RESERVED28          = D3DDDIFMT_DXVACOMPBUFFER_BASE+28
  D3DDDIFMT_DXVA_RESERVED29          = D3DDDIFMT_DXVACOMPBUFFER_BASE+29
  D3DDDIFMT_DXVA_RESERVED30          = D3DDDIFMT_DXVACOMPBUFFER_BASE+30
  D3DDDIFMT_DXVA_RESERVED31          = D3DDDIFMT_DXVACOMPBUFFER_BASE+31
  D3DDDIFMT_DXVACOMPBUFFER_MAX       = D3DDDIFMT_DXVA_RESERVED31
  D3DDDIFMT_BINARYBUFFER             = 199
  D3DDDIFMT_FORCE_UINT               = &h7fffffff
end enum

type D3DKMT_CREATEDCFROMMEMORY
  as any ptr          pMemory
  as D3DDDIFORMAT     Format
  as UINT             Width
  as UINT             Height
  as UINT             Pitch
  as HDC              hDeviceDC
  as PALETTEENTRY ptr pColorTable
  as HDC              hDC
  as HANDLE           hBitmap
end type
   
type D3DKMT_DESTROYDCFROMMEMORY  
  as HDC    hDC
  as HANDLE hBitmap
end type

type BITMAPOBJ
    as DIBSECTION dib
    as SIZE       size           '/* For SetBitmapDimension() */
    as RGBQUAD    ptr color_table';  /* DIB color table if <= 8bpp (always 1 << bpp in size) */
end type

#define get_dib_stride( _width, _bpp ) ((((_width) * (_bpp) + 31) shr 3) and (not 3))
