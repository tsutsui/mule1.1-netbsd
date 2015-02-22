/* Definitions for interface to indent.c
   Copyright (C) 1985, 1986 Free Software Foundation, Inc.

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

/* 92.4.1   modified for Mule Ver.0.9.2 by  Y.Niibe <gniibe@mri.co.jp> */
/* 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
        Preliminary support (92.8.2) for right-to-left languages. */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	for full support for composite character and
	private char-sets, and right-to-left char-sets. */

struct position
  {
    Lisp_Object_Int bufpos;
    int hpos;
    int vpos;
    Lisp_Object_Int prevhpos;
    int contin;
    int tab_offset;		/* 92.4.1 by Y.Niibe */
    int rev_hpos;		/* 92.8.2 by Y.Niibe */
    int vir_hpos;		/* 92.8.2 by Y.Niibe */
  };

struct position *compute_motion ();
struct position *vmotion ();
int *char_width_dir_on (); /* 93.5.22 Y.Niibe */
