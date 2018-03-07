#include "crt\stdio.bi"
#include "crt\ctype.bi"

#undef BOOL
#undef WINBOOL
type BOOL as integer
type WINBOOL as integer

#macro UndefAllParams()
  #undef P1
  #undef P2
  #undef P3
  #undef P4
  #undef P5
  #undef P6
  #undef P7
  #undef P8
  #undef P9
  #undef P10
  #undef P11
  #undef P12
  #undef P13
  #undef P14
  #undef P15
  #undef P16
#endmacro

' **************************************************************************
#define GlobalDebugEnabled

#macro DEBUG_AlertNotImpl()
  #ifdef GlobalDebugEnabled
    OutputDebugString("ALERT: " __FUNCTION__ !" STUB called.\r\n" )
    messagebox(null, __FUNCTION__ !" STUB called.\r\n", "DllCompat", MB_SYSTEMMODAL or MB_ICONINFORMATION)
  #endif
#endmacro

#macro DEBUG_MsgNotImpl()
  #ifdef GlobalDebugEnabled
    OutputDebugString("MSG:   " __FUNCTION__ !" STUB called. \r\n" )
  #endif
#endmacro

#macro DEBUG_MsgTrace(_STRING , _PARAMS...)
  #ifdef GlobalDebugEnabled
    scope
      dim as zstring*4096 zTemp = any
      sprintf(zTemp , "MSG:   %s(%i): " _STRING , __FUNCTION__  , __LINE__ , _PARAMS)  
      OutputDebugString(zTemp)
    end scope
  #endif
#endmacro

#macro DEBUG_TripDebugger()
  #ifdef GlobalDebugEnabled
    if IsDebuggerPresent() then
      asm .byte 0xCC
    end if
  #endif
#endmacro
' **************************************************************************  

sub hexdump(mem as any ptr, lenny as UInteger, elemsize as UInteger)
  'Courtesy of Grapus
  'http://grapsus.net/blog/post/Hexadecimal-dump-in-C
  #define HEXDUMP_COLS 16
  dim as UByte ptr chmem = cast(UByte ptr, mem)
  dim as UInteger i, j
  lenny *= elemsize
  
  for i=0 to lenny + iif((lenny mod HEXDUMP_COLS), (HEXDUMP_COLS - lenny mod HEXDUMP_COLS), 0) -1
    'print offset
    if i mod HEXDUMP_COLS = 0 then
      printf("%06x: ", i)
    end if

    'print hex data
    if i < lenny then
      printf("%02x ", chmem[i])
    else 'end of block, just aligning for ASCII dump
      printf("   ")
    end if
    
    'print ASCII dump
    if i mod HEXDUMP_COLS = (HEXDUMP_COLS - 1) then
      for j = i - (HEXDUMP_COLS - 1) to i
        if j >= lenny then 'end of block, not really printing
          putchar( asc(" ") )
        elseif(isprint(chmem[j])) then 'printable char
          putchar(chmem[j])
        else 'other char
          putchar( asc(".") )
        end if
      next
      putchar(asc(!"\n"))
    end if
  next
end sub