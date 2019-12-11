#pragma once

const CREATE_MUTEX_INITIAL_OWNER = &h1
const CREATE_EVENT_MANUAL_RESET = &h1
const CREATE_EVENT_INITIAL_SET = &h2

type _FILE_INFO_BY_HANDLE_CLASS as long
enum
  FileBasicInfo
  FileStandardInfo
  FileNameInfo
  FileRenameInfo
  FileDispositionInfo
  FileAllocationInfo
  FileEndOfFileInfo
  FileStreamInfo
  FileCompressionInfo
  FileAttributeTagInfo
  FileIdBothDirectoryInfo
  FileIdBothDirectoryRestartInfo
  FileIoPriorityHintInfo
  FileRemoteProtocolInfo
  FileFullDirectoryInfo
  FileFullDirectoryRestartInfo
  FileStorageInfo
  FileAlignmentInfo
  FileIdInfo
  FileIdExtdDirectoryInfo
  FileIdExtdDirectoryRestartInfo
  MaximumFileInfoByHandleClass
end enum
type FILE_INFO_BY_HANDLE_CLASS as _FILE_INFO_BY_HANDLE_CLASS
type PFILE_INFO_BY_HANDLE_CLASS as _FILE_INFO_BY_HANDLE_CLASS ptr

#undef PROCESS_NAME_NATIVE
const PROCESS_NAME_NATIVE = &h00000001