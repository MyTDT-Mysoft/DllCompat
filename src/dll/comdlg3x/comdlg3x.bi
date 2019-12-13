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
  declare function FileDialog_Show                       (_self as IFileDialog ptr, hwndOwner as HWND) as HRESULT
  declare function FileDialog_SetFileTypes               (_self as IFileDialog ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
  declare function FileDialog_SetFileTypeIndex           (_self as IFileDialog ptr, iFileType as UINT) as HRESULT
  declare function FileDialog_GetFileTypeIndex           (_self as IFileDialog ptr, piFileType as UINT ptr) as HRESULT
  declare function FileDialog_Advise                     (_self as IFileDialog ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
  declare function FileDialog_Unadvise                   (_self as IFileDialog ptr, dwCookie as DWORD) as HRESULT
  declare function FileDialog_SetOptions                 (_self as IFileDialog ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
  declare function FileDialog_GetOptions                 (_self as IFileDialog ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
  declare function FileDialog_SetDefaultFolder           (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
  declare function FileDialog_SetFolder                  (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
  declare function FileDialog_GetFolder                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function FileDialog_GetCurrentSelection        (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function FileDialog_SetFileName                (_self as IFileDialog ptr, pszName as LPCWSTR) as HRESULT
  declare function FileDialog_GetFileName                (_self as IFileDialog ptr, pszName as LPWSTR ptr) as HRESULT
  declare function FileDialog_SetTitle                   (_self as IFileDialog ptr, pszTitle as LPCWSTR) as HRESULT
  declare function FileDialog_SetOkButtonLabel           (_self as IFileDialog ptr, pszText as LPCWSTR) as HRESULT
  declare function FileDialog_SetFileNameLabel           (_self as IFileDialog ptr, pszLabel as LPCWSTR) as HRESULT
  declare function FileDialog_GetResult                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function FileDialog_AddPlace                   (_self as IFileDialog ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
  declare function FileDialog_SetDefaultExtension        (_self as IFileDialog ptr, pszDefaultExtension as LPCWSTR) as HRESULT
  declare function FileDialog_Close                      (_self as IFileDialog ptr, hr as HRESULT) as HRESULT
  declare function FileDialog_SetClientGuid              (_self as IFileDialog ptr, guid as GUID ptr) as HRESULT
  declare function FileDialog_ClearClientData            (_self as IFileDialog ptr) as HRESULT
  declare function FileDialog_SetFilter                  (_self as IFileDialog ptr, pFilter as IShellItemFilter ptr) as HRESULT
  'FileOpenDialog
  declare function FileOpenDialog_GetResults             (_self as IFileOpenDialog ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
  declare function FileOpenDialog_GetSelectedItems       (_self as IFileOpenDialog ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
  'FileSaveDialog
  declare function FileSaveDialog_SetSaveAsItem          (_self as IFileSaveDialog ptr, psi as IShellItem ptr) as HRESULT
  declare function FileSaveDialog_SetProperties          (_self as IFileSaveDialog ptr, pStore as IPropertyStore ptr) as HRESULT
  declare function FileSaveDialog_SetCollectedProperties (_self as IFileSaveDialog ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
  declare function FileSaveDialog_GetProperties          (_self as IFileSaveDialog ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
  declare function FileSaveDialog_ApplyProperties        (_self as IFileSaveDialog ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
end extern

extern "C"
  declare function FileDialogDestructor(_self as any ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT
  declare function FileDialogConstructor(_self as any ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT
end extern

'-------------------------------------------------------------------------------------------

type PrivEventHandler
  pfde as IFileDialogEvents ptr
  'pDialog as FileDialogImpl ptr
  cookie as DWORD
end type

'FileDialog
#define MAX_FILEPATH 65536
#define MAX_FILENAME 256
#define MAX_HANDLERS 128
type FileDialogImpl
  union
    baseObj as COMGenerObj
    fd_lpvtbl  as const IFileDialogVtbl ptr
    fod_lpvtbl as const IFileOpenDialogVtbl ptr
    fsd_lpvtbl as const IFileSaveDialogVtbl ptr
  end union
  filePath as WSTRING*MAX_FILEPATH
  fileName as WSTRING*MAX_FILENAME
  ofnw as OPENFILENAMEW
  
  isSaveDialog as BOOL
  
  dialogHwnd as HWND
  nextCookie as DWORD
  usedArrSlots as int 'inclusive
  handlerArr(MAX_HANDLERS) as PrivEventHandler ptr
end type