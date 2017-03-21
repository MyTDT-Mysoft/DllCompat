#include "windows.bi"
#include "win\winnt.bi"

type KAFFINITY as dword
type KPRIORITY as dword
type NTSTATUS as LONG 
type KPRIORITY as DWORD
type UWORD as WORD

type CLIENT_ID
  as any ptr UniqueProcess
  as any ptr UniqueThread
end type

type THREAD_BASIC_INFO
  as NTSTATUS   ExitStatus
  as any ptr    TebBaseAddress
  as CLIENT_ID  ClientId
  as KAFFINITY  AffinityMask
  as KPRIORITY  Priority
  as KPRIORITY  BasePriority
end type

enum THREADINFOCLASS
  ThreadBasicInformation
end enum

'// NtQueryInformationProcess is documented in winternl.h, but we link
'// dynamically to it because we might as well.
var hNTDLL = GetModuleHandle("ntdll.dll")

dim shared fnNtQueryInformationThreadFunc as function ( _
    ThreadHandle as HANDLE, _
    ThreadInformationClass as THREADINFOCLASS, _
    ThreadInformation as any ptr, _
    ThreadInformationLength as ulong, _                  
    ReturnLength as ulong ptr ) as NTSTATUS = any '<- optional
fnNtQueryInformationThreadFunc = cast(any ptr, GetProcAddress( hNTDLL , "NtQueryInformationThread" ) )



