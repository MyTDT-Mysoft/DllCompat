#define fbc -dll -Wl "TlsDeps.dll.def" 

'#define NoDependencies

#ifndef NoDependencies
  'extern TLS_OPENGL32 alias "TLS_OPENGL32" as any ptr
  'extern TLS_DXGI alias "TLS_DXGI" as any ptr
  'extern TLS_WINED3D alias "TLS_WINED3D" as any ptr
  'extern TLS_D3D9 alias "TLS_D3D9" as any ptr
  'extern TLS_D3D10 alias "TLS_D3D10" as any ptr
  'extern TLS_EGL alias "TLS_EGL" as any ptr 
  'extern TLS_EGL2 alias "TLS_EGL2" as any ptr 'libEGL.dll
  'extern TLS_COFEE alias "TLS_COFEE" as any ptr
  extern TLS_EXCEPTIONS alias "TLS_EXCEPTIONS" as any ptr
  
#endif

extern "windows-ms"
  sub StaticDependencyListTLS() export
    #ifndef NoDependencies
      'var N = TLS_OPENGL32
      'var N1 = TLS_DXGI
      'var N2 = TLS_WINED3D      
      'var N3 = TLS_D3D9
      'var N4 = TLS_D3D10
      'var N5 = TLS_EGL
      'var N6 = TLS_EGL2
      'var N7 = TLS_COFEE
      var N8 = TLS_EXCEPTIONS
    #endif
  end sub
end extern
