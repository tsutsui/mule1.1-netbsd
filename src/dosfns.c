/* MS-DOS specific Lisp staff.
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
/* 93.2.25  modified for Mule Ver.0.9.7
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	FEPCTRL 1.5 supported. */

#include "config.h"

#ifdef MSDOS
/* The entire file is within this conditional */

#include <stdio.h>
#include <dos.h>

#include "lisp.h"
#include "buffer.h"
#include "termchar.h"
#include "dosfns.h"

Lisp_Object Vdos_machine_type;

#ifdef IBMPC
Lisp_Object Qibmpc;
#endif
#ifdef J3100
Lisp_Object Qj3100;
#endif
#ifdef PC9801
Lisp_Object Qpc98;
#endif

int InhibitSetDisk;

#ifdef GO32 /* 92.11.3 by M.Higashida */

DEFUN ("int86", Fint86, Sint86, 2, 2, 0, "")
  (intno, regs)
  Lisp_Object intno, regs;
{
  register int i;
  int size;
  union REGS inregs, outregs;
  Lisp_Object val;

  CHECK_NUMBER (intno, 0);
  CHECK_VECTOR (regs, 0);
  if (XVECTOR (regs)-> size != 8) return Qnil;
  for (i = 0; i < 8; i++)
    {
      CHECK_NUMBER (XVECTOR (regs)->contents[i], 0);
    }

  inregs.x.ax    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[0]);
  inregs.x.bx    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[1]);
  inregs.x.cx    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[2]);
  inregs.x.dx    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[3]);
  inregs.x.si    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[4]);
  inregs.x.di    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[5]);
  inregs.x.cflag = (unsigned long) XFASTINT (XVECTOR (regs)->contents[6]);
  inregs.x.flags = (unsigned long) XFASTINT (XVECTOR (regs)->contents[7]);

  int86 ((unsigned long) XFASTINT (intno), &inregs, &outregs);

  XVECTOR (regs)->contents[0] = make_number (outregs.x.ax);
  XVECTOR (regs)->contents[1] = make_number (outregs.x.bx);
  XVECTOR (regs)->contents[2] = make_number (outregs.x.cx);
  XVECTOR (regs)->contents[3] = make_number (outregs.x.dx);
  XVECTOR (regs)->contents[4] = make_number (outregs.x.si);
  XVECTOR (regs)->contents[5] = make_number (outregs.x.di);
  XVECTOR (regs)->contents[6] = make_number (outregs.x.cflag);
  XVECTOR (regs)->contents[7] = make_number (outregs.x.flags);

  return regs;
}

#if 0
/* segread () is requied, but does not inplemented in DJ's library. */
DEFUN ("int86x", Fint86x, Sint86x, 3, 3, 0, "")
  (intno, regs, sregs)
  Lisp_Object intno, regs, sregs;
{
  register int i;
  int size;
  union REGS inregs, outregs;
  struct SREGS seg;
  Lisp_Object val;

  CHECK_NUMBER (intno, 0);
  CHECK_VECTOR (regs, 0);
  CHECK_VECTOR (sregs, 0);
  if (XVECTOR (regs)-> size != 8) return Qnil;
  for (i = 0; i < 8; i++)
    CHECK_NUMBER (XVECTOR (regs)->contents[i], 0);

  if (XVECTOR (sregs)-> size != 6) return Qnil;
  for (i = 0; i < 6; i++)
    CHECK_NUMBER (XVECTOR (sregs)->contents[i], 0);

  inregs.x.ax    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[0]);
  inregs.x.bx    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[1]);
  inregs.x.cx    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[2]);
  inregs.x.dx    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[3]);
  inregs.x.si    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[4]);
  inregs.x.di    = (unsigned long) XFASTINT (XVECTOR (regs)->contents[5]);
  inregs.x.cflag = (unsigned long) XFASTINT (XVECTOR (regs)->contents[6]);
  inregs.x.flags = (unsigned long) XFASTINT (XVECTOR (regs)->contents[7]);

  seg.cs = (unsigned short) XFASTINT (XVECTOR (sregs)->contents[0]);
  seg.ds = (unsigned short) XFASTINT (XVECTOR (sregs)->contents[0]);
  seg.es = (unsigned short) XFASTINT (XVECTOR (sregs)->contents[0]);
  seg.fs = (unsigned short) XFASTINT (XVECTOR (sregs)->contents[0]);
  seg.gs = (unsigned short) XFASTINT (XVECTOR (sregs)->contents[0]);
  seg.ss = (unsigned short) XFASTINT (XVECTOR (sregs)->contents[0]);

  int86x ((unsigned long) XFASTINT (intno), &inregs, &outregs, &seg);

  XVECTOR (regs)->contents[0] = make_number (outregs.x.ax);
  XVECTOR (regs)->contents[1] = make_number (outregs.x.bx);
  XVECTOR (regs)->contents[2] = make_number (outregs.x.cx);
  XVECTOR (regs)->contents[3] = make_number (outregs.x.dx);
  XVECTOR (regs)->contents[4] = make_number (outregs.x.si);
  XVECTOR (regs)->contents[5] = make_number (outregs.x.di);
  XVECTOR (regs)->contents[6] = make_number (outregs.x.cflag);
  XVECTOR (regs)->contents[7] = make_number (outregs.x.flags);

  return regs;
}
#endif 0
#endif GO32

#ifdef FEPCTRL	/* Demacs 1.1.8 91/11/29 Manabu Higashida */

int InhibitFEPCtrl;

DEFUN ("fep-init", Ffep_init, Sfep_init, 0, 0, 0, "")
  ()
{
  extern int fep_init (void);
  if (!InhibitFEPCtrl)
    return make_number (fep_init ());
  else
    return Qnil;
}

DEFUN ("fep-term", Ffep_term, Sfep_term, 0, 0, 0, "")
  ()
{
  extern void fep_term (void);
  if (!InhibitFEPCtrl) fep_term ();
  return Qnil;
}

DEFUN ("fep-on", Ffep_on, Sfep_on, 0, 0, 0, "")
  ()
{
  extern void fep_on (void);
  if (!InhibitFEPCtrl) fep_on ();
  return Qnil;
}

DEFUN ("fep-off", Ffep_off, Sfep_off, 0, 0, 0, "")
  ()
{
  extern void fep_off (void);
  if (!InhibitFEPCtrl) fep_off ();
  return Qnil;
}

DEFUN ("fep-force-on", Ffep_force_on, Sfep_force_on, 0, 0, "", "")
  ()
{
  extern void fep_force_on (void);
  if (!InhibitFEPCtrl) fep_force_on ();
  return Qnil;
}

DEFUN ("fep-force-off", Ffep_force_off, Sfep_force_off, 0, 0, "", "")
  ()
{
  extern void fep_force_off (void);
  if (!InhibitFEPCtrl) fep_force_off ();
  return Qnil;
}

DEFUN ("fep-get-mode", Ffep_get_mode, Sfep_get_mode, 0, 0, "", "")
  ()
{
  extern int fep_stat (void);
  if (!InhibitFEPCtrl)
    return fep_get_mode () ? Qt : Qnil;
  else
    return Qnil;
}
#endif /* FEPCTRL */

#if defined(GO32) && defined(PC9801)
DEFUN ("pc98-assign-special-key", 
  Fpc98_assign_special_key, Spc98_assign_special_key, 0, 0, 0, "")
  ()
{
  extern int set98FunctionKey (void);
  if (EQ (Vdos_machine_type, Qpc98))
    set98FunctionKey ();
  return Qnil;
}

DEFUN ("pc98-cancel-special-key", 
  Fpc98_cancel_special_key, Spc98_cancel_special_key, 0, 0, 0, "")
  ()
{
  extern int restore98FunctionKey (void);
  if (EQ (Vdos_machine_type, Qpc98))
    restore98FunctionKey ();
  return Qnil;
}
#endif /* GO32 and PC9801 */

/*
 *	Define everything
 */
syms_of_dosfns()
{
#ifdef IBMPC
  Qibmpc = intern ("ibmpc");
  staticpro (&Qibmpc);
#endif
#ifdef J3100
  Qj3100 = intern ("j3100");
  staticpro (&Qj3100);
#endif
#ifdef PC9801
  Qpc98 = intern ("pc98");
  staticpro (&Qpc98);
#endif

#ifdef GO32 /* 92.11.3 by M.Higashida */
  defsubr (&Sint86);
#endif
#ifdef FEPCTRL	/* 91.11.29 by M.Higashida */
  defsubr (&Sfep_init);
  defsubr (&Sfep_term);
  defsubr (&Sfep_on);
  defsubr (&Sfep_off);
  defsubr (&Sfep_force_on);
  defsubr (&Sfep_force_off);
  defsubr (&Sfep_get_mode);
#endif FEPCTRL
#if defined(GO32) && defined(PC9801)
  defsubr (&Spc98_assign_special_key);
  defsubr (&Spc98_cancel_special_key);
#endif

  DEFVAR_LISP ("dos-machine-type", &Vdos_machine_type, 
    "*A symbol naming the dos-machine-type under which Emacs is running,\n\
\(such as `ibmpc'), or nil means running on dos generic mode.");
  /* Initialize `dos-machine-type'. */
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    Vdos_machine_type = Qnil;

  DEFVAR_BOOL ("dos-inhibit-setdisk", &InhibitSetDisk,
    "*Non-nil means that changing current drive is inhibited.");
#ifdef GO32 /* 92.11.3 by M.Higashida */
  InhibitSetDisk = 0;
#elif EMX
  InhibitSetDisk = 1;
#endif

#ifdef FEPCTRL /* 91.11.29 M.Higashida */
  DEFVAR_BOOL ("inhibit-fep-control", &InhibitFEPCtrl,
    "*Non-nil means that Kana-Kanji FEP control is inhibited.");
  InhibitFEPCtrl = 1;
#endif
}
#endif /* MSDOS */
