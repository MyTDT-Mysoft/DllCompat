#include "windows.bi"


#include "shared\helper.bas"
#include "includes\lib\comhelper.h"

extern "windows-ms"
  declare function fnIMMDevice_Activate(_self as IMMDevice ptr, iid as REFIID, dwClsCtx as DWORD, pActivationParams as PROPVARIANT ptr, ppv as any ptr ptr) as HRESULT
  declare function fnIMMDevice_OpenPropertyStore(_self as IMMDevice, stgmAccess as DWORD, ppProperties as IPropertyStore ptr ptr) as HRESULT
  declare function fnIMMDevice_GetId(_self as IMMDevice, ppstrId as LPWSTR ptr) as HRESULT
  declare function fnIMMDevice_GetState(_self as IMMDevice, pdwState as DWORD ptr) as HRESULT
  
  
  declare function fnMMDeviceEnumerator_EnumAudioEndpoints(_self as IMMDeviceEnumerator, dataFlow as EDataFlow, dwStateMask as DWORD, ppDevices as IMMDeviceCollection ptr ptr) as HRESULT
  declare function fnMMDeviceEnumerator_GetDefaultAudioEndpoint(_self as IMMDeviceEnumerator, dataFlow as EDataFlow, role as ERole, ppEndpoint as IMMDevice ptr ptr) as HRESULT
  declare function fnMMDeviceEnumerator_GetDevice(_self as IMMDeviceEnumerator, pwstrId as LPCWSTR, ppDevice as IMMDevice ptr ptr) as HRESULT
  declare function fnMMDeviceEnumerator_RegisterEndpointNotificationCallback(_self as IMMDeviceEnumerator, pClient as IMMNotificationClient ptr) as HRESULT
  declare function fnMMDeviceEnumerator_UnregisterEndpointNotificationCallback(_self as IMMDeviceEnumerator, pClient as IMMNotificationClient ptr) as HRESULT
end extern

extern "C"
  declare function MMDeviceEnumeratorConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
  declare function MMDeviceEnumeratorDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
end extern

type IMMDeviceEnumeratorImpl
  lpVtbl as IMMDeviceEnumeratorVtbl ptr
  
  
end type