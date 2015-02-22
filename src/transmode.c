/* File translation mode support staff for MS-DOS and Win32.
   Copyright (C) 1992 Free Software Foundation, Inc.

This file is part of Mule (MULtilingual Enhancement of GNU Emacs).

Mule is free software distributed in the form of patches to GNU Emacs.
You can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

Mule is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. */

/* 92.11.2  written by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */
/* 92.11.4  modified by M.Higashida <manbau@sigmath.osaka-u.ac.jp>
	Mis-naming: write_with_cr_to_crlf -> write_with_lf_to_crlf
	Bug fix for missing tailing condition. */

#include <stdio.h>

#include "config.h"
#include "lisp.h"

#define min(x,y) ((x) > (y) ? (y) : (x))

#ifdef FILE_TRANSLATION_MODE

Lisp_Object Qdos_text;

Lisp_Object Qfile_translation_mode;

/* These objects are used in `fileio.c'. */
Lisp_Object Qfind_file_translation_mode;
Lisp_Object Qinvoke_find_file_translation_mode;

int
crlf_to_lf (n, buf)
     register int n;
     register unsigned char *buf;
{
  unsigned char *np = buf;
  unsigned char *startp = buf;
  unsigned char *endp = buf + n;
  int check;
    
  if (n == 0)
    return n;
  check = 0;
  while (buf < endp) {
    if (check) {
      if (*buf != 0x0a)	*np++ = 0x0d;
      check = 0;
    }	
    if (*buf == 0x0d) {
      check = 1;
      buf++;
    } else {
      *np++ = *buf++;
    }
  }
  return (np - startp);
}



int
write_with_lf_to_crlf (desc, buf, len)
     int desc;
     char *buf;
     unsigned int len;
{
  char *p = buf;
  char *trans_buf = (char *) alloca (BUFSIZ + 1);
  int rest = len;	/* 92.11.4 by M.Higashida */

  while (rest > 0)
    {
      int nbytes = 0;
      char *tp = trans_buf;
      char *e = p + min (BUFSIZ, rest);

      while ((p < e) && (*p != '\n')) {
	*tp++ = *p++;
	nbytes++, rest--;
      }
      if ((p < e) && (*p == '\n')) {  /* 92.11.4 by M.Higashida */
	*tp++ = '\r', *tp++ = *p++;
	nbytes += 2, rest--;
      }
      if (write (desc, trans_buf, nbytes) != nbytes)
	return -1;
    }

  return len;
}

/* Initialize the file translation mode routine. */

syms_of_transmode ()
{
  Qdos_text = intern ("*dos-text*");
  staticpro (&Qdos_text);
  XSYMBOL (Qdos_text)->value = Qdos_text;

  Qfind_file_translation_mode
    = intern ("find-file-translation-mode");
  staticpro (&Qfind_file_translation_mode);

  Qinvoke_find_file_translation_mode
    = intern ("invoke-find-file-translation-mode");
  staticpro (&Qinvoke_find_file_translation_mode);
}

#endif /* FILE_TRANSLATION_MODE */
