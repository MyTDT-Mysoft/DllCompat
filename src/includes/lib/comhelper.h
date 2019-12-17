#pragma once

#define GUIDSTR_SIZE (sizeof("{00112233-4455-6677-8899-AABBCCDDEEFF}")-1)
#define THREADMODEL_APARTMENT "Apartment"
#define THREADMODEL_FREE      "Free"
#define THREADMODEL_BOTH      "Both"
#define THREADMODEL_NEUTRAL   "Neutral"

#ifndef __FB_VERSION__
//---------------------------------------------------------------------------------------------------
//C version
#include <windows.h>

//--------------------------------
//COM helper functions

//convert GUID to ANSI string
void chelp_GUID2strA(LPSTR buf, const GUID* ri);

//convert GUID to UTF16 string
void chelp_GUID2strW(LPWSTR buf, const GUID* ri);

//check GUID identity against multiple GUIDs
BOOL chelp_cmpMultGUID(const GUID* p1, const GUID** pp2, int count);

//remove registry info for COM Object
BOOL chelp_unregisterCOM(LPCSTR ownershipMark, REFCLSID pGuid);

//add registry info for COM Object
BOOL chelp_registerCOM(LPCSTR ownershipMark, REFCLSID pGuid, LPCSTR pszDllPath, BOOL isExpandable, LPCSTR pszThreadModel, LPCSTR pszDescription);



//-------------------------------------------------------------
//COM base helper API

//Cbase callback.
typedef HRESULT (*CbaseCB)(void* self, REFCLSID rclsid);

//COM Descriptor, a config struct
typedef struct COMDesc COMDesc;
typedef struct COMDesc {
    //Object stuff
    REFCLSID    rclsid;         //Ptr to Object's CLSID.
    REFIID*     riidArr;        //Array of ptrs to Interfaces the Object recognizes.
    int         iidCount;       //Number of Interfaces refered to by riidArr
    void*       rvtbl;          //Ptr to Object's v-table. Must extend IUnknown.
    DWORD       objSize;        //Size of object to allocate, in bytes.
    CbaseCB     cbConstruct;    //The constructor callback, immediatelly after instance allocation(pre-zeroed)
    CbaseCB     cbDestruct;     //The destructor callback, immediatelly before instance deallocation
    
    //Registration stuff    
    PCHAR       ownMark;        //Ownership mark. Required for preventing changes to keys that do not belong to us, inside HKLM\SOFTWARE\Classes\CLSID.
    PCHAR       thModel;        //Threading model.
    PCHAR       descript;       //Description of COM Object
} _COMDesc;

//COM generic Object
//Extend all COM objects from this
//Must be first member of your object, union-ed with your own v-table that extends IUnknown
/*
 * struct MyObject {
 *     union {
 *         COMGenerObj baseObj;
 *         const IMyObjectVtbl* lpVtbl
 *     };
 *     SomeStruct* myMember1;
 *     int         myMember2;
 * };
 */
typedef struct COMGenerObj COMGenerObj;
struct COMGenerObj {
    const IUnknownVtbl* lpVtbl;
    const COMDesc* conf;       //Identity of object instance
    BOOL           isFactory;  //Is our Object a factory?
    int            count;      //Reference count for object
} _COMGenerObj;

//Must be called from DllMain on DLL_PROCESS_ATTACH.
void cbase_init(HINSTANCE hinst, const COMDesc** cobjArr, int nrObjects);
//Must be called from DllMain on DLL_PROCESS_DETACH.
void cbase_destroy();

//Creates instance of a COM object or its factory
HRESULT cbase_createInstance(const COMDesc* conf, void** ppv, BOOL isFactory);

//These COM functions can be inserted into your v-tables, or you can call them from your own functions.
//They do the COM book-work.
HRESULT STDMETHODCALLTYPE cbase_UnkQueryInterface(COMGenerObj* self, REFIID riid, void **ppv);
ULONG   STDMETHODCALLTYPE cbase_UnkAddRef(COMGenerObj* self);
ULONG   STDMETHODCALLTYPE cbase_UnkRelease(COMGenerObj* self);

//These functions go inside respectively named export functions, like hooks.
//It is up to you to export them.
HRESULT WINAPI cbase_DllGetClassObject(REFCLSID rclsid, REFIID riid, void** ppv);
HRESULT WINAPI cbase_DllCanUnloadNow();
HRESULT WINAPI cbase_DllUnregisterServer();
HRESULT WINAPI cbase_DllRegisterServer();

//---------------------------------------------------------------------------------------------------
//FreeBASIC version
#else

#include "windows.bi"
#include "win\winbase.bi"
#include "win\objbase.bi"

extern "C"
  declare sub chelp_GUID2strA(buf as LPSTR, ri as const GUID ptr)
  declare sub chelp_GUID2strW(buf as LPWSTR, ri as const GUID ptr)
  declare function chelp_cmpMultGUID(p1 as const GUID ptr, pp2 as const GUID ptr ptr, count as long) as BOOL
  declare function chelp_unregisterCOM(ownershipMark as LPCSTR, pGuid as REFCLSID) as BOOL
  declare function chelp_registerCOM(ownershipMark as LPCSTR, pGuid as REFCLSID, pszDllPath as LPCSTR, isExpandable as BOOL, pszThreadModel as LPCSTR, pszDescription as LPCSTR) as BOOL
  
  type CbaseCB as function(self as any ptr, rclsid as REFCLSID) as HRESULT
end extern


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
  declare sub cbase_destroy()
  declare function cbase_createInstance(conf as const COMDesc ptr, ppv as any ptr ptr, isFactory as BOOL) as HRESULT
end extern

extern "windows-ms"
  declare function cbase_UnkQueryInterface(self as COMGenerObj ptr, riid as REFIID, ppv as any ptr ptr) as HRESULT
  declare function cbase_UnkAddRef(self as COMGenerObj ptr) as ULONG
  declare function cbase_UnkRelease(self as COMGenerObj ptr) as ULONG
  
  declare function cbase_DllGetClassObject(rclsid as REFCLSID, riid as REFIID, ppv as any ptr ptr) as HRESULT
  declare function cbase_DllCanUnloadNow() as HRESULT
  declare function cbase_DllUnregisterServer() as HRESULT
  declare function cbase_DllRegisterServer() as HRESULT
end extern
#endif