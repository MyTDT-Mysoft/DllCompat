#pragma once

#include once "crt/long.bi"

extern "Windows"

#define _WINCRED_H_
#define WINADVAPI DECLSPEC_IMPORT
#define CREDUIAPI DECLSPEC_IMPORT

type _SecHandle
	dwLower as ULONG_PTR
	dwUpper as ULONG_PTR
end type

type SecHandle as _SecHandle
type PSecHandle as _SecHandle ptr
#define __SECHANDLE_DEFINED__
type PCtxtHandle as PSecHandle
#define _FILETIME_

#ifndef _FILETIME
  type _FILETIME
    dwLowDateTime as DWORD
    dwHighDateTime as DWORD
  end type
#endif

type FILETIME as _FILETIME
type PFILETIME as _FILETIME ptr
type LPFILETIME as _FILETIME ptr
type NTSTATUS as LONG
type PNTSTATUS as LONG ptr

const STATUS_LOGON_FAILURE = cast(NTSTATUS, cast(clong, &hC000006D))
const STATUS_WRONG_PASSWORD = cast(NTSTATUS, cast(clong, &hC000006A))
const STATUS_PASSWORD_EXPIRED = cast(NTSTATUS, cast(clong, &hC0000071))
const STATUS_PASSWORD_MUST_CHANGE = cast(NTSTATUS, cast(clong, &hC0000224))
const STATUS_ACCESS_DENIED = cast(NTSTATUS, cast(clong, &hC0000022))
const STATUS_DOWNGRADE_DETECTED = cast(NTSTATUS, cast(clong, &hC0000388))
const NERR_BASE = 2100
const NERR_PasswordExpired = NERR_BASE + 142
#define CREDUIP_IS_USER_PASSWORD_ERROR(_Status) (((((((((((((((_Status) = ERROR_LOGON_FAILURE) orelse ((_Status) = HRESULT_FROM_WIN32(ERROR_LOGON_FAILURE))) orelse ((_Status) = STATUS_LOGON_FAILURE)) orelse ((_Status) = HRESULT_FROM_NT(STATUS_LOGON_FAILURE))) orelse ((_Status) = ERROR_ACCESS_DENIED)) orelse ((_Status) = HRESULT_FROM_WIN32(ERROR_ACCESS_DENIED))) orelse ((_Status) = STATUS_ACCESS_DENIED)) orelse ((_Status) = HRESULT_FROM_NT(STATUS_ACCESS_DENIED))) orelse ((_Status) = ERROR_INVALID_PASSWORD)) orelse ((_Status) = HRESULT_FROM_WIN32(ERROR_INVALID_PASSWORD))) orelse ((_Status) = STATUS_WRONG_PASSWORD)) orelse ((_Status) = HRESULT_FROM_NT(STATUS_WRONG_PASSWORD))) orelse ((_Status) = SEC_E_NO_CREDENTIALS)) orelse ((_Status) = SEC_E_LOGON_DENIED))
#define CREDUIP_IS_DOWNGRADE_ERROR(_Status) (((((_Status) = ERROR_DOWNGRADE_DETECTED) orelse ((_Status) = HRESULT_FROM_WIN32(ERROR_DOWNGRADE_DETECTED))) orelse ((_Status) = STATUS_DOWNGRADE_DETECTED)) orelse ((_Status) = HRESULT_FROM_NT(STATUS_DOWNGRADE_DETECTED)))
#define CREDUIP_IS_EXPIRED_ERROR(_Status) (((((((((((_Status) = ERROR_PASSWORD_EXPIRED) orelse ((_Status) = HRESULT_FROM_WIN32(ERROR_PASSWORD_EXPIRED))) orelse ((_Status) = STATUS_PASSWORD_EXPIRED)) orelse ((_Status) = HRESULT_FROM_NT(STATUS_PASSWORD_EXPIRED))) orelse ((_Status) = ERROR_PASSWORD_MUST_CHANGE)) orelse ((_Status) = HRESULT_FROM_WIN32(ERROR_PASSWORD_MUST_CHANGE))) orelse ((_Status) = STATUS_PASSWORD_MUST_CHANGE)) orelse ((_Status) = HRESULT_FROM_NT(STATUS_PASSWORD_MUST_CHANGE))) orelse ((_Status) = NERR_PasswordExpired)) orelse ((_Status) = HRESULT_FROM_WIN32(NERR_PasswordExpired)))
#define CREDUI_IS_AUTHENTICATION_ERROR(_Status) ((CREDUIP_IS_USER_PASSWORD_ERROR(_Status) orelse CREDUIP_IS_DOWNGRADE_ERROR(_Status)) orelse CREDUIP_IS_EXPIRED_ERROR(_Status))
const CRED_MAX_STRING_LENGTH = 256
const CRED_MAX_USERNAME_LENGTH = (256 + 1) + 256
const CRED_MAX_GENERIC_TARGET_NAME_LENGTH = 32767
const CRED_MAX_DOMAIN_TARGET_NAME_LENGTH = (256 + 1) + 80
const CRED_MAX_VALUE_SIZE = 256
const CRED_MAX_ATTRIBUTES = 64

type _CREDENTIAL_ATTRIBUTEA
	Keyword as LPSTR
	Flags as DWORD
	ValueSize as DWORD
	Value as LPBYTE
end type

type CREDENTIAL_ATTRIBUTEA as _CREDENTIAL_ATTRIBUTEA
type PCREDENTIAL_ATTRIBUTEA as _CREDENTIAL_ATTRIBUTEA ptr

type _CREDENTIAL_ATTRIBUTEW
	Keyword as LPWSTR
	Flags as DWORD
	ValueSize as DWORD
	Value as LPBYTE
end type

type CREDENTIAL_ATTRIBUTEW as _CREDENTIAL_ATTRIBUTEW
type PCREDENTIAL_ATTRIBUTEW as _CREDENTIAL_ATTRIBUTEW ptr
type CREDENTIAL_ATTRIBUTE as CREDENTIAL_ATTRIBUTEA
type PCREDENTIAL_ATTRIBUTE as PCREDENTIAL_ATTRIBUTEA

#define CRED_SESSION_WILDCARD_NAME_W wstr("*Session")
#define CRED_SESSION_WILDCARD_NAME_A "*Session"
#define CRED_SESSION_WILDCARD_NAME_LENGTH (sizeof(CRED_SESSION_WILDCARD_NAME_A) - 1)
#define CRED_SESSION_WILDCARD_NAME CRED_SESSION_WILDCARD_NAME_A
const CRED_FLAGS_PASSWORD_FOR_CERT = &h0001
const CRED_FLAGS_PROMPT_NOW = &h0002
const CRED_FLAGS_USERNAME_TARGET = &h0004
const CRED_FLAGS_OWF_CRED_BLOB = &h0008
const CRED_FLAGS_VALID_FLAGS = &h000F
const CRED_TYPE_GENERIC = 1
const CRED_TYPE_DOMAIN_PASSWORD = 2
const CRED_TYPE_DOMAIN_CERTIFICATE = 3
const CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 4
const CRED_TYPE_MAXIMUM = 5
const CRED_MAX_CREDENTIAL_BLOB_SIZE = 512
const CRED_PERSIST_NONE = 0
const CRED_PERSIST_SESSION = 1
const CRED_PERSIST_LOCAL_MACHINE = 2
const CRED_PERSIST_ENTERPRISE = 3

type _CREDENTIALA
	Flags as DWORD
	as DWORD Type
	TargetName as LPSTR
	Comment as LPSTR
	LastWritten as FILETIME
	CredentialBlobSize as DWORD
	CredentialBlob as LPBYTE
	Persist as DWORD
	AttributeCount as DWORD
	Attributes as PCREDENTIAL_ATTRIBUTEA
	TargetAlias as LPSTR
	UserName as LPSTR
end type

type CREDENTIALA as _CREDENTIALA
type PCREDENTIALA as _CREDENTIALA ptr

type _CREDENTIALW
	Flags as DWORD
	as DWORD Type
	TargetName as LPWSTR
	Comment as LPWSTR
	LastWritten as FILETIME
	CredentialBlobSize as DWORD
	CredentialBlob as LPBYTE
	Persist as DWORD
	AttributeCount as DWORD
	Attributes as PCREDENTIAL_ATTRIBUTEW
	TargetAlias as LPWSTR
	UserName as LPWSTR
end type

type CREDENTIALW as _CREDENTIALW
type PCREDENTIALW as _CREDENTIALW ptr
type CREDENTIAL as CREDENTIALA
type PCREDENTIAL as PCREDENTIALA

const CRED_TI_SERVER_FORMAT_UNKNOWN = &h0001
const CRED_TI_DOMAIN_FORMAT_UNKNOWN = &h0002
const CRED_TI_ONLY_PASSWORD_REQUIRED = &h0004
const CRED_TI_USERNAME_TARGET = &h0008
const CRED_TI_CREATE_EXPLICIT_CRED = &h0010
const CRED_TI_WORKGROUP_MEMBER = &h0020
const CRED_TI_VALID_FLAGS = &h003F

type _CREDENTIAL_TARGET_INFORMATIONA
	TargetName as LPSTR
	NetbiosServerName as LPSTR
	DnsServerName as LPSTR
	NetbiosDomainName as LPSTR
	DnsDomainName as LPSTR
	DnsTreeName as LPSTR
	PackageName as LPSTR
	Flags as ULONG
	CredTypeCount as DWORD
	CredTypes as LPDWORD
end type

type CREDENTIAL_TARGET_INFORMATIONA as _CREDENTIAL_TARGET_INFORMATIONA
type PCREDENTIAL_TARGET_INFORMATIONA as _CREDENTIAL_TARGET_INFORMATIONA ptr

type _CREDENTIAL_TARGET_INFORMATIONW
	TargetName as LPWSTR
	NetbiosServerName as LPWSTR
	DnsServerName as LPWSTR
	NetbiosDomainName as LPWSTR
	DnsDomainName as LPWSTR
	DnsTreeName as LPWSTR
	PackageName as LPWSTR
	Flags as ULONG
	CredTypeCount as DWORD
	CredTypes as LPDWORD
end type

type CREDENTIAL_TARGET_INFORMATIONW as _CREDENTIAL_TARGET_INFORMATIONW
type PCREDENTIAL_TARGET_INFORMATIONW as _CREDENTIAL_TARGET_INFORMATIONW ptr
type CREDENTIAL_TARGET_INFORMATION as CREDENTIAL_TARGET_INFORMATIONA
type PCREDENTIAL_TARGET_INFORMATION as PCREDENTIAL_TARGET_INFORMATIONA
const CERT_HASH_LENGTH = 20

type _CERT_CREDENTIAL_INFO
	cbSize as ULONG
	rgbHashOfCert(0 to 19) as UCHAR
end type

type CERT_CREDENTIAL_INFO as _CERT_CREDENTIAL_INFO
type PCERT_CREDENTIAL_INFO as _CERT_CREDENTIAL_INFO ptr

type _USERNAME_TARGET_CREDENTIAL_INFO
	UserName as LPWSTR
end type

type USERNAME_TARGET_CREDENTIAL_INFO as _USERNAME_TARGET_CREDENTIAL_INFO
type PUSERNAME_TARGET_CREDENTIAL_INFO as _USERNAME_TARGET_CREDENTIAL_INFO ptr

type _CRED_MARSHAL_TYPE as long
enum
	CertCredential = 1
	UsernameTargetCredential
end enum

type CRED_MARSHAL_TYPE as _CRED_MARSHAL_TYPE
type PCRED_MARSHAL_TYPE as _CRED_MARSHAL_TYPE ptr

type _CREDUI_INFOA
	cbSize as DWORD
	hwndParent as HWND
	pszMessageText as PCSTR
	pszCaptionText as PCSTR
	hbmBanner as HBITMAP
end type

type CREDUI_INFOA as _CREDUI_INFOA
type PCREDUI_INFOA as _CREDUI_INFOA ptr

type _CREDUI_INFOW
	cbSize as DWORD
	hwndParent as HWND
	pszMessageText as PCWSTR
	pszCaptionText as PCWSTR
	hbmBanner as HBITMAP
end type

type CREDUI_INFOW as _CREDUI_INFOW
type PCREDUI_INFOW as _CREDUI_INFOW ptr
type CREDUI_INFO as CREDUI_INFOA
type PCREDUI_INFO as PCREDUI_INFOA

const CREDUI_MAX_MESSAGE_LENGTH = 32767
const CREDUI_MAX_CAPTION_LENGTH = 128
const CREDUI_MAX_GENERIC_TARGET_LENGTH = CRED_MAX_GENERIC_TARGET_NAME_LENGTH
#define CREDUI_MAX_DOMAIN_TARGET_LENGTH (CRED_MAX_STRING_LENGTH + NNLEN)
const CREDUI_MAX_USERNAME_LENGTH = CRED_MAX_USERNAME_LENGTH
const CREDUI_MAX_PASSWORD_LENGTH = CRED_MAX_CREDENTIAL_BLOB_SIZE / 2
const CREDUI_FLAGS_INCORRECT_PASSWORD = &h00001
const CREDUI_FLAGS_DO_NOT_PERSIST = &h00002
const CREDUI_FLAGS_REQUEST_ADMINISTRATOR = &h00004
const CREDUI_FLAGS_EXCLUDE_CERTIFICATES = &h00008
const CREDUI_FLAGS_REQUIRE_CERTIFICATE = &h00010
const CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX = &h00040
const CREDUI_FLAGS_ALWAYS_SHOW_UI = &h00080
const CREDUI_FLAGS_REQUIRE_SMARTCARD = &h00100
const CREDUI_FLAGS_PASSWORD_ONLY_OK = &h00200
const CREDUI_FLAGS_VALIDATE_USERNAME = &h00400
const CREDUI_FLAGS_COMPLETE_USERNAME = &h00800
const CREDUI_FLAGS_PERSIST = &h01000
const CREDUI_FLAGS_SERVER_CREDENTIAL = &h04000
const CREDUI_FLAGS_EXPECT_CONFIRMATION = &h20000
const CREDUI_FLAGS_GENERIC_CREDENTIALS = &h40000
const CREDUI_FLAGS_USERNAME_TARGET_CREDENTIALS = &h80000
const CREDUI_FLAGS_KEEP_USERNAME = &h100000
const CREDUI_FLAGS_PROMPT_VALID = (((((((((((((((CREDUI_FLAGS_INCORRECT_PASSWORD or CREDUI_FLAGS_DO_NOT_PERSIST) or CREDUI_FLAGS_REQUEST_ADMINISTRATOR) or CREDUI_FLAGS_EXCLUDE_CERTIFICATES) or CREDUI_FLAGS_REQUIRE_CERTIFICATE) or CREDUI_FLAGS_SHOW_SAVE_CHECK_BOX) or CREDUI_FLAGS_ALWAYS_SHOW_UI) or CREDUI_FLAGS_REQUIRE_SMARTCARD) or CREDUI_FLAGS_PASSWORD_ONLY_OK) or CREDUI_FLAGS_VALIDATE_USERNAME) or CREDUI_FLAGS_COMPLETE_USERNAME) or CREDUI_FLAGS_PERSIST) or CREDUI_FLAGS_SERVER_CREDENTIAL) or CREDUI_FLAGS_EXPECT_CONFIRMATION) or CREDUI_FLAGS_GENERIC_CREDENTIALS) or CREDUI_FLAGS_USERNAME_TARGET_CREDENTIALS) or CREDUI_FLAGS_KEEP_USERNAME
const CRED_PRESERVE_CREDENTIAL_BLOB = &h1

declare function CredWriteW(byval Credential as PCREDENTIALW, byval Flags as DWORD) as WINBOOL
declare function CredWriteA(byval Credential as PCREDENTIALA, byval Flags as DWORD) as WINBOOL
declare function CredWrite alias "CredWriteA"(byval Credential as PCREDENTIALA, byval Flags as DWORD) as WINBOOL
declare function CredReadW(byval TargetName as LPCWSTR, byval Type as DWORD, byval Flags as DWORD, byval Credential as PCREDENTIALW ptr) as WINBOOL
declare function CredReadA(byval TargetName as LPCSTR, byval Type as DWORD, byval Flags as DWORD, byval Credential as PCREDENTIALA ptr) as WINBOOL
declare function CredRead alias "CredReadA"(byval TargetName as LPCSTR, byval Type as DWORD, byval Flags as DWORD, byval Credential as PCREDENTIALA ptr) as WINBOOL
declare function CredEnumerateW(byval Filter as LPCWSTR, byval Flags as DWORD, byval Count as DWORD ptr, byval Credential as PCREDENTIALW ptr ptr) as WINBOOL
declare function CredEnumerateA(byval Filter as LPCSTR, byval Flags as DWORD, byval Count as DWORD ptr, byval Credential as PCREDENTIALA ptr ptr) as WINBOOL
declare function CredEnumerate alias "CredEnumerateA"(byval Filter as LPCSTR, byval Flags as DWORD, byval Count as DWORD ptr, byval Credential as PCREDENTIALA ptr ptr) as WINBOOL
declare function CredWriteDomainCredentialsW(byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONW, byval Credential as PCREDENTIALW, byval Flags as DWORD) as WINBOOL
declare function CredWriteDomainCredentialsA(byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONA, byval Credential as PCREDENTIALA, byval Flags as DWORD) as WINBOOL
declare function CredWriteDomainCredentials alias "CredWriteDomainCredentialsA"(byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONA, byval Credential as PCREDENTIALA, byval Flags as DWORD) as WINBOOL
const CRED_CACHE_TARGET_INFORMATION = &h1
declare function CredReadDomainCredentialsW(byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONW, byval Flags as DWORD, byval Count as DWORD ptr, byval Credential as PCREDENTIALW ptr ptr) as WINBOOL
declare function CredReadDomainCredentialsA(byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONA, byval Flags as DWORD, byval Count as DWORD ptr, byval Credential as PCREDENTIALA ptr ptr) as WINBOOL
declare function CredReadDomainCredentials alias "CredReadDomainCredentialsA"(byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONA, byval Flags as DWORD, byval Count as DWORD ptr, byval Credential as PCREDENTIALA ptr ptr) as WINBOOL
declare function CredDeleteW(byval TargetName as LPCWSTR, byval Type as DWORD, byval Flags as DWORD) as WINBOOL
declare function CredDeleteA(byval TargetName as LPCSTR, byval Type as DWORD, byval Flags as DWORD) as WINBOOL
declare function CredDelete alias "CredDeleteA"(byval TargetName as LPCSTR, byval Type as DWORD, byval Flags as DWORD) as WINBOOL
declare function CredRenameW(byval OldTargetName as LPCWSTR, byval NewTargetName as LPCWSTR, byval Type as DWORD, byval Flags as DWORD) as WINBOOL
declare function CredRenameA(byval OldTargetName as LPCSTR, byval NewTargetName as LPCSTR, byval Type as DWORD, byval Flags as DWORD) as WINBOOL
declare function CredRename alias "CredRenameA"(byval OldTargetName as LPCSTR, byval NewTargetName as LPCSTR, byval Type as DWORD, byval Flags as DWORD) as WINBOOL
const CRED_ALLOW_NAME_RESOLUTION = &h1
declare function CredGetTargetInfoW(byval TargetName as LPCWSTR, byval Flags as DWORD, byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONW ptr) as WINBOOL
declare function CredGetTargetInfoA(byval TargetName as LPCSTR, byval Flags as DWORD, byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONA ptr) as WINBOOL
declare function CredGetTargetInfo alias "CredGetTargetInfoA"(byval TargetName as LPCSTR, byval Flags as DWORD, byval TargetInfo as PCREDENTIAL_TARGET_INFORMATIONA ptr) as WINBOOL
declare function CredMarshalCredentialW(byval CredType as CRED_MARSHAL_TYPE, byval Credential as PVOID, byval MarshaledCredential as LPWSTR ptr) as WINBOOL
declare function CredMarshalCredentialA(byval CredType as CRED_MARSHAL_TYPE, byval Credential as PVOID, byval MarshaledCredential as LPSTR ptr) as WINBOOL
declare function CredMarshalCredential alias "CredMarshalCredentialA"(byval CredType as CRED_MARSHAL_TYPE, byval Credential as PVOID, byval MarshaledCredential as LPSTR ptr) as WINBOOL
declare function CredUnmarshalCredentialW(byval MarshaledCredential as LPCWSTR, byval CredType as PCRED_MARSHAL_TYPE, byval Credential as PVOID ptr) as WINBOOL
declare function CredUnmarshalCredentialA(byval MarshaledCredential as LPCSTR, byval CredType as PCRED_MARSHAL_TYPE, byval Credential as PVOID ptr) as WINBOOL
declare function CredUnmarshalCredential alias "CredUnmarshalCredentialA"(byval MarshaledCredential as LPCSTR, byval CredType as PCRED_MARSHAL_TYPE, byval Credential as PVOID ptr) as WINBOOL
declare function CredIsMarshaledCredentialW(byval MarshaledCredential as LPCWSTR) as WINBOOL
declare function CredIsMarshaledCredentialA(byval MarshaledCredential as LPCSTR) as WINBOOL
declare function CredIsMarshaledCredential alias "CredIsMarshaledCredentialA"(byval MarshaledCredential as LPCSTR) as WINBOOL
declare function CredGetSessionTypes(byval MaximumPersistCount as DWORD, byval MaximumPersist as LPDWORD) as WINBOOL
declare      sub CredFree(byval Buffer as PVOID)
declare function CredUIPromptForCredentialsW(byval pUiInfo as PCREDUI_INFOW, byval pszTargetName as PCWSTR, byval pContext as PCtxtHandle, byval dwAuthError as DWORD, byval pszUserName as PWSTR, byval ulUserNameBufferSize as ULONG, byval pszPassword as PWSTR, byval ulPasswordBufferSize as ULONG, byval save as WINBOOL ptr, byval dwFlags as DWORD) as DWORD
declare function CredUIPromptForCredentialsA(byval pUiInfo as PCREDUI_INFOA, byval pszTargetName as PCSTR, byval pContext as PCtxtHandle, byval dwAuthError as DWORD, byval pszUserName as PSTR, byval ulUserNameBufferSize as ULONG, byval pszPassword as PSTR, byval ulPasswordBufferSize as ULONG, byval save as WINBOOL ptr, byval dwFlags as DWORD) as DWORD
declare function CredUIPromptForCredentials alias "CredUIPromptForCredentialsA"(byval pUiInfo as PCREDUI_INFOA, byval pszTargetName as PCSTR, byval pContext as PCtxtHandle, byval dwAuthError as DWORD, byval pszUserName as PSTR, byval ulUserNameBufferSize as ULONG, byval pszPassword as PSTR, byval ulPasswordBufferSize as ULONG, byval save as WINBOOL ptr, byval dwFlags as DWORD) as DWORD
declare function CredUIParseUserNameW(byval pszUserName as PCWSTR, byval pszUser as PWSTR, byval ulUserBufferSize as ULONG, byval pszDomain as PWSTR, byval ulDomainBufferSize as ULONG) as DWORD
declare function CredUIParseUserNameA(byval pszUserName as PCSTR, byval pszUser as PSTR, byval ulUserBufferSize as ULONG, byval pszDomain as PSTR, byval ulDomainBufferSize as ULONG) as DWORD
declare function CredUIParseUserName alias "CredUIParseUserNameA"(byval pszUserName as PCSTR, byval pszUser as PSTR, byval ulUserBufferSize as ULONG, byval pszDomain as PSTR, byval ulDomainBufferSize as ULONG) as DWORD
declare function CredUICmdLinePromptForCredentialsW(byval pszTargetName as PCWSTR, byval pContext as PCtxtHandle, byval dwAuthError as DWORD, byval UserName as PWSTR, byval ulUserBufferSize as ULONG, byval pszPassword as PWSTR, byval ulPasswordBufferSize as ULONG, byval pfSave as PBOOL, byval dwFlags as DWORD) as DWORD
declare function CredUICmdLinePromptForCredentialsA(byval pszTargetName as PCSTR, byval pContext as PCtxtHandle, byval dwAuthError as DWORD, byval UserName as PSTR, byval ulUserBufferSize as ULONG, byval pszPassword as PSTR, byval ulPasswordBufferSize as ULONG, byval pfSave as PBOOL, byval dwFlags as DWORD) as DWORD
declare function CredUICmdLinePromptForCredentials alias "CredUICmdLinePromptForCredentialsA"(byval pszTargetName as PCSTR, byval pContext as PCtxtHandle, byval dwAuthError as DWORD, byval UserName as PSTR, byval ulUserBufferSize as ULONG, byval pszPassword as PSTR, byval ulPasswordBufferSize as ULONG, byval pfSave as PBOOL, byval dwFlags as DWORD) as DWORD
declare function CredUIConfirmCredentialsW(byval pszTargetName as PCWSTR, byval bConfirm as WINBOOL) as DWORD
declare function CredUIConfirmCredentialsA(byval pszTargetName as PCSTR, byval bConfirm as WINBOOL) as DWORD
declare function CredUIConfirmCredentials alias "CredUIConfirmCredentialsA"(byval pszTargetName as PCSTR, byval bConfirm as WINBOOL) as DWORD
declare function CredUIStoreSSOCredW(byval pszRealm as PCWSTR, byval pszUsername as PCWSTR, byval pszPassword as PCWSTR, byval bPersist as WINBOOL) as DWORD
declare function CredUIReadSSOCredW(byval pszRealm as PCWSTR, byval ppszUsername as PWSTR ptr) as DWORD

end extern
