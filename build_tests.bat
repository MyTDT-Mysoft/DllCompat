@echo off
setlocal

set params=vista_comFileDlg vista_credui xp_credui vista_getfinalpathnamebyhandle xp_LoadLibrarydll
::set params=vista_comFiledlg
set settfile=compile.ini
set binpath=bin\test
set srcpath=src\test

for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H
IF NOT EXIST %binpath% mkdir %binpath%
del %binpath%\* /Q
call :comploop %params%
goto :eof

:comploop
call :compile %1
shift /1
if not "%~1" EQU "" goto :comploop

:cleanup
echo Cleaning compile residue
del %binpath%\*.exe.a /Q
del %binpath%\*.o /Q
del %binpath%\*.s /Q
endlocal
pause
goto :eof

:failed
echo Compilation Failed...
rem pause >nul
goto :cleanup

:compile
echo compiling %1
pushd .\%srcpath%
IF NOT EXIST res\%1.rc goto :hasnores
%dllc_fbcpath% %1.bas -x ..\..\%binpath%\%1.exe -s gui res\%1.rc -i ..\..\src
goto :postcomp
:hasnores
%dllc_fbcpath% %1.bas -x ..\..\%binpath%\%1.exe -i ..\..\src
:postcomp
set err=%errorlevel%
popd
if %err% gtr 0 goto :Failed
goto :eof

:eof