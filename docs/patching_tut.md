# Manually patching applications with DllCompat

We are going to need three tools in our inventory.

1. Dependency Walker: http://www.dependencywalker.com/ <br/>
2. a PE editor, PPEE is chosen here: https://mzrst.com/ <br/>
3. DebugView: https://docs.microsoft.com/en-us/sysinternals/downloads/debugview 

![](patut_img/ppee_majmin.png?raw=true) <br/>
First step is to start PPEE and load application EXE.<br/>
Look in NT Header -> Optional Header.<br/>
In right pane, MajorSubsystemVersion and MinorSubsystemVersion together must be v5.1 or less<br/>
Edit them accordingly if larger, so our application can be started. Save.<br/>
This step is only needed for EXE and never DLL.<br/>
<br/>

![](patut_img/depwalk_depmiss.png?raw=true) <br/>
Next step is to start Dependency Walker and load the EXE.<br/>
This tool will walk from exe to dll recursively and tell you where there is missing function.<br/>
These will appear in red. Be sure to order top-right list by PI collumn.<br/>
Return to PPEE window.<br/>
<br/>

![](patut_img/ppee_depfix.png?raw=true) <br/>
We will be patching the IAT(Import Address Table).
Loading exe and each dll with missing dependencies into PPEE, go into DIRECTORY_ENTRY_IMPORT.<br/>
Change dependency name from system dll to ours(ex: gdi32.dll -> gdi3x.dll). Case insensitive.<br/>
For a reference on what and how to rename, take a look in DllCompat's bin\dll and bin\dll_guest folders.<br/>
After renaming dependencies, reopen application in DepWalker to see if there are any remains.<br/>
Note: be careful that some applications may load dlls dynamically, which cannot be directly seen by DepWalker.<br/>
For example, Qt-based applications will load "platforms\qwindows.dll", which fails because of missing dependencies.<br/>
Such a problem can be discovered in next step.<br/>
<br/>

![](patut_img/debview_inspect.png?raw=true) <br/>
Another problem is dynamic loading.<br/>
You will patch import kernel32.dll -> kernel3x.dll for your main exe and dependant dlls, even if no missing dependancy.<br/>
This will do two things for you. It will redirect dynamic load to our dlls and it will show debug info.<br/>
Start DebugView.<br/>
If it's the first time, go into Edit -> Filter/Highlight... and load dllcompat_filter.INI<br/>
This will colorize events emitted by DllCompat in gray.<br/>
Two events will be of interest: those that say "Dynload FAIL" and those that start with DLLC_WHOCALL.<br/>
The former will be for failure to load DLL and absent functions.<br/>
The latter will show where above failures come from.<br/>
A dll will often fail to be loaded dynamically if it has missing IAT dependencies.<br/>
<br/>

### Questions:

Q: Some dlls in DepWalker have hourglass in their symbol.<br/>
A: This is delay-loading. It's similar to the IAT import, except the dll is only loaded when the function is called.<br/>
   An application will start and work fine until such missing function is called.<br/>
   It will fail with a MessageBox.<br/>

Q: I get funky longs names in DepWalker/DebugView, like api-ms-win-core-synch-l1-1-0.dll.<br/>
A: These are the so called MinWin dlls. They are often just redirects to system dll functions.<br/>
   TODO: information on how to replace accordingly.<br/>
   
Q: After patching IAT of exe/dlls, I still have missing imports in DepWalker.<br/>
A: Report issue on github.<br/>

Q: After patching exe/dlls, I still get Dynload FAIL in DebugView.<br/>
A: Ideally, dynamic loading is used for optional functions that enhance application in newer windows.<br/>
   In this case, failure to load is treated graciously inside application.<br/>
   Such application will either silently work around or clearly post error message.<br/>
   Sadly, a developer is free to write applications that dynamically load and never check for success.<br/>
   Expect malfunction in this case.<br/>
   Feel free to report pesky application on github.
   