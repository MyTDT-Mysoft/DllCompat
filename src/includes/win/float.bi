#pragma once

#include once "crt.bi"

'/* Control word masks for unMask */
#define	_MCW_EM		&h0008001F	'/* Error masks */
#define	_MCW_IC		&h00040000	'/* Infinity */
#define	_MCW_RC		&h00000300	'/* Rounding */
#define	_MCW_PC		&h00030000	'/* Precision */

'/* Control word values for unNew (use with related unMask above) */
#define	_EM_INVALID	&h00000010
#define	_EM_DENORMAL	&h00080000
#define	_EM_ZERODIVIDE	&h00000008
#define	_EM_OVERFLOW	&h00000004
#define	_EM_UNDERFLOW	&h00000002
#define	_EM_INEXACT	&h00000001
#define	_IC_AFFINE	&h00040000
#define	_IC_PROJECTIVE	&h00000000
#define	_RC_CHOP	&h00000300
#define	_RC_UP		&h00000200
#define	_RC_DOWN	&h00000100
#define	_RC_NEAR	&h00000000
#define	_PC_24		&h00020000
#define	_PC_53		&h00010000
#define	_PC_64		&h00000000

extern "C"
  declare function _control87 (unNew as uinteger, unMask as uinteger) as uinteger
  declare function _controlfp (unNew as uinteger, unMask as uinteger) as uinteger
  declare function _clearfp() as uinteger
  declare function _statusfp() as uinteger
  #define _clear87 _clearfp
  #define _status87 _statusfp
  declare sub _fpreset()
  declare sub fpreset()
end extern