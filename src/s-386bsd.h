/* Definitions file for GNU emacs running on 386BSD.  */

/* 93.6.5   modified for Mule Ver.0.9.8
			by T.Maebashi <maebashi@mcs.meitetsu.co.jp>
	Modification for XFree86. */
/* 93.8.3   modified for Mule Ver.1.1
   			by R.Fukui <fukuirei@tansei.cc.u-tokyo.ac.jp>
	#define LIBS_DEBUG and #define HAVE_CLOCK. */

#include "s-bsd4-3.h"

/*
 *     Define symbols to identify the version of Unix this is.
 *     BSD and BSD4_3 are defined in s-bsd4-3.h.  There are some
 *     differences between 386BSD and BSD 4.3 so we need an extra
 *     symbol to identify it (the J stands for Jolitz).
 */

#ifndef J386BSD
#define J386BSD
#endif /* J386BSD */

/* Under 386BSD the file containing the kernel's symbol 
   table is named /386bsd.  */

#undef KERNEL_FILE
#define KERNEL_FILE "/386bsd"

/* The symbol in the kernel where the load average is found
   is named _averunnable.  */

#undef LDAV_SYMBOL
#define LDAV_SYMBOL "_averunnable"

/* This macro determines the number of bytes waiting to be written
   in a FILE buffer.  */

#define PENDING_OUTPUT_COUNT(FILE) ((FILE)->_p - (FILE)->_bf._base)

/* 386BSD uses GNU C.  */

#define C_COMPILER gcc -traditional

/* 386BSD stores the termcap database in /usr/share/misc rather than
   /etc. We use the system termcap library to avoid putting a #ifdef
   in termcap.c or forcing the user to use the TERMCAP environment
   variable.  */

#define LIBS_TERMCAP -ltermcap

/* 386BSD is nominally a POSIX.1 OS and has setsid.  */

#ifndef HAVE_SETSID
#define HAVE_SETSID
#endif /* HAVE_SETSID */

/* 93.5.2 by T.Maebashi */
/* The following is needed to work with the "XFree86" version of
   X Window System. */
#undef LD_SWITCH_SYSTEM
#define LD_SWITCH_SYSTEM -X -L/usr/X386/lib
#define C_SWITCH_SYSTEM -I/usr/X386/include
/* end of patch */

/* 93.7.31 FUKUI Rei */
/* 386BSD doesn't have libg.a */
#undef LIBS_DEBUG
#define LIBS_DEBUG

#define HAVE_CLOCK
