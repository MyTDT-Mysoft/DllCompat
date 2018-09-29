/*
 *  MKLINK.C - mklink internal command.
 */
#define UNICODE

#include <stdio.h>
#include <shlwapi.h>
#include <winioctl.h>
#include <malloc.h>
#include <ntdef.h>
#include <wchar.h>

typedef struct _CURDIR {
    UNICODE_STRING DosPath;
    PVOID Handle;
} CURDIR, *PCURDIR;

typedef struct _FileProperties {
    union {
        int data;
        struct {
            int isValid       : 1;
            int isExist       : 1;
            int isFolder      : 1;
            int isFolderEmpty : 1;
        };
    };
} FileProperties_t;

#define DECLFUNC(NAME, RET, PARAMS) typedef RET(WINAPI *NAME##_t)PARAMS; static NAME##_t p##NAME
#define GPA(HND, NAME) p##NAME = (NAME##_t)GetProcAddress(HND, #NAME)
DECLFUNC(RtlDosPathNameToNtPathName_U, BOOLEAN, (PCWSTR, PUNICODE_STRING, PCWSTR*, CURDIR*));
DECLFUNC(RtlFreeUnicodeString, VOID, (PUNICODE_STRING));
DECLFUNC(CreateSymbolicLinkW, BOOL, (LPCWSTR, LPCWSTR, DWORD));
DECLFUNC(CreateHardLinkW, BOOL, (LPCWSTR, LPCWSTR, LPSECURITY_ATTRIBUTES));

char s_mklink_help[] =
    "\nCreates a filesystem link object.\n\n"
    "MKLINK /SHJ Link Target\n\n"
    "  S     Create a symbolic link.\n"
    "  H     Create a hard link.\n"
    "  J     Create a junction.\n"
    "Link    Name of new file/folder that will become the link.\n"
    "Target  Existing file/folder that the new link refers to.\n\n"
    "         symb   hard   junc\n"
    "file      x      x         \n"
    "folder    x             x  \n";

/* There is no API for creating junctions, so we must do it the hard way */
static BOOL CreateJunction(LPCWSTR LinkName, LPCWSTR TargetName) {
    WCHAR TargetFullPath[MAX_PATH];
    UNICODE_STRING TargetNTPath;
    HANDLE hJunction;

    /* The data for this kind of reparse point has two strings:
     * The first ("SubstituteName") is the full target path in NT format,
     * the second ("PrintName") is the full target path in Win32 format.
     * Both of these must be wide-character strings. */
    if (!GetFullPathNameW(TargetName, MAX_PATH, TargetFullPath, NULL) || !pRtlDosPathNameToNtPathName_U(TargetFullPath, &TargetNTPath, NULL, NULL)) {
        return FALSE;
    }

    /* We have both the names we need, so time to create the junction.
     * Start with an empty directory */
    if (!(PathIsDirectoryEmptyW(LinkName) || CreateDirectoryW(LinkName, NULL))) {
        pRtlFreeUnicodeString(&TargetNTPath);
        return FALSE;
    }

    /* Open the directory we just created */
    hJunction = CreateFileW(LinkName, GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, NULL);
    if (hJunction != INVALID_HANDLE_VALUE) {
        /* Allocate a buffer large enough to hold both strings, including trailing NULs */
        SIZE_T TargetLen = wcslen(TargetFullPath) * sizeof(WCHAR);
        DWORD DataSize = (DWORD)(FIELD_OFFSET(REPARSE_DATA_BUFFER, MountPointReparseBuffer.PathBuffer) + TargetNTPath.Length + sizeof(WCHAR) + TargetLen + sizeof(WCHAR));
        PREPARSE_DATA_BUFFER Data = _alloca(DataSize); //check successful allocation

        /* Fill it out and use it to turn the directory into a reparse point */
        Data->ReparseTag = IO_REPARSE_TAG_MOUNT_POINT;
        Data->ReparseDataLength = (WORD)(DataSize - FIELD_OFFSET(REPARSE_DATA_BUFFER, MountPointReparseBuffer));
        Data->Reserved = 0;
        Data->MountPointReparseBuffer.SubstituteNameOffset = 0;
        Data->MountPointReparseBuffer.SubstituteNameLength = TargetNTPath.Length;
        wcscpy(Data->MountPointReparseBuffer.PathBuffer, TargetNTPath.Buffer);
        Data->MountPointReparseBuffer.PrintNameOffset = TargetNTPath.Length + sizeof(WCHAR);
        Data->MountPointReparseBuffer.PrintNameLength = (USHORT)TargetLen;
        wcscpy((WCHAR *)((BYTE *)Data->MountPointReparseBuffer.PathBuffer + Data->MountPointReparseBuffer.PrintNameOffset), TargetFullPath);
        if (DeviceIoControl(hJunction, FSCTL_SET_REPARSE_POINT, Data, DataSize, NULL, 0, &DataSize, NULL)) {
            /* Success */
            CloseHandle(hJunction);
            pRtlFreeUnicodeString(&TargetNTPath);
            return TRUE;
        }
        CloseHandle(hJunction);
    }
    RemoveDirectoryW(LinkName);
    pRtlFreeUnicodeString(&TargetNTPath);
    return FALSE;
}

void CheckPath(LPCWSTR path, FileProperties_t* f) {
    f->data = 0;
    if (PathFileExistsW(path)) {
        f->isExist = f->isValid = 1;
        if (PathIsDirectoryW(path)) {
            f->isFolder = 1;
            if (PathIsDirectoryEmptyW(path)) {
                f-> isFolderEmpty = 1;
            }
        }
    }
    //TODO: f->isValid
}

#define CRAPOUT(err) {printf(err); goto BADEND;}
int main(int argc, char* argv[]) {
    enum { M_NONE, M_SYMB, M_HARD, M_JUNC } mode = M_NONE;
    int argcw; LPWSTR* argvw;
    LPWSTR link, target;
    FileProperties_t fl, ft;
    BYTE canHardLink, canSymbLink, canJuncLink;
    
    (void)argv; (void) argc;
    argvw = CommandLineToArgvW(GetCommandLineW(), &argcw);
    
    HMODULE hNtdll = GetModuleHandleA("NTDLL");
    if (hNtdll) {
        GPA(hNtdll, RtlDosPathNameToNtPathName_U);
        GPA(hNtdll, RtlFreeUnicodeString);
    }
    HMODULE hKernel32 = GetModuleHandleA("KERNEL32");
    if (hKernel32) {
        GPA(hKernel32, CreateSymbolicLinkW);
        GPA(hKernel32, CreateHardLinkW);
    }

    if (argcw < 2)  CRAPOUT(s_mklink_help);
    if (argcw != 4) CRAPOUT("Invalid parameters\n");
    
    link = argvw[2]; target = argvw[3];
    CheckPath(link, &fl);
    CheckPath(target, &ft);
    canSymbLink = !!pCreateSymbolicLinkW;
    canHardLink = !!pCreateHardLinkW;
    canJuncLink = !!(pRtlFreeUnicodeString || pRtlFreeUnicodeString);
    if      (!wcscmp(argvw[1], L"/S")) mode = M_SYMB;
    else if (!wcscmp(argvw[1], L"/H")) mode = M_HARD;
    else if (!wcscmp(argvw[1], L"/J")) mode = M_JUNC;
    else CRAPOUT("Invalid parameters\n");
    
    if (!ft.isExist)                                          CRAPOUT("Target file/folder does not exist\n");
    if ((mode != M_JUNC) && fl.isExist)                       CRAPOUT("Link file/folder already exists\n");
    if ((mode == M_SYMB) && !canSymbLink)                     CRAPOUT("Symbolic links not supported on this system\n");
    if ((mode == M_HARD) && !canHardLink)                     CRAPOUT("Hardlinks not supported on this system\n");
    if ((mode == M_JUNC) && !canJuncLink)                     CRAPOUT("Junctions not supported on this system\n");
    if ((mode == M_HARD) && ft.isFolder)                      CRAPOUT("Hardlink target cannot be a folder\n");
    if ((mode == M_JUNC) && fl.isFolder && !fl.isFolderEmpty) CRAPOUT("Junction link is a non-empty folder\n");
    if ((mode == M_JUNC) && !ft.isFolder)                     CRAPOUT("Junction target cannot be a file\n");
    
    if        (mode == M_SYMB) {
        if (pCreateSymbolicLinkW(link, target, (ft.isFolder ? SYMBOLIC_LINK_FLAG_DIRECTORY : 0))) {
            wprintf(L"Symbolic link created for %ls <<=== %ls\n", link, target);
        } else {
            CRAPOUT("Failed symbolic link creation\n");
        }
    } else if (mode == M_HARD) {
        if (pCreateHardLinkW(link, target, NULL)) {
            wprintf(L"Hardlink created for %ws <<=== %ws\n", link, target);
        } else {
            CRAPOUT("Failed hard link creation\n");
        }
    } else if (mode == M_JUNC) {
        if (CreateJunction(link, target)) {
            wprintf(L"Junction created for %ls <<=== %ls\n", link, target);
        } else {
            CRAPOUT("Failed junction creation\n");
        }
    }
    return 0;
    
    BADEND:
    if (argvw) LocalFree(argvw);
    return 1;
}