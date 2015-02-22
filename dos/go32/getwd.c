/* This is file GETWD.C */
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

#include <sys/param.h>

char *
getwd (buf)
    char *buf;
{
  int len;
  char tmp[MAXPATHLEN + 1];

  bzero(tmp, MAXPATHLEN + 1);
  _getwd(tmp);
  len = strlen(tmp);
  buf[0] = 'a' + getdisk ();
  buf[1] = ':';
  strncpy(buf + 2, tmp, len);
  if (buf[len + 1] != '/') {
    buf[len + 2] = '/';
    buf[len + 3] = '\0';
  } else {
    buf[len + 2] = '\0';
  }
  return buf;
}

/*
 * char *_getwd (char *);
 */
asm ("	.text");
asm ("	.globl __getwd");
asm ("__getwd:");
asm ("	pushl	%ebx");
asm ("	pushl	%esi");
asm ("	pushl	%edi");
asm ("	movl	16(%esp),%esi");
asm ("	movb	$47,(%esi)");
asm ("	incl	%esi");
asm ("	movb	$0,%dl");
asm ("	movb	$0x47,%ah");
asm ("	int	$0x21");
asm ("	movl	16(%esp),%eax");
asm ("	popl	%edi");
asm ("	popl	%esi");
asm ("	popl	%ebx");
asm ("	ret");
