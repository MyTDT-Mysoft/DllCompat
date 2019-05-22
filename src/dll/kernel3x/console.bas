#include "win\strsafe.bi"
#include "string.bi"

static shared as COLORREF DefaultColours(16-1) = { _
  &h00000000, &h00800000, &h00008000, &h00808000,  _
  &h00000080, &h00800080, &h00008080, &h00C0C0C0,  _
  &h00808080, &h00FF0000, &h0000FF00, &h00FFFF00,  _
  &h000000FF, &h00FF00FF, &h0000FFFF, &h00FFFFFF   _
}

extern "windows-ms"
  UndefAllParams()
  #define P1 hConsoleOutput              as _In_  HANDLE
  #define P2 lpConsoleScreenBufferInfoEx as _Out_ PCONSOLE_SCREEN_BUFFER_INFOEX
  function _GetConsoleScreenBufferInfoEx alias "GetConsoleScreenBufferInfoEx"(P1, P2) as BOOL export
    dim as BOOL ret
    dim as CONSOLE_SCREEN_BUFFER_INFO inf = any
    
    if lpConsoleScreenBufferInfoEx->cbSize<>sizeof(CONSOLE_SCREEN_BUFFER_INFOEX) then
        SetLastError(ERROR_INVALID_PARAMETER)
        return FALSE
    end if
    
    ret = GetConsoleScreenBufferInfo(hConsoleOutput, @inf)
    if ret then
      lpConsoleScreenBufferInfoEx->cbSize               = sizeof(CONSOLE_SCREEN_BUFFER_INFOEX)
      lpConsoleScreenBufferInfoEx->dwSize               = inf.dwSize
      lpConsoleScreenBufferInfoEx->dwCursorPosition     = inf.dwCursorPosition
      lpConsoleScreenBufferInfoEx->wAttributes          = inf.wAttributes
      lpConsoleScreenBufferInfoEx->srWindow             = inf.srWindow
      lpConsoleScreenBufferInfoEx->dwMaximumWindowSize  = inf.dwMaximumWindowSize
      lpConsoleScreenBufferInfoEx->wPopupAttributes     = &hF5 'default value in win7
      lpConsoleScreenBufferInfoEx->bFullscreenSupported = TRUE 'always supported in XP
      memcpy(@lpConsoleScreenBufferInfoEx->ColorTable(0), @DefaultColours(0), 16*4)
    end if
    
    return ret
  end function
  
  UndefAllParams()
  #define P1 hConsoleOutput              as _In_  HANDLE
  #define P2 lpConsoleScreenBufferInfoEx as _In_  PCONSOLE_SCREEN_BUFFER_INFOEX
  function _SetConsoleScreenBufferInfoEx alias "SetConsoleScreenBufferInfoEx"(P1, P2) as BOOL export
    dim as BOOL ret
    
    if lpConsoleScreenBufferInfoEx->cbSize<>sizeof(CONSOLE_SCREEN_BUFFER_INFOEX) then
        SetLastError(ERROR_INVALID_PARAMETER)
        return FALSE
    end if
    
    '
    return TRUE
  end function
end extern