@echo off
setlocal
set params=xp_credui xp_LoadLibrarydll
set params=%params% vista_comFileDlg vista_credui vista_getfinalpathnamebyhandle
set params=%params% both_SHGetKnownFolderPath both_SHParseDisplayName
::set params=both_SHParseDisplayName

set settfile=compile.ini
set libpath=bin\lib
set binpath=bin\test
set srcpath=src\test
set logpath=logs

for /f "delims== tokens=1,2" %%G in (%settfile%) do set %%G=%%H
set gcc=%dllc_gccpath%\gcc.exe
path=%path%;%dllc_fbcpath%;%dllc_gccpath%
IF NOT EXIST %binpath% mkdir %binpath%
IF NOT EXIST %logpath% mkdir %logpath%

call :compile_all %params%

call :cleanup
IF DEFINED compilehasfailed pause
endlocal
exit /B 0



::------------------------------
:compile_all
if "%1" EQU "" exit /B 0
echo Compiling %1

pushd .\%srcpath%
set complog=..\..\%logpath%\test_%1.log

IF EXIST res\%1.rc set res=-s gui res\%1.rc
IF NOT EXIST res\%1.rc set res=
fbc %1.bas -x ..\..\%binpath%\%1.exe %res% -i ..\..\src -d _WIN32_WINNT=^&h0601 -Wl "-L ..\..\%libpath%" -i ..\..\src > %complog%
set err=%errorlevel%
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
del %binpath%\*.exe.a /Q
del %binpath%\*.o /Q
del %binpath%\*.s /Q
exit /B 0