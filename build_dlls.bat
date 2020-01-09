@echo off
setlocal
set params=advapi3x credux comdlg3x gdi3x iphlpapx kernel3x ntdlx ole3x opengl3x powrprox shell3x user3x uxthemx ws2_3x
set params=%params% avrt dwmapi MMDevApi

set settfile=compile.ini
set libpath=bin\lib
set binpath=bin\dll
set srcpath=src\dll
set logpath=logs

for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H
set gcc=%dllc_gccpath%\gcc.exe
path=%path%;%dllc_fbcpath%;%dllc_gccpath%
IF NOT EXIST %binpath% mkdir %binpath%
IF NOT EXIST %logpath% mkdir %logpath%

call :compile_all %params%
echo.
echo Generating TlsDeps.dll
set loc=.\%srcpath%\kernel3x\TlsDeps
fbc -dll %loc%\TlsDeps.bas -Wl "%loc%\TlsDeps.dll.def --entry _DLLMAIN" -x .\%binpath%\TlsDeps.dll -i .\src -m blabla
::copy %srcpath%\kernel3x\TlsDeps\TlsDeps_Empty.dll %binpath%\TlsDeps.dll /Y

call :cleanup
IF DEFINED compilehasfailed pause
endlocal
exit /B 0



::------------------------------
:compile_all
if "%1" EQU "" exit /B 0
echo Compiling %1

pushd .\%srcpath%\%1
set complog=..\..\..\%logpath%\dll_%1.log
::ugly hack to get linker to cooperate
set dlltool=dummy
echo ' > dummy.bas
fbc dummy.bas
if exist extraparams.txt (set /p exprm=<extraparams.txt) else (set exprm=)
::set gengcc=-gen gcc -O 3 -asm intel
fbc -dll %1.bas %gengcc% -d _WIN32_WINNT=^&h0501 -Wl "%1.dll.def --entry _DLLMAIN -L ..\..\..\%binpath% -L ..\..\..\%libpath%" %exprm% -x ..\..\..\%binpath%\%1.dll -i ..\..\..\src -m blabla > %complog%
set err=%errorlevel%
del dummy.bas
del dummy.exe
set dlltool=
for %%R in (%complog%) do if %%~zR lss 1 del %complog%
popd

if not %err% gtr 0 goto :l_nocomperr
set compilehasfailed=yes
echo Failed compiling %1
:l_nocomperr
shift /1
goto compile_all

::------------------------------
:cleanup
echo Cleaning compile residue
del %binpath%\*.dll.a /Q
del %binpath%\*.o /Q
del %binpath%\*.s /Q
exit /B 0