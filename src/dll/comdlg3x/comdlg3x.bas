#include "windows.bi"
#include "win\winbase.bi"
#include "win\objbase.bi"
#include "win\shlobj.bi"
#include "win\commdlg.bi"

#include "shared\helper.bas"
#include "includes\comhelper.h"
'#include "includes\win\shellapi_fix.bi"
#include "comdlg3x.bi"

static shared AsGuid(IID_IFileOperationProgressSink, 04B0F1A7,9490,44BC,96E1,4296A31252E2)
static shared AsGuid(IID_IFileDialogEvents,          973510DB,7D7F,452B,8975,74A85828D354)
static shared AsGuid(IID_IFileDialog,                42F85136,DB7E,439C,85F1,E4075D135FC8)
static shared AsGuid(IID_IFileOpenDialog,            D57C7288,D4AD,4768,BE02,9D969532D960)
static shared AsGuid(IID_IFileSaveDialog,            84BCCD23,5FDE,4CDB,AEA4,AF64B83D78AB)
static shared AsGuid(CLSID_FileOpenDialog,           DC1C5A9C,E88A,4DDE,A5A1,60F82A20AEF7)
static shared AsGuid(CLSID_FileSaveDialog,           C0B4E2F3,BA21,4773,8DBA,335EC946EB8B)

static shared vt_FileDialog as IFileDialogVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @FileDialog_Show, _
  @FileDialog_SetFileTypes, _
  @FileDialog_SetFileTypeIndex, _
  @FileDialog_GetFileTypeIndex, _
  @FileDialog_Advise, _
  @FileDialog_Unadvise, _
  @FileDialog_SetOptions, _
  @FileDialog_GetOptions, _
  @FileDialog_SetDefaultFolder, _
  @FileDialog_SetFolder, _
  @FileDialog_GetFolder, _
  @FileDialog_GetCurrentSelection, _
  @FileDialog_SetFileName, _
  @FileDialog_GetFileName, _
  @FileDialog_SetTitle, _
  @FileDialog_SetOkButtonLabel, _
  @FileDialog_SetFileNameLabel, _
  @FileDialog_GetResult, _
  @FileDialog_AddPlace, _
  @FileDialog_SetDefaultExtension, _
  @FileDialog_Close, _
  @FileDialog_SetClientGuid, _
  @FileDialog_ClearClientData, _
  @FileDialog_SetFilter _
)

static shared vt_FileOpenDialog as IFileOpenDialogVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @FileDialog_Show, _
  @FileDialog_SetFileTypes, _
  @FileDialog_SetFileTypeIndex, _
  @FileDialog_GetFileTypeIndex, _
  @FileDialog_Advise, _
  @FileDialog_Unadvise, _
  @FileDialog_SetOptions, _
  @FileDialog_GetOptions, _
  @FileDialog_SetDefaultFolder, _
  @FileDialog_SetFolder, _
  @FileDialog_GetFolder, _
  @FileDialog_GetCurrentSelection, _
  @FileDialog_SetFileName, _
  @FileDialog_GetFileName, _
  @FileDialog_SetTitle, _
  @FileDialog_SetOkButtonLabel, _
  @FileDialog_SetFileNameLabel, _
  @FileDialog_GetResult, _
  @FileDialog_AddPlace, _
  @FileDialog_SetDefaultExtension, _
  @FileDialog_Close, _
  @FileDialog_SetClientGuid, _
  @FileDialog_ClearClientData, _
  @FileDialog_SetFilter, _
  _
  @FileOpenDialog_GetResults, _
  @FileOpenDialog_GetSelectedItems _
)

static shared vt_FileSaveDialog as IFileSaveDialogVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @FileDialog_Show, _
  @FileDialog_SetFileTypes, _
  @FileDialog_SetFileTypeIndex, _
  @FileDialog_GetFileTypeIndex, _
  @FileDialog_Advise, _
  @FileDialog_Unadvise, _
  @FileDialog_SetOptions, _
  @FileDialog_GetOptions, _
  @FileDialog_SetDefaultFolder, _
  @FileDialog_SetFolder, _
  @FileDialog_GetFolder, _
  @FileDialog_GetCurrentSelection, _
  @FileDialog_SetFileName, _
  @FileDialog_GetFileName, _
  @FileDialog_SetTitle, _
  @FileDialog_SetOkButtonLabel, _
  @FileDialog_SetFileNameLabel, _
  @FileDialog_GetResult, _
  @FileDialog_AddPlace, _
  @FileDialog_SetDefaultExtension, _
  @FileDialog_Close, _
  @FileDialog_SetClientGuid, _
  @FileDialog_ClearClientData, _
  @FileDialog_SetFilter, _
  _
  @FileSaveDialog_SetSaveAsItem, _
  @FileSaveDialog_SetProperties, _
  @FileSaveDialog_SetCollectedProperties, _
  @FileSaveDialog_GetProperties, _
  @FileSaveDialog_ApplyProperties _
)
'configuration
static shared iidOpenDialog(...) as REFIID = { @IID_IFileOpenDialog, @IID_IFileDialog, @IID_IUnknown }
static shared confOpenDialog as COMDesc = type( _
    @CLSID_FileOpenDialog, @iidOpenDialog(0), COUNTOF(iidOpenDialog), _
    @vt_FileOpenDialog, sizeof(FileDialogImpl), _
    @FileDialogConstructor, @FileDialogDestructor, _
    @DLLC_COM_MARK, @THREADMODEL_APARTMENT, @"File Open Dialog(DLLCompat)" _
)
static shared iidSaveDialog(...) as REFIID = { @IID_IFileSaveDialog, @IID_IFileDialog, @IID_IUnknown }

static shared confSaveDialog as COMDesc = type( _
    @CLSID_FileSaveDialog, @iidSaveDialog(0), COUNTOF(iidSaveDialog), _
    @vt_FileSaveDialog, sizeof(FileDialogImpl), _
    @FileDialogConstructor, @FileDialogDestructor, _
    @DLLC_COM_MARK, @THREADMODEL_APARTMENT, @"File Save Dialog(DLLCompat)" _
)
static shared serverConfig(...) as COMDesc ptr = {@confOpenDialog, @confSaveDialog}


'-------------------------------------------------------------------------------------------
#define IF_HFREE(x) if x <> NULL then HeapFree(GetProcessHeap(), 0, cast(LPVOID, x)) : x = NULL
function lazyHeapAlloc(pOut as LPVOID ptr, flags as DWORD, size as SIZE_T) as LPVOID
  dim hand as HANDLE = GetProcessHeap()
  dim mem as LPVOID
  
  if *pOut=NULL orelse HeapSize(hand, 0, *pOut) < size then
    mem = HeapAlloc(hand, flags, size)
    if mem <> NULL then
      HeapFree(hand, 0, *pOut)
      *pOut = mem
    end if
  else
    mem = *pOut
  end if
  
  return mem
end function

extern "windows-ms"

'-------------------------------------------------------------------------------------------
'FileDialog
  
  function FileDialog_Show                       (self as FileDialogImpl ptr, hwndOwner as HWND) as HRESULT
    dim ret as BOOL
    
    self->ofnw.hwndOwner = hwndOwner
    ret = iif(self->isSaveDialog, GetSaveFileNameW(@self->ofnw), GetOpenFileNameW(@self->ofnw))
    'TODO: check advanced error
    return iif(ret, S_OK, HRESULT_FROM_WIN32(ERROR_CANCELLED))
  end function
  
  function FileDialog_SetFileTypes               (self as FileDialogImpl ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
    dim size as DWORD = 1 'list is double-NULL terminated
    dim strArr as LPCWSTR ptr = cast(LPCWSTR ptr, rgFilterSpec)
    dim dat as BYTE ptr
    
    for i as integer = 0 to (cFileTypes*2)-1
      size += lstrlenW(strArr[i]) * 2 + 2
    next
    
    if lazyHeapAlloc(cast(LPVOID, @self->ofnw.lpstrFilter), 0, size)=NULL then return E_OUTOFMEMORY
    
    dat = cast(BYTE ptr, self->ofnw.lpstrFilter)
    
    for i as integer = 0 to (cFileTypes*2)-1
      size = lstrlenW(strArr[i]) * 2 + 2
      memcpy(dat, strArr[i], size)
      dat += size
    next
    
    dat[0] = 0
    dat[1] = 0
    
    return S_OK
  end function
  
  function FileDialog_SetFileTypeIndex           (self as FileDialogImpl ptr, iFileType as UINT) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_GetFileTypeIndex           (self as FileDialogImpl ptr, piFileType as UINT ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_Advise                     (self as FileDialogImpl ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
    'Before enabling, we must at least respond to open/save and cancel buttons
    if pfde=NULL orelse pdwCookie=NULL then return E_INVALIDARG
    
    for i as integer = 0 to MAX_HANDLERS-1
      dim hdlr as PrivEventHandler ptr = self->handlerArr(i)
      
      if hdlr=NULL then
        hdlr = HeapAlloc(GetProcessHeap(), 0, sizeof(PrivEventHandler))
        if hdlr<>NULL then exit for
        
        hdlr->pfde = pfde
        hdlr->cookie = self->nextCookie
        'hdlr->pDialog = self
        
        self->nextCookie += 1
        if self->usedArrSlots < i then self->usedArrSlots = i
        pfde->lpVtbl->AddRef(pfde)
        return S_OK
      end if
    next
    
    return E_OUTOFMEMORY
  end function
  
  function FileDialog_Unadvise                   (self as FileDialogImpl ptr, dwCookie as DWORD) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
    'Before enabling, we must at least respond to open/save and cancel buttons
    
    for i as integer = 0 to self->usedArrSlots
      dim hdlr as PrivEventHandler ptr = self->handlerArr(i)
      
      if hdlr<>NULL andalso hdlr->cookie=dwCookie then 
        hdlr->pfde->lpVtbl->Release(hdlr->pfde)
        HeapFree(GetProcessHeap(), 0, hdlr)
        return S_OK
      end if
    next
    
    return E_INVALIDARG
  end function
  
  function FileDialog_SetOptions                 (self as FileDialogImpl ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_GetOptions                 (self as FileDialogImpl ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetDefaultFolder           (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetFolder                  (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_GetFolder                  (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_GetCurrentSelection        (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetFileName                (self as FileDialogImpl ptr, pszName as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_GetFileName                (self as FileDialogImpl ptr, pszName as LPWSTR ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetTitle                   (self as FileDialogImpl ptr, pszTitle as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetOkButtonLabel           (self as FileDialogImpl ptr, pszText as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetFileNameLabel           (self as FileDialogImpl ptr, pszLabel as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_GetResult                  (self as FileDialogImpl ptr, ppsi as IShellItem ptr ptr) as HRESULT
    dim pidl as PIDLIST_ABSOLUTE
    dim hr as HRESULT = SHParseDisplayName(self->ofnw.lpstrFile, 0, @pidl, SFGAO_FILESYSTEM, 0)
    
    if SUCCEEDED(hr) then
      dim psi as IShellItem ptr
      
      hr = SHCreateShellItem(NULL, NULL, pidl, @psi)
      ILFree(pidl)
      if SUCCEEDED(hr) then *ppsi = psi
    end if
    
    return hr
    return E_FAIL
  end function
  
  function FileDialog_AddPlace                   (self as FileDialogImpl ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetDefaultExtension        (self as FileDialogImpl ptr, pszDefaultExtension as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_Close                      (self as FileDialogImpl ptr, hr as HRESULT) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetClientGuid              (self as FileDialogImpl ptr, guid as GUID ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_ClearClientData            (self as FileDialogImpl ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileDialog_SetFilter                  (self as FileDialogImpl ptr, pFilter as IShellItemFilter ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
'-------------------------------------------------------------------------------------------
'FileOpenDialog
  
  function FileOpenDialog_GetResults             (self as FileDialogImpl ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileOpenDialog_GetSelectedItems       (self as FileDialogImpl ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
'-------------------------------------------------------------------------------------------
'FileSaveDialog
  
  function FileSaveDialog_SetSaveAsItem          (self as FileDialogImpl ptr, psi as IShellItem ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileSaveDialog_SetProperties          (self as FileDialogImpl ptr, pStore as IPropertyStore ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileSaveDialog_SetCollectedProperties (self as FileDialogImpl ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileSaveDialog_GetProperties          (self as FileDialogImpl ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
  
  function FileSaveDialog_ApplyProperties        (self as FileDialogImpl ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_FAIL
  end function
end extern

extern "C"
  function FileDialogDestructor(self as FileDialogImpl ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT
    IF_HFREE(self->ofnw.lpstrFilter)
    
    return S_OK
  end function
  
  function FileDialogConstructor(self as FileDialogImpl ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT
    self->ofnw.lStructSize = sizeof(OPENFILENAMEW)
    self->ofnw.nFilterIndex = 1
    self->ofnw.lpstrFile = @self->filePath
    self->ofnw.nMaxFile = MAX_FILEPATH
    
    if IsEqualGUID(rclsid, @CLSID_FileOpenDialog) then
      self->isSaveDialog = FALSE
    elseif IsEqualGUID(rclsid, @CLSID_FileSaveDialog) then
      self->isSaveDialog = TRUE
    else
      return E_FAIL
    end if
    
    return S_OK
  end function
end extern

'-------------------------------------------------------------------------------------------
'Main exports

#define CUSTOM_MAIN
#include "shared\defaultmain.bas"

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as any ptr) as BOOL
    select case uReason
      case DLL_PROCESS_ATTACH
        InitializeCriticalSection(@csWhnd)
        cbase_init(handle, @serverConfig(0), 2)
      case DLL_PROCESS_DETACH
        DeleteCriticalSection(@csWhnd)
        cbase_destroy()
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select
    return DLLMAIN_DEFAULT(handle, uReason, Reserved)
  end function
  
  function DllGetClassObject(rclsid as REFCLSID, riid as REFIID, ppv as any ptr ptr) as HRESULT export
    return cbase_DllGetClassObject(rclsid, riid, ppv)
  end function
  
  function DllCanUnloadNow() as HRESULT export
    return cbase_DllCanUnloadNow()
  end function
      
  function DllUnregisterServer() as HRESULT export
    return cbase_DllUnregisterServer()
  end function

  function DllRegisterServer() as HRESULT export
      return cbase_DllRegisterServer()
  end function
end extern