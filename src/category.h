/* Declarations having to do with Mule category tables.
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

/* 91.10.30 created for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 93.7.12  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	category_table_version introduced. */
/* 93.7.27  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Modified for 64bit architecture machine. */

extern Lisp_Object Qcategory_table_p, Qcategoryp, Qmnemonicp;
extern Lisp_Object Fcategory_table_p ();
extern Lisp_Object Fcategory_table (), Fset_category_table ();
extern Lisp_Object check_category_table ();

/* The standard category table is stored where it will automatically
   be used in all new buffers.  */
#define Vstandard_category_table buffer_defaults.category_table

struct Lisp_Category
  {
    Lisp_Object_Int size;	/* 93.7.27 by K.Handa */
    unsigned int data[3];
    unsigned char terminator;
  };

#define XCATEGORY(a) ((struct Lisp_Category *) XPNTR(a))

#define CHECK_MNEMONIC(x, i) \
  { if ((XTYPE ((x)) != Lisp_Int) \
	|| (XFASTINT (x) < 32 || XFASTINT (x) > 126)) \
      x = wrong_type_argument (Qmnemonicp, (x)); }

extern unsigned int category_table_version; /* 93.7.12 by K.Handa */

struct Lisp_Category *char_category();
