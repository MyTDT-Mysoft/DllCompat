#pragma once

#include "windows.bi"
#include "crt.bi"
#include "win\ole2.bi"
#include "win\objbase.bi"
#include "win\shlobj.bi"
#include "shared\helper.bas"

#define DLLC_COM_MARK "DLLCompat"
#define AsGuid(_N,_l,_w1,_w2,_bw,_ll) as const GUID _N = type( (&h##_l), (&h##_w1), (&h##_w2), { ((&h##_bw) shr 8) and &hFF, (&h##_bw) and &hFF,  (((&h##_ll) shr 40) and &hFF),  (((&h##_ll) shr 32) and &hFF),  (((&h##_ll) shr 24) and &hFF),  (((&h##_ll) shr 16) and &hFF),  (((&h##_ll) shr 8) and &hFF),(((&h##_ll) shr 0) and &hFF) } )

sub print_guid(pGuid as const GUID ptr, szGName as zstring ptr)
  dim as HRESULT hr
  dim as IClassFactory ptr pClassFac
  dim as wstring*40 swGuid
  
  StringFromGUID2(pGuid, @swGuid, sizeof(swGuid)/2)
  printf(!"%s %ls\n", szGName, swGuid)
end sub

sub CLSID2strA(buf as LPSTR, ri as REFCLSID)
	wsprintfA(buf, "{%08lX-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}", _
		ri->Data1, ri->Data2, ri->Data3, ri->Data4(0), _
		ri->Data4(1), ri->Data4(2), ri->Data4(3), _
		ri->Data4(4), ri->Data4(5), ri->Data4(6), _
		ri->Data4(7))
end sub

sub CLSID2strW(buf as LPWSTR, ri as REFCLSID)
	wsprintfW(buf, "{%08lX-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}", _
		ri->Data1, ri->Data2, ri->Data3, ri->Data4(0), _
		ri->Data4(1), ri->Data4(2), ri->Data4(3), _
		ri->Data4(4), ri->Data4(5), ri->Data4(6), _
		ri->Data4(7))
end sub

function unregisterCOM(ownershipMark as LPCSTR, pGuid as REFCLSID) as BOOL
  dim as zstring*40 szGuidPath = any
  dim as HKEY kRoot, kClsid
  
  CLSID2strA(@szGuidPath, pGuid)
  if RegOpenKeyExA(HKEY_LOCAL_MACHINE, "Software\Classes\CLSID\", 0, KEY_ALL_ACCESS, @kRoot)=ERROR_SUCCESS then
    if RegOpenKeyExA(kRoot, szGuidPath, 0, KEY_ALL_ACCESS, @kClsid)=ERROR_SUCCESS then
      if RegQueryValueExA(kClsid, ownershipMark, 0, NULL, NULL, NULL)<>ERROR_SUCCESS then goto FAIL
      RegDeleteKeyA(kClsid, "InprocServer32")
      RegCloseKey(kClsid)
    end if
    RegDeleteKeyA(kRoot, szGuidPath)
    RegCloseKey(kRoot)
  end if
  return TRUE
  
  FAIL:
    if(kClsid) then RegCloseKey(kClsid)
    if(kRoot)  then RegCloseKey(kRoot)
    return FALSE
end function

function registerCOM(ownershipMark as LPCSTR, pGuid as REFCLSID, pszDllPath as LPCSTR, pszThreadModel as LPCSTR, pszDescription as LPCSTR) as BOOL
  dim as zstring*64 szGuidPath = "Software\Classes\CLSID\"
  dim as HKEY kClsid, kInproc
  dim as DWORD disp
  
  CLSID2strA(@szGuidPath+23, pGuid)
  'does CLSID already exist?
  if RegOpenKeyExA(HKEY_LOCAL_MACHINE, @szGuidPath, 0, KEY_READ, @kClsid)=ERROR_SUCCESS then
    'if ownership stamp is not present, back away
    if RegQueryValueExA(kClsid, ownershipMark, 0, NULL, NULL, NULL)<>ERROR_SUCCESS then goto FAIL
    RegCloseKey(kClsid)
  end if
  
  'create CLSID key
  if RegCreateKeyExA(HKEY_LOCAL_MACHINE, @szGuidPath, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, @kClsid, @disp)=ERROR_SUCCESS then
    'write object description
    if RegSetValueExA(kClsid, NULL, 0, REG_SZ, pszDescription, strlen(pszDescription))<>ERROR_SUCCESS then goto FAIL
    'write our ownership stamp
    if RegSetValueExA(kClsid, ownershipMark, 0, REG_NONE, NULL, 0)<>ERROR_SUCCESS then goto FAIL
    'make inprocserver key
    if RegCreateKeyExA(kClsid, "InprocServer32", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, @kInproc, @disp)=ERROR_SUCCESS then
      'write path to DLL as expandable string
      if RegSetValueExA(kInproc, NULL, 0, REG_EXPAND_SZ, pszDllPath, strlen(pszDllPath))<>ERROR_SUCCESS then goto FAIL
      'write threading model
      if RegSetValueExA(kInproc, "ThreadingModel", 0, REG_SZ, pszThreadModel, strlen(pszThreadModel))<>ERROR_SUCCESS then goto FAIL
      RegCloseKey(kInproc)
    end if
    RegCloseKey(kClsid)
  end if
  return TRUE
  
  FAIL:
    if(kInproc) then RegCloseKey(kInproc)
    if(kClsid)  then RegCloseKey(kClsid)
    unregisterCOM(ownershipMark, pGuid)
    return FALSE
end function