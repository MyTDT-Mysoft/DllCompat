#pragma once

#include "win\guiddef.bi"
#include "crt\stdio.bi"
#include "crt\ctype.bi"

'<ThFabba> [INT and int] They're the same
'<ThFabba> BOOL is int, BOOLEAN is unsigned char
'<ThFabba> Yeah [BOOLEAN] it's more common in NT APIs

#undef INT
#undef BOOL
#undef BOOLEAN
#undef WINBOOL
type INT     as integer
type BOOL    as integer
type BOOLEAN as ubyte

type WINBOOL as integer

#define _In_  
#define _In_opt_
#define _Out_
#define _Out_opt_
#define _Inout_
#define _Inout_opt_

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
#define DEBUG_MAXSTR 512
#define GlobalDebugEnabled
#define CallerTraceEnabled

sub DebugOutputCalledResult(__pCaller as any ptr, pzFunction as zstring ptr)
  dim zResult as zstring*DEBUG_MAXSTR = any
  dim hCallerModule as HMODULE = null
  var iSz = sprintf(zResult, "DLLC_WHOCALL: %s was called by ", pzFunction)

  const cFlags = GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS or GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT    
  if GetModuleHandleEx(cFlags, __pCaller, @hCallerModule) andalso hCallerModule then
    GetModuleFileName(hCallerModule, @zResult+iSz , DEBUG_MAXSTR-iSz)
  else
    sprintf(@zResult+iSz, "Unknown (0x%08X)", __pCaller)
  end if
  
  OutputDebugString(zResult)
end sub

#macro DEBUG_AlertNotImpl()
  #ifdef GlobalDebugEnabled
    OutputDebugString("DLLC_ALERT:   " __FUNCTION__ !" STUB called.\r\n" )
    MessageBox(null, __FUNCTION__ !" STUB called.\r\n", "DllCompat", MB_SYSTEMMODAL or MB_ICONINFORMATION)
  #endif
#endmacro

#macro DEBUG_MsgNotImpl()
  #ifdef GlobalDebugEnabled
    OutputDebugString("DLLC_MSG:     " __FUNCTION__ !" STUB called. \r\n" )
  #endif
#endmacro

#macro DEBUG_MsgTrace(_STRING , _PARAMS...)
  #ifdef GlobalDebugEnabled
    scope
      dim as zstring*DEBUG_MAXSTR zTemp = any
      sprintf(zTemp , "DLLC_MSG:     %s(%i)| " _STRING , __FUNCTION__  , __LINE__ , _PARAMS)  
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

#macro DEBUG_WhoCalledInit()
  #if defined(GlobalDebugEnabled) andalso defined(CallerTraceEnabled)
    dim __pCaller as any ptr = any
    asm
      mov eax, [ebp+4]
      mov [__pCaller], eax
    end asm
  #endif
#endmacro

#macro DEBUG_WhoCalledResult()  
  #if defined(GlobalDebugEnabled) andalso defined(CallerTraceEnabled)
    DebugOutputCalledResult(__pCaller, @__FUNCTION__)    
  #endif
#endmacro

' **************************************************************************

#define AsGuid(_N,_l,_w1,_w2,_bw,_ll) as const GUID _N = type( (&h##_l), (&h##_w1), (&h##_w2), { ((&h##_bw) shr 8) and &hFF, (&h##_bw) and &hFF,  (((&h##_ll) shr 40) and &hFF),  (((&h##_ll) shr 32) and &hFF),  (((&h##_ll) shr 24) and &hFF),  (((&h##_ll) shr 16) and &hFF),  (((&h##_ll) shr 8) and &hFF),(((&h##_ll) shr 0) and &hFF) } )

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