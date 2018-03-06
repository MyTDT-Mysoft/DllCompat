#undef _FILE_INFO_BY_HANDLE_CLASS
#undef FILE_INFO_BY_HANDLE_CLASS
#undef PFILE_INFO_BY_HANDLE_CLASS

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