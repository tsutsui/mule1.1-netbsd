/* Definitions file for GNU Emacs running on linux 0.96c pl2 and gcc 2.2.2
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
/* 93.7.17  modified for Mule Ver.0.9.8
			by Koaunghi Un <zraun01@hpserv.zdv.uni-tuebingen.de>
	HAVE_SYSVIPC and LIB_X11_LIB is defined */
/* 93.7.17  modified for Mule Ver.0.9.8
   			by S.Komeda <komeda@ics.es.osaka-u.ac.jp>
	ORDINARY_LINK is defined for libc.4.4 or greater. */
/* 93.7.27  modified for Mule Ver.0.9.8
   			by S.Komeda <komeda@ics.es.osaka-u.ac.jp>
	Modified to avoid wchar_t problem. */

#include "s-usg5-2.h"		/* as close as anything */

/* overrides for linux versus s-usg5-2.h */

#undef TERMINFO			/* not really SYSV */
#undef COFF			/* not really SYSV */
#undef NOMULTIPLEJOBS		/* not even used ... */
#undef NONSYSTEM_DIR_LIBRARY	/* use our dirent library for VFS */
#undef static			/* static is OK for with gcc */
#undef sigsetmask		/* linux has sigsetmask */
#undef _setjmp			/* we must use macro in setjmp.h */

/* just a few small changes for linux ... */

/* let's see, what have we got here */

#define HAVE_TCATTR		/* fixes ^z problems */
#define HAVE_SETSID		/* fixes shell problems */
#define HAVE_DUP2		/* is builtin */
#define HAVE_TIMEVAL		/* is builtin */
#define HAVE_GETTIMEOFDAY	/* is builtin */
#define HAVE_RENAME		/* is builtin */
#define HAVE_RANDOM		/* is builtin */
#define HAVE_SELECT		/* works */
#define HAVE_PTYS		/* works */
#define HAVE_CLOSEDIR		/* we have a closedir */
#define HAVE_GETPAGESIZE	/* we now have getpagesize (0.96) */
#define HAVE_VFORK		/* we now have vfork (0.96) */
#define HAVE_SYS_SIGLIST	/* we have a (non-standard) sys_siglist */
#define HAVE_GETWD		/* cure conflict with getcwd? */
#define	HAVE_SOCKETS		/* we have socket */
#define	NO_SOCK_SIGIO 		/* linux doesn't have SIGIO */

#define BSTRING			/* we now have bcopy, etc. (0.96) */
#define USE_UTIME		/* don't have utimes */
#define NO_SIOCTL_H		/* don't have sioctl.h */
#define SYSV_SYSTEM_DIR		/* use dirent.h */
#define USG_SYS_TIME		/* use sys/time.h, not time.h */
#define HAVE_SYSVIPC		/* 93.7.17 by K.Un - 0.99.10 has working IPC */

#define INTERRUPTABLE_CLOSE	/* no harm if not true */
#define close sys_close

#define C_COMPILER gcc
#define C_DEBUG_SWITCH -g -O6 -fwritable-strings -fomit-frame-pointer -D__const=
#define C_OPTIMIZE_SWITCH -O6 -fwritable-strings -fomit-frame-pointer -D__const=
#define OLDXMENU_OPTIONS CFLAGS=-O6 EXTRA=insque.o /* doesn't work anyway */
#define LIB_X11_LIB -L/usr/X386/lib -lX11 /* 93.7.17 by K.Un */
/* 93.7.17 by S.Komeda */
#define ORDINARY_LINK   /* need if you use libc.4.4 or greater */

#if 0				/* choose for yourself */
#define SYSTEM_MALLOC		/* produces smaller binary */
#else
#define ULIMIT_BREAK_VALUE (32*1024*1024) /* ulimit not implemented */
#endif

#undef rcheck			/* for debugging builtin malloc */

#ifdef rcheck
#define botch(msg)	(printf("%s", (msg)), abort())
#endif

/* misc. kludges for linux */

#define __const 		/* avoids type mismatch errors */

#define MAXNAMLEN NAME_MAX	/* missing SYSV-ism */

#define SIGBUS SIGSEGV		/* rename to harmless work-alike */
#define SIGSYS SIGSEGV		/* rename to harmless work-alike */

#define VSWTCH VSWTC		/* mis-spelling in termios.h? */
#define CDEL '\0'		/* missing termio-ism */

/* we have non-standard standard I/O (iostream) ... */

#define PENDING_OUTPUT_COUNT(FILE) ((FILE)->_pptr - (FILE)->_pbase)

/* defines for linux in preparation for m-intel386.h */

#define DONT_DEFINE_SIGNAL	/* live with the warnings */

