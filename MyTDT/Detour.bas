#include once "windows.bi"
#include once "crt.bi"

#macro UndefAll()
  #undef P1
  #undef P2
  #undef P3
  #undef P4
  #undef P5
  #undef P6
  #undef P7
  #undef P8
  #undef P9
  #undef P10
  #undef P11
  #undef P12
  #undef P13
  #undef P14
  #undef P15
  #undef P16
#endmacro

#define SetDetourLibrary(zDll_) DetourFunction(zDll_,0,0)
#macro CreateDetour(zFunc_)
  pf##zFunc_ = DetourFunction(0,#zFunc_,@##zFunc_##_Detour)
  #ifdef DebugOut
  if pf##zFunc_ = 0 then 
    DebugOut(!"Failed to Detour to '%s'\r\n",#zFunc_)
  end if
  #else
  if pf##zFunc_ = 0 then Printf(!"Failed to Detour to '%s'\r\n",#zFunc_)
  #endif
#endmacro
#macro RestoreDetour(zFunc_)
  if (pf##zFunc_) then
    if DetourFunction(0,#zFunc_,pf##zFunc_) <> @##zFunc_##_Detour then
      #ifdef DebugOut
      DebugOut(!"Warning: Detour to '%s' was modified!\r\n",#zFunc_)
      #else
      Printf(!"Warning: Detour to '%s' was modified!\r\n",#zFunc_)
      #endif
    end if
  end if
#endmacro

extern "windows-ms"
function DetourFunction alias "DetourFunction" (zModule as zstring ptr=0,zFunctionName as zstring ptr,pNewFunction as any ptr) as any ptr
  
  type tLinked
    as tLinked ptr pNext,pPrev  
    as any ptr     Reserved(1),pDllBase  
  end type
    
  static as any ptr hModule,hKernel,hNTDLL    
  static as tLinked ptr pModList
  if zModule then 
    hModule = GetModuleHandle(zModule)
    if hModule = 0 then hModule = LoadLibrary(zModule)
  end if
  if hModule = 0 or zFunctionName=0 or pNewFunction=0 then return 0  
  
  ' Getting PEB->Ldr->Modules once using NtQueryInfoProc.
  if pModList = NULL then
    dim NtQueryInfoProc as function (as handle,as long,as any ptr,as ulong,as ulong ptr) as integer
    hNTDLL = GetModuleHandle("NTDLL.DLL"): hKernel = GetModuleHandle("KERNEL32.DLL")
    dim zQueryInfo as zstring*32 = any,pzSrc as ubyte ptr = cast(ubyte ptr,@!"OvRq`t~Agld~`o{y~|Cfzurkj\26")
    for I as integer = 0 to 25: zQueryInfo[I] = pzSrc[I] xor (I+1): next
    NtQueryInfoProc = cast(any ptr,GetProcAddress(hNTDLL,zQueryInfo))    
    dim pPBI(5) as any ptr, iSz as ulong,iResu as integer = NtQueryInfoProc=0
    if iResu=0 then iResu = (NtQueryInfoProc(GetCurrentProcess(),0,@pPBI(0),6*sizeof(any ptr),@iSz)<>0)
    if iResu then
      dim zA as zstring*24 = any, zB as zstring*24 = any,bA as ubyte ptr,bB as ubyte ptr
      bA = cptr(ubyte ptr,@!"Gcjh`b'|f*Liy._US\018"): bB = cptr(ubyte ptr,@!"Oxwtbs'Fl}+Hhz`ec\018")      
      for I as integer = 0 to 17: zA[I]=bA[I] xor (I+1): zb[I]=bB[I] xor (I+1): next
      Messagebox(null,zA,zB,MB_ICONERROR or MB_SYSTEMMODAL):return 0
    end if
    dim as any ptr ptr pPeb = pPBI(1): pPeb = pPeb[3]: pModList = pPeb[5]
  end if
  
  'Get Export Directory from hmodule
  #undef _p
  #undef pRva
  #undef pDirectory
  #undef zName
  #undef pAddress
  #undef SetAddress
  
  #define _p(_pp_) cptr(any ptr,_pp_)
  #define pRVA(_pp_) (_p(pDosHeader)+cast(integer,(_pp_)))
  #define pDirectory(_N_) pRVA((pOptHeader->DataDirectory(_N_).VirtualAddress))
  #define zName(_N_) *cptr(zstring ptr,pRVA(pdName[_N_]))
  #define pAddress(_N_) _p(pRVA(pdAddress[pwNumToAddr[_N_]]))
  #define SetAddress(_N_,_A_) pdAddress[pwNumToAddr[_N_]] = (cuint(_A_)-cuint(pDosHeader))
  
  dim as IMAGE_DOS_HEADER ptr pDosHeader = _p(hModule)
  dim as IMAGE_NT_HEADERS ptr pNTHeader = _p(pDosHeader) + pDosHeader->e_lfanew
  dim as IMAGE_OPTIONAL_HEADER  ptr pOptHeader = @(pNTHeader->OptionalHeader)
  dim as IMAGE_EXPORT_DIRECTORY ptr pExports = pDirectory(IMAGE_DIRECTORY_ENTRY_EXPORT)
  dim as dword ptr pdName = pRVA(pExports->AddressOfNames)
  dim as dword ptr pdAddress = pRVA(pExports->AddressOfFunctions)
  dim as word ptr pwNumToAddr = pRVA(pExports->AddressOfNameOrdinals)
  dim as any ptr pResult 

  'Locating Export name
  for CNT as integer = 0 to pExports->NumberOfNames-1
    if strcmp(zName(CNT),zFunctionName)=0 then      
      var pFunc = pAddress(CNT),OldProt=0
      VirtualProtect(pdAddress+CNT,sizeof(dword),PAGE_EXECUTE_READWRITE,@OldProt)
      SetAddress(CNT,pNewFunction)
      VirtualProtect(pdAddress+CNT,sizeof(dword),OldProt,@OldProt)
      pResult = pFunc:exit for
    end if
  next CNT
  if pResult=0 then return NULL  
  
  'Enumerating modules and locating imports
  'New modules loaded will inherit the changes.
  dim as tLinked ptr pModules = pModList 
  do
    with *pModules
      if .pDllBase = 0 then exit do        
      dim as IMAGE_DOS_HEADER ptr pDosHeader = _p(.pDllBase)    
      dim as IMAGE_NT_HEADERS ptr pNTHeader = _p(pDosHeader) + pDosHeader->e_lfanew    
      dim as IMAGE_OPTIONAL_HEADER  ptr pOptHeader = @(pNTHeader->OptionalHeader)    
      dim as IMAGE_IMPORT_DESCRIPTOR ptr pImp = pDirectory(IMAGE_DIRECTORY_ENTRY_IMPORT)
      if pImp then 'andalso .pDllBase <> hNTDLL andalso .pDllBase <> hKernel then
        while pImp->Name <> 0          
          dim as PIMAGE_THUNK_DATA pThunkB = pRVA(pImp->FirstThunk)
          while pThunkB->u1.AddressOfData            
            dim as IMAGE_IMPORT_BY_NAME ptr pImpAddr = cast(IMAGE_IMPORT_BY_NAME ptr, pThunkB->u1.AddressOfData)
            if pImpAddr = pResult then                  
              var pFunc = @(pThunkB->u1.AddressOfData),OldProt=0
              VirtualProtect(pFunc,sizeof(any ptr),PAGE_EXECUTE_READWRITE,@OldProt)
              if IsBadWritePtr(pFunc,sizeof(any ptr))=0 then
                pThunkB->u1.AddressOfData = culng(pNewFunction)                
              end if
              VirtualProtect(pFunc,sizeof(any ptr),OldProt,@OldProt)
            end if
            pThunkB += 1          
          wend
          pImp += 1
        wend      
      end if      
      if .pNext = 0 or .pNext = pModList then exit do
      pModules = .pNext
    end with
  loop 
  
  return pResult
  
  #undef _p
  #undef pRva
  #undef pDirectory
  #undef zName
  #undef pAddress
  #undef SetAddress
  
end function
end extern


