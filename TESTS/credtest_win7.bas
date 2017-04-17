#include "windows.bi"
#include "win\combaseapi.bi"
#include "win\winerror.bi"

#include "..\MyTDT\detour.bas"
#include "..\win\wincred.bi"
#include "..\win\credui.bi"

#inclib "ole32"

dim as CREDUI_INFOW credui
with credui
  .cbSize         = sizeof(credui)
  .hwndParent     = GetConsoleWindow()
  .pszMessageText = @wstr("enter password to hack me")
  .pszCaptionText = @wstr("enter me not")
  .hbmBanner      = NULL '320x60
end With
dim as uint authPackage = 0
dim as any ptr outCredBuffer
dim as uint outCredSize
dim as bool save = false
dim as wstring*(CREDUI_MAX_USERNAME_LENGTH+1) usernameBuf
dim as wstring*(CREDUI_MAX_PASSWORD_LENGTH+1) passwordBuf
dim as wstring*(CREDUI_MAX_DOMAIN_TARGET_LENGTH+1) domainBuf
var maxUserName = CREDUI_MAX_USERNAME_LENGTH
var maxPassword = CREDUI_MAX_PASSWORD_LENGTH
var maxDomain = CREDUI_MAX_DOMAIN_TARGET_LENGTH

dim as DWORD promptresult
dim as BOOL unpackresult
var promptflags = CREDUIWIN_GENERIC
promptresult = CredUIPromptForWindowsCredentialsW(@credui, 0, @authPackage, NULL, 0, @outCredBuffer, @outCredSize, @save, promptflags)

'Here are some complaints before I start:
'CredUnPackAuthenticationBuffer changes GetLastError while returning a bool
'CredUIPromptForWindowsCredentials does not and returns error value directly
'ANSI version of CredUIPromptForWindowsCredentials does not seem to work and always returns error code 31.
if promptresult = ERROR_SUCCESS then
  fwrite(outCredBuffer, outCredSize, 1, stdout)
  print ""
  unpackresult = CredUnPackAuthenticationBufferW(0, outCredBuffer, outCredSize, @usernameBuf, @maxUserName, @domainBuf, @maxDomain, @passwordBuf, @maxPassword)
  if unpackresult Then
    print "Username:" + usernameBuf
    print "Password:" + passwordBuf
    print "Domain:"   + domainBuf
    SecureZeroMemory(outCredBuffer, outCredSize)
    SecureZeroMemory(@passwordBuf, maxPassword)
    CoTaskMemFree(outCredBuffer)
  else
    print "CredUnPackAuthenticationBuffer error: " & GetLastError()
  endif
elseif promptresult = ERROR_CANCELLED then
  print "user canceled..."
else
  print "CredUIPromptForWindowsCredentials error: " & promptresult
endif