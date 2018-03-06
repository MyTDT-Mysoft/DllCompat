#include "windows.bi"
#include "win\winnt.bi"

#inclib "ntdll"

type FIBER
  as PVOID FiberData
  as _EXCEPTION_REGISTRATION_RECORD ExceptionList
  as PVOID StackBase
  as PVOID StackLimit
  as PVOID DeallocationStack
  as CONTEXT FiberContext
  'win2k3
  as ULONG GuaranteedStackBytes
  as PVOID FlsData
end type

type UNICODE_STRING
  as USHORT      Length
  as USHORT      MaximumLength
  as wstring ptr Buffer
end type
type PUNICODE_STRING as UNICODE_STRING ptr

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

'type NTSTATUS as ulong

enum NTSTATUS_
  STATUS_SUCCESS = 0
end enum

enum FILE_INFORMATION_CLASS
  FileDirectoryInformation = 1
  FileFullDirectoryInformation
  FileBothDirectoryInformation
  FileBasicInformation
  FileStandardInformation
  FileInternalInformation
  FileEaInformation
  FileAccessInformation
  FileNameInformation
  FileRenameInformation
  FileLinkInformation
  FileNamesInformation
  FileDispositionInformation
  FilePositionInformation
  FileFullEaInformation
  FileModeInformation
  FileAlignmentInformation
  FileAllInformation
  FileAllocationInformation
  FileEndOfFileInformation
  FileAlternateNameInformation
  FileStreamInformation
  FilePipeInformation
  FilePipeLocalInformation
  FilePipeRemoteInformation
  FileMailslotQueryInformation
  FileMailslotSetInformation
  FileCompressionInformation
  FileObjectIdInformation
  FileCompletionInformation
  FileMoveClusterInformation
  FileQuotaInformation
  FileReparsePointInformation
  FileNetworkOpenInformation
  FileAttributeTagInformation
  FileTrackingInformation
  FileIdBothDirectoryInformation
  FileIdFullDirectoryInformation
  FileValidDataLengthInformation
  FileShortNameInformation
  FileIoCompletionNotificationInformation
  FileIoStatusBlockRangeInformation
  FileIoPriorityHintInformation
  FileSfioReserveInformation
  FileSfioVolumeInformation
  FileHardLinkInformation
  FileProcessIdsUsingFileInformation
  FileNormalizedNameInformation
  FileNetworkPhysicalNameInformation
  FileIdGlobalTxDirectoryInformation
  FileIsRemoteDeviceInformation
  FileUnusedInformation
  FileNumaNodeInformation
  FileStandardLinkInformation
  FileRemoteProtocolInformation
  FileRenameInformationBypassAccessCheck
  FileLinkInformationBypassAccessCheck
  FileVolumeNameInformation
  FileIdInformation
  FileIdExtdDirectoryInformation
  FileReplaceCompletionInformation
  FileHardLinkFullIdInformation
  FileIdExtdBothDirectoryInformation
  FileMaximumInformation
end enum

type IO_STATUS_BLOCK
  union
    as NTSTATUS Status
    as PVOID    _Pointer
  end union
  as ULONG_PTR Information
end type
type PIO_STATUS_BLOCK as IO_STATUS_BLOCK ptr

#undef FILE_NAME_INFORMATION
type FILE_NAME_INFORMATION
  FileNameLength as ULONG 'IN BYTES!
  FileName as wstring*1
end type
type PFILE_NAME_INFORMATION as FILE_NAME_INFORMATION ptr

enum OBJECT_INFORMATION_CLASS
  ObjectBasicInformation
  ObjectNameInformation
  ObjectTypeInformation
  ObjectAllInformation
  ObjectDataInformation
end enum

#undef OBJECT_NAME_INFORMATION
type OBJECT_NAME_INFORMATION 
  as UNICODE_STRING usName
  as wstring*1      pwBuff
end type
type POBJECT_NAME_INFORMATION as OBJECT_NAME_INFORMATION ptr

type PIO_APC_ROUTINE as sub stdcall(byval as PVOID, byval as PIO_STATUS_BLOCK, byval as ULONG)
    
extern "windows"
  declare function NtQueryDirectoryFile( _
    FileHandle           as HANDLE, _
    Event                as HANDLE, _
    ApcRoutine           as PIO_APC_ROUTINE, _
    ApcContext           as PVOID, _
    IoStatusBlock        as PIO_STATUS_BLOCK, _
    FileInformation      as PVOID, _
    Length               as ULONG, _
    FileInformationClass as FILE_INFORMATION_CLASS, _
    ReturnSingleEntry    as BOOLEAN, _
    FileMask             as PUNICODE_STRING, _
    RestartScan          as BOOLEAN _
    ) as NTSTATUS
  
  declare function NtQueryInformationFile( _
    FileHandle           as HANDLE, _
    IoStatusBlock        as PIO_STATUS_BLOCK, _
    FileInformation      as PVOID, _
    Length               as ULONG, _
    FileInformationClass as FILE_INFORMATION_CLASS _
    ) as NTSTATUS
  'fnNtQueryInformationFile = cast(any ptr, GetProcAddress( hNTDLL , "NtQueryInformationFile" ) )
  
  declare function NtQueryInformationThread( _
    ThreadHandle            as HANDLE, _
    ThreadInformationClass  as THREADINFOCLASS, _
    ThreadInformation       as any ptr, _
    ThreadInformationLength as ulong, _                  
    ReturnLength            as ulong ptr _
    ) as NTSTATUS
  'fnNtQueryInformationThreadFunc = cast(any ptr, GetProcAddress( hNTDLL , "NtQueryInformationThread" ) )
  
  declare function NtQueryObject( _
    ObjectHandle           as handle, _
    ObjectInformationClass as OBJECT_INFORMATION_CLASS, _
    ObjectInformation      as PVOID, _
    Length                 as ULONG, _
    ResultLength           as PULONG _
    ) as NTSTATUS
  'fnNtQueryObject = cast(any ptr, GetProcAddress( hNTDLL , "NtQueryObject" ) )
  
  declare function RtlNtStatusToDosError ( _
    Status as NTSTATUS _
  ) as ULONG
end extern
