/* Interface definition for MS-DOS specified functions.
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

/* 91.10.20 written by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */
/* 92.10.21 modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	DOS-Extender GO32 supported. */
/* 92.11.3  modifined for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	DOS-Extender EMX supported. */

extern Lisp_Object Vdos_machine_type;

#ifdef IBMPC
extern Lisp_Object Qibmpc;	/* IBM PC and it's compatible machines */
#endif
#ifdef J3100
extern Lisp_Object Qj3100;	/* Toshiba J-3100 Series */
#endif
#ifdef PC9801
extern Lisp_Object Qpc98;	/* NEC PC-9801 Series */
#endif

#define CHECK_MACHINE_TYPE(x)  EQ (Vdos_machine_type, (x))

extern int InhibitSetDisk;

#ifdef FEPCTRL
extern int InhibitFEPCtrl;
#endif
