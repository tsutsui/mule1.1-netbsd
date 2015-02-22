/* This is file `_signal.s'

Copyright (C) 1992 M.Kobayashi (EastWind)

  This file is distributed under the conditions described in the
GNU CC General Public License.   A copy of this license is
supposed to have been given to you along with GNU CC so you
can know your rights and responsibilities.  It should be in a
file named COPYING.  Among other things, the copyright notice
and this notice must be preserved on all copies.  
*/

	.text
	.globl	__sigint_service
__sigint_service:
	pusha
	pushl	__sigint_val	/*	push argument(signal value) */
	pushl	__sigint_func	/*	save function address */
	call	__sigint_reset	/*	reset routine */
	popl 	%eax			/*	load signal function address*/
	call	*%eax 			/*	call function */
	addl	$4,%esp			/*	clean stack */
	popa
	ret
