@echo off

echo Copying DLLs to windir
copy bin\dll\*.dll %windir% /Y
copy bin\guest_dll\*.dll %windir% /Y

::for %%I in (%windir%\appcompat\*.dll) do bin\util\makelink.exe /H %windir%\%%~nxI %windir%\appcompat\%%~nxI

pause
