#define fbc -dll -Wl "TlsDeps.dll.def" 

#define NoDependencies

#ifndef NoDependencies
  extern TLS_EXCEPTIONS alias "TLS_EXCEPTIONS" as any ptr  
#endif

extern "windows-ms"
  sub StaticDependencyListTLS() export
    #ifndef NoDependencies
      var N = TLS_EXCEPTIONS
    #endif
  end sub
end extern

#include "shared\defaultmain.bas"