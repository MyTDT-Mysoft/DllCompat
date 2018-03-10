#define fbc -dll -Wl "opengl3x.dll.def" -x ..\..\bin\dll\opengl3x.dll -i ..\..\

#include "windows.bi"
#include "gl\gl.bi"
#include "shared\helper.bas"

#define DebugAddress

extern "windows-ms"

  function fnglGetString alias "glGetString"(iName as GLenum) as zstring ptr export
    if iname = GL_VERSION then return @"2.0.0"
    return cast(zstring ptr,glGetString(iName))
  end function
  
  function fnwglGetProcAddress alias "wglGetProcAddress"(lpszProc as zstring ptr) as any ptr export
    
    dim as string zAlt = ""
    if lpszProc = 0 then return 0
    var hResu = wglGetProcAddress(lpszProc)
    if hResu = 0 then      
      select case lcase$(*lpszProc)
      case "glgenbuffers": zAlt = "glGenBuffersARB"
      case "glisbuffer": zAlt = "glIsBufferARB"
      case else: zAlt = *lpszProc+"ARB"
      end select    
      if len(zAlt) then
        hResu = wglGetProcAddress(zAlt)
      end if
    end if
    
    #ifdef DebugAddress
    var f = freefile()
    open "Debug.txt" for append as #f
    print #f,"(" & *lpszProc & ")[" & zAlt & "] = 0x"+hex$(hResu,8)
    close #f
    #endif
    
    return hResu

  end function

end extern

#ifdef DebugAddress
  var f = freefile()
  open "Debug.txt" for output as #f
  close #f
#endif