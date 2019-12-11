#include "wincred.bi"
#include "shared\helper.bas"

enum
  CREDUIWIN_GENERIC                 = &H1
  CREDUIWIN_CHECKBOX                = &H2
  CREDUIWIN_AUTHPACKAGE_ONLY        = &H10
  CREDUIWIN_IN_CRED_ONLY            = &H20
  CREDUIWIN_ENUMERATE_ADMINS        = &H100
  CREDUIWIN_ENUMERATE_CURRENT_USER  = &H200
  CREDUIWIN_SECURE_PROMPT           = &H1000
  CREDUIWIN_PREPROMPTING            = &H2000
  CREDUIWIN_PACK_32_WOW             = &H10000000
end enum