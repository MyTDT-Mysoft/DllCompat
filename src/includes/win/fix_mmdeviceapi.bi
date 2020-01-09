#include "windows.bi"
#include "win\propsys.bi"

type EDataFlow as long
enum
    eRender = 0
    eCapture = 1
    eAll = 2
    EDataFlow_enum_count = 3
end enum

type ERole as long
enum _ERole
    eConsole = 0
    eMultimedia = 1
    eCommunications = 2
    ERole_enum_count = 3
end enum

extern "windows-ms"
  'IMMDevice
  type IMMDevice as IMMDevice_
  type IMMDeviceVtbl
    QueryInterface as function(self as IMMDevice ptr, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
    AddRef as function(self as IMMDevice ptr) as ULONG
    Release as function(self as IMMDevice ptr) as ULONG
    
    Activate as function(self as IMMDevice ptr, iid as REFIID, dwClsCtx as DWORD, pActivationParams as PROPVARIANT ptr, ppv as any ptr ptr) as HRESULT
    OpenPropertyStore as function(self as IMMDevice, stgmAccess as DWORD, ppProperties as IPropertyStore ptr ptr) as HRESULT
    GetId as function(self as IMMDevice, ppstrId as LPWSTR ptr) as HRESULT
    GetState as function(self as IMMDevice, pdwState as DWORD ptr) as HRESULT
  end type
  type IMMDevice_
    lpVtbl as IMMDeviceVtbl ptr
  end type
  
  #define IMMDevice_QueryInterface(self, riid, ppv) (self)->lpVtbl-> QueryInterface(self, riid, ppv)
  #define IMMDevice_AddRef(self) (self)->lpVtbl->AddRef(self)
  #define IMMDevice_Release(self) (self)->lpVtbl->Release(self)
  #define IMMDevice_Activate(self, iid, dwClsCtx, pActivationParams, ppv) (self)->lpVtbl->Activate(self, iid, dwClsCtx, pActivationParams, ppv)
  #define IMMDevice_OpenPropertyStore(self, stgmAccess, ppProperties) (self)->lpVtbl->OpenPropertyStore(self, stgmAccess, ppProperties)
  #define IMMDevice_GetId(self, ppstrId) (self)->lpVtbl->GetId(self, ppstrId)
  #define IMMDevice_GetState(self, pdwState) (self)->lpVtbl->GetState(self, pdwState)
  
  
  'IMMDeviceCollection
  type IMMDeviceCollection as IMMDeviceCollection_
  type IMMDeviceCollectionVtbl
    QueryInterface as function(self as IMMDeviceCollection ptr, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
    AddRef as function(self as IMMDeviceCollection ptr) as ULONG
    Release as function(self as IMMDeviceCollection ptr) as ULONG
    
    GetCount as function(self as IMMDeviceCollection ptr, pcDevices as UINT ptr) as HRESULT
    Item as function(self as IMMDeviceCollection ptr, nDevice as UINT, ppDevice as IMMDevice ptr ptr) as HRESULT
  end type
  type IMMDeviceCollection_
    lpVtbl as IMMDeviceCollectionVtbl ptr
  end type
  
  #define IMMDeviceCollection_QueryInterface(self, riid, ppv) (self)->lpVtbl->QueryInterface(self, riid, ppv)
  #define IMMDeviceCollection_AddRef(self) (self)->lpVtbl->AddRef(self)
  #define IMMDeviceCollection_Release(self) (self)->lpVtbl->Release(self)
  #define IMMDeviceCollection_GetCount(self, pcDevices) (self)->lpVtbl->GetCount(self, pcDevices)
  #define IMMDeviceCollection_Item(self, nDevice, ppDevice) (self)->lpVtbl->Item(self, nDevice, ppDevice)
  
  
  'IMMNotificationClient
  type IMMNotificationClient as IMMNotificationClient_
  type IMMNotificationClientVtbl
    QueryInterface as function(self as IMMNotificationClient ptr, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
    AddRef as function(self as IMMNotificationClient ptr) as ULONG
    Release as function(self as IMMNotificationClient ptr) as ULONG
    
    OnDeviceStateChanged as function(self as IMMNotificationClient, pwstrDeviceId as LPCWSTR, dwNewState as DWORD) as HRESULT
    OnDeviceAdded as function(self as IMMNotificationClient, pwstrDeviceId as LPCWSTR) as HRESULT
    OnDeviceRemoved as function(self as IMMNotificationClient, pwstrDeviceId as LPCWSTR) as HRESULT
    OnDefaultDeviceChanged as function(self as IMMNotificationClient, flow as EDataFlow, role as ERole, pwstrDeviceId as LPCWSTR) as HRESULT
    OnPropertyValueChanged as function(self as IMMNotificationClient, pwstrDeviceId as LPCWSTR, key as const PROPERTYKEY) as HRESULT
  end type
  type IMMNotificationClient_
    lpVtbl as IMMNotificationClientVtbl ptr
  end type
  
  #define IMMNotificationClient_QueryInterface(self, riid, ppv) (self)->lpVtbl-> QueryInterface(self, riid, ppv)
  #define IMMNotificationClient_AddRef(self) (self)->lpVtbl->AddRef(self)
  #define IMMNotificationClient_Release(self) (self)->lpVtbl->Release(self)
  #define IMMNotificationClient_OnDeviceStateChanged(self, pwstrDeviceId, dwNewState) (self)->lpVtbl->OnDeviceStateChanged(self, pwstrDeviceId, dwNewState)
  #define IMMNotificationClient_OnDeviceAdded(self, pwstrDeviceId) (self)->lpVtbl->OnDeviceAdded(self, pwstrDeviceId)
  #define IMMNotificationClient_OnDeviceRemoved(self, pwstrDeviceId) (self)->lpVtbl->OnDeviceRemoved(self, pwstrDeviceId)
  #define IMMNotificationClient_OnDefaultDeviceChanged(self, flow, role, pwstrDeviceId) (self)->lpVtbl->OnDefaultDeviceChanged(self, flow, role, pwstrDeviceId)
  #define IMMNotificationClient_OnPropertyValueChanged(self, pwstrDeviceId, key) (self)->lpVtbl->OnPropertyValueChanged(self, pwstrDeviceId, key)
  
  
  'IMMDeviceEnumerator
  type IMMDeviceEnumerator as IMMDeviceEnumerator_
  type IMMDeviceEnumeratorVtbl
    QueryInterface as function(self as IMMDeviceEnumerator ptr, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
    AddRef as function(self as IMMDeviceEnumerator ptr) as ULONG
    Release as function(self as IMMDeviceEnumerator ptr) as ULONG
    
    EnumAudioEndpoints as function(self as IMMDeviceEnumerator, dataFlow as EDataFlow, dwStateMask as DWORD, ppDevices as IMMDeviceCollection ptr ptr) as HRESULT
    GetDefaultAudioEndpoint as function(self as IMMDeviceEnumerator, dataFlow as EDataFlow, role as ERole, ppEndpoint as IMMDevice ptr ptr) as HRESULT
    GetDevice as function(self as IMMDeviceEnumerator, pwstrId as LPCWSTR, ppDevice as IMMDevice ptr ptr) as HRESULT
    RegisterEndpointNotificationCallback as function(self as IMMDeviceEnumerator, pClient as IMMNotificationClient ptr) as HRESULT
    UnregisterEndpointNotificationCallback as function(self as IMMDeviceEnumerator, pClient as IMMNotificationClient ptr) as HRESULT
  end type
  type IMMDeviceEnumerator_
    lpVtbl as IMMDeviceEnumeratorVtbl ptr
  end type
  
  #define IMMDeviceEnumerator_QueryInterface(self, riid, ppv) (self)->lpVtbl-> QueryInterface(self, riid, ppv)
  #define IMMDeviceEnumerator_AddRef(self) (self)->lpVtbl->AddRef(self)
  #define IMMDeviceEnumerator_Release(self) (self)->lpVtbl->Release(self)
  #define IMMDeviceEnumerator_EnumAudioEndpoints(self, dataFlow, dwStateMask, ppDevices) (self)->lpVtbl->EnumAudioEndpoints(self, dataFlow, dwStateMask, ppDevices)
  #define IMMDeviceEnumerator_GetDefaultAudioEndpoint(self, dataFlow, role, ppEndpoint) (self)->lpVtbl->GetDefaultAudioEndpoint(self, dataFlow, role, ppEndpoint)
  #define IMMDeviceEnumerator_GetDevice(self, pwstrId, ppDevice) (self)->lpVtbl->GetDevice(self, pwstrId, ppDevice)
  #define IMMDeviceEnumerator_RegisterEndpointNotificationCallback(self, pClient) (self)->lpVtbl->RegisterEndpointNotificationCallback(self, pClient)
  #define IMMDeviceEnumerator_UnregisterEndpointNotificationCallback(self, pClient) (self)->lpVtbl->UnregisterEndpointNotificationCallback(self, pClient)
end extern