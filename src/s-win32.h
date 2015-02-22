/* s- file for Win32 API (MS Windows NT and Windows 3.1)

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

/* 93.2.25 written by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */

/*
 *      Define symbols to identify the version of Unix this is.
 *      Define all the symbols that apply correctly.
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
#ifndef WIN32
#define WIN32
#endif

/* SYSTEM_TYPE should indicate the kind of system you are using.
 It sets the Lisp variable system-type.  */

#define SYSTEM_TYPE "win32"

#define SYMS_SYSTEM syms_of_win32fns()

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
 *      Define HAVE_TIMEVAL if the system supports the BSD style clock values.
 *      Look in <sys/time.h> for a timeval structure.
 */

#define HAVE_TIMEVAL

/*
 *      Define HAVE_SELECT if the system supports the `select' system call.
 */

#define HAVE_SELECT

/*
 *      Define HAVE_PTYS if the system supports pty devices.
 */

/* #define HAVE_PTYS */

/* Define HAVE_SOCKETS if system supports 4.2-compatible sockets.  */

#define HAVE_SOCKETS
#define USE_UTIME

/*
 *      Define NONSYSTEM_DIR_LIBRARY to make Emacs emulate
 *      The 4.2 opendir, etc., library functions.
 */

/* #define NONSYSTEM_DIR_LIBRARY */

/* Define this symbol if your system has the functions bcopy, etc. */

/* #define BSTRING */

/* subprocesses should be defined if you want to
   have code for asynchronous subprocesses
   (as used in M-x compile and M-x shell).
   This is generally OS dependent, and not supported
   under most USG systems. */

#define subprocesses

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

#define SYSTEM_MALLOC

/* setjmp and longjmp can safely replace _setjmp and _longjmp,
   but they will run slower.  */

#define _setjmp setjmp
#define _longjmp longjmp

#define CANNOT_UNEXEC

/* Text or Binary file translation is done by Emacs, */
/* but currently this feature is not compatible to Mule's translation */
/* #define FILE_TRANSLATION_MODE */

#include <windows.h>

/* #define WIN32S */

#ifdef WIN32S
# undef subprocesses
# undef HAVE_SELECT
# undef HAVE_SOCKETS
#else
# define HAVE_THREAD
# define UNICODEDISPLAY
#endif
/* #define USE_FATFS */
/* #define USE_IME */

/* for compatibilities to UNIX libc */

/* #define access _access   : re-defined in ../nt/lib/libc/sys/access.c */
/* #define chown _chown	    : re-defined in ../nt/lib/libc/sys/chown.c */
/* #define open _open       : re-defined in ../nt/lib/libc/sys/open.c */
/* #define creat _creat     : re-defined in ../nt/lib/libc/creat.c */
/* #define unlink _unlink   : re-defined in ../nt/lib/libc/sys/unlink.c */
/* #define pipe _pipe       : re-defined in ../nt/lib/libc/sys/pipe.c */

#define read _read
#define write _write
#define lseek _lseek
#define dup _dup
#define dup2 _dup2
#define close _close
#define chdir _chdir
#define utime _utime
#define mktemp _mktemp

/* missing signal declaratins */

#define SIGHUP  1
#define SIGQUIT 3
#define SIGTRAP 5
#define SIGIOT  6
#define SIGKILL 9
#define SIGBUS  10
#define SIGSYS  12
#define SIGPIPE 13
