#include "windows.bi"
#include "..\win\wincred.bi"

dim as CREDUI_INFO tCredUi

with tCredUi
  .cbSize         = sizeof(tCredUi)
  .hwndParent     = GetConsoleWindow()
  .pszMessageText = @"enter password to hack me"
  .pszCaptionText = @"enter me not"
  .hbmBanner      = null '320x60
end with

dim as zstring*(CREDUI_MAX_USERNAME_LENGTH+1) zUserName = "Greg"
dim as zstring*(CREDUI_MAX_PASSWORD_LENGTH+1) zPassword = "Abc123"
dim as BOOL pbSave

CredUIPromptForCredentialsA( @tCredUi , "eNTERmEnOT" , null , 0 , _
@zUserName, sizeof(zUserName) , @zPassword , sizeof(zPassword) , _
@pbSave , CREDUI_FLAGS_COMPLETE_USERNAME or CREDUI_FLAGS_DO_NOT_PERSIST)