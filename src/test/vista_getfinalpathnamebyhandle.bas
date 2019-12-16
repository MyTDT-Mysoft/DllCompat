#include "windows.bi"
#include "includes\win\wintern.bi"

'#include "inc\win\ddk\winddk.bi"

dim fnGetFinalPathNameByHandle as function (hFile as HANDLE, lpszFilePath as LPTSTR, cchFilePath as DWORD,dwFlags as DWORD) as dword

#if 0
var hKernel = GetModuleHandle("kernel32.dll")
fnGetFinalPathNameByHandle = cast( any ptr, GetProcAddress( hKernel , "GetFinalPathNameByHandleA" ) )
if fnGetFinalPathNameByHandle = 0 then
  print "failed to locate GetFinalPathNameByHandle function"
  sleep: system
end if
#endif

chdir exepath()

var hTemp = CreateFile( "GetFinalPathNameByHandleTests.exe" , GENERIC_READ , FILE_SHARE_READ , null , OPEN_EXISTING , null , null )
if hTemp = 0 then
  print "failed to open self..."
  sleep: system
end if

#undef MAX_PATH
#define MAX_PATH 4096

dim as wstring*MAX_PATH zBuff
type FILE_NAME_INFORMATION2
  FileNameLength as ULONG 
  FileName as wstring*MAX_PATH
end type

dim as IO_STATUS_BLOCK tStatBlock
dim as FILE_NAME_INFORMATION2 tFileInfo
var iResu = NtQueryInformationFile( hTemp , @tStatBlock ,  @tFileInfo , _ 
sizeof(FILE_NAME_INFORMATION2) , FileNameInformation )
if iResu <> STATUS_SUCCESS then
  print "NtQueryInformationFile Error 0x"+hex(iResu)
end if

type OBJECT_NAME_INFORMATION2 
  as UNICODE_STRING usName
  as wstring*MAX_PATH wBuff
end type
dim as OBJECT_NAME_INFORMATION2 tObjInf
var size = sizeof(tObjInf)
iResu = NtQueryObject(hTemp, ObjectNameInformation, @tObjInf , size , @size )
if iResu <> STATUS_SUCCESS then
  print "NtQueryObject Error 0x"+hex(iResu)
end if

print tFileInfo.FileName
print *cast(wstring ptr,tObjInf.usName.Buffer)

#if 0
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_NORMALIZED)
  print !"Normalized/DOS  \r\n["+zBuff+"]"
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_NORMALIZED or VOLUME_NAME_GUID)
  print !"Normalized/GUID \r\n["+zBuff+"]"
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_NORMALIZED or VOLUME_NAME_NONE)
  print !"Normalized/NONE \r\n["+zBuff+"]"
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_NORMALIZED or VOLUME_NAME_NT)
  print !"Normalized/NT   \r\n["+zBuff+"]"
  
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_OPENED)
  print !"Opened/DOS  \r\n["+zBuff+"]"
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_OPENED or VOLUME_NAME_GUID)
  print !"Opened/GUID \r\n["+zBuff+"]"
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_OPENED or VOLUME_NAME_NONE)
  print !"Opened/NONE \r\n["+zBuff+"]"
  fnGetFinalPathNameByHandle( hTemp , zBuff , MAX_PATH-1 , FILE_NAME_OPENED or VOLUME_NAME_NT)
  print !"Opened/NT   \r\n["+zBuff+"]"
  
  sleep
#endif

#if 0
  Normalized/DOS
  [\\?\C:\Users\Mysoft\Desktop\GetFinalPathNameByHandleTests.exe]
  Normalized/GUID
  [\\?\Volume{9f1c08e5-a28a-11e6-a286-806e6f6e6963}\Users\Mysoft\Desktop\GetFinalP
  athNameByHandleTests.exe]
  Normalized/NONE
  [\Users\Mysoft\Desktop\GetFinalPathNameByHandleTests.exe]
  Normalized/NT
  [\Device\HarddiskVolume2\Users\Mysoft\Desktop\GetFinalPathNameByHandleTests.exe]
  
  Opened/DOS
  [\\?\C:\Users\Mysoft\Desktop\GetFinalPathNameByHandleTests.exe]
  Opened/GUID
  [\\?\Volume{9f1c08e5-a28a-11e6-a286-806e6f6e6963}\Users\Mysoft\Desktop\GetFinalP
  athNameByHandleTests.exe]
  Opened/NONE
  [\Users\Mysoft\Desktop\GetFinalPathNameByHandleTests.exe]
  Opened/NT
  [\Device\HarddiskVolume2\Users\Mysoft\Desktop\GetFinalPathNameByHandleTests.exe]
#endif

sleep:end