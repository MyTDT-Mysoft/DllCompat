#define fbc -dll -Wl "ws2_3x.dll.def" -x ..\..\bin\dll\ws2_3x.dll -i ..\..\

#include "win/winsock2.bi"
#Include "win/ws2tcpip.bi"

extern "windows-ms"

function inet_ntop alias "inet_ntop" (af as integer, src as any ptr, dst as zstring ptr, size as socklen_t) as zstring ptr export
  dim as sockaddr_storage ss
  dim as ulong s = size
  
  ss.ss_family = af

  select case af
  case AF_INET
    cptr(sockaddr_in ptr,@ss)->sin_addr = *cptr(in_addr ptr,src)
  case AF_INET6:
    cptr(sockaddr_in6 ptr,@ss)->sin6_addr = *cptr(in6_addr ptr,src)
  case else          
    return NULL
  end select
  
  '/* cannot direclty use &size because of strict aliasing rules */
  return iif(WSAAddressToString(cast(any ptr,@ss), sizeof(ss), NULL, dst, @s) = 0 , dst , NULL )
end function

end extern

#if 0
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <winsock2.h>
#include <ws2tcpip.h>


int inet_pton(int af, const char *src, void *dst)
{
  struct sockaddr_storage ss;
  int size = sizeof(ss);
  char src_copy[INET6_ADDRSTRLEN+1];

  ZeroMemory(&ss, sizeof(ss));
  /* stupid non-const API */
  strncpy (src_copy, src, INET6_ADDRSTRLEN+1);
  src_copy[INET6_ADDRSTRLEN] = 0;

  if (WSAStringToAddress(src_copy, af, NULL, (struct sockaddr *)&ss, &size) == 0) {
    switch(af) {
      case AF_INET:
    *(struct in_addr *)dst = ((struct sockaddr_in *)&ss)->sin_addr;
    return 1;
      case AF_INET6:
    *(struct in6_addr *)dst = ((struct sockaddr_in6 *)&ss)->sin6_addr;
    return 1;
    }
  }
  return 0;
}

const char *inet_ntop(int af, const void *src, char *dst, socklen_t size)
{
  struct sockaddr_storage ss;
  unsigned long s = size;

  ZeroMemory(&ss, sizeof(ss));
  ss.ss_family = af;

  switch(af) {
    case AF_INET:
      ((struct sockaddr_in *)&ss)->sin_addr = *(struct in_addr *)src;
      break;
    case AF_INET6:
      ((struct sockaddr_in6 *)&ss)->sin6_addr = *(struct in6_addr *)src;
      break;
    default:
      return NULL;
  }
  /* cannot direclty use &size because of strict aliasing rules */
  return (WSAAddressToString((struct sockaddr *)&ss, sizeof(ss), NULL, dst, &s) == 0)?
          dst : NULL;
}
#endif