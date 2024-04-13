/* Fully extensible Emacs, running on Unix, intended for GNU.
   Copyright (C) 1985, 1986, 1987, 1990 Free Software Foundation, Inc.

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

/* 87.6.9   modified by K.Handa */
/* 88.1.10  modified for Nemacs Ver.2.0 by K.Handa */
/* 88.6.20  modified for Nemacs Ver.2.1 by K.Handa */
/* 91.10.9  modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.25  modified for Mule Ver.0.9.2 by N.Hikichi <hikichi@sra.co.jp>
	In main(), DISPLAY environment var is set. */
/* 92.3.31  modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	Sun console feature addred. */
/* 92.5.18  modified for Mule Ver.0.9.4 by T.Shingu <shingu@cpr.canon.co.jp>
	Now WNN4 is supported. */
/* 92.6.24  modified for Mule Ver.0.9.5 by Y.Akiba <akiba@cbs.canon.co.jp>
	Patch for NeXT is applied */
/* 92.7.31  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	If CANNA is defined syms_of_canna is called. */
/* 92.9.18 modified for Mule Ver.0.9.6 by K.Sakaeda <saka@pfu.fujitsu.co.jp>
	Patch for "PFU A family". */
/* 92.10.21 modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>,
		   S.Hirano <hirano@etl.go.jp>
	DOS-Extender GO32 supported. */
/* 92.11.4  modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	DOS-Extender EMX supported. */
/* 93.1.15  modified for Mule Ver.0.9.7.1 by Y.Akiba <akiba@cbs.canon.co.jp>
	Patch for NeXT is updated. */
/* 93.2.25  modified for Mule Ver.0.9.7
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	Win32 (Windows NT and Windows 3.1) supported. */
/* 93.5.12  modified for Mule Ver.0.9.8 by T.Enami <enami@sys.ptg.sony.co.jp>
	Support MCPATH. */
/* 93.5.14  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In main(), call syms_of_ccl(). */
/* 93.9.8   modified for Mule Ver.1.1 by A.Kon <kon@d1.bs2.mt.nec.co.jp>
	Wnn and Canna can coexist. */
/* 93.9.25  modified for Mule Ver.1.1 by T.Shingu <shingu@cpr.canon.co.jp>
	wnn_exit() is obsolete. */

/* This must precede sys/signal.h on certain machines.  */
#include <sys/types.h>
#include <signal.h>
#include <errno.h>

#include "config.h"
#include "lisp.h"
#include "commands.h"
#include "process.h"

/* Get FIONREAD, if it is available,
   just to help decide whether SIGIO should be defined.  */
#ifdef USG
#include <termio.h>
#include <fcntl.h>
#else /* not USG */
#ifndef VMS
#include <sys/ioctl.h>
#endif /* not VMS */
#endif /* not USG */

/* Allow m- file to inhibit use of FIONREAD.  */
#ifdef BROKEN_FIONREAD
#undef FIONREAD
#endif

/* We are unable to use interrupts if FIONREAD is not available,
   so flush SIGIO so we won't try. */
#ifndef FIONREAD
#ifdef SIGIO
#undef SIGIO
#endif
#endif

#include <stdio.h>
#include <sys/file.h>

#ifdef VMS
#include <ssdef.h>
#endif

#if 0 /* fcntl.h was included above.  */
#ifdef USG5
#include <fcntl.h>
#endif
#endif

#ifdef BSD
#include <sys/ioctl.h>
#endif

#ifdef APOLLO
#ifndef APOLLO_SR10
#include <default_acl.h>
#endif
#endif

/* 92.3.31 by K.Handa */
#ifdef HAVE_SUN_CONSOLE
#include <pixrect/pixrect_hs.h>
#endif
/* end of patch */

/* 91.10.16 by S.Hirano, 92.11.4 by M.Higashida */
#ifdef MSDOS
#ifdef GO32
#include <fcntl.h>
#else
#ifdef EMX
#include <sys/stat.h>
#endif
#endif
#endif
/* end of patch */

#ifdef HAVE_PERSONALITY_LINUX32
#include <sys/personality.h>
#ifndef ADDR_NO_RANDOMIZE
#define ADDR_NO_RANDOMIZE 0x0040000
#endif
#endif

#ifndef O_RDWR
#define O_RDWR 2
#endif

#define PRIO_PROCESS 0

/* Command line args from shell, as list of strings */
Lisp_Object Vcommand_line_args;

/* Hook run by `kill-emacs' before it does really anything.  */
Lisp_Object Vkill_emacs_hook;

/* Set nonzero after Emacs has started up the first time.
  Prevents reinitialization of the Lisp world and keymaps
  on subsequent starts.  */
int initialized;

/* Variable whose value is symbol giving operating system type */
Lisp_Object Vsystem_type;
  
/* If non-zero, emacs should not attempt to use an window-specific code,
   but instead should use the virtual terminal under which it was started */
/* 92.3.31 by K.Handa - If negative, Mule use Sun console feature. */
int inhibit_window_system;

/* 92.3.31 by K.Handa, 92.10.21 by M.Higashida  */
#if defined (HAVE_X_WINDOWS) || defined (HAVE_SUN_CONSOLE) || (defined (MSDOS) && defined(HAVE_VGA_ADAPTER)) || defined (WIN32)
/* If -d option is used, this variable points to the name of
   the display to use.  */
char *alternate_display;
char **xargv;
int xargc;
#endif /* HAVE_X_WINDOWS or HAVE_SUN_CONSOLE or (MSDOS and HAVE_VGA_ADAPTER) or WIN32 */

#ifdef USG_SHARED_LIBRARIES
/* If nonzero, this is the place to put the end of the writable segment
   at startup.  */

unsigned int bss_end = 0;
#endif

/* Nonzero means running Emacs without interactive terminal.  */

int noninteractive;

/* Value of Lisp variable `noninteractive'.
   Normally same as C variable `noninteractive'
   but nothing terrible happens if user sets this one.  */

int noninteractive1;

/* Signal code for the fatal signal that was received */
int fatal_error_code;

/* Nonzero if handling a fatal error already */
int fatal_error_in_progress;

/* Handle bus errors, illegal instruction, etc. */
void
fatal_error_signal (int sig)
{
#ifdef BSD
  int tpgrp;
#endif /* BSD */

  fatal_error_code = sig;
  signal (sig, SIG_DFL);

  /* If fatal error occurs in code below, avoid infinite recursion.  */
  if (fatal_error_in_progress)
    kill (getpid (), fatal_error_code);

  fatal_error_in_progress = 1;

  /* If we are controlling the terminal, reset terminal modes */
#ifdef BSD
  if (ioctl(0, TIOCGPGRP, &tpgrp) == 0
      && tpgrp == getpgrp ())
#endif /* BSD */
    {
      reset_sys_modes ();
      if (sig != SIGTERM)
	fprintf (stderr, "Fatal error (%d).", sig);
    }

  /* Clean up */
#ifdef subprocesses
  kill_buffer_processes (Qnil);
#endif
  Fdo_auto_save (Qt);

#ifdef CLASH_DETECTION
  unlock_all_files ();
#endif /* CLASH_DETECTION */

#ifdef VMS
  kill_vms_processes ();
  LIB$STOP (SS$_ABORT);
#else
  /* Signal the same code; this time it will really be fatal.  */
  kill (getpid (), fatal_error_code);
#endif /* not VMS */
}

/* Code for dealing with Lisp access to the Unix command line */

static void
init_cmdargs (int argc, char **argv, int skip_args)
{
  register int i;

  Vcommand_line_args = Qnil;

  for (i = argc - 1; i >= 0; i--)
    {
      if (i == 0 || i > skip_args)
	Vcommand_line_args
	  = Fcons (build_string (argv[i]), Vcommand_line_args);
    }
}

#ifdef VMS
#ifdef LINK_CRTL_SHARE
#ifdef SHAREABLE_LIB_BUG
#ifdef __GNUC__
#define	environ $$PsectAttributes_NOSHR$$environ
extern char **environ;
#else
extern noshare char **environ;
#endif
#endif /* SHAREABLE_LIB_BUG */
#endif /* LINK_CRTL_SHARE */
#endif /* VMS */
/* 92.11.4 by M.Higashida */
#if defined(MSDOS) && defined(EMX)
extern char **environ;
#endif
#ifdef WIN32
char **environ;
#endif
/* end of patch */

/* 92.11.4 by M.Higashida */
#if defined(MSDOS) && defined(EMX)
/* Setup all of files be input/output'ed with binary translation mdoe. */
asm ("	.text");
asm ("L_setbinmode:");
asm ("	movl	$1, __fmode_bin");
asm ("	ret");
asm ("	.stabs	\"___CTOR_LIST__\", 23, 0, 0, L_setbinmode");
#endif
/* end of patch */

/* We don't include crtbegin.o and crtend.o in the link,
   so these functions and variables might be missed.
   Provide dummy definitions to avoid error.
   (We don't have any real constructors or destructors.)  */
#ifdef __GNUC__
#ifndef ORDINARY_LINK
__do_clobal_ctors ()
{}
__do_clobal_ctors_aux ()
{}
__do_global_dtors ()
{}
char * __CTOR_LIST__[2] = { (char *) (-1), 0 };
char * __DTOR_LIST__[2] = { (char *) (-1), 0 };
__main ()
{}
#endif /* not ORDINARY_LINK */
#endif /* __GNUC__ */

#ifdef NeXT
#include <mach/mach.h>
NXZone *emacszone;
#endif

void syms_of_emacs (void);

/* ARGSUSED */
int
main (int argc, char **argv, char **envp)
{
  int skip_args = 0;

#ifdef HAVE_PERSONALITY_LINUX32
  /* See if there is a gap between the end of BSS and the heap.
     In that case, set personality and exec ourself again.  */
  if (!initialized
      && strcmp (argv[argc-1], "dump") == 0
      && !getenv ("EMACS_HEAP_EXEC"))
    {
      /* Set this so we only do this once.  */
      putenv ("EMACS_HEAP_EXEC=true");

      /* A flag to turn off address randomization which is introduced
	 in linux kernel shipped with fedora core 4 */
      personality (PER_LINUX32 | ADDR_NO_RANDOMIZE);

      execvp (argv[0], argv);

      /* If the exec fails, try to dump anyway.  */
      perror ("execvp");
    }
#endif /* HAVE_PERSONALITY_LINUX32 */
 
/* Map in shared memory, if we are using that.  */
#ifdef HAVE_SHM
  if (argc > 1 && !strcmp (argv[1], "-nl"))
    {
      map_in_data (0);
      /* The shared memory was just restored, which clobbered this.  */
      skip_args = 1;
    }
  else
    {
      map_in_data (1);
      /* The shared memory was just restored, which clobbered this.  */
      skip_args = 0;
    }
#endif

#ifdef VMS
  /* If -map specified, map the data file in */
  if (argc > 2 && ! strcmp (argv[1], "-map"))
    {
      skip_args = 2;
      mapin_data (argv[2]);
    }

#ifdef LINK_CRTL_SHARE
#ifdef SHAREABLE_LIB_BUG
  /* Bletcherous shared libraries! */
  if (!stdin)
    stdin = fdopen (0, "r");
  if (!stdout)
    stdout = fdopen (1, "w");
  if (!stderr)
    stderr = fdopen (2, "w");
  if (!environ)
    environ = envp;
#endif /* SHAREABLE_LIB_BUG */
#endif /* LINK_CRTL_SHARE */
#endif /* VMS */
/* 92.11.4, 93.2.17 by M.Higashida */
#if defined(MSDOS) && defined(EMX)
  environ = envp;
#endif
#ifdef WIN32
  environ = envp;
#endif
/* end of patch */

#ifdef USG_SHARED_LIBRARIES
  if (bss_end)
    brk (bss_end);
#endif

#ifdef NeXT
  extern int malloc_cookie;

  /* This helps out unexnext.c.  */
  if (initialized) {
    if (malloc_jumpstart (malloc_cookie) != 0)
      fatal("malloc jumpstart failed!\n");
  } else {
    emacszone = NXCreateZone(ZONESIZE*vm_page_size,vm_page_size,1);
    if(emacszone == NX_NOZONE)
      fatal("can't create emacs zone.\n");
  }
#endif /* NeXT */

  clearerr (stdin);

#ifdef APOLLO
#ifndef APOLLO_SR10
  /* If USE_DOMAIN_ACLS environment variable exists,
     use ACLs rather than UNIX modes. */
  if (egetenv ("USE_DOMAIN_ACLS"))
    default_acl (USE_DEFACL);
#endif
#endif /* APOLLO */

#ifndef SYSTEM_MALLOC
  /* Arrange for warnings when nearly out of space.  */
  malloc_init (0, malloc_warning);
#endif

/* 91.10.16 by S.Hirano */
#if defined(MSDOS) && defined(GO32)
  _fmode = O_BINARY;	/* all of files are treated as binary files */
  (stdin)->_flag &= ~_IOTEXT;   /* also binary for stdio */
  (stdout)->_flag &= ~_IOTEXT;
  (stderr)->_flag &= ~_IOTEXT;
#endif /* MSDOS */
/* end of patch */

#ifdef HIGHPRI
  setpriority (PRIO_PROCESS, getpid (), HIGHPRI);
  setuid (getuid ());
#endif

  inhibit_window_system = 0;

/* 92.3.31 by K.Handa, 92.10.21 by M.Higashida */
#if defined (HAVE_X_WINDOWS) || defined (HAVE_SUN_CONSOLE) || (defined(MSDOS) && defined(HAVE_VGA_ADAPTER)) || defined (WIN32)
  xargv = argv;
  xargc = argc;
#endif

/* Handle the -t switch, which specifies filename to use as terminal */
  if (skip_args + 2 < argc && !strcmp (argv[skip_args + 1], "-t"))
    {
      skip_args += 2;
      close (0);
      close (1);
      open (argv[skip_args], O_RDWR, 2 );
      dup (0);
      fprintf (stderr, "Using %s\n", argv[skip_args]);
/* 92.3.31 by K.Handa, 92.10.21 by M.Higashida */
#if defined (HAVE_X_WINDOWS) || defined (HAVE_SUN_CONSOLE) || (defined(MSDOS) && defined(HAVE_VGA_ADAPTER)) || defined (WIN32)
      inhibit_window_system = 1;	/* -t => -nw */
#endif
    }
#ifdef HAVE_X_WINDOWS
/* Handle the -d switch, which means use a different display for X */
  if (skip_args + 2 < argc && (!strcmp (argv[skip_args + 1], "-d") ||
			       !strcmp (argv[skip_args + 1], "-display")))
    {
      skip_args += 2;
      alternate_display = argv[skip_args];
    } 
  else
    alternate_display = 0;
#endif	/* HAVE_X_WINDOWS */
/* 92.3.31 by K.Handa */
#ifdef HAVE_SUN_CONSOLE
  if (skip_args + 1 < argc && (!strcmp (argv[skip_args + 1], "-sun"))) {
    extern Pixrect *screen;

    inhibit_window_system = -1;
    skip_args++;
    alternate_display = "/dev/fb";
    if (skip_args + 2 < argc && (!strcmp (argv[skip_args + 1], "-fb"))) {
      skip_args += 2;
      alternate_display = argv[skip_args];
    }
    if (screen = pr_open(alternate_display)) /* Just a test. */
      pr_close(screen);
    else
      alternate_display = 0;
  }
#endif /* HAVE_SUN_CONSOLE */
/* end of patch */
/* 92.10.17, 93.2.17 by M.Higashida */
#if defined(MSDOS) && defined(HAVE_VGA_ADAPTER)
  if (skip_args + 1 < argc && (!strcmp (argv[skip_args + 1], "-vga"))) {
    inhibit_window_system = -1;
    skip_args++;
  }
#endif /* MSDOS and HAVE_VGA_ADAPTER */
#ifdef WIN32
  inhibit_window_system = -1;
#endif
/* end of patch */
  if (skip_args + 1 < argc
      && (!strcmp (argv[skip_args + 1], "-nw")))
    {
      skip_args += 1;
      inhibit_window_system = 1;
    }

/* Handle the -batch switch, which means don't do interactive display.  */
  noninteractive = 0;
  if (skip_args + 1 < argc && !strcmp (argv[skip_args + 1], "-batch"))
    {
      skip_args += 1;
      noninteractive = 1;
    }

#ifdef POSIX_SIGNALS
  init_signals ();
#endif

#ifdef HAVE_TZSET
  /* Reinitialize the time zone if it was initialized before dumping Emacs.  */
  if (initialized)
    tzset ();
#endif
#ifdef WIN32 /* 93.2.25 by M.Higashida */
  _tzset ();
#endif

  if (
#ifndef CANNOT_DUMP
      ! noninteractive || initialized
#else
      1
#endif
      )
    {
      /* Don't catch these signals in batch mode if not initialized.
	 On some machines, this sets static data that would make
	 signal fail to work right when the dumped Emacs is run.  */
/* 91.10.16 by S.Hirano, 92.11.4 by M.Higashida */
#ifdef MSDOS
#ifdef GO32
      /* Nothing */
#else
#ifdef EMX
      signal (SIGBREAK, fatal_error_signal);
      signal (SIGQUIT, fatal_error_signal);
#endif
#endif
#else /* not MSDOS */
      signal (SIGHUP, fatal_error_signal);
      signal (SIGQUIT, fatal_error_signal);
      signal (SIGILL, fatal_error_signal);
      signal (SIGTRAP, fatal_error_signal);
      signal (SIGIOT, fatal_error_signal);
#ifdef SIGEMT
      signal (SIGEMT, fatal_error_signal);
#endif
      signal (SIGFPE, fatal_error_signal);
      signal (SIGBUS, fatal_error_signal);
      signal (SIGSEGV, fatal_error_signal);
      signal (SIGSYS, fatal_error_signal);
      signal (SIGTERM, fatal_error_signal);
#ifdef SIGXCPU
      signal (SIGXCPU, fatal_error_signal);
#endif
#ifdef SIGXFSZ
      signal (SIGXFSZ, fatal_error_signal);
#endif
#endif /* not MSDOS and GO32 */
/* end of patch */

#ifdef AIX
      /* This used to run fatal_error_signal,
	 but it isn't fatal.  There's nothing Emacs can usefully do.
	 Might as well let the system kill us if it insists.  */
      signal (SIGDANGER, SIG_IGN);
      signal (20, fatal_error_signal);
      signal (21, fatal_error_signal);
      signal (22, fatal_error_signal);
      signal (23, fatal_error_signal);
      signal (24, fatal_error_signal);
#ifdef SIGIO
      signal (SIGAIO, fatal_error_signal);
      signal (SIGPTY, fatal_error_signal);
#endif
#ifdef SIGURG
      /* Note that SIGIOINT is the same as SIGIO on some machines,
	 and the same as SIGURG on others.  It seems ore reliable to use the
	 name with a uniform meaning.  */
      signal (SIGURG, fatal_error_signal);
#endif
      signal (SIGGRANT, fatal_error_signal);
      signal (SIGRETRACT, fatal_error_signal);
      signal (SIGSOUND, fatal_error_signal);
      signal (SIGMSG, fatal_error_signal);
#endif /* AIX */
    }

  noninteractive1 = noninteractive;

/* Perform basic initializations (not merely interning symbols) */

  if (!initialized)
    {
      init_alloc_once ();
      init_obarray ();
      init_eval_once ();
      init_mc_once ();		/* 89.7.26, 91.10.19 by K.Handa */
      init_syntax_once ();	/* Create standard syntax table.  */
      init_category_once ();	/* 91.12.7 by K.Handa */
		      /* Must be done before init_buffer */
      init_buffer_once ();	/* Create buffer table and some buffers */
      init_minibuf_once ();	/* Create list of minibuffers */
			      /* Must precede init_window_once */
      init_window_once ();	/* Init the window system */
      /* 92.10.28 by M.Higashida */
#if defined (MSDOS) && defined (HAVE_VGA_ADAPTER)
      init_bdf_once ();		/* Init the BDF font structure. */
#endif
      /* end of patch */
    }

  init_alloc ();
#ifdef MAINTAIN_ENVIRONMENT
  init_environ ();
/* 92.3.25 by N.Hikichi */
#ifdef HAVE_X_WINDOWS
  if (alternate_display)
    set_environment_alist (build_string ("DISPLAY"),
			   build_string (alternate_display));
#endif /* HAVE_X_WINDOWS */
/* end of patch */
#endif
  init_codeconv ();		/* 92.1.7 by K.Handa */
  init_eval ();
  init_data ();
  init_read ();

  init_cmdargs (argc, argv, skip_args);	/* Create list Vcommand_line_args */
  init_buffer ();	/* Init default directory of main buffer */
  if (!noninteractive)
    {
#ifdef VMS
      init_vms_input ();/* init_display calls get_screen_size, that needs this */
#endif /* VMS */
      init_display ();	/* Determine terminal type.  init_sys_modes uses results */
    }
  init_keyboard ();	/* This too must precede init_sys_modes */
  init_callproc ();	/* And this too. */
  init_sys_modes ();	/* Init system terminal modes (RAW or CBREAK, etc.) */
  init_xdisp ();
  init_macros ();
  init_editfns ();
#ifdef VMS
  init_vmsfns ();
#endif /* VMS */
#ifdef subprocesses
  init_process ();
#endif /* subprocesses */

/* Intern the names of all standard functions and variables; define standard keys */

  if (!initialized)
    {
      /* The basic levels of Lisp must come first */
      /* And data must come first of all
	 for the sake of symbols like error-message */
      syms_of_data ();
      syms_of_alloc ();
#ifdef MAINTAIN_ENVIRONMENT
      syms_of_environ ();
#endif /* MAINTAIN_ENVIRONMENT */
      syms_of_read ();
      syms_of_print ();
      syms_of_eval ();
      syms_of_fns ();

      syms_of_abbrev ();
      syms_of_buffer ();
      syms_of_bytecode ();
      syms_of_callint ();
      syms_of_casefiddle ();
      syms_of_callproc ();
      syms_of_category ();	/* 91.11.11 by K.Handa */
      syms_of_codeconv ();	/* 92.1.7 by K.Handa */
      syms_of_cmds ();
#ifndef NO_DIR_LIBRARY
      syms_of_dired ();
#endif /* not NO_DIR_LIBRARY */
      syms_of_display ();
      syms_of_doc ();
      syms_of_editfns ();
      syms_of_emacs ();
      syms_of_fileio ();
#ifdef CLASH_DETECTION
      syms_of_filelock ();
#endif /* CLASH_DETECTION */
/* 92.11.1 by M.Higashida */
#ifdef FILE_TRANSLATION_MODE
      syms_of_transmode ();
#endif /* FILE_TRANSLATION_MODE */
/* end of patch */
      syms_of_indent ();
      syms_of_keyboard ();
      syms_of_keymap ();
      syms_of_macros ();
      syms_of_marker ();
      syms_of_minibuf ();
      syms_of_mocklisp ();
#ifdef subprocesses
      syms_of_process ();
#endif /* subprocesses */
      syms_of_search ();
      syms_of_syntax ();
      syms_of_undo ();
      syms_of_window ();
      syms_of_xdisp ();
#ifdef HAVE_X_WINDOWS
      syms_of_xfns ();
#ifdef HAVE_X_MENU
      syms_of_xmenu ();
#endif /* HAVE_X_MENU */
#endif /* HAVE_X_WINDOWS */
/* 87.6.8, 91.11.2, 92.3.31, 92.7.31  by K.Handa, 92.10.17, 93.2.17 by M.Higashida */
#ifdef HAVE_SUN_CONSOLE
      syms_of_sunterm ();
#endif
#if defined(MSDOS) && defined(HAVE_VGA_ADAPTER)
      syms_of_vgaterm ();
#endif
#ifdef WIN32
      syms_of_win32term ();
#endif
      syms_of_mc ();
      syms_of_ccl ();		/* 93.5.14 by K.Handa */
#ifdef WNN4
      syms_of_wnn ();
#endif
#ifdef CANNA
      syms_of_canna ();
#endif /* CANNA */
/* end of patch */

#ifdef MCPATH
      syms_of_mcpath ();
#endif /* MCPATH */

#ifdef SYMS_SYSTEM
      SYMS_SYSTEM;
#endif

#ifdef SYMS_MACHINE
      SYMS_MACHINE;
#endif

      keys_of_casefiddle ();
      keys_of_cmds ();
      keys_of_buffer ();
      keys_of_keyboard ();
      keys_of_keymap ();
      keys_of_macros ();
      keys_of_minibuf ();
      keys_of_window ();
    }

  if (!initialized)
    {
      /* Handle -l loadup-and-dump, args passed by Makefile. */
      if (argc > 2 + skip_args && !strcmp (argv[1 + skip_args], "-l"))
	Vtop_level = Fcons (intern ("load"),
			    Fcons (build_string (argv[2 + skip_args]), Qnil));
#ifdef CANNOT_DUMP
      /* Unless next switch is -nl, load "loadup.el" first thing.  */
      if (!(argc > 1 + skip_args && !strcmp (argv[1 + skip_args], "-nl")))
	Vtop_level = Fcons (intern ("load"),
			    Fcons (build_string ("loadup.el"), Qnil));
#endif /* CANNOT_DUMP */
    }

  initialized = 1;

  /* Enter editor command loop.  This never returns.  */
  Frecursive_edit ();
  /* NOTREACHED */
  return 0;
}

DEFUN ("kill-emacs", Fkill_emacs, Skill_emacs, 0, 1, "P",
  "Exit the Emacs job and kill it.  ARG means no query.\n\
If emacs is running noninteractively and ARG is an integer,\n\
return ARG as the exit program code.")
  (Lisp_Object arg)
{
  struct gcpro gcpro1;

  GCPRO1 (arg);

  if (!EQ (Vkill_emacs_hook, Qnil))
    call0 (Vkill_emacs_hook);

  if (feof (stdin))
    arg = Qt;

/* 93.9.25 by T.Shingu -- Now wnn wnn_exit() is done in wnn4-egg.el.*/

#ifdef subprocesses
  kill_buffer_processes (Qnil);
#endif /* subprocesses */

#ifdef VMS
  kill_vms_processes ();
#endif /* VMS */

  Fdo_auto_save (Qt);

#ifdef CLASH_DETECTION
  unlock_all_files ();
#endif /* CLASH_DETECTION */

  fflush (stdout);
  reset_sys_modes ();
  UNGCPRO;

/* Is it really necessary to do this deassign
   when we are going to exit anyway?  */
/* #ifdef VMS
  stop_vms_input ();
 #endif  */
  stuff_buffered_input (arg);
#ifdef SIGIO
  /* There is a tendency for a SIGIO signal to arrive within exit,
     and cause a SIGHUP because the input descriptor is already closed.  */
  unrequest_sigio ();
  signal (SIGIO, SIG_IGN);
#endif
  exit ((XTYPE (arg) == Lisp_Int) ? XINT (arg)
#ifdef VMS
	: 1
#else
	: 0
#endif
	);
  /* NOTREACHED */
}

#ifndef CANNOT_DUMP
/* Nothing like this can be implemented on an Apollo.
   What a loss!  */

#ifdef HAVE_SHM

DEFUN ("dump-emacs-data", Fdump_emacs_data, Sdump_emacs_data, 1, 1, 0,
  "Dump current state of Emacs into data file FILENAME.\n\
This function exists on systems that use HAVE_SHM.")
  (Lisp_Object intoname)
{
  extern int my_edata;
  Lisp_Object tem;

  CHECK_STRING (intoname, 0);
  intoname = Fexpand_file_name (intoname, Qnil);

  tem = Vpurify_flag;
  Vpurify_flag = Qnil;

  fflush (stdout);
  /* Tell malloc where start of impure now is */
  /* Also arrange for warnings when nearly out of space.  */
#ifndef SYSTEM_MALLOC
  malloc_init (&my_edata, malloc_warning);
#endif
  map_out_data (XSTRING (intoname)->data);

  Vpurify_flag = tem;

  return Qnil;
}

#else /* not HAVE_SHM */

DEFUN ("dump-emacs", Fdump_emacs, Sdump_emacs, 2, 2, 0,
  "Dump current state of Emacs into executable file FILENAME.\n\
Take symbols from SYMFILE (presumably the file you executed to run Emacs).")
  (Lisp_Object intoname, Lisp_Object symname)
{
  extern int my_edata;
  Lisp_Object tem;

  CHECK_STRING (intoname, 0);
  intoname = Fexpand_file_name (intoname, Qnil);
  if (!EQ (symname, Qnil))
    {
      CHECK_STRING (symname, 0);
      if (XSTRING (symname)->size)
	symname = Fexpand_file_name (symname, Qnil);
    }

  tem = Vpurify_flag;
  Vpurify_flag = Qnil;

  fflush (stdout);
#ifdef VMS
  mapout_data (XSTRING (intoname)->data);
#else
  /* Tell malloc where start of impure now is */
  /* Also arrange for warnings when nearly out of space.  */
#ifndef SYSTEM_MALLOC
  malloc_init (&my_edata, malloc_warning);
#endif
/* 92.11.4 by M.Higashida */
#if defined(MSDOS) && defined(EMX)
  {
    int fd = open (XSTRING (intoname)->data,
                   O_WRONLY|O_CREAT|O_TRUNC, S_IREAD|S_IWRITE);
    if (!fd) {
      error ("Failure operating on %s", XSTRING (intoname)->data);
    } else {
      _core (fd);
      close (fd);
    }
  }
#else /* not MSDOS and EMX */
  unexec (XSTRING (intoname)->data,
	  !EQ (symname, Qnil) ? XSTRING (symname)->data : 0, &my_edata, 0, 0);
#endif /* not MSDOS and EMX */
/* end of patch */
#endif /* not VMS */

  Vpurify_flag = tem;

  return Qnil;
}

#endif /* not HAVE_SHM */

#endif /* not CANNOT_DUMP */

#ifdef VMS
#define SEPCHAR ','
#else
/* 91.10.16 by S.Hirano, 93.2.17 by M.Higashida */
#if defined(MSDOS) || defined(WIN32)
#define SEPCHAR ';'
#else
#define SEPCHAR ':'
#endif /* MSDOS or WIN32 */
/* end of patch */
#endif

Lisp_Object
decode_env_path (char *evarname, char *defalt)
{
  register char *path, *p;

  Lisp_Object lpath;

  if (evarname != 0)
    path = (char *) egetenv (evarname);
  else
    path = 0;
  if (!path)
    path = defalt;
/* 91.10.16 by S.Hirano, 93.2.17 by M.Higashida */
#if defined(MSDOS) || defined(WIN32)
  dostounix_filename(path);
#endif
/* end of patch */
  lpath = Qnil;
  while (1)
    {
      p = index (path, SEPCHAR);
      if (!p) p = path + strlen (path);
      lpath = Fcons (p - path ? make_string (path, p - path) : Qnil,
		     lpath);
      if (*p)
	path = p + 1;
      else
	break;
    }
  return Fnreverse (lpath);
}

void
syms_of_emacs (void)
{
#ifndef CANNOT_DUMP
#ifdef HAVE_SHM
  defsubr (&Sdump_emacs_data);
#else
  defsubr (&Sdump_emacs);
#endif
#endif /* not CANNOT_DUMP */

  defsubr (&Skill_emacs);

  DEFVAR_LISP ("command-line-args", &Vcommand_line_args,
    "Args passed by shell to Emacs, as a list of strings.");

  DEFVAR_LISP ("system-type", &Vsystem_type,
    "Symbol indicating type of operating system you are using.");
  Vsystem_type = intern (SYSTEM_TYPE);

  DEFVAR_BOOL ("noninteractive", &noninteractive1,
    "Non-nil means Emacs is running without interactive terminal.");

  Vkill_emacs_hook = Qnil;

  DEFVAR_LISP ("kill-emacs-hook", &Vkill_emacs_hook,
    "Function called, if non-nil, whenever kill-emacs is called.");
}

