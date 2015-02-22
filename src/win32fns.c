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

/* 93.6.1 written by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */

#include "config.h"

#ifdef WIN32
/* The entire file is within this conditional */

#ifdef NULL
#undef NULL
#endif
#include "lisp.h"

#include <windows.h>
#ifdef USE_IME
#include <winnls32.h>
#include <ime.h>
#include <dde.h>
#endif

#ifdef USE_IME

extern HWND hwndMain;

HANDLE hIME;
DWORD wIMEOpen;

DEFUN ("fep-force-on", Ffep_force_on, Sfep_force_on, 0, 0, 0, "")
  ()
{
  LPIMESTRUCT lpIme = (LPIMESTRUCT) GlobalLock (hIME);
  lpIme->fnc = IME_SETOPEN;
  lpIme->wParam = wIMEOpen = 1;
  GlobalUnlock (hIME);
  SendIMEMessageEx (hwndMain, (LPARAM) hIME);
  return Qnil;
}

DEFUN ("fep-force-off", Ffep_force_off, Sfep_force_off, 0, 0, 0, "")
  ()
{
  LPIMESTRUCT lpIme = (LPIMESTRUCT) GlobalLock (hIME);
  lpIme->fnc = IME_SETOPEN;
  lpIme->wParam = wIMEOpen = 0;
  GlobalUnlock (hIME);
  SendIMEMessageEx (hwndMain, (LPARAM) hIME);
  return Qnil;
}

DEFUN ("fep-get-mode", Ffep_get_mode, Sfep_get_mode, 0, 0, "", "")
  ()
{
  LPIMESTRUCT lpIme = (LPIMESTRUCT) GlobalLock (hIME);
  lpIme->fnc = IME_GETOPEN;
  GlobalUnlock (hIME);
  return SendIMEMessageEx (hwndMain, (LPARAM) hIME) ? Qt : Qnil;
}
#endif /* USE_IME */

/*
 *	Define everything
 */
syms_of_win32fns()
{
#ifdef USE_IME
  defsubr (&Sfep_force_on);
  defsubr (&Sfep_force_off);
  defsubr (&Sfep_get_mode);
#endif /* USE_IME */
}
#endif /* WIN32 */
