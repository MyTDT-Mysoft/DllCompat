# TlsDeps

Thread Local Storage Dependencies...

Thread Local Storage exists in two forms.... dynamic/Manual using TLS functions and static, windows XP when using static, gets the amount required for all threads at load time, which means that libraries loaded trough LoadLibrary() or equivalents, and that have TLS sections, will not be initialized correctly if loaded late, this behavior is fixed/improved on vista

The workaround for it on windows is obvious, only use with statically linked libraries... when a library is loaded it's possible to verify that it requires TLS, so kernel3x can wrap LoadLibrary functions, and detect/warn about this compatibility problem (usually that will instantly followed by a crash, but can be hard to debug), so all libraries that the program will need to use that contain static TLS and will be loaded dynamically, must first be loaded statistically, and that's where TlsDeps enters into play...

TlsDeps generates a dll, that is application specific containing libraries that must be static loaded, it's loaded statically by Kernel3x, and so it has a "empty default", but application spefific case that will then load the missing libraries

The generated .dll.a for the "empty/skeleton" version was renamed just to .a, so that it can be included into kernel3x without triggering the git ignore for .dll.a, but it's just a import library for the TlsDeps.dll as Kernel3x,TlsDeps and all other modules can be just shared to all patched apps residing on a system folder

Currently, a .def file must be added containing those libraries, and to force the libraries to be linked you need a function... to simplify the process, the function (which one is irrelevant), is pointed by ORDINAL, by default ordinal #1 should work on most libraries, so just making a list for each app is enough

A .bat/.exe is yet to be provided so the .dll can be generated based on a simple .txt template, which then can have more detected modules added and TlsDeps recompiled... and so TlsDeps.dll must reside on the same folder as the .exe using it, if multiples .exe on the same folder require that each of them must be patched... but they all share the same TlsDeps.dll

An alternative to this process, would be to actually patch the import table of the .exe to add the required dll's (or a renamed version of the TlsDeps.dll), which is virtually more secure, since Kernel3x loading TlsDeps.dll is a common entrypoint to have overriding dll's

Later on the project, if the loader get patched to be used instead of patching applications, then maybe a list of dependencies can be used, and possibly automatically added by the program itself, with a warning that the behavior was detected and that the program must be restarted to apply the changes.

