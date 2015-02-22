/* Definitions file for GNU Emacs running on NEC's EWS-UX/V(Rel4.2) 
							   (System V Release 4)
   Copyright (C) 1987, 1990 Free Software Foundation, Inc.

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

#include "s-usg5-4.h"

#ifndef nec_ews
#define nec_ews
#endif
#ifndef nec_ews_svr4
#define nec_ews_svr4
#endif
#ifdef _MIPS_ABI
#define MIPS_ABI
#endif

/* SYSTEM_TYPE should indicate the kind of system you are using.
 It sets the Lisp variable system-type.  */

#undef SYSTEM_TYPE
#define SYSTEM_TYPE "ews-ux5r4"

#define BSTRING
#define STAT_IS_XSTAT

#define C_SWITCH_SYSTEM -Xt -ZXNd=5000
