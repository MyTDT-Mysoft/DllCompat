#pragma once

#include "windows.bi"
#include "win\winbase.bi"
#include "win\objbase.bi"

extern "C"
  declare sub chelp_GUID2strA(buf as LPSTR, ri as GUID ptr)
  declare sub chelp_GUID2strW(buf as LPWSTR, ri as GUID ptr)
  declare function chelp_cmpMultGUID(p1 as GUID ptr, pp2 as GUID ptr ptr, count as long) as BOOL
  declare function chelp_unregisterCOM(ownershipMark as LPCSTR, pGuid as REFCLSID) as BOOL
  declare function chelp_registerCOM(ownershipMark as LPCSTR, pGuid as REFCLSID, pszDllPath as LPCSTR, isExpandable as BOOL, pszThreadModel as LPCSTR, pszDescription as LPCSTR) as BOOL
end extern

#define THREADMODEL_APARTMENT "Apartment"
#define THREADMODEL_FREE      "Free"
#define THREADMODEL_BOTH      "Both"
#define THREADMODEL_NEUTRAL   "Neutral"

type CbaseCB as function(self as any ptr, rclsid as REFCLSID, extraData as any ptr) as HRESULT

type COMDesc
  rclsid as REFCLSID
  riidArr as REFIID ptr
  iidCount as long
  rvtbl as any ptr
  objSize as DWORD
  cbConstruct as CbaseCB
  cbDestruct as CbaseCB
  
  ownMark  as const zstring ptr
  thModel  as const zstring ptr
  descript as const zstring ptr
end type

type COMGenerObj
  lpVtbl as const IUnknownVtbl ptr
  conf as const COMDesc ptr
  isFactory as BOOL
  count as long
end type

extern "C"
  declare sub cbase_init(hinst as HINSTANCE, cobjArr as const COMDesc ptr ptr, nrObjects as long)
  declare function cbase_createInstance(conf as const COMDesc ptr, ppv as any ptr ptr, isFactory as BOOL) as HRESULT
end extern

extern "windows"
  declare function cbase_UnkQueryInterface(self as COMGenerObj ptr, riid as REFIID, ppv as any ptr ptr) as HRESULT
  declare function cbase_UnkAddRef(self as COMGenerObj ptr) as ULONG
  declare function cbase_UnkRelease(self as COMGenerObj ptr) as ULONG
  
  declare function cbase_DllGetClassObject(rclsid as REFCLSID, riid as REFIID, ppv as any ptr ptr) as HRESULT
  declare function cbase_DllCanUnloadNow() as HRESULT
  declare function cbase_DllUnregisterServer() as HRESULT
  declare function cbase_DllRegisterServer() as HRESULT
end extern