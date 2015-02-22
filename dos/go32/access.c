/* This is file ACCESS.C */
/*
** Copyright (C) 1991 DJ Delorie, 24 Kirsten Ave, Rochester NH 03867-2954
**
** This file is distributed under the terms listed in the document
** "copying.dj", available from DJ Delorie at the address above.
** A copy of "copying.dj" should accompany this file; if not, a copy
** should be available from where this file was obtained.  This file
** may not be distributed without a verbatim copy of "copying.dj".
**
** This file is distributed WITHOUT ANY WARRANTY; without even the implied
** warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

int
access (file, mode)
     const char *file;
     int mode;
{
  int len = strlen (file);
  char *tmp = (char *) alloca (len + 1);

  strcpy (tmp, file);
  if (strcmp (file, "/") && strcmp (file + 1, ":/") && (file[len - 1] == '/'))
    tmp[len - 1] = 0;
  return (int) _access (tmp, mode);
}

/*
 * int _access (const char *, int);
 */
asm ("	.text");
asm ("	.globl __access");
asm ("__access:");
asm ("	pushl	%ebx");
asm ("	pushl	%esi");
asm ("	pushl	%edi");
asm ("	movl	16(%esp),%edx");
asm ("	movw	$0x4300,%ax");
asm ("	int	$0x21");
asm ("	popl	%edi");
asm ("	popl	%esi");
asm ("	popl	%ebx");
asm ("	jc	syscall_error");
asm ("	testl	$2,8(%esp)");
asm ("	jz	access_ok");
asm ("	testl	$1,%ecx");
asm ("	jz	access_ok");
asm ("	mov	$5,%eax");		/* EACCES */
asm ("	jmp	syscall_error");
asm ("access_ok:");
asm ("	movl	$0,%eax");
asm ("	ret");
