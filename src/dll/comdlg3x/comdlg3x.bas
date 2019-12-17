#include "windows.bi"
#include "crt.bi"
#include "win\winbase.bi"
#include "win\objbase.bi"
#include "win\shlobj.bi"
#include "win\commdlg.bi"

#include "shared\helper.bas"
#include "includes\lib\comhelper.h"
#include "includes\win\fix_shobjidl.bi"
#include "includes\win\fix_shellapi.bi"
#include "includes\win\dll_shell3x.bi"

#include "comdlg3x.bi"

'configuration
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

static shared vt_fsbd as IFileSystemBindDataVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @FileSystemBindData_SetFindData, _
  @FileSystemBindData_GetFindData _
)

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

static shared iidFSBind(...) as REFIID = { @IID_IFileSystemBindData, @IID_IUnknown }
static shared confFSBind as COMDesc = type( _
  NULL, @iidFSBind(0), COUNTOF(iidFSBind), _
  @vt_fsbd, sizeof(FileSystemBindDataImpl), _
  NULL, NULL, _
  NULL, NULL, NULL _
)

static shared serverConfig(...) as COMDesc ptr = {@confOpenDialog, @confSaveDialog}

'-------------------------------------------------------------------------------------------

#define MAX_DIALOGS 32
static shared csWhnd as CRITICAL_SECTION
static shared dialogArr(MAX_DIALOGS) as FileDialogImpl ptr

sub bindHwnd2Dialog(hwnd as HWND, pdlg as FileDialogImpl ptr)
  EnterCriticalSection(@csWhnd)
  for i as integer = 0 to MAX_DIALOGS
    if dialogArr(i)=NULL then
      pdlg->dialogHwnd = hwnd
      dialogArr(i) = pdlg
      exit for
    end if
  next
  LeaveCriticalSection(@csWhnd)
end sub

function unbindHwndAndDialog(hwnd as HWND) as FileDialogImpl ptr
  dim pdlg as FileDialogImpl ptr = NULL
  
  EnterCriticalSection(@csWhnd)
  for i as integer = 0 to MAX_DIALOGS
    if dialogArr(i)<>NULL andalso dialogArr(i)->dialogHwnd=hwnd then
      pdlg = dialogArr(i)
      dialogArr(i)->dialogHwnd = NULL
      dialogArr(i) = NULL
      exit for
    end if
  next
  LeaveCriticalSection(@csWhnd)
  return pdlg
end function

function getDialogFromHwnd(hwnd as HWND) as FileDialogImpl ptr
  dim pdlg as FileDialogImpl ptr = NULL
  
  EnterCriticalSection(@csWhnd)
  for i as integer = 0 to MAX_DIALOGS
    if dialogArr(i)<>NULL andalso dialogArr(i)->dialogHwnd=hwnd then
      pdlg = dialogArr(i)
      exit for
    end if
  next
  LeaveCriticalSection(@csWhnd)
  return pdlg
end function

#define IF_HFREE(x) if x <> NULL then HeapFree(GetProcessHeap(), 0, cast(any ptr, x)) : x = NULL
  function lazyHeapAlloc(pOut as any ptr ptr, flags as DWORD, size as SIZE_T) as any ptr
    dim hand as HANDLE = GetProcessHeap()
    dim mem as any ptr
    
    if *pOut=NULL then
      mem = HeapAlloc(hand, 0, size)
    elseif HeapSize(hand, 0, *pOut) < size then
      mem = HeapReAlloc(hand, 0, cast(any ptr, *pOut), size)
    end if
    if mem<>NULL then *pOut = mem
    return mem
  end function

'-------------------------------------------------------------------------------------------
extern "windows-ms"
  function dialogEventCB(hwnd as HANDLE, uiMsg as UINT, WPARAM as wParam, lParam as LPARAM) as UINT_PTR
    #macro NOTIFY_FDE(_PDLG, _FUNC, _PARAMS...)
      if _PDLG<>NULL then
        dim evIface as IFileDialogEvents ptr
        
        for i as integer = 0 to _PDLG->usedArrSlots
          evIface = iif(_PDLG->handlerArr(i)<>NULL, _PDLG->handlerArr(i)->pfde, NULL)
          if evIface<>NULL then evIface->lpVtbl->_FUNC(evIface, _PARAMS)
        next
      end if
    #endmacro
    
    select case uiMsg
      case WM_INITDIALOG
        dim pOfnw as OPENFILENAMEW ptr = cast(OPENFILENAMEW ptr, lParam)
        dim pdlg as FileDialogImpl ptr = cast(FileDialogImpl ptr, pOfnw->lCustData)
        
        bindHwnd2Dialog(hwnd, pdlg)
      case WM_CLOSE
        unbindHwndAndDialog(hwnd)
      case WM_NOTIFY
        dim ofn as OFNOTIFYW ptr = cast(OFNOTIFYW ptr, lparam)
        
        select case ofn->hdr.code
          case CDN_FILEOK
            dim pdlg as FileDialogImpl ptr = getDialogFromHwnd(hwnd)
            
            NOTIFY_FDE(pdlg, OnFileOk, pdlg)
          case CDN_TYPECHANGE
            dim pdlg as FileDialogImpl ptr = getDialogFromHwnd(hwnd)
            
            NOTIFY_FDE(pdlg, OnTypeChange, pdlg)
        end select
    end select
    
    return FALSE
  end function
  
  
  'FileSystemBindData
  #define SELF cast(FileSystemBindDataImpl ptr, _self)
  function FileSystemBindData_SetFindData(_self as IFileSystemBindData ptr, pfd as const WIN32_FIND_DATAW ptr) as HRESULT
    SELF->w32fdw = *pfd
    return S_OK
  end function
  
  function FileSystemBindData_GetFindData(_self as IFileSystemBindData ptr, pfd as WIN32_FIND_DATAW ptr) as HRESULT
    *pfd = SELF->w32fdw
    return S_OK
  end function
  #undef SELF
  
  
  'FileDialog
  #define SELF cast(FileDialogImpl ptr, _self)
  function FileDialog_Show                       (_self as IFileDialog ptr, hwndOwner as HWND) as HRESULT
    dim ret as BOOL
    
    SELF->ofnw.hwndOwner = hwndOwner
    if SELF->dialogHwnd<>NULL then return E_FAIL 'TODO: check how windows likes this
    ret = iif(SELF->isSaveDialog, GetSaveFileNameW(@SELF->ofnw), GetOpenFileNameW(@SELF->ofnw))
    
    'TODO: check advanced error
    return iif(ret, S_OK, HRESULT_FROM_WIN32(ERROR_CANCELLED))
  end function
  
  function FileDialog_SetFileTypes               (_self as IFileDialog ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
    dim size as DWORD = 1 'list is double-NULL terminated
    dim strArr as LPCWSTR ptr = cast(LPCWSTR ptr, rgFilterSpec)
    dim dat as BYTE ptr
    
    for i as integer = 0 to (cFileTypes*2)-1
      size += lstrlenW(strArr[i]) * 2 + 2
    next
    
    if lazyHeapAlloc(cast(any ptr, @(SELF->ofnw.lpstrFilter)), 0, size)=NULL then return E_OUTOFMEMORY
    
    dat = cast(BYTE ptr, SELF->ofnw.lpstrFilter)
    
    for i as integer = 0 to (cFileTypes*2)-1
      size = lstrlenW(strArr[i]) * 2 + 2
      memcpy(dat, strArr[i], size)
      dat += size
    next
    
    dat[0] = 0
    dat[1] = 0
    
    return S_OK
  end function
  
  function FileDialog_SetFileTypeIndex           (_self as IFileDialog ptr, iFileType as UINT) as HRESULT
    SELF->ofnw.nFilterIndex = iFileType
    
    return S_OK
  end function
  
  function FileDialog_GetFileTypeIndex           (_self as IFileDialog ptr, piFileType as UINT ptr) as HRESULT
    if piFileType=NULL then return E_POINTER
    *piFileType = SELF->ofnw.nFilterIndex
    
    return S_OK
  end function
  
  function FileDialog_Advise                     (_self as IFileDialog ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
    dim hand as HANDLE = GetProcessHeap()
    'Before enabling, we must at least respond to open/save and cancel buttons
    if pfde=NULL then return E_INVALIDARG
    if pdwCookie=NULL then return E_POINTER
    
    for i as integer = 0 to MAX_HANDLERS-1
      dim hdlr as PrivEventHandler ptr = SELF->handlerArr(i)
      
      if hdlr=NULL then
        hdlr = HeapAlloc(hand, HEAP_ZERO_MEMORY, sizeof(PrivEventHandler))
        if hdlr=NULL then exit for
        SELF->handlerArr(i) = hdlr
        
        hdlr->pfde = pfde
        hdlr->cookie = SELF->nextCookie
        'hdlr->pDialog = SELF
        
        SELF->nextCookie += 1
        if SELF->usedArrSlots < i then SELF->usedArrSlots = i
        IUnknown_AddRef(pfde)
        return S_OK
      end if
    next
    
    return E_OUTOFMEMORY
  end function
  
  function FileDialog_Unadvise                   (_self as IFileDialog ptr, dwCookie as DWORD) as HRESULT
    dim hand as HANDLE = GetProcessHeap()
    'Before enabling, we must at least respond to open/save and cancel buttons
    
    for i as integer = 0 to SELF->usedArrSlots
      dim hdlr as PrivEventHandler ptr = SELF->handlerArr(i)
      
      if hdlr<>NULL andalso hdlr->cookie=dwCookie then 
        IUnknown_Release(hdlr->pfde)
        HeapFree(hand, 0, hdlr)
        return S_OK
      end if
    next
    
    return E_INVALIDARG
  end function
  
  function FileDialog_SetOptions                 (_self as IFileDialog ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
    for i as int = 0 to (sizeof(long)*8)-1
      select case ((1 shl i) and fos) 
        case FOS_OVERWRITEPROMPT
          SELF->ofnw.Flags or= OFN_OVERWRITEPROMPT
        case FOS_STRICTFILETYPES
          '
        case FOS_NOCHANGEDIR
          SELF->ofnw.Flags or= OFN_NOCHANGEDIR
        case FOS_PICKFOLDERS
          'TODO
          DEBUG_MsgTrace("!! Folder browser wanted.")
        case FOS_FORCEFILESYSTEM
          '
        case FOS_ALLNONSTORAGEITEMS
          '
        case FOS_NOVALIDATE
          SELF->ofnw.Flags or= OFN_NOVALIDATE
        case FOS_ALLOWMULTISELECT
          SELF->ofnw.Flags or= OFN_ALLOWMULTISELECT
        case FOS_PATHMUSTEXIST
          SELF->ofnw.Flags or= OFN_PATHMUSTEXIST
        case FOS_FILEMUSTEXIST
          SELF->ofnw.Flags or= OFN_FILEMUSTEXIST
        case FOS_CREATEPROMPT
          SELF->ofnw.Flags or= OFN_CREATEPROMPT
        case FOS_SHAREAWARE
          SELF->ofnw.Flags or= OFN_SHAREAWARE
        case FOS_NOREADONLYRETURN
          SELF->ofnw.Flags or= OFN_NOREADONLYRETURN
        case FOS_NOTESTFILECREATE
          SELF->ofnw.Flags or= OFN_NOTESTFILECREATE
        'case FOS_HIDEMRUPLACES
          'unsupported in win7+
        case FOS_HIDEPINNEDPLACES
          '
        case FOS_NODEREFERENCELINKS
          SELF->ofnw.Flags or= OFN_NODEREFERENCELINKS
        'case FOS_OKBUTTONNEEDSINTERACTION
          '
        case FOS_DONTADDTORECENT
          SELF->ofnw.Flags or= OFN_DONTADDTORECENT
        case FOS_FORCESHOWHIDDEN
          SELF->ofnw.Flags or= OFN_FORCESHOWHIDDEN
        case FOS_DEFAULTNOMINIMODE
          ' unsupported in win7+
        case FOS_FORCEPREVIEWPANEON
          '
        'case FOS_SUPPORTSTREAMABLEITEMS
          '
      end select
    next
    
    SELF->isFolderDialog = iif(fos and FOS_PICKFOLDERS, TRUE, FALSE)
    SELF->fos = fos
    
    return S_OK
  end function
  
  function FileDialog_GetOptions                 (_self as IFileDialog ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    if pfos=NULL then return E_POINTER
    *pfos = SELF->fos
    
    return S_OK
  end function
  
  function FileDialog_SetDefaultFolder           (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_SetFolder                  (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_GetFolder                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_GetCurrentSelection        (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_SetFileName                (_self as IFileDialog ptr, pszName as LPCWSTR) as HRESULT
    if pszName=NULL then return E_INVALIDARG
    memcpy(cast(any ptr, SELF->ofnw.lpstrFile), pszName, (lstrlenW(pszName)+1) * 2)
    
    return S_OK
  end function
  
  function FileDialog_GetFileName                (_self as IFileDialog ptr, pszName as LPWSTR ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_SetTitle                   (_self as IFileDialog ptr, pszTitle as LPCWSTR) as HRESULT
    dim length as int
    
    if pszTitle=NULL then return E_INVALIDARG
    length = (lstrlenW(pszTitle)+1) * 2
    if lazyHeapAlloc(cast(any ptr, @(SELF->ofnw.lpstrTitle)), 0, length)=NULL then return E_OUTOFMEMORY
    memcpy(cast(any ptr, SELF->ofnw.lpstrTitle), pszTitle, length)
    
    return S_OK
  end function
  
  function FileDialog_SetOkButtonLabel           (_self as IFileDialog ptr, pszText as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_SetFileNameLabel           (_self as IFileDialog ptr, pszLabel as LPCWSTR) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_GetResult                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
    dim hr as HRESULT
    dim pidl as PIDLIST_ABSOLUTE
    
    if ppsi=NULL then return E_POINTER
    hr = SHParseDisplayName(SELF->ofnw.lpstrFile, SELF->bindctx, @pidl, 0, NULL)
    
    if SUCCEEDED(hr) then
      hr = SHCreateShellItem(NULL, NULL, pidl, ppsi)
      ILFree(pidl)
    end if
    
    return hr
  end function
  
  function FileDialog_AddPlace                   (_self as IFileDialog ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_SetDefaultExtension        (_self as IFileDialog ptr, pszDefaultExtension as LPCWSTR) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_Close                      (_self as IFileDialog ptr, hr as HRESULT) as HRESULT
    '
    if SELF->dialogHwnd<>NULL then PostMessageA(SELF->dialogHwnd, WM_CLOSE , 0, 0)
    return S_OK
  end function
  
  function FileDialog_SetClientGuid              (_self as IFileDialog ptr, guid as GUID ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_ClearClientData            (_self as IFileDialog ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileDialog_SetFilter                  (_self as IFileDialog ptr, pFilter as IShellItemFilter ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
'-------------------------------------------------------------------------------------------
'FileOpenDialog
  function FileOpenDialog_GetResults             (_self as IFileOpenDialog ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
    dim hr as HRESULT = S_OK
    dim hand as HANDLE = GetProcessHeap()
    dim fileCount as int = 0
    dim pStr as WCHAR ptr
    dim pidlArr as PIDLIST_ABSOLUTE ptr
    
    if ppenum=NULL then return E_POINTER
    *ppenum = NULL
    pStr = SELF->ofnw.lpstrFile
    while 1
      if pStr[0]<>0 then fileCount += 1
      pStr += lstrlenW(pStr) + 1
      if pStr[0]=0 then exit while
    wend
    
    pidlArr = HeapAlloc(hand, HEAP_ZERO_MEMORY, sizeof(any ptr) * fileCount)
    if pidlArr=NULL then return E_OUTOFMEMORY
    
    pStr = SELF->ofnw.lpstrFile
    fileCount = 0
    while 1
      
      hr = SHParseDisplayName(pStr, SELF->bindctx, @(pidlArr[fileCount]), 0, NULL)
      if pStr[0]<>0 andalso SUCCEEDED(hr) then fileCount+=1
      
      pStr += lstrlenW(pStr) + 1
      if pStr[0]=0 then exit while
    wend
    hr = SHCreateShellItemArrayFromIDLists(fileCount, pidlArr, ppenum)
    
    for i as int = 0 to fileCount-1
      ILFree(pidlArr[i])
    next
    HeapFree(hand, 0, pidlArr)
    return hr
  end function
  
  function FileOpenDialog_GetSelectedItems       (_self as IFileOpenDialog ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
'-------------------------------------------------------------------------------------------
'FileSaveDialog
  
  function FileSaveDialog_SetSaveAsItem          (_self as IFileSaveDialog ptr, psi as IShellItem ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileSaveDialog_SetProperties          (_self as IFileSaveDialog ptr, pStore as IPropertyStore ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileSaveDialog_SetCollectedProperties (_self as IFileSaveDialog ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileSaveDialog_GetProperties          (_self as IFileSaveDialog ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function FileSaveDialog_ApplyProperties        (_self as IFileSaveDialog ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern

extern "C"
  function FileDialogDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    IF_HFREE(SELF->ofnw.lpstrFilter)
    IF_HFREE(SELF->ofnw.lpstrTitle)
    
    if SELF->bindctx<>NULL then
      SELF->bindctx->lpVtbl->RevokeObjectParam(SELF->bindctx, STR_FILE_SYS_BIND_DATA)
      IUnknown_Release(SELF->bindctx)
    end if
    
    return S_OK
  end function
  
  function FileDialogConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    dim hr as HRESULT = S_OK
    
    SELF->ofnw.lStructSize      = sizeof(OPENFILENAMEW)
    SELF->ofnw.nFilterIndex     = 1
    SELF->ofnw.lpstrFile        = @SELF->filePath
    SELF->ofnw.nMaxFile         = MAX_FILEPATH
    SELF->ofnw.lpstrFileTitle   = @SELF->fileName
    SELF->ofnw.nMaxFileTitle    = MAX_FILENAME
    SELF->ofnw.lCustData        = SELF
    SELF->ofnw.lpfnHook         = @dialogEventCB
    'SELF->ofnw.hInstance = GetModuleHandle(NULL)
    SELF->ofnw.Flags = OFN_EXPLORER or OFN_ENABLEHOOK or OFN_HIDEREADONLY
    
    if IsEqualGUID(rclsid, @CLSID_FileOpenDialog) then
      SELF->isSaveDialog = FALSE
    elseif IsEqualGUID(rclsid, @CLSID_FileSaveDialog) then
      SELF->isSaveDialog = TRUE
    else
      return E_FAIL
    end if
    
    
    'Based on Raymond Chen's example
    ' https://devblogs.microsoft.com/oldnewthing/?p=4463
    scope
      dim bindctx as IBindCtx ptr
      dim fsbd as FileSystemBindDataImpl ptr
      
      hr = CreateBindCtx(0, @bindctx)
      if not SUCCEEDED(hr) then goto FAIL
      hr = cbase_createInstance(@confFSBind, @fsbd, FALSE)
      if not SUCCEEDED(hr) then goto FAIL
      hr = bindctx->lpVtbl->RegisterObjectParam(bindctx, STR_FILE_SYS_BIND_DATA, fsbd)
      if SUCCEEDED(hr) then
        dim w32fdw as WIN32_FIND_DATAW
        dim bo as BIND_OPTS = type(sizeof(BIND_OPTS), 0, STGM_CREATE, 0)
        
        w32fdw.dwFileAttributes = FILE_ATTRIBUTE_NORMAL
        FileSystemBindData_SetFindData(fsbd, @w32fdw)
        hr = bindctx->lpVtbl->SetBindOptions(bindctx, @bo)
        if not SUCCEEDED(hr) then goto FAIL
        
        SELF->bindctx = bindctx
        IUnknown_AddRef(bindctx)
      end if
      
      FAIL:
      if fsbd<>NULL then IUnknown_Release(fsbd)
      if bindctx<>NULL then IUnknown_Release(bindctx)
    end scope
    
    return hr
  end function
end extern
#undef SELF

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