/*
 * assist.s extended system call assist library
 *
 * Author: HIRANO Satoshi
 *
 * entry:
 *	int fep_init (void)
 *	void fep_term (void)
 *	void fep_on (void)
 *	void fep_off (void)
 *	void fep_force_on (void)
 *	void fep_force_off (void)
 *	int fep_get_mode (void)
 *	void set98FunctionKey (void)
 *	void restore98FunctionKey (void)
 */

	.text
_fep_init:
	.globl	_fep_init
	movb	$20,%al
	jmp	turbo_assist
_fep_term:
	.globl	_fep_term
	movb	$21,%al
	jmp	turbo_assist
_fep_on:
	.globl	_fep_on
	movb	$22,%al
	jmp	turbo_assist
_fep_off:
	.globl	_fep_off
	movb	$23,%al
	jmp	turbo_assist
_fep_force_on:
	.globl	_fep_force_on
	movb	$24,%al
	jmp	turbo_assist
_fep_force_off:
	.globl	_fep_force_off
	movb	$25,%al
	jmp	turbo_assist
_fep_get_mode:
	.globl	_fep_get_mode
	movb	$28,%al
	jmp	turbo_assist

_set98FunctionKey:
	.globl	_set98FunctionKey
	movb	$26,%al
	jmp	turbo_assist
_restore98FunctionKey:
	.globl	_restore98FunctionKey
	movb	$27,%al
	jmp	turbo_assist
