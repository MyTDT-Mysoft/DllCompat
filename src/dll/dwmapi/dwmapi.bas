#define fbc -dll -Wl "dwmapi.dll.def" -x ..\..\..\bin\dll\dwmapi.dll -i ..\..\

#include "windows.bi"
#include "win\uxtheme.bi"
#include "includes\win\fix_dwmapi.bi"
#include "includes\win\extraerrs.bi"
#include "shared\helper.bas"

extern "windows-ms"
  UndefAllParams()
  #define P1 hwnd as _In_ HWND
  function DwmAttachMilContent(P1) as HRESULT export
    'deprecated in Win7
    return DWM_E_COMPOSITIONDISABLED
  end function
  
  UndefAllParams()
  #define P1 hwnd     as _In_  HWND
  #define P2 msg      as       UINT
  #define P3 wParam   as       WPARAM
  #define P4 lParam   as       LPARAM
  #define P5 plResult as _Out_ LRESULT ptr
  function DwmDefWindowProc(P1, P2, P3, P4, P5) as BOOL export
    DEBUG_MsgNotImpl()
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hwnd as _In_ HWND
  function DwmDetachMilContent(P1) as HRESULT export
    'deprecated in Win7
    return DWM_E_COMPOSITIONDISABLED
  end function
  
  UndefAllParams()
  #define P1 hWnd        as      HWND
  #define P2 pBlurBehind as _In_ const DWM_BLURBEHIND ptr
  function DwmEnableBlurBehindWindow(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 uCompositionAction as UINT
  function DwmEnableComposition(P1) as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 fEnableMMCSS as BOOL
  function DwmEnableMMCSS(P1) as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hWnd      as HWND
  #define P2 pMarInset as _In_ const MARGINS ptr
  function DwmExtendFrameIntoClientArea(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  function DwmFlush() as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 pcrColorization as _Out_ DWORD ptr
  #define P2 pfOpaqueBlend   as _Out_ BOOL ptr
  function DwmGetColorizationColor(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd        as       HWND
  #define P2 pTimingInfo as _Out_ DWM_TIMING_INFO ptr
  function DwmGetCompositionTimingInfo(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 uIndex      as       UINT
  #define P2 pClientUuid as _Out_ UUID ptr
  function DwmGetGraphicsStreamClient(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 uIndex     as       UINT
  #define P2 pTransform as _Out_ MilMatrix3x2D ptr
  function DwmGetGraphicsStreamTransformHint(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 pfIsRemoting  as _Out_ BOOL ptr
  #define P2 pfIsConnected as _Out_ BOOL ptr
  #define P3 pDwGeneration as _Out_ DWORD ptr
  function DwmGetTransportAttributes(P1, P2, P3) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd        as       HWND
  #define P2 dwAttribute as       DWORD
  #define P3 pvAttribute as _Out_ PVOID
  #define P4 cbAttribute as       DWORD
  function DwmGetWindowAttribute(P1, P2, P3, P4) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd as _In_ HWND
  function DwmInvalidateIconicBitmaps(P1) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 pfEnabled as _Out_ BOOL ptr
  function DwmIsCompositionEnabled(P1) as HRESULT export
    *pfEnabled = FALSE
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hwnd       as HWND
  #define P2 cRefreshes as integer
  #define P3 fRelative  as BOOL
  function DwmModifyPreviousDxFrameDuration(P1, P2, P3) as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hThumbnail as       HTHUMBNAIL
  #define P2 pSize      as _Out_ PSIZE
  function DwmQueryThumbnailSourceSize(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwndDestination as       HWND
  #define P2 hwndSource      as       HWND
  #define P3 phThumbnailId   as _Out_ PHTHUMBNAIL
  function DwmRegisterThumbnail(P1, P2, P3) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd       as HWND
  #define P2 cRefreshes as INT
  function DwmSetDxFrameDuration(P1, P2) as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hwnd       as          HWND
  #define P2 hbmp       as          HBITMAP
  #define P3 pptClient  as _In_opt_ POINT ptr
  #define P4 dwSITFlags as          DWORD
  function DwmSetIconicLivePreviewBitmap(P1, P2, P3, P4) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd       as _In_ HWND
  #define P2 hbmp       as _In_ HBITMAP
  #define P3 dwSITFlags as _In_ DWORD
  function DwmSetIconicThumbnail(P1, P2, P3) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd           as         HWND
  #define P2 pPresentParams as _Inout_ DWM_PRESENT_PARAMETERS ptr
  function DwmSetPresentParameters(P1, P2) as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hwnd        as         HWND
  #define P2 dwAttribute as         DWORD
  #define P3 pvAttribute as _Inout_ LPCVOID
  #define P4 cbAttribute as         DWORD
  function DwmSetWindowAttribute(P1, P2, P3, P4) as HRESULT export
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hThumbnailId as HTHUMBNAIL
  function DwmUnregisterThumbnail(P1) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hThumbnailId  as      HTHUMBNAIL
  #define P2 ptnProperties as _In_ const DWM_THUMBNAIL_PROPERTIES ptr
  function DwmUpdateThumbnailProperties(P1, P2) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern

#include "shared\defaultmain.bas"