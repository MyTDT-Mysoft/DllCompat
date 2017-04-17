@echo off
setlocal

set fbc=f:\fb15\fbc.exe

IF NOT EXIST bin\ mkdir bin\
del bin\* /Q

call :compile credux
call :compile advapi3x
call :compile gdi3x
call :compile kernel3x
call :compile msvcrx
call :compile opengl3x
call :compile powrprox
call :compile shell3x
call :compile vcruntime140
call :compile ws2_3x

:donecomp
echo Copying DLLs to windir
copy bin\*x.dll %windir% /Y
:cleanup
echo Cleaning compile residue
del bin\*.dll.a /Q
del bin\*.o /Q
del bin\*.s /Q
endlocal
goto :eof

:failed
echo Compilation Failed...
pause >nul
goto :cleanup

:compile
echo compiling %1
%fbc% -dll %1\%1.bas -Wl "%1\%1.dll.def" -x bin\%1.dll
set err=%errorlevel%
if %err% gtr 0 goto :Failed
goto :eof
