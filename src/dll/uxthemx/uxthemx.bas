#define fbc -dll -Wl "uxthemx.dll.def" -x ..\..\..\bin\dll\uxthemx.dll -i ..\..\

#include "windows.bi"
#include "win\tmschema.bi"
#include "win\uxtheme.bi"
#include "shared\helper.bas"
#include "includes\win\fix_uxtheme.bi"

extern "windows-ms"
  UndefAllParams()
  #define P1 hTheme     as _In_    HTHEME
  #define P2 hdc        as _In_    HDC
  #define P3 iPartId    as _In_    int
  #define P4 iStateId   as _In_    int
  #define P5 pszText    as _In_    LPCWSTR
  #define P6 iCharCount as _In_    int
  #define P7 dwFlags    as _In_    DWORD
  #define P8 pRect      as _Inout_ LPRECT
  #define P9 pOptions   as _In_    const DTTOPTS ptr
  function DrawThemeTextEx(P1, P2, P3, P4, P5, P6, P7, P8, P9) as HRESULT export
    'testme: GetThemeFont warning param 6
    dim hr as HRESULT
    dim hFont as HFONT = 0
    dim oldFont as HGDIOBJ = 0
    dim logfont as LOGFONTW
    dim textColor as COLORREF
    dim oldTextColor as COLORREF
    dim oldBkMode as integer

    if hTheme=0 then
      return E_HANDLE
    end if

    if (pOptions->dwFlags and not DTT_TEXTCOLOR) then
        DEBUG_MsgTrace("unsupported flags 0x%08x\n", pOptions->dwFlags)
    end if
    
    hr = GetThemeFont(hTheme, hdc, iPartId, iStateId, TMT_FONT, @logfont)
    if SUCCEEDED(hr) then
      hFont = CreateFontIndirectW(@logfont)
      if hFont=0 then
        DEBUG_MsgTrace("Failed to create font\n")
      end if
    end if
    
    if hFont then
        oldFont = SelectObject(hdc, hFont)
    end if

    if (pOptions->dwFlags and DTT_TEXTCOLOR) then
        textColor = pOptions->crText
    else
        if FAILED(GetThemeColor(hTheme, iPartId, iStateId, TMT_TEXTCOLOR, @textColor)) then
            textColor = GetTextColor(hdc)
        end if
    end if
    oldTextColor = SetTextColor(hdc, textColor)
    oldBkMode = SetBkMode(hdc, TRANSPARENT)
    DrawTextW(hdc, pszText, iCharCount, pRect, dwFlags)
    SetBkMode(hdc, oldBkMode)
    SetTextColor(hdc, oldTextColor)

    if hFont then
        SelectObject(hdc, oldFont)
        DeleteObject(hFont)
    end if
    return S_OK
  end function
  
  UndefAllParams()
  #define P1 hTheme as HTHEME
  #define P2 iPartId as int
  #define P3 iStateIdFrom as int
  #define P4 iStateIdTo as int
  #define P5 iPropId as int
  #define P6 pdwDuration as DWORD ptr
  function GetThemeTransitionDuration(P1, P2, P3, P4, P5, P6) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  UndefAllParams()
  #define P1 hwnd        as _In_ HWND
  #define P2 eAttribute  as _In_ WINDOWTHEMEATTRIBUTETYPE
  #define P3 pvAttribute as _In_ PVOID
  #define P4 cbAttribute as _In_ DWORD
  function SetWindowThemeAttribute(P1, P2, P3, P4) as HRESULT export
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern

#include "shared\defaultmain.bas"