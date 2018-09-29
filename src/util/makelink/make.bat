@echo off
set gcc=C:\p_files\prog\ZinjaI\mingw32-gcc5\bin

set exename=makelink.exe
set opts=-std=c99 -mconsole -Wall -Wextra
set link=-lshlwapi
::-ggdb3

set PATH=%gcc%;%PATH%
del %exename%
gcc -o %exename% main.c %opts% %link% 2> err.log

pause