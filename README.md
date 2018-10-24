# DllCompat

DLLCompat is a set of dll files implementing functionality found Vista+, to be used in windows XP.
The dlls are used by patching the target application.


INSTALLING AND USING:
Simply execute install_dlls.bat and DLLs will be copied to your Windows folder from bin\dll and bin\guest_dll.
From there, you have to patch application. See this [detailed guide](docs/patching_tut.md) on how to patch.


COMPILING:
Download and install http://www.freebasic.net/
Edit compile.ini to point to fbc.exe location. Surround path with "" if it contains spaces.
Ex: "dllc_fbcpath=C:\Program Files\FBC\fbc.exe"
Execute build_tests.bat

This project is known to compile with FBC v1.00 and v1.05, maybe v0.24


CONTACT:
We can be reached via IRC below, or Issues section here on github.
https://kiwiirc.com/client/irc.freenode.net/?#AppCompat













DLL replacement for Windows Vista and later compatibility on Windows XP

Each DLL implements new APIs from later versions of Windows and passes ahead existing ones to the original files from Windows XP. 
Currently there isnt a tool to automate the process of changing which DLL a program will load so that it will use the enhanced DLL, but PETools can be used for that purpose, for example changing the reference from KERNEL32.DLL to KERNEL3x.DLL.

Compiled DLL's can be put in the system32 folder to be shared but I am only adding new functions or behaviors based on what I have the ability to reimplement. Probabily will need some test units to probe implementations...

Currently the DLLs return the version of the OS to be Windows Vista. In the future some configuration on this will be needed since some apps may work worse if they know it's Windows Vista while others may refuse to work if Vista+ isnt detected...

REQUIREMENTS TO COMPILE:

Freebasic ( http://www.freebasic.net/ ) (maybe 0.24, mostly compiled using v1.00, but confirmed working with v1.05)

HOW TO COMPILE:

Each module (DLL) can be compiled separately. The very first line of each .bas file for the specified module contains a "#define fbc ..." with the required command to compile with Freebasic. As a general rule the command is 'fbc -Wl "ModuleNamex.dll.def" -dll'. 

For convenience a .bat is included to compile all modules but obviously that .bat only work if you have the Freebasic folder set as a global environment variable (or inside the Freebasic command line shortcut that is create when freebasic is installed).

Project contact/chat:
https://kiwiirc.com/client/irc.freenode.net/?#AppCompat