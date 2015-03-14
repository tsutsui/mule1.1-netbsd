/* Simple built-in editing commands.
   Copyright (C) 1985, 1990 Free Software Foundation, Inc.

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

/* 87.6.10  modified by K.Handa */
/* 88.1.5   modified for Nemacs Ver.2.0 by K.Handa */
/* 90.3.2   modified for Nemacs Ver.3.3.1 by K.Handa
	overwrite mode for Japanese */
/* 91.10.28 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.4.1   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	In self_insert_internal, bug of overwrite-mode fixed.
	Fforward_byte and Fbackward_byte are addred. */
/* 92.10.26 modified for Mule Ver.0.9.6	by T.Saneto <sanewo@pdp.crl.sony.co.jp>
	In self_insert_internal(), declaration of str[3] changed. */
/* 92.11.30 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	In self_insert_internal(), bug of overwrite-mode fixed. */

#include "config.h"
#include "lisp.h"
#include "commands.h"
#include "buffer.h"
#include "syntax.h"
#include "mule.h"		/* 91.10.28 by K.Handa */

Lisp_Object Qkill_forward_chars, Qkill_backward_chars, Vblink_paren_hook;


DEFUN ("forward-char", Fforward_char, Sforward_char, 0, 1, "p",
  "Move point right ARG characters (left if ARG negative).\n\
On reaching end of buffer, stop and signal error.")
  (n)
     Lisp_Object n;
{
  if (NULL (n))
    XFASTINT (n) = 1;
  else
    CHECK_NUMBER (n, 0);

  SET_PT (forward_point(XINT (n))); /* 91.10.28 by K.Handa */
  if (point < BEGV)
    {
      SET_PT (BEGV);
      Fsignal (Qbeginning_of_buffer, Qnil);
    }
  if (point > ZV)
    {
      SET_PT (ZV);
      Fsignal (Qend_of_buffer, Qnil);
    }
  return Qnil;
}

/* 92.4.1 by K.Handa */
DEFUN ("forward-byte", Fforward_byte, Sforward_byte, 0, 1, "p",
  "Move point right ARG bytes (left if ARG negative).\n\
On reaching end of buffer, stop and signal error.")
  (n)
     Lisp_Object n;
{
  if (NULL (n))
    XFASTINT (n) = 1;
  else
    CHECK_NUMBER (n, 0);

  SET_PT (point + XINT (n));
  if (point < BEGV)
    {
      SET_PT (BEGV);
      Fsignal (Qbeginning_of_buffer, Qnil);
    }
  if (point > ZV)
    {
      SET_PT (ZV);
      Fsignal (Qend_of_buffer, Qnil);
    }
  return Qnil;
}

DEFUN ("backward-byte", Fbackward_byte, Sbackward_byte, 0, 1, "p",
  "Move point left ARG bytes (right if ARG negative).\n\
On attempt to pass beginning or end of buffer, stop and signal error.")
  (n)
     Lisp_Object n;
{
  if (NULL (n))
    XFASTINT (n) = 1;
  else
    CHECK_NUMBER (n, 0);

  XSETINT (n, - XINT (n));
  return Fforward_byte (n);
}
/* end of patch */

/* 91.10.28 by K.Handa */
int
forward_point(n)
     int n;
{
  int pos = point, c;

  if (NULL(current_buffer->mc_flag))
    pos += n;
  else {
    if (n > 0) while (n--) INC_POS (pos);
    else while (n++) DEC_POS (pos);
  }
  return pos;
}
  
/* end of patch */

DEFUN ("backward-char", Fbackward_char, Sbackward_char, 0, 1, "p",
  "Move point left ARG characters (right if ARG negative).\n\
On attempt to pass beginning or end of buffer, stop and signal error.")
  (n)
     Lisp_Object n;
{
  if (NULL (n))
    XFASTINT (n) = 1;
  else
    CHECK_NUMBER (n, 0);

  XSETINT (n, - XINT (n));
  return Fforward_char (n);
}

DEFUN ("forward-line", Fforward_line, Sforward_line, 0, 1, "p",
  "If point is on line i, move to the start of line i + ARG.\n\
If there isn't room, go as far as possible (no error).\n\
Returns the count of lines left to move.\n\
With positive ARG, a non-empty line traversed at end of buffer \n\
 counts as one line successfully moved (for the return value).")
  (n)
     Lisp_Object n;
{
  int pos2 = point;
  int pos;
  int count, shortage, negp;

  if (NULL (n))
    count = 1;
  else
    {
      CHECK_NUMBER (n, 0);
      count = XINT (n);
    }

  negp = count <= 0;
  pos = scan_buffer ('\n', pos2, count - negp, &shortage);
  if (shortage > 0
      && (negp
	  || (ZV > BEGV && pos != pos2
	      && FETCH_CHAR (pos - 1) != '\n')))
    shortage--;
  SET_PT (pos);
  return make_number (negp ? - shortage : shortage);
}

DEFUN ("beginning-of-line", Fbeginning_of_line, Sbeginning_of_line,
  0, 1, "p",
  "Move point to beginning of current line.\n\
With argument ARG not nil or 1, move forward ARG - 1 lines first.\n\
If scan reaches end of buffer, stop there without error.")
  (n)
     Lisp_Object n;
{
  if (NULL (n))
    XFASTINT (n) = 1;
  else
    CHECK_NUMBER (n, 0);

  Fforward_line (make_number (XINT (n) - 1));
  return Qnil;
}

DEFUN ("end-of-line", Fend_of_line, Send_of_line,
  0, 1, "p",
  "Move point to end of current line.\n\
With argument ARG not nil or 1, move forward ARG - 1 lines first.\n\
If scan reaches end of buffer, stop there without error.")
  (n)
     Lisp_Object n;
{
  register int pos;
  register int stop;

  if (NULL (n))
    XFASTINT (n) = 1;
  else
    CHECK_NUMBER (n, 0);

  if (XINT (n) != 1)
    Fforward_line (make_number (XINT (n) - 1));

  pos = point;
  stop = ZV;
  while (pos < stop && FETCH_CHAR (pos) != '\n') pos++;
  SET_PT (pos);

  return Qnil;
}

DEFUN ("delete-char", Fdelete_char, Sdelete_char, 1, 2, "p\nP",
  "Delete the following ARG characters (previous, with negative arg).\n\
Optional second arg KILLFLAG non-nil means kill instead (save in kill ring).\n\
Interactively, ARG is the prefix arg, and KILLFLAG is set if\n\
ARG was explicitly specified.")
  (n, killflag)
     Lisp_Object n, killflag;
{
  int pos;			/* 91.10.28 by K.Handa */

  CHECK_NUMBER (n, 0);

  pos = forward_point(XINT (n)); /* 91.10.28 by K.Handa */
  if (NULL (killflag))
    {
      if (XINT (n) < 0)
	{
	  if (pos < BEGV)	/* 91.10.28 by K.Handa */
	    Fsignal (Qbeginning_of_buffer, Qnil);
	  else
	    del_range (pos, point); /* 91.10.28 by K.Handa */
	}
      else
	{
	  if (pos > ZV)		/* 91.10.28 by K.Handa */
	    Fsignal (Qend_of_buffer, Qnil);
	  else
	    del_range (point, pos); /* 91.10.28 by K.Handa */
	}
    }
  else
    {
      call1 (Qkill_forward_chars, n);
    }
  return Qnil;
}

DEFUN ("delete-backward-char", Fdelete_backward_char, Sdelete_backward_char,
  1, 2, "p\nP",
  "Delete the previous ARG characters (following, with negative ARG).\n\
Optional second arg KILLFLAG non-nil means kill instead (save in kill ring).\n\
Interactively, ARG is the prefix arg, and KILLFLAG is set if\n\
ARG was explicitly specified.")
  (n, killflag)
     Lisp_Object n, killflag;
{
  CHECK_NUMBER (n, 0);
  return Fdelete_char (make_number (-XINT (n)), killflag);
}

DEFUN ("self-insert-command", Fself_insert_command, Sself_insert_command, 1, 1, "p",
  "Insert this character.  Prefix arg is repeat-count.")
  (arg)
     Lisp_Object arg;
{
  CHECK_NUMBER (arg, 0);

  while (XINT (arg) > 0)
    {
      XFASTINT (arg)--;		/* Ok since old and new vals both nonneg */
      self_insert_internal (last_command_char, XFASTINT (arg) != 0);
    }
  return Qnil;
}

/* 92.2.17 by K.Handa */
DEFUN ("self-insert-internal", Fself_insert_internal, Sself_insert_internal,
       1, 1, 0,
  "Invoke self-insert-command as if CHAR is entered from keyboard.")
  (ch)
     Lisp_Object ch;
{
  CHECK_CHARACTER (ch, 0);
  self_insert_internal (XFASTINT (ch), 0);
  return Qnil;
}
/* end of patch */

DEFUN ("newline", Fnewline, Snewline, 0, 1, "P",
  "Insert a newline.  With arg, insert that many newlines.\n\
In Auto Fill mode, can break the preceding line if no numeric arg.")
  (arg1)
     Lisp_Object arg1;
{
  int flag;
  Lisp_Object arg;
  char c1 = '\n';

  arg = Fprefix_numeric_value (arg1);

  if (!NULL (current_buffer->read_only))
    Fsignal (Qbuffer_read_only, Qnil);

  /* Inserting a newline at the end of a line
     produces better redisplay in try_window_id
     than inserting at the ebginning fo a line,
     And the textual result is the same.
     So if at beginning, pretend to be at the end.
     Must avoid self_insert_internal in that case since point is wrong.
     Luckily self_insert_internal's special features all do nothing in that case.  */

  flag = point > BEGV && FETCH_CHAR (point - 1) == '\n';
  if (flag)
    SET_PT (point - 1);

  while (XINT (arg) > 0)
    {
      if (flag)
	insert (&c1, 1);
      else
	self_insert_internal ('\n', !NULL (arg1));
      XFASTINT (arg)--;		/* Ok since old and new vals both nonneg */
    }

  if (flag)
    SET_PT (point + 1);

  return Qnil;
}

self_insert_internal (c1, noautofill)
     int c1;			/* 92.1.16 by K.Handa */
     int noautofill;
{				/* 92.1.16 by K.Handa */
  int hairy = 0;
  Lisp_Object tem;
  register enum syntaxcode synt;
  register int c = c1, pos, len;
  unsigned char str[4];		/* 92.10.26 by T.Saneto, 92.11.30 by K.Handa */
  register unsigned char *p;

  len = CHARtoSTR (c1, str);

  if (!NULL (current_buffer->overwrite_mode)
      && point < ZV
      && c != '\n') {		/* 92.11.30 by K.Handa */
    int clm1 = current_column() + char_width[str[0]], clm2;

    c1 = FETCH_CHAR (point);
    if (c1 != '\n'
	&& (c1 != '\t'
	    || XINT (current_buffer->tab_width) <= 0
	    || !(clm1 % XFASTINT (current_buffer->tab_width))))
    {				/* 92.4.1 by K.Handa */
      pos = point;
      clm2 = XFASTINT (Fmove_to_column(clm1));
      del_range (pos, point);
      if (clm2 > clm1) {
	insert("        ",  clm2 - clm1);
	point = pos;
      }
      hairy = 1;
    }
  }
  if (!NULL (current_buffer->abbrev_mode)
      && SYNTAX (c) != Sword
      && NULL (current_buffer->read_only)
      && point > BEGV) {
    pos = point;
    DEC_POS (pos);
    FETCH_MC_CHAR (c1, pos);
    if (SYNTAX (c1) == Sword)
    {
      tem = Fexpand_abbrev ();
      if (!NULL (tem))
	hairy = 1;
    }
  }
  if ((c == ' ' || c == '\n')
      && !noautofill
      && !NULL (current_buffer->auto_fill_hook)
      && current_column () > XFASTINT (current_buffer->fill_column))
    {
      if (c != '\n')
	insert (str, len);
      call0 (current_buffer->auto_fill_hook);
      if (c == '\n')
	insert (str, len);
      hairy = 1;
    }
  else
    insert (str, len);
  synt = SYNTAX (c);
  if ((synt == Sclose || synt == Smath)
      && !NULL (Vblink_paren_hook) && FROM_KBD)
    {
      call0 (Vblink_paren_hook);
      hairy = 1;
    }
  return hairy;
}

/* module initialization */

syms_of_cmds ()
{
  Qkill_backward_chars = intern ("kill-backward-chars");
  staticpro (&Qkill_backward_chars);

  Qkill_forward_chars = intern ("kill-forward-chars");
  staticpro (&Qkill_forward_chars);

  DEFVAR_LISP ("blink-paren-hook", &Vblink_paren_hook,
    "Function called, if non-nil, whenever a char with closeparen syntax is self-inserted.");
  Vblink_paren_hook = Qnil;

  defsubr (&Sforward_char);
  defsubr (&Sbackward_char);
  defsubr (&Sforward_byte);	/* 92.4.1 by K.Handa */
  defsubr (&Sbackward_byte);	/* 92.4.1 by K.Handa */
  defsubr (&Sforward_line);
  defsubr (&Sbeginning_of_line);
  defsubr (&Send_of_line);

  defsubr (&Sdelete_char);
  defsubr (&Sdelete_backward_char);

  defsubr (&Sself_insert_command);
  defsubr (&Sself_insert_internal); /* 92.2.17 by K.Handa */
  defsubr (&Snewline);
}

keys_of_cmds ()
{
  int n;

  ndefkey (Vglobal_map, Ctl('M'), "newline");
  ndefkey (Vglobal_map, Ctl('I'), "self-insert-command");
  for (n = 040; n < 0177; n++)
    ndefkey (Vglobal_map, n, "self-insert-command");

  ndefkey (Vglobal_map, Ctl ('A'), "beginning-of-line");
  ndefkey (Vglobal_map, Ctl ('B'), "backward-char");
  ndefkey (Vglobal_map, Ctl ('D'), "delete-char");
  ndefkey (Vglobal_map, Ctl ('E'), "end-of-line");
  ndefkey (Vglobal_map, Ctl ('F'), "forward-char");
  ndefkey (Vglobal_map, 0177, "delete-backward-char");
}
