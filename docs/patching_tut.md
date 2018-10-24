# Manually patching applications with DllCompat

We are going to need three tools in our inventory.

1. Dependency Walker: http://www.dependencywalker.com/
2. a PE editor, PPEE chosen here: https://mzrst.com/
3. DebugView: https://docs.microsoft.com/en-us/sysinternals/downloads/debugview

[ppee_majmin.png](patut_img/ppee_majmin.png)
First step is to start PPEE and load application EXE.
Look in NT Header -> Optional Header.
In right pane, MajorSubsystemVersion and MinorSubsystemVersion together must be lower than v5.1
Edit them accordingly if larger, so our application can be started. Save.
This step is only needed for EXE and never DLL.

[depwalk_depmiss.png](patut_img/depwalk_depmiss.png)
Next step is to start Dependency Walker and load the EXE.
This tool will walk from exe to dll recursively and tell you where there is missing function.
These will appear in red. Be sure to order top-right list by PI collumn.
Return to PPEE window.

[ppee_depfix.png](patut_img/ppee_depfix.png)
Loading exe and each dll with missing dependencies into PPEE, go into DIRECTORY_ENTRY_IMPORT.
Change dependency name from system dll to ours(ex: gdi32.dll -> gdi3x.dll). Case insensitive.
For a reference on what and how to rename, take a look in DllCompat's bin\dll and bin\dll_guest folders.
After renaming dependencies, reopen application in DepWalker to see if there are any remains.

Note: be careful that some applications may load dlls dynamically, which cannot be directly seen by DepWalker.
For example, Qt-based applications will load "platforms\qwindows.dll", which fails because of missing dependencies.
Such a problem can be discovered in next step.

[debview_inspect.png](patut_img/debview_inspect.png)
So far, you have solved IAT(Import Address Table) loading. Another problem is dynamic loading.
For this, patch application exe and as many dlls as you see fit(the more patched, the more info).
You will replace import kernel32.dll -> kernel3x.dll in these.
This will do two things for you. It will redirect dynamic load to our dlls and it will show debug info.

Start DebugView, go into Edit -> Filter/Highlight... and load dllcompat_filter.INI
This will colorize events emitted by DllCompat in gray.
Two events will be of interest: those that say "Dynload FAIL" and those that start with DLLC_WHOCALL.
The former will be for failure to load DLL and absent functions.
The latter will show where above failures come from.

A dll will often fail to be loaded dynamically if it has missing IAT dependencies.

Questions:

Q: Some dlls in DepWalker have hourglass in their symbol.
A: This is delay-loading. It's similar to the IAT import, except the dll is only loaded when the function is called.
   An application will start and work fine until such missing function is called.

Q: I get funky longs names in DepWalker/DebugView, like api-ms-win-core-synch-l1-1-0.dll.
A: That's the so called, MinWin. These are often redirect to system dll functions.
   TODO: information on how to replace accordingly.

Q: After patching exe/dlls, I still have missing imports in DepWalker.
A: Report issue on github.

Q: After patching exe/dlls, I still get Dynload FAIL in DebugView.
A: Ideally, dynamic loading is used for optional functions that enhance application in newer windows.
   In this case, failure to load is treated graciously inside application.
   Such application will either silently work around or clearly post error message.
   Sadly, a developer is free to write applications that dynamically load and never check for success.
   Expect malfunction in this case.
   Feel free to report pesky application on github.