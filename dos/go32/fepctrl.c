#include <dos.h>

int
fep_get_mode ()
{
  union REGS regs;
	
  regs.h.ah = 0x30;        /* get DOS version */
  regs.x.bx = 0x474F3332;  /* "GO32" */
  intdos (&regs, &regs);
  if ((r.x.bx & 0x80000000) == 0) return;	/* version check */

  return _fep_get_mode ();
}

asm ("	.text");
asm ("	.globl	__fep_get_mode");
asm ("__fep_get_mode:");
asm ("	movb	$28,%al");
asm ("	jmp	turbo_assist");
