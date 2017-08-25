@echo off
setlocal

set fbc=f:\fb15\fbc.exe
set type=dll

IF NOT EXIST bin\%type% mkdir bin\%type%
del bin\%type%\* /Q

::goto :donecomp
call :compile advapi3x
call :compile credux
call :compile gdi3x
call :compile kernel3x
call :compile msvcrx
call :compile opengl3x
call :compile powrprox
call :compile shell3x
call :compile user3x
call :compile vcruntime140
call :compile ws2_3x

:donecomp
echo Copying DLLs to windir
copy bin\%type%\*x.dll %windir% /Y
:cleanup
echo Cleaning compile residue
del bin\%type%\*.dll.a /Q
del bin\%type%\*.o /Q
del bin\%type%\*.s /Q
endlocal
pause
goto :eof

:failed
echo Compilation Failed...
rem pause >nul
goto :cleanup

:compile
echo compiling %1
pushd .\src\%type%\%1
%fbc% -dll %1.bas -Wl "%1.dll.def" -x ..\..\..\bin\%type%\%1.dll -i ..\..\..\src
set err=%errorlevel%
popd
if %err% gtr 0 goto :Failed
goto :eof
