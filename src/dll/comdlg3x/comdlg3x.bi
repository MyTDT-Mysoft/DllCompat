#pragma once

#include "windows.bi"
#include "win\winbase.bi"
#include "win\objbase.bi"
#include "win\shlobj.bi"
#include "win\commdlg.bi"

#include "includes\lib\comhelper.h"

extern "windows-ms"

'-------------------------------------------------------------------------------------------
  'FileDialog
  declare function fnIFileDialog_Show                       (_self as IFileDialog ptr, hwndOwner as HWND) as HRESULT
  declare function fnIFileDialog_SetFileTypes               (_self as IFileDialog ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
  declare function fnIFileDialog_SetFileTypeIndex           (_self as IFileDialog ptr, iFileType as UINT) as HRESULT
  declare function fnIFileDialog_GetFileTypeIndex           (_self as IFileDialog ptr, piFileType as UINT ptr) as HRESULT
  declare function fnIFileDialog_Advise                     (_self as IFileDialog ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
  declare function fnIFileDialog_Unadvise                   (_self as IFileDialog ptr, dwCookie as DWORD) as HRESULT
  declare function fnIFileDialog_SetOptions                 (_self as IFileDialog ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
  declare function fnIFileDialog_GetOptions                 (_self as IFileDialog ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
  declare function fnIFileDialog_SetDefaultFolder           (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
  declare function fnIFileDialog_SetFolder                  (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
  declare function fnIFileDialog_GetFolder                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function fnIFileDialog_GetCurrentSelection        (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function fnIFileDialog_SetFileName                (_self as IFileDialog ptr, pszName as LPCWSTR) as HRESULT
  declare function fnIFileDialog_GetFileName                (_self as IFileDialog ptr, pszName as LPWSTR ptr) as HRESULT
  declare function fnIFileDialog_SetTitle                   (_self as IFileDialog ptr, pszTitle as LPCWSTR) as HRESULT
  declare function fnIFileDialog_SetOkButtonLabel           (_self as IFileDialog ptr, pszText as LPCWSTR) as HRESULT
  declare function fnIFileDialog_SetFileNameLabel           (_self as IFileDialog ptr, pszLabel as LPCWSTR) as HRESULT
  declare function fnIFileDialog_GetResult                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function fnIFileDialog_AddPlace                   (_self as IFileDialog ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
  declare function fnIFileDialog_SetDefaultExtension        (_self as IFileDialog ptr, pszDefaultExtension as LPCWSTR) as HRESULT
  declare function fnIFileDialog_Close                      (_self as IFileDialog ptr, hr as HRESULT) as HRESULT
  declare function fnIFileDialog_SetClientGuid              (_self as IFileDialog ptr, guid as GUID ptr) as HRESULT
  declare function fnIFileDialog_ClearClientData            (_self as IFileDialog ptr) as HRESULT
  declare function fnIFileDialog_SetFilter                  (_self as IFileDialog ptr, pFilter as IShellItemFilter ptr) as HRESULT
  'FileOpenDialog
  declare function fnIFileOpenDialog_GetResults             (_self as IFileOpenDialog ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
  declare function fnIFileOpenDialog_GetSelectedItems       (_self as IFileOpenDialog ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
  'FileSaveDialog
  declare function fnIFileSaveDialog_SetSaveAsItem          (_self as IFileSaveDialog ptr, psi as IShellItem ptr) as HRESULT
  declare function fnIFileSaveDialog_SetProperties          (_self as IFileSaveDialog ptr, pStore as IPropertyStore ptr) as HRESULT
  declare function fnIFileSaveDialog_SetCollectedProperties (_self as IFileSaveDialog ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
  declare function fnIFileSaveDialog_GetProperties          (_self as IFileSaveDialog ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
  declare function fnIFileSaveDialog_ApplyProperties        (_self as IFileSaveDialog ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
  
  'FileSystemBindDaIta
  declare function fnIFileSystemBindData_SetFindData(_self as IFileSystemBindData ptr, pfd as const WIN32_FIND_DATAW ptr) as HRESULT
  declare function fnIFileSystemBindData_GetFindData(_self as IFileSystemBindData ptr, pfd as WIN32_FIND_DATAW ptr) as HRESULT
end extern

extern "C"
  declare function FileDialogDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
  declare function FileDialogConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
end extern

'-------------------------------------------------------------------------------------------

type PrivEventHandler
  pfde as IFileDialogEvents ptr
  'pDialog as IFileDialogImpl ptr
  cookie as DWORD
end type

'FileDialog
#define FFLAGS_DEFAULT OFN_EXPLORER or OFN_ENABLEHOOK or OFN_HIDEREADONLY
#define MAX_FILEPATH 65536
#define MAX_FILENAME 256
#define MAX_FILEEXT  16
#define MAX_HANDLERS 128
type IFileDialogImpl
  union
    baseObj as COMGenerObj
    fd_lpVtbl  as const IFileDialogVtbl ptr
    fod_lpVtbl as const IFileOpenDialogVtbl ptr
    fsd_lpVtbl as const IFileSaveDialogVtbl ptr
  end union
  ofnw as OPENFILENAMEW
  fos as FILEOPENDIALOGOPTIONS
  defaultFolder as IShellItem ptr
  overrideFolder as IShellItem ptr
  currentFolder as IShellItem ptr
  
  filePath as WSTRING*MAX_FILEPATH
  fileName as WSTRING*MAX_FILENAME
  defltExt as WSTRING*MAX_FILEEXT
  isSaveDialog as BOOL
  isFolderDialog as BOOL
  
  dialogHwnd as HWND
  nextCookie as DWORD
  usedArrSlots as int 'inclusive
  handlerArr(MAX_HANDLERS) as PrivEventHandler ptr
end type

type IFileSystemBindDataImpl
  union
    baseObj as COMGenerObj
    lpVtbl  as const IFileSystemBindDataVtbl ptr
  end union
  w32fdw as WIN32_FIND_DATAW
end type