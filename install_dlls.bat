@echo off

echo Copying DLLs to windir
copy bin\dll\*.dll %windir%\appcompat /Y
copy bin\guest_dll\*.dll %windir%\appcompat /Y

for %%I in (%windir%\appcompat\*.dll) do bin\util\makelink.exe /H %windir%\system32\%%~nxI %windir%\appcompat\%%~nxI

pause
