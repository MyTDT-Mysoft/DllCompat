static shared vt_ShellItemArray as IShellItemArrayVtbl = type( _
  @cbase_UnkQueryInterface, _
  @cbase_UnkAddRef, _
  @cbase_UnkRelease, _
  _
  @fnIShellItemArray_BindToHandler, _
  @fnIShellItemArray_GetPropertyStore, _
  @fnIShellItemArray_GetPropertyDescriptionList, _
  @fnIShellItemArray_GetAttributes, _
  @fnIShellItemArray_GetCount, _
  @fnIShellItemArray_GetItemAt, _
  @fnIShellItemArray_EnumItems _
)

static shared iidShellItemArray(...) as REFIID = { @IID_IShellItemArray, @IID_IUnknown }
static shared confShellItemArray as COMDesc = type( _
  NULL, @iidShellItemArray(0), COUNTOF(iidShellItemArray), _
  @vt_ShellItemArray, sizeof(IShellItemArrayImpl), _
  @IShellItemArrayDestructor, @IShellItemArrayConstructor, _
  NULL, NULL, NULL _
)

#define SELF cast(IShellItemArrayImpl ptr, _self)
extern "C"
  function IShellItemArrayDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    for i as int = 0 to SELF->itemCount-1
      dim item as IShellItem ptr = SELF->ptrArr[i]
      
      if item<>NULL then IShellItem_Release(item)
    next
    HeapFree(GetProcessHeap(), 0, SELF->ptrArr)
    return S_OK
  end function
  
  function IShellItemArrayConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
    return S_OK
  end function
end extern

function create_ShellItemArray(itemCount as UINT) as IShellItemArrayImpl ptr
  dim psia as IShellItemArrayImpl ptr
  dim hr as HRESULT
  
  if SUCCEEDED(cbase_createInstance(@confShellItemArray, @psia, FALSE)) then
    psia->ptrArr = HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(any ptr)*itemCount)
    if psia->ptrArr=NULL then 
      IShellItemArray_Release(psia)
      return E_OUTOFMEMORY
    end if
    psia->itemCount = itemCount
    
    return psia
  end if
  
  return NULL
end function






extern "windows-ms"
  function fnIShellItemArray_BindToHandler(_self as IShellItemArray ptr, pbc as IBindCtx ptr, bhid as const GUID const ptr, riid as const IID const ptr, ppvOut as any ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIShellItemArray_GetPropertyStore(_self as IShellItemArray ptr, flags as GETPROPERTYSTOREFLAGS, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIShellItemArray_GetPropertyDescriptionList(_self as IShellItemArray ptr, keyType as const PROPERTYKEY const ptr, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIShellItemArray_GetAttributes(_self as IShellItemArray ptr, AttribFlags as SIATTRIBFLAGS, sfgaoMask as SFGAOF, psfgaoAttribs as SFGAOF ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
  
  function fnIShellItemArray_GetCount(_self as IShellItemArray ptr, pdwNumItems as DWORD ptr) as HRESULT
    if pdwNumItems=NULL then return E_INVALIDARG
    *pdwNumItems = SELF->itemCount
    
    return S_OK
  end function
  
  function fnIShellItemArray_GetItemAt(_self as IShellItemArray ptr, dwIndex as DWORD, ppsi as IShellItem ptr ptr) as HRESULT
    dim psi as IShellItem ptr
    
    if ppsi=NULL then return E_INVALIDARG
    *ppsi = NULL
    if dwIndex >= SELF->itemCount then return E_FAIL
    
    psi = SELF->ptrArr[dwIndex]
    IShellItem_AddRef(psi)
    *ppsi = psi
    
    return S_OK
  end function
  
  function fnIShellItemArray_EnumItems(_self as IShellItemArray ptr, ppenumShellItems as IEnumShellItems ptr ptr) as HRESULT
    DEBUG_MsgNotImpl()
    return E_NOTIMPL
  end function
end extern
#undef SELF