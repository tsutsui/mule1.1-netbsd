/* s- file for MS-DOS 3.0 or later with DJ's GCC libraly.

   This file describes the parameters that s- files should define or not.
   Copyright (C) 1985, 1986 Free Software Foundation, Inc.

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

/* 91.10.16 written by H.Satoshi <hirano@tkl.iis.u-tokyo.ac.jp>
/* 92.10.21 modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	DOS-Extender GO32 supported. */
/* 92.11.3  modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	DOS-Extender EMX supported. */

/*
 *	Define symbols to identify the version of Unix this is.
 *	Define all the symbols that apply correctly.
 */

/* #define UNIPLUS */
/* #define USG5 */
/* #define USG */
/* #define HPUX */
/* #define UMAX */
/* #define BSD4_1 */
/* #define BSD4_2 */
/* #define BSD4_3 */
/* #define BSD */
/* #define VMS */
#ifndef MSDOS
#define MSDOS
#endif

/* SYSTEM_TYPE should indicate the kind of system you are using.
 It sets the Lisp variable system-type.  */

#define SYSTEM_TYPE "ms-dos"

#define SYMS_SYSTEM syms_of_dosfns()

/* NOMULTIPLEJOBS should be defined if your system's shell
 does not have "job control" (the ability to stop a program,
 run some other program, then continue the first one).  */

#define NOMULTIPLEJOBS

/* Emacs can read input using SIGIO and buffering characters itself,
   or using CBREAK mode and making C-g cause SIGINT.
   The choice is controlled by the variable interrupt_input.
   Define INTERRUPT_INPUT to make interrupt_input = 1 the default (use SIGIO)

   SIGIO can be used only on systems that implement it (4.2 and 4.3).
   CBREAK mode has two disadvatages
     1) At least in 4.2, it is impossible to handle the Meta key properly.
        I hear that in system V this problem does not exist.
     2) Control-G causes output to be discarded.
        I do not know whether this can be fixed in system V.

   Another method of doing input is planned but not implemented.
   It would have Emacs fork off a separate process
   to read the input and send it to the true Emacs process
   through a pipe.
*/

/* #define INTERRUPT_INPUT */

/* Letter to use in finding device name of first pty,
  if system supports pty's.  'a' means it is /dev/ptya0  */

/* #define FIRST_PTY_LETTER 'a' */

/*
 *	Define HAVE_TIMEVAL if the system supports the BSD style clock values.
 *	Look in <sys/time.h> for a timeval structure.
 */

/* #define HAVE_TIMEVAL */

/*
 *	Define HAVE_SELECT if the system supports the `select' system call.
 */

/* #define HAVE_SELECT */

/*
 *	Define HAVE_PTYS if the system supports pty devices.
 */

/* #define HAVE_PTYS */

/*
 *	Define NONSYSTEM_DIR_LIBRARY to make Emacs emulate
 *      The 4.2 opendir, etc., library functions.
 */

/* #define NONSYSTEM_DIR_LIBRARY */

/* Define this symbol if your system has the functions bcopy, etc. */

#define BSTRING

/* subprocesses should be defined if you want to
   have code for asynchronous subprocesses
   (as used in M-x compile and M-x shell).
   This is generally OS dependent, and not supported
   under most USG systems. */

/* #define subprocesses */

/* If your system uses COFF (Common Object File Format) then define the
   preprocessor symbol "COFF". */

/* #define COFF */

/* define MAIL_USE_FLOCK if the mailer uses flock
   to interlock access to /usr/spool/mail/$USER.
   The alternative is that a lock file named
   /usr/spool/mail/$USER.lock.  */

/* #define MAIL_USE_FLOCK */

/* Define CLASH_DETECTION if you want lock files to be written
   so that Emacs can tell instantly when you try to modify
   a file that someone else has modified in his Emacs.  */

/* #define CLASH_DETECTION */

/* Here, on a separate page, add any special hacks needed
   to make Emacs work on this system.  For example,
   you might define certain system call names that don't
   exist on your system, or that do different things on
   your system and must be used only through an encapsulation
   (Which you should place, by convention, in sysdep.c).  */

/* Some compilers tend to put everything declared static
   into the initialized data area, which becomes pure after dumping Emacs.
   On these systems, you must #define static as nothing to foil this.
   Note that emacs carefully avoids static vars inside functions.  */

/* #define static */

/* used in dired.c */
/* #define MAXNAMLEN 100 */

/* we don't use djgcc's malloc */
/* #define SYSTEM_MALLOC */

/* setjmp and longjmp can safely replace _setjmp and _longjmp,
   but they will run slower.  */

#define _setjmp setjmp
#define _longjmp longjmp

/* we can use dj's getpagesize() */
#define HAVE_GETPAGESIZE

#ifdef EMX
#define CANNOT_UNEXEC
#define	PENDING_OUTPUT_COUNT(FILE) ((FILE)->ptr - (FILE)->buffer)
#endif

/* Text or Binary file translation is done by Emacs. */
/* #define FILE_TRANSLATION_MODE */

#ifdef GO32
/* Define this symbol if you want map fonts to the VGA display adaptor. */
/* # define HAVE_VGA_ADAPTER */
/* Define this symbol if you want control Japanese `FEP' in software. */
# define FEPCTRL
#endif /* GO32 */

/* Use gcc cross-compiler on UNIX build by -target=i386-bsd option. */
#if unix
# ifdef i386
#  undef i386
#endif
# ifdef GO32
#  define C_COMPILER gcc-i386-go32
#  define GCC_LIBDIR /usr/local/lib/gcc-lib/i386-msdos/2.3.1/go32/
#  define START_FILES crt0.o
#  define LD_SWITCH_SYSTEM -r -L$(gcclibdir)
# else
# ifdef EMX
#  define C_COMPILER gcc-i386-emx
#  define GCC_LIBDIR /usr/local/lib/gcc-lib/i386-msdos/2.3.1/emx/
#  define START_FILES
#  define LD_SWITCH_SYSTEM -r -L$(gcclibdir)
#  define LIB_STANDARD -lc -lemx
#endif
# endif
# define LINKER $(gcclibdir)ld
#else /* Not use cross-compiler. */
# ifdef GO32
# define GCC_LIBDIR f:/djgcc/
#  define START_FILES crt0.o
# define LD_SWITCH_SYSTEM -e __start -L$(gcclibdir)lib
# else
# ifdef EMX
#  define GCC_LIBDIR f:/emx/
#  define START_FILES $(gcclibdir)lib/crt0.o
#  define LD_SWITCH_SYSTEM -L$(gcclibdir)lib
#  define LIB_STANDARD -lc -lemx
# endif
# endif
#endif

#define C_SWITCH_SYSTEM -I$(supportdosdir)
