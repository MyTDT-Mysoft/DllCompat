#define fbc -dll -Wl "ole3x.dll.def" -x ..\..\..\bin\dll\ole3x.dll -i ..\..\

#include "windows.bi"
#include "win\ole2.bi"
#include "shared\helper.bas"

sub checkCLSID(pclsid as REFCLSID, hr as HRESULT)
  dim guidStr as wstring*40
  if hr = REGDB_E_CLASSNOTREG then
    StringFromGUID2(pclsid, @guidStr, sizeof(guidStr)/2)
    DEBUG_MsgTrace("COM fail: Class not registered %ls", @guidStr)
  elseif hr = REGDB_E_IIDNOTREG then
    StringFromGUID2(pclsid, @guidStr, sizeof(guidStr)/2)
    DEBUG_MsgTrace("COM fail: Interface not registered %ls", @guidStr)
  end if
end sub

extern "windows-ms"
  UndefAllParams()
  #define P1 rclsid       as REFCLSID
  #define P2 pUnkOuter    as LPUNKNOWN
  #define P3 dwClsContext as DWORD
  #define P4 riid         as REFIID
  #define P5 ppv          as LPVOID ptr
  function _CoCreateInstance alias "CoCreateInstance"(P1, P2, P3, P4, P5) as HRESULT export
    dim hr as HRESULT = CoCreateInstance(rclsid, pUnkOuter, dwClsContext, riid, ppv)
    checkCLSID(rclsid, hr)
    return hr
  end function
  
  UndefAllParams()
  #define P1 Clsid       as REFCLSID
  #define P2 punkOuter   as IUnknown ptr
  #define P3 dwClsCtx    as DWORD
  #define P4 pServerInfo as COSERVERINFO ptr
  #define P5 dwCount     as DWORD
  #define P6 pResults    as MULTI_QI ptr
  function _CoCreateInstanceEx alias "CoCreateInstanceEx"(P1, P2, P3, P4, P5, P6) as HRESULT export
    dim hr as HRESULT = CoCreateInstanceEx(Clsid, punkOuter, dwClsCtx, pServerInfo, dwCount, pResults)
    checkCLSID(Clsid, hr)
    return hr
  end function
  
  UndefAllParams()
  #define P1 rclsid       as REFCLSID
  #define P2 dwClsContext as DWORD
  #define P3 pvReserved   as LPVOID
  #define P4 riid         as REFIID
  #define P5 ppv          as LPVOID ptr
  function _CoGetClassObject alias "CoGetClassObject"(P1, P2, P3, P4, P5) as HRESULT export
    dim hr as HRESULT = CoGetClassObject(rclsid, dwClsContext, pvReserved, riid, ppv)
    checkCLSID(rclsid, hr)
    return hr
  end function
end extern

#include "shared\defaultmain.bas"