#define fbc -dll -Wl "msvcrz.dll.def" -x ..\..\bin\dll\msvcrz.dll -i ..\..\

#include "windows.bi"

var hNtdll = LoadLibrary("ntdll.dll")
static shared ___sse2_available as integer = 1

if hNtdll=0 then
  messagebox(null,"Failed to retrieve functions","msvcrx",MB_ICONERROR)
  end
end if  

#if 0
#macro WrapC(_FuncName_)
  dim shared as any ptr Org##_FuncName_
  Org##_FuncName_ = GetProcAddress(hMsvcrt,#_FuncName_)
  extern "C"
    sub Wrp##_FuncName_ naked alias #_FuncName_ () export
      asm jmp [Org##_FuncName_]
    end sub
  end extern
#endmacro
#macro WrapCC(_FuncName_,_AliasName_)
  dim shared as any ptr Org##_FuncName_
  Org##_FuncName_ = GetProcAddress(hMsvcrt,_AliasName_)  
  extern "C"
  sub Wrp##_FuncName_ naked alias _AliasName_ () export
    asm jmp [Org##_FuncName_]
  end sub
  end extern  
#endmacro
#endif

extern "windows-ms"
  dim shared RtlTimeToSecondsSince1970 as function (as FILETIME ptr, as ULONG ptr) as integer
end extern
RtlTimeToSecondsSince1970 = cast(any ptr,GetProcAddress(hNtDll,"RtlTimeToSecondsSince1970"))
if RtlTimeToSecondsSince1970=0 then
  messagebox(null,"Failed to retrieve function 'RtlTimeToSecondsSince1970'","msvcrx",MB_ICONERROR)
  end
end if  

function _time cdecl alias "time" (plResult as ulong ptr) as ulong export
  dim as FILETIME tTime  
  GetSystemTimeAsFileTime(@tTime)
  return RtlTimeToSecondsSince1970(@tTime,plResult)
end function
function _ftol2 naked cdecl alias "_ftol2" (fNum as double) as long export
   const var_20 = &h-20 'dword ptr -20h
   const var_10 = &h-10 'qword ptr -10h
   const var_8 = &h-8   'dword ptr -8

  asm
                    push    ebp
                    mov     ebp, esp
                    sub     esp, 0x20
                    and     esp, 0x0FFFFFFF0
                    fld     st
                    fst     dword ptr [esp+0x20+var_8]
                    fistp   qword ptr [esp+0x20+var_10]
                    fild    qword ptr [esp+0x20+var_10]
                    mov     edx, [esp+0x20+var_8]
                    mov     eax, dword ptr [esp+0x20+var_10]
                    test    eax, eax
                    jz      loc_6FF59DCF
       loc_6FF59BC8:
                    fsubp   st(1), st
                    test    edx, edx
                    js      loc_6FF5F9DB
                    fstp    dword ptr  [esp+0x20+var_20]
                    mov     ecx, [esp+0x20+var_20]
                    add     ecx, 0x7FFFFFFF
                    sbb     eax, 0
                    mov     edx, dword ptr [esp+0x20+var_10+4]
                    sbb     edx, 0
    
    locret_6FF59BE8:
                    leave
                    ret
    
      loc_6FF59DCF:
                    mov     edx, dword ptr [esp+0x20+var_10+4]
                    test    edx, 0x7FFFFFFF
                    jnz     loc_6FF59BC8
                    fstp    dword ptr [esp+0x20+var_8]
                    fstp    dword ptr [esp+0x20+var_8]
                    jmp     locret_6FF59BE8
                    
      loc_6FF5F9DB:
                    fstp    dword ptr [esp+0x20+var_20]
                    mov     ecx, [esp+0x20+var_20]
                    xor     ecx, 0x80000000
                    add     ecx, 0x7FFFFFFF
                    adc     eax, 0
                    mov     edx, dword ptr [esp+0x20+var_10+4]
                    adc     edx, 0
                    jmp     locret_6FF59BE8
  end asm
end function
function _ftol2_sse naked cdecl alias "_ftol2_sse" (fNum as double) as long export
  const var_C = &h0C '  = qword ptr -0Ch
  asm    
    cmp     dword ptr [___sse2_available], 0
    jz      _ftol2
    push    ebp
    mov     ebp, esp
    sub     esp, 8
    and     esp, 0x0FFFFFFF8
    fstp    qword ptr [esp+0x0C+var_C]
    cvttsd2si eax, qword ptr [esp+0x0C+var_C]
    leave
    ret
  end asm
end function
