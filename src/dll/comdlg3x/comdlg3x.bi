#pragma once

#include "windows.bi"
#include "win\winbase.bi"
#include "win\objbase.bi"
#include "win\shlobj.bi"
#include "win\commdlg.bi"

#include "includes\comhelper.h"

'placeholders
type IFileOperationProgressSink as any ptr
type FILEOPENDIALOGOPTIONS as any ptr
type FDAP as any ptr
type FDE_SHAREVIOLATION_RESPONSE as any ptr
type FDE_OVERWRITE_RESPONSE as any ptr



extern "windows-ms"

'-------------------------------------------------------------------------------------------
type IFileDialogEvents as IFileDialogEvents_
type FileDialogImpl as FileDialogImpl_

'FileDialogEvents
'client-side
  type IFileDialogEventsVtbl
    QueryInterface    as function(self as IFileDialogEvents ptr, riid as const IID const ptr, ppvObject as any ptr ptr) as HRESULT
    AddRef            as function(self as IFileDialogEvents ptr) as ULONG
    Release           as function(self as IFileDialogEvents ptr) as ULONG
    OnFileOk          as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr) as HRESULT
    OnFolderChanging  as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr, psiFolder as IShellItem ptr) as HRESULT
    OnFolderChange    as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr) as HRESULT
    OnSelectionChange as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr) as HRESULT
    OnShareViolation  as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr, psi as IShellItem ptr, pResponse as FDE_SHAREVIOLATION_RESPONSE ptr) as HRESULT
    OnTypeChange      as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr) as HRESULT
    OnOverwrite       as function(self as IFileDialogEvents ptr, pfd as FileDialogImpl ptr, psi as IShellItem ptr, pResponse as FDE_OVERWRITE_RESPONSE ptr) as HRESULT
  end type
  type IFileDialogEvents_
    lpVtbl as const IFileDialogEventsVtbl ptr
  end type


'FileSaveDialog, FileOpenDialog, FileDialog
'server-side
  type IFileDialogVtbl
    QueryInterface         as function (self as FileDialogImpl ptr, riid as REFIID, ppv as any ptr ptr) as HRESULT
    AddRef                 as function (self as FileDialogImpl ptr) as ULONG
    Release                as function (self as FileDialogImpl ptr) as ULONG
    
    Show                   as function (self as FileDialogImpl ptr, hwndOwner as HWND) as HRESULT
    SetFileTypes           as function (self as FileDialogImpl ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
    SetFileTypeIndex       as function (self as FileDialogImpl ptr, iFileType as UINT) as HRESULT
    GetFileTypeIndex       as function (self as FileDialogImpl ptr, piFileType as UINT ptr) as HRESULT
    Advise                 as function (self as FileDialogImpl ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
    Unadvise               as function (self as FileDialogImpl ptr, dwCookie as DWORD) as HRESULT
    SetOptions             as function (self as FileDialogImpl ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
    GetOptions             as function (self as FileDialogImpl ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    SetDefaultFolder       as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    SetFolder              as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    GetFolder              as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    GetCurrentSelection    as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    SetFileName            as function (self as FileDialogImpl ptr, pszName as LPCWSTR) as HRESULT
    GetFileName            as function (self as FileDialogImpl ptr, pszName as LPWSTR ptr) as HRESULT
    SetTitle               as function (self as FileDialogImpl ptr, pszTitle as LPCWSTR) as HRESULT
    SetOkButtonLabel       as function (self as FileDialogImpl ptr, pszText as LPCWSTR) as HRESULT
    SetFileNameLabel       as function (self as FileDialogImpl ptr, pszLabel as LPCWSTR) as HRESULT
    GetResult              as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    AddPlace               as function (self as FileDialogImpl ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
    SetDefaultExtension    as function (self as FileDialogImpl ptr, pszDefaultExtension as LPCWSTR) as HRESULT
    Close                  as function (self as FileDialogImpl ptr, hr as HRESULT) as HRESULT
    SetClientGuid          as function (self as FileDialogImpl ptr, guid as GUID ptr) as HRESULT
    ClearClientData        as function (self as FileDialogImpl ptr) as HRESULT
    SetFilter              as function (self as FileDialogImpl ptr, pFilter as IShellItemFilter ptr) as HRESULT
  end type

  type IFileOpenDialogVtbl
    QueryInterface         as function (self as FileDialogImpl ptr, riid as REFIID, ppv as any ptr ptr) as HRESULT
    AddRef                 as function (self as FileDialogImpl ptr) as ULONG
    Release                as function (self as FileDialogImpl ptr) as ULONG
    
    Show                   as function (self as FileDialogImpl ptr, hwndOwner as HWND) as HRESULT
    SetFileTypes           as function (self as FileDialogImpl ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
    SetFileTypeIndex       as function (self as FileDialogImpl ptr, iFileType as UINT) as HRESULT
    GetFileTypeIndex       as function (self as FileDialogImpl ptr, piFileType as UINT ptr) as HRESULT
    Advise                 as function (self as FileDialogImpl ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
    Unadvise               as function (self as FileDialogImpl ptr, dwCookie as DWORD) as HRESULT
    SetOptions             as function (self as FileDialogImpl ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
    GetOptions             as function (self as FileDialogImpl ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    SetDefaultFolder       as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    SetFolder              as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    GetFolder              as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    GetCurrentSelection    as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    SetFileName            as function (self as FileDialogImpl ptr, pszName as LPCWSTR) as HRESULT
    GetFileName            as function (self as FileDialogImpl ptr, pszName as LPWSTR ptr) as HRESULT
    SetTitle               as function (self as FileDialogImpl ptr, pszTitle as LPCWSTR) as HRESULT
    SetOkButtonLabel       as function (self as FileDialogImpl ptr, pszText as LPCWSTR) as HRESULT
    SetFileNameLabel       as function (self as FileDialogImpl ptr, pszLabel as LPCWSTR) as HRESULT
    GetResult              as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    AddPlace               as function (self as FileDialogImpl ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
    SetDefaultExtension    as function (self as FileDialogImpl ptr, pszDefaultExtension as LPCWSTR) as HRESULT
    Close                  as function (self as FileDialogImpl ptr, hr as HRESULT) as HRESULT
    SetClientGuid          as function (self as FileDialogImpl ptr, guid as GUID ptr) as HRESULT
    ClearClientData        as function (self as FileDialogImpl ptr) as HRESULT
    SetFilter              as function (self as FileDialogImpl ptr, pFilter as IShellItemFilter ptr) as HRESULT
    
    GetResults             as function (self as FileDialogImpl ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
    GetSelectedItems       as function (self as FileDialogImpl ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
  end type

  type IFileSaveDialogVtbl
    QueryInterface         as function (self as FileDialogImpl ptr, riid as REFIID, ppv as any ptr ptr) as HRESULT
    AddRef                 as function (self as FileDialogImpl ptr) as ULONG
    Release                as function (self as FileDialogImpl ptr) as ULONG
    
    Show                   as function (self as FileDialogImpl ptr, hwndOwner as HWND) as HRESULT
    SetFileTypes           as function (self as FileDialogImpl ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
    SetFileTypeIndex       as function (self as FileDialogImpl ptr, iFileType as UINT) as HRESULT
    GetFileTypeIndex       as function (self as FileDialogImpl ptr, piFileType as UINT ptr) as HRESULT
    Advise                 as function (self as FileDialogImpl ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
    Unadvise               as function (self as FileDialogImpl ptr, dwCookie as DWORD) as HRESULT
    SetOptions             as function (self as FileDialogImpl ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
    GetOptions             as function (self as FileDialogImpl ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    SetDefaultFolder       as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    SetFolder              as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    GetFolder              as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    GetCurrentSelection    as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    SetFileName            as function (self as FileDialogImpl ptr, pszName as LPCWSTR) as HRESULT
    GetFileName            as function (self as FileDialogImpl ptr, pszName as LPWSTR ptr) as HRESULT
    SetTitle               as function (self as FileDialogImpl ptr, pszTitle as LPCWSTR) as HRESULT
    SetOkButtonLabel       as function (self as FileDialogImpl ptr, pszText as LPCWSTR) as HRESULT
    SetFileNameLabel       as function (self as FileDialogImpl ptr, pszLabel as LPCWSTR) as HRESULT
    GetResult              as function (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    AddPlace               as function (self as FileDialogImpl ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
    SetDefaultExtension    as function (self as FileDialogImpl ptr, pszDefaultExtension as LPCWSTR) as HRESULT
    Close                  as function (self as FileDialogImpl ptr, hr as HRESULT) as HRESULT
    SetClientGuid          as function (self as FileDialogImpl ptr, guid as GUID ptr) as HRESULT
    ClearClientData        as function (self as FileDialogImpl ptr) as HRESULT
    SetFilter              as function (self as FileDialogImpl ptr, pFilter as IShellItemFilter ptr) as HRESULT
    
    SetSaveAsItem          as function (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    SetProperties          as function (self as FileDialogImpl ptr, pStore as IPropertyStore ptr) as HRESULT
    SetCollectedProperties as function (self as FileDialogImpl ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
    GetProperties          as function (self as FileDialogImpl ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
    ApplyProperties        as function (self as FileDialogImpl ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
  end type

  declare function FileDialog_Show                       (self as FileDialogImpl ptr, hwndOwner as HWND) as HRESULT
  declare function FileDialog_SetFileTypes               (self as FileDialogImpl ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
  declare function FileDialog_SetFileTypeIndex           (self as FileDialogImpl ptr, iFileType as UINT) as HRESULT
  declare function FileDialog_GetFileTypeIndex           (self as FileDialogImpl ptr, piFileType as UINT ptr) as HRESULT
  declare function FileDialog_Advise                     (self as FileDialogImpl ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
  declare function FileDialog_Unadvise                   (self as FileDialogImpl ptr, dwCookie as DWORD) as HRESULT
  declare function FileDialog_SetOptions                 (self as FileDialogImpl ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
  declare function FileDialog_GetOptions                 (self as FileDialogImpl ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
  declare function FileDialog_SetDefaultFolder           (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
  declare function FileDialog_SetFolder                  (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
  declare function FileDialog_GetFolder                  (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function FileDialog_GetCurrentSelection        (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function FileDialog_SetFileName                (self as FileDialogImpl ptr, pszName as LPCWSTR) as HRESULT
  declare function FileDialog_GetFileName                (self as FileDialogImpl ptr, pszName as LPWSTR ptr) as HRESULT
  declare function FileDialog_SetTitle                   (self as FileDialogImpl ptr, pszTitle as LPCWSTR) as HRESULT
  declare function FileDialog_SetOkButtonLabel           (self as FileDialogImpl ptr, pszText as LPCWSTR) as HRESULT
  declare function FileDialog_SetFileNameLabel           (self as FileDialogImpl ptr, pszLabel as LPCWSTR) as HRESULT
  declare function FileDialog_GetResult                  (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
  declare function FileDialog_AddPlace                   (self as FileDialogImpl ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
  declare function FileDialog_SetDefaultExtension        (self as FileDialogImpl ptr, pszDefaultExtension as LPCWSTR) as HRESULT
  declare function FileDialog_Close                      (self as FileDialogImpl ptr, hr as HRESULT) as HRESULT
  declare function FileDialog_SetClientGuid              (self as FileDialogImpl ptr, guid as GUID ptr) as HRESULT
  declare function FileDialog_ClearClientData            (self as FileDialogImpl ptr) as HRESULT
  declare function FileDialog_SetFilter                  (self as FileDialogImpl ptr, pFilter as IShellItemFilter ptr) as HRESULT
  
  declare function FileOpenDialog_GetResults             (self as FileDialogImpl ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
  declare function FileOpenDialog_GetSelectedItems       (self as FileDialogImpl ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
  
  declare function FileSaveDialog_SetSaveAsItem          (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
  declare function FileSaveDialog_SetProperties          (self as FileDialogImpl ptr, pStore as IPropertyStore ptr) as HRESULT
  declare function FileSaveDialog_SetCollectedProperties (self as FileDialogImpl ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
  declare function FileSaveDialog_GetProperties          (self as FileDialogImpl ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
  declare function FileSaveDialog_ApplyProperties        (self as FileDialogImpl ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
end extern

extern "C"
  declare function FileDialogDestructor(self as FileDialogImpl ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT
  declare function FileDialogConstructor(self as FileDialogImpl ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT
end extern

'-------------------------------------------------------------------------------------------

type PrivEventHandler
  pfde as IFileDialogEvents ptr
  'pDialog as FileDialogImpl ptr
  cookie as DWORD
end type

'FileDialog
#define COOK_INVAL &hFFFFFFFF
#define MAX_FILEPATH 2048
#define MAX_HANDLERS 128
type FileDialogImpl_
  union
    baseObj as COMGenerObj
    fd_lpvtbl  as const IFileDialogVtbl ptr
    fod_lpvtbl as const IFileOpenDialogVtbl ptr
    fsd_lpvtbl as const IFileSaveDialogVtbl ptr
  end union
  filePath as WSTRING*MAX_FILEPATH
  ofnw as OPENFILENAMEW
  
  isDialogOpen as BOOL
  isSaveDialog as BOOL
  
  nextCookie as DWORD
  usedArrSlots as int
  handlerArr(MAX_HANDLERS) as PrivEventHandler ptr
end type