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

'-------------------------------------------------------------------------------------------

#define MAX_DIALOGS 32
static shared csWhnd as CRITICAL_SECTION
static shared dialogArr(MAX_DIALOGS) as IFileDialogImpl ptr
static shared bindctx as IBindCtx ptr
static shared mal as IMalloc ptr

sub bindHwnd2Dialog(hwnd as HWND, pdlg as IFileDialogImpl ptr)
  EnterCriticalSection(@csWhnd)
  for i as integer = 0 to MAX_DIALOGS
    if dialogArr(i)<>NULL andalso pdlg->dialogHwnd=hwnd then return
  next
  for i as integer = 0 to MAX_DIALOGS
    if dialogArr(i)=NULL then
      pdlg->dialogHwnd = hwnd
      dialogArr(i) = pdlg
      exit for
    end if
  next
  LeaveCriticalSection(@csWhnd)
end sub

function unbindHwndAndDialog(hwnd as HWND) as IFileDialogImpl ptr
  dim pdlg as IFileDialogImpl ptr = NULL
  
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

function getDialogFromHwnd(hwnd as HWND) as IFileDialogImpl ptr
  dim pdlg as IFileDialogImpl ptr = NULL
  
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

#define LCA_ZEROMEMORY   1 shl 0
#define LCA_KEEPCONTENTS 1 shl 1

#define IF_COFREE(x) if x <> NULL then IMalloc_Free(mal, cast(any ptr, x)) : x = NULL
function lazyCoAlloc(pOut as any ptr ptr, flags as DWORD, newSize as int) as any ptr
  dim mem as any ptr
  dim oldSize as int = iif(*pOut=NULL, 0, IMalloc_GetSize(mal, *pOut))
  
  if *pOut=NULL then
    mem = IMalloc_Alloc(mal, newSize)
  elseif newSize > oldSize then
    if flags and LCA_KEEPCONTENTS then
      mem = IMalloc_Alloc(mal, newSize)
      if mem<>NULL then memcpy(mem, *pOut, oldSize)
    else
      mem = IMalloc_ReAlloc(mal, cast(any ptr, *pOut), newSize)
    end if
  else
    mem = *pOut
  end if
  
  if mem<>NULL then
    if flags and LCA_ZEROMEMORY andalso (newSize - oldSize)>0 then ZeroMemory(mem+oldSize, (newSize - oldSize))
    *pOut = mem
  end if
  
  return mem
end function

function getBestcaseFolder(fdlg as IFileDialogImpl ptr) as IShellItem ptr
  if      fdlg->currentFolder<>NULL then 
    return fdlg->currentFolder
  elseif fdlg->overrideFolder<>NULL then
    return fdlg->overrideFolder
  elseif fdlg->defaultFolder<>NULL then
    return fdlg->defaultFolder
  else
    return NULL
  end if
end function

'-------------------------------------------------------------------------------------------
''#define OnFileOk(This, pfd) (This)->lpVtbl->OnFileOk(This, pfd)
'#define OnFolderChanging(This, pfd, psiFolder) (This)->lpVtbl->OnFolderChanging(This, pfd, psiFolder)
''#define OnFolderChange(This, pfd) (This)->lpVtbl->OnFolderChange(This, pfd)
''#define OnSelectionChange(This, pfd) (This)->lpVtbl->OnSelectionChange(This, pfd)
'#define OnShareViolation(This, pfd, psi, pResponse) (This)->lpVtbl->OnShareViolation(This, pfd, psi, pResponse)
''#define OnTypeChange(This, pfd) (This)->lpVtbl->OnTypeChange(This, pfd)
'#define OnOverwrite(This, pfd, psi, pResponse) (This)->lpVtbl->OnOverwrite(This, pfd, psi, pResponse)
extern "windows-ms"
  function dialogEventCB(hwnd as HANDLE, uiMsg as UINT, WPARAM as wParam, lParam as LPARAM) as UINT_PTR
    #macro NOTIFY_FDE(_PDLG, _FUNC, _PARAMS...)
      if _PDLG<>NULL then
        dim evIface as IFileDialogEvents ptr
        
        for i as integer = 0 to _PDLG->usedArrSlots
          evIface = iif(_PDLG->handlerArr(i)<>NULL, _PDLG->handlerArr(i)->pfde, NULL)
          if evIface<>NULL then IFileDialogEvents_##_FUNC(evIface, _PARAMS)
        next
      end if
    #endmacro
    
    select case uiMsg
      case WM_INITDIALOG
        dim pOfnw as OPENFILENAMEW ptr = cast(OPENFILENAMEW ptr, lParam)
        dim pdlg as IFileDialogImpl ptr = cast(IFileDialogImpl ptr, pOfnw->lCustData)
        
        bindHwnd2Dialog(hwnd, pdlg)
      case WM_CLOSE
        unbindHwndAndDialog(hwnd)
      case WM_NOTIFY
        dim ofn as OFNOTIFYW ptr = cast(OFNOTIFYW ptr, lparam)
        dim pdlg as IFileDialogImpl ptr = getDialogFromHwnd(hwnd)
        
        select case ofn->hdr.code
          case CDN_FILEOK
            NOTIFY_FDE(pdlg, OnFileOk, pdlg)
          case CDN_FOLDERCHANGE
            NOTIFY_FDE(pdlg, OnFolderChange, pdlg)
          case CDN_SELCHANGE
            NOTIFY_FDE(pdlg, OnSelectionChange, pdlg)
          case CDN_SHAREVIOLATION
            'NOTIFY_FDE(pdlg, OnShareViolation, pdlg, _psi, _pResponse)
            'ofn->hdr->code
          case CDN_TYPECHANGE
            NOTIFY_FDE(pdlg, OnTypeChange, pdlg)
        end select
    end select
    
    return FALSE
  end function
  
  'FileSystemBindData
  #define SELF cast(IFileSystemBindDataImpl ptr, _self)
  function fnIFileSystemBindData_SetFindData(_self as IFileSystemBindData ptr, pfd as const WIN32_FIND_DATAW ptr) as HRESULT
    SELF->w32fdw = *pfd
    return S_OK
  end function
  
  function fnIFileSystemBindData_GetFindData(_self as IFileSystemBindData ptr, pfd as WIN32_FIND_DATAW ptr) as HRESULT
    *pfd = SELF->w32fdw
    return S_OK
  end function
  #undef SELF
  
  
  'FileDialog
  #define SELF cast(IFileDialogImpl ptr, _self)
  function fnIFileDialog_Show                       (_self as IFileDialog ptr, hwndOwner as HWND) as HRESULT
    dim ret as BOOL
    dim strtFldr as IShellItem ptr
    
    SELF->ofnw.hwndOwner = hwndOwner
    if SELF->dialogHwnd<>NULL then
      'TODO: check how windows likes this
      DEBUG_MsgTrace("Attempt at simultaneous dialog Show().")
      return E_FAIL
    end if
    
    strtFldr = getBestcaseFolder(SELF)
    if strtFldr<>NULL then 
      IShellItem_GetDisplayName(strtFldr, SIGDN_FILESYSPATH, cast(any ptr, @SELF->ofnw.lpstrInitialDir))
    end if
    
    ret = iif(SELF->isSaveDialog, GetSaveFileNameW(@SELF->ofnw), GetOpenFileNameW(@SELF->ofnw))
    if ret then
      dim extLen as int = lstrlenW(SELF->defltExt)
      
      if extLen>0 andalso SELF->ofnw.nFileExtension=0 andalso SELF->isSaveDialog andalso not SELF->isFolderDialog andalso not SELF->ofnw.Flags and OFN_ALLOWMULTISELECT then
        dim fnLen as int = lstrlenW(SELF->ofnw.lpstrFile)
        
        SELF->ofnw.lpstrFile[fnLen] = asc(".")
        memcpy(cast(any ptr, SELF->ofnw.lpstrFile+fnLen+1), @SELF->defltExt, (extLen+1)*sizeof(WCHAR))
      end if
    end if
    
    'TODO: check advanced error
    return iif(ret, S_OK, HRESULT_FROM_WIN32(ERROR_CANCELLED))
  end function
  
  function fnIFileDialog_SetFileTypes               (_self as IFileDialog ptr, cFileTypes as UINT, rgFilterSpec as COMDLG_FILTERSPEC ptr) as HRESULT
    dim size as DWORD = 1 'list is double-NULL terminated
    dim strArr as LPCWSTR ptr = cast(LPCWSTR ptr, rgFilterSpec)
    dim dat as BYTE ptr
    
    for i as integer = 0 to (cFileTypes*2)-1
      size += (lstrlenW(strArr[i])+1) * sizeof(WCHAR)
    next
    
    if lazyCoAlloc(cast(any ptr, @(SELF->ofnw.lpstrFilter)), 0, size)=NULL then return E_OUTOFMEMORY
    
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
  
  function fnIFileDialog_SetFileTypeIndex           (_self as IFileDialog ptr, iFileType as UINT) as HRESULT
    SELF->ofnw.nFilterIndex = iFileType
    
    return S_OK
  end function
  
  function fnIFileDialog_GetFileTypeIndex           (_self as IFileDialog ptr, piFileType as UINT ptr) as HRESULT
    if piFileType=NULL then return E_INVALIDARG
    *piFileType = SELF->ofnw.nFilterIndex
    
    return S_OK
  end function
  
  function fnIFileDialog_Advise                     (_self as IFileDialog ptr, pfde as IFileDialogEvents ptr, pdwCookie as DWORD ptr) as HRESULT
    if pfde=NULL orelse pdwCookie=NULL then return E_INVALIDARG
    
    for i as integer = 0 to MAX_HANDLERS-1
      dim hdlr as PrivEventHandler ptr = SELF->handlerArr(i)
      
      if hdlr=NULL then
        if lazyCoAlloc(@hdlr, LCA_ZEROMEMORY, sizeof(PrivEventHandler))=NULL then exit for
        SELF->handlerArr(i) = hdlr
        
        hdlr->pfde = pfde
        hdlr->cookie = SELF->nextCookie
        'hdlr->pDialog = SELF
        
        SELF->nextCookie += 1
        if SELF->usedArrSlots < i then SELF->usedArrSlots = i
        IFileDialogEvents_AddRef(pfde)
        return S_OK
      end if
    next
    
    return E_OUTOFMEMORY
  end function
  
  function fnIFileDialog_Unadvise                   (_self as IFileDialog ptr, dwCookie as DWORD) as HRESULT
    'Before enabling, we must at least respond to open/save and cancel buttons
    
    for i as integer = 0 to SELF->usedArrSlots
      dim hdlr as PrivEventHandler ptr = SELF->handlerArr(i)
      
      if hdlr<>NULL andalso hdlr->cookie=dwCookie then 
        IFileDialogEvents_Release(hdlr->pfde)
        IMalloc_Free(mal, hdlr)
        return S_OK
      end if
    next
    
    return E_INVALIDARG
  end function
  
  function fnIFileDialog_SetOptions                 (_self as IFileDialog ptr, fos as FILEOPENDIALOGOPTIONS) as HRESULT
    static flgMap(...) as DWORD = { _
      FOS_OVERWRITEPROMPT,               OFN_OVERWRITEPROMPT, _
      FOS_STRICTFILETYPES,               0, _
      FOS_NOCHANGEDIR,                   OFN_NOCHANGEDIR, _
      FOS_PICKFOLDERS,                   0, _
      FOS_FORCEFILESYSTEM,               0, _
      FOS_ALLNONSTORAGEITEMS,            0, _
      FOS_NOVALIDATE,                    OFN_NOVALIDATE, _
      FOS_ALLOWMULTISELECT,              OFN_ALLOWMULTISELECT, _
      FOS_PATHMUSTEXIST,                 OFN_PATHMUSTEXIST, _
      FOS_FILEMUSTEXIST,                 OFN_FILEMUSTEXIST, _
      FOS_CREATEPROMPT,                  OFN_CREATEPROMPT, _
      FOS_SHAREAWARE,                    OFN_SHAREAWARE, _
      FOS_NOREADONLYRETURN,              OFN_NOREADONLYRETURN, _
      FOS_NOTESTFILECREATE,              OFN_NOTESTFILECREATE, _
      _ 'case FOS_HIDEMRUPLACES,            0, 'unsupported in win7+
      FOS_HIDEPINNEDPLACES,              0, _
      FOS_NODEREFERENCELINKS,            OFN_NODEREFERENCELINKS, _
      _ 'case FOS_OKBUTTONNEEDSINTERACTION, 0, '
      FOS_DONTADDTORECENT,               OFN_DONTADDTORECENT, _
      FOS_FORCESHOWHIDDEN,               OFN_FORCESHOWHIDDEN, _
      FOS_DEFAULTNOMINIMODE,             0, _ ' unsupported in win7+
      FOS_FORCEPREVIEWPANEON,            0 _
      _ 'FOS_SUPPORTSTREAMABLEITEMS,       0,
    }
    
    SELF->ofnw.Flags = FFLAGS_DEFAULT
    for i as int = 0 to COUNTOF(flgMap)\2
      if fos and flgMap(i*2+0) then SELF->ofnw.Flags or= flgMap(i*2+1)
    next
    if fos and FOS_PICKFOLDERS then 
      DEBUG_MsgTrace("!! Folder browser wanted.")
    end if
    SELF->isFolderDialog = iif(fos and FOS_PICKFOLDERS, TRUE, FALSE)
    SELF->fos = fos
    
    return S_OK
  end function
  
  function fnIFileDialog_GetOptions                 (_self as IFileDialog ptr, pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    if pfos=NULL then return E_INVALIDARG
    *pfos = SELF->fos
    
    return S_OK
  end function
  
  function fnIFileDialog_SetDefaultFolder           (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
    dim hr as HRESULT = S_OK
    dim sfgao as SFGAOF
    dim newpsi as IShellItem ptr
    
    if psi<>NULL then
      hr = IShellItem_GetAttributes(psi, SFGAO_FOLDER, @sfgao)
      if SUCCEEDED(hr) then
        if sfgao=0 then return E_INVALIDARG
        newpsi = psi
      end if
    else
      newpsi = NULL
    end if
    
    if SELF->defaultFolder<>NULL then IShellItem_Release(SELF->defaultFolder)
    SELF->defaultFolder = newpsi
    if SELF->defaultFolder<>NULL then IShellItem_AddRef(SELF->defaultFolder)
    
    return hr
  end function
  
  function fnIFileDialog_SetFolder                  (_self as IFileDialog ptr, psi as IShellItem ptr) as HRESULT
    dim hr as HRESULT = S_OK
    dim sfgao as SFGAOF
    dim newpsi as IShellItem ptr
    
    if psi<>NULL then
      hr = IShellItem_GetAttributes(psi, SFGAO_FOLDER, @sfgao)
      if SUCCEEDED(hr) then
        if sfgao=0 then return E_INVALIDARG
        newpsi = psi
      end if
    else
      newpsi = NULL
    end if
    
    if SELF->overrideFolder<>NULL then IShellItem_Release(SELF->overrideFolder)
    SELF->overrideFolder = newpsi
    if SELF->overrideFolder<>NULL then IShellItem_AddRef(SELF->overrideFolder)
    
    return hr
  end function
  
  function fnIFileDialog_GetFolder                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
    if ppsi=NULL then return E_INVALIDARG
    
    *ppsi = getBestcaseFolder(SELF)
    if *ppsi=NULL then return E_FAIL
    IShellItem_AddRef(*ppsi)
    
    return S_OK
  end function
  
  function fnIFileDialog_GetCurrentSelection        (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileDialog_SetFileName                (_self as IFileDialog ptr, pszName as LPCWSTR) as HRESULT
    if pszName=NULL then return E_INVALIDARG
    memcpy(cast(any ptr, SELF->ofnw.lpstrFile), pszName, (lstrlenW(pszName)+1) * 2)
    
    return S_OK
  end function
  
  function fnIFileDialog_GetFileName                (_self as IFileDialog ptr, pszName as LPWSTR ptr) as HRESULT
    dim fnSize as int
    
    if pszName<>NULL then return E_INVALIDARG
    
    *pszName = NULL
    fnSize = (lstrlenW(pszName)+1)*sizeof(WCHAR)
    if lazyCoAlloc(pszName, 0, fnSize)=NULL then return E_OUTOFMEMORY
    memcpy(*pszName, SELF->ofnw.lpstrFileTitle, fnSize)
    
    return S_OK
  end function
  
  function fnIFileDialog_SetTitle                   (_self as IFileDialog ptr, pszTitle as LPCWSTR) as HRESULT
    dim length as int
    
    if pszTitle=NULL then return E_INVALIDARG
    length = (lstrlenW(pszTitle)+1) * 2
    if lazyCoAlloc(cast(any ptr, @(SELF->ofnw.lpstrTitle)), 0, length)=NULL then return E_OUTOFMEMORY
    memcpy(cast(any ptr, SELF->ofnw.lpstrTitle), pszTitle, length)
    
    return S_OK
  end function
  
  function fnIFileDialog_SetOkButtonLabel           (_self as IFileDialog ptr, pszText as LPCWSTR) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileDialog_SetFileNameLabel           (_self as IFileDialog ptr, pszLabel as LPCWSTR) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileDialog_GetResult                  (_self as IFileDialog ptr, ppsi as IShellItem ptr ptr) as HRESULT
    dim hr as HRESULT
    dim pidl as PIDLIST_ABSOLUTE
    
    if ppsi=NULL then return E_INVALIDARG
    hr = SHParseDisplayName(SELF->ofnw.lpstrFile, bindctx, @pidl, 0, NULL)
    
    if SUCCEEDED(hr) then
      hr = SHCreateShellItem(NULL, NULL, pidl, ppsi)
      ILFree(pidl)
    end if
    
    return hr
  end function
  
  function fnIFileDialog_AddPlace                   (_self as IFileDialog ptr, psi as IShellItem ptr, fdap as FDAP) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileDialog_SetDefaultExtension        (_self as IFileDialog ptr, pszDefaultExtension as LPCWSTR) as HRESULT
    dim extLen as int = iif(pszDefaultExtension=NULL, 0, lstrlenW(pszDefaultExtension))
    
    if extLen>(MAX_FILEEXT - 1) then extLen = MAX_FILEEXT - 1
    if extLen>0 then
      memcpy(@SELF->defltExt, pszDefaultExtension, (extLen+1)*sizeof(WCHAR))
      SELF->defltExt[MAX_FILEEXT - 1] = 0
    else
      SELF->defltExt[0] = 0
    end if    
    
    return S_OK
  end function
  
  function fnIFileDialog_Close                      (_self as IFileDialog ptr, hr as HRESULT) as HRESULT
    if SELF->dialogHwnd<>NULL then PostMessageA(SELF->dialogHwnd, WM_CLOSE , 0, 0)
    return S_OK
  end function
  
  function fnIFileDialog_SetClientGuid              (_self as IFileDialog ptr, guid as GUID ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileDialog_ClearClientData            (_self as IFileDialog ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileDialog_SetFilter                  (_self as IFileDialog ptr, pFilter as IShellItemFilter ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
'-------------------------------------------------------------------------------------------
'FileOpenDialog
  function fnIFileOpenDialog_GetResults             (_self as IFileOpenDialog ptr, ppenum as IShellItemArray ptr ptr) as HRESULT
    dim hr as HRESULT = S_OK
    dim fileCount as int = 0
    dim pStr as WCHAR ptr
    dim pidlArr as PIDLIST_ABSOLUTE ptr
    
    if ppenum=NULL then return E_INVALIDARG
    *ppenum = NULL
    pStr = SELF->ofnw.lpstrFile
    while 1
      if pStr[0]<>0 then fileCount += 1
      pStr += lstrlenW(pStr) + 1
      if pStr[0]=0 then exit while
    wend
    
    if lazyCoAlloc(@pidlArr, LCA_ZEROMEMORY, sizeof(any ptr) * fileCount)=NULL then return E_OUTOFMEMORY
    
    pStr = SELF->ofnw.lpstrFile
    fileCount = 0
    while 1
      
      hr = SHParseDisplayName(pStr, bindctx, @(pidlArr[fileCount]), 0, NULL)
      if pStr[0]<>0 andalso SUCCEEDED(hr) then fileCount+=1
      
      pStr += lstrlenW(pStr) + 1
      if pStr[0]=0 then exit while
    wend
    hr = SHCreateShellItemArrayFromIDLists(fileCount, pidlArr, ppenum)
    
    for i as int = 0 to fileCount-1
      ILFree(pidlArr[i])
    next
    IMalloc_Free(mal, pidlArr)
    return hr
  end function
  
  function fnIFileOpenDialog_GetSelectedItems       (_self as IFileOpenDialog ptr, ppsai as IShellItemArray ptr ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
'-------------------------------------------------------------------------------------------
'FileSaveDialog
  
  function fnIFileSaveDialog_SetSaveAsItem          (_self as IFileSaveDialog ptr, psi as IShellItem ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileSaveDialog_SetProperties          (_self as IFileSaveDialog ptr, pStore as IPropertyStore ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileSaveDialog_SetCollectedProperties (_self as IFileSaveDialog ptr, pList as IPropertyDescriptionList ptr, fAppendDefault as WINBOOL) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileSaveDialog_GetProperties          (_self as IFileSaveDialog ptr, ppStore as IPropertyStore ptr ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIFileSaveDialog_ApplyProperties        (_self as IFileSaveDialog ptr, psi as IShellItem ptr, pStore as IPropertyStore ptr, hwnd as HWND, pSink as IFileOperationProgressSink ptr) as HRESULT
    
    
    
    
    
    
    
    
    
    
    
    
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern

extern "C"
  function FileDialogDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    IF_COFREE(SELF->ofnw.lpstrFilter)
    IF_COFREE(SELF->ofnw.lpstrTitle)
    IF_COFREE(SELF->ofnw.lpstrInitialDir)
    
    if bindctx<>NULL then
      IBindCtx_RevokeObjectParam(bindctx, STR_FILE_SYS_BIND_DATA)
      IBindCtx_Release(bindctx)
    end if
    
    return S_OK
  end function
  
  function FileDialogConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    dim hr as HRESULT = S_OK
    
    if IsEqualGUID(rclsid, @CLSID_FileOpenDialog) then
      SELF->isSaveDialog = FALSE
    elseif IsEqualGUID(rclsid, @CLSID_FileSaveDialog) then
      SELF->isSaveDialog = TRUE
    else
      return E_FAIL
    end if
    
    SELF->ofnw.lStructSize      = sizeof(OPENFILENAMEW)
    SELF->ofnw.nFilterIndex     = 1
    SELF->ofnw.lpstrFile        = @SELF->filePath
    SELF->ofnw.nMaxFile         = MAX_FILEPATH
    SELF->ofnw.lpstrFileTitle   = @SELF->fileName
    SELF->ofnw.nMaxFileTitle    = MAX_FILENAME
    SELF->ofnw.lCustData        = SELF
    SELF->ofnw.lpfnHook         = @dialogEventCB
    'SELF->ofnw.hInstance = GetModuleHandle(NULL)
    SELF->ofnw.Flags = FFLAGS_DEFAULT
    
    'Based on Raymond Chen's example: https://devblogs.microsoft.com/oldnewthing/?p=4463
    scope
      dim ctx as IBindCtx ptr
      dim fsbd as IFileSystemBindDataImpl ptr
      
      hr = CreateBindCtx(0, @ctx)
      if not SUCCEEDED(hr) then goto FAIL
      hr = cbase_createInstance(@confFSBind, @fsbd, FALSE)
      if not SUCCEEDED(hr) then goto FAIL
      hr = IBindCtx_RegisterObjectParam(ctx, STR_FILE_SYS_BIND_DATA, fsbd)
      if SUCCEEDED(hr) then
        dim w32fdw as WIN32_FIND_DATAW
        dim bo as BIND_OPTS = type(sizeof(BIND_OPTS), 0, STGM_CREATE, 0)
        
        w32fdw.dwFileAttributes = FILE_ATTRIBUTE_NORMAL
        IFileSystemBindData_SetFindData(fsbd, @w32fdw)
        hr = IBindCtx_SetBindOptions(ctx, @bo)
        if not SUCCEEDED(hr) then goto FAIL
        
        bindctx = ctx
        IBindCtx_AddRef(ctx)
      end if
      
      FAIL:
      if fsbd<>NULL then IFileSystemBindData_Release(fsbd)
      if ctx<>NULL  then IBindCtx_Release(ctx)
    end scope
    
    if SUCCEEDED(hr) then
      if mal=NULL then hr = CoGetMalloc(1, @mal)
    end if
    
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
        if mal then IMalloc_Release(mal)
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