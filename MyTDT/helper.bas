#include "crt\stdio.bi"
#include "crt\ctype.bi"

#macro UnimplementedFunction()
  messagebox(null, __FUNCTION__ " called. but not implemented", "DllCompat", MB_SYSTEMMODAL or MB_ICONINFORMATION)
#endmacro

sub hexdump(mem as any ptr, lenny as UInteger, elemsize as UInteger)
  'Courtesy of Grapus
  'http://grapsus.net/blog/post/Hexadecimal-dump-in-C
  #define HEXDUMP_COLS 17
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