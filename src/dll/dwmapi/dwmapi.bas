#define fbc -dll -Wl "dwmapi.dll.def" -x ..\..\..\bin\dll\dwmapi.dll -i ..\..\

#include "windows.bi"
#include "win\uxtheme.bi"
#include "shared\helper.bas"
#include "includes\win\dwmapi.bi"
#include "includes\win\extraerrs.bi"

extern "windows-ms"
  UndefAllParams()
  #define P1 hwnd as HWND
  'deprecated in Win7
  function DwmAttachMilContent(P1) as HRESULT
    return DWM_E_COMPOSITIONDISABLED
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 msg as UINT
  #define P3 wParam as WPARAM
  #define P4 lParam as LPARAM
  #define P5 plResult as LRESULT ptr
  function DwmDefWindowProc(P1, P2, P3, P4, P5) as BOOL
    'UnimplementedFunction()
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  'deprecated in Win7
  function DwmDetachMilContent(P1) as HRESULT
    return DWM_E_COMPOSITIONDISABLED
  end function
  
  UndefAllParams()
  #define P1 hWnd as HWND
  #define P2 pBlurBehind as const DWM_BLURBEHIND ptr
  function DwmEnableBlurBehindWindow(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 uCompositionAction as UINT
  function DwmEnableComposition(P1) as HRESULT
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 fEnableMMCSS as BOOL
  function DwmEnableMMCSS(P1) as HRESULT
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hWnd as HWND
  #define P2 pMarInset as const MARGINS ptr
  function DwmExtendFrameIntoClientArea(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  function DwmFlush() as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 pcrColorization as DWORD ptr
  #define P2 pfOpaqueBlend as BOOL ptr
  function DwmGetColorizationColor(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 pTimingInfo as DWM_TIMING_INFO ptr
  function DwmGetCompositionTimingInfo(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 uIndex as UINT
  #define P2 pClientUuid as UUID ptr
  function DwmGetGraphicsStreamClient(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 uIndex as UINT
  #define P2 pTransform as MilMatrix3x2D ptr
  function DwmGetGraphicsStreamTransformHint(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 pfIsRemoting as BOOL ptr
  #define P2 pfIsConnected as BOOL ptr
  #define P3 pDwGeneration as DWORD ptr
  function DwmGetTransportAttributes(P1, P2, P3) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 attribute as DWORD
  #define P3 pv_attribute as PVOID
  #define P4 size as DWORD
  function DwmGetWindowAttribute(P1, P2, P3, P4) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  function DwmInvalidateIconicBitmaps(P1) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 enabled as BOOL ptr
  function DwmIsCompositionEnabled(P1) as HRESULT
    *enabled = FALSE
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 cRefreshes as integer
  #define P3 fRelative as BOOL
  function DwmModifyPreviousDxFrameDuration(P1, P2, P3) as HRESULT
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hThumbnail as HTHUMBNAIL
  #define P2 pSize as PSIZE
  function DwmQueryThumbnailSourceSize(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 dest as HWND
  #define P2 src as HWND
  #define P3 thumbnail_id as PHTHUMBNAIL
  function DwmRegisterThumbnail(P1, P2, P3) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 cRefreshes as integer
  function DwmSetDxFrameDuration(P1, P2) as HRESULT
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 hbmp as HBITMAP
  #define P3 pptClient as POINT ptr
  #define P4 dwSITFlags as DWORD
  function DwmSetIconicLivePreviewBitmap(P1, P2, P3, P4) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 hbmp as HBITMAP
  #define P3 dwSITFlags as DWORD
  function DwmSetIconicThumbnail(P1, P2, P3) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 params as DWM_PRESENT_PARAMETERS ptr
  function DwmSetPresentParameters(P1, P2) as HRESULT
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 attributenum as DWORD
  #define P3 attribute as LPCVOID
  #define P4 size as DWORD
  function DwmSetWindowAttribute(P1, P2, P3, P4) as HRESULT
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 thumbnail as HTHUMBNAIL
  function DwmUnregisterThumbnail(P1) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 thumbnail as HTHUMBNAIL
  #define P2 props as const DWM_THUMBNAIL_PROPERTIES ptr
  function DwmUpdateThumbnailProperties(P1, P2) as HRESULT
    'UnimplementedFunction()
    return ERROR_OUT_OF_PAPER
  end function
end extern