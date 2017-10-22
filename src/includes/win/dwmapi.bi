#pragma once

type _DWM_BLURBEHIND
    dwFlags as DWORD
    fEnable as BOOL
    hRgnBlur as HRGN
    fTransitionOnMaximized as BOOL
end type
type DWM_BLURBEHIND as _DWM_BLURBEHIND
type PDWM_BLURBEHIND as _DWM_BLURBEHIND ptr

extern "windows-ms"
  declare function DwmAttachMilContent(byval as HWND) as HRESULT
  declare function DwmDefWindowProc(byval as HWND, byval as UINT, byval as WPARAM, byval as LPARAM, byval as LRESULT ptr) as BOOL
  declare function DwmDetachMilContent(byval as HWND) as HRESULT
  declare function DwmEnableBlurBehindWindow(byval as HWND, byval as const DWM_BLURBEHIND ptr) as HRESULT
  declare function DwmEnableComposition(byval as UINT) as HRESULT
  declare function DwmEnableMMCSS(byval as BOOL) as HRESULT
  declare function DwmExtendFrameIntoClientArea(byval as HWND, byval as const MARGINS ptr) as HRESULT
  declare function DwmFlush() as HRESULT
  declare function DwmGetColorizationColor(byval as DWORD ptr, byval as BOOL ptr) as HRESULT
  declare function DwmGetCompositionTimingInfo(byval as HWND, byval as DWM_TIMING_INFO ptr) as HRESULT
  declare function DwmGetGraphicsStreamClient(byval as UINT, byval as UUID ptr) as HRESULT
  declare function DwmGetGraphicsStreamTransformHint(byval as UINT, byval as MilMatrix3x2D ptr) as HRESULT
  declare function DwmGetTransportAttributes(byval as BOOL ptr, byval as BOOL ptr, byval as DWORD ptr) as HRESULT
  declare function DwmGetWindowAttribute(byval as HWND, byval as DWORD, byval as PVOID, byval as DWORD) as HRESULT
  declare function DwmInvalidateIconicBitmaps(byval as HWND) as HRESULT
  declare function DwmIsCompositionEnabled(byval as BOOL ptr) as HRESULT
  declare function DwmModifyPreviousDxFrameDuration(byval as HWND, byval as INT, byval as BOOL) as HRESULT
  declare function DwmQueryThumbnailSourceSize(byval as HTHUMBNAIL, byval as PSIZE) as HRESULT
  declare function DwmRegisterThumbnail(byval as HWND, byval as HWND, byval as PHTHUMBNAIL) as HRESULT
  declare function DwmSetDxFrameDuration(HWND, INT) as HRESULT
  declare function DwmSetIconicLivePreviewBitmap(byval as HWND, byval as HBITMAP, byval as POINT ptr, byval as DWORD) as HRESULT
  declare function DwmSetIconicThumbnail(byval as HWND, byval as HBITMAP, byval as DWORD) as HRESULT
  declare function DwmSetPresentParameters(byval as HWND, byval as DWM_PRESENT_PARAMETERS ptr) as HRESULT
  declare function DwmSetWindowAttribute(byval as HWND, byval as DWORD, byval as LPCVOID, byval as DWORD) as HRESULT
  declare function DwmUnregisterThumbnail(byval as HTHUMBNAIL) as HRESULT
  declare function DwmUpdateThumbnailProperties(byval as HTHUMBNAIL, byval as const DWM_THUMBNAIL_PROPERTIES ptr) as HRESULT
end extern