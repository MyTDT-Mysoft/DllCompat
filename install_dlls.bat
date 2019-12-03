@echo off

set settfile=compile.ini
for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H

echo Copying DLLs to %install_path%
copy bin\dll\*.dll %install_path% /Y
copy bin\guest_dll\*.dll %install_path% /Y

echo Installing COM servers
regsvr32 /i %install_path%\comdlg3x.dll

pause
