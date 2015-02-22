/* m- file for linux 0.96c pl2 and gcc 2.2.2
   by Rick Sladkey <jrs@world.std.com>, your mileage may vary */

/*
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

/* 93.5.4   modified for Mule Ver.0.9.8
   			by S.Komeda <komeda@ics.es.osaka-u.ac.jp>
	Linux support updated. */

#include "m-intel386.h"

/* overrides for linux versus m-intel386.h */

/* #undef NO_REMAP		/* would require hacking crt0.c */

#undef LINK_STATICALLY		/* shared libs now working with 0.96c */

#ifdef NO_REMAP
#ifndef emacs			/* defeat some ymakefile problems */
#undef i386
#undef linux
#undef static
#endif
#define START_FILES pre-crt0.o /usr/lib/crt0.o
#ifdef LINK_STATICALLY
#define LIBS_SYSTEM -Bstatic
#else
#define VIRT_ADDR_VARIES	/* see if this cures shared libs */
#define LIBS_SYSTEM
#endif
#else
#undef CRT0_DUMMIES
#endif
