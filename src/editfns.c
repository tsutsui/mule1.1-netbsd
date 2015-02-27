/* Lisp functions pertaining to editing.
   Copyright (C) 1985, 1986, 1987, 1990 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* 89.11.30 modified for Nemacs Ver.3.3.0 by K.Handa <handa@etl.go.jp> */
/* 91.11.13 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.4.16  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Cope with a new function insert_from_string(). */
/* 92.6.24  modified for Mule Ver.0.9.5 by T.Enami <enami@sys.ptg.sony.co.jp>
	In Fformat(), bug about integer argument of minus value fixed. */
/* 92.7.2  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	Fsref() cope with binary characters in STRING appropriately. */
/* 92.7.30  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	Fsubst_char_in_region() returns quickly if FROMCHAR = TOCHAR. */
/* 92.9.5  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Big change to support private character-set. */
/* 92.9.16  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Fsubst_char_in_region() gets slightly efficient. */
/* 92.11.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Composite character is supported. */
/* 92.11.19 modified for Mule Ver.0.9.7 by T.Enami <enami@sys.ptg.sony.co.jp>
	Fgoto_char() calls clip_to_bounds() before validate_position(). */
/* 92.12.26 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Fsref() and Fsset() can also be used for vector. */
/* 93.1.5   modified for Mule Ver.0.9.7.1 by T.Enami <enami@sys.ptg.sony.co.jp>
	In Fstring_to_char(), type of returned value should be Lisp_int. */
/* 93.2.12  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In char_to_string, handle private chars correctly. */
/* 93.5.27  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	char_to_string() and string_to_char() completely re-written. */

#include "config.h"
#ifdef hpux
/* needed by <pwd.h> */
#include <stdio.h>
#undef NULL
#endif

#ifdef VMS
#include "vms-pwd.h"
#else
#include <pwd.h>
#endif

#include "lisp.h"
#include "buffer.h"
#include "window.h"
#include "mule.h"		/* 91.11.14 by K.Handa */

#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

/* Some static data, and a function to initialize it for each run */

static Lisp_Object Vsystem_name;
static Lisp_Object Vuser_real_name;  /* login name of current user ID */
static Lisp_Object Vuser_full_name;  /* full name of current user */
static Lisp_Object Vuser_name;	/* user name from USER or LOGNAME.  */

void
init_editfns ()
{
  char *user_name;
  register unsigned char *p, *q;
  struct passwd *pw;		/* password entry for the current user */
  Lisp_Object tem;
  extern char *index ();

  /* Turn off polling so the SIGALRM won't bother getpwuid.  */
  stop_polling ();

  /* Set up system_name even when dumping.  */

  Vsystem_name = build_string (get_system_name ());
  p = XSTRING (Vsystem_name)->data;
  while (*p)
    {
      if (*p == ' ' || *p == '\t')
	*p = '-';
      p++;
    }

#ifndef CANNOT_DUMP
  /* Don't bother with this on initial start when just dumping out */
  if (!initialized)
    return;
#endif				/* not CANNOT_DUMP */

  pw = (struct passwd *) getpwuid (getuid ());
  Vuser_real_name = build_string (pw ? pw->pw_name : "unknown");

  /* Get the effective user name, by consulting environment variables,
     or the effective uid if those are unset.  */
  user_name = (char *) getenv ("USER");
  if (!user_name)
    user_name = (char *) getenv ("LOGNAME"); /* USG equivalent */
  if (!user_name)
    {
      pw = (struct passwd *) getpwuid (geteuid ());
      user_name = pw ? pw->pw_name : "unknown";
    }
  Vuser_name = build_string (user_name);

  /* If the user name claimed in the environment vars differs from
     the real uid, use the claimed name to find the full name.  */
  tem = Fstring_equal (Vuser_name, Vuser_real_name);
  if (NULL (tem))
    pw = (struct passwd *) getpwnam (XSTRING (Vuser_name)->data);
  
  p = (unsigned char *) (pw ? USER_FULL_NAME : "unknown");
  q = (unsigned char *) index (p, ',');
  Vuser_full_name = make_string (p, q ? q - p : strlen (p));

#ifdef AMPERSAND_FULL_NAME
  p = XSTRING (Vuser_full_name)->data;
  q = (unsigned char *) index (p, '&');
  /* Substitute the login name for the &, upcasing the first character.  */
  if (q)
    {
      char *r
	= (char *) alloca (strlen (p) + XSTRING (Vuser_name)->size + 1);
      bcopy (p, r, q - p);
      r[q - p] = 0;
      strcat (r, XSTRING (Vuser_real_name)->data);
      r[q - p] = UPCASE (r[q - p]);
      strcat (r, q + 1);
      Vuser_full_name = build_string (r);
    }
#endif				/* AMPERSAND_FULL_NAME */

  start_polling ();
}

/* 93.5.27 by K.Handa
   Use macro CHARtoSTR (c,str) instead of calling mchar_to_string() directly.
*/
/* 92.1.16 by K.Handa */
mchar_to_string (c, str)
     register unsigned int c;
     register unsigned char *str;
{				/* 92.9.5, 93.2.12, 93.5.27 by K.Handa */
  register unsigned char *p = str, c1 = (c >> 16 | 0x80);

  if (c1 < LCPRV11EXT) {
    *p++ = c1;
    *p++ = (c >> 8) & 0xFF;
    if (c1 = (c & 0xFF)) *p++ = c1;
  } else {
    *p++ = c1 < LCPRV12EXT ? LCPRV11 : c1 < LCPRV21EXT ? LCPRV12 :
      c1 < LCPRV22EXT ? LCPRV21 : c1 < LCPRV3EXT ? LCPRV22 : LCPRV3;
    *p++ = c1 < LCPRV3EXT ? c1 : c1 - 0x40;
    if (c1 = (c >> 8) & 0xFF) {
      *p++ = c1;
      if (c1 = (c & 0xFF)) *p++ = c1;
    }
  }
  return (p - str);
}

/* 93.5.27 by K.Handa
   Use macro STRtoCHAR(str,size) instead of calling string_to_mchar() directly.
*/
string_to_mchar (str, size)
     register unsigned char *str;
     register int size;
{				/* 92.11.12, 93.5.27 by K.Handa */
  register int i = *str++;

  if (i == LCCMP) {
    i = *str++;
    if (i == 0xA0)
      return (*str & 0x7F);
    i -= 0x20; size -= 1;
  }    
  switch (char_bytes[i]) {
  case ONEBYTE:			/* Type 1-1 */
    break;
  case TWOBYTE:			/* Type 1-2 */
    i = ((i & 0x7F) << 16) | (*str << 8);
    break;
  case THREEBYTE:		/* Type 1-3 or 2-3 */
    if (i < LCPRV11)		/* Type 2-3 */
      i = ((i & 0x7F) << 16) | (*str << 8) | (size >= 3 ? *(str + 1) : 0);
    else			/* Type 1-3 */
      i = ((*str & 0x7F) << 16) | (size >= 3 ? (*(str + 1) << 8) : 0);
    break;
  default:			/* Type 2-4 or 3-4 */
    if (i < LCPRV3)		/* Type 2-4 */
      i = ((*str & 0x7F) << 16) | (size >= 3 ? (*(str + 1) << 8) : 0)
	| (size >= 4 ? *(str + 2) : 0);
    else			/* Type 3-4 */
      i = (((*str & 0x7F) - 0x40) << 16) | (size >= 3 ? (*(str + 1) << 8) : 0)
	| (size >= 4 ? *(str + 2) : 0);
  }
  return i;
}
/* end of patch */

DEFUN ("char-to-string", Fchar_to_string, Schar_to_string, 1, 1, 0,
  "Convert arg CHAR to a string containing that character.")
  (n)
     Lisp_Object n;
{				/* 91.11.14 by K.Handa */
  unsigned int c, i;
  char str[4];			/* 92.9.5 by K.Handa */
  CHECK_CHARACTER (n, 0);

  c = XFASTINT (n);
  i = CHARtoSTR (c, str);
  return make_string (str, i);
}

DEFUN ("string-to-char", Fstring_to_char, Sstring_to_char, 1, 1, 0,
  "Convert arg STRING to a character, the first character of that string.")
  (str)
     register Lisp_Object str;
{
  register Lisp_Object val;
  register struct Lisp_String *p;
  CHECK_STRING (str, 0);

  p = XSTRING (str);

  XFASTINT (val) = 0;		/* 93.1.5 by T.Enami -- force Lisp_Int type */
  if (p->size)			/* 92.1.12, 92.11.12 by K.Handa */
    XSETINT (val, STRtoCHAR (p->data, p->size));

  return val;
}

/* 92.2.25, 92.12.25 by K.Handa */
DEFUN ("sref", Fsref, Ssref, 2, 2, 0,
  "Return the character in STRING at index INDEX.  INDEX starts at 0.\n\
STRING may be a vector, in that case,\n\
 elements should be integers of less than 256.\n\
If the character is a leading-character, the following multi-byte character\n\
is returned.")
  (str, idx)
     Lisp_Object str, idx;
{			/* 92.7.2 by K.Handa -- Handle binary chars */
  register Lisp_Object val;
  register int idxval, len;
  unsigned char *p, buf[4];

  CHECK_NUMBER (idx, 1);
  idxval = XINT (idx);
  if (XTYPE (str) != Lisp_Vector && XTYPE (str) != Lisp_String)
    str = wrong_type_argument (Qarrayp, str);
  if (idxval < 0 || idxval >= (len = XVECTOR (str)->size))
    args_out_of_range (str, idx);
  if (XTYPE (str) == Lisp_Vector) {
    int i;
    for (i = 0; i < 4 && idxval + i < len; i++)
      buf[i] = XFASTINT (XVECTOR (str)->contents[idxval + i]);
    p = buf;
    len = i;
  } else {
    p = XSTRING (str)->data + idxval;
    len = XSTRING (str)->size - idxval;
  }
  /* 92.11.12 by K.Handa */
  XSET (val, Lisp_Int, STRtoCHAR (p, len));
  return val;
}

DEFUN ("sset", Fsset, Ssset, 3, 3, 0,
  "Store into STRING at index INDEX the character CHAR and returns CHAR.\n\
There's no validity check of character boundary.")
  (str, idx, ch)
     Lisp_Object str, idx, ch;
{
  unsigned char s[4];		/* 92.9.5 by K.Handa */
  int idxval, len, size;

  CHECK_NUMBER (idx, 1);
  CHECK_CHARACTER (ch, 2);
  if (XTYPE (str) != Lisp_Vector && XTYPE (str) != Lisp_String)
    str = wrong_type_argument (Qarrayp, str);
  idxval = XINT (idx);
  len = CHARtoSTR (XFASTINT (ch), s);
  if (idxval < 0 || idxval + len > XVECTOR (str)->size)
    args_out_of_range (str, idx);

  if (XTYPE (str) == Lisp_Vector) {
    int i;

    for (i = 0; i < len; i++)
      XVECTOR (str)->contents[idxval + i] = XFASTINT (s[i]);
  } else {
    bcopy (s, XSTRING (str)->data + idxval, len);
  }
  return ch;
}

/* end of patch */

static Lisp_Object
buildmark (val)
     int val;
{
  register Lisp_Object mark;
  mark = Fmake_marker ();
  Fset_marker (mark, make_number (val), Qnil);
  return mark;
}

DEFUN ("point", Fpoint, Spoint, 0, 0, 0,
  "Return value of point, as an integer.\n\
Beginning of buffer is position (point-min)")
  ()
{
  Lisp_Object temp;
  XFASTINT (temp) = point;
  return temp;
}

DEFUN ("point-marker", Fpoint_marker, Spoint_marker, 0, 0, 0,
   "Return value of point, as a marker object.")
  ()
{
  return buildmark (point);
}

int
clip_to_bounds (lower, num, upper)
     int lower, num, upper;
{
  if (num < lower)
    return lower;
  else if (num > upper)
    return upper;
  else
    return num;
}

DEFUN ("goto-char", Fgoto_char, Sgoto_char, 1, 1, "NGoto char: ",
  "One arg, a number.  Set point to that number.\n\
Beginning of buffer is position (point-min), end is (point-max).\n\
If mc-flag of the current buffer is non-nil and the target position\n\
 is not at character boundary, set point to the previous character boundary.")
  (n)
     register Lisp_Object n;
{
  register int charno;
  CHECK_NUMBER_COERCE_MARKER (n, 0);
  charno = clip_to_bounds (BEGV, XINT (n), ZV);
  if (!NULL (current_buffer->mc_flag)) /* 91.12.26 by K.Handa */
    charno = validate_position (charno, 0);
  SET_PT (charno);
  return n;
}

static Lisp_Object
region_limit (beginningp)
     int beginningp;
{
  register Lisp_Object m;
  m = Fmarker_position (current_buffer->mark);
  if (NULL (m)) error ("There is no region now");
  if ((point < XFASTINT (m)) == beginningp)
    return (make_number (point));
  else
    return (m);
}

DEFUN ("region-beginning", Fregion_beginning, Sregion_beginning, 0, 0, 0,
  "Return position of beginning of region, as an integer.")
  ()
{
  return (region_limit (1));
}

DEFUN ("region-end", Fregion_end, Sregion_end, 0, 0, 0,
  "Return position of end of region, as an integer.")
  ()
{
  return (region_limit (0));
}

#if 0 /* now in lisp code */
DEFUN ("mark", Fmark, Smark, 0, 0, 0,
  "Return this buffer's mark value as integer, or nil if no mark.\n\
If you are using this in an editing command, you are most likely making\n\
a mistake; see the documentation of `set-mark'.")
  ()
{
  return Fmarker_position (current_buffer->mark);
}
#endif /* commented out code */

DEFUN ("mark-marker", Fmark_marker, Smark_marker, 0, 0, 0,
  "Return this buffer's mark, as a marker object.\n\
Watch out!  Moving this marker changes the mark position.\n\
The marker will not point anywhere if mark is not set.")
  ()
{
  return current_buffer->mark;
}

#if 0 /* this is now in lisp code */
DEFUN ("set-mark", Fset_mark, Sset_mark, 1, 1, 0,
  "Set this buffer's mark to POS.  Don't use this function!\n\
That is to say, don't use this function unless you want\n\
the user to see that the mark has moved, and you want the previous\n\
mark position to be lost.\n\
\n\
Normally, when a new mark is set, the old one should go on the stack.\n\
This is why most applications should use push-mark, not set-mark.\n\
\n\
Novice programmers often try to use the mark for the wrong purposes.\n\
The mark saves a location for the user's convenience.\n\
Most editing commands should not alter the mark.\n\
To remember a location for internal use in the Lisp program,\n\
store it in a Lisp variable.  Example:\n\
\n\
   (let ((beg (point))) (forward-line 1) (delete-region beg (point))).")
  (pos)
     Lisp_Object pos;
{
  if (NULL (pos))
    {
      current_buffer->mark = Qnil;
      return Qnil;
    }
  CHECK_NUMBER_COERCE_MARKER (pos, 0);

  if (NULL (current_buffer->mark))
    current_buffer->mark = Fmake_marker ();

  Fset_marker (current_buffer->mark, pos, Qnil);
  return pos;
}
#endif /* commented-out code */

Lisp_Object
save_excursion_save ()
{
  register int visible = XBUFFER (XWINDOW (selected_window)->buffer) == current_buffer;

  return Fcons (Fpoint_marker (),
		Fcons (Fcopy_marker (current_buffer->mark), visible ? Qt : Qnil));
}

Lisp_Object
save_excursion_restore (info)
     register Lisp_Object info;
{
  register Lisp_Object tem;

  tem = Fmarker_buffer (Fcar (info));
  /* If buffer being returned to is now deleted, avoid error */
  /* Otherwise could get error here while unwinding to top level
     and crash */
  /* In that case, Fmarker_buffer returns nil now.  */
  if (NULL (tem))
    return Qnil;
  Fset_buffer (tem);
  tem = Fcar (info);
  Fgoto_char (tem);
  unchain_marker (tem);
  tem = Fcar (Fcdr (info));
  Fset_marker (current_buffer->mark, tem, Fcurrent_buffer ());
  if (XMARKER (tem)->buffer)
    unchain_marker (tem);
  tem = Fcdr (Fcdr (info));
  if (!NULL (tem) && current_buffer != XBUFFER (XWINDOW (selected_window)->buffer))
    Fswitch_to_buffer (Fcurrent_buffer (), Qnil);
  return Qnil;
}

DEFUN ("save-excursion", Fsave_excursion, Ssave_excursion, 0, UNEVALLED, 0,
  "Save point (and mark), execute BODY, then restore point and mark.\n\
Executes BODY just like PROGN.  Point and mark values are restored\n\
even in case of abnormal exit (throw or error).")
  (args)
     Lisp_Object args;
{
  register Lisp_Object val;
  int count = specpdl_ptr - specpdl;

  record_unwind_protect (save_excursion_restore, save_excursion_save ());
			 
  val = Fprogn (args);

  return unbind_to (count, val);
}

DEFUN ("buffer-size", Fbufsize, Sbufsize, 0, 0, 0,
  "Return the number of characters in the current buffer.")
  ()
{
  Lisp_Object temp;
  XFASTINT (temp) = Z - BEG;
  return temp;
}

DEFUN ("point-min", Fpoint_min, Spoint_min, 0, 0, 0,
  "Return the minimum permissible value of point in the current buffer.\n\
This is 1, unless a clipping restriction is in effect.")
  ()
{
  Lisp_Object temp;
  XFASTINT (temp) = BEGV;
  return temp;
}

DEFUN ("point-min-marker", Fpoint_min_marker, Spoint_min_marker, 0, 0, 0,
  "Return a marker to the beginning of the currently visible part of the buffer.\n\
This is the beginning, unless a clipping restriction is in effect.")
  ()
{
  return buildmark (BEGV);
}

DEFUN ("point-max", Fpoint_max, Spoint_max, 0, 0, 0,
  "Return the maximum permissible value of point in the current buffer.\n\
This is (1+ (buffer-size)), unless a clipping restriction is in effect,\n\
in which case it is less.")
  ()
{
  Lisp_Object temp;
  XFASTINT (temp) = ZV;
  return temp;
}

DEFUN ("point-max-marker", Fpoint_max_marker, Spoint_max_marker, 0, 0, 0,
  "Return a marker to the end of the currently visible part of the buffer.\n\
This is the actual end, unless a clipping restriction is in effect.")
  ()
{
  return buildmark (ZV);
}

DEFUN ("following-char", Ffollchar, Sfollchar, 0, 0, 0,
  "Return the character following point, as a number.\n\
If mc-flag of the current buffer is not nil, the returned character\n\
 may be a multi-byte character.")
  ()
{
  Lisp_Object temp;
  if (point >= ZV)
    XFASTINT (temp) = 0;
  else {			/* 91.11.14 by K.Handa */
    if (NULL (current_buffer->mc_flag))
      XFASTINT (temp) = FETCH_CHAR (point);
    else
      FETCH_MC_CHAR (XFASTINT (temp), point);
  }
  return temp;
}

DEFUN ("preceding-char", Fprevchar, Sprevchar, 0, 0, 0,
  "Return the character preceding point, as a number.\n\
If mc-flag of the current buffer is not nil, the returned character\n\
 may be a multi-byte character.")
  ()
{
  Lisp_Object temp;
  if (point <= BEGV)
    XFASTINT (temp) = 0;
  else {			/* 91.11.14 by K.Handa */
    if (NULL (current_buffer->mc_flag))
      XFASTINT (temp) = FETCH_CHAR (point - 1);
    else {
      register int pos = point;
      DEC_POS (pos);
      FETCH_MC_CHAR (XFASTINT (temp), pos);
    }
  }
  return temp;
}

DEFUN ("bobp", Fbobp, Sbobp, 0, 0, 0,
  "Return T if point is at the beginning of the buffer.\n\
If the buffer is narrowed, this means the beginning of the narrowed part.")
  ()
{
  if (point == BEGV)
    return Qt;
  return Qnil;
}

DEFUN ("eobp", Feobp, Seobp, 0, 0, 0,
  "Return T if point is at the end of the buffer.\n\
If the buffer is narrowed, this means the end of the narrowed part.")
  ()
{
  if (point == ZV)
    return Qt;
  return Qnil;
}

DEFUN ("bolp", Fbolp, Sbolp, 0, 0, 0,
  "Return T if point is at the beginning of a line.")
  ()
{
  if (point == BEGV || FETCH_CHAR (point - 1) == '\n')
    return Qt;
  return Qnil;
}

DEFUN ("eolp", Feolp, Seolp, 0, 0, 0,
  "Return T if point is at the end of a line.\n\
`End of a line' includes point being at the end of the buffer.")
  ()
{
  if (point == ZV || FETCH_CHAR (point) == '\n')
    return Qt;
  return Qnil;
}

DEFUN ("char-after", Fchar_after, Schar_after, 1, 1, 0,
  "First arg, POS, a number.  Return the character in the current buffer\n\
at position POS.\n\
If POS is out of range, the value is NIL.\n\
If mc-flag of the current buffer is not nil, the returned character\n\
 may be a multi-byte character.")
  (pos)
     Lisp_Object pos;
{
  register Lisp_Object val;
  register int n;

  CHECK_NUMBER_COERCE_MARKER (pos, 0);

  n = XINT (pos);
  if (n < BEGV || n >= ZV) return Qnil;

  if (NULL (current_buffer->mc_flag)) /* 91.11.14 by K.Handa */
    XFASTINT (val) = FETCH_CHAR (n);
  else
    FETCH_MC_CHAR (XFASTINT (val), n);
  return val;
}

DEFUN ("char-before", Fchar_before, Schar_before, 1, 2, 0,
  "First arg, POS, a number.  Return the character in the current buffer\n\
BEFORE position POS.\n\
If POS is out of range on not at character boundary, the value is NIL.\n\
In case that there's a multi-byte character at POS,\n\
 only the last byte of the character is returned\n\
 unless mc-flag of the buffer is t nor optional arg BYTE-UNIT is nil.")
  (pos, byte_unit)
     Lisp_Object pos, byte_unit;
{
  register Lisp_Object val;
  register int n;

  CHECK_NUMBER_COERCE_MARKER (pos, 0);

  n = XINT (pos);
  if (n <= BEGV || n > ZV) return Qnil;

  XFASTINT (val) = FETCH_CHAR (n - 1);
  if (!NULL (current_buffer->mc_flag)
      && !ASCII_P (XFASTINT (val))
      && NULL (byte_unit)) {	/* 93.5.27 by K.Handa */
    unsigned char *str;
    int len;

    DEC_POS (n);
    str = &FETCH_CHAR (n);
    len = n < GPT ? GPT - n : Z - n;
    XSETINT (val, STRtoCHAR (str, len));
  }
  return val;
}

DEFUN ("user-login-name", Fuser_login_name, Suser_login_name, 0, 0, 0,
  "Return the name under which user logged in, as a string.\n\
This is based on the effective uid, not the real uid.")
  ()
{
  return Vuser_name;
}

DEFUN ("user-real-login-name", Fuser_real_login_name, Suser_real_login_name,
  0, 0, 0,
  "Return the name of the user's real uid, as a string.\n\
Differs from user-login-name when running under su.")
  ()
{
  return Vuser_real_name;
}

DEFUN ("user-uid", Fuser_uid, Suser_uid, 0, 0, 0,
  "Return the effective uid of Emacs, as an integer.")
  ()
{
  return make_number (geteuid ());
}

DEFUN ("user-real-uid", Fuser_real_uid, Suser_real_uid, 0, 0, 0,
  "Return the real uid of Emacs, as an integer.")
  ()
{
  return make_number (getuid ());
}

DEFUN ("user-full-name", Fuser_full_name, Suser_full_name, 0, 0, 0,
  "Return the full name of the user logged in, as a string.")
  ()
{
  return Vuser_full_name;
}

DEFUN ("system-name", Fsystem_name, Ssystem_name, 0, 0, 0,
  "Return the name of the machine you are running on, as a string.")
  ()
{
  return Vsystem_name;
}

DEFUN ("current-time-string", Fcurrent_time_string, Scurrent_time_string, 0, 0, 0,
  "Return the current time, as a human-readable string.")
  ()
{
  time_t current_time = time (0);
  register char *tem = (char *) ctime (&current_time);
  tem [24] = 0;
  return build_string (tem);
}

/* 89.11.30, 91.11.15, 92.4.16 patch for point_type_marker by K.Handa */
extern int insert (), insert_before_markers (), insert2 ();
extern int insert_from_string (), insert_from_string_before_markers ();
extern int insert_from_string2 ();
/* end of patch */

insert1 (arg)
     Lisp_Object arg;
{
  Finsert (1, &arg);
}

DEFUN ("insert", Finsert, Sinsert, 0, MANY, 0,
  "Any number of args, strings or chars.  Insert them after point, moving point forward.")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
/* 89.11.30, 92.4.16 patch for point_type_marker by K.Handa */
{
  insert_with_specified_function (insert, insert_from_string, nargs, args);
  return Qnil;
}

insert_with_specified_function (func, func_str, nargs, args)
     int (*func)(), (*func_str)(), nargs;
     register Lisp_Object *args;
{
  register int argnum;
  register Lisp_Object tem;
  char i, str[4];		/* 92.9.5 by K.Handa */

  for (argnum = 0; argnum < nargs; argnum++)
    {
      tem = args[argnum];
    retry:
      if (XTYPE (tem) == Lisp_Int)
	{
	  CHECK_CHARACTER (tem, 0);
	  i = CHARtoSTR (XFASTINT (tem), str);
	  (*func) (str, i);
	}
      else if (XTYPE (tem) == Lisp_String)
	{
	  (*func_str) (tem, 0, XSTRING (tem)->size);
	}
      else
	{
	  tem = wrong_type_argument (Qchar_or_string_p, tem);
	  goto retry;
	}
    }
}
/* end of patch */

DEFUN ("insert-before-markers", Finsert_before_markers, Sinsert_before_markers, 0, MANY, 0,
  "Any number of args, strings or chars.  Insert them after point,\n\
moving point forward.  Also, any markers pointing at the insertion point\n\
get relocated to point after the newly inserted text.")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
{				/* 89.11.30, 92.4.16 by K.Handa */
  insert_with_specified_function (insert_before_markers,
				  insert_from_string_before_markers,
				  nargs, args);
  return Qnil;
}

/* 89.11.30, 92.4.16 patch for point_type_marker by K.Handa */
DEFUN ("insert-after-markers", Finsert_after_markers, Sinsert_after_markers, 0, MANY, 0,
  "Any number of args, strings or chars.  Insert them after point,\n\
moving point forward.  Also, any markers of point_type pointing at\n\
the insertion point get relocated to point before the newly inserted text.")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
{
  insert_with_specified_function (insert2, insert_from_string2, nargs, args);
  return Qnil;
}
/* end of patch */

DEFUN ("insert-char", Finsert_char, Sinsert_char, 2, 2, 0,
  "Insert COUNT (second arg) copies of CHAR (first arg).\n\
Both arguments are required.")
  (chr, count)
       Lisp_Object chr, count;
{
  register unsigned char *string;
  register int strlen;
  register int i, j, n;		/* 91.11.14 by K.Handa */
  unsigned char str[4];		/* 91.11.14, 92.9.5 by K.Handa */

  CHECK_CHARACTER (chr, 0);	/* 91.11.17 by K.Handa */
  CHECK_NUMBER (count, 1);

  j = CHARtoSTR (XFASTINT (chr), str); /* 91.11.17 by K.Handa */
  n = XINT (count) * j;
  if (n <= 0)
    return Qnil;
  strlen = min (n, 768);	/* 91.11.14 by K.Handa */
  string = (unsigned char *) alloca (strlen);
  for (i = 0; i < strlen; i++)
    string[i] = str[i % j];	/* 91.11.14 by K.Handa */
  while (n >= strlen)
    {
      insert (string, strlen);
      n -= strlen;
    }
  if (n > 0)
    insert (string, n);
  return Qnil;
}


/* Return a string with the contents of the current region */

DEFUN ("buffer-substring", Fbuffer_substring, Sbuffer_substring, 2, 2, 0,
  "Return the contents of part of the current buffer as a string.\n\
The two arguments specify the START and END, as position.\n\
If mc-flag of the current buffer is non-nil, region may be widen\n\
 to meet character boundary.")
  (b, e)
     Lisp_Object b, e;
{
  register int beg, end;

  validate_region (&b, &e);
  beg = XINT (b);
  end = XINT (e);

  if (beg < GPT && end > GPT)
    move_gap (beg);
  return make_string (&FETCH_CHAR (beg), end - beg);
}

DEFUN ("buffer-string", Fbuffer_string, Sbuffer_string, 0, 0, 0,
  "Return the contents of the current buffer as a string.")
  ()
{
  if (BEGV < GPT && ZV > GPT)
    move_gap (BEGV);
  return make_string (BEGV_ADDR, ZV - BEGV);
}

DEFUN ("insert-buffer-substring", Finsert_buffer_substring, Sinsert_buffer_substring,
  1, 3, 0,
  "Insert before point a substring of the contents buffer BUFFER.\n\
BUFFER may be a buffer or a buffer name.\n\
Arguments START and END are character numbers specifying the substring.\n\
They default to the beginning and the end of BUFFER.")
  (buf, b, e)
     Lisp_Object buf, b, e;
{
  register int beg, end, exch;
  register struct buffer *bp;

  buf = Fget_buffer (buf);
  bp = XBUFFER (buf);

  if (NULL (b))
    beg = BUF_BEGV (bp);
  else
    {
      CHECK_NUMBER_COERCE_MARKER (b, 0);
      beg = XINT (b);
    }
  if (NULL (e))
    end = BUF_ZV (bp);
  else
    {
      CHECK_NUMBER_COERCE_MARKER (e, 1);
      end = XINT (e);
    }

  if (beg > end)
    exch = beg, beg = end, end = exch;

  /* Move the gap or create enough gap in the current buffer.  */

  if (point != GPT)
    move_gap (point);
  if (GAP_SIZE < end - beg)
    make_gap (end - beg - GAP_SIZE);

  if (!(BUF_BEGV (bp) <= beg
	&& beg <= end
        && end <= BUF_ZV (bp)))
    args_out_of_range (b, e);

  /* Now the actual insertion will not do any gap motion,
     so it matters not if BUF is the current buffer.  */

  if (beg < BUF_GPT (bp))
    {
      insert (BUF_CHAR_ADDRESS (bp, beg), min (end, BUF_GPT (bp)) - beg);
      beg = min (end, BUF_GPT (bp));
    }
  if (beg < end)
    insert (BUF_CHAR_ADDRESS (bp, beg), end - beg);

  return Qnil;
}

DEFUN ("subst-char-in-region", Fsubst_char_in_region,
  Ssubst_char_in_region, 4, 5, 0,
  "From START to END, replace FROMCHAR with TOCHAR each time it occurs.\n\
If optional arg NOUNDO is non-nil, don't record this change for undo\n\
and don't mark the buffer as really changed.\n\
It also works well with multi-byte characters only if the substitution\n\
doesn't alter the length of buffer.")
  (start, end, fromchar, tochar, noundo)
     Lisp_Object start, end, fromchar, tochar, noundo;
{				/* 91.11.17, 92.9.16 by K.Handa */
  register unsigned int pos, stop, i, j;
  unsigned char fromstr[4], tostr[4], *p; /* 92.9.5 by K.Handa */

  validate_region (&start, &end);
  CHECK_CHARACTER (fromchar, 2);
  CHECK_CHARACTER (tochar, 3);

  pos = XINT (start);
  stop = XINT (end);
  modify_region (pos, stop);
  if (fromchar == tochar) return Qnil; /* 92.7.30 by K.Handa */

  i = CHARtoSTR (XFASTINT (fromchar), fromstr);
  j = CHARtoSTR (XFASTINT (tochar), tostr);

  if (i != j) error ("Can't substitute different byte-size characters.");

  if (! NULL (noundo))
    {
      if (MODIFF - 1 == current_buffer->save_modified)
	current_buffer->save_modified++;
      if (MODIFF - 1 == current_buffer->auto_save_modified)
	current_buffer->auto_save_modified++;
    }

  if (GPT > pos) stop = min(stop, GPT); /* 92.9.5 by K.Handa */
  p = &FETCH_CHAR (pos);
  while (1)
    {
      if (pos >= stop) {
	if (pos >= XINT (end)) break;
	stop = XINT (end);
	p = &FETCH_CHAR (pos);
      }
      if (*p == fromstr[0]
	  && (i == 1
	      || (p[1] == fromstr[1]
		  && (i == 2 || (p[2] == fromstr[2] /* 92.9.5 by K.Handa */
				 && (i == 3 || p[3] == fromstr[3])))))) {
	int k;
	if (NULL (noundo))
	  record_change (pos, i);
	for (k = 0; k < i; k++) *p++ = tostr[k];
	pos += i;
      } else {
	pos++;
	p++;
      }
    }

  return Qnil;
}				/*  91.11.17 by K.Handa*/

DEFUN ("delete-region", Fdelete_region, Sdelete_region, 2, 2, "r",
  "Delete the text between point and mark.\n\
When called from a program, expects two arguments,\n\
character numbers specifying the stretch to be deleted.")
  (b, e)
     Lisp_Object b, e;
{
  validate_region (&b, &e);
  del_range (XINT (b), XINT (e));
  return Qnil;
}

DEFUN ("widen", Fwiden, Swiden, 0, 0, "",
  "Remove restrictions from current buffer, allowing full text to be seen and edited.")
  ()
{
  BEGV = BEG;
  SET_BUF_ZV (current_buffer, Z);
  clip_changed = 1;
  /* Changing the buffer bounds invalidates any recorded current column.  */
  invalidate_current_column ();
  return Qnil;
}

DEFUN ("narrow-to-region", Fnarrow_to_region, Snarrow_to_region, 2, 2, "r",
  "Restrict editing in this buffer to the current region.\n\
The rest of the text becomes temporarily invisible and untouchable\n\
but is not deleted; if you save the buffer in a file, the invisible\n\
text is included in the file.  \\[widen] makes all visible again.\n\
\n\
When calling from a program, pass two arguments; character numbers\n\
bounding the text that should remain visible.")
  (b, e)
     register Lisp_Object b, e;
{				/* 92.3.6 by K.Handa -- Many changes. */
  register int i;
  int beg, end;

  CHECK_NUMBER_COERCE_MARKER (b, 0);
  CHECK_NUMBER_COERCE_MARKER (e, 1);

  if (XINT (b) > XINT (e))
    {
      i = XFASTINT (b);
      b = e;
      XFASTINT (e) = i;
    }

  beg = XINT (b); end = XINT (e);
  if (!(BEG <= beg && beg <= end && end <= Z))
    args_out_of_range (b, e);

  BEGV = beg;
  SET_BUF_ZV (current_buffer, end);
  if (point < beg)
    SET_PT (beg);
  if (point > end)
    SET_PT (end);
  clip_changed = 1;
  /* Changing the buffer bounds invalidates any recorded current column.  */
  invalidate_current_column ();
  return Qnil;
}

Lisp_Object
save_restriction_save ()
{
  register Lisp_Object bottom, top;
  /* Note: I tried using markers here, but it does not win
     because insertion at the end of the saved region
     does not advance top and is considered "outside" the saved region. */
  XFASTINT (bottom) = BEGV - BEG;
  XFASTINT (top) = Z - ZV;

  return Fcons (Fcurrent_buffer (), Fcons (bottom, top));
}

Lisp_Object
save_restriction_restore (data)
     Lisp_Object data;
{
  register struct buffer *buf;
  register int newhead, newtail;
  register Lisp_Object tem;

  buf = XBUFFER (XCONS (data)->car);

  data = XCONS (data)->cdr;

  tem = XCONS (data)->car;
  newhead = XINT (tem);
  tem = XCONS (data)->cdr;
  newtail = XINT (tem);
  if (newhead + newtail > BUF_Z (buf) - BUF_BEG (buf))
    {
      newhead = 0;
      newtail = 0;
    }
  BUF_BEGV (buf) = BUF_BEG (buf) + newhead;
  SET_BUF_ZV (buf, BUF_Z (buf) - newtail);
  clip_changed = 1;

  /* If point is outside the new visible range, move it inside. */
  SET_BUF_PT (buf,
	      clip_to_bounds (BUF_BEGV (buf), BUF_PT (buf), BUF_ZV (buf)));

  return Qnil;
}

DEFUN ("save-restriction", Fsave_restriction, Ssave_restriction, 0, UNEVALLED, 0,
  "Execute the body, undoing at the end any changes to current buffer's restrictions.\n\
Changes to restrictions are made by narrow-to-region or by widen.\n\
Thus, the restrictions are the same after this function as they were before it.\n\
The value returned is that returned by the last form in the body.\n\
\n\
This function can be confused if, within the body, you widen\n\
and then make changes outside the area within the saved restrictions.\n\
\n\
Note: if you are using both save-excursion and save-restriction,\n\
use save-excursion outermost.")
  (body)
     Lisp_Object body;
{
  register Lisp_Object val;
  int count = specpdl_ptr - specpdl;

  record_unwind_protect (save_restriction_restore, save_restriction_save ());
  val = Fprogn (body);

  return unbind_to (count, val);
}

DEFUN ("message", Fmessage, Smessage, 1, MANY, 0,
  "Print a one-line message at the bottom of the screen.\n\
The first argument is a control string.\n\
It may contain %s or %d or %c to print successive following arguments.\n\
%s means print an argument as a string, %d means print as number in decimal,\n\
%c means print a number as a single character.\n\
The argument used by %s must be a string or a symbol;\n\
the argument used by %d or %c must be a number.")
  (nargs, args)
     int nargs;
     Lisp_Object *args;
{
  register Lisp_Object val;

  val = Fformat (nargs, args);
  message ("%s", XSTRING (val)->data);
  return val;
}

DEFUN ("format", Fformat, Sformat, 1, MANY, 0,
  "Format a string out of a control-string and arguments.\n\
The first argument is a control string.\n\
It, and subsequent arguments substituted into it, become the value, which is a string.\n\
It may contain %s or %d or %c to substitute successive following arguments.\n\
%s means print an argument as a string, %d means print as number in decimal,\n\
%c means print a number as a single character.\n\
The argument used by %s must be a string or a symbol;\n\
the argument used by %d, %b, %o, %x or %c must be a number.")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
{
  register int n;
  register int total = 5;
  char *buf;
  register unsigned char *format;
  register unsigned char **strings;
  extern char *index ();
  /* It should not be necessary to GCPRO ARGS, because
     the caller in the interpreter should take care of that.  */

  CHECK_STRING (args[0], 0);
  format = XSTRING (args[0])->data;

  /* We have to do so much work in order to prepare to call doprnt
     that we might as well do all of it ourself...  (Which would also
     circumvent C asciz cretinism by allowing ascii 000 chars to appear)
   */
  n = 0;
  while (format = (unsigned char *) index (format, '%'))
    {
      format++;
      while ((*format >= '0' && *format <= '9')
	     || *format == '-' || *format == ' ')
	format++;
      if (*format == '%')
	format++;
      else if (++n >= nargs)
	;
      else if (XTYPE (args[n]) == Lisp_Symbol)
	{
	  XSET (args[n], Lisp_String, XSYMBOL (args[n])->name);
	  goto string;
	}
      else if (XTYPE (args[n]) == Lisp_String)
	{
	string:
	  total += XSTRING (args[n])->size;
	}
      /* would get MPV otherwise, since Lisp_Int's `point' to low memory */
      else if (XTYPE (args[n]) == Lisp_Int && *format != 's')
	total += 10;
      else
	{
	  register Lisp_Object tem;
	  tem = Fprin1_to_string (args[n]);
	  args[n] = tem;
	  goto string;
	}
    }

  strings = (unsigned char **) alloca ((n + 1) * sizeof (unsigned char *));
  for (; n >= 0; n--)
    {
      if (n >= nargs)
	strings[n] = (unsigned char *) "";
      else if (XTYPE (args[n]) == Lisp_Int)
	/* We checked above that the correspondiong format effector
	   isn't %s, which would cause MPV */
	strings[n] = (unsigned char *) XINT (args[n]); /* 92.6.24 by T.Enami */
      else
	strings[n] = XSTRING (args[n])->data;
    }

  /* Format it in bigger and bigger buf's until it all fits. */
  while (1)
    {
      buf = (char *) alloca (total + 1);
      buf[total - 1] = 0;

      doprnt (buf, total + 1, strings[0], nargs, strings + 1);
      if (buf[total - 1] == 0)
	break;

      total *= 2;
    }

/*   UNGCPRO;  */
  return build_string (buf);
}

/* VARARGS 1 */
Lisp_Object
#ifdef NO_ARG_ARRAY
format1 (string1, arg0, arg1, arg2, arg3, arg4)
     Lisp_Object_Int arg0, arg1, arg2, arg3, arg4;
#else
format1 (string1)
#endif
     char *string1;
{
  char buf[100];
#ifdef NO_ARG_ARRAY
  Lisp_Object_Int args[5];
  args[0] = arg0;
  args[1] = arg1;
  args[2] = arg2;
  args[3] = arg3;
  args[4] = arg4;
  doprnt (buf, sizeof buf, string1, 5, args);
#else
  doprnt (buf, sizeof buf, string1, 5, &string1 + 1);
#endif
  return build_string (buf);
}

DEFUN ("char-equal", Fchar_equal, Schar_equal, 2, 2, 0,
  "T if args (both characters (numbers)) match.  May ignore case.\n\
Case is ignored if the current buffer specifies to do so.")
  (c1, c2)
     register Lisp_Object c1, c2;
{
  CHECK_CHARACTER (c1, 0);	/* 91.11.17 by K.Handa */
  CHECK_CHARACTER (c2, 1);	/* 91.11.17 by K.Handa */

  if (!NULL (current_buffer->case_fold_search)
      && !MC_CHAR_P(c1) /* 91.11.17 by K.Handa */
      ? downcase_table[0xff & XFASTINT (c1)] == downcase_table[0xff & XFASTINT (c2)]
      : XINT (c1) == XINT (c2))
    return Qt;
  return Qnil;
}

#ifndef MAINTAIN_ENVIRONMENT /* it is done in environ.c in that case */
DEFUN ("getenv", Fgetenv, Sgetenv, 1, 2, 0,
  "Return the value of environment variable VAR, as a string.\n\
VAR should be a string.  If the environment variable VAR is not defined,\n\
the value is nil.")
  (str)
     Lisp_Object str;
{
  register char *val;
  CHECK_STRING (str, 0);
  val = (char *) egetenv (XSTRING (str)->data);
  if (!val)
    return Qnil;
  return build_string (val);
}
#endif /* MAINTAIN_ENVIRONMENT */

void
syms_of_editfns ()
{
  staticpro (&Vsystem_name);
  staticpro (&Vuser_name);
  staticpro (&Vuser_full_name);
  staticpro (&Vuser_real_name);

  defsubr (&Schar_equal);
  defsubr (&Sgoto_char);
  defsubr (&Sstring_to_char);
  defsubr (&Ssref);		/* 92.2.25 by K.Handa */
  defsubr (&Ssset);		/* 92.2.25 by K.Handa */
  defsubr (&Schar_to_string);
  defsubr (&Sbuffer_substring);
  defsubr (&Sbuffer_string);

  defsubr (&Spoint_marker);
  defsubr (&Smark_marker);
  defsubr (&Spoint);
  defsubr (&Sregion_beginning);
  defsubr (&Sregion_end);
/*  defsubr (&Smark); */
/*  defsubr (&Sset_mark); */
  defsubr (&Ssave_excursion);

  defsubr (&Sbufsize);
  defsubr (&Spoint_max);
  defsubr (&Spoint_min);
  defsubr (&Spoint_min_marker);
  defsubr (&Spoint_max_marker);

  defsubr (&Sbobp);
  defsubr (&Seobp);
  defsubr (&Sbolp);
  defsubr (&Seolp);
  defsubr (&Sfollchar);
  defsubr (&Sprevchar);
  defsubr (&Schar_after);
  defsubr (&Schar_before);	/* 92.1.16 by K.Handa */
  defsubr (&Sinsert);
  defsubr (&Sinsert_before_markers);
  defsubr (&Sinsert_after_markers); /* 89.11.30 by K.Handa */
  defsubr (&Sinsert_char);

  defsubr (&Suser_login_name);
  defsubr (&Suser_real_login_name);
  defsubr (&Suser_uid);
  defsubr (&Suser_real_uid);
  defsubr (&Suser_full_name);
  defsubr (&Scurrent_time_string);
  defsubr (&Ssystem_name);
  defsubr (&Smessage);
  defsubr (&Sformat);
#ifndef MAINTAIN_ENVIRONMENT /* in environ.c */
  defsubr (&Sgetenv);
#endif

  defsubr (&Sinsert_buffer_substring);
  defsubr (&Ssubst_char_in_region);
  defsubr (&Sdelete_region);
  defsubr (&Swiden);
  defsubr (&Snarrow_to_region);
  defsubr (&Ssave_restriction);
}

