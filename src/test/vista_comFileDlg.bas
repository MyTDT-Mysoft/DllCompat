#define _WIN32_WINNT &h0602
#include "windows.bi"
#include "win\shobjidl.bi"

dim as HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE)
if SUCCEEDED(hr) then
  dim as IFileOpenDialog ptr pFileOpen

  'Create the FileOpenDialog object.
  hr = CoCreateInstance(@CLSID_FileOpenDialog, NULL, CLSCTX_ALL, @IID_IFileOpenDialog, cast(any ptr ptr, @pFileOpen))

  if SUCCEEDED(hr) then
    'Show the Open dialog box.
    hr = IFileOpenDialog_Show(pFileOpen, NULL)

    'Get the file name from the dialog box.
    if SUCCEEDED(hr) then
      dim as IShellItem ptr pItem
      hr = IFileOpenDialog_GetResult(pFileOpen, @pItem)
      if SUCCEEDED(hr) then
        dim as wstring ptr pszFilePath
        hr = IShellItem_GetDisplayName(pItem, SIGDN_FILESYSPATH, @pszFilePath)

        'Display the file name to the user.
        if SUCCEEDED(hr) then
          print "SUCCESS!"
          print "Path: " + *pszFilePath
          CoTaskMemFree(pszFilePath)
        else print "IShellItem_GetDisplayName failed."
        endif
        IShellItem_Release(pItem)
      else print "IFileOpenDialog_GetResult failed."
      endif
    else print "IFileOpenDialog_Show failed or canceled."
    endif
    IFileOpenDialog_Release(pFileOpen)
  else print "CoCreateInstance failed."
  endif
  CoUninitialize()
endif

print "Press any key to continue..."
getkey()