extern "windows-ms"
  declare function fnIShellItemArray_QueryInterface(_self as IShellItemArray ptr, riid as const IID const ptr, ppvObject as any ptr ptr) as HRESULT
  declare function fnIShellItemArray_AddRef(_self as IShellItemArray ptr) as ULONG
  declare function fnIShellItemArray_Release(_self as IShellItemArray ptr) as ULONG
  declare function fnIShellItemArray_BindToHandler(_self as IShellItemArray ptr, pbc as IBindCtx ptr, bhid as const GUID const ptr, riid as const IID const ptr, ppvOut as any ptr ptr) as HRESULT
  declare function fnIShellItemArray_GetPropertyStore(_self as IShellItemArray ptr, flags as GETPROPERTYSTOREFLAGS, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
  declare function fnIShellItemArray_GetPropertyDescriptionList(_self as IShellItemArray ptr, keyType as const PROPERTYKEY const ptr, riid as const IID const ptr, ppv as any ptr ptr) as HRESULT
  declare function fnIShellItemArray_GetAttributes(_self as IShellItemArray ptr, AttribFlags as SIATTRIBFLAGS, sfgaoMask as SFGAOF, psfgaoAttribs as SFGAOF ptr) as HRESULT
  declare function fnIShellItemArray_GetCount(_self as IShellItemArray ptr, pdwNumItems as DWORD ptr) as HRESULT
  declare function fnIShellItemArray_GetItemAt(_self as IShellItemArray ptr, dwIndex as DWORD, ppsi as IShellItem ptr ptr) as HRESULT
  declare function fnIShellItemArray_EnumItems(_self as IShellItemArray ptr, ppenumShellItems as IEnumShellItems ptr ptr) as HRESULT
end extern

extern "C"
  declare function IShellItemArrayDestructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
  declare function IShellItemArrayConstructor(_self as any ptr, rclsid as REFCLSID) as HRESULT
end extern

type IShellItemArrayImpl
  union
    baseObj as COMGenerObj
    lpVtbl  as const IShellItemArrayVtbl ptr
  end union
  itemCount as integer
  ptrArr as IShellItemArray ptr ptr
end type