@echo off
setlocal

::set old=msvcrx
set params=advapi3x avrt credux dwmapi gdi3x iphlpapx kernel3x opengl3x powrprox shell3x user3x uxthemx vcruntime140 ws2_3x
rem set params=kernel3x

set settfile=compile.ini
set binpath=bin\dll
set srcpath=src\dll

for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H
IF NOT EXIST %binpath% mkdir %binpath%
del %binpath%\* /Q
call :comploop %params%
goto :eof

:comploop
call :compile %1
shift /1
if not "%~1" EQU "" goto :comploop

:donecomp
echo Generating TlsDeps.dll
copy %srcpath%\kernel3x\TlsDeps\TlsDeps_Empty.dll %binpath%\TlsDeps.dll /Y

:cleanup
echo Cleaning compile residue
del %binpath%\*.dll.a /Q
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
pushd .\%srcpath%\%1
%dllc_fbcpath% -dll %1.bas -Wl "%1.dll.def" -x ..\..\..\%binpath%\%1.dll -i ..\..\..\src
set err=%errorlevel%
popd
if %err% gtr 0 goto :Failed
goto :eof

:eof