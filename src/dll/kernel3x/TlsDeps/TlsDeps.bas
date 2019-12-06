#define fbc -dll -Wl "TlsDeps.dll.def" 

'#define NoDependencies

#ifndef NoDependencies
  extern TLS_OPENGL32 alias "TLS_OPENGL32" as any ptr
  extern TLS_DXGI alias "TLS_DXGI" as any ptr
  extern TLS_WINED3D alias "TLS_WINED3D" as any ptr
  extern TLS_D3D9 alias "TLS_D3D9" as any ptr
  extern TLS_D3D10 alias "TLS_D3D10" as any ptr
  extern TLS_EGL alias "TLS_EGL" as any ptr 
  extern TLS_EGL2 alias "TLS_EGL2" as any ptr 'libEGL.dll
  extern TLS_COFEE alias "TLS_COFEE" as any ptr
  extern TLS_EXCEPTIONS alias "TLS_EXCEPTIONS" as any ptr
#endif

extern "windows-ms"
  sub StaticDependencyListTLS() export
    #ifndef NoDependencies
      'var N00 = TLS_OPENGL32
      'var N01 = TLS_DXGI
      'var N02 = TLS_WINED3D      
      'var N03 = TLS_D3D9
      'var N04 = TLS_D3D10
      'var N05 = TLS_EGL
      'var N06 = TLS_EGL2
      'var N07 = TLS_COFEE
      'var N08 = TLS_EXCEPTIONS
    #endif
  end sub
end extern

#define CUSTOM_MAIN
#define NO_OTHER_MAIN
#include "shared\defaultmain.bas"

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as BOOL
    select case uReason
      case DLL_PROCESS_ATTACH
      case DLL_PROCESS_DETACH
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select
    return TRUE
  end function
end extern