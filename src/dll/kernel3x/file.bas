extern "windows-ms"
  UndefAllParams()
  #define P1 lpSymlinkFileName as LPCSTR
  #define P2 lpTargetFileName  as LPCSTR
  #define P3 dwFlags           as DWORD
  function CreateSymbolicLinkA(P1, P2, P3) as BOOLEAN export
    DEBUG_MsgNotImpl()
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 lpSymlinkFileName as LPCWSTR
  #define P2 lpTargetFileName  as LPCWSTR
  #define P3 dwFlags           as DWORD
  function CreateSymbolicLinkW(P1, P2, P3) as BOOLEAN export
    DEBUG_MsgNotImpl()
    return FALSE
  end function
  
  UndefAllParams()
  #define P1 hFile        as _In_  HANDLE
  #define P2 lpszFilePath as _Out_ LPWSTR
  #define P3 cchFilePath  as _In_  DWORD
  #define P4 dwFlags      as _In_  DWORD
  function GetFinalPathNameByHandleW(P1,P2,P3,P4) as DWORD export
    'cchFilePath is in TCHARS (i.e. wchars for this one)... and doesnt include the space for NULL
    var iFilePathSz = (cchFilePath+1)*sizeof(wstring*1)
    
    'basic flags check
    const cAllVolumeOptions =  VOLUME_NAME_GUID or VOLUME_NAME_NT or VOLUME_NAME_NONE
    var iBadFlags = (dwFlags and (not (FILE_NAME_OPENED or cAllVolumeOptions)))
    if hFile=null orelse lpszFilePath=null orelse iBadFlags then
      if iBadFlags then
        DEBUG_MsgTrace("FAIL: Bad flags were used... 0x" & iBadFlags)
      elseif lpszFilePath=null then
        DEBUG_MsgTrace("FAIL: null lpszFilePath")
      elseif hFile=null then
        DEBUG_MsgTrace("FAIL: null hFile")
      end if
      SetLastError( ERROR_INVALID_PARAMETER )
      return 0
    end if
    
    'basic handle check
    var iType = GetFileType( hFile )
    if iType = 0 then 
      var iTempErr = GetLastError()
      DEBUG_MsgTrace("FAIL: bad file type? (not a file?)")
      SetLastError(iTempErr)
      return 0 
    end if
    
    'this may not be implemented correctly... so warning when used
    if (dwFlags and FILE_NAME_OPENED) then
      DEBUG_MsgTrace("flag FILE_NAME_OPENED used...")
    end if
    
    'expecting a DOS volume? [\\?\Drive:\Path\File.Ext]
    if (dwFlags and cAllVolumeOptions)=0 then 'VOLUME_NAME_DOS
      '// Get the file size.
      dim as DWORD dwFileSizeHi = 0
      dim as DWORD dwFileSizeLo = GetFileSize(hFile, @dwFileSizeHi)
      if dwFileSizeLo = 0 andalso dwFileSizeHi = 0 then
        DEBUG_MsgTrace("FAIL: Filesize=0 so can't map to get name...")
        SetLastError( ERROR_FILE_NOT_FOUND )
        return 0
      end if
      DEBUG_MsgTrace("flag VOLUME_NAME_DOS used...")
    end if
    
    'expecting a GUID volume? [\\?\Volume{GUID}\Path\File.Ext]
    if (dwFlags and VOLUME_NAME_GUID) then
      DEBUG_MsgTrace("flag VOLUME_NAME_GUID used...")
      return 0
    end if
    
    'expecting a NT volume? [\Device\HarddiskVolume?\Path\File.Ext]
    if (dwFlags and VOLUME_NAME_NT) then            
      var iTempSz = cchFilePath + sizeof(OBJECT_NAME_INFORMATION) 
      var pTemp = cptr(POBJECT_NAME_INFORMATION, allocate(iTempSz))      
      
      if pTemp = 0 then
        DEBUG_MsgTrace("FAIL: out of memory allocating buffer...")
        SetLastError( ERROR_NOT_ENOUGH_MEMORY )
        return 0
      end if      
      
      var iResu = NtQueryObject(hFile, ObjectNameInformation, pTemp , iTempSz , @iTempSz )
      if iResu <> STATUS_SUCCESS then
        DEBUG_MsgTrace("FAIL: NtQueryInformationFile Error 0x" & hex(iResu))
        SetLastError(ERROR_PATH_NOT_FOUND) 'need better error handling?
      end if
      
      DEBUG_MsgTrace("flag VOLUME_NAME_NT used")
      
    end if
    
    'expecting no volume?  [\Path\File.Ext]
    if (dwFlags and VOLUME_NAME_NONE) then
      var iTempSz = ((cchFilePath+1)*sizeof(wstring*1)) + sizeof(FILE_NAME_INFORMATION) 
      var pTemp = cptr(PFILE_NAME_INFORMATION, allocate(iTempSz))      
      dim as IO_STATUS_BLOCK tStatBlock
      
      if pTemp = 0 then
        DEBUG_MsgTrace("FAIL: out of memory allocating buffer...")
        SetLastError( ERROR_NOT_ENOUGH_MEMORY )
        return 0
      end if
      
      var iResu = NtQueryInformationFile( hFile , @tStatBlock ,  pTemp , iTempSz , FileNameInformation )
      if iResu <> STATUS_SUCCESS then
        DEBUG_MsgTrace("FAIL: NtQueryInformationFile Error 0x" & hex(iResu))
        SetLastError(ERROR_PATH_NOT_FOUND) 'need better error handling?
        return 0
      end if
      
      var iSz = pTemp->FileNameLength       
      if (iSz+sizeof(wstring*1)) > iFilePathSz then        
        memcpy( lpszFilePath , @(pTemp->FileName) , iFilePathSz ) 'copy what fits
        lpszFilePath[cchFilePath] = 0 'set the null char
        DEBUG_MsgTrace("FAIL: NtQueryInformationFile ERROR_INSUFFICIENT_BUFFER" & hex(iResu))
        SetLastError( ERROR_INSUFFICIENT_BUFFER )
        return iSz
      end if      
      
      memcpy( lpszFilePath , @(pTemp->FileName) , (iSz+sizeof(wstring*1)) )
      lpszFilePath[ iSz\sizeof(wstring*1) ] = 0 'set the last null char
      SetLastError( ERROR_SUCCESS )      
      return iSz\(sizeof(wstring*1))
    end if
  end function
  
  UndefAllParams()
  #define P1 hFile        as _In_  HANDLE
  #define P2 lpszFilePath as _Out_ LPSTR
  #define P3 cchFilePath  as _In_  DWORD
  #define P4 dwFlags      as _In_  DWORD
  function GetFinalPathNameByHandleA(P1,P2,P3,P4) as DWORD export
    dim as DWORD ret
    dim as zstring*MAX_PATH zTemp = any
    dim as zstring ptr stringPtr = @zTemp
    
    if cchFilePath>MAX_PATH then
      stringPtr = GlobalAlloc(GMEM_FIXED, cchFilePath*sizeof(CHAR))
      if stringPtr=NULL then
        SetLastERror(ERROR_NOT_ENOUGH_MEMORY)
        return 0
      end if
    end if 
    
    ret = GetFinalPathNameByHandleW(hFile, stringPtr, cchFilePath, dwFlags) 'cchFilePath
    if ret=0 orelse cchFilePath<ret then return ret
    
    MultiByteToWideChar(CP_ACP, 0, stringPtr, -1, lpszFilePath, cchFilePath)
    if stringPtr<>@zTemp then GlobalFree(stringPtr)
    
    return ret
  end function
  
  UndefAllParams()
  #define P1 hFile                as _In_ HANDLE
  #define P2 FileInformationClass as _In_ FILE_INFO_BY_HANDLE_CLASS
  #define P3 lpFileInformation    as _In_ LPVOID
  #define P4 dwBufferSize         as _In_ DWORD
  function SetFileInformationByHandle(P1, P2, P3, P4) as BOOL export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return 0
  end function
  
  UndefAllParams()
  #define P1 hFile                as _In_  HANDLE
  #define P2 FileInformationClass as _In_  FILE_INFO_BY_HANDLE_CLASS
  #define P3 lpFileInformation    as _Out_ LPVOID
  #define P4 dwBufferSize         as _In_  DWORD
  function GetFileInformationByHandleEx(P1, P2, P3, P4) as BOOL export
    dim status as NTSTATUS
    dim io as IO_STATUS_BLOCK

    #define CASE_NOTIMPL _
    FileStreamInfo, FileCompressionInfo, FileAttributeTagInfo, _
    FileRemoteProtocolInfo, FileFullDirectoryInfo, FileFullDirectoryRestartInfo, _
    FileStorageInfo, FileAlignmentInfo, FileIdExtdDirectoryInfo, _
    FileIdExtdDirectoryRestartInfo
    
    #define CASE_BADPARAM _
    FileRenameInfo, FileDispositionInfo, FileAllocationInfo, _
    FileIoPriorityHintInfo, FileEndOfFileInfo, else
    
    select case as const FileInformationClass
      case CASE_NOTIMPL
        DEBUG_MsgTrace("%p, %u, %p, %u\n", hFile, FileInformationClass, lpFileInformation, dwBufferSize )
        SetLastError(ERROR_CALL_NOT_IMPLEMENTED)
        return FALSE
      case FileBasicInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileBasicInformation)
      case FileStandardInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileStandardInformation)
      case FileNameInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileNameInformation)
      case FileIdInfo
        status = NtQueryInformationFile(hFile, @io, lpFileInformation, dwBufferSize, FileIdInformation)
      case FileIdBothDirectoryRestartInfo, FileIdBothDirectoryInfo
        status = NtQueryDirectoryFile(hFile, NULL, NULL, NULL, @io, lpFileInformation, dwBufferSize, FileIdBothDirectoryInformation, FALSE, NULL, (FileInformationClass = FileIdBothDirectoryRestartInfo))
      case else 'CASE_BADPARAM
        SetLastError(ERROR_INVALID_PARAMETER)
        return FALSE
    end select

    if status <> STATUS_SUCCESS then
      SetLastError(RtlNtStatusToDosError(status))
      return FALSE
    end if
    return TRUE
  end function
  
  UndefAllParams()
  #define P1 hOriginalFile        as HANDLE
  #define P2 dwDesiredAccess      as DWORD
  #define P3 dwShareMode          as DWORD
  #define P4 dwFlagsAndAttributes as DWORD
  function fnReOpenFile alias "ReOpenFile"(P1, P2, P3, P4) as HANDLE export
    DEBUG_MsgNotImpl()
    SetLastError(ERROR_OUT_OF_PAPER)
    return INVALID_HANDLE_VALUE
  end function
  
end extern