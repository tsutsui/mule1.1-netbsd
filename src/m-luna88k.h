/* m- file for LUNA 88000 running Mach.

						Jun. 26th '90
						Akitoshi MORISHIMA
						ohm@astem.or.jp

   Copyright (C) 1990 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY.  No author or distributor
accepts responsibility to anyone for the consequences of using it
or for whether it serves any particular purpose or works at all,
unless he says so in writing.  Refer to the GNU Emacs General Public
License for full details.

Everyone is granted permission to copy, modify and redistribute
GNU Emacs, but only under the conditions described in the
GNU Emacs General Public License.   A copy of this license is
supposed to have been given to you along with GNU Emacs so you
can know your rights and responsibilities.  It should be in a
file named COPYING.  Among other things, the copyright notice
and this notice must be preserved on all copies.  */


/* The following three symbols give information on
 the size of various data types.  */

#define SHORTBITS 16		/* Number of bits in a short */

#define INTBITS 32		/* Number of bits in an int */

#define LONGBITS 32		/* Number of bits in a long */

/* LUNA 88000 has lowest-numbered byte in a word as most significant */

#define BIG_ENDIAN

/* Compilers for 88000 generally pass first several arguments in
 * registers, so we cannot take the address of the first of a
 * group of arguments and treat it as an array of the arguments.  */

#define NO_ARG_ARRAY

/* Define how to take a char and sign-extend into an int.
   On machines where char is signed, this is a no-op.  */

#define SIGN_EXTEND_CHAR(c) (c)

/* Use type int rather than a union, to represent Lisp_Object */

#define NO_UNION_TYPE

/* XINT must explicitly sign-extend */

#define EXPLICIT_SIGN_EXTEND

/* Data type of load average, as read out of kmem.  */

#define LOAD_AVE_TYPE long

/* Convert that into an integer that is 100 for a load average of 1.0  */

#define LOAD_AVE_CVT(x) (int) (((double) (x)) * 100.0 / FSCALE)

/* On Mach, LSCALE is defined instead of FSCALE, in h/kernel.h, as 1000. */

#define FSCALE 1000

/* Mask for address bits within a memory segment */
/* In other words, data segment starts from the address that is end of
   text segment rounded up to next (SEGMENT_MASK + 1) boundary. */

#define SEGMENT_MASK 0x1ffff

/* macros to make unexec work right */

#define A_TEXT_OFFSET(HDR) sizeof(HDR)
#define A_TEXT_SEEK(HDR) sizeof(HDR)

/* Define HAVE_ALLOCA to say that the system provides a properly
   working alloca function and it should be used.
   At least, gcc for 88000 supports inline alloca. */

#define HAVE_ALLOCA

/* Memory management mechanism is different on Mach, so emacs-supplied
   malloc.c does not work. */

#define SYSTEM_MALLOC

/* We want errno in crt0.c */

#define NEED_ERRNO

/* Mach has 'init_process()' in libc.a, conflicting with emacs'
   'init_process()', causing make to stop. So redefining that. */

#define init_process init_process_emacs

#define HAVE_X_WINDOWS

/* We have gcc-1.37 */

#define C_COMPILER gcc

#define MISSING_CLOCK
