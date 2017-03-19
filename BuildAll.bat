@echo off
setlocal

set fbc=f:\fb15\fbc.exe
set opt=-dll

call :Compile advapi3x
call :Compile kernel3x
call :Compile msvcrx
call :Compile opengl3x
call :Compile powrprox
call :Compile shell3x
call :Compile vcruntime140
call :Compile ws2_3x

echo Done.
pause >nul
endlocal
goto :eof


:Compile
echo compiling %1
cd %1 
%fbc% %opt% %1.bas -Wl "%1.dll.def"
set err=%errorlevel%
cd ..
if %err% gtr 0 goto :Failed
goto :eof

:Failed
echo Compilation Failed...
pause >nul
exit
