#include once "crt.bi"

#macro UnimplementedFunction()
  messagebox(null, __FUNCTION__ " called. but not implemented", "DllCompat", MB_SYSTEMMODAL or MB_ICONINFORMATION)
#endmacro
#macro TRACE( _STRING , _PARMS... )
  scope
    dim as zstring*4096 zDebug
    sprintf(zDebug, __FUNCTION__ ":%i - " & _STRING & !"\r\n" , __LINE__ , _PARMS )
    OutputDebugString( zDebug )
  end scope
#endmacro