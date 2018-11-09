const c_advapi3x = "advapi3x"
const c_avrt     = "avrt"
const c_credux   = "credux"
const c_dwmapi   = "dwmapi"
const c_gdi3x    = "gdi3x"
const c_gdipluz  = "gdipluz"
const c_iphlpapx = "iphlpapx"
const c_kernel3x = "kernel3x"
const c_msvcrz   = "msvcrz"
const c_ntdlx    = "ntdlx"
const c_powrprox = "powrprox"
const c_shell3x  = "shell3x"
const c_user3x   = "user3x"
const c_uxthemx  = "uxthemx"
const c_ws2_3x   = "ws2_3x"
 
type dllMapping
  as zstring ptr targ
  as zstring ptr repl
end type
 
static shared as dllMapping mapCommon(...) = { _
  (@"advapi32", @c_advapi3x ), _
  (@"avrt",     @c_avrt     ), _
  (@"credu2",   @c_credux   ), _
  (@"dwmapi",   @c_dwmapi   ), _
  (@"gdi32",    @c_gdi3x    ), _
  (@"gdiplus",  @c_gdipluz  ), _
  (@"iphlpapi", @c_iphlpapx ), _
  (@"kernel32", @c_kernel3x ), _
  (@"msvcrt",   @c_msvcrz   ), _
  (@"ntdll",    @c_ntdlx    ), _
  /'(@"opengl32", @c_opengl3x ),'/ _
  (@"powrprof", @c_powrprox ), _
  (@"shell32",  @c_shell3x  ), _
  (@"user32",   @c_user3x   ), _
  (@"uxtheme",  @c_uxthemx  ), _
  (@"ws2_32",   @c_ws2_3x   )  _
}

'static shared as dllMapping mapMinWin(...) = { _
'  (@"api-ms-win-core-fibers-l1-1-0", c_kernel3x ) _
'}
'TODO: winmin table

enum
  GETMOD, LOADLIB
end enum