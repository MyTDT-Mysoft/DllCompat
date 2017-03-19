// Compilation of F:\FB15\Projetos\GameTools\DllCompat\kernel3x.bas started at 18:31:19 on 02-03-2017

typedef   signed char       int8;
typedef unsigned char      uint8;
typedef   signed short      int16;
typedef unsigned short     uint16;
typedef   signed int        int32;
typedef unsigned int       uint32;
typedef   signed long long  int64;
typedef unsigned long long uint64;
typedef struct { char *data; int32 len; int32 size; } FBSTRING;
#define __FB_STATIC_ASSERT( expr ) extern int __$fb_structsizecheck[(expr) ? 1 : -1]
struct $11HINSTANCE__ {
	int32 I;
};
__FB_STATIC_ASSERT( sizeof( struct $11HINSTANCE__ ) == 4 );
typedef int32 __stdcall (*tmp$17)( void );
struct $16__FB_ARRAYDIMTB$ {
	int32 ELEMENTS;
	int32 LBOUND;
	int32 UBOUND;
};
__FB_STATIC_ASSERT( sizeof( struct $16__FB_ARRAYDIMTB$ ) == 12 );
struct $6HWND__ {
	int32 I;
};
__FB_STATIC_ASSERT( sizeof( struct $6HWND__ ) == 4 );
struct __attribute__((gcc_struct)) $16IMAGE_DOS_HEADER {
	uint16 E_MAGIC;
	uint16 E_CBLP;
	uint16 E_CP;
	uint16 E_CRLC;
	uint16 E_CPARHDR;
	uint16 E_MINALLOC;
	uint16 E_MAXALLOC;
	uint16 E_SS;
	uint16 E_SP;
	uint16 E_CSUM;
	uint16 E_IP;
	uint16 E_CS;
	uint16 E_LFARLC;
	uint16 E_OVNO;
	uint16 E_RES[4];
	uint16 E_OEMID;
	uint16 E_OEMINFO;
	uint16 E_RES2[10];
	int32 E_LFANEW __attribute__((packed, aligned(2)));
};
__FB_STATIC_ASSERT( sizeof( struct $16IMAGE_DOS_HEADER ) == 64 );
struct $17IMAGE_FILE_HEADER {
	uint16 MACHINE;
	uint16 NUMBEROFSECTIONS;
	uint32 TIMEDATESTAMP;
	uint32 POINTERTOSYMBOLTABLE;
	uint32 NUMBEROFSYMBOLS;
	uint16 SIZEOFOPTIONALHEADER;
	uint16 CHARACTERISTICS;
};
__FB_STATIC_ASSERT( sizeof( struct $17IMAGE_FILE_HEADER ) == 20 );
struct $20IMAGE_DATA_DIRECTORY {
	uint32 VIRTUALADDRESS;
	uint32 SIZE;
};
__FB_STATIC_ASSERT( sizeof( struct $20IMAGE_DATA_DIRECTORY ) == 8 );
struct $21IMAGE_OPTIONAL_HEADER {
	uint16 MAGIC;
	uint8 MAJORLINKERVERSION;
	uint8 MINORLINKERVERSION;
	uint32 SIZEOFCODE;
	uint32 SIZEOFINITIALIZEDDATA;
	uint32 SIZEOFUNINITIALIZEDDATA;
	uint32 ADDRESSOFENTRYPOINT;
	uint32 BASEOFCODE;
	uint32 BASEOFDATA;
	uint32 IMAGEBASE;
	uint32 SECTIONALIGNMENT;
	uint32 FILEALIGNMENT;
	uint16 MAJOROPERATINGSYSTEMVERSION;
	uint16 MINOROPERATINGSYSTEMVERSION;
	uint16 MAJORIMAGEVERSION;
	uint16 MINORIMAGEVERSION;
	uint16 MAJORSUBSYSTEMVERSION;
	uint16 MINORSUBSYSTEMVERSION;
	uint32 RESERVED1;
	uint32 SIZEOFIMAGE;
	uint32 SIZEOFHEADERS;
	uint32 CHECKSUM;
	uint16 SUBSYSTEM;
	uint16 DLLCHARACTERISTICS;
	uint32 SIZEOFSTACKRESERVE;
	uint32 SIZEOFSTACKCOMMIT;
	uint32 SIZEOFHEAPRESERVE;
	uint32 SIZEOFHEAPCOMMIT;
	uint32 LOADERFLAGS;
	uint32 NUMBEROFRVAANDSIZES;
	struct $20IMAGE_DATA_DIRECTORY DATADIRECTORY[16];
};
__FB_STATIC_ASSERT( sizeof( struct $21IMAGE_OPTIONAL_HEADER ) == 224 );
struct $16IMAGE_NT_HEADERS {
	uint32 SIGNATURE;
	struct $17IMAGE_FILE_HEADER FILEHEADER;
	struct $21IMAGE_OPTIONAL_HEADER OPTIONALHEADER;
};
__FB_STATIC_ASSERT( sizeof( struct $16IMAGE_NT_HEADERS ) == 248 );
struct $22IMAGE_EXPORT_DIRECTORY {
	uint32 CHARACTERISTICS;
	uint32 TIMEDATESTAMP;
	uint16 MAJORVERSION;
	uint16 MINORVERSION;
	uint32 NAME;
	uint32 BASE;
	uint32 NUMBEROFFUNCTIONS;
	uint32 NUMBEROFNAMES;
	uint32** ADDRESSOFFUNCTIONS;
	uint32** ADDRESSOFNAMES;
	uint16** ADDRESSOFNAMEORDINALS;
};
__FB_STATIC_ASSERT( sizeof( struct $22IMAGE_EXPORT_DIRECTORY ) == 40 );
struct $20IMAGE_IMPORT_BY_NAME {
	uint16 HINT;
	uint8 NAME[1];
};
__FB_STATIC_ASSERT( sizeof( struct $20IMAGE_IMPORT_BY_NAME ) == 4 );
union $19IMAGE_THUNK_DATA_U1 {
	uint8* FORWARDERSTRING;
	uint32* FUNCTION;
	uint32 ORDINAL;
	struct $20IMAGE_IMPORT_BY_NAME* ADDRESSOFDATA;
};
__FB_STATIC_ASSERT( sizeof( union $19IMAGE_THUNK_DATA_U1 ) == 4 );
struct $16IMAGE_THUNK_DATA {
	union $19IMAGE_THUNK_DATA_U1 U1;
};
__FB_STATIC_ASSERT( sizeof( struct $16IMAGE_THUNK_DATA ) == 4 );
struct $23IMAGE_IMPORT_DESCRIPTOR {
	union {
		uint32 CHARACTERISTICS;
		struct $16IMAGE_THUNK_DATA* ORIGINALFIRSTTHUNK;
	};
	uint32 TIMEDATESTAMP;
	uint32 FORWARDERCHAIN;
	uint32 NAME;
	struct $16IMAGE_THUNK_DATA* FIRSTTHUNK;
};
__FB_STATIC_ASSERT( sizeof( struct $23IMAGE_IMPORT_DESCRIPTOR ) == 20 );
struct $19SECURITY_ATTRIBUTES {
	uint32 NLENGTH;
	void* LPSECURITYDESCRIPTOR;
	int32 BINHERITHANDLE;
};
__FB_STATIC_ASSERT( sizeof( struct $19SECURITY_ATTRIBUTES ) == 12 );
struct $16CRITICAL_SECTION;
struct $10LIST_ENTRY;
struct $10LIST_ENTRY {
	struct $10LIST_ENTRY* FLINK;
	struct $10LIST_ENTRY* BLINK;
};
__FB_STATIC_ASSERT( sizeof( struct $10LIST_ENTRY ) == 8 );
struct $22CRITICAL_SECTION_DEBUG {
	uint16 TYPE;
	uint16 CREATORBACKTRACEINDEX;
	struct $16CRITICAL_SECTION* CRITICALSECTION;
	struct $10LIST_ENTRY PROCESSLOCKSLIST;
	uint32 ENTRYCOUNT;
	uint32 CONTENTIONCOUNT;
	uint32 SPARE[2];
};
__FB_STATIC_ASSERT( sizeof( struct $22CRITICAL_SECTION_DEBUG ) == 32 );
struct $16CRITICAL_SECTION {
	struct $22CRITICAL_SECTION_DEBUG* DEBUGINFO;
	int32 LOCKCOUNT;
	int32 RECURSIONCOUNT;
	void* OWNINGTHREAD;
	void* LOCKSEMAPHORE;
	uint32 SPINCOUNT;
};
__FB_STATIC_ASSERT( sizeof( struct $16CRITICAL_SECTION ) == 24 );
struct $17_OSVERSIONINFOEXW {
	uint32 DWOSVERSIONINFOSIZE;
	uint32 DWMAJORVERSION;
	uint32 DWMINORVERSION;
	uint32 DWBUILDNUMBER;
	uint32 DWPLATFORMID;
	uint16 SZCSDVERSION[128];
	uint16 WSERVICEPACKMAJOR;
	uint16 WSERVICEPACKMINOR;
	uint16 WSUITEMASK;
	uint8 WPRODUCTTYPE;
	uint8 WRESERVED;
};
__FB_STATIC_ASSERT( sizeof( struct $17_OSVERSIONINFOEXW ) == 284 );
struct $17_OSVERSIONINFOEXA {
	uint32 DWOSVERSIONINFOSIZE;
	uint32 DWMAJORVERSION;
	uint32 DWMINORVERSION;
	uint32 DWBUILDNUMBER;
	uint32 DWPLATFORMID;
	uint8 SZCSDVERSION[128];
	uint16 WSERVICEPACKMAJOR;
	uint16 WSERVICEPACKMINOR;
	uint16 WSUITEMASK;
	uint8 WPRODUCTTYPE;
	uint8 WRESERVED;
};
__FB_STATIC_ASSERT( sizeof( struct $17_OSVERSIONINFOEXA ) == 156 );
struct $18slpi_ProcessorCore {
	uint8 FLAGS;
};
__FB_STATIC_ASSERT( sizeof( struct $18slpi_ProcessorCore ) == 1 );
struct $13slpi_NumaNode {
	int32 NODENUMBER;
};
__FB_STATIC_ASSERT( sizeof( struct $13slpi_NumaNode ) == 4 );
struct $36SYSTEM_LOGICAL_PROCESSOR_INFORMATION {
	uint32 PROCESSORMASK;
	int32 RELATIONSHIP;
	union {
		struct $18slpi_ProcessorCore PROCESSORCORE;
		struct $13slpi_NumaNode NUMANODE;
	};
	int32 CACHE;
	uint64 RESERVED[2];
};
__FB_STATIC_ASSERT( sizeof( struct $36SYSTEM_LOGICAL_PROCESSOR_INFORMATION ) == 32 );
struct $4RECT {
	int32 LEFT;
	int32 TOP;
	int32 RIGHT;
	int32 BOTTOM;
};
__FB_STATIC_ASSERT( sizeof( struct $4RECT ) == 16 );
struct $5POINT {
	int32 X;
	int32 Y;
};
__FB_STATIC_ASSERT( sizeof( struct $5POINT ) == 8 );
typedef int32 __stdcall (*tmp$43)( struct $6HWND__*, uint32, uint32, int32 );
struct $7HMENU__ {
	int32 I;
};
__FB_STATIC_ASSERT( sizeof( struct $7HMENU__ ) == 4 );
typedef void __stdcall (*tmp$44)( struct $6HWND__*, uint32, uint32, uint32 );
struct $5HDC__ {
	int32 I;
};
__FB_STATIC_ASSERT( sizeof( struct $5HDC__ ) == 4 );
struct $21PIXELFORMATDESCRIPTOR {
	uint16 NSIZE;
	uint16 NVERSION;
	uint32 DWFLAGS;
	uint8 IPIXELTYPE;
	uint8 CCOLORBITS;
	uint8 CREDBITS;
	uint8 CREDSHIFT;
	uint8 CGREENBITS;
	uint8 CGREENSHIFT;
	uint8 CBLUEBITS;
	uint8 CBLUESHIFT;
	uint8 CALPHABITS;
	uint8 CALPHASHIFT;
	uint8 CACCUMBITS;
	uint8 CACCUMREDBITS;
	uint8 CACCUMGREENBITS;
	uint8 CACCUMBLUEBITS;
	uint8 CACCUMALPHABITS;
	uint8 CDEPTHBITS;
	uint8 CSTENCILBITS;
	uint8 CAUXBUFFERS;
	uint8 ILAYERTYPE;
	uint8 BRESERVED;
	uint32 DWLAYERMASK;
	uint32 DWVISIBLEMASK;
	uint32 DWDAMAGEMASK;
};
__FB_STATIC_ASSERT( sizeof( struct $21PIXELFORMATDESCRIPTOR ) == 40 );
FBSTRING* __stdcall fb_StrAssign( void*, int32, void*, int32, int32 );
uint16* __stdcall fb_WstrAssign( uint16*, int32, uint16* );
int32 __stdcall fb_StrCompare( void*, int32, void*, int32 );
void __stdcall fb_Init( int32, uint8**, int32 );
static int32 tmp$2( int32, uint8** );
int32 strcmp( uint8*, uint8* );
int32 __stdcall CloseHandle( void* );
void __stdcall EnterCriticalSection( struct $16CRITICAL_SECTION* );
void* __stdcall GetCurrentProcess( void );
void* __stdcall GetCurrentThread( void );
uint32 __stdcall GetLastError( void );
tmp$17 __stdcall GetProcAddress( struct $11HINSTANCE__*, uint8* );
int32 __stdcall GetProcessAffinityMask( void*, uint32*, uint32* );
int32 __stdcall InitializeCriticalSectionAndSpinCount( struct $16CRITICAL_SECTION*, uint32 );
int32 __stdcall IsBadWritePtr( void*, uint32 );
void __stdcall LeaveCriticalSection( struct $16CRITICAL_SECTION* );
int32 __stdcall ReleaseMutex( void* );
int32 __stdcall SetEvent( void* );
void __stdcall SetLastError( uint32 );
int32 __stdcall SetThreadPriority( void*, int32 );
int32 __stdcall VirtualProtect( void*, uint32, uint32, uint32* );
uint32 __stdcall WaitForSingleObject( void*, uint32 );
void* __stdcall CreateEventA( struct $19SECURITY_ATTRIBUTES*, int32, int32, uint8* );
void* __stdcall CreateMutexA( struct $19SECURITY_ATTRIBUTES*, int32, uint8* );
struct $11HINSTANCE__* __stdcall GetModuleHandleA( uint8* );
struct $11HINSTANCE__* __stdcall LoadLibraryA( uint8* );
void __stdcall OutputDebugStringA( uint8* );
int32 __stdcall ClientToScreen( struct $6HWND__*, struct $5POINT* );
struct $6HWND__* __stdcall GetForegroundWindow( void );
int32 __stdcall GetWindowRect( struct $6HWND__*, struct $4RECT* );
int32 __stdcall KillTimer( struct $6HWND__*, uint32 );
void __stdcall mouse_event( uint32, uint32, uint32, uint32, uint32 );
int32 __stdcall SetCursorPos( int32, int32 );
int32 __stdcall SetForegroundWindow( struct $6HWND__* );
uint32 __stdcall SetTimer( struct $6HWND__*, uint32, uint32, tmp$44 );
int32 __stdcall CallWindowProcA( tmp$43, struct $6HWND__*, uint32, uint32, int32 );
int32 __stdcall MessageBoxA( struct $6HWND__*, uint8*, uint8*, uint32 );
int32 __stdcall SetWindowLongA( struct $6HWND__*, int32, int32 );
int32 __stdcall GetLocaleInfoW( uint32, uint32, uint16*, int32 );
int32 __stdcall MYPROC( struct $6HWND__*, int32, uint32, int32 );
struct $6_IOBUF {
	uint8* _PTR;
	int32 _CNT;
	uint8* _BASE;
	int32 _FLAG;
	int32 _FILE;
	int32 _CHARBUF;
	int32 _BUFSIZ;
	uint8* _TMPFNAME;
};
__FB_STATIC_ASSERT( sizeof( struct $6_IOBUF ) == 32 );
struct $8FBARRAY1I6_IOBUFE {
	struct $6_IOBUF* DATA;
	struct $6_IOBUF* PTR;
	int32 SIZE;
	int32 ELEMENT_LEN;
	int32 DIMENSIONS;
	struct $16__FB_ARRAYDIMTB$ DIMTB[1];
};
__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1I6_IOBUFE ) == 32 );
static struct $8FBARRAY1I6_IOBUFE tmp$75;
static void* PINITMUTEX$;
static void* ORGPROC$;
static struct $6HWND__* SPLASHWND$;
typedef struct $6HWND__* __stdcall (*tmp$110)( uint32, void*, void*, uint32, int32, int32, int32, int32, struct $6HWND__*, struct $7HMENU__*, struct $11HINSTANCE__*, void* );
static tmp$110 PFCREATEWINDOWEXW$;
static tmp$110 PFCREATEWINDOWEXA$;
typedef int32 __stdcall (*tmp$115)( struct $5HDC__*, struct $21PIXELFORMATDESCRIPTOR* );
static tmp$115 PFCHOOSEPIXELFORMAT$;

int32 __stdcall DllMain( void* __FB_DLLINSTANCE__$1, uint32 __FB_DLLREASON__$1, void* __FB_DLLRESERVED__$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4 );
	label$2:;
	fb$result$1 = 1;
	if( __FB_DLLREASON__$1 != 1u ) goto label$4;
	tmp$2( 0, (uint8**)0u );
	label$4:;
	label$3:;
	return fb$result$1;
}

void* __stdcall DetourFunction( uint8*, uint8*, void* ) asm("_DetourFunction");
void* __stdcall DetourFunction( uint8* zModule, uint8* zFunctionName, void* pNewFunction )
{
	void* fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$5:;
	static void* hModule;
	static void* hKernel;
	static void* hNTDLL;
	struct $7tLinked;
	struct $7tLinked {
		struct $7tLinked* PNEXT;
		struct $7tLinked* PPREV;
		void* RESERVED[2];
		void* PDLLBASE;
	};
	__FB_STATIC_ASSERT( sizeof( struct $7tLinked ) == 20 );
	static struct $7tLinked* pModList;
	if( zModule == (uint8*)0u ) goto label$8;
	{
		struct $11HINSTANCE__* vr$2 = GetModuleHandleA( zModule );
		hModule = (void*)vr$2;
		if( hModule != (void*)0u ) goto label$10;
		{
			struct $11HINSTANCE__* vr$4 = LoadLibraryA( zModule );
			hModule = (void*)vr$4;
			label$10:;
		}
	}
	label$8:;
	label$7:;
	if( ((-(hModule == (void*)0u) | -(zFunctionName == (uint8*)0u)) | -(pNewFunction == (void*)0u)) == 0 ) goto label$12;
	{
		fb$result = (void*)0u;
		goto label$6;
		label$12:;
	}
	if( pModList != (struct $7tLinked*)0u ) goto label$14;
	{
		typedef int32 __stdcall (*tmp$79)( void*, int32, void*, uint32, uint32* );
		tmp$79 NtQueryInfoProc;
		__builtin_memset( &NtQueryInfoProc, 0, 4 );
		struct $11HINSTANCE__* vr$13 = GetModuleHandleA( (uint8*)"NTDLL.DLL" );
		hNTDLL = (void*)vr$13;
		struct $11HINSTANCE__* vr$14 = GetModuleHandleA( (uint8*)"KERNEL32.DLL" );
		hKernel = (void*)vr$14;
		uint8 zQueryInfo[32];
		uint8* pzSrc;
		pzSrc = (uint8*)"OvRq`t~Agld~`o{y~|Cfzurkj\x1A";
		{
			int32 I;
			I = 0;
			label$18:;
			{
				*(uint8*)((uint8*)zQueryInfo + I) = (uint8)((int32)*(uint8*)(pzSrc + I) ^ (I + 1));
			}
			label$16:;
			I = I + 1;
			label$15:;
			if( I <= 25 ) goto label$18;
			label$17:;
		}
		tmp$17 vr$25 = GetProcAddress( (struct $11HINSTANCE__*)hNTDLL, (uint8*)zQueryInfo );
		NtQueryInfoProc = (tmp$79)vr$25;
		void* pPBI[6];
		__builtin_memset( (void**)pPBI, 0, 24 );
		struct $8FBARRAY1IPvE {
			void** DATA;
			void** PTR;
			int32 SIZE;
			int32 ELEMENT_LEN;
			int32 DIMENSIONS;
			struct $16__FB_ARRAYDIMTB$ DIMTB[1];
		};
		__FB_STATIC_ASSERT( sizeof( struct $8FBARRAY1IPvE ) == 32 );
		struct $8FBARRAY1IPvE tmp$83;
		*(void***)&tmp$83 = (void**)pPBI;
		*(void***)((uint8*)&tmp$83 + 4) = (void**)pPBI;
		*(int32*)((uint8*)&tmp$83 + 8) = 24;
		*(int32*)((uint8*)&tmp$83 + 12) = 4;
		*(int32*)((uint8*)&tmp$83 + 16) = 1;
		*(int32*)((uint8*)&tmp$83 + 20) = 6;
		*(int32*)((uint8*)&tmp$83 + 24) = 0;
		*(int32*)((uint8*)&tmp$83 + 28) = 5;
		uint32 iSz;
		__builtin_memset( &iSz, 0, 4 );
		int32 iResu;
		iResu = -(NtQueryInfoProc == (tmp$79)0u);
		if( iResu != 0 ) goto label$20;
		{
			void* vr$48 = GetCurrentProcess(  );
			int32 vr$49 = (NtQueryInfoProc)( vr$48, 0, (void*)pPBI, 24u, &iSz );
			iResu = -(vr$49 != 0);
			label$20:;
		}
		if( iResu == 0 ) goto label$22;
		{
			uint8 zA[24];
			uint8 zB[24];
			uint8* bA;
			__builtin_memset( &bA, 0, 4 );
			uint8* bB;
			__builtin_memset( &bB, 0, 4 );
			bA = (uint8*)"Gcjh`b'|f*Liy._US\x12";
			bB = (uint8*)"Oxwtbs'Fl}+Hhz`ec\x12";
			{
				int32 I;
				I = 0;
				label$26:;
				{
					*(uint8*)((uint8*)zA + I) = (uint8)((int32)*(uint8*)(bA + I) ^ (I + 1));
					*(uint8*)((uint8*)zB + I) = (uint8)((int32)*(uint8*)(bB + I) ^ (I + 1));
				}
				label$24:;
				I = I + 1;
				label$23:;
				if( I <= 17 ) goto label$26;
				label$25:;
			}
			MessageBoxA( (struct $6HWND__*)0u, (uint8*)zA, (uint8*)zB, 4112u );
			fb$result = (void*)0u;
			goto label$6;
		}
		label$22:;
		label$21:;
		void** pPeb;
		pPeb = (void**)*(void**)((uint8*)pPBI + 4);
		pPeb = (void**)*(void**)((uint8*)pPeb + 12);
		pModList = *(struct $7tLinked**)((uint8*)pPeb + 20);
	}
	label$14:;
	label$13:;
	struct $16IMAGE_DOS_HEADER* pDosHeader;
	pDosHeader = (struct $16IMAGE_DOS_HEADER*)hModule;
	struct $16IMAGE_NT_HEADERS* pNTHeader;
	pNTHeader = (struct $16IMAGE_NT_HEADERS*)((uint8*)pDosHeader + *(int32*)((uint8*)pDosHeader + 60));
	struct $21IMAGE_OPTIONAL_HEADER* pOptHeader;
	pOptHeader = (struct $21IMAGE_OPTIONAL_HEADER*)((uint8*)pNTHeader + 24);
	struct $22IMAGE_EXPORT_DIRECTORY* pExports;
	pExports = (struct $22IMAGE_EXPORT_DIRECTORY*)((uint8*)pDosHeader + *(int32*)((uint8*)pOptHeader + 96));
	uint32* pdName;
	pdName = (uint32*)((uint8*)pDosHeader + *(int32*)((uint8*)pExports + 32));
	uint32* pdAddress;
	pdAddress = (uint32*)((uint8*)pDosHeader + *(int32*)((uint8*)pExports + 28));
	uint16* pwNumToAddr;
	pwNumToAddr = (uint16*)((uint8*)pDosHeader + *(int32*)((uint8*)pExports + 36));
	void* pResult;
	__builtin_memset( &pResult, 0, 4 );
	{
		int32 CNT;
		CNT = 0;
		int32 tmp$86;
		tmp$86 = (int32)(*(uint32*)((uint8*)pExports + 24) + 4294967295u);
		goto label$27;
		label$30:;
		{
			int32 vr$92 = strcmp( (uint8*)((uint8*)pDosHeader + *(int32*)((uint8*)pdName + (CNT << 2))), zFunctionName );
			if( vr$92 != 0 ) goto label$32;
			{
				void* pFunc;
				pFunc = (void*)((uint8*)pDosHeader + *(int32*)((uint8*)pdAddress + ((int32)*(uint16*)((uint8*)pwNumToAddr + (CNT << 1)) << 2)));
				int32 OldProt;
				OldProt = 0;
				VirtualProtect( (void*)((uint8*)pdAddress + (CNT << 2)), 4u, 64u, (uint32*)&OldProt );
				*(uint32*)((uint8*)pdAddress + ((int32)*(uint16*)((uint8*)pwNumToAddr + (CNT << 1)) << 2)) = (uint32)pNewFunction - (uint32)pDosHeader;
				VirtualProtect( (void*)((uint8*)pdAddress + (CNT << 2)), 4u, (uint32)OldProt, (uint32*)&OldProt );
				pResult = pFunc;
				goto label$29;
			}
			label$32:;
			label$31:;
		}
		label$28:;
		CNT = CNT + 1;
		label$27:;
		if( CNT <= tmp$86 ) goto label$30;
		label$29:;
	}
	if( pResult != (void*)0u ) goto label$34;
	{
		fb$result = (void*)0u;
		goto label$6;
		label$34:;
	}
	struct $7tLinked* pModules;
	pModules = pModList;
	label$35:;
	{
		struct $7tLinked* tmp$87;
		tmp$87 = pModules;
		if( *(void**)((uint8*)tmp$87 + 16) != (void*)0u ) goto label$39;
		{
			goto label$36;
			label$39:;
		}
		struct $16IMAGE_DOS_HEADER* pDosHeader;
		pDosHeader = *(struct $16IMAGE_DOS_HEADER**)((uint8*)tmp$87 + 16);
		struct $16IMAGE_NT_HEADERS* pNTHeader;
		pNTHeader = (struct $16IMAGE_NT_HEADERS*)((uint8*)pDosHeader + *(int32*)((uint8*)pDosHeader + 60));
		struct $21IMAGE_OPTIONAL_HEADER* pOptHeader;
		pOptHeader = (struct $21IMAGE_OPTIONAL_HEADER*)((uint8*)pNTHeader + 24);
		struct $23IMAGE_IMPORT_DESCRIPTOR* pImp;
		pImp = (struct $23IMAGE_IMPORT_DESCRIPTOR*)((uint8*)pDosHeader + *(int32*)((uint8*)pOptHeader + 104));
		if( pImp == (struct $23IMAGE_IMPORT_DESCRIPTOR*)0u ) goto label$41;
		{
			label$42:;
			if( *(uint32*)((uint8*)pImp + 12) == 0u ) goto label$43;
			{
				struct $16IMAGE_THUNK_DATA* pThunkB;
				pThunkB = (struct $16IMAGE_THUNK_DATA*)((uint8*)pDosHeader + *(int32*)((uint8*)pImp + 16));
				label$44:;
				if( *(struct $20IMAGE_IMPORT_BY_NAME**)pThunkB == (struct $20IMAGE_IMPORT_BY_NAME*)0u ) goto label$45;
				{
					struct $20IMAGE_IMPORT_BY_NAME* pImpAddr;
					pImpAddr = *(struct $20IMAGE_IMPORT_BY_NAME**)pThunkB;
					if( (uint32)pImpAddr != (uint32)pResult ) goto label$47;
					{
						struct $20IMAGE_IMPORT_BY_NAME** pFunc;
						pFunc = (struct $20IMAGE_IMPORT_BY_NAME**)pThunkB;
						int32 OldProt;
						OldProt = 0;
						VirtualProtect( (void*)pFunc, 4u, 64u, (uint32*)&OldProt );
						int32 vr$136 = IsBadWritePtr( (void*)pFunc, 4u );
						if( vr$136 != 0 ) goto label$49;
						{
							*(struct $20IMAGE_IMPORT_BY_NAME**)pThunkB = (struct $20IMAGE_IMPORT_BY_NAME*)pNewFunction;
						}
						label$49:;
						label$48:;
						VirtualProtect( (void*)pFunc, 4u, (uint32)OldProt, (uint32*)&OldProt );
					}
					label$47:;
					label$46:;
					pThunkB = (struct $16IMAGE_THUNK_DATA*)((uint8*)pThunkB + 4);
				}
				goto label$44;
				label$45:;
				pImp = (struct $23IMAGE_IMPORT_DESCRIPTOR*)((uint8*)pImp + 20);
			}
			goto label$42;
			label$43:;
		}
		label$41:;
		label$40:;
		if( (-(*(struct $7tLinked**)tmp$87 == (struct $7tLinked*)0u) | -(*(struct $7tLinked**)tmp$87 == pModList)) == 0 ) goto label$51;
		{
			goto label$36;
			label$51:;
		}
		pModules = *(struct $7tLinked**)tmp$87;
	}
	label$37:;
	goto label$35;
	label$36:;
	fb$result = pResult;
	goto label$6;
	label$6:;
	return fb$result;
}

int32 __stdcall InitOnceExecuteOnce( void**, void*, void*, void* ) asm("_InitOnceExecuteOnce");
int32 __stdcall InitOnceExecuteOnce( void** pInit, void* pFN, void* pParm, void* pContext )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$52:;
	if( (-(pInit == (void**)0u) | -(pFN == (void*)0u)) == 0 ) goto label$55;
	{
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"Bad Parameters", (uint8*)"InitOnceExecuteOnce", 4096u );
		fb$result = 0;
		goto label$53;
	}
	label$55:;
	label$54:;
	if( pContext == (void*)0u ) goto label$57;
	{
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"Using context???", (uint8*)"InitOnceExecuteOnce", 4096u );
	}
	label$57:;
	label$56:;
	WaitForSingleObject( PINITMUTEX$, 4294967295u );
	if( *pInit != (void*)0u ) goto label$59;
	{
		void* vr$8 = CreateEventA( (struct $19SECURITY_ATTRIBUTES*)0u, 1, 0, (uint8*)0u );
		*pInit = vr$8;
		ReleaseMutex( PINITMUTEX$ );
	}
	goto label$58;
	label$59:;
	{
		void* hEvent;
		hEvent = *pInit;
		ReleaseMutex( PINITMUTEX$ );
		WaitForSingleObject( hEvent, 4294967295u );
		WaitForSingleObject( PINITMUTEX$, 4294967295u );
		if( *pInit == (void*)0u ) goto label$61;
		{
			ReleaseMutex( PINITMUTEX$ );
			SetLastError( 0u );
			fb$result = 1;
			goto label$53;
		}
		label$61:;
		label$60:;
		*pInit = (void*)0u;
		CloseHandle( hEvent );
		ReleaseMutex( PINITMUTEX$ );
		SetLastError( 87u );
		fb$result = 0;
		goto label$53;
	}
	label$58:;
	typedef int32 __stdcall (*tmp$91)( void*, void*, void* );
	tmp$91 pCall;
	pCall = (tmp$91)pFN;
	int32 vr$14 = (pCall)( (void*)pInit, pParm, pContext );
	if( vr$14 == 0 ) goto label$63;
	{
		SetEvent( *pInit );
		fb$result = 1;
		goto label$53;
	}
	goto label$62;
	label$63:;
	{
		WaitForSingleObject( PINITMUTEX$, 4294967295u );
		void* hMutex;
		hMutex = *pInit;
		*pInit = (void*)0u;
		SetEvent( hMutex );
		ReleaseMutex( PINITMUTEX$ );
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"Initialization failed", (uint8*)"InitOnceExecuteOnce", 4096u );
		fb$result = 0;
		goto label$53;
	}
	label$62:;
	label$53:;
	return fb$result;
}

void __stdcall InitializeConditionVariable( void** ) asm("_InitializeConditionVariable");
void __stdcall InitializeConditionVariable( void** pCondVar )
{
	label$64:;
	if( pCondVar != (void**)0u ) goto label$67;
	{
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"InitializeConditionVariable", (uint8*)"InitializeConditionVariable", 4096u );
		goto label$65;
	}
	label$67:;
	label$66:;
	void* vr$1 = CreateEventA( (struct $19SECURITY_ATTRIBUTES*)0u, 0, 0, (uint8*)0u );
	*pCondVar = vr$1;
	label$65:;
}

int32 __stdcall SleepConditionVariableCS( void**, void*, uint32 ) asm("_SleepConditionVariableCS");
int32 __stdcall SleepConditionVariableCS( void** pCondVar, void* pCrit, uint32 dwMili )
{
	int32 tmp$94;
	int32 tmp$95;
	int32 tmp$97;
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$68:;
	if( -(pCondVar == (void**)0u) != 0 ) goto label$70;
	tmp$94 = -(-(*pCondVar == (void*)0u) != 0);
	goto label$79;
	label$70:;
	tmp$94 = -1;
	label$79:;
	if( tmp$94 != 0 ) goto label$71;
	tmp$95 = -(-(pCrit == (void*)0u) != 0);
	goto label$80;
	label$71:;
	tmp$95 = -1;
	label$80:;
	if( tmp$95 == 0 ) goto label$73;
	{
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"SleepConditionVariableCS", (uint8*)"SleepConditionVariableCS", 4096u );
		fb$result = 0;
		goto label$69;
	}
	label$73:;
	label$72:;
	if( dwMili == 0u ) goto label$75;
	{
		LeaveCriticalSection( (struct $16CRITICAL_SECTION*)pCrit );
		label$75:;
	}
	uint32 iResu;
	uint32 vr$12 = WaitForSingleObject( *pCondVar, dwMili );
	iResu = vr$12;
	uint32 x;
	uint32 vr$13 = GetLastError(  );
	x = vr$13;
	if( dwMili == 0u ) goto label$77;
	{
		EnterCriticalSection( (struct $16CRITICAL_SECTION*)pCrit );
		label$77:;
	}
	SetLastError( x );
	if( iResu == 0u ) goto label$78;
	tmp$97 = 0;
	goto label$81;
	label$78:;
	tmp$97 = 1;
	label$81:;
	fb$result = tmp$97;
	goto label$69;
	label$69:;
	return fb$result;
}

void __stdcall WakeAllConditionVariable( void** ) asm("_WakeAllConditionVariable");
void __stdcall WakeAllConditionVariable( void** pCondVar )
{
	int32 tmp$98;
	label$82:;
	if( -(pCondVar == (void**)0u) != 0 ) goto label$84;
	tmp$98 = -(-(*pCondVar == (void*)0u) != 0);
	goto label$95;
	label$84:;
	tmp$98 = -1;
	label$95:;
	if( tmp$98 == 0 ) goto label$86;
	{
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"WakeAllConditionVariable", (uint8*)"WakeAllConditionVariable", 4096u );
		goto label$83;
	}
	label$86:;
	label$85:;
	{
		int32 CNT;
		CNT = 0;
		label$90:;
		{
			int32 vr$7 = SetEvent( *pCondVar );
			if( vr$7 != 0 ) goto label$92;
			{
				goto label$89;
				label$92:;
			}
			uint32 vr$10 = WaitForSingleObject( *pCondVar, 0u );
			if( vr$10 == 258u ) goto label$94;
			{
				goto label$89;
				label$94:;
			}
		}
		label$88:;
		CNT = CNT + 1;
		label$87:;
		if( CNT <= 999 ) goto label$90;
		label$89:;
	}
	label$83:;
}

void __stdcall WakeConditionVariable( void** ) asm("_WakeConditionVariable");
void __stdcall WakeConditionVariable( void** pCondVar )
{
	int32 tmp$100;
	label$96:;
	if( -(pCondVar == (void**)0u) != 0 ) goto label$98;
	tmp$100 = -(-(*pCondVar == (void*)0u) != 0);
	goto label$101;
	label$98:;
	tmp$100 = -1;
	label$101:;
	if( tmp$100 == 0 ) goto label$100;
	{
		MessageBoxA( (struct $6HWND__*)0u, (uint8*)"WakeConditionVariable", (uint8*)"WakeConditionVariable", 4096u );
		goto label$97;
	}
	label$100:;
	label$99:;
	SetEvent( *pCondVar );
	label$97:;
}

__asm__( ".globl _InterlockedCompareExchange64" );
__asm__( "_InterlockedCompareExchange64:" );
__asm__( push ebx );
__asm__( push ebp );
__asm__( mov ebp,[esp+12] );
__asm__( mov ebx,[esp+16+0] );
__asm__( mov ecx,[esp+16+4] );
__asm__( mov eax,[esp+24+0] );
__asm__( mov edx,[esp+24+4] );
__asm__( lock cmpxchg8b [ebp] );
__asm__( pop ebp );
__asm__( pop ebx );
__asm__( ret );

int32 __stdcall InitializeCriticalSectionEx( struct $16CRITICAL_SECTION*, uint32, uint32 ) asm("_InitializeCriticalSectionEx");
int32 __stdcall InitializeCriticalSectionEx( struct $16CRITICAL_SECTION* lpCriticalSection, uint32 dwSpinCount, uint32 Flags )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$104:;
	int32 vr$1 = InitializeCriticalSectionAndSpinCount( lpCriticalSection, dwSpinCount );
	fb$result = vr$1;
	goto label$105;
	label$105:;
	return fb$result;
}

int32 __stdcall GetSystemDefaultLocaleName( uint16*, int32 ) asm("_GetSystemDefaultLocaleName");
int32 __stdcall GetSystemDefaultLocaleName( uint16* lpwLocaleName, int32 cchLocaleName )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$106:;
	if( (-(lpwLocaleName == (uint16*)0u) | -(cchLocaleName <= 1)) == 0 ) goto label$109;
	{
		SetLastError( 122u );
		fb$result = 0;
		goto label$107;
	}
	label$109:;
	label$108:;
	uint16 wLocale[85];
	int32 iPos;
	int32 vr$6 = GetLocaleInfoW( 2048u, 89u, (uint16*)wLocale, 32 );
	iPos = vr$6;
	if( (-(iPos == 0) | -(iPos > cchLocaleName)) == 0 ) goto label$111;
	{
		SetLastError( 122u );
		fb$result = 0;
		goto label$107;
	}
	label$111:;
	label$110:;
	*(uint16*)((uint8*)((uint8*)wLocale + (iPos << 1)) + -2) = (uint16)45u;
	int32 iPos2;
	int32 vr$17 = GetLocaleInfoW( 2048u, 90u, (uint16*)((uint8*)wLocale + (iPos << 1)), 16 );
	iPos2 = vr$17;
	iPos = iPos + iPos2;
	if( (-(iPos2 == 0) | -(iPos > cchLocaleName)) == 0 ) goto label$113;
	{
		SetLastError( 122u );
		fb$result = 0;
		goto label$107;
	}
	label$113:;
	label$112:;
	fb$result = iPos;
	goto label$107;
	label$107:;
	return fb$result;
}

int32 __stdcall GetVersionExW( struct $17_OSVERSIONINFOEXW* ) asm("_GetVersionExW");
int32 __stdcall GetVersionExW( struct $17_OSVERSIONINFOEXW* pVerW )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$114:;
	if( pVerW != (struct $17_OSVERSIONINFOEXW*)0u ) goto label$117;
	{
		SetLastError( 87u );
		fb$result = 0;
		goto label$115;
		label$117:;
	}
	if( *(uint32*)pVerW >= 276u ) goto label$119;
	{
		SetLastError( 87u );
		fb$result = 0;
		goto label$115;
	}
	label$119:;
	label$118:;
	*(uint32*)((uint8*)pVerW + 4) = 6u;
	*(uint32*)((uint8*)pVerW + 8) = 1u;
	*(uint32*)((uint8*)pVerW + 12) = 9999u;
	*(uint32*)((uint8*)pVerW + 16) = 2u;
	uint16* vr$10 = fb_WstrAssign( (uint16*)((uint8*)pVerW + 20), 128, (uint16*)L"Service Pack 2" );
	if( *(uint32*)pVerW < 284u ) goto label$121;
	{
		*(uint16*)((uint8*)pVerW + 276) = (uint16)2u;
		*(uint16*)((uint8*)pVerW + 278) = (uint16)0u;
		*(uint16*)((uint8*)pVerW + 280) = (uint16)65535u;
		*(uint8*)((uint8*)pVerW + 282) = (uint8)1u;
	}
	label$121:;
	label$120:;
	fb$result = 1;
	goto label$115;
	label$115:;
	return fb$result;
}

int32 __stdcall GetVersionExA( struct $17_OSVERSIONINFOEXA* ) asm("_GetVersionExA");
int32 __stdcall GetVersionExA( struct $17_OSVERSIONINFOEXA* pVerA )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$122:;
	if( pVerA != (struct $17_OSVERSIONINFOEXA*)0u ) goto label$125;
	{
		SetLastError( 87u );
		fb$result = 0;
		goto label$123;
		label$125:;
	}
	if( *(uint32*)pVerA >= 148u ) goto label$127;
	{
		SetLastError( 87u );
		fb$result = 0;
		goto label$123;
	}
	label$127:;
	label$126:;
	*(uint32*)((uint8*)pVerA + 4) = 6u;
	*(uint32*)((uint8*)pVerA + 8) = 1u;
	*(uint32*)((uint8*)pVerA + 12) = 9999u;
	*(uint32*)((uint8*)pVerA + 16) = 2u;
	fb_StrAssign( (void*)((uint8*)pVerA + 20), 128, (void*)"Service Pack 2", 15, 0 );
	if( *(uint32*)pVerA < 284u ) goto label$129;
	{
		*(uint16*)((uint8*)pVerA + 148) = (uint16)2u;
		*(uint16*)((uint8*)pVerA + 150) = (uint16)0u;
		*(uint16*)((uint8*)pVerA + 152) = (uint16)65535u;
		*(uint8*)((uint8*)pVerA + 154) = (uint8)1u;
	}
	label$129:;
	label$128:;
	fb$result = 1;
	goto label$123;
	label$123:;
	return fb$result;
}

int32 __stdcall GetLogicalProcessorInformation( struct $36SYSTEM_LOGICAL_PROCESSOR_INFORMATION*, uint32* ) asm("_GetLogicalProcessorInformation");
int32 __stdcall GetLogicalProcessorInformation( struct $36SYSTEM_LOGICAL_PROCESSOR_INFORMATION* pBuffer, uint32* pReturnLength )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$130:;
	if( pBuffer != (struct $36SYSTEM_LOGICAL_PROCESSOR_INFORMATION*)0u ) goto label$133;
	{
		if( pReturnLength == (uint32*)0u ) goto label$135;
		{
			*pReturnLength = 32u;
			SetLastError( 122u );
		}
		goto label$134;
		label$135:;
		{
			SetLastError( 1u );
		}
		label$134:;
		fb$result = 0;
		goto label$131;
	}
	goto label$132;
	label$133:;
	{
		uint32 dwProc;
		__builtin_memset( &dwProc, 0, 4 );
		uint32 dwSys;
		__builtin_memset( &dwSys, 0, 4 );
		void* vr$8 = GetCurrentProcess(  );
		GetProcessAffinityMask( vr$8, &dwProc, &dwSys );
		*(uint32*)pBuffer = dwSys;
		*(int32*)((uint8*)pBuffer + 4) = 0;
		*(uint8*)((uint8*)pBuffer + 8) = (uint8)0u;
		fb$result = 1;
		goto label$131;
	}
	label$132:;
	label$131:;
	return fb$result;
}

int32 __stdcall VerifyVersionInfoW( struct $17_OSVERSIONINFOEXW*, uint32, uint32 ) asm("_VerifyVersionInfoW");
int32 __stdcall VerifyVersionInfoW( struct $17_OSVERSIONINFOEXW* lpVerW, uint32 dwType, uint32 dwCond )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$136:;
	fb$result = 1;
	goto label$137;
	label$137:;
	return fb$result;
}

int32 __stdcall VerifyVersionInfoA( struct $17_OSVERSIONINFOEXA*, uint32, uint32 ) asm("_VerifyVersionInfoA");
int32 __stdcall VerifyVersionInfoA( struct $17_OSVERSIONINFOEXA* lpVerA, uint32 dwType, uint32 dwCond )
{
	int32 fb$result;
	__builtin_memset( &fb$result, 0, 4 );
	label$138:;
	fb$result = 1;
	goto label$139;
	label$139:;
	return fb$result;
}

int32 __stdcall MYPROC( struct $6HWND__* HWND$1, int32 MSG$1, uint32 WPARAM$1, int32 LPARAM$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4 );
	label$140:;
	static int32 N$1 = 1;
	{
		if( MSG$1 != 275 ) goto label$143;
		label$144:;
		{
			struct $4RECT TTEMP$3;
			__builtin_memset( &TTEMP$3, 0, 16 );
			GetWindowRect( SPLASHWND$, &TTEMP$3 );
			if( (-(*(int32*)&TTEMP$3 != 0) & -(*(int32*)((uint8*)&TTEMP$3 + 4) != 0)) == 0 ) goto label$146;
			{
				{
					if( N$1 != 1 ) goto label$148;
					label$149:;
					{
						struct $5POINT MYPT$6;
						*(int32*)&MYPT$6 = 683;
						*(int32*)((uint8*)&MYPT$6 + 4) = 406;
						ClientToScreen( SPLASHWND$, &MYPT$6 );
						SetCursorPos( *(int32*)&MYPT$6, *(int32*)((uint8*)&MYPT$6 + 4) );
						struct $6HWND__* vr$12 = GetForegroundWindow(  );
						if( vr$12 == SPLASHWND$ ) goto label$151;
						{
							SetForegroundWindow( SPLASHWND$ );
						}
						label$151:;
						label$150:;
						N$1 = 2;
					}
					goto label$147;
					label$148:;
					if( N$1 != 2 ) goto label$152;
					label$153:;
					{
						mouse_event( 2u, 0u, 0u, 0u, 0u );
						N$1 = 3;
					}
					goto label$147;
					label$152:;
					if( N$1 != 3 ) goto label$154;
					label$155:;
					{
						mouse_event( 4u, 0u, 0u, 0u, 0u );
						N$1 = 1;
						OutputDebugStringA( (uint8*)"Clicking!\x0D\x0A" );
						goto label$141;
					}
					goto label$147;
					label$154:;
					{
						N$1 = N$1 + 1;
						if( N$1 <= 10 ) goto label$158;
						{
							N$1 = 1;
							label$158:;
						}
					}
					label$156:;
					label$147:;
				}
			}
			label$146:;
			label$145:;
		}
		goto label$142;
		label$143:;
		if( MSG$1 != 514 ) goto label$159;
		label$160:;
		{
			int32 vr$19 = CallWindowProcA( (tmp$43)ORGPROC$, HWND$1, (uint32)MSG$1, WPARAM$1, LPARAM$1 );
			fb$result$1 = vr$19;
			N$1 = 4;
			OutputDebugStringA( (uint8*)"Button up!\x0D\x0A" );
			goto label$141;
		}
		goto label$142;
		label$159:;
		if( MSG$1 != 2 ) goto label$161;
		label$162:;
		{
			KillTimer( SPLASHWND$, 1123u );
		}
		label$161:;
		label$142:;
	}
	int32 vr$21 = CallWindowProcA( (tmp$43)ORGPROC$, HWND$1, (uint32)MSG$1, WPARAM$1, LPARAM$1 );
	fb$result$1 = vr$21;
	goto label$141;
	label$141:;
	return fb$result$1;
}

struct $6HWND__* __stdcall CREATEWINDOWEXW_DETOUR( uint32 DWEXSTYLE$1, void* LPCLASSNAME$1, void* LPWINDOWNAME$1, uint32 DWSTYLE$1, int32 X$1, int32 Y$1, int32 NWIDTH$1, int32 NHEIGHT$1, struct $6HWND__* HWNDPARENT$1, struct $7HMENU__* HMENU$1, struct $11HINSTANCE__* HINSTANCE$1, void* LPPARAM$1 )
{
	struct $6HWND__* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4 );
	label$163:;
	if( (DWSTYLE$1 & 1073741824u) != 0u ) goto label$166;
	{
		DWEXSTYLE$1 = DWEXSTYLE$1 | 34078720u;
		label$166:;
	}
	struct $6HWND__* vr$4 = (PFCREATEWINDOWEXW$)( DWEXSTYLE$1, LPCLASSNAME$1, LPWINDOWNAME$1, DWSTYLE$1, X$1, Y$1, NWIDTH$1, NHEIGHT$1, HWNDPARENT$1, HMENU$1, HINSTANCE$1, LPPARAM$1 );
	fb$result$1 = vr$4;
	goto label$164;
	label$164:;
	return fb$result$1;
}

struct $6HWND__* __stdcall CREATEWINDOWEXA_DETOUR( uint32 DWEXSTYLE$1, void* LPCLASSNAME$1, void* LPWINDOWNAME$1, uint32 DWSTYLE$1, int32 X$1, int32 Y$1, int32 NWIDTH$1, int32 NHEIGHT$1, struct $6HWND__* HWNDPARENT$1, struct $7HMENU__* HMENU$1, struct $11HINSTANCE__* HINSTANCE$1, void* LPPARAM$1 )
{
	int32 TMP$111$1;
	int32 TMP$113$1;
	struct $6HWND__* fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4 );
	label$167:;
	int32 ISKIP$1;
	ISKIP$1 = 0;
	if( -((DWSTYLE$1 & 1073741824u) == 0u) == 0 ) goto label$169;
	TMP$111$1 = -(-((uint32)LPCLASSNAME$1 > 65535u) != 0);
	goto label$177;
	label$169:;
	TMP$111$1 = 0;
	label$177:;
	if( TMP$111$1 == 0 ) goto label$171;
	{
		int32 vr$7 = fb_StrCompare( LPCLASSNAME$1, 0, (void*)"MischiefSplashScreen", 21 );
		if( vr$7 != 0 ) goto label$173;
		{
			ISKIP$1 = 1;
			DWSTYLE$1 = DWSTYLE$1 | 268435456u;
			X$1 = 0;
			Y$1 = 0;
			void* vr$10 = GetCurrentThread(  );
			SetThreadPriority( vr$10, 15 );
		}
		label$173:;
		label$172:;
	}
	label$171:;
	label$170:;
	struct $6HWND__* HRESU$1;
	struct $6HWND__* vr$11 = (PFCREATEWINDOWEXA$)( DWEXSTYLE$1, LPCLASSNAME$1, LPWINDOWNAME$1, DWSTYLE$1, X$1, Y$1, NWIDTH$1, NHEIGHT$1, HWNDPARENT$1, HMENU$1, HINSTANCE$1, LPPARAM$1 );
	HRESU$1 = vr$11;
	if( HRESU$1 == (struct $6HWND__*)0u ) goto label$174;
	TMP$113$1 = -((struct $6HWND__*)ISKIP$1 != (struct $6HWND__*)0u);
	goto label$178;
	label$174:;
	TMP$113$1 = 0;
	label$178:;
	if( TMP$113$1 == 0 ) goto label$176;
	{
		int32 vr$15 = SetWindowLongA( HRESU$1, -4, (int32)&MYPROC );
		ORGPROC$ = (void*)vr$15;
		SetTimer( HRESU$1, 1123u, 1u, (tmp$44)0u );
		SPLASHWND$ = HRESU$1;
	}
	label$176:;
	label$175:;
	fb$result$1 = HRESU$1;
	goto label$168;
	label$168:;
	return fb$result$1;
}

int32 __stdcall CHOOSEPIXELFORMAT_DETOUR( struct $5HDC__* HDC$1, struct $21PIXELFORMATDESCRIPTOR* PPFD$1 )
{
	int32 fb$result$1;
	__builtin_memset( &fb$result$1, 0, 4 );
	label$179:;
	OutputDebugStringA( (uint8*)"ChoosePixelFormat_Detour\x0D\x0A" );
	int32 vr$1 = (PFCHOOSEPIXELFORMAT$)( HDC$1, PPFD$1 );
	fb$result$1 = vr$1;
	goto label$180;
	label$180:;
	return fb$result$1;
}

static int32 tmp$2( int32 __FB_ARGC__$0, uint8** __FB_ARGV__$0 )
{
	int32 fb$result$0;
	__builtin_memset( &fb$result$0, 0, 4 );
	fb_Init( __FB_ARGC__$0, __FB_ARGV__$0, 0 );
	label$0:;
	void* vr$1 = CreateMutexA( (struct $19SECURITY_ATTRIBUTES*)0u, 0, (uint8*)0u );
	PINITMUTEX$ = vr$1;
	label$1:;
	return fb$result$0;
}

__asm__( 
	".section .drectve\n"
	"\t.ascii \" -export:\\\"InitOnceExecuteOnce\\\"\"\n"
	"\t.ascii \" -export:\\\"InitializeConditionVariable\\\"\"\n"
	"\t.ascii \" -export:\\\"SleepConditionVariableCS\\\"\"\n"
	"\t.ascii \" -export:\\\"WakeAllConditionVariable\\\"\"\n"
	"\t.ascii \" -export:\\\"WakeConditionVariable\\\"\"\n"
	"\t.ascii \" -export:\\\"InterlockedCompareExchange64\\\"\"\n"
	"\t.ascii \" -export:\\\"InitializeCriticalSectionEx\\\"\"\n"
	"\t.ascii \" -export:\\\"GetSystemDefaultLocaleName\\\"\"\n"
	"\t.ascii \" -export:\\\"GetVersionExW\\\"\"\n"
	"\t.ascii \" -export:\\\"GetVersionExA\\\"\"\n"
	"\t.ascii \" -export:\\\"GetLogicalProcessorInformation\\\"\"\n"
	"\t.ascii \" -export:\\\"VerifyVersionInfoW\\\"\"\n"
	"\t.ascii \" -export:\\\"VerifyVersionInfoA\\\"\"\n"
);

// Total compilation time: 0.1008791987173883 seconds.
