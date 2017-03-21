# DllCompat
dll replacement for vista+ compatibility on windows XP

each dll implements functions, and passes ahead already implemented functions...
currently there isnt a tool to automatize the process of changing a process, so that it will use the enhanced dll...
but PETools can be used for that purpose, for example changing KERNEL32.DLL to KERNEL3x.DLL.

Compiled DLL's can be put on system32 to be shared, but i'm only adding new functions or behaviors, based on what is on my 
power to reimplement, probabily need some test units to probe implementations...

currently it's returning the version of the OS to be vista+, but i guess some configuration on this will be needed... since some apps may work worse, if they know it's vista... while others may detect and refuse to work if vista+ isnt detected...

REQUIREMENTS TO COMPILE:

Freebasic ( http://www.freebasic.net/ )
(maybe 0.24, mostly compiled using v1.00, but confirmed working with v1.05)

HOW TO COMPILE:

each module (DLL) can be compiled separately.
the very first line of each .bas for the specified module contains a #define fbc ...
with the required command to compile with freebasic
but as general rule the command is 'fbc -Wl "ModuleNamex.dll.def" -dll'
for convenience a .bat is included to compile all modules

but obviously that .bat only work if you have freebasic folder as global environment variable
(or inside freebasic command line shortcut, that is create when freebasic is installed)
