#pragma once

#define EXTERN_GUID(x) extern as const GUID x alias #x
extern "C"
extern as const GUID IID_IFileDialogEvents
extern as const GUID IID_IFileOperationProgressSink
extern as const GUID IID_IFileDialog
extern as const GUID IID_IFileOpenDialog
extern as const GUID IID_IFileSaveDialog
extern as const GUID CLSID_FileOpenDialog
extern as const GUID CLSID_FileSaveDialog
end extern

type KNOWN_FOLDER_FLAG as long
enum
  KF_FLAG_DEFAULT = &h00000000
  KF_FLAG_NO_APPCONTAINER_REDIRECTION = &h00010000
  KF_FLAG_CREATE = &h00008000
  KF_FLAG_DONT_VERIFY = &h00004000
  KF_FLAG_DONT_UNEXPAND = &h00002000
  KF_FLAG_NO_ALIAS = &h00001000
  KF_FLAG_INIT = &h00000800
  KF_FLAG_DEFAULT_PATH = &h00000400
  KF_FLAG_NOT_PARENT_RELATIVE = &h00000200
  KF_FLAG_SIMPLE_IDLIST = &h00000100
  KF_FLAG_ALIAS_ONLY = &h80000000
end enum

  type FDE_OVERWRITE_RESPONSE as long
  enum
    FDEOR_DEFAULT = 0
    FDEOR_ACCEPT = 1
    FDEOR_REFUSE = 2
  end enum
  
  type FDE_SHAREVIOLATION_RESPONSE as long
  enum
    FDESVR_DEFAULT = 0
    FDESVR_ACCEPT = 1
    FDESVR_REFUSE = 2
  end enum
  
  type FDAP as long
  enum
    FDAP_BOTTOM = 0
    FDAP_TOP = 1
  end enum

#ifndef __IFileOperationProgressSink_INTERFACE_DEFINED__
 #define __IFileOperationProgressSink_INTERFACE_DEFINED__
 type IFileOperationProgressSink as IFileOperationProgressSink_
 
 type IFileOperationProgressSinkVtbl
    QueryInterface as function(byval This as IFileOperationProgressSink ptr, byval riid as const IID const ptr, byval ppvObject as any ptr ptr) as HRESULT
    AddRef as function(byval This as IFileOperationProgressSink ptr) as ULONG
    Release as function(byval This as IFileOperationProgressSink ptr) as ULONG
    StartOperations as function(byval This as IFileOperationProgressSink ptr) as HRESULT
    FinishOperations as function(byval This as IFileOperationProgressSink ptr, byval hrResult as HRESULT) as HRESULT
    PreRenameItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
    PostRenameItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval pszNewName as LPCWSTR, byval hrRename as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
    PreMoveItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
    PostMoveItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR, byval hrMove as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
    PreCopyItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
    PostCopyItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR, byval hrCopy as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
    PreDeleteItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr) as HRESULT
    PostDeleteItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval hrDelete as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
    PreNewItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
    PostNewItem as function(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR, byval pszTemplateName as LPCWSTR, byval dwFileAttributes as DWORD, byval hrNew as HRESULT, byval psiNewItem as IShellItem ptr) as HRESULT
    UpdateProgress as function(byval This as IFileOperationProgressSink ptr, byval iWorkTotal as UINT, byval iWorkSoFar as UINT) as HRESULT
    ResetTimer as function(byval This as IFileOperationProgressSink ptr) as HRESULT
    PauseTimer as function(byval This as IFileOperationProgressSink ptr) as HRESULT
    ResumeTimer as function(byval This as IFileOperationProgressSink ptr) as HRESULT
 end type
 
 type IFileOperationProgressSink_
    lpVtbl as IFileOperationProgressSinkVtbl ptr
 end type
 
 #define IFileOperationProgressSink_QueryInterface(This, riid, ppvObject) (This)->lpVtbl->QueryInterface(This, riid, ppvObject)
 #define IFileOperationProgressSink_AddRef(This) (This)->lpVtbl->AddRef(This)
 #define IFileOperationProgressSink_Release(This) (This)->lpVtbl->Release(This)
 #define IFileOperationProgressSink_StartOperations(This) (This)->lpVtbl->StartOperations(This)
 #define IFileOperationProgressSink_FinishOperations(This, hrResult) (This)->lpVtbl->FinishOperations(This, hrResult)
 #define IFileOperationProgressSink_PreRenameItem(This, dwFlags, psiItem, pszNewName) (This)->lpVtbl->PreRenameItem(This, dwFlags, psiItem, pszNewName)
 #define IFileOperationProgressSink_PostRenameItem(This, dwFlags, psiItem, pszNewName, hrRename, psiNewlyCreated) (This)->lpVtbl->PostRenameItem(This, dwFlags, psiItem, pszNewName, hrRename, psiNewlyCreated)
 #define IFileOperationProgressSink_PreMoveItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName) (This)->lpVtbl->PreMoveItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName)
 #define IFileOperationProgressSink_PostMoveItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName, hrMove, psiNewlyCreated) (This)->lpVtbl->PostMoveItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName, hrMove, psiNewlyCreated)
 #define IFileOperationProgressSink_PreCopyItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName) (This)->lpVtbl->PreCopyItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName)
 #define IFileOperationProgressSink_PostCopyItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName, hrCopy, psiNewlyCreated) (This)->lpVtbl->PostCopyItem(This, dwFlags, psiItem, psiDestinationFolder, pszNewName, hrCopy, psiNewlyCreated)
 #define IFileOperationProgressSink_PreDeleteItem(This, dwFlags, psiItem) (This)->lpVtbl->PreDeleteItem(This, dwFlags, psiItem)
 #define IFileOperationProgressSink_PostDeleteItem(This, dwFlags, psiItem, hrDelete, psiNewlyCreated) (This)->lpVtbl->PostDeleteItem(This, dwFlags, psiItem, hrDelete, psiNewlyCreated)
 #define IFileOperationProgressSink_PreNewItem(This, dwFlags, psiDestinationFolder, pszNewName) (This)->lpVtbl->PreNewItem(This, dwFlags, psiDestinationFolder, pszNewName)
 #define IFileOperationProgressSink_PostNewItem(This, dwFlags, psiDestinationFolder, pszNewName, pszTemplateName, dwFileAttributes, hrNew, psiNewItem) (This)->lpVtbl->PostNewItem(This, dwFlags, psiDestinationFolder, pszNewName, pszTemplateName, dwFileAttributes, hrNew, psiNewItem)
 #define IFileOperationProgressSink_UpdateProgress(This, iWorkTotal, iWorkSoFar) (This)->lpVtbl->UpdateProgress(This, iWorkTotal, iWorkSoFar)
 #define IFileOperationProgressSink_ResetTimer(This) (This)->lpVtbl->ResetTimer(This)
 #define IFileOperationProgressSink_PauseTimer(This) (This)->lpVtbl->PauseTimer(This)
 #define IFileOperationProgressSink_ResumeTimer(This) (This)->lpVtbl->ResumeTimer(This)
 
 declare function IFileOperationProgressSink_StartOperations_Proxy(byval This as IFileOperationProgressSink ptr) as HRESULT
 declare sub IFileOperationProgressSink_StartOperations_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_FinishOperations_Proxy(byval This as IFileOperationProgressSink ptr, byval hrResult as HRESULT) as HRESULT
 declare sub IFileOperationProgressSink_FinishOperations_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PreRenameItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
 declare sub IFileOperationProgressSink_PreRenameItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PostRenameItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval pszNewName as LPCWSTR, byval hrRename as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
 declare sub IFileOperationProgressSink_PostRenameItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PreMoveItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
 declare sub IFileOperationProgressSink_PreMoveItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PostMoveItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR, byval hrMove as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
 declare sub IFileOperationProgressSink_PostMoveItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PreCopyItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
 declare sub IFileOperationProgressSink_PreCopyItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PostCopyItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR, byval hrCopy as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
 declare sub IFileOperationProgressSink_PostCopyItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PreDeleteItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr) as HRESULT
 declare sub IFileOperationProgressSink_PreDeleteItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PostDeleteItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiItem as IShellItem ptr, byval hrDelete as HRESULT, byval psiNewlyCreated as IShellItem ptr) as HRESULT
 declare sub IFileOperationProgressSink_PostDeleteItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PreNewItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR) as HRESULT
 declare sub IFileOperationProgressSink_PreNewItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PostNewItem_Proxy(byval This as IFileOperationProgressSink ptr, byval dwFlags as DWORD, byval psiDestinationFolder as IShellItem ptr, byval pszNewName as LPCWSTR, byval pszTemplateName as LPCWSTR, byval dwFileAttributes as DWORD, byval hrNew as HRESULT, byval psiNewItem as IShellItem ptr) as HRESULT
 declare sub IFileOperationProgressSink_PostNewItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_UpdateProgress_Proxy(byval This as IFileOperationProgressSink ptr, byval iWorkTotal as UINT, byval iWorkSoFar as UINT) as HRESULT
 declare sub IFileOperationProgressSink_UpdateProgress_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_ResetTimer_Proxy(byval This as IFileOperationProgressSink ptr) as HRESULT
 declare sub IFileOperationProgressSink_ResetTimer_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_PauseTimer_Proxy(byval This as IFileOperationProgressSink ptr) as HRESULT
 declare sub IFileOperationProgressSink_PauseTimer_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOperationProgressSink_ResumeTimer_Proxy(byval This as IFileOperationProgressSink ptr) as HRESULT
 declare sub IFileOperationProgressSink_ResumeTimer_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
#endif

#ifndef __IFileDialogEvents_INTERFACE_DEFINED__
  #define __IFileDialogEvents_INTERFACE_DEFINED__
  type IFileDialogEvents as IFileDialogEvents_
  type IFileDialog as IFileDialog_
  
  type IFileDialogEventsVtbl
    QueryInterface as function(byval This as IFileDialogEvents ptr, byval riid as const IID const ptr, byval ppvObject as any ptr ptr) as HRESULT
    AddRef as function(byval This as IFileDialogEvents ptr) as ULONG
    Release as function(byval This as IFileDialogEvents ptr) as ULONG
    OnFileOk as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
    OnFolderChanging as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr, byval psiFolder as IShellItem ptr) as HRESULT
    OnFolderChange as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
    OnSelectionChange as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
    OnShareViolation as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_SHAREVIOLATION_RESPONSE ptr) as HRESULT
    OnTypeChange as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
    OnOverwrite as function(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_OVERWRITE_RESPONSE ptr) as HRESULT
  end type
  
  type IFileDialogEvents_
    lpVtbl as IFileDialogEventsVtbl ptr
  end type
  
  #define IFileDialogEvents_QueryInterface(This, riid, ppvObject) (This)->lpVtbl->QueryInterface(This, riid, ppvObject)
  #define IFileDialogEvents_AddRef(This) (This)->lpVtbl->AddRef(This)
  #define IFileDialogEvents_Release(This) (This)->lpVtbl->Release(This)
  #define IFileDialogEvents_OnFileOk(This, pfd) (This)->lpVtbl->OnFileOk(This, pfd)
  #define IFileDialogEvents_OnFolderChanging(This, pfd, psiFolder) (This)->lpVtbl->OnFolderChanging(This, pfd, psiFolder)
  #define IFileDialogEvents_OnFolderChange(This, pfd) (This)->lpVtbl->OnFolderChange(This, pfd)
  #define IFileDialogEvents_OnSelectionChange(This, pfd) (This)->lpVtbl->OnSelectionChange(This, pfd)
  #define IFileDialogEvents_OnShareViolation(This, pfd, psi, pResponse) (This)->lpVtbl->OnShareViolation(This, pfd, psi, pResponse)
  #define IFileDialogEvents_OnTypeChange(This, pfd) (This)->lpVtbl->OnTypeChange(This, pfd)
  #define IFileDialogEvents_OnOverwrite(This, pfd, psi, pResponse) (This)->lpVtbl->OnOverwrite(This, pfd, psi, pResponse)
  
  declare function IFileDialogEvents_OnFileOk_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
  declare sub IFileDialogEvents_OnFileOk_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialogEvents_OnFolderChanging_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr, byval psiFolder as IShellItem ptr) as HRESULT
  declare sub IFileDialogEvents_OnFolderChanging_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialogEvents_OnFolderChange_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
  declare sub IFileDialogEvents_OnFolderChange_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialogEvents_OnSelectionChange_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
  declare sub IFileDialogEvents_OnSelectionChange_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialogEvents_OnShareViolation_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_SHAREVIOLATION_RESPONSE ptr) as HRESULT
  declare sub IFileDialogEvents_OnShareViolation_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialogEvents_OnTypeChange_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr) as HRESULT
  declare sub IFileDialogEvents_OnTypeChange_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialogEvents_OnOverwrite_Proxy(byval This as IFileDialogEvents ptr, byval pfd as IFileDialog ptr, byval psi as IShellItem ptr, byval pResponse as FDE_OVERWRITE_RESPONSE ptr) as HRESULT
  declare sub IFileDialogEvents_OnOverwrite_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
#endif

#ifndef __IFileDialog_INTERFACE_DEFINED__
  #define __IFileDialog_INTERFACE_DEFINED__
  
  type _FILEOPENDIALOGOPTIONS as long
  enum
    FOS_OVERWRITEPROMPT = &h2
    FOS_STRICTFILETYPES = &h4
    FOS_NOCHANGEDIR = &h8
    FOS_PICKFOLDERS = &h20
    FOS_FORCEFILESYSTEM = &h40
    FOS_ALLNONSTORAGEITEMS = &h80
    FOS_NOVALIDATE = &h100
    FOS_ALLOWMULTISELECT = &h200
    FOS_PATHMUSTEXIST = &h800
    FOS_FILEMUSTEXIST = &h1000
    FOS_CREATEPROMPT = &h2000
    FOS_SHAREAWARE = &h4000
    FOS_NOREADONLYRETURN = &h8000
    FOS_NOTESTFILECREATE = &h10000
    FOS_HIDEMRUPLACES = &h20000
    FOS_HIDEPINNEDPLACES = &h40000
    FOS_NODEREFERENCELINKS = &h100000
    FOS_DONTADDTORECENT = &h2000000
    FOS_FORCESHOWHIDDEN = &h10000000
    FOS_DEFAULTNOMINIMODE = &h20000000
    FOS_FORCEPREVIEWPANEON = &h40000000
  end enum
  
  type FILEOPENDIALOGOPTIONS as DWORD
  
  type IFileDialogVtbl
    QueryInterface as function(byval This as IFileDialog ptr, byval riid as const IID const ptr, byval ppvObject as any ptr ptr) as HRESULT
    AddRef as function(byval This as IFileDialog ptr) as ULONG
    Release as function(byval This as IFileDialog ptr) as ULONG
    Show as function(byval This as IFileDialog ptr, byval hwndOwner as HWND) as HRESULT
    SetFileTypes as function(byval This as IFileDialog ptr, byval cFileTypes as UINT, byval rgFilterSpec as const COMDLG_FILTERSPEC ptr) as HRESULT
    SetFileTypeIndex as function(byval This as IFileDialog ptr, byval iFileType as UINT) as HRESULT
    GetFileTypeIndex as function(byval This as IFileDialog ptr, byval piFileType as UINT ptr) as HRESULT
    Advise as function(byval This as IFileDialog ptr, byval pfde as IFileDialogEvents ptr, byval pdwCookie as DWORD ptr) as HRESULT
    Unadvise as function(byval This as IFileDialog ptr, byval dwCookie as DWORD) as HRESULT
    SetOptions as function(byval This as IFileDialog ptr, byval fos as FILEOPENDIALOGOPTIONS) as HRESULT
    GetOptions as function(byval This as IFileDialog ptr, byval pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    SetDefaultFolder as function(byval This as IFileDialog ptr, byval psi as IShellItem ptr) as HRESULT
    SetFolder as function(byval This as IFileDialog ptr, byval psi as IShellItem ptr) as HRESULT
    GetFolder as function(byval This as IFileDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    GetCurrentSelection as function(byval This as IFileDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    SetFileName as function(byval This as IFileDialog ptr, byval pszName as LPCWSTR) as HRESULT
    GetFileName as function(byval This as IFileDialog ptr, byval pszName as LPWSTR ptr) as HRESULT
    SetTitle as function(byval This as IFileDialog ptr, byval pszTitle as LPCWSTR) as HRESULT
    SetOkButtonLabel as function(byval This as IFileDialog ptr, byval pszText as LPCWSTR) as HRESULT
    SetFileNameLabel as function(byval This as IFileDialog ptr, byval pszLabel as LPCWSTR) as HRESULT
    GetResult as function(byval This as IFileDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    AddPlace as function(byval This as IFileDialog ptr, byval psi as IShellItem ptr, byval fdap as FDAP) as HRESULT
    SetDefaultExtension as function(byval This as IFileDialog ptr, byval pszDefaultExtension as LPCWSTR) as HRESULT
    Close as function(byval This as IFileDialog ptr, byval hr as HRESULT) as HRESULT
    SetClientGuid as function(byval This as IFileDialog ptr, byval guid as const GUID const ptr) as HRESULT
    ClearClientData as function(byval This as IFileDialog ptr) as HRESULT
    SetFilter as function(byval This as IFileDialog ptr, byval pFilter as IShellItemFilter ptr) as HRESULT
  end type
  
  type IFileDialog_
    lpVtbl as IFileDialogVtbl ptr
  end type
  
  #define IFileDialog_QueryInterface(This, riid, ppvObject) (This)->lpVtbl->QueryInterface(This, riid, ppvObject)
  #define IFileDialog_AddRef(This) (This)->lpVtbl->AddRef(This)
  #define IFileDialog_Release(This) (This)->lpVtbl->Release(This)
  #define IFileDialog_Show(This, hwndOwner) (This)->lpVtbl->Show(This, hwndOwner)
  #define IFileDialog_SetFileTypes(This, cFileTypes, rgFilterSpec) (This)->lpVtbl->SetFileTypes(This, cFileTypes, rgFilterSpec)
  #define IFileDialog_SetFileTypeIndex(This, iFileType) (This)->lpVtbl->SetFileTypeIndex(This, iFileType)
  #define IFileDialog_GetFileTypeIndex(This, piFileType) (This)->lpVtbl->GetFileTypeIndex(This, piFileType)
  #define IFileDialog_Advise(This, pfde, pdwCookie) (This)->lpVtbl->Advise(This, pfde, pdwCookie)
  #define IFileDialog_Unadvise(This, dwCookie) (This)->lpVtbl->Unadvise(This, dwCookie)
  #define IFileDialog_SetOptions(This, fos) (This)->lpVtbl->SetOptions(This, fos)
  #define IFileDialog_GetOptions(This, pfos) (This)->lpVtbl->GetOptions(This, pfos)
  #define IFileDialog_SetDefaultFolder(This, psi) (This)->lpVtbl->SetDefaultFolder(This, psi)
  #define IFileDialog_SetFolder(This, psi) (This)->lpVtbl->SetFolder(This, psi)
  #define IFileDialog_GetFolder(This, ppsi) (This)->lpVtbl->GetFolder(This, ppsi)
  #define IFileDialog_GetCurrentSelection(This, ppsi) (This)->lpVtbl->GetCurrentSelection(This, ppsi)
  #define IFileDialog_SetFileName(This, pszName) (This)->lpVtbl->SetFileName(This, pszName)
  #define IFileDialog_GetFileName(This, pszName) (This)->lpVtbl->GetFileName(This, pszName)
  #define IFileDialog_SetTitle(This, pszTitle) (This)->lpVtbl->SetTitle(This, pszTitle)
  #define IFileDialog_SetOkButtonLabel(This, pszText) (This)->lpVtbl->SetOkButtonLabel(This, pszText)
  #define IFileDialog_SetFileNameLabel(This, pszLabel) (This)->lpVtbl->SetFileNameLabel(This, pszLabel)
  #define IFileDialog_GetResult(This, ppsi) (This)->lpVtbl->GetResult(This, ppsi)
  #define IFileDialog_AddPlace(This, psi, fdap) (This)->lpVtbl->AddPlace(This, psi, fdap)
  #define IFileDialog_SetDefaultExtension(This, pszDefaultExtension) (This)->lpVtbl->SetDefaultExtension(This, pszDefaultExtension)
  #define IFileDialog_Close(This, hr) (This)->lpVtbl->Close(This, hr)
  #define IFileDialog_SetClientGuid(This, guid) (This)->lpVtbl->SetClientGuid(This, guid)
  #define IFileDialog_ClearClientData(This) (This)->lpVtbl->ClearClientData(This)
  #define IFileDialog_SetFilter(This, pFilter) (This)->lpVtbl->SetFilter(This, pFilter)
  
  declare function IFileDialog_SetFileTypes_Proxy(byval This as IFileDialog ptr, byval cFileTypes as UINT, byval rgFilterSpec as const COMDLG_FILTERSPEC ptr) as HRESULT
  declare sub IFileDialog_SetFileTypes_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetFileTypeIndex_Proxy(byval This as IFileDialog ptr, byval iFileType as UINT) as HRESULT
  declare sub IFileDialog_SetFileTypeIndex_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_GetFileTypeIndex_Proxy(byval This as IFileDialog ptr, byval piFileType as UINT ptr) as HRESULT
  declare sub IFileDialog_GetFileTypeIndex_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_Advise_Proxy(byval This as IFileDialog ptr, byval pfde as IFileDialogEvents ptr, byval pdwCookie as DWORD ptr) as HRESULT
  declare sub IFileDialog_Advise_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_Unadvise_Proxy(byval This as IFileDialog ptr, byval dwCookie as DWORD) as HRESULT
  declare sub IFileDialog_Unadvise_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetOptions_Proxy(byval This as IFileDialog ptr, byval fos as FILEOPENDIALOGOPTIONS) as HRESULT
  declare sub IFileDialog_SetOptions_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_GetOptions_Proxy(byval This as IFileDialog ptr, byval pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
  declare sub IFileDialog_GetOptions_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetDefaultFolder_Proxy(byval This as IFileDialog ptr, byval psi as IShellItem ptr) as HRESULT
  declare sub IFileDialog_SetDefaultFolder_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetFolder_Proxy(byval This as IFileDialog ptr, byval psi as IShellItem ptr) as HRESULT
  declare sub IFileDialog_SetFolder_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_GetFolder_Proxy(byval This as IFileDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
  declare sub IFileDialog_GetFolder_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_GetCurrentSelection_Proxy(byval This as IFileDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
  declare sub IFileDialog_GetCurrentSelection_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetFileName_Proxy(byval This as IFileDialog ptr, byval pszName as LPCWSTR) as HRESULT
  declare sub IFileDialog_SetFileName_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_GetFileName_Proxy(byval This as IFileDialog ptr, byval pszName as LPWSTR ptr) as HRESULT
  declare sub IFileDialog_GetFileName_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetTitle_Proxy(byval This as IFileDialog ptr, byval pszTitle as LPCWSTR) as HRESULT
  declare sub IFileDialog_SetTitle_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetOkButtonLabel_Proxy(byval This as IFileDialog ptr, byval pszText as LPCWSTR) as HRESULT
  declare sub IFileDialog_SetOkButtonLabel_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetFileNameLabel_Proxy(byval This as IFileDialog ptr, byval pszLabel as LPCWSTR) as HRESULT
  declare sub IFileDialog_SetFileNameLabel_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_GetResult_Proxy(byval This as IFileDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
  declare sub IFileDialog_GetResult_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_AddPlace_Proxy(byval This as IFileDialog ptr, byval psi as IShellItem ptr, byval fdap as FDAP) as HRESULT
  declare sub IFileDialog_AddPlace_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetDefaultExtension_Proxy(byval This as IFileDialog ptr, byval pszDefaultExtension as LPCWSTR) as HRESULT
  declare sub IFileDialog_SetDefaultExtension_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_Close_Proxy(byval This as IFileDialog ptr, byval hr as HRESULT) as HRESULT
  declare sub IFileDialog_Close_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetClientGuid_Proxy(byval This as IFileDialog ptr, byval guid as const GUID const ptr) as HRESULT
  declare sub IFileDialog_SetClientGuid_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_ClearClientData_Proxy(byval This as IFileDialog ptr) as HRESULT
  declare sub IFileDialog_ClearClientData_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileDialog_SetFilter_Proxy(byval This as IFileDialog ptr, byval pFilter as IShellItemFilter ptr) as HRESULT
  declare sub IFileDialog_SetFilter_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
#endif

#ifndef __IFileSaveDialog_INTERFACE_DEFINED__
  #define __IFileSaveDialog_INTERFACE_DEFINED__
  type IFileSaveDialog as IFileSaveDialog_
  
  type IFileSaveDialogVtbl
    QueryInterface as function(byval This as IFileSaveDialog ptr, byval riid as const IID const ptr, byval ppvObject as any ptr ptr) as HRESULT
    AddRef as function(byval This as IFileSaveDialog ptr) as ULONG
    Release as function(byval This as IFileSaveDialog ptr) as ULONG
    Show as function(byval This as IFileSaveDialog ptr, byval hwndOwner as HWND) as HRESULT
    SetFileTypes as function(byval This as IFileSaveDialog ptr, byval cFileTypes as UINT, byval rgFilterSpec as const COMDLG_FILTERSPEC ptr) as HRESULT
    SetFileTypeIndex as function(byval This as IFileSaveDialog ptr, byval iFileType as UINT) as HRESULT
    GetFileTypeIndex as function(byval This as IFileSaveDialog ptr, byval piFileType as UINT ptr) as HRESULT
    Advise as function(byval This as IFileSaveDialog ptr, byval pfde as IFileDialogEvents ptr, byval pdwCookie as DWORD ptr) as HRESULT
    Unadvise as function(byval This as IFileSaveDialog ptr, byval dwCookie as DWORD) as HRESULT
    SetOptions as function(byval This as IFileSaveDialog ptr, byval fos as FILEOPENDIALOGOPTIONS) as HRESULT
    GetOptions as function(byval This as IFileSaveDialog ptr, byval pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    SetDefaultFolder as function(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr) as HRESULT
    SetFolder as function(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr) as HRESULT
    GetFolder as function(byval This as IFileSaveDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    GetCurrentSelection as function(byval This as IFileSaveDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    SetFileName as function(byval This as IFileSaveDialog ptr, byval pszName as LPCWSTR) as HRESULT
    GetFileName as function(byval This as IFileSaveDialog ptr, byval pszName as LPWSTR ptr) as HRESULT
    SetTitle as function(byval This as IFileSaveDialog ptr, byval pszTitle as LPCWSTR) as HRESULT
    SetOkButtonLabel as function(byval This as IFileSaveDialog ptr, byval pszText as LPCWSTR) as HRESULT
    SetFileNameLabel as function(byval This as IFileSaveDialog ptr, byval pszLabel as LPCWSTR) as HRESULT
    GetResult as function(byval This as IFileSaveDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    AddPlace as function(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr, byval fdap as FDAP) as HRESULT
    SetDefaultExtension as function(byval This as IFileSaveDialog ptr, byval pszDefaultExtension as LPCWSTR) as HRESULT
    Close as function(byval This as IFileSaveDialog ptr, byval hr as HRESULT) as HRESULT
    SetClientGuid as function(byval This as IFileSaveDialog ptr, byval guid as const GUID const ptr) as HRESULT
    ClearClientData as function(byval This as IFileSaveDialog ptr) as HRESULT
    SetFilter as function(byval This as IFileSaveDialog ptr, byval pFilter as IShellItemFilter ptr) as HRESULT
    SetSaveAsItem as function(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr) as HRESULT
    SetProperties as function(byval This as IFileSaveDialog ptr, byval pStore as IPropertyStore ptr) as HRESULT
    SetCollectedProperties as function(byval This as IFileSaveDialog ptr, byval pList as IPropertyDescriptionList ptr, byval fAppendDefault as WINBOOL) as HRESULT
    GetProperties as function(byval This as IFileSaveDialog ptr, byval ppStore as IPropertyStore ptr ptr) as HRESULT
    ApplyProperties as function(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr, byval pStore as IPropertyStore ptr, byval hwnd as HWND, byval pSink as IFileOperationProgressSink ptr) as HRESULT
  end type
  
  type IFileSaveDialog_
    lpVtbl as IFileSaveDialogVtbl ptr
  end type
  
  #define IFileSaveDialog_QueryInterface(This, riid, ppvObject) (This)->lpVtbl->QueryInterface(This, riid, ppvObject)
  #define IFileSaveDialog_AddRef(This) (This)->lpVtbl->AddRef(This)
  #define IFileSaveDialog_Release(This) (This)->lpVtbl->Release(This)
  #define IFileSaveDialog_Show(This, hwndOwner) (This)->lpVtbl->Show(This, hwndOwner)
  #define IFileSaveDialog_SetFileTypes(This, cFileTypes, rgFilterSpec) (This)->lpVtbl->SetFileTypes(This, cFileTypes, rgFilterSpec)
  #define IFileSaveDialog_SetFileTypeIndex(This, iFileType) (This)->lpVtbl->SetFileTypeIndex(This, iFileType)
  #define IFileSaveDialog_GetFileTypeIndex(This, piFileType) (This)->lpVtbl->GetFileTypeIndex(This, piFileType)
  #define IFileSaveDialog_Advise(This, pfde, pdwCookie) (This)->lpVtbl->Advise(This, pfde, pdwCookie)
  #define IFileSaveDialog_Unadvise(This, dwCookie) (This)->lpVtbl->Unadvise(This, dwCookie)
  #define IFileSaveDialog_SetOptions(This, fos) (This)->lpVtbl->SetOptions(This, fos)
  #define IFileSaveDialog_GetOptions(This, pfos) (This)->lpVtbl->GetOptions(This, pfos)
  #define IFileSaveDialog_SetDefaultFolder(This, psi) (This)->lpVtbl->SetDefaultFolder(This, psi)
  #define IFileSaveDialog_SetFolder(This, psi) (This)->lpVtbl->SetFolder(This, psi)
  #define IFileSaveDialog_GetFolder(This, ppsi) (This)->lpVtbl->GetFolder(This, ppsi)
  #define IFileSaveDialog_GetCurrentSelection(This, ppsi) (This)->lpVtbl->GetCurrentSelection(This, ppsi)
  #define IFileSaveDialog_SetFileName(This, pszName) (This)->lpVtbl->SetFileName(This, pszName)
  #define IFileSaveDialog_GetFileName(This, pszName) (This)->lpVtbl->GetFileName(This, pszName)
  #define IFileSaveDialog_SetTitle(This, pszTitle) (This)->lpVtbl->SetTitle(This, pszTitle)
  #define IFileSaveDialog_SetOkButtonLabel(This, pszText) (This)->lpVtbl->SetOkButtonLabel(This, pszText)
  #define IFileSaveDialog_SetFileNameLabel(This, pszLabel) (This)->lpVtbl->SetFileNameLabel(This, pszLabel)
  #define IFileSaveDialog_GetResult(This, ppsi) (This)->lpVtbl->GetResult(This, ppsi)
  #define IFileSaveDialog_AddPlace(This, psi, fdap) (This)->lpVtbl->AddPlace(This, psi, fdap)
  #define IFileSaveDialog_SetDefaultExtension(This, pszDefaultExtension) (This)->lpVtbl->SetDefaultExtension(This, pszDefaultExtension)
  #define IFileSaveDialog_Close(This, hr) (This)->lpVtbl->Close(This, hr)
  #define IFileSaveDialog_SetClientGuid(This, guid) (This)->lpVtbl->SetClientGuid(This, guid)
  #define IFileSaveDialog_ClearClientData(This) (This)->lpVtbl->ClearClientData(This)
  #define IFileSaveDialog_SetFilter(This, pFilter) (This)->lpVtbl->SetFilter(This, pFilter)
  #define IFileSaveDialog_SetSaveAsItem(This, psi) (This)->lpVtbl->SetSaveAsItem(This, psi)
  #define IFileSaveDialog_SetProperties(This, pStore) (This)->lpVtbl->SetProperties(This, pStore)
  #define IFileSaveDialog_SetCollectedProperties(This, pList, fAppendDefault) (This)->lpVtbl->SetCollectedProperties(This, pList, fAppendDefault)
  #define IFileSaveDialog_GetProperties(This, ppStore) (This)->lpVtbl->GetProperties(This, ppStore)
  #define IFileSaveDialog_ApplyProperties(This, psi, pStore, hwnd, pSink) (This)->lpVtbl->ApplyProperties(This, psi, pStore, hwnd, pSink)
  
  declare function IFileSaveDialog_SetSaveAsItem_Proxy(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr) as HRESULT
  declare sub IFileSaveDialog_SetSaveAsItem_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileSaveDialog_SetProperties_Proxy(byval This as IFileSaveDialog ptr, byval pStore as IPropertyStore ptr) as HRESULT
  declare sub IFileSaveDialog_SetProperties_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileSaveDialog_SetCollectedProperties_Proxy(byval This as IFileSaveDialog ptr, byval pList as IPropertyDescriptionList ptr, byval fAppendDefault as WINBOOL) as HRESULT
  declare sub IFileSaveDialog_SetCollectedProperties_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileSaveDialog_GetProperties_Proxy(byval This as IFileSaveDialog ptr, byval ppStore as IPropertyStore ptr ptr) as HRESULT
  declare sub IFileSaveDialog_GetProperties_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
  declare function IFileSaveDialog_ApplyProperties_Proxy(byval This as IFileSaveDialog ptr, byval psi as IShellItem ptr, byval pStore as IPropertyStore ptr, byval hwnd as HWND, byval pSink as IFileOperationProgressSink ptr) as HRESULT
  declare sub IFileSaveDialog_ApplyProperties_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
#endif

#ifndef __IFileOpenDialog_INTERFACE_DEFINED__
 #define __IFileOpenDialog_INTERFACE_DEFINED__
 type IFileOpenDialog as IFileOpenDialog_
 
 type IFileOpenDialogVtbl
    QueryInterface as function(byval This as IFileOpenDialog ptr, byval riid as const IID const ptr, byval ppvObject as any ptr ptr) as HRESULT
    AddRef as function(byval This as IFileOpenDialog ptr) as ULONG
    Release as function(byval This as IFileOpenDialog ptr) as ULONG
    Show as function(byval This as IFileOpenDialog ptr, byval hwndOwner as HWND) as HRESULT
    SetFileTypes as function(byval This as IFileOpenDialog ptr, byval cFileTypes as UINT, byval rgFilterSpec as const COMDLG_FILTERSPEC ptr) as HRESULT
    SetFileTypeIndex as function(byval This as IFileOpenDialog ptr, byval iFileType as UINT) as HRESULT
    GetFileTypeIndex as function(byval This as IFileOpenDialog ptr, byval piFileType as UINT ptr) as HRESULT
    Advise as function(byval This as IFileOpenDialog ptr, byval pfde as IFileDialogEvents ptr, byval pdwCookie as DWORD ptr) as HRESULT
    Unadvise as function(byval This as IFileOpenDialog ptr, byval dwCookie as DWORD) as HRESULT
    SetOptions as function(byval This as IFileOpenDialog ptr, byval fos as FILEOPENDIALOGOPTIONS) as HRESULT
    GetOptions as function(byval This as IFileOpenDialog ptr, byval pfos as FILEOPENDIALOGOPTIONS ptr) as HRESULT
    SetDefaultFolder as function(byval This as IFileOpenDialog ptr, byval psi as IShellItem ptr) as HRESULT
    SetFolder as function(byval This as IFileOpenDialog ptr, byval psi as IShellItem ptr) as HRESULT
    GetFolder as function(byval This as IFileOpenDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    GetCurrentSelection as function(byval This as IFileOpenDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    SetFileName as function(byval This as IFileOpenDialog ptr, byval pszName as LPCWSTR) as HRESULT
    GetFileName as function(byval This as IFileOpenDialog ptr, byval pszName as LPWSTR ptr) as HRESULT
    SetTitle as function(byval This as IFileOpenDialog ptr, byval pszTitle as LPCWSTR) as HRESULT
    SetOkButtonLabel as function(byval This as IFileOpenDialog ptr, byval pszText as LPCWSTR) as HRESULT
    SetFileNameLabel as function(byval This as IFileOpenDialog ptr, byval pszLabel as LPCWSTR) as HRESULT
    GetResult as function(byval This as IFileOpenDialog ptr, byval ppsi as IShellItem ptr ptr) as HRESULT
    AddPlace as function(byval This as IFileOpenDialog ptr, byval psi as IShellItem ptr, byval fdap as FDAP) as HRESULT
    SetDefaultExtension as function(byval This as IFileOpenDialog ptr, byval pszDefaultExtension as LPCWSTR) as HRESULT
    Close as function(byval This as IFileOpenDialog ptr, byval hr as HRESULT) as HRESULT
    SetClientGuid as function(byval This as IFileOpenDialog ptr, byval guid as const GUID const ptr) as HRESULT
    ClearClientData as function(byval This as IFileOpenDialog ptr) as HRESULT
    SetFilter as function(byval This as IFileOpenDialog ptr, byval pFilter as IShellItemFilter ptr) as HRESULT
    GetResults as function(byval This as IFileOpenDialog ptr, byval ppenum as IShellItemArray ptr ptr) as HRESULT
    GetSelectedItems as function(byval This as IFileOpenDialog ptr, byval ppsai as IShellItemArray ptr ptr) as HRESULT
 end type
 
 type IFileOpenDialog_
    lpVtbl as IFileOpenDialogVtbl ptr
 end type
 
 #define IFileOpenDialog_QueryInterface(This, riid, ppvObject) (This)->lpVtbl->QueryInterface(This, riid, ppvObject)
 #define IFileOpenDialog_AddRef(This) (This)->lpVtbl->AddRef(This)
 #define IFileOpenDialog_Release(This) (This)->lpVtbl->Release(This)
 #define IFileOpenDialog_Show(This, hwndOwner) (This)->lpVtbl->Show(This, hwndOwner)
 #define IFileOpenDialog_SetFileTypes(This, cFileTypes, rgFilterSpec) (This)->lpVtbl->SetFileTypes(This, cFileTypes, rgFilterSpec)
 #define IFileOpenDialog_SetFileTypeIndex(This, iFileType) (This)->lpVtbl->SetFileTypeIndex(This, iFileType)
 #define IFileOpenDialog_GetFileTypeIndex(This, piFileType) (This)->lpVtbl->GetFileTypeIndex(This, piFileType)
 #define IFileOpenDialog_Advise(This, pfde, pdwCookie) (This)->lpVtbl->Advise(This, pfde, pdwCookie)
 #define IFileOpenDialog_Unadvise(This, dwCookie) (This)->lpVtbl->Unadvise(This, dwCookie)
 #define IFileOpenDialog_SetOptions(This, fos) (This)->lpVtbl->SetOptions(This, fos)
 #define IFileOpenDialog_GetOptions(This, pfos) (This)->lpVtbl->GetOptions(This, pfos)
 #define IFileOpenDialog_SetDefaultFolder(This, psi) (This)->lpVtbl->SetDefaultFolder(This, psi)
 #define IFileOpenDialog_SetFolder(This, psi) (This)->lpVtbl->SetFolder(This, psi)
 #define IFileOpenDialog_GetFolder(This, ppsi) (This)->lpVtbl->GetFolder(This, ppsi)
 #define IFileOpenDialog_GetCurrentSelection(This, ppsi) (This)->lpVtbl->GetCurrentSelection(This, ppsi)
 #define IFileOpenDialog_SetFileName(This, pszName) (This)->lpVtbl->SetFileName(This, pszName)
 #define IFileOpenDialog_GetFileName(This, pszName) (This)->lpVtbl->GetFileName(This, pszName)
 #define IFileOpenDialog_SetTitle(This, pszTitle) (This)->lpVtbl->SetTitle(This, pszTitle)
 #define IFileOpenDialog_SetOkButtonLabel(This, pszText) (This)->lpVtbl->SetOkButtonLabel(This, pszText)
 #define IFileOpenDialog_SetFileNameLabel(This, pszLabel) (This)->lpVtbl->SetFileNameLabel(This, pszLabel)
 #define IFileOpenDialog_GetResult(This, ppsi) (This)->lpVtbl->GetResult(This, ppsi)
 #define IFileOpenDialog_AddPlace(This, psi, fdap) (This)->lpVtbl->AddPlace(This, psi, fdap)
 #define IFileOpenDialog_SetDefaultExtension(This, pszDefaultExtension) (This)->lpVtbl->SetDefaultExtension(This, pszDefaultExtension)
 #define IFileOpenDialog_Close(This, hr) (This)->lpVtbl->Close(This, hr)
 #define IFileOpenDialog_SetClientGuid(This, guid) (This)->lpVtbl->SetClientGuid(This, guid)
 #define IFileOpenDialog_ClearClientData(This) (This)->lpVtbl->ClearClientData(This)
 #define IFileOpenDialog_SetFilter(This, pFilter) (This)->lpVtbl->SetFilter(This, pFilter)
 #define IFileOpenDialog_GetResults(This, ppenum) (This)->lpVtbl->GetResults(This, ppenum)
 #define IFileOpenDialog_GetSelectedItems(This, ppsai) (This)->lpVtbl->GetSelectedItems(This, ppsai)
 
 declare function IFileOpenDialog_GetResults_Proxy(byval This as IFileOpenDialog ptr, byval ppenum as IShellItemArray ptr ptr) as HRESULT
 declare sub IFileOpenDialog_GetResults_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 declare function IFileOpenDialog_GetSelectedItems_Proxy(byval This as IFileOpenDialog ptr, byval ppsai as IShellItemArray ptr ptr) as HRESULT
 declare sub IFileOpenDialog_GetSelectedItems_Stub(byval This as IRpcStubBuffer ptr, byval pRpcChannelBuffer as IRpcChannelBuffer ptr, byval pRpcMessage as PRPC_MESSAGE, byval pdwStubPhase as DWORD ptr)
 
 type CDCONTROLSTATEF as long
 enum
    CDCS_INACTIVE = &h0
    CDCS_ENABLED = &h1
    CDCS_VISIBLE = &h2
    CDCS_ENABLEDVISIBLE = &h3
 end enum
#endif
