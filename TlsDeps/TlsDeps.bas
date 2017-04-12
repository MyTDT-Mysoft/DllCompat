#define fbc -dll -Wl "TlsDeps.dll.def" 

'#define NoDependencies

#ifndef NoDependencies
  extern TLS_OPENGL32 alias "TLS_OPENGL32" as any ptr
#endif

extern "windows-ms"
  sub StaticDependencyListTLS() export
    #ifndef NoDependencies
      var N = TLS_OPENGL32
    #endif
  end sub
end extern
