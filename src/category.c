/* GNU Emacs routines to deal with category tables.
   Copyright (C) 1992 Free Software Foundation, Inc.
   Created by modifing syntax.c.

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

/* 91.12.4  created for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.7.10  modified for Mule Ver.0.9.5 by T.Enami <enami@sys.ptg.sony.co.jp>
	In insert_character_description(), 'char str[5]' is correct. */
/* 93.2.12  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In char_category() and modify_category_entry(),
	handle private chars correctly. */
/* 93.6.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	insert_character_description() produces prettier description. */
/* 93.7.12  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	category_table_version introduced.
	New function check_category(). */
/* 94.2.23  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	describe-category displays multilingual text. */

#include "config.h"
#include <ctype.h>
#include "lisp.h"
#include "commands.h"
#include "buffer.h"
#include "syntax.h"
#include "category.h"
#include "mule.h"

unsigned int category_table_version; /* 93.7.12 by K.Handa */

Lisp_Object Qcategory_table_p;

DEFUN ("category-table-p", Fcategory_table_p, Scategory_table_p, 1, 1, 0,
  "Return t if ARG is a category table.\n\
Any vector of 257 elements will do as far as the last element\n\
is a vetor of 127 elements, which are description strings for each category.")
  (obj)
     Lisp_Object obj;
{
  if (XTYPE (obj) == Lisp_Vector && XVECTOR (obj)->size == 257
      && XTYPE (XVECTOR (obj)->contents[256]) == Lisp_Vector
      && XVECTOR (XVECTOR (obj)->contents[256])->size == 95)
    return Qt;
  return Qnil;
}

Lisp_Object
check_category_table (obj)
     Lisp_Object obj;
{
  register Lisp_Object tem;
  if (NULL (obj)) return current_buffer->category_table;
  tem = Fcategory_table_p (obj);
  if (NULL (tem))
    obj = wrong_type_argument (Qcategory_table_p, obj);
  return obj;
}   

DEFUN ("category-table", Fcategory_table, Scategory_table, 0, 0, 0,
  "Return the current category table.\n\
This is the one specified by the current buffer.")
  ()
{
  return current_buffer->category_table;
}

DEFUN ("standard-category-table", Fstandard_category_table,
   Sstandard_category_table, 0, 0, 0,
  "Return the standard category table.\n\
This is the one used for new buffers.")
  ()
{
  return Vstandard_category_table;
}

struct Lisp_Category temp_category;

init_category(category)
     struct Lisp_Category *category;
{
  category->data[0] = category->data[1] = category->data[2] = 0;
}

Lisp_Object
make_init_category()
{
  register Lisp_Object category;
  Lisp_Object size, init;

  XFASTINT (size) = 12; XFASTINT (init) = 0;
  return Fmake_string (size, init);
}

update_category(src, mask)
     struct Lisp_Category *src;
     Lisp_Object mask;
{
  unsigned int *s = &(src->data[0]), *d = &(XCATEGORY (mask)->data[0]);

  *s++ |= *d++; *s++ |= *d++; *s |= *d;
}

DEFUN ("category-equal", Fcategory_equal, Scategory_equal, 2, 2, 0,
  "T if two categories have identical contents.")
  (c1, c2)
     register Lisp_Object c1, c2;
{
  if (XTYPE (c1) != Lisp_String
      || XTYPE (c2) != Lisp_String
      || XCATEGORY (c1)->data[0] != XCATEGORY (c2)->data[0]
      || XCATEGORY (c1)->data[1] != XCATEGORY (c2)->data[1]
      || XCATEGORY (c1)->data[2] != XCATEGORY (c2)->data[2])
    return Qnil;
  return Qt;
}

DEFUN ("define-category-mnemonic",
       Fdefine_category_mnemonic, Sdefine_category_mnemonic, 2, 3, 0,
  "Make MNEMONIC as a mnemonic for a new category.\n\
MNEMONIC should be a visible letter of ' ' thru '~'.\n\
STRING is a description for the category.\n\
Optional third arg specifies CATEGORY-TABLE,\n\
which defaults to the current buffer's category table.\n\
Letters of 'a' thru 'z' are already used or kept for the system.")
  (mnemonic, string, ctbl)
     Lisp_Object mnemonic, string, ctbl;
{
  int m;

  CHECK_MNEMONIC (mnemonic, 0);
  CHECK_STRING (string, 1);
  ctbl = check_category_table (ctbl);

  m = XFASTINT (mnemonic) - ' ';
  XVECTOR (XVECTOR (ctbl)->contents[256])->contents[m] = string;
  return Qnil;
}

DEFUN ("used-category-mnemonic",
       Fused_category_mnemonic, Sused_category_mnemonic, 0, 1, 0,
  "Return a string of category mnemonic used in the category.\n\
Optional argument specifies CATEGORY-TABLE,\n\
which defaults to the current buffer's category table.\n\
You can't 'new-category-mnemonic' with the returned mnemonic.")
  (ctbl)
     Lisp_Object ctbl;
{
  int i;
  char str[95], *p = str;
  Lisp_Object temp;

  ctbl = check_category_table (ctbl);

  temp = XVECTOR (ctbl)->contents[256];
  for (i = 0; i < 95; i++)
    if (!NULL (XVECTOR (temp)->contents[i])) *p++ = i + ' ';
  return (p == str ? Qnil : make_string (str, p - str));
}

DEFUN ("unused-category-mnemonic",
       Funused_category_mnemonic, Sunused_category_mnemonic, 0, 1, 0,
  "Return a string of category mnemonic not yet used in the category.\n\
Optional argument specifies CATEGORY-TABLE,\n\
which defaults to the current buffer's category table.\n\
You should 'new-category-mnemonic' with the returned mnemonic\n\
before really using it.")
  (ctbl)
     Lisp_Object ctbl;
{
  int i;
  char str[95], *p = str;
  Lisp_Object temp;

  ctbl = check_category_table (ctbl);

  temp = XVECTOR (ctbl)->contents[256];
  for (i = 0; i < 95; i++)
    if (NULL (XVECTOR (temp)->contents[i])) *p++ = i + ' ';
  return (p == str ? Qnil : make_string (str, p - str));
}

Lisp_Object
make_init_category_table(size)
     register Lisp_Object size;
{
  Lisp_Object val;
  int i = XFASTINT (size);

  XFASTINT (val) = 0;
  val = Fmake_vector (size, val);
  if (i == 257) {
    XFASTINT (size) = 95;
    XVECTOR (val)->contents[256] = Fmake_vector (size, Qnil);
    for (i = 0; i < 95; i++)
      XVECTOR (XVECTOR (val)->contents[256])->contents[i] = Qnil;
  }
  for (i = 0; i < 256; i++)
    XVECTOR (val)->contents[i] = make_init_category();
  return val;
}

Lisp_Object
copy_category_table(table)
     Lisp_Object table;
{
  int i;
  Lisp_Object val = make_init_category_table(XVECTOR (table)->size);
  Lisp_Object temp;

  bcopy (XVECTOR (table)->contents,
	 XVECTOR (val)->contents, 256 * sizeof (Lisp_Object));
  for (i = 0; i < 256; i++) {
    if (XTYPE (XVECTOR (table)->contents[i]) == Lisp_Cons) {
      temp = XVECTOR (table)->contents[i];
      XSET (temp, Lisp_Cons,
	    Fcons (Fcar (temp), copy_category_table(Fcdr (temp))));
    }
  }
  if (XVECTOR (val)->size == 257) {
    bcopy (XVECTOR (XVECTOR (table)->contents[256])->contents,
	   XVECTOR (XVECTOR (val)->contents[256])->contents,
	   95 * sizeof (Lisp_Object));
  }
  return val;
}

DEFUN ("copy-category-table", Fcopy_category_table, Scopy_category_table, 0, 1, 0,
  "Construct a new category table and return it.\n\
It is a copy of the TABLE, which defaults to the standard category table.")
  (table)
     Lisp_Object table;
{
  if (!NULL (table))
    table = check_category_table (table);
  else if (NULL (Vstandard_category_table))
    /* Can only be null during initialization */
    return make_init_category_table(257);
  else table = Vstandard_category_table;

  category_table_version++;	/* 93.7.12 by K.Handa */
  return copy_category_table(table);
}

DEFUN ("set-category-table", Fset_category_table, Sset_category_table, 1, 1, 0,
  "Select a new category table for the current buffer.\n\
One argument, a category table.")
  (table)
     Lisp_Object table;
{
  table = check_category_table (table);
  current_buffer->category_table = table;
  /* Indicate that this buffer now has a specified category table.  */
  current_buffer->local_var_flags |= buffer_local_flags.category_table;
  return table;
}

/* 93.7.13 by K.Handa */
check_category(category, mnemonic, not)
     struct Lisp_Category *category;
     char mnemonic;
     int not;
{
  register unsigned int m1, m2;

  mnemonic -= ' '; m1 = mnemonic / 32; m2 = 1 << (mnemonic % 32);
  if (category->data[m1] & m2) return !not;
  else return not;
}
/* end of patch */

int
check_category_at(p, len, ctbl, mnemonic, not)
     register unsigned char *p;
     register Lisp_Object ctbl;
     unsigned int len, mnemonic, not;
{
  register Lisp_Object temp;
  register unsigned int m1, m2;
  register unsigned char c;

  mnemonic -= ' '; m1 = mnemonic / 32; m2 = 1 << (mnemonic % 32);
  while (len--) {
    c = *p++;
    if (c == LCCMP) {
      len--, c = *p++ - 0x20;
      if (c == 0x80)
	len--, c = *p++ & 0x7F;
    }
    if (XTYPE ((temp = XVECTOR (ctbl)->contents[c])) == Lisp_Cons) {
      if (XCATEGORY (XCONS (temp)->car)->data[m1] & m2) return !not;
      ctbl = XCONS (temp)->cdr;
    } else {
      return ((XCATEGORY (temp)->data[m1] & m2) ? !not : not);
    }
  }
  return not;
}

DEFUN ("check-category", Fcheck_category, Scheck_category, 2, 3, 0,
  "Return t if CHAR's category includes MNEMONIC, else return nil.\n\
Optional third arg specifies CATEGORY-TABLE, which defaults to\n\
 the current buffer's category table.")
  (c, mnemonic, ctbl)
      Lisp_Object c, mnemonic, ctbl;
{
  unsigned char str[3];
  int len;

  CHECK_NUMBER (c, 0);
  CHECK_MNEMONIC (mnemonic, 1);
  ctbl = check_category_table (ctbl);

  len = CHARtoSTR (c, str);
  return (check_category_at(str, len, ctbl, XFASTINT (mnemonic), 0)
	  ? Qt : Qnil);
}

DEFUN ("check-category-at", Fcheck_category_at, Scheck_category_at, 2, 3, 0,
  "Return t if category of a character at POS includes MNEMONIC,\n\
 else return nil.\n\
Optional third arg specifies CATEGORY-TABLE, which defaults to\n\
 the current buffer's category table.")
  (pos, mnemonic, ctbl)
      Lisp_Object pos, mnemonic, ctbl;
{
  CHECK_NUMBER_COERCE_MARKER (pos, 0);
  CHECK_MNEMONIC (mnemonic, 1);
  ctbl = check_category_table (ctbl);

  return (check_category_at(&FETCH_CHAR(pos), 3,
			    ctbl, XFASTINT (mnemonic), 0)
	  ? Qt : Qnil);
}

struct Lisp_Category *
char_category(c, ctbl)
     register unsigned int c;
     register Lisp_Object ctbl;
{				/* 93.2.12 by K.Handa */
  unsigned char str[4], *p = str;
  register int i = CHARtoSTR (c, str);

  init_category(&temp_category);

  while (i > 1 && XTYPE (XVECTOR (ctbl)->contents[*p]) == Lisp_Cons) {
    update_category (&temp_category,
		     XCONS (XVECTOR (ctbl)->contents[*p])->car);
    ctbl = XCONS (XVECTOR (ctbl)->contents[*p])->cdr;
    p++, i--;
  }
  if (i > 0)
    update_category (&temp_category, XVECTOR (ctbl)->contents[*p]);
  return &temp_category;
}

pack_mnemonic_string(category, str)
     struct Lisp_Category *category;
     char *str;
{
  int j = 0, k;
  unsigned int c;

  for (k = 0; k < 3; k++) {
    if (c = category->data[k]) {
      j = k * 32;
      while (c) {
	if (c & 1) *str++ = j + ' ';
	c >>= 1, j++;
      }
    }
  }
  *str = 0;
}

DEFUN ("char-category", Fchar_category, Schar_category, 1, 2, 0,
  "Return string of category mnemonics for CHAR in TABLE.\n\
CHAR can be any multilingual character\n\
TABLE defaults to the current buffer's category table.")
  (c, ctbl)
     Lisp_Object c, ctbl;
{
  struct Lisp_Category *ct;
  char str[95];

  CHECK_CHARACTER (c, 0);
  ctbl = check_category_table (ctbl);

  ct = char_category(XFASTINT (c), ctbl);
  pack_mnemonic_string (ct, str);
  return build_string(str);
}

modify_category_entry(c, maskbit, ctbl, reset)
     register unsigned int c, reset, maskbit;
     Lisp_Object ctbl;
{				/* 93.2.12 by K.Handa */
  Lisp_Object obj;
  unsigned char str[4], *p = str;
  register int i = CHARtoSTR (c, str);

  while (i-- > 1) {
    if (XTYPE (XVECTOR (ctbl)->contents[*p]) != Lisp_Cons)
      XVECTOR (ctbl)->contents[*p] =
	Fcons (XVECTOR (ctbl)->contents[*p],
	       make_init_category_table (256));
    ctbl = Fcdr (XVECTOR (ctbl)->contents[*p]);
    p++;
  }
  obj = XVECTOR (ctbl)->contents[*p];
  if (XTYPE (obj) == Lisp_Cons) obj = XCONS (obj)->car;
  
  if (reset) XCATEGORY (obj)->data[maskbit / 32] &= ~(1 << (maskbit % 32));
  else XCATEGORY (obj)->data[maskbit / 32] |= 1 << (maskbit % 32);
}

DEFUN ("modify-category-entry", Fmodify_category_entry,
       Smodify_category_entry, 2, 4, 0,
  "Set category code of CHAR to CATEGORY.\n\
CHAR can be just a leading-char or a list of 1-byte codes.\n\
CATEGORY is given by a mnemonic character.\n\
The category is changed only for table TABLE, which defaults to\n\
 the current buffer's category table.\n\
If optionnal forth argument RESET is non NIL, CATEGORY is reset for CHAR.\n\
On success, returns T, else returns NIL.")
  (c, mnemonic, ctbl, reset)
     Lisp_Object c, mnemonic, ctbl, reset;
{
  Lisp_Object category;
  int m;

  CHECK_CHARACTER (c, 0);
  CHECK_MNEMONIC (mnemonic, 1);
  ctbl = check_category_table (ctbl);

  m = XFASTINT (mnemonic) - ' ';
  if (NULL (XVECTOR (XVECTOR (ctbl)->contents[256])->contents[m]))
    error ("Invalid mnemonic: %c", m + ' ');
  
  modify_category_entry (XFASTINT (c), m, ctbl, !NULL(reset));
  category_table_version++;	/* 93.7.12 by K.Handa */
  return Qnil;
}

/* Dump category table to buffer in human-readable format */

insert_character_description(i)	/* 94.2.23 by K.Handa */
     unsigned int i;
{				/* 93.6.7 by K.Handa */
  unsigned char str[5];		/* 92.7.10 by T.Enami */

  if (i <= ' '){
    unsigned char *p = (unsigned char *)push_key_description (i, str);
    insert (str, p - str);
  } else if (i <= '~') {
    str[0] = i;
    insert (str, 1);
  } else {
    int j = i & 0xFF000000 ? 3 : i & 0xFF0000 ? 2 : i & 0xFF00 ? 1 : 0;
    int k = j;

    while (i) str[j--] = i & 0xFF, i >>= 8;

    if (char_bytes[str[0]] == k + 1) {
      insert (str, k + 1);
      sprintf(str, "[%02x]", str[k]);
      insert (str, 4);
    } else {
      if (NULL (current_buffer->ctl_hexa)) /* 93.6.7 by K.Handa */
	sprintf(str, "\\%03o", str[k]);
      else
	sprintf(str, "\\x%02x", str[k]);
      insert (str, 4);
    }
  }
}

describe_category (ctbl, parent) /* 94.2.23 by K.Handae */
     Lisp_Object ctbl;
     int parent;
{
  int i, start, deeper;
  char mnemonic, str[95];
  struct Lisp_Vector *v = XVECTOR (ctbl);
  Lisp_Object category;
  int indent = !parent ? 0 : parent < 0x100 ? 2 : 4;

  for (i = parent ? 0xa0 : 0; i < 256; i++) {
    Findent_to (make_number (indent), make_number (0));
    insert_character_description((parent << 8) | i);
    start = i;
    category = v->contents[i];

    while (i < 0xFF
	   && !NULL (Fcategory_equal (v->contents[i + 1], category)))
      i++;

    if (i != start) {
      insert (" .. ", 4);
      insert_character_description((parent << 8) | i);
    }

    Findent_to (make_number (24), make_number (1));
    
    deeper = 0;
    if (XTYPE (category) == Lisp_Cons) {
      category = XCONS (category)->car;
      deeper = 1;
    }

    if (XTYPE (category) != Lisp_String || XSTRING (category)->size != 12) {
      InsStr ("invalid");
    } else {
      pack_mnemonic_string (XCATEGORY (category), str);
      if (strlen(str))
	insert1 (build_string(str));
      else
	InsStr ("No category");
    }
    InsStr ("\n");
    if (deeper) {
      ctbl = XCONS (v->contents[i])->cdr;
      describe_category (ctbl, (parent << 8) | i);
    }
  }
}

describe_mnemonic(description)
     Lisp_Object description;
{
  int i;
  struct Lisp_Vector *v = XVECTOR(description);
  char str[3];

  InsStr ("\nMeanings of mnemonics:\n");
  
  str[1] = ':'; str[2] = ' ';
  for (i = 0; i < 95; i++)
    if (!NULL (v->contents[i])) {
      str[0] = i + ' ';
      insert (str, 3);
      insert1 (v->contents[i]);
      InsStr ("\n");
    }
}

Lisp_Object
describe_category_1 (ctbl)
     Lisp_Object ctbl;
{
  struct buffer *old = current_buffer;
  set_buffer_internal (XBUFFER (Vstandard_output));
  describe_category (ctbl, 0);
  describe_mnemonic (XVECTOR (ctbl)->contents[256]);
  set_buffer_internal (old);
  return Qnil;
}

DEFUN ("describe-category", Fdescribe_category, Sdescribe_category, 0, 0, "",
  "Describe the category specifications in the category table.\n\
The descriptions are inserted in a buffer, which is selected so you can see it.")
  ()
{
  internal_with_output_to_temp_buffer
     ("*Help*", describe_category_1, current_buffer->category_table);

  return Qnil;
}

init_category_once ()
{
  temp_category.size = 12;
  temp_category.data[0] = temp_category.data[1] = temp_category.data[2] = 0;
  temp_category.terminator = 0;

  Vstandard_category_table = Qnil;
  Vstandard_category_table = Fcopy_category_table (Qnil);
}

syms_of_category ()
{
  Qcategory_table_p = intern ("category-table-p");
  staticpro (&Qcategory_table_p);

  defsubr (&Scategory_table_p);
  defsubr (&Scategory_table);
  defsubr (&Sstandard_category_table);
  defsubr (&Sdefine_category_mnemonic);
  defsubr (&Sused_category_mnemonic);
  defsubr (&Sunused_category_mnemonic);
  defsubr (&Scheck_category);
  defsubr (&Scheck_category_at);
  defsubr (&Scopy_category_table);
  defsubr (&Sset_category_table);
  defsubr (&Schar_category);
  defsubr (&Smodify_category_entry);
  defsubr (&Sdescribe_category);

  category_table_version = 0;	/* 93.7.12 by K.Handa */
}
