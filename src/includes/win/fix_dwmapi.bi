#pragma once

#define DWM_E_COMPOSITIONDISABLED   &H80263001L

type DWM_FRAME_COUNT as ULONGLONG
type QPC_TIME as ULONGLONG

type HTHUMBNAIL as HANDLE
type PHTHUMBNAIL as HTHUMBNAIL ptr
    
type DWM_SOURCE_FRAME_SAMPLING as integer

type _DWM_THUMBNAIL_PROPERTIES
    dwFlags as DWORD
    rcDestination as RECT
    rcSource as RECT
    opacity as BYTE
    fVisible as BOOL
    fSourceClientAreaOnly as BOOL
end type
type DWM_THUMBNAIL_PROPERTIES as _DWM_THUMBNAIL_PROPERTIES
type PDWM_THUMBNAIL_PROPERTIES as _DWM_THUMBNAIL_PROPERTIES ptr

type _UNSIGNED_RATIO
    uiNumerator as UINT32
    uiDenominator as UINT32
end type

type UNSIGNED_RATIO as _UNSIGNED_RATIO

type _DWM_PRESENT_PARAMETERS
    cbSize as UINT32
    fQueue as BOOL
    cRefreshStart as DWM_FRAME_COUNT
    cBuffer as UINT
    fUseSourceRate as BOOL
    rateSource as UNSIGNED_RATIO
    cRefreshesPerFrame as UINT
    eSampling as DWM_SOURCE_FRAME_SAMPLING
end type
type DWM_PRESENT_PARAMETERS as _DWM_PRESENT_PARAMETERS

type _MilMatrix3x2D
  S_11 as double
  S_12 as double
  S_21 as double
  S_22 as double
  DX   as double
  DY   as double
end type
type MilMatrix3x2D as _MilMatrix3x2D

type _DWM_TIMING_INFO
    cbSize                 as UINT
    rateRefresh            as UNSIGNED_RATIO
    qpcRefreshPeriod       as QPC_TIME
    rateCompose            as UNSIGNED_RATIO
    qpcVBlank              as QPC_TIME
    cRefresh               as DWM_FRAME_COUNT
    cDXRefresh             as UINT
    qpcCompose             as QPC_TIME
    cFrame                 as DWM_FRAME_COUNT
    cDXPresent             as UINT
    cRefreshFrame          as DWM_FRAME_COUNT
    cFrameSubmitted        as DWM_FRAME_COUNT
    cDXPresentSubmitted    as UINT
    cFrameConfirmed        as DWM_FRAME_COUNT
    cDXPresentConfirmed    as UINT
    cRefreshConfirmed      as DWM_FRAME_COUNT
    cDXRefreshConfirmed    as UINT
    cFramesLate            as DWM_FRAME_COUNT
    cFramesOutstanding     as UINT
    cFrameDisplayed        as DWM_FRAME_COUNT
    qpcFrameDisplayed      as QPC_TIME
    cRefreshFrameDisplayed as DWM_FRAME_COUNT
    cFrameComplete         as DWM_FRAME_COUNT
    qpcFrameComplete       as QPC_TIME
    cFramePending          as DWM_FRAME_COUNT
    qpcFramePending        as QPC_TIME
    cFramesDisplayed       as DWM_FRAME_COUNT
    cFramesComplete        as DWM_FRAME_COUNT
    cFramesPending         as DWM_FRAME_COUNT
    cFramesAvailable       as DWM_FRAME_COUNT
    cFramesDropped         as DWM_FRAME_COUNT
    cFramesMissed          as DWM_FRAME_COUNT
    cRefreshNextDisplayed  as DWM_FRAME_COUNT
    cRefreshNextPresented  as DWM_FRAME_COUNT
    cRefreshesDisplayed    as DWM_FRAME_COUNT
    cRefreshesPresented    as DWM_FRAME_COUNT
    cRefreshStarted        as DWM_FRAME_COUNT
    cPixelsReceived        as ULONGLONG
    cPixelsDrawn           as ULONGLONG
    cBuffersEmpty          as DWM_FRAME_COUNT
end type
type DWM_TIMING_INFO as _DWM_TIMING_INFO

type _DWM_BLURBEHIND
    dwFlags as DWORD
    fEnable as BOOL
    hRgnBlur as HRGN
    fTransitionOnMaximized as BOOL
end type
type DWM_BLURBEHIND as _DWM_BLURBEHIND
type PDWM_BLURBEHIND as _DWM_BLURBEHIND ptr