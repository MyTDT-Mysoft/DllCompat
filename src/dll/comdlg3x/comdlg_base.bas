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
  
  'FileSystemBindData
  declare function fnIFileSystemBindData_SetFindData(_self as IFileSystemBindData ptr, pfd as const WIN32_FIND_DATAW ptr) as HRESULT
  declare function fnIFileSystemBindData_GetFindData(_self as IFileSystemBindData ptr, pfd as WIN32_FIND_DATAW ptr) as HRESULT
end extern

extern "C"
  declare function FileDialogDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
  declare function FileDialogConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
end extern

'-------------------------------------------------------------------------------------------

'configuration
static shared vt_FileDialog as IFileDialogVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @fnIFileDialog_Show, _
  @fnIFileDialog_SetFileTypes, _
  @fnIFileDialog_SetFileTypeIndex, _
  @fnIFileDialog_GetFileTypeIndex, _
  @fnIFileDialog_Advise, _
  @fnIFileDialog_Unadvise, _
  @fnIFileDialog_SetOptions, _
  @fnIFileDialog_GetOptions, _
  @fnIFileDialog_SetDefaultFolder, _
  @fnIFileDialog_SetFolder, _
  @fnIFileDialog_GetFolder, _
  @fnIFileDialog_GetCurrentSelection, _
  @fnIFileDialog_SetFileName, _
  @fnIFileDialog_GetFileName, _
  @fnIFileDialog_SetTitle, _
  @fnIFileDialog_SetOkButtonLabel, _
  @fnIFileDialog_SetFileNameLabel, _
  @fnIFileDialog_GetResult, _
  @fnIFileDialog_AddPlace, _
  @fnIFileDialog_SetDefaultExtension, _
  @fnIFileDialog_Close, _
  @fnIFileDialog_SetClientGuid, _
  @fnIFileDialog_ClearClientData, _
  @fnIFileDialog_SetFilter _
)

static shared vt_FileOpenDialog as IFileOpenDialogVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @fnIFileDialog_Show, _
  @fnIFileDialog_SetFileTypes, _
  @fnIFileDialog_SetFileTypeIndex, _
  @fnIFileDialog_GetFileTypeIndex, _
  @fnIFileDialog_Advise, _
  @fnIFileDialog_Unadvise, _
  @fnIFileDialog_SetOptions, _
  @fnIFileDialog_GetOptions, _
  @fnIFileDialog_SetDefaultFolder, _
  @fnIFileDialog_SetFolder, _
  @fnIFileDialog_GetFolder, _
  @fnIFileDialog_GetCurrentSelection, _
  @fnIFileDialog_SetFileName, _
  @fnIFileDialog_GetFileName, _
  @fnIFileDialog_SetTitle, _
  @fnIFileDialog_SetOkButtonLabel, _
  @fnIFileDialog_SetFileNameLabel, _
  @fnIFileDialog_GetResult, _
  @fnIFileDialog_AddPlace, _
  @fnIFileDialog_SetDefaultExtension, _
  @fnIFileDialog_Close, _
  @fnIFileDialog_SetClientGuid, _
  @fnIFileDialog_ClearClientData, _
  @fnIFileDialog_SetFilter, _
  _
  @fnIFileOpenDialog_GetResults, _
  @fnIFileOpenDialog_GetSelectedItems _
)

static shared vt_FileSaveDialog as IFileSaveDialogVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @fnIFileDialog_Show, _
  @fnIFileDialog_SetFileTypes, _
  @fnIFileDialog_SetFileTypeIndex, _
  @fnIFileDialog_GetFileTypeIndex, _
  @fnIFileDialog_Advise, _
  @fnIFileDialog_Unadvise, _
  @fnIFileDialog_SetOptions, _
  @fnIFileDialog_GetOptions, _
  @fnIFileDialog_SetDefaultFolder, _
  @fnIFileDialog_SetFolder, _
  @fnIFileDialog_GetFolder, _
  @fnIFileDialog_GetCurrentSelection, _
  @fnIFileDialog_SetFileName, _
  @fnIFileDialog_GetFileName, _
  @fnIFileDialog_SetTitle, _
  @fnIFileDialog_SetOkButtonLabel, _
  @fnIFileDialog_SetFileNameLabel, _
  @fnIFileDialog_GetResult, _
  @fnIFileDialog_AddPlace, _
  @fnIFileDialog_SetDefaultExtension, _
  @fnIFileDialog_Close, _
  @fnIFileDialog_SetClientGuid, _
  @fnIFileDialog_ClearClientData, _
  @fnIFileDialog_SetFilter, _
  _
  @fnIFileSaveDialog_SetSaveAsItem, _
  @fnIFileSaveDialog_SetProperties, _
  @fnIFileSaveDialog_SetCollectedProperties, _
  @fnIFileSaveDialog_GetProperties, _
  @fnIFileSaveDialog_ApplyProperties _
)

static shared vt_fsbd as IFileSystemBindDataVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @fnIFileSystemBindData_SetFindData, _
  @fnIFileSystemBindData_GetFindData _
)

static shared iidOpenDialog(...) as REFIID = { @IID_IFileOpenDialog, @IID_IFileDialog, @IID_IUnknown }
static shared confOpenDialog as COMDesc = type( _
  @CLSID_FileOpenDialog, @iidOpenDialog(0), COUNTOF(iidOpenDialog), _
  @vt_FileOpenDialog, sizeof(IFileDialogImpl), _
  @FileDialogConstructor, @FileDialogDestructor, _
  @DLLC_COM_MARK, @THREADMODEL_APARTMENT, @"File Open Dialog(DLLCompat)" _
)

static shared iidSaveDialog(...) as REFIID = { @IID_IFileSaveDialog, @IID_IFileDialog, @IID_IUnknown }
static shared confSaveDialog as COMDesc = type( _
  @CLSID_FileSaveDialog, @iidSaveDialog(0), COUNTOF(iidSaveDialog), _
  @vt_FileSaveDialog, sizeof(IFileDialogImpl), _
  @FileDialogConstructor, @FileDialogDestructor, _
  @DLLC_COM_MARK, @THREADMODEL_APARTMENT, @"File Save Dialog(DLLCompat)" _
)

static shared iidFSBind(...) as REFIID = { @IID_IFileSystemBindData, @IID_IUnknown }
static shared confFSBind as COMDesc = type( _
  NULL, @iidFSBind(0), COUNTOF(iidFSBind), _
  @vt_fsbd, sizeof(IFileSystemBindDataImpl), _
  NULL, NULL, _
  NULL, NULL, NULL _
)

static shared serverConfig(...) as COMDesc ptr = {@confOpenDialog, @confSaveDialog}