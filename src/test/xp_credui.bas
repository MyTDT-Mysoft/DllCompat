#include "windows.bi"
#include "includes\win\wincred.bi"

dim as CREDUI_INFOW tCredUi

with tCredUi
  .cbSize         = sizeof(tCredUi)
  .hwndParent     = GetConsoleWindow()
  .pszMessageText = @wstr("enter password to hack me")
  .pszCaptionText = @wstr("enter me not")
  .hbmBanner      = null '320x60
end with

dim as wstring*(CREDUI_MAX_USERNAME_LENGTH+1) zUserName = "Greg"
dim as wstring*(CREDUI_MAX_PASSWORD_LENGTH+1) zPassword = "Abc123"
dim as BOOL pbSave

CredUIPromptForCredentialsW( @tCredUi , wstr("eNTERmEnOT") , null , 0 , _
@zUserName, sizeof(zUserName) , @zPassword , sizeof(zPassword) , _
@pbSave , CREDUI_FLAGS_COMPLETE_USERNAME or CREDUI_FLAGS_DO_NOT_PERSIST)