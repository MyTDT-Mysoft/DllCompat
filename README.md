# DllCompat

DLLCompat is a set of dll files implementing functionality found Vista+, to be used in windows XP.<br/>
The dlls are used by patching the target application.<br/>

### INSTALLING AND USING:
Simply execute install_dlls.bat and DLLs will be copied to your Windows folder from bin\dll and bin\guest_dll.<br/>
From there, you have to patch application. See this [detailed guide](docs/patching_tut.md) on how to patch.<br/>
Currently, there is no automated patching tool.<br/>

### COMPILING:
Download and install http://www.freebasic.net/ <br/>
Edit compile.ini to point to fbc.exe location. Surround path with "" if it contains spaces.<br/>
Ex: "dllc_fbcpath=C:\Program Files\FBC\fbc.exe"<br/>
Execute build_tests.bat.<br/>
This project is known to compile with FBC v1.00 and v1.05, maybe v0.24<br/>

### CONTACT:
We can be reached via IRC below, or Issues section here on github.<br/>
https://kiwiirc.com/client/irc.freenode.net/?#AppCompat <br/>