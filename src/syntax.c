/* GNU Emacs routines to deal with syntax tables; also word and list parsing.
   Copyright (C) 1985, 1987, 1990 Free Software Foundation, Inc.

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

/* 91.12.22 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.4.9   modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Bug fixed in char_syntax_at(). */
/* 92.7.16  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	Sextword is appended in syntaxcode.
	New entry Fsyntax_spec_code() and Fsyntax_code_spec are added. */
/* 92.7.17  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	Fforward_word() tries regular expression search if 'word' is
	defined as a regular expression. */
/* 92.8.21  modified for Mule Ver.0.9.6 by K.Nozoe <nozoe@telcom.oki.co.jp>
	In Fsyntax_code_spec(), Smax is coerced to 'int'. */
/* 92.12.22 modified for Mule Ver.0.9.7
			by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	Argument number of modify-syntax-entry corrected. */
/* 93.6.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	describe_syntax_1() shows deeper syntax. */
/* 93.7.13  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Format of wordbuf changed.
	syntax_table_version introduced. */
/* 94.2.23  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	describe-syntax displays multilingual text. */

#include "config.h"
#include <ctype.h>
#include "lisp.h"
#include "commands.h"
#include "buffer.h"
#include "syntax.h"
#include "category.h"
#include "regex.h"		/* 92.7.17 by K.Handa */
#include "mule.h"		/* 91.12.22 by K.Handa */

Lisp_Object Qsyntax_table_p;

/* 93.7.12 by K.Handa */
/* The version of the syntax_table created or modified lastly. */
unsigned int syntax_table_version;

void describe_syntax_2 (Lisp_Object, unsigned int);
int char_quoted (int);

DEFUN ("syntax-table-p", Fsyntax_table_p, Ssyntax_table_p, 1, 1, 0,
  "Return t if ARG is a syntax table.\n\
Any vector of 256 elements will do.")
  (Lisp_Object obj)
{
  if (XTYPE (obj) == Lisp_Vector && XVECTOR (obj)->size == 0400)
    return Qt;
  return Qnil;
}

Lisp_Object
check_syntax_table (Lisp_Object obj)
{
  register Lisp_Object tem;
  while (tem = Fsyntax_table_p (obj),
	 NILP (tem))
    obj = wrong_type_argument (Qsyntax_table_p, obj);
  return obj;
}   


DEFUN ("syntax-table", Fsyntax_table, Ssyntax_table, 0, 0, 0,
  "Return the current syntax table.\n\
This is the one specified by the current buffer.")
  (void)
{
  return current_buffer->syntax_table;
}

DEFUN ("standard-syntax-table", Fstandard_syntax_table,
   Sstandard_syntax_table, 0, 0, 0,
  "Return the standard syntax table.\n\
This is the one used for new buffers.")
  (void)
{
  return Vstandard_syntax_table;
}

/* 92.1.10 by K.Handa */
Lisp_Object
copy_syntax_table (Lisp_Object table)
{
  Lisp_Object size, val;
  struct Lisp_Vector *v;
  int i;
  XFASTINT (size) = 0400;
  XFASTINT (val) = 0;
  val = Fmake_vector (size, val);
  bcopy (XVECTOR (table)->contents,
	 XVECTOR (val)->contents, 0400 * sizeof (Lisp_Object));

  v = XVECTOR (table);
  for (i = 0; i < 0400; i++)
    if (XTYPE (v->contents[i]) != Lisp_Int)
      v->contents[i] = copy_syntax_table(v->contents[i]);

  return val;
}
/* end of patch */

DEFUN ("copy-syntax-table", Fcopy_syntax_table, Scopy_syntax_table, 0, 1, 0,
  "Construct a new syntax table and return it.\n\
It is a copy of the TABLE, which defaults to the standard syntax table.")
  (Lisp_Object table)
{				/* 92.1.10 by K.Handa */
  Lisp_Object size, val;
  XFASTINT (size) = 0400;
  XFASTINT (val) = 0;
  val = Fmake_vector (size, val);
  if (!NILP (table))
    table = check_syntax_table (table);
  else if (NILP (Vstandard_syntax_table))
    /* Can only be null during initialization */
    return val;
  else table = Vstandard_syntax_table;

  syntax_table_version++;	/* 93.7.12 by K.Handa */
  return copy_syntax_table(table);
}

DEFUN ("set-syntax-table", Fset_syntax_table, Sset_syntax_table, 1, 1, 0,
  "Select a new syntax table for the current buffer.\n\
One argument, a syntax table.")
  (Lisp_Object table)
{
  table = check_syntax_table (table);
  current_buffer->syntax_table = table;
  /* Indicate that this buffer now has a specified syntax table.  */
  current_buffer->local_var_flags |= buffer_local_flags.syntax_table;
  return table;
}

/* Convert a letter which signifies a syntax code
 into the code it signifies.
 This is used by modify-syntax-entry, and other things. */

unsigned char syntax_spec_code[0400] =
  { 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    (char) Swhitespace, 0377, (char) Sstring, 0377,
        (char) Smath, 0377, 0377, (char) Squote,
    (char) Sopen, (char) Sclose, 0377, 0377,
	0377, (char) Swhitespace, (char) Spunct, (char) Scharquote,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    0377, 0377, 0377, 0377,
	(char) Scomment, 0377, (char) Sendcomment, 0377,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,   /* @, A, ... */
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, (char) Sword,
    0377, 0377, 0377, 0377, (char) Sescape, 0377, 0377, (char) Ssymbol,
    0377, 0377, 0377, 0377, 0377, (char) Sextword, /* 92.7.16 by K.Handa */
      0377, 0377, /* `, a, ... */
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, (char) Sword,
    0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377
  };

/* Indexed by syntax code, give the letter that describes it. */

char syntax_code_spec[14] =	/* 92.7.16 by K.Handa */
  {
    ' ', '.', 'w', '_', '(', ')', '\'', '\"', '$', '\\', '/', '<', '>', 'e'
  };

/* 92.7.16 by K.Handa */
DEFUN ("syntax-spec-code", Fsyntax_spec_code, Ssyntax_spec_code, 1, 1, 0,
  "Return the internale syntax code for the MNEMONIC of syntax in integer.\n\
-1 means illegal MNEMONIC.")
  (Lisp_Object code)
{
  CHECK_NUMBER (code, 0);
  return XINT (syntax_spec_code[XFASTINT (code) & 0xFF]);
}

DEFUN ("syntax-code-spec", Fsyntax_code_spec, Ssyntax_code_spec, 1, 1, 0,
  "Return the mnemonic of syntax for the internal syntax code CODE.")
  (Lisp_Object code)
{
  CHECK_NUMBER (code, 0);
  if (XFASTINT (code) >= (int)Smax) return XINT (0); /* K.Nozoe */
  return XINT (syntax_code_spec[XFASTINT (code)]);
}
/* end of patch */


/* 92.2.3 by K.Handa */
Lisp_Object
char_syntax (register unsigned int c)
{				/* 93.2.12 by K.Handa */
  register struct Lisp_Vector *v = XVECTOR (current_buffer->syntax_table);
  unsigned char str[4], *p = str;
  register int i = CHARtoSTR (c, str);

  while (i > 1 && XTYPE (v->contents[*p]) == Lisp_Vector) {
    v = XVECTOR (v->contents[*p]);
    p++, i--;
  }
  return (v->contents[*p]);
}

/* 92.4.30 by K.Handa -- char_syntax_at gets two arguments now. */
Lisp_Object
char_syntax_at (register unsigned char *p, int len)
{				/* 92.4.9, 93.2.12 by K.Handa - big change */
  register Lisp_Object val;
  register unsigned char c = *p++;

  if (c == LCCMP) {
    len--, c = *p++ - 0x20;
    if (c == 0x80)
      len--, c = *p++ & 0x7F;
  }
  val = XVECTOR (current_buffer->syntax_table)->contents[c];
  if (NILP (current_buffer->mc_flag)) {
    if (XTYPE (val) != Lisp_Int)
      XSET (val, Lisp_Int, 0);
  } else {
    while (XTYPE (val) == Lisp_Vector) {
      if (len-- && NONASCII_P(*p)) /* 92.4.30 by K.Handa */
	val = XVECTOR (val)->contents[*p];
      else {
	XSET (val, Lisp_Int, 0);
	break;
      }
      p++;
    }
  }
  return val;
}
/* end of patch */

DEFUN ("char-syntax", Fchar_syntax, Schar_syntax, 1, 1, 0,
  "Return the syntax code of CHAR, described by a character.\n\
For example, if CHAR is a word constituent, ?w is returned.\n\
The characters that correspond to various syntax codes\n\
are listed in the documentation of  modify-syntax-entry.")
  (Lisp_Object ch)
{				/* 92.1.10 by K.Handa */
  CHECK_CHARACTER (ch, 0);
  return make_number (syntax_code_spec[(int) SYNTAX (ch)]);
}

/* 92.1.10, 92.4.30 by K.Handa */
DEFUN ("char-syntax-at", Fchar_syntax_at, Schar_syntax_at, 1, 1, 0,
  "Return the syntax code of the character at position POS")
  (Lisp_Object pos)
{
  unsigned char *p, *pend;
  int n;

  CHECK_NUMBER_COERCE_MARKER (pos, 0);
  n = XFASTINT (pos);
  if (pos >= GPT)
    p = BEG_ADDR - 1 + GAP_SIZE + n, pend = ZV_ADDR + 1;
  else
    p = BEG_ADDR - 1 + n, pend = GPT_ADDR;
  return make_number (syntax_code_spec[(int) SYNTAX_AT (p, pend - p)]);
}

DEFUN ("char-syntax-match", Fchar_syntax_match, Schar_syntax_match, 1, 1, 0,
  "Return the match character of CHAR.\n\
If there's no match character defined in the syntax of CHAR, 0 is returned.")
  (Lisp_Object ch)
{
  unsigned int c;

  CHECK_CHARACTER (ch, 0);
  c = XFASTINT (ch) & 0xFFFF00 | SYNTAX_MATCH (ch);
  return make_number (c);
}
/* end of patch */

void
modify_syntax_entry (register unsigned int c, Lisp_Object tbl, Lisp_Object syntax)
{				/* 93.2.12 by K.Handa */
  Lisp_Object size, val;
  unsigned char str[4], *p = str;
  register int i = CHARtoSTR (c, str);

  XFASTINT (size) = 0400;
  XFASTINT (val) = 0;

  while (i-- > 1) {
    if (XTYPE (XVECTOR (tbl)->contents[*p]) != Lisp_Vector)
      XVECTOR (tbl)->contents[*p] = Fmake_vector (size, val);
    tbl = XVECTOR (tbl)->contents[*p];
    p++;
  }
  XVECTOR (tbl)->contents[*p] = syntax;
}

/* This comment supplies the doc string for modify-syntax-entry,
   for make-docfile to see.  We cannot put this in the real DEFUN
   due to limits in the Unix cpp.

DEFUN ("modify-syntax-entry", foo, bar, 0, 0, 0,
  "Set syntax for character CHAR according to string S.\n\
CHAR can be any multilingual character.\n\
The syntax is changed only for table TABLE, which defaults to\n\
 the current buffer's syntax table.\n\
The first character of S should be one of the following:\n\
  Space or -   whitespace syntax.    w   word constituent.\n\
  _            symbol constituent.   .   punctuation.\n\
  (            open-parenthesis.     )   close-parenthesis.\n\
  \"            string quote.         \\   escape character.\n\
  $            paired delimiter.     '   expression prefix operator.\n\
  <            comment starter.      >   comment ender.\n\
  /	       character quote.\n\
Only single-character comment start and end sequences are represented thus.\n\
Two-character sequences are represented as described below.\n\
The second character of S is the matching parenthesis,\n\
 used only if the first character is ( or ).\n\
If CHAR is a multilingual character,\n\
 it should be the same as CHAR except for the last byte.\n\
Any additional characters are flags.\n\
Defined flags are the characters 1, 2, 3 and 4.\n\
 1 means C is the start of a two-char comment start sequence.\n\
 2 means C is the second character of such a sequence.\n\
 3 means C is the start of a two-char comment end sequence.\n\
 4 means C is the second character of such a sequence.")\n\
*/

/* 92.12.22 by M.Higashida */
DEFUN ("modify-syntax-entry", Fmodify_syntax_entry, Smodify_syntax_entry, 2, 3, 
  /* I really don't know why this is interactive
     help-form should at least be made useful whilst reading the second arg
   */
  "cSet syntax for character: \nsSet syntax for %s to: ",
  0 /* See immediately above */)
  (Lisp_Object c, Lisp_Object newentry, Lisp_Object syntax_table) /* 91.12.22 by K.Handa */
{
  register unsigned char *p, match;
  register enum syntaxcode code;
  Lisp_Object val;

  CHECK_CHARACTER (c, 0);	/* 92.1.10 by K.Handa */
  CHECK_STRING (newentry, 1);
  if (NILP (syntax_table))
    syntax_table = current_buffer->syntax_table;
  else
    syntax_table = check_syntax_table (syntax_table);

  p = XSTRING (newentry)->data;
  code = (enum syntaxcode) syntax_spec_code[*p++];
  if (((int) code & 0377) == 0377)
    error ("invalid syntax description letter: %c", c);

  match = *p;
  if (match) p++;
  if (LC_P(match)) {
    while (NONASCII_P(*p)) p++;
    match = *(p - 1);
  }
  if (match == ' ') match = 0;

  XFASTINT (val) = (match << 8) + (int) code;
  while (*p)
    switch (*p++)
      {
      case '1':
	XFASTINT (val) |= 1 << 16;
	break;

      case '2':
	XFASTINT (val) |= 1 << 17;
	break;

      case '3':
	XFASTINT (val) |= 1 << 18;
	break;

      case '4':
	XFASTINT (val) |= 1 << 19;
	break;
      }
	
  modify_syntax_entry(c, syntax_table, val); /* 92.1.10 by K.Handa */
  syntax_table_version++;
  return Qnil;
}

/* Dump syntax table to buffer in human-readable format */

void
describe_syntax (Lisp_Object value, unsigned int parent) /* 93.6.7, 94.2.23 by K.Handa */
{
  register enum syntaxcode code;
  char desc, match, start1, start2, end1, end2;
  char str[2];

  Findent_to (make_number (24), make_number (1));

  if (XTYPE (value) == Lisp_Vector) /* 92.1.10 by K.Handa */
    {
      InsStr ("deeper\t");
      if (LCCMP <= parent && parent < LCINV)
	InsStr (char_description[parent & 0x7F]);
      InsStr ("\n");
      describe_syntax_2 (value, parent);
      return;
    }

  if (XTYPE (value) != Lisp_Int)
    {
      InsStr ("invalid");
      return;
    }

  code = (enum syntaxcode) (XINT (value) & 0377);
  match = (XINT (value) >> 8) & 0377;
  start1 = (XINT (value) >> 16) & 1;
  start2 = (XINT (value) >> 17) & 1;
  end1 = (XINT (value) >> 18) & 1;
  end2 = (XINT (value) >> 19) & 1;

  if ((int) code < 0 || (int) code >= (int) Smax)
    {
      InsStr ("invalid");
      return;
    }
  desc = syntax_code_spec[(int) code];

  str[0] = desc, str[1] = 0;
  insert (str, 1);

  if (match)
    insert_character_description((parent & 0xFFFFFF00) | (unsigned char)match);
  else
    insert (" ", 1);

  if (start1)
    insert ("1", 1);
  if (start2)
    insert ("2", 1);

  if (end1)
    insert ("3", 1);
  if (end2)
    insert ("4", 1);

  InsStr ("\twhich means: ");

#ifdef SWITCH_ENUM_BUG
  switch ((int) code)
#else
  switch (code)
#endif
    {
    case Swhitespace:
      InsStr ("whitespace"); break;
    case Spunct:
      InsStr ("punctuation"); break;
    case Sword:
      InsStr ("word"); break;
    case Ssymbol:
      InsStr ("symbol"); break;
    case Sopen:
      InsStr ("open"); break;
    case Sclose:
      InsStr ("close"); break;
    case Squote:
      InsStr ("quote"); break;
    case Sstring:
      InsStr ("string"); break;
    case Smath:
      InsStr ("math"); break;
    case Sescape:
      InsStr ("escape"); break;
    case Scharquote:
      InsStr ("charquote"); break;
    case Scomment:
      InsStr ("comment"); break;
    case Sendcomment:
      InsStr ("endcomment"); break;
    case Sextword:
      InsStr ("extword"); break;
    default:
      InsStr ("invalid");
      return;
    }

  if (match)
    {
      InsStr (", matches ");
      insert_character_description ((parent&0xFFFFFF00)|(unsigned char)match);
    }

  if (start1)
    InsStr (",\n\t  is the first character of a comment-start sequence");
  if (start2)
    InsStr (",\n\t  is the second character of a comment-start sequence");

  if (end1)
    InsStr (",\n\t  is the first character of a comment-end sequence");
  if (end2)
    InsStr (",\n\t  is the second character of a comment-end sequence");

  InsStr ("\n");
}

void
describe_syntax_2 (Lisp_Object vector, unsigned int parent) /* 93.6.7, 94.2.23 by K.Handa */
{
  int i, start;
  struct Lisp_Vector *v = XVECTOR (vector);
  int indent = !parent ? 0 : parent < 0x100 ? 2 : parent < 0x10000 ? 4 : 6;

  for (i = parent ? 0xa0 : 0; i < v->size; i++) {
    Findent_to (make_number (indent), make_number (0));
    insert_character_description((parent << 8) | i);
    start = i;

    while (i < 0xFF
	   && XFASTINT (v->contents[i]) == XFASTINT (v->contents[i + 1]))
      i++;

    if (i != start) {
      insert (" .. ", 4);
      insert_character_description((parent << 8) | i);
    }

    describe_syntax (v->contents[i], (parent << 8) | i);
  }
}

Lisp_Object
describe_syntax_1 (Lisp_Object vector)
{
  struct buffer *old = current_buffer;
  set_buffer_internal (XBUFFER (Vstandard_output));
  describe_syntax_2 (vector, 0); /* 93.6.7 by K.Handa */
  set_buffer_internal (old);
  return Qnil;
}

DEFUN ("describe-syntax", Fdescribe_syntax, Sdescribe_syntax, 0, 0, "",
  "Describe the syntax specifications in the syntax table.\n\
The descriptions are inserted in a buffer, which is selected so you can see it.")
  (void)
{
  internal_with_output_to_temp_buffer
     ("*Help*", describe_syntax_1, current_buffer->syntax_table);

  return Qnil;
}

/* Return the position across `count' words from `from'.
   If that many words cannot be found before the end of the buffer, return 0.
   `count' negative means scan backward and stop at word beginning.  */

int
scan_words (register int from, register int count)
{
  register int beg = BEGV;
  register int end = ZV;
  register int temp;		/* 92.1.10 by K.Handa */
  register unsigned int c;	/* 92.1.10 by K.Handa */
  enum syntaxcode s;		/* 92.7.16 by K.Handa */

  immediate_quit = 1;
  QUIT;

  while (count > 0)
    {				/* 92.1.10 by K.Handa -- Big change here! */
      while (1)
	{
	  if (from == end)
	    {
	      immediate_quit = 0;
	      return 0;
	    }
	  FETCH_MC_CHAR (c, from);
	  if ((s = SYNTAX(c)) == Sword
	      || s == Sextword) /* 92.7.16 by K.Handa */
	    break;
	  INC_POS (from);
	}
      while (1)
	{
	  if (from == end) break;
	  FETCH_MC_CHAR (c, from);
	  if ((s = SYNTAX(c)) != Sword
	      && s != Sextword)	/* 92.7.16 by K.Handa */
	    break;
	  INC_POS (from);
	}
      count--;
    }
  while (count < 0)
    {
      while (1)
	{
	  if (from == beg)
	    {
	      immediate_quit = 0;
	      return 0;
	    }
	  temp = from;
	  DEC_POS (temp);
	  FETCH_MC_CHAR (c, temp);
	  if ((s = SYNTAX(c)) == Sword
	      || s == Sextword)	/* 92.7.16 by K.Handa */
	    break;
	  from = temp;
	}
      while (1)
	{
	  if (from == beg) break;
	  temp = from;
	  DEC_POS (temp);
	  FETCH_MC_CHAR (c, temp);
	  if ((s = SYNTAX(c)) != Sword
	      && s != Sextword)	/* 92.7.16 by K.Handa */
	    break;
	  from = temp;
	}
      count++;
    }

  immediate_quit = 0;

  return from;
}

DEFUN ("forward-word", Fforward_word, Sforward_word, 1, 1, "p",
  "Move point forward ARG words (backward if ARG is negative).\n\
Normally returns t.\n\
If an edge of the buffer is reached, point is left there\n\
and nil is returned.")
  (Lisp_Object count)
{
  int val;
  CHECK_NUMBER (count, 0);

/* 92.7.17 by K.Handa */
  if (wordbuf[0]		/* 93.7.13 by K.Handa */
      && !NILP (Vforward_word_regexp)
      && !NILP (Vbackward_word_regexp)) {
    Lisp_Object re;
    int np, lim;

    CHECK_STRING (Vforward_word_regexp, 0);
    CHECK_STRING (Vbackward_word_regexp, 1);
    if (XINT (count) > 0) re = Vforward_word_regexp, lim = ZV;
    else re = Vbackward_word_regexp, lim = BEGV;
    if ((np = search_buffer(re, point, lim, XINT (count), 1, 0)) <= 0) {
      SET_PT (lim);
      return Qnil;
    } else {
      SET_PT (np);
      return Qt;
    }
  }
/* end of patch */
  if (!(val = scan_words (point, XINT (count))))
    {
      SET_PT (XINT (count) > 0 ? ZV : BEGV);
      return Qnil;
    }
  SET_PT (val);
  return Qt;
}

int parse_sexp_ignore_comments;

Lisp_Object
scan_lists (register int from, int count, int depth, int sexpflag)
{				/* 92.1.10 by K.Handa -- Big change here! */
  Lisp_Object val;
  register int stop, temp;
  register unsigned int c, c1;
  unsigned int stringterm;
  int quoted;
  int mathexit = 0;
  register enum syntaxcode code;
  int min_depth = depth;    /* Err out if depth gets less than this. */

  if (depth > 0) min_depth = 0;

  immediate_quit = 1;
  QUIT;

  while (count > 0)
    {
      stop = ZV;
      while (from < stop)
	{
	  FETCH_MC_CHAR (c, from);
	  code = SYNTAX(c);
	  INC_POS (from);
	  if (from < stop && SYNTAX_COMSTART_FIRST (c)) {
	    FETCH_MC_CHAR (c, from);
	    if (SYNTAX_COMSTART_SECOND (c)
		&& parse_sexp_ignore_comments) {
	      code = Scomment;
	      INC_POS (from);
	    }
	  }

#ifdef SWITCH_ENUM_BUG
	  switch ((int) code)
#else
	  switch (code)
#endif
	    {
	    case Sescape:
	    case Scharquote:
	      if (from == stop) goto lose;
	      INC_POS (from);
	      /* treat following character as a word constituent */
	    case Sword:
	    case Sextword:	/* 92.7.16 by K.Handa */
	    case Ssymbol:
	      if (depth || !sexpflag) break;
	      /* This word counts as a sexp; return at end of it. */
	      while (from < stop)
		{
		  FETCH_MC_CHAR (c, from);
#ifdef SWITCH_ENUM_BUG
		  switch ((int) SYNTAX(c))
#else
		  switch (SYNTAX(c))
#endif
		    {
		    case Scharquote:
		    case Sescape:
		      INC_POS (from);
		      if (from == stop) goto lose;
		      break;
		    case Sword:
		    case Ssymbol:
		    case Squote:
		    case Sextword: /* 92.7.16 by K.Handa */
		      break;
		    default:
		      goto done;
		    }
		  INC_POS (from);
		}
	      goto done;

	    case Scomment:
	      if (!parse_sexp_ignore_comments) break;
	      while (1)
		{
		  if (from == stop) goto done;
		  FETCH_MC_CHAR (c, from);
		  if (SYNTAX (c) == Sendcomment)
		    break;
		  INC_POS (from);
		  FETCH_MC_CHAR (c1, from);
		  if (from < stop && SYNTAX_COMEND_FIRST (c)
		       && SYNTAX_COMEND_SECOND (c1))
		    { INC_POS (from); break; }
		}
	      break;

	    case Smath:
	      if (!sexpflag)
		break;
	      FETCH_MC_CHAR (c1, from);
	      if (from != stop && c == c1)
		INC_POS (from);
	      if (mathexit)
		{
		  mathexit = 0;
		  goto close1;
		}
	      mathexit = 1;

	    case Sopen:
	      if (!++depth) goto done;
	      break;

	    case Sclose:
	    close1:
	      if (!--depth) goto done;
	      if (depth < min_depth)
		error ("Containing expression ends prematurely");
	      break;

	    case Sstring:
	      stringterm = c;
	      while (1)
		{
		  if (from >= stop) goto lose;
		  FETCH_MC_CHAR (c, from);
		  if (c == stringterm) break;
#ifdef SWITCH_ENUM_BUG
		  switch ((int) SYNTAX(c))
#else
		  switch (SYNTAX(c))
#endif
		    {
		    case Scharquote:
		    case Sescape:
		      INC_POS (from);
		    }
		  INC_POS (from);
		}
	      INC_POS (from);
	      if (!depth && sexpflag) goto done;
	      break;
	    }
	}

      /* Reached end of buffer.  Error if within object, return nil if between */
      if (depth) goto lose;

      immediate_quit = 0;
      return Qnil;

      /* End of object reached */
    done:
      count--;
    }

  while (count < 0)
    {
      stop = BEGV;
      while (from > stop)
	{
	  DEC_POS (from);
	  if (quoted = char_quoted (from))
	    DEC_POS (from);
	  FETCH_MC_CHAR (c, from);
	  code = SYNTAX (c);
	  if (from > stop && SYNTAX_COMEND_SECOND (c)) {
	    temp = from;
	    DEC_POS (temp);
	    FETCH_MC_CHAR (c, temp);
	    if (SYNTAX_COMEND_FIRST (c)
		&& !char_quoted (temp)
		&& parse_sexp_ignore_comments) {
	      code = Sendcomment;
	      from = temp;
	    }
	  }

#ifdef SWITCH_ENUM_BUG
	  switch ((int) (quoted ? Sword : code))
#else
	  switch (quoted ? Sword : code)
#endif
	    {
	    case Sword:
	    case Sextword:	/* 92.7.16 by K.Handa */
	    case Ssymbol:
	      if (depth || !sexpflag) break;
	      /* This word counts as a sexp; count object finished after passing it. */
	      while (from > stop)
		{
		  enum syntaxcode s; /* 92.7.16 by K.Handa */

		  temp = from;
		  DEC_POS (temp);
		  if (quoted = char_quoted (temp))
		    from = temp;
		  temp = from;
		  DEC_POS (temp);
		  FETCH_MC_CHAR (c, temp);
		  if (! (quoted || (s = SYNTAX(c)) == Sword ||
			 s == Sextword || /* 92.7.16 by K.Handa */
			 s == Ssymbol ||
			 s == Squote))
            	    goto done2;
		  from = temp;
		}
	      goto done2;

	    case Smath:
	      if (!sexpflag)
		break;
	      temp = from;
	      DEC_POS (temp);
	      FETCH_MC_CHAR (c1, temp);
	      if (from != stop && c == c1)
		from = temp;
	      if (mathexit)
		{
		  mathexit = 0;
		  goto open2;
		}
	      mathexit = 1;

	    case Sclose:
	      if (!++depth) goto done2;
	      break;

	    case Sopen:
	    open2:
	      if (!--depth) goto done2;
	      if (depth < min_depth)
		error ("Containing expression ends prematurely");
	      break;

	    case Sendcomment:
	      if (!parse_sexp_ignore_comments) break;
	      if (from != stop) DEC_POS (from);
	      while (1)
		{
		  FETCH_MC_CHAR (c, from);
		  if (SYNTAX (c) == Scomment)
		    break;
		  if (from == stop) goto done;
		  DEC_POS (from);
		  FETCH_MC_CHAR (c1, from);
		  if (SYNTAX_COMSTART_SECOND (c)
		      && SYNTAX_COMSTART_FIRST (c1)
		      && !char_quoted (from))
		    break;
		}
	      break;

	    case Sstring:
	      FETCH_MC_CHAR (stringterm, from);
	      while (1)
		{
		  if (from == stop) goto lose;
		  temp = from;
		  DEC_POS (temp);
		  FETCH_MC_CHAR (c, temp);
		  if (!char_quoted (temp) && stringterm == c)
		    break;
		  from = temp;
		}
	      DEC_POS (from);
	      if (!depth && sexpflag) goto done2;
	      break;
	    }
	}

      /* Reached start of buffer.  Error if within object, return nil if between */
      if (depth) goto lose;

      immediate_quit = 0;
      return Qnil;

    done2:
      count++;
    }


  immediate_quit = 0;
  XFASTINT (val) = from;
  return val;

 lose:
  error ("Unbalanced parentheses");
  /* NOTREACHED */
}

int
char_quoted (register int pos)
{
  register enum syntaxcode code;
  register int beg = BEGV;
  register int quoted = 0;
  register unsigned int c;	/* 92.1.10 by K.Handa */

  while (pos > beg) {		/* 92.1.10 by K.Handa */
    DEC_POS (pos);
    FETCH_MC_CHAR (c, pos);
    if ((code = SYNTAX (c)) != Scharquote && code != Sescape) break;
    quoted = !quoted;
  }
  return quoted;
}

DEFUN ("scan-lists", Fscan_lists, Sscan_lists, 3, 3, 0,
  "Scan from character number FROM by COUNT lists.\n\
Returns the character number of the position thus found.\n\
\n\
If DEPTH is nonzero, paren depth begins counting from that value,\n\
only places where the depth in parentheses becomes zero\n\
are candidates for stopping; COUNT such places are counted.\n\
Thus, a positive value for DEPTH means go out levels.\n\
\n\
Comments are ignored if parse-sexp-ignore-comments is non-nil.\n\
\n\
If the beginning or end of (the visible part of) the buffer is reached\n\
and the depth is wrong, an error is signaled.\n\
If the depth is right but the count is not used up, nil is returned.")
  (Lisp_Object from, Lisp_Object count, Lisp_Object depth)
{
  CHECK_NUMBER (from, 0);
  CHECK_NUMBER (count, 1);
  CHECK_NUMBER (depth, 2);

  return scan_lists (XINT (from), XINT (count), XINT (depth), 0);
}

DEFUN ("scan-sexps", Fscan_sexps, Sscan_sexps, 2, 2, 0,
  "Scan from character number FROM by COUNT balanced expressions.\n\
Returns the character number of the position thus found.\n\
\n\
Comments are ignored if parse-sexp-ignore-comments is non-nil.\n\
\n\
If the beginning or end of (the visible part of) the buffer is reached\n\
in the middle of a parenthetical grouping, an error is signaled.\n\
If the beginning or end is reached between groupings but before count is used up,\n\
nil is returned.")
  (Lisp_Object from, Lisp_Object count)
{
  CHECK_NUMBER (from, 0);
  CHECK_NUMBER (count, 1);

  return scan_lists (XINT (from), XINT (count), 0, 1);
}

DEFUN ("backward-prefix-chars", Fbackward_prefix_chars, Sbackward_prefix_chars,
  0, 0, 0,
  "Move point backward over any number of chars with syntax \"prefix\".")
  (void)
{
  int beg = BEGV;
  int pos = point;

  while (pos > beg && !char_quoted (pos - 1) && SYNTAX (FETCH_CHAR (pos - 1)) == Squote)
    pos--;

  SET_PT (pos);

  return Qnil;
}

struct lisp_parse_state
  {
    int depth;		/* Depth at end of parsing */
    int instring;	/* -1 if not within string, else desired terminator. */
    int incomment;	/* Nonzero if within a comment at end of parsing */
    int quoted;		/* Nonzero if just after an escape char at end of parsing */
    int thislevelstart;	/* Char number of most recent start-of-expression at current level */
    int prevlevelstart; /* Char number of start of containing expression */
    int location;	/* Char number at which parsing stopped. */
    int mindepth;	/* Minimum depth seen while scanning.  */
  };

/* Parse forward from FROM to END,
   assuming that FROM is the start of a function, 
   and return a description of the state of the parse at END. */

struct lisp_parse_state val_scan_sexps_forward;

struct lisp_parse_state *
scan_sexps_forward (register int from, int end, int targetdepth, int stopbefore, Lisp_Object oldstate)
{
  struct lisp_parse_state state;

  register enum syntaxcode code;
  struct level { int last, prev; };
  struct level levelstart[100];
  register struct level *curlevel = levelstart;
  struct level *endlevel = levelstart + 100;
  char prev;
  register int depth;	/* Paren depth of current scanning location.
			   level - levelstart equals this except
			   when the depth becomes negative.  */
  int mindepth;		/* Lowest DEPTH value seen.  */
  int start_quoted = 0;		/* Nonzero means starting after a char quote */
  Lisp_Object tem;

  immediate_quit = 1;
  QUIT;

  if (NILP (oldstate))
    {
      depth = 0;
      state.instring = -1;
      state.incomment = 0;
    }
  else
    {
      tem = Fcar (oldstate);
      if (!NILP (tem))
	depth = XINT (tem);
      else
	depth = 0;

      oldstate = Fcdr (oldstate);
      oldstate = Fcdr (oldstate);
      oldstate = Fcdr (oldstate);
      tem = Fcar (oldstate);
      state.instring = !NILP (tem) ? XINT (tem) : -1;

      oldstate = Fcdr (oldstate);
      tem = Fcar (oldstate);
      state.incomment = !NILP (tem);

      oldstate = Fcdr (oldstate);
      tem = Fcar (oldstate);
      start_quoted = !NILP (tem);
    }
  state.quoted = 0;
  mindepth = depth;

  curlevel->prev = -1;
  curlevel->last = -1;

  /* Enter the loop at a place appropriate for initial state. */

  if (state.incomment) goto startincomment;
  if (state.instring >= 0)
    {
      if (start_quoted) goto startquotedinstring;
      goto startinstring;
    }
  if (start_quoted) goto startquoted;

  while (from < end)
    {
      code = SYNTAX(FETCH_CHAR (from));
      from++;
      if (from < end && SYNTAX_COMSTART_FIRST (FETCH_CHAR (from - 1))
	   && SYNTAX_COMSTART_SECOND (FETCH_CHAR (from)))
	code = Scomment, from++;
#ifdef SWITCH_ENUM_BUG
      switch ((int) code)
#else
      switch (code)
#endif
	{
	case Sescape:
	case Scharquote:
	  if (stopbefore) goto stop;  /* this arg means stop at sexp start */
	  curlevel->last = from - 1;
	startquoted:
	  if (from == end) goto endquoted;
	  from++;
	  goto symstarted;
	  /* treat following character as a word constituent */
	case Sword:
	case Sextword:		/* 92.7.16 by K.Handa */
	case Ssymbol:
	  if (stopbefore) goto stop;  /* this arg means stop at sexp start */
	  curlevel->last = from - 1;
	symstarted:
	  while (from < end)
	    {
#ifdef SWITCH_ENUM_BUG
	      switch ((int) SYNTAX(FETCH_CHAR (from)))
#else
	      switch (SYNTAX(FETCH_CHAR (from)))
#endif
		{
		case Scharquote:
		case Sescape:
		  from++;
		  if (from == end) goto endquoted;
		  break;
		case Sword:
		case Sextword:	/* 92.7.16 by K.Handa */
		case Ssymbol:
		case Squote:
		  break;
		default:
		  goto symdone;
		}
	      from++;
	    }
	symdone:
	  curlevel->prev = curlevel->last;
	  break;

	case Scomment:
	  state.incomment = 1;
	startincomment:
	  while (1)
	    {
	      if (from == end) goto done;
	      if (SYNTAX (prev = FETCH_CHAR (from)) == Sendcomment)
		break;
	      from++;
	      if (from < end && SYNTAX_COMEND_FIRST (prev)
		   && SYNTAX_COMEND_SECOND (FETCH_CHAR (from)))
		{ from++; break; }
	    }
	  state.incomment = 0;
	  break;

	case Sopen:
	  if (stopbefore) goto stop;  /* this arg means stop at sexp start */
	  depth++;
	  /* curlevel++->last ran into compiler bug on Apollo */
	  curlevel->last = from - 1;
	  if (++curlevel == endlevel)
	    error ("Nesting too deep for parser");
	  curlevel->prev = -1;
	  curlevel->last = -1;
	  if (!--targetdepth) goto done;
	  break;

	case Sclose:
	  depth--;
	  if (depth < mindepth)
	    mindepth = depth;
	  if (curlevel != levelstart)
	    curlevel--;
	  curlevel->prev = curlevel->last;
	  if (!++targetdepth) goto done;
	  break;

	case Sstring:
	  if (stopbefore) goto stop;  /* this arg means stop at sexp start */
	  curlevel->last = from - 1;
	  state.instring = FETCH_CHAR (from - 1);
	startinstring:
	  while (1)
	    {
	      if (from >= end) goto done;
	      if (FETCH_CHAR (from) == state.instring) break;
#ifdef SWITCH_ENUM_BUG
	      switch ((int) SYNTAX(FETCH_CHAR (from)))
#else
	      switch (SYNTAX(FETCH_CHAR (from)))
#endif
		{
		case Scharquote:
		case Sescape:
		  from++;
		startquotedinstring:
		  if (from >= end) goto endquoted;
		}
	      from++;
	    }
	  state.instring = -1;
	  curlevel->prev = curlevel->last;
	  from++;
	  break;

	case Smath:
	  break;
	}
    }
  goto done;

 stop:   /* Here if stopping before start of sexp. */
  from--;    /* We have just fetched the char that starts it; */
  goto done; /* but return the position before it. */

 endquoted:
  state.quoted = 1;
 done:
  state.depth = depth;
  state.mindepth = mindepth;
  state.thislevelstart = curlevel->prev;
  state.prevlevelstart
    = (curlevel == levelstart) ? -1 : (curlevel - 1)->last;
  state.location = from;
  immediate_quit = 0;

  val_scan_sexps_forward = state;
  return &val_scan_sexps_forward;
}

/* This comment supplies the doc string for parse-partial-sexp,
   for make-docfile to see.  We cannot put this in the real DEFUN
   due to limits in the Unix cpp.

DEFUN ("parse-partial-sexp", Ffoo, Sfoo, 0, 0, 0,
  "Parse Lisp syntax starting at FROM until TO; return status of parse at TO.\n\
Parsing stops at TO or when certain criteria are met;\n\
 point is set to where parsing stops.\n\
If fifth arg STATE is omitted or nil,\n\
 parsing assumes that FROM is the beginning of a function.\n\
Value is a list of seven elements describing final state of parsing:\n\
 1. depth in parens.\n\
 2. character address of start of innermost containing list; nil if none.\n\
 3. character address of start of last complete sexp terminated.\n\
 4. non-nil if inside a string.\n\
    (it is the character that will terminate the string.)\n\
 5. t if inside a comment.\n\
 6. t if following a quote character.\n\
 7. the minimum paren-depth encountered during this scan.\n\
If third arg TARGETDEPTH is non-nil, parsing stops if the depth\n\
in parentheses becomes equal to TARGETDEPTH.\n\
Fourth arg STOPBEFORE non-nil means stop when come to\n\
 any character that starts a sexp.\n\
Fifth arg STATE is a seven-list like what this function returns.\n\
It is used to initialize the state of the parse.")

*/

DEFUN ("parse-partial-sexp", Fparse_partial_sexp, Sparse_partial_sexp, 2, 5, 0,
  0 /* See immediately above */)
  (Lisp_Object from, Lisp_Object to, Lisp_Object targetdepth, Lisp_Object stopbefore, Lisp_Object oldstate)
{
  struct lisp_parse_state state;
  int target;

  if (!NILP (targetdepth))
    {
      CHECK_NUMBER (targetdepth, 3);
      target = XINT (targetdepth);
    }
  else
    target = -100000;		/* We won't reach this depth */

  validate_region (&from, &to);
  state = *scan_sexps_forward (XINT (from), XINT (to),
			       target, !NILP (stopbefore), oldstate);

  SET_PT (state.location);
  
  return Fcons (make_number (state.depth),
	   Fcons (state.prevlevelstart < 0 ? Qnil : make_number (state.prevlevelstart),
	     Fcons (state.thislevelstart < 0 ? Qnil : make_number (state.thislevelstart),
	       Fcons (state.instring >= 0 ? make_number (state.instring) : Qnil,
		 Fcons (state.incomment ? Qt : Qnil,
		   Fcons (state.quoted ? Qt : Qnil,
			  Fcons (make_number (state.mindepth), Qnil)))))));
}

void
init_syntax_once (void)
{
  register int i;
  register struct Lisp_Vector *v;

  /* Set this now, so first buffer creation can refer to it. */
  /* Make it nil before calling copy-syntax-table
    so that copy-syntax-table will know not to try to copy from garbage */
  Vstandard_syntax_table = Qnil;
  Vstandard_syntax_table = Fcopy_syntax_table (Qnil);

  v = XVECTOR (Vstandard_syntax_table);

  for (i = 'a'; i <= 'z'; i++)
    XFASTINT (v->contents[i]) = (int) Sword;
  for (i = 'A'; i <= 'Z'; i++)
    XFASTINT (v->contents[i]) = (int) Sword;
  for (i = '0'; i <= '9'; i++)
    XFASTINT (v->contents[i]) = (int) Sword;
  XFASTINT (v->contents['$']) = (int) Sword;
  XFASTINT (v->contents['%']) = (int) Sword;

  XFASTINT (v->contents['(']) = (int) Sopen + (')' << 8);
  XFASTINT (v->contents[')']) = (int) Sclose + ('(' << 8);
  XFASTINT (v->contents['[']) = (int) Sopen + (']' << 8);
  XFASTINT (v->contents[']']) = (int) Sclose + ('[' << 8);
  XFASTINT (v->contents['{']) = (int) Sopen + ('}' << 8);
  XFASTINT (v->contents['}']) = (int) Sclose + ('{' << 8);
  XFASTINT (v->contents['"']) = (int) Sstring;
  XFASTINT (v->contents['\\']) = (int) Sescape;

  for (i = 0; i < 10; i++)
    XFASTINT (v->contents["_-+*/&|<>="[i]]) = (int) Ssymbol;

  for (i = 0; i < 12; i++)
    XFASTINT (v->contents[".,;:?!#@~^'`"[i]]) = (int) Spunct;

}

void
syms_of_syntax (void)
{
  Qsyntax_table_p = intern ("syntax-table-p");
  staticpro (&Qsyntax_table_p);

  DEFVAR_BOOL ("parse-sexp-ignore-comments", &parse_sexp_ignore_comments,
    "Non-nil means forward-sexp, etc., should treat comments as whitespace.\n\
Non-nil works only when the comment terminator is something like */,\n\
and appears only when it ends a comment.\n\
If comments are terminated by newlines,\n\
you must make this variable nil.");

  defsubr (&Ssyntax_table_p);
  defsubr (&Ssyntax_table);
  defsubr (&Sstandard_syntax_table);
  defsubr (&Scopy_syntax_table);
  defsubr (&Sset_syntax_table);
  defsubr (&Ssyntax_spec_code);	/* 92.7.16 by K.Handa */
  defsubr (&Ssyntax_code_spec);	/* 92.7.16 by K.Handa */
  defsubr (&Schar_syntax);
  defsubr (&Schar_syntax_at);	/* 92.2.3 by K.Handa */
  defsubr (&Schar_syntax_match);
  defsubr (&Smodify_syntax_entry);
  defsubr (&Sdescribe_syntax);

  defsubr (&Sforward_word);

  defsubr (&Sscan_lists);
  defsubr (&Sscan_sexps);
  defsubr (&Sbackward_prefix_chars);
  defsubr (&Sparse_partial_sexp);

  syntax_table_version = 0;	/* 93.7.12 by K.Handa */
}
