/* This is file CHDIR.C */
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
chdir (path)
     const char* path;
{
  int len = strlen (path);
  char *tmp = (char *) alloca (len + 1);

  if ((path[1] == ':') && (getdisk () != tolower (path[0]) - 'a')) {
    setdisk (tolower (path[0]) - 'a');
  }

  strcpy (tmp, path);
  if (strcmp (path, "/") && strcmp (path + 1, ":/") && (path[len - 1] == '/'))
    tmp[len - 1] = 0;
  return _chdir (tmp);
}

/*
 * int _chdir (const char *)
 */
asm ("	.text");
asm ("	.globl __chdir");
asm ("__chdir:");
asm ("	pushl	%ebx");
asm ("	pushl	%esi");
asm ("	pushl	%edi");
asm ("	movl	16(%esp),%edx");
asm ("	movb	$0x3b,%ah");
asm ("	int	$0x21");
asm ("	popl	%edi");
asm ("	popl	%esi");
asm ("	popl	%ebx");
asm ("	jmp	syscall_check");
