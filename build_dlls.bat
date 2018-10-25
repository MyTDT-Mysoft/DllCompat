@echo off
setlocal

set params=advapi3x avrt credux comdlg3x dwmapi gdi3x iphlpapx kernel3x ntdlx opengl3x powrprox shell3x user3x uxthemx ws2_3x
::set params=comdlg3x

set settfile=compile.ini
set binpath=bin\dll
set srcpath=src\dll

for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H
IF NOT EXIST %binpath% mkdir %binpath%
::del %binpath%\* /Q
call :comploop %params%
goto :eof

:comploop
call :compile %1
shift /1
if not "%~1" EQU "" goto :comploop

:donecomp
echo Generating TlsDeps.dll
set loc=.\%srcpath%\kernel3x\TlsDeps
%dllc_fbcpath% -dll %loc%\TlsDeps.bas -Wl "%loc%\TlsDeps.dll.def" -x .\%binpath%\TlsDeps.dll -i .\src
::copy %srcpath%\kernel3x\TlsDeps\TlsDeps_Empty.dll %binpath%\TlsDeps.dll /Y

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
%dllc_fbcpath% -dll %1.bas -Wl "%1.dll.def --entry _DLLMAIN" -x ..\..\..\%binpath%\%1.dll -i ..\..\..\src -m blabla
set err=%errorlevel%
popd
if %err% gtr 0 goto :Failed
goto :eof

:eof