@echo off

set settfile=compile.ini
for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H

echo Copying DLLs to %install_path% and installing COM servers
xcopy bin\dll\*.dll %install_path% /Y
xcopy bin\guest_dll\*.dll /exclude:bin\guest_dll\special.txt %install_path% /Y

regsvr32 /s %install_path%\comdlg3x.dll
if not exist %WINDIR%\system32\propsys.dll (
  xcopy bin\guest_dll\propsys.dll %install_path% /Y
  regsvr32 /s %install_path%\propsys.dll
)
pause