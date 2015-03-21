/* Functions to handle multilingual characters.
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

/* 91.10.09 written by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.21  modified for Mule Ver.0.9.1
   by T.Nakagawa <nakagawa@is.titech.ac.jp>
	In Fcharacter_set(), argument of last Fcons fixed.
	In Fnew_character_set(), cheking of leading char fixed.
   by K.Handa <handa@etl.go.jp>
	Declarations of char_... are changed. */
/* 92.3.25  modified for Mule Ver.0.9.2
   by T.Nakagawa <nakagawa@is.titech.ac.jp>
	More severe error check in Fnew_character_set() */
/* 92.7.2   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	char_width() handles control characters. */
/* 92.7.8   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	Support for WNN3 and WNN4V3 stopped. */
/* 92.7.8   modified for Mule Ver.0.9.5 by Y.Kawabe <kawabe@sramhc.sra.co.jp>
	Support for SJ3 started. */
/* 92.9.2   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Big change to support private character-set. */
/* 92.9.11  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Fredisplay_region() is created. */
/* 92.9.16  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	undefined_private_charset() is created. */
/* 92.11.10 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Composite character is supported. */
/* 92.12.15 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Set char_bytes and char_width also for LCINV. */
/* 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
	Preliminary support (92.8.2) for right-to-left languages. */
/* 93.1.13  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In Fcharacter_set(), char_description[] should be index by lc&0x7F */
/* 93.4.29  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	CNS11643 support. */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	change so that private char-set could have direction */
/* 93.5.27  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Fmake_character() handles partially defined char. */
/* 93.6.2   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Arrays lc94[],... are changed to two dimentional array lc_table,
	indexed by type and final character. */
/* 93.6.17  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	'string-width' is defined in this file. */
/* 93.7.13  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Format of wordbuf changed.  */
/* 93.7.15  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In Fdefine_word_pattern(), memory allocation bug fixed. */

#include <stdio.h>

#ifdef emacs

#include "config.h"
#undef NULL
#include "lisp.h"
#include "buffer.h"
#include "syntax.h"
#include "regex.h"
#include "window.h"		/* 92.9.11 by K.Handa */

#endif /* emacs */

#include "mule.h"		/* 92.1.21 by K.Handa */
#include "codeconv.h"		/* 92.1.21 by K.Handa */

#ifdef emacs

Lisp_Object VMULE, VEGG, VWNN4, VSJ3; /* 92.7.8 by K.Handa and Y.Kawabe */

int Vlc_ascii, Vlc_ltn1, Vlc_ltn2, Vlc_ltn3, Vlc_ltn4, Vlc_grk;
int Vlc_arb, Vlc_hbw, Vlc_kana, Vlc_roman, Vlc_crl, Vlc_ltn5;
int Vlc_jpold, Vlc_cn, Vlc_jp, Vlc_jp2, Vlc_kr, Vlc_big5_1, Vlc_big5_2;
int Vlc_cns1, Vlc_cns2, Vlc_cns14; /* 93.4.29, 93.7.25 by K.Handa */
int Vlc_prv11, Vlc_prv12, Vlc_prv21, Vlc_prv22, Vlc_prv3;
int Vlc_invalid, Vlc_composite; /* 92.11.14 by K.Handa */

Lisp_Object Vre_word;

int re_short_flag;

#endif /* emacs */

/* Tables for character set definition. */
/* 92.3.21, 92.9.2 by K.Handa - variable declaration changed */
char *char_description[128];
unsigned char char_bytes[256];
unsigned char char_width[256];
unsigned char char_direction[256]; /* 92.8.2 Y.Niibe */
unsigned char char_data[512];
/* Indices to the following arrays should be 0 or 0x80..0xFF. */
unsigned char *char_graphic;
unsigned char *char_type;
unsigned char *char_final;
/* Table of leading-char indexed by TYPE/FINAL_CHAR. */
unsigned char lc_table[4][128];
/* Table of leading-char indexed by leading-char of the same TYPE/FINAL_CHAR
   but reverse DIRECTION. */
unsigned char rev_lc_table[256];

/* Add direction, 92.8.2 Y.Niibe */
void
update_mc_table(lc, bytes, clm, type, graphic, final, direction, doc)
     unsigned char lc, bytes, clm, type, graphic, final, direction;
     char *doc;
{
  char *p;

  if (lc < LCPRV11EXT) {	/* 91.10.19 by K.Handa */
    char_bytes[lc] = bytes;
    char_width[lc] = clm;
  }
  char_direction[lc] = direction; /* 92.8.2 Y.Niibe */
  char_type[lc] = type;
  char_graphic[lc] = graphic;
  char_final[lc] = final;
  char_description[lc & 0x7F] = doc; /* 92.9.2 by K.Handa */
  if (lc_table[type][final] == LCINV) {
    lc_table[type][final] = lc;
    rev_lc_table[lc] = lc;
  } else if (direction == RIGHT_TO_LEFT) {
    rev_lc_table[lc] = lc_table[type][final];
    rev_lc_table[lc_table[type][final]] = lc;
  }
}

#ifdef emacs

/* 92.9.16 by K.Handa */
int
undefined_private_charset(bytes, width)
     int bytes, width;
{
  int lc, from, to;

  if (bytes == 1) {
    if (width == 1) from = LCPRV11EXT, to = LCPRV12EXT;
    else from = LCPRV12EXT, to = LCPRV21EXT;
  } else {
    if (width == 1) from = LCPRV21EXT, to = LCPRV22EXT;
    else from = LCPRV22EXT, to = LCPRV3EXT;
  }
  for (lc = from; lc < to; lc++)
    if (char_type[lc] != 0xFF) break;
  return (lc < to ? lc : 0);
}
/* end of patch */

/* Add direction, 92.8.2 Y.Niibe */
DEFUN ("new-character-set", Fnew_character_set, Snew_character_set, 8, MANY, 0,
  "Define new character set of LEADING-CHAR (1st arg).\n\
Rest of args are:\n\
 BYTE: 1, 2, or 3\n\
 COLUMNS: 1 or 2\n\
 TYPE: 0 (94 chars), 1 (96 chars), 2 (94x94 chars), or 3 (96x96 chars)\n\
 GRAPHIC: 0 (use g0 on output) or 1 (use g1 on output)\n\
 FINAL: final character of ISO escape sequence\n\
 DIRECTION: 0 (left-to-right) or 1 (right-to-left)\n\
 DOC: short description string.\n\
If LEADING-CHAR >= 0xA0, it is regarded as extended leading-char\n\
and BYTE and COLUMNS args are ignored.")
  (nargs, args)
     int nargs;
     Lisp_Object *args;
{
  unsigned char lc, b, c, t, g, f, dir; /* 92.8.2 Y.Niibe */
  char *d;

  CHECK_NUMBER (args[0], 0);
  lc = XFASTINT (args[0]);
  if (lc <= 0x80 || lc == 0x9F)	/* 92.3.21 by T. NAKAGAWA, 92.9.2 by K.Handa */
    error ("Invalid leading character: %d", lc);
  if (char_type[lc] != 0xFF)
    error ("The character set (%d) already used.", lc);

  CHECK_NUMBER (args[1], 1);
  if ((b = XFASTINT (args[1]) + 1) > 3 || b < 1) /* 92.3.25 by T.Nakagawa */
    error ("Invalid BYTES: %d", --b);
  CHECK_NUMBER (args[2], 2);
  if ((c = XFASTINT (args[2])) > 2) error ("Invalid WIDTH: %d", c);
  CHECK_NUMBER (args[3], 3);
  if ((t = XFASTINT (args[3])) > 4) error ("Invalid TYPE: %d", t);
  CHECK_NUMBER (args[4], 4);
  if ((g = XFASTINT (args[4])) > 1) error ("Invalid GRAPHIC: %d", g);
  CHECK_NUMBER (args[5], 5);
  if ((f = XFASTINT (args[5])) < '0' || f > '_')
    error ("Invalid final character: %c", f);
/* 92.8.2 Y.Niibe */
  CHECK_NUMBER (args[6], 6);
  if ((dir = XFASTINT (args[6])) > 1)
    error ("Invalid direction: %d", dir);
  CHECK_STRING (args[7], 7);
  d = (char *)malloc (XSTRING (args[7])->size + 1);
  bcopy (XSTRING (args[7])->data, d, XSTRING (args[7])->size + 1);

  update_mc_table(lc, b, c, t, g, f, dir, d);
/* end of patch */
  return Qnil;
}

DEFUN ("leading-char", Fleading_char, Sleading_char, 2, 3, 0,
  "Return (extended) leading-char of character-set with TYPE and FINAL-CHAR.\n\
Optional arg DIRECTION specifies writing direction (0:normal, 1:r2l).")
  (type, final, direction)
     Lisp_Object type, final, direction;
{				/* 93.6.2 by K.Handa */
  Lisp_Object val;
  int dir = (NULL (direction) || XFASTINT (direction) == 0) ? 0 : 1;

  CHECK_NUMBER (type, 0);
  CHECK_NUMBER (final, 0);
  XFASTINT (val) = lc_table[XFASTINT (type) & 3][XFASTINT (final) & 0xFF];
  if (dir) XFASTINT (val) = rev_lc_table[XFASTINT (val)];
  return val;
}

/* Add direction, 92.8.2 Y.Niibe */
DEFUN ("character-set", Fcharacter_set, Scharacter_set, 1, 1, 0,
  "Return list of attributes of charcter-set indicated by LEADING-CHAR.\n\
Elements of the returned list are:\n\
 BYTES: 1..4\n\
 COLUMNS: 1 or 2\n\
 TYPE: 0 (94 chars), 1 (96 chars), 2 (94x94 chars), or 3 (96x96 chars)\n\
 GRAPHIC: 0 (use g0 on output) or 1 (use g1 on output)\n\
 FINAL-CHAR: final character of ISO escape sequence\n\
 DIRECTION: 0 (left-to-right) or 1 (right-to-left)\n\
 DOC: short description string.\n\
Return nil if LEADING-CHAR is invalid or not yet defined.")
  (leading_char)
     Lisp_Object leading_char;
{				/* 92.9.2 by K.Handa */
  unsigned int lc;

  CHECK_NUMBER (leading_char, 0);
  lc = XFASTINT (leading_char);
  if (lc > 0xFF || char_type[lc] == 0xFF) return Qnil;
/* 92.3.21 by T.Nakagawa -- argument of last Fcons fixed */
/* 92.8.2 Y.Niibe, 93.1.13 by K.Handa */
  return (Fcons (make_number (char_bytes[lc]),
		 Fcons (make_number (char_width[lc]),
			Fcons (make_number (char_type[lc]),
			       Fcons (make_number (char_graphic[lc]),
				      Fcons (make_number (char_final[lc]),
					     Fcons (make_number (char_direction[lc]),
						    Fcons (build_string (char_description[lc & 0x7F]), Qnil))))))));
}


DEFUN ("make-character", Fmake_character, Smake_character, 1, 4, 0,
  "Make multi-byte character from LEADING-CHAR and optional args ARG1,\n\
ARG2, and ARG3.\n\
LEADING-CHAR should be a leading-char or an extended leading-char.")
  (leading_char, arg1, arg2, arg3)
     Lisp_Object leading_char, arg1, arg2, arg3;
{				/* 92.9.2, 93.5.27 by K.Handa */
  unsigned int lc, i = 0;
  unsigned char buf[4];

  CHECK_NUMBER(leading_char, 0);
  lc = XFASTINT (leading_char);
  if (lc > 0xFF || char_type[lc] == 0xFF)
    error ("Invalid leading-char: %d", lc);
  if (lc < LCPRV11EXT)
    buf[i++] = lc;
  else {
    buf[i++] =
      lc < LCPRV12EXT ? LCPRV11 : lc < LCPRV21EXT ? LCPRV12 :
	lc < LCPRV22EXT ? LCPRV21 : LCPRV22;
    buf[i++] = lc;
  }
  if (!NULL (arg1))
    buf[i++] = XFASTINT (arg1) | 0x80;
  if (!NULL (arg2))
    buf[i++] = XFASTINT (arg2) | 0x80;
  if (!NULL (arg3))
    buf[i++] = XFASTINT (arg3) | 0x80;

  return make_number (STRtoCHAR (buf, i));
}

DEFUN ("char-component", Fchar_component, Schar_component, 2, 2, 0,
  "Return a components of multi-byte character CHAR.\n\
Second arg IDX indicate which component should be returned as follows.\n\
 0: leading character or extended leading character,\n\
 1: first byte of the character code,\n\
 2: second byte of the character code,\n\
 3: third byte of the character code.\n\
If the character does not have the componets, 0 is returned.")
  (ch, idx)
     Lisp_Object ch, idx;
{				/* 92.9.2 by K.Handa */
  register unsigned int c;
  unsigned char s[4];
  Lisp_Object val;

  CHECK_CHARACTER (ch, 0);
  c = XFASTINT (ch);
  CHECK_NUMBER (idx, 1);
  if (XFASTINT (idx) > 3)
    error ("Invalid index: %d", XFASTINT (idx));
  if (c <= 0xFF)
    s[0] = c, s[1] = s[2] = s[3] = 0;
  else if (c <= 0xFFFF)
    s[0] = (c >> 8) | 0x80, s[1] = c & 0xFF, s[2] = s[3] = 0;
  else if (c <= 0x5FFFFF)
    s[0] = (c >> 16) | 0x80, s[1] = (c >> 8) & 0xFF, s[2] = c & 0xFF, s[3] = 0;
  else
    s[0] = 0x9E, s[1] = (c >> 16) | 0x80,
    s[2] = (c >> 8) & 0xFF, s[3] = c & 0xFF;
  XFASTINT (val) = s[XFASTINT (idx)];
  return val;
}

DEFUN ("char-leading-char", Fchar_leading_char, Schar_leading_char, 1, 1, 0,
  "Return (extended) leading character of CHAR.\n\
If CHAR is not a multi-byte code, 0 is returned.")
  (ch)
     Lisp_Object ch;
{			/* 92.7.2 by K.Handa -- calls char_leading_char() */
  Lisp_Object w;
  unsigned int c;

  CHECK_CHARACTER (ch, 0);
  c = XFASTINT (ch);
  XSET (w, Lisp_Int, LEADING_CHAR(c));
  return w;
}

DEFUN ("char-bytes", Fchar_bytes, Schar_bytes, 1, 1, 0,
  "Return number of bytes CHAR will occupy in a buffer.\n\
You can specify a character set to be concerned\n\
 by providing a leading character as CHAR.")
  (ch)
     Lisp_Object ch;
{
  Lisp_Object w;
  unsigned int c;

  CHECK_NUMBER (ch, 0);
  c = XFASTINT (ch);
  XSET (w, Lisp_Int, char_bytes[LEADING_CHAR(c)]);
  return w;
}

/* 93.6.17 by K.Handa */
int
charwidth (c)
     unsigned int c;
{
  if (c == '\t')
    c = current_buffer->tab_width;
  else if (c == '\n')
    c = 0;
  else if (c == ' ')
    c = 1;
  else if (C0_P(c))
    c = !NULL (current_buffer->ctl_arrow) ? 2 : 4;
  else if (ASCII_P(c))
    c = 1;
  else if (LC_P (c) && !NULL (current_buffer->mc_flag))
    c = char_width[c];
  else if (c <= 0xFF)
    c = 4;
  else {
    c = LEADING_CHAR(c);
    c = NULL (current_buffer->mc_flag) ? char_bytes[c] * 4 : char_width[c];
  }
  return (int)c;
}

int
strwidth (s)
     unsigned char *s;
{
  int i = 0;
  unsigned char *endp = s + strlen(s);

  while (s < endp) {
    i += charwidth (*s);
    s += char_bytes[*s];
  }
  return i;
}

DEFUN ("string-width", Fstring_width, Sstring_width, 1, 1, 0,
  "Return number of columns STRING will occupy when displayed with mc-flag t.")
  (str)
     Lisp_Object str;
{
  CHECK_STRING (str, 0);
  return make_number (strwidth (XSTRING (str)->data));
}
/* end of patch */

DEFUN ("char-width", Fchar_width, Schar_width, 1, 1, 0,
  "Return number of columns CHAR will occupy when displayed.\n\
You can specify a character set to be concerned\n\
 by providing a leading character (not extended) of the charcter set as CHAR.")
  (ch)
       Lisp_Object ch;
{				/* 92.7.2, 92.9.3 by K.Handa -- Big change */
  Lisp_Object w;
  int c;

  CHECK_CHARACTER (ch, 0);
  c = charwidth (XFASTINT(ch)); /* 93.6.17 by K.Handa */
  
  XSET (w, Lisp_Int, c);
  return w;
}

/* 92.8.2 by Y.Niibe */
DEFUN ("char-direction", Fchar_direction, Schar_direction, 1, 1, 0,
  "Return the direction of CHAR.\n\
You can specify a character set to be concerned\n\
 by providing a leading character of the charcter set as CHAR.\n\
0: left-to-right, 1: right-to-left")
  (c)
       Lisp_Object c;
{
  Lisp_Object d;

  CHECK_NUMBER (c, 0);
  d = LC_P (XFASTINT (c)) ? c : Fchar_leading_char (c);

  XFASTINT (d) = char_direction[XFASTINT (d)];
  return d;
}
/* end of patch */

DEFUN ("chars-in-string", Fchars_in_string, Schars_in_string, 1, 1, 0,
  "Return number of characters in STRING.\n\
Each multilingual/composite character is also counted as one.")
  (string)
     Lisp_Object string;
{
  register Lisp_Object val;
  register unsigned char *p, *endp;
  register unsigned int i;

  CHECK_STRING (string, 0);

  p = XSTRING (string)->data; endp = p + XSTRING (string)->size;
  i = 0;
  while (p < endp) {		/* 92.11.16 by K.Handa */
    if (!NONASCII_P (*p)) i++;
    p++;
  }

  XFASTINT (val) = i;
  return val;
}

DEFUN ("char-boundary-p", Fchar_boundary_p, Schar_boundary_p, 1, 1, 0,
  "Return non nil value if POS is at character boundary.\n\
The value is:\n\
 0: if POS is at an ASCII character or end of range,\n\
 1: if POS is at a leading char of 2-byte sequence.\n\
 2: if POS is at a leading char of 3-byte sequence.\n\
 3: if POS is at a leading char of 4-byte sequence.\n\
 4: if POS is at a leading char of a composite character.\n\
If POS is out of range or not at character boundary, NIL is returned.")
  (pos)
     Lisp_Object pos;
{
  register Lisp_Object val;
  register unsigned char c;
  register int n;

  if (NULL (current_buffer->mc_flag))
    XSET (val, Lisp_Int, 0);
  else {
    CHECK_NUMBER_COERCE_MARKER (pos, 0);
    n = XINT (pos);
    if (n < BEGV || n >= ZV) return Qnil;
    c = FETCH_CHAR (n);
    if (NONASCII_P(c)) return Qnil;
    n = c == LCCMP ? 4 : char_bytes[c] - 1;
    XSET (val, Lisp_Int, n);
  }
  return val;
}

/* 92.9.11 by K.Handa */
DEFUN ("redisplay-region", Fredisplay_region, Sredisplay_region, 2, 2, 0,
  "Force redisplaying the region in START and END.")
  (b, e)
     Lisp_Object b, e;
{
  int beg, end;

  validate_region (&b, &e);
  beg = XINT (b), end = XINT (e);

  if (beg - 1 < beg_unchanged || unchanged_modified == MODIFF)
    beg_unchanged = beg - 1;
  if (Z - end < end_unchanged || unchanged_modified == MODIFF)
    end_unchanged = Z - end;
  if (current_buffer->save_modified == MODIFF++)
    current_buffer->save_modified++;
  return Qnil;
}
/* end of patch */

extern struct re_pattern_buffer searchbuf;
extern Lisp_Object last_regexp;

DEFUN ("re-compile", Fre_compile, Sre_compile, 1, 1, 0,
  "Return compiled code (by GNU Emacs original compiler) of RE by a string.")
  (re)
     Lisp_Object re;
{
  CHECK_STRING (re, 0);
  last_regexp = Qnil;
  compile_pattern(re, &searchbuf, 0, 0);
  return make_string(searchbuf.buffer, searchbuf.used);
}

DEFUN ("define-word-pattern", Fdefine_word_pattern, Sdefine_word_pattern,
       1, 1, 0,
  "Don't call this function directly, instead use 'define-word' which\n\
accept a pattern compiled by 'regexp-compile' with word-option t.")
  (pattern)
      Lisp_Object pattern;
{				/* 93.7.13 by K.Handa -- Big change */
  int i, len;
  char *p;
  Lisp_Object temp;
  struct Lisp_String *s;

  CHECK_CONS (pattern, 0);
  len = XFASTINT (Flength (pattern));
  if (len > MAXWORDBUF)
    error ("Too complicated regular expression for word!");
  for (i = 0; i < len; i++) {
    temp =XCONS (pattern)->car;
    CHECK_VECTOR (temp, 1);
    CHECK_STRING (XVECTOR (temp)->contents[0], 2);
    s = XSTRING (XVECTOR (temp)->contents[0]);
    if (!wordbuf[i])
      wordbuf[i] = (struct re_pattern_buffer *) xmalloc (sizeof (struct re_pattern_buffer));
    else
      if (wordbuf[i]->buffer) free (wordbuf[i]->buffer);
    wordbuf[i]->buffer = (char *)xmalloc (s->size + 1);
    wordbuf[i]->used = s->size;
    bcopy (s->data, wordbuf[i]->buffer, s->size + 1);
    pattern = XCONS (pattern)->cdr;
  }
  for (; i < MAXWORDBUF && wordbuf[i]; i++) {
    if (wordbuf[i]->buffer) free (wordbuf[i]->buffer);
    free (wordbuf[i]);
    wordbuf[i] = (struct re_pattern_buffer *)0;
  }    
  return Qnil;
}

#endif /* emacs */

void
init_mc_once()
{
  int i,j;

/* 92.3.21, 92.9.2 by K.Handa - big change */
  bzero(char_description, sizeof (char *) * 128);
  bzero(char_data, 512);
  char_type = char_data;
  char_graphic = char_type + 128;
  char_final = char_graphic + 128;
  for (i = 0; i < 4; i++) for (j = 0; j < 128; j++)
    lc_table[i][j] = LCINV;
  for (i = 0; i < 256; i++) {	/* 92.8.2 by Y.Niibe, 93.6.2 by K.Handa */
    char_direction[i] = LEFT_TO_RIGHT;
    rev_lc_table[i] = LCINV;
  }
  for (i = 0; i < 128; i++) char_bytes[i] = char_width[i] = 1;
  for (; i < 0x90; i++) char_bytes[i] = 2, char_width[i] = 1;
  for (; i < 0x9A; i++) char_bytes[i] = 3, char_width[i] = 2;
  for (; i < LCPRV11EXT; i++) char_bytes[i] = 1, char_width[i] = 1;
  for (; i < LCPRV12EXT; i++) char_bytes[i] = 3, char_width[i] = 1;
  for (; i < LCPRV21EXT; i++) char_bytes[i] = 3, char_width[i] = 2;
  for (; i < LCPRV22EXT; i++) char_bytes[i] = 4, char_width[i] = 1;
  for (; i < LCPRV3EXT; i++) char_bytes[i] = 4, char_width[i] = 2;
  for (; i <= 0xFF; i++) char_bytes[i] = 4, char_width[i] = 2;
  for (i = 0; i <= 0xFF; i++) char_type[i] = 0xFF;
/* 92.8.2, 93.5.22 by Y.Niibe */
  update_mc_table(LCPRV11, THREEBYTE, ONECOLUMN, 0, 0, 0, DIRECTION_UNDEFINED,
		  "1-byte/1-column private character sets");
  update_mc_table(LCPRV12, THREEBYTE, TWOCOLUMN, 0, 0, 0, DIRECTION_UNDEFINED,
		  "1-byte/2-column private character sets");
  update_mc_table(LCPRV21, FOURBYTE, ONECOLUMN, 0, 0, 0, DIRECTION_UNDEFINED,
		  "2-byte/1-column private character sets");
  update_mc_table(LCPRV22, FOURBYTE, TWOCOLUMN, 0, 0, 0, DIRECTION_UNDEFINED,
		  "2-byte/2-column private character sets");
  char_bytes[LCINV] = char_width[LCINV] = 1; /* 92.12.15 by K.Handa */
  update_mc_table(LCASCII, ONEBYTE, ONECOLUMN, TYPE94, GRAPHIC0, 'B',
		  LEFT_TO_RIGHT, "ASCII");
/* end of patch */
}

#ifdef emacs

void
syms_of_mc ()
{
  defsubr (&Snew_character_set);
  defsubr (&Sleading_char);
  defsubr (&Scharacter_set);
  defsubr (&Smake_character);
  defsubr (&Schar_component);
  defsubr (&Schar_leading_char);
  defsubr (&Schar_boundary_p);
  defsubr (&Sstring_width);	/* 93.6.17 by K.Handa */
  defsubr (&Schar_width);
  defsubr (&Schar_bytes);
  defsubr (&Schar_direction);  /* 92.8.2 by Y.Niibe */
  defsubr (&Schars_in_string);
  defsubr (&Sredisplay_region);
  defsubr (&Sre_compile);
  defsubr (&Sdefine_word_pattern);

  DEFVAR_INT ("lc-ascii", &Vlc_ascii,
    "Leading character for ASCII character, but never used.");
  XSET (Vlc_ascii, Lisp_Int, LCASCII);

  DEFVAR_INT ("lc-ltn1", &Vlc_ltn1,
    "Leading character for ISO8859-1, Latin alphabet No.1.");
  XSET (Vlc_ltn1, Lisp_Int, LCLTN1);

  DEFVAR_INT ("lc-ltn2", &Vlc_ltn2,
    "Leading character for ISO8859-2, Latin alphabet No.2.");
  XSET (Vlc_ltn2, Lisp_Int, LCLTN2);

  DEFVAR_INT ("lc-ltn3", &Vlc_ltn3,
    "Leading character for ISO8859-3, Latin alphabet No.3.");
  XSET (Vlc_ltn3, Lisp_Int, LCLTN3);

  DEFVAR_INT ("lc-ltn4", &Vlc_ltn4,
    "Leading character for ISO8859-4, Latin alphabet No.4.");
  XSET (Vlc_ltn4, Lisp_Int, LCLTN4);

  DEFVAR_INT ("lc-grk", &Vlc_grk,
    "Leading character for ISO8859-7, Greek alphabet.");
  XSET (Vlc_grk, Lisp_Int, LCGRK);

  DEFVAR_INT ("lc-arb", &Vlc_arb,
    "Leading character for ISO8859-6, Arabic alphabet.");
  XSET (Vlc_arb, Lisp_Int, LCARB);

  DEFVAR_INT ("lc-hbw", &Vlc_hbw,
    "Leading character for ISO8859-8, Hebrew alphabet.");
  XSET (Vlc_hbw, Lisp_Int, LCHBW);

  DEFVAR_INT ("lc-kana", &Vlc_kana,
    "Leading character for JIS X0201-1976, Japanese Katakana.");
  XSET (Vlc_kana, Lisp_Int, LCKANA);

  DEFVAR_INT ("lc-roman", &Vlc_roman,
    "Leading character for JIS X0201-1976, Japanese Roman.");
  XSET (Vlc_roman, Lisp_Int, LCROMAN);

  DEFVAR_INT ("lc-crl", &Vlc_crl,
    "Leading character for ISO8859-5, Cyrillic alphabet.");
  XSET (Vlc_crl, Lisp_Int, LCCRL);

  DEFVAR_INT ("lc-ltn5", &Vlc_ltn5,
    "Leading character for ISO8859-9, Latin alphabet No.5.");
  XSET (Vlc_ltn5, Lisp_Int, LCLTN5);

  DEFVAR_INT ("lc-jpold", &Vlc_jpold,
    "Leading character for JIS X0208-1976, Japanese characters.");
  XSET (Vlc_jpold, Lisp_Int, LCJPOLD);

  DEFVAR_INT ("lc-cn", &Vlc_cn,
    "Leading character for GB2312-1980, China (RPC) Hanzi.");
  XSET (Vlc_cn, Lisp_Int, LCCN);

  DEFVAR_INT ("lc-jp", &Vlc_jp,
    "Leading character for JIS X0208-1983, Japanese characters.");
  XSET (Vlc_jp, Lisp_Int, LCJP);

  DEFVAR_INT ("lc-jp2", &Vlc_jp2,
    "Leading character for JIS X0212-1990, Japanese characters.");
  XSET (Vlc_jp2, Lisp_Int, LCJP2);

  DEFVAR_INT ("lc-kr", &Vlc_kr,
    "Leading character for KS C5601-1987, Hangul character.");
  XSET (Vlc_kr, Lisp_Int, LCKR);

/* 93.4.29 by K.Handa */
  DEFVAR_INT ("lc-cns1", &Vlc_cns1,
    "Leading character for CNS 11643 Set 1.");
  XSET (Vlc_cns1, Lisp_Int, LCCNS1);

  DEFVAR_INT ("lc-cns2", &Vlc_cns2,
    "Leading character for CNS 11643 Set 2.");
  XSET (Vlc_cns2, Lisp_Int, LCCNS2);

/* 93.7.25 by K.Handa */
  DEFVAR_INT ("lc-cns14", &Vlc_cns14,
    "Leading character for CNS 11643 Set 14.");
  XSET (Vlc_cns14, Lisp_Int, LCCNS14);
/* end of patch */

  DEFVAR_INT ("lc-big5-1", &Vlc_big5_1,
    "Leading character for Big5 Level 1.");
  XSET (Vlc_big5_1, Lisp_Int, LCBIG5_1);

  DEFVAR_INT ("lc-big5-2", &Vlc_big5_2,
    "Leading character for Big5 Level 2.");
  XSET (Vlc_big5_2, Lisp_Int, LCBIG5_2);

  DEFVAR_INT ("lc-prv11", &Vlc_prv11,
    "Leading character for 1byte/1column private character sets.");
  XSET (Vlc_prv11, Lisp_Int, LCPRV11);

  DEFVAR_INT ("lc-prv12", &Vlc_prv12,
    "Leading character for 1byte/2column private character sets.");
  XSET (Vlc_prv12, Lisp_Int, LCPRV12);

  DEFVAR_INT ("lc-prv21", &Vlc_prv21,
    "Leading character for 2byte/1column private character sets.");
  XSET (Vlc_prv21, Lisp_Int, LCPRV21);

  DEFVAR_INT ("lc-prv22", &Vlc_prv22,
    "Leading character for 2byte/2column private character sets.");
  XSET (Vlc_prv22, Lisp_Int, LCPRV22);

  DEFVAR_INT ("lc-prv3", &Vlc_prv3,
    "Leading character for 3byte private character set.");
  XSET (Vlc_prv3, Lisp_Int, LCPRV3);

  DEFVAR_INT ("lc-invalid", &Vlc_invalid,
    "Invalid leading character.");
  XSET (Vlc_invalid, Lisp_Int, LCINV);

  DEFVAR_INT ("lc-composite", &Vlc_composite,
    "Leading character for a composite characer.");
  XSET (Vlc_composite, Lisp_Int, LCCMP);

  DEFVAR_BOOL ("re-short-flag", &re_short_flag,
    "*T means regexp search success when the shortest match is found.");
  re_short_flag = 0;

  DEFVAR_LISP ("MULE", &VMULE, "");
  VMULE = Qt;

#ifdef EGG
  DEFVAR_LISP ("EGG", &VEGG, "");
  VEGG = Qt;
/* 92.7.8 by K.Handa and Y.Kawabe */
#ifdef WNN4
  DEFVAR_LISP ("WNN4", &VWNN4, "");
  VWNN4 = Qt;
#else  /* not WNN4 */
#ifdef SJ3
  DEFVAR_LISP ("SJ3", &VSJ3, "");
  VSJ3 = Qt;
#endif /* SJ3 */
#endif /* not WNN4 */
#endif /* EGG */
}

#define max(a,b) ((a)>(b) ? (a) : (b))

char inspect_str[1024];

void
inspect(obj)			/* Inspect Lisp Data */
     Lisp_Object obj;
{
  switch (XTYPE (obj)) {
  case Lisp_Symbol:
    printf("Type:Symbol Name:%s\n", XSYMBOL (obj)->name->data); break;
  case Lisp_Int:
    printf("Type:Integer Value:%d\n", XINT (obj)); break;
  case Lisp_String:
    strncpy(inspect_str, XSTRING (obj)->data, max (XSTRING (obj)->size, 1023));
    printf("Type:String[%d] Value:%s\n", XSTRING (obj)->size, inspect_str);
    break;
  case Lisp_Vector:
    printf("Type:Vector Size:%d\n", XVECTOR (obj)->size);
    break;
  default:
    printf("Type:%d\n", XTYPE (obj));
  }
  fflush(stdout);
}

void
inspect_vector(obj,idx)
     Lisp_Object obj;
     int idx;
{
  if (XTYPE(obj) != Lisp_Vector) {
    printf("Not a vector!\n");
    return;
  }
  if (XVECTOR (obj)->size <= idx) {
    printf("Subscript out of range!");
    return;
  }
  printf("Value = %x\n", XVECTOR (obj)->contents[idx]);
  inspect(XVECTOR (obj)->contents[idx]);
  fflush(stdout);
}

void
inspect_array(p, n)
     unsigned char *p;
     int n;
{
  int i;

  for (i = 0; i < n; i++) printf("%d:%d ", i, p[i]);
  putchar('\n');
  fflush(stdout);
}
#endif /* emacs */
