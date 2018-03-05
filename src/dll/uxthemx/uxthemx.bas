#include "windows.bi"
#include "win\tmschema.bi"
#include "win\uxtheme.bi"
#include "shared\helper.bas"
#include "includes\win\uxtheme_fix.bi"

extern "windows-ms"
  UndefAllParams()
  #define P1 hTheme as HTHEME
  #define P2 hdc as HDC
  #define P3 iPartId as integer
  #define P4 iStateId as integer
  #define P5 pszText as LPCWSTR
  #define P6 iCharCount as integer
  #define P7 dwFlags as DWORD
  #define P8 pRect as LPRECT
  #define P9 pOptions as const DTTOPTS ptr
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
        'FIXME("unsupported flags 0x%08x\n", pOptions->dwFlags)
    end if
    
    hr = GetThemeFont(hTheme, hdc, iPartId, iStateId, TMT_FONT, @logfont)
    if SUCCEEDED(hr) then
      hFont = CreateFontIndirectW(@logfont)
      if hFont=0 then
        'TRACE("Failed to create font\n")
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
  #define P2 iPartId as integer
  #define P3 iStateIdFrom as integer
  #define P4 iStateIdTo as integer
  #define P5 iPropId as integer
  #define P6 pdwDuration as DWORD ptr
  function GetThemeTransitionDuration(P1, P2, P3, P4, P5, P6) as HRESULT export
    return ERROR_OUT_OF_PAPER
  end function
  
  UndefAllParams()
  #define P1 hwnd as HWND
  #define P2 eAttribute as WINDOWTHEMEATTRIBUTETYPE 'enum
  #define P3 pvAttribute as PVOID
  #define P4 cbAttribute as DWORD
  function SetWindowThemeAttribute(P1, P2, P3, P4) as HRESULT export
    return ERROR_OUT_OF_PAPER
  end function
end extern