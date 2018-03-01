@echo off

set binpath=bin\dll

echo Copying DLLs to windir
copy %binpath%\*.dll %windir% /Y

pause