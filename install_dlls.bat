@echo off

set binpath=bin\dll

echo Copying DLLs to windir
copy %binpath%\*x.dll %windir% /Y

pause