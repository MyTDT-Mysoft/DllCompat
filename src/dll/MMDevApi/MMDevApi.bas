#include "windows.bi"


#include "shared\helper.bas"
#include "includes\lib\comhelper.h"
#include "includes\win\fix_mmdeviceapi.bi"

#include "MMDevApi.bi"

static shared AsGuid(CLSID_MMDeviceEnumerator, BCDE0395,E52F,467C,8E3D,C4579291692E)
static shared AsGuid(IID_IMMDevice,            D666063F,1587,4E43,81F1,B948E807363F)
static shared AsGuid(IID_IMMDeviceCollection,  0BD7A1BE,7A1A,44DB,8397,CC5392387B5E)
static shared AsGuid(IID_IMMDeviceEnumerator,  A95664D2,9614,4F35,A746,DE8DB63617E6)
'static shared AsGuid(CLSID_MMEndpointManager,  06CCA63E,9941,441B,B004,39F999ADA412) '"both"

'configuration
static shared vt_MMDeviceEnumerator as IMMDeviceEnumeratorVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @fnMMDeviceEnumerator_EnumAudioEndpoints, _
  @fnMMDeviceEnumerator_GetDefaultAudioEndpoint, _
  @fnMMDeviceEnumerator_GetDevice, _
  @fnMMDeviceEnumerator_RegisterEndpointNotificationCallback, _
  @fnMMDeviceEnumerator_UnregisterEndpointNotificationCallback _
)

'This appears in win7 registry as exported by MMDevApi.dll, but no info on this API
'static shared vt_MMEndpointManager as IMMEndpointManagerVtbl = type( _
'  @cbase_UnkQueryInterface, _
'  @cbase_UnkAddRef, _
'  @cbase_UnkRelease, _
'  _
'  _ '???????????????????????
')

static shared iidMMDeviceEnumerator(...) as REFIID = { @IID_IMMDeviceEnumerator, @IID_IUnknown }
static shared confMMDeviceEnumerator as COMDesc = type( _
  @CLSID_MMDeviceEnumerator, @iidMMDeviceEnumerator(0), COUNTOF(iidMMDeviceEnumerator), _
  @vt_MMDeviceEnumerator, sizeof(IMMDeviceEnumeratorImpl), _
  @MMDeviceEnumeratorConstructor, @MMDeviceEnumeratorDestructor, _
  @DLLC_COM_MARK, @THREADMODEL_BOTH, @"MMDeviceEnumerator class(DLLCompat)" _
)

static shared serverConfig(...) as COMDesc ptr = {@confMMDeviceEnumerator}

'-------------------------------------------------------------------------------------------
#define SELF cast(IMMDeviceImpl ptr, _self)
extern "windows-ms"
  function fnIMMDevice_Activate(_self as IMMDevice ptr, iid as REFIID, dwClsCtx as DWORD, pActivationParams as PROPVARIANT ptr, ppv as any ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIMMDevice_OpenPropertyStore(_self as IMMDevice, stgmAccess as DWORD, ppProperties as IPropertyStore ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIMMDevice_GetId(_self as IMMDevice, ppstrId as LPWSTR ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIMMDevice_GetState(_self as IMMDevice, pdwState as DWORD ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern

extern "C"
end extern
#undef SELF



#define SELF cast(IMMDeviceEnumeratorImpl ptr, _self)
extern "windows-ms"
  function fnMMDeviceEnumerator_EnumAudioEndpoints(_self as IMMDeviceEnumerator, dataFlow as EDataFlow, dwStateMask as DWORD, ppDevices as IMMDeviceCollection ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnMMDeviceEnumerator_GetDefaultAudioEndpoint(_self as IMMDeviceEnumerator, dataFlow as EDataFlow, role as ERole, ppEndpoint as IMMDevice ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnMMDeviceEnumerator_GetDevice(_self as IMMDeviceEnumerator, pwstrId as LPCWSTR, ppDevice as IMMDevice ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnMMDeviceEnumerator_RegisterEndpointNotificationCallback(_self as IMMDeviceEnumerator, pClient as IMMNotificationClient ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnMMDeviceEnumerator_UnregisterEndpointNotificationCallback(_self as IMMDeviceEnumerator, pClient as IMMNotificationClient ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern



extern "C"
  function MMDeviceEnumeratorConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    return S_OK
  end function
  
  function MMDeviceEnumeratorDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    return S_OK
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
        cbase_init(handle, @serverConfig(0), 1)
      case DLL_PROCESS_DETACH
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