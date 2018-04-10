@echo off

set binpath=bin\dll

echo Copying DLLs to windir
copy bin\dll\*.dll %windir% /Y
copy bin\guest_dll\*.dll %windir% /Y

pause