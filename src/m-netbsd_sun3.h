/* m- file for Sun 68000's OPERATING SYSTEM version 3.
  Note that "m-sun2.h" refers to the operating system version, not the
  CPU model number.  See the MACHINES file for details.
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


/* The following three symbols give information on
 the size of various data types.  */

#define SHORTBITS 16		/* Number of bits in a short */

#define INTBITS 32		/* Number of bits in an int */

#define LONGBITS 32		/* Number of bits in a long */

#define BIG_ENDIAN

#define START_FILES crt0.o /usr/lib/crt0.o
#define CRT0_DUMMIES bogus_fp,

/* Define how to take a char and sign-extend into an int.
   On machines where char is signed, this is a no-op.  */

#define SIGN_EXTEND_CHAR(c) (c)

/* Say this machine is a 68000 */

#ifndef m68000
#define m68000
#endif

#ifndef sun3
#define sun3
#endif

/* Use type int rather than a union, to represent Lisp_Object */

#define NO_UNION_TYPE

/* Sun can't write competent compilers */
/* #define COMPILER_REGISTER_BUG */

/* XINT must explicitly sign-extend */

#define EXPLICIT_SIGN_EXTEND

/* Data type of load average, as read out of kmem.  */

#define LOAD_AVE_TYPE unsigned long

/* Convert that into an integer that is 100 for a load average of 1.0  */

#define LOAD_AVE_CVT(x) (int) (((double) (x)) * 100.0 / FSCALE)

/* Say that this is a Sun 2; must check for and maybe reinitialize
   the "sky" board.  */

/* Mask for address bits within a memory segment */

/* #define SEGMENT_MASK (SEGSIZ - 1) */

/* Arrange to link with sun windows, if requested.  */
/* For details on emacstool and sunfns, see etc/SUN-SUPPORT */
/* These programs require Sun UNIX 4.2 Release 3.2 or greater */

#define HAVE_ALLOCA

/* If compiling with GCC, let GCC implement alloca.  */
#if defined(__GNUC__) && !defined(alloca)
#define alloca(n) __builtin_alloca(n)
#endif
