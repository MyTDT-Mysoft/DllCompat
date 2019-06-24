#define fbc -dll -Wl "comdlg3x.dll.def" -x ..\..\bin\dll\comdlg3x.dll -i ..\..\

#include "windows.bi"
#include "win\objbase.bi"
#include "win\shlobj.bi"
#include "includes\win\float.bi"
#include "includes\win\shlobj_fix.bi"
#include "shared\helper.bas"
#include "shared\COMhelper.bas"

static shared as DWORD OutstandingObjects
static shared as DWORD LockCount

static shared AsGuid(CLSID_IExample, 6899A2A3,405B,44d4,A415,E08CEE2A97CB)
static shared AsGuid(IID_IExample, 74666CAC,C2B1,4fa8,A049,97F3214802F0)
type IExampleVtbl as IExampleVtbl_
type IExample
  lpVtbl as IExampleVtbl ptr
end type
type IExampleVtbl_
  QueryInterface as function(this as IExample ptr, vTableGuid as REFIID, ppv as LPVOID ptr) as HRESULT
  AddRef as function(this as IExample ptr) as ULONG
  Release as function(this as IExample ptr) as ULONG
  'other methods
  ExampleFunc as function(this as IExample ptr) as DWORD
end type


type MyRealIExample
  lpVtbl as IExampleVtbl
  'private
  count as DWORD
end type

extern "windows"
function QueryInterface(this as IExample ptr, vTableGuid as REFIID, ppv as LPVOID ptr) as HRESULT
  if (IsEqualIID(vTableGuid, @IID_IUnknown)=FALSE and IsEqualIID(vTableGuid, @IID_IExample)=FALSE) then
    *ppv = NULL
    return E_NOINTERFACE
  end if
  
  *ppv = this
  this->lpVtbl->AddRef(this)
  return NOERROR
end function

  function AddRef(this as IExample ptr) as ULONG
    dim count as DWORD ptr = @cast(MyRealIExample ptr, this)->count
    *count = *count+1
    return *count
  end function
  
  function Release(this as IExample ptr) as ULONG
    dim count as DWORD ptr = @cast(MyRealIExample ptr, this)->count
    *count=*count-1
    if *count=0 then
      GlobalFree(this)
      InterlockedDecrement(@OutstandingObjects)
      return(0)
    end if
    return *count
  end function
  
  'own functions
  function ExampleFunc(this as IExample ptr) as DWORD
    return 42
  end function
  
  static shared as IExampleVtbl IExample_Vtbl = type( _
    @QueryInterface, @AddRef, @Release, _
    @ExampleFunc _
  )
end extern


extern "windows"
  static shared as IClassFactory MyIClassFactoryObj
  
  function classAddRef(this as IClassFactory ptr) as ULONG
    InterlockedIncrement(@OutstandingObjects)
    return 1
  end function
  
  function classQueryInterface(this as IClassFactory ptr, factoryGuid as REFIID, ppv as LPVOID ptr) as HRESULT
    'IClassFactory masquerades as an IUnknown
    if (IsEqualIID(factoryGuid, @IID_IUnknown) or IsEqualIID(factoryGuid, @IID_IClassFactory)) then
        this->lpVtbl->AddRef(this)
        *ppv = this
        return NOERROR
    end if
    
    *ppv = NULL
    return E_NOINTERFACE
  end function
  
  function classRelease(this as IClassFactory ptr) as ULONG
    return(InterlockedDecrement(@OutstandingObjects))
  end function
  
  function classCreateInstance(this as IClassFactory ptr, punkOuter as IUnknown ptr, vTableGuid as REFIID, objHandle as LPVOID ptr) as HRESULT
    dim hr as HRESULT
    dim thisobj as IExample ptr
    
    *objHandle = 0
    
    'aggregation not supported
    if punkOuter then
      hr = CLASS_E_NOAGGREGATION
    else
        thisobj = cast(IExample ptr, GlobalAlloc(GMEM_FIXED, sizeof(MyRealIExample)))
      if thisobj = null then
        hr = E_OUTOFMEMORY
      else
        thisobj->lpVtbl = cast(IExampleVtbl ptr, @IExample_Vtbl)
        cast(MyRealIExample ptr, thisobj)->count = 1
        hr = IExample_Vtbl.QueryInterface(thisobj, vTableGuid, objHandle)
        IExample_Vtbl.Release(thisobj)
        if hr = NULL then InterlockedIncrement(@OutstandingObjects)
      end if
    end if
    
    return(hr)
  end function
  
  function classLockServer(this as IClassFactory ptr, flock as BOOL) as HRESULT
    if flock then 
      InterlockedIncrement(@LockCount)
    else
      InterlockedDecrement(@LockCount)
    end if
    return NOERROR
  end function
  
  static shared as IClassFactoryVtbl IClassFactory_Vtbl = type( _
    @classQueryInterface, @classAddRef, @classRelease, _
    @classCreateInstance, @classLockServer _
  )
end extern





extern "windows-ms"
  'combaseapi.bi defines the first two as extern "windows", which we don't want
  #undef DllGetClassObject
  #undef DllCanUnloadNow
  #undef DllRegisterServer
  #undef DllUnregisterServer
  
  UndefAllParams()
  #define P1 rclsid as REFCLSID
  #define P2 riid   as REFIID
  #define P3 ppv    as LPVOID ptr
  function DllGetClassObject(P1, P2, P3) as HRESULT export
    dim hr as HRESULT
    if IsEqualCLSID(rclsid, @CLSID_IExample) then
      hr = classQueryInterface(@MyIClassFactoryObj, riid, ppv)
    else
      *ppv = NULL
      hr = CLASS_E_CLASSNOTAVAILABLE
  end if
  return hr
  end function
  
  UndefAllParams()
  function DllCanUnloadNow() as HRESULT export
    return iif((OutstandingObjects or LockCount), S_FALSE, S_OK)
  end function
  
  UndefAllParams()
  function DllRegisterServer() as HRESULT export
    if WinverCompare(VER_LESS, 6,0,0) then
      'uninstall here
      return S_OK
    else
      return E_FAIL
    end if
  end function
  
  UndefAllParams()
  function DllUnregisterServer() as HRESULT export
    if WinverCompare(VER_LESS, 6,0,0) then
      'install here
      return S_OK
    else
      return E_FAIL
    end if
  end function
end extern

extern "windows-ms"
  function DLLMAIN(handle as HINSTANCE, uReason as uinteger, Reserved as LPVOID) as integer
    select case uReason
      case DLL_PROCESS_ATTACH
        dim fpuState as DWORD = _control87(0, 0)
        fb_Init(0, NULL, 0)
        _control87(fpuState, &hFFFF)
        DisableThreadLibraryCalls(handle)
        
        OutstandingObjects = LockCount = 0
        MyIClassFactoryObj.lpVtbl = cast(IClassFactoryVtbl ptr, @IClassFactory_Vtbl)
      case DLL_PROCESS_DETACH
      case DLL_THREAD_ATTACH
      case DLL_THREAD_DETACH
    end select     
    return 1
  end function
end extern