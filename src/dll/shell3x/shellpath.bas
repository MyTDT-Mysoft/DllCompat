type kcmItem
  pKfid as REFKNOWNFOLDERID
  union
    _16 as WORD
    type
      csidl:8   as WORD
      isBound:8 as BYTE
    end type
  end union
end type

#define NOWHERE &h00FF
#define BIND &hFF00 or

static shared kcMap(...) as kcmItem = {_
  (@FOLDERID_AddNewPrograms,              NOWHERE),_
  (@FOLDERID_AdminTools,                  CSIDL_ADMINTOOLS),_
  (@FOLDERID_AppUpdates,                  NOWHERE),_
  (@FOLDERID_CDBurning,              BIND CSIDL_CDBURN_AREA),_
  (@FOLDERID_ChangeRemovePrograms,        NOWHERE),_
  (@FOLDERID_CommonAdminTools,            CSIDL_COMMON_ADMINTOOLS),_
  (@FOLDERID_CommonOEMLinks,              CSIDL_COMMON_OEM_LINKS),_
  (@FOLDERID_CommonPrograms,         BIND CSIDL_COMMON_PROGRAMS),_
  (@FOLDERID_CommonStartMenu,        BIND CSIDL_COMMON_STARTMENU),_
  (@FOLDERID_CommonStartup,          BIND CSIDL_COMMON_STARTUP),_ 'CSIDL_COMMON_ALTSTARTUP
  (@FOLDERID_CommonTemplates,        BIND CSIDL_COMMON_TEMPLATES),_
  (@FOLDERID_ComputerFolder,         BIND CSIDL_DRIVES),_
  (@FOLDERID_ConflictFolder,              NOWHERE),_
  (@FOLDERID_ConnectionsFolder,           CSIDL_CONNECTIONS),_
  (@FOLDERID_Contacts,                    NOWHERE),_
  (@FOLDERID_ControlPanelFolder,          CSIDL_CONTROLS),_
  (@FOLDERID_Cookies,                BIND CSIDL_COOKIES),_
  (@FOLDERID_Desktop,                BIND CSIDL_DESKTOP),_ 'CSIDL_DESKTOPDIRECTORY
  (@FOLDERID_DeviceMetadataStore,         NOWHERE),_
  (@FOLDERID_Documents,              BIND CSIDL_MYDOCUMENTS),_ 'CSIDL_PERSONAL
  (@FOLDERID_DocumentsLibrary,            NOWHERE),_
  (@FOLDERID_Downloads,                   NOWHERE),_
  (@FOLDERID_Favorites,              BIND CSIDL_FAVORITES),_ 'CSIDL_COMMON_FAVORITES
  (@FOLDERID_Fonts,                  BIND CSIDL_FONTS),_
  (@FOLDERID_Games,                       NOWHERE),_
  (@FOLDERID_GameTasks,                   NOWHERE),_
  (@FOLDERID_History,                     CSIDL_HISTORY),_
  (@FOLDERID_HomeGroup,                   NOWHERE),_
  (@FOLDERID_ImplicitAppShortcuts,        NOWHERE),_
  (@FOLDERID_InternetCache,          BIND CSIDL_INTERNET_CACHE),_
  (@FOLDERID_InternetFolder,              CSIDL_INTERNET),_
  (@FOLDERID_Libraries,                   NOWHERE),_
  (@FOLDERID_Links,                       NOWHERE),_
  (@FOLDERID_LocalAppData,           BIND CSIDL_LOCAL_APPDATA),_
  (@FOLDERID_LocalAppDataLow,             NOWHERE),_
  (@FOLDERID_LocalizedResourcesDir,       CSIDL_RESOURCES_LOCALIZED),_
  (@FOLDERID_Music,                  BIND CSIDL_MYMUSIC),_
  (@FOLDERID_MusicLibrary,                NOWHERE),_
  (@FOLDERID_NetHood,                     CSIDL_NETHOOD),_
  (@FOLDERID_NetworkFolder,               CSIDL_NETWORK),_ 'CSIDL_COMPUTERSNEARME
  (@FOLDERID_OriginalImages,              NOWHERE),_
  (@FOLDERID_PhotoAlbums,                 NOWHERE),_
  (@FOLDERID_Pictures,               BIND CSIDL_MYPICTURES),_
  (@FOLDERID_PicturesLibrary,             NOWHERE),_
  (@FOLDERID_Playlists,                   NOWHERE),_
  (@FOLDERID_PrintersFolder,              CSIDL_PRINTERS),_
  (@FOLDERID_PrintHood,                   CSIDL_PRINTHOOD),_
  (@FOLDERID_Profile,                     CSIDL_PROFILE),_
  (@FOLDERID_ProgramData,            BIND CSIDL_COMMON_APPDATA),_
  (@FOLDERID_ProgramFiles,           BIND CSIDL_PROGRAM_FILES),_
  (@FOLDERID_ProgramFilesCommon,     BIND CSIDL_PROGRAM_FILES_COMMON),_
  (@FOLDERID_ProgramFilesCommonX64,       NOWHERE),_
  (@FOLDERID_ProgramFilesCommonX86,  BIND CSIDL_PROGRAM_FILES_COMMONX86),_
  (@FOLDERID_ProgramFilesX64,             NOWHERE),_
  (@FOLDERID_ProgramFilesX86,        BIND CSIDL_PROGRAM_FILESX86),_
  (@FOLDERID_Programs,               BIND CSIDL_PROGRAMS),_
  (@FOLDERID_Public,                      NOWHERE),_
  (@FOLDERID_PublicDesktop,          BIND CSIDL_COMMON_DESKTOPDIRECTORY),_
  (@FOLDERID_PublicDocuments,        BIND CSIDL_COMMON_DOCUMENTS),_
  (@FOLDERID_PublicDownloads,             NOWHERE),_
  (@FOLDERID_PublicGameTasks,             NOWHERE),_
  (@FOLDERID_PublicLibraries,             NOWHERE),_
  (@FOLDERID_PublicMusic,            BIND CSIDL_COMMON_MUSIC),_
  (@FOLDERID_PublicPictures,         BIND CSIDL_COMMON_PICTURES),_
  (@FOLDERID_PublicRingtones,             NOWHERE),_
  (@FOLDERID_PublicVideos,           BIND CSIDL_COMMON_VIDEO),_
  (@FOLDERID_QuickLaunch,                 NOWHERE),_
  (@FOLDERID_Recent,                      CSIDL_RECENT),_
  (@FOLDERID_RecordedTV,                  NOWHERE),_
  (@FOLDERID_RecordedTVLibrary,           NOWHERE),_
  (@FOLDERID_RecycleBinFolder,       BIND CSIDL_BITBUCKET),_
  (@FOLDERID_ResourceDir,                 CSIDL_RESOURCES),_
  (@FOLDERID_Ringtones,                   NOWHERE),_
  (@FOLDERID_RoamingAppData,         BIND CSIDL_APPDATA),_
  (@FOLDERID_SampleMusic,                 NOWHERE),_
  (@FOLDERID_SamplePictures,              NOWHERE),_
  (@FOLDERID_SamplePlaylists,             NOWHERE),_
  (@FOLDERID_SampleVideos,                NOWHERE),_
  (@FOLDERID_SavedGames,                  NOWHERE),_
  (@FOLDERID_SavedSearches,               NOWHERE),_
  (@FOLDERID_SEARCH_CSC,                  NOWHERE),_
  (@FOLDERID_SearchHome,                  NOWHERE),_
  (@FOLDERID_SEARCH_MAPI,                 NOWHERE),_
  (@FOLDERID_SendTo,                 BIND CSIDL_SENDTO),_
  (@FOLDERID_SidebarDefaultParts,         NOWHERE),_
  (@FOLDERID_SidebarParts,                NOWHERE),_
  (@FOLDERID_StartMenu,              BIND CSIDL_STARTMENU),_
  (@FOLDERID_Startup,                     CSIDL_STARTUP),_ 'CSIDL_ALTSTARTUP
  (@FOLDERID_SyncManagerFolder,           NOWHERE),_
  (@FOLDERID_SyncResultsFolder,           NOWHERE),_
  (@FOLDERID_SyncSetupFolder,             NOWHERE),_
  (@FOLDERID_System,                      CSIDL_SYSTEM),_
  (@FOLDERID_SystemX86,                   CSIDL_SYSTEMX86),_
  (@FOLDERID_Templates,              BIND CSIDL_TEMPLATES),_
  (@FOLDERID_UserPinned,                  NOWHERE),_
  (@FOLDERID_UserProfiles,                NOWHERE),_
  (@FOLDERID_UserProgramFiles,            NOWHERE),_
  (@FOLDERID_UserProgramFilesCommon,      NOWHERE),_
  (@FOLDERID_UsersFiles,                  NOWHERE),_
  (@FOLDERID_UsersLibraries,              NOWHERE),_
  (@FOLDERID_Videos,                 BIND CSIDL_MYVIDEO),_
  (@FOLDERID_VideosLibrary,               NOWHERE),_
  (@FOLDERID_Windows,                     CSIDL_WINDOWS)_
}

function kfid2clsid(pKfid as const REFKNOWNFOLDERID, pCsidl as INT ptr) as WINBOOL
  dim i as integer
  dim pkc as kcmItem ptr
  
  for i=0 to ubound(kcMap)
    pkc = @kcMap(i)
    
    if pkc->isBound=0 orelse pkc->csidl=NOWHERE then continue for
    if IsEqualGUID(pKfid, pkc->pKfid) then
      'preserve flags, if any
      *pCsidl = pkc->csidl or (*pCsidl and CSIDL_FLAG_MASK)
      return TRUE
    end if
  next
  return FALSE
end function