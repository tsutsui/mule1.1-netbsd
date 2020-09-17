/* Asynchronous subprocess control for GNU Emacs.
   Copyright (C) 1985, 1986, 1987, 1988, 1990 Free Software Foundation, Inc.

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

/* modified by A.Kato(kato@koudai.cs.titech.junet)  87.7.7 */
/* 88.1.20  modified for Nemacs Ver.2.0 by K.Handa */
/* 88.1.19  modified by K.Handa according to a patch by Mr.Sanewo (88.3.6) */
/* 88.5.19  modified for Nemacs Ver.2.1 by K.Handa */
/* 89.3.23  modified for Nemacs Ver.3.0 by K.Handa, S.Tomura */
/* 89.9.12  modified for nemacs Ver.3.2 by S.Tomura */
/* 90.2.28  modified for Nemacs Ver.3.3.1 by abe@sunrise.hallab.co.jp
	do GCPRO (proc) before Ffuncall */
/* 91.1.17  modified for Nemacs Ver.3.3.3
	by ytk@naga.ee.uec.ac.jp (Yutaka Niibe)
	do GCPRO related bug fixes */
/* 91.10.28 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.24  modified for Mule Ver.0.9.2 by T.Enami <enami@sys.ptg.sony.co.jp>
	In send_process(), encode_code() is called. */
/* 92.4.17  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	send_process() is changed to cope with new coding-system form. */
/* 92.7.15  modified for Mule Ver.0.9.5
			by Y.HIROSE <yoichi@s5g.ksp.fujixerox.co.jp>
			and K.Handa <handa@etl.go.jp>
	In send_process(), the buffer to be sent is pointed by 'buf'. */
/* 92.9.11  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Big change to support private character-set. */
/* 92.9.18  modified for Mule Ver.0.9.6 by K.Sakaeda <saka@pfu.fujitsu.co.jp>
	Patch for "PFU A family". */
/* 92.9.18  modified for Mule Ver.0.9.6
			by B.Sommerfeld <sommerfeld@apollo.hp.com>
	Patch for 386BSD.  To get subprocesses to have their controlling
	terminals set correctly. */
/* 92.9.18  modified for Mule Ver.0.9.6 by R.Sladkey <jrs@world.std.com>
	Patch for linux 0.96c pl2.
	process_send_signal90 has a hack to get shell-mode job control working
	(problem is related to process groups) */
/* 92.9.30  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	In create_process(), out_state should be set. */
/* 92.10.30 modified for Mule Ver.0.9.6 by T.Furuhata <furuhata@vnet.ibm.com>
	Change for AIX */
/* 92.12.20 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	In read_process_output(), CODE_ASCII_EOT is replaced by CC_END. */
/* 92.12.20 modified for Mule Ver.0.9.7 by T.Enami <enami@sys.ptg.sony.co.jp>
	In read_process_output(), bug fixed. */
/* 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Arguments of get_conversion_buffer() changed. */
/* 93.2.25  modified for Mule Ver.0.9.7
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	Win32 (Windows NT and Windows 3.1) supported. */
/* 93.4.16  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	'si:start-process' and 'si:open-network-process' have docs now. */
/* 93.5.6   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In Fset_process_coding_system(), CODE_ASCII_EOT --> CC_END. */
/* 93.7.8   modified for Mule Ver.0.9.8 by T.Atsushiba <toshiki@jit.dec.co.jp>
	Function type declaration of status_convert(). */
/* 93.7.17  modified for Mule Ver.0.9.8
   			by S.Komeda <komeda@ics.es.osaka-u.ac.jp>
	create_process() modified for Linux. */

/* This must precede sys/signal.h on certain machines.  */
#include <sys/types.h>
#include <signal.h>

#include "config.h"

#ifdef VMS
/* Prevent the file from being totally empty.  */
static dummy () {}
#endif

#ifdef subprocesses
/* The entire file is within this conditional */

#include <stdio.h>
#include <errno.h>
#include <setjmp.h>
#include <sys/file.h>
#include <sys/stat.h>

#ifdef HAVE_SOCKETS	/* TCP connection support, if kernel can do it */
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#endif /* HAVE_SOCKETS */

#if defined(BSD) || defined(STRIDE)
#include <sys/ioctl.h>
#if !defined (O_NDELAY) && defined (HAVE_PTYS)
#include <fcntl.h>
#endif /* HAVE_PTYS and no O_NDELAY */
#endif /* BSD or STRIDE */
#ifdef USG
#ifndef NO_TERMIO
#include <termio.h>
#endif
#include <fcntl.h>
#endif /* USG */
#ifdef WIN32 /* 93.2.25 by M.Higashida */
#include <fcntl.h>
#define O_WRONLY _O_WRONLY
#define EWOULDBLOCK 1035
#endif

#ifdef NEED_BSDTTY
#include <sys/bsdtty.h>
#endif

#ifdef NEED_TERMIOS
#include <sys/termios.h>
#endif

#ifdef TRITON88			/* To make emacs send C-c correctly in shell */
#define TIOCGPGRP FIOGETOWN
#endif

#ifdef HPUX
#undef TIOCGPGRP
#endif

/* Include time.h or sys/time.h or both.  */
#include "gettime.h"

#if defined (HPUX) && defined (HAVE_PTYS)
#include <sys/ptyio.h>
#endif
  
#ifdef AIX
#include <sys/pty.h>
#include <unistd.h>
#endif /* AIX */

#ifdef SYSV_PTYS
#include <sys/tty.h>
#include <sys/pty.h>
#endif

#ifdef XENIX
#undef TIOCGETC  /* Avoid confusing some conditionals that test this.  */
#endif

#ifdef BROKEN_TIOCGETC
#undef TIOCGETC
#endif

#ifdef BROKEN_O_NONBLOCK
#undef O_NONBLOCK
#endif

#include "lisp.h"
#include "window.h"
#include "buffer.h"
#include "process.h"
#if defined(WIN32) && defined(USE_FATFS) /* 93.2.25 by M.Higashida */
#include "termhook.h"
#else
#include "termhooks.h"
#endif
#include "termopts.h"
#include "commands.h"
#if defined(WIN32) && defined(USE_FATFS) /* 93.2.25 by M.Higashida */
#include "dispexte.h"
#else
#include "dispextern.h"
#endif
#include "mule.h"		/* 91.10.28 by K.Handa */
#include "codeconv.h"		/* 92.1.6 by K.Handa */

Lisp_Object Qrun, Qstop, Qsignal, Qopen, Qclosed;
extern Lisp_Object Qexit;

/* a process object is a network connection when its childp field is neither
   Qt nor Qnil but is instead a string (name of foreign host we
   are connected to + name of port we are connected to) */

#ifdef HAVE_SOCKETS
#define NETCONN_P(p) (XGCTYPE (XPROCESS (p)->childp) == Lisp_String)
#else
#define NETCONN_P(p) 0
#endif /* HAVE_SOCKETS */

/* Define SIGCHLD as an alias for SIGCLD.  There are many conditionals
   testing SIGCHLD.  */

#if !defined (SIGCHLD) && defined (SIGCLD)
#define SIGCHLD SIGCLD
#endif /* SIGCLD */

#if defined(WIN32) && defined(USE_FATFS) /* 93.2.25 by M.Higashida */
#include "emacssig.h"
#else
#include "emacssignal.h"
#endif

/* Define the structure that the wait system call stores.
   On many systems, there is a structure defined for this.
   But on vanilla-ish USG systems there is not.  */

#ifdef HAVE_SYS_WAIT_H /* We have sys/wait.h with POSIXoid definitions. */
#include <sys/wait.h>
#ifndef WCOREDUMP              /* not POSIX */
#define WCOREDUMP(w) ((w) & 0x80)
#endif

#else  /* !HAVE_SYS_WAIT_H */

/* Note that sys/wait.h may still be included by stdlib.h or something
   according to XPG.  */

#undef WEXITSTATUS
#define WEXITSTATUS(w) (((w) & 0xff00) >> 8)
#undef WIFEXITED
#define WIFEXITED(w) (WTERMSIG(w) == 0)
#undef WIFSTOPPED
#define WIFSTOPPED(w) (((w) & 0xff) == 0x7f)
#undef WIFSIGNALED
#define WIFSIGNALED(w) (!WIFSTOPPED(w) && !WIFEXITED(w))
#undef WSTOPSIG
#define WSTOPSIG(w) WEXITSTATUS(w)
#undef WTERMSIG
#define WTERMSIG(w) ((w) & 0x7f)
#undef WCOREDUMP
#define WCOREDUMP(w) ((w) & 0x80)
#endif /* HAVE_SYS_WAIT_H */

#undef WAITTYPE
#define WAITTYPE int
#undef WRETCODE
#define WRETCODE(w) WEXITSTATUS (w)

#if !defined(HAVE_STRERROR)
extern errno;
extern sys_nerr;
extern char *sys_errlist[];
#define err_str(a) ((a) < sys_nerr ? sys_errlist[a] : "unknown error")
#else
#define err_str(a) strerror(a)
#endif

#if !defined(HAVE_STRSIGNAL)
#if !defined(BSD4_1) && !defined(WIN32) /* 93.2.17 by M.Higashida */
#ifndef SYS_SIGLIST_DECLARED
extern char *sys_siglist[];
#endif /* ! SYS_SYGLIST_DECLARED */
#else
char *sys_siglist[] =
  {
    "bum signal!!",
    "hangup",
    "interrupt",
    "quit",
    "illegal instruction",
    "trace trap",
    "iot instruction",
    "emt instruction",
    "floating point exception",
    "kill",
    "bus error",
    "segmentation violation",
    "bad argument to system call",
    "write on a pipe with no one to read it",
    "alarm clock",
    "software termination signal from kill",
    "status signal",
    "sendable stop signal not from tty",
    "stop signal from tty",
    "continue a stopped process",
    "child status has changed",
    "background read attempted from control tty",
    "background write attempted from control tty",
    "input record available at control tty",
    "exceeded CPU time limit",
    "exceeded file size limit"
    };
#endif
#define strsignal(code)	sys_siglist[(code)]
#endif

#ifdef vipc

#include "vipc.h"
extern int comm_server;
extern int net_listen_address;
#endif /* vipc */

/* t means use pty, nil means use a pipe,
   maybe other values to come.  */
Lisp_Object Vprocess_connection_type;

#ifdef SKTPAIR
#ifndef HAVE_SOCKETS
#include <sys/socket.h>
#endif
#endif /* SKTPAIR */

/* Number of events of change of status of a process.  */
int process_tick;

/* Number of events for which the user or sentinel has been notified.  */
int update_tick;

int delete_exited_processes;

#ifdef FD_SET
/* We could get this from param.h, but better not to depend on finding that.
   And better not to risk that it might define other symbols used in this
   file.  */
#define MAXDESC 64
#define SELECT_TYPE fd_set
#else /* no FD_SET */
#define MAXDESC 32
#define SELECT_TYPE int

/* Define the macros to access a single-int bitmap of descriptors.  */
#define FD_SET(n, p) (*(p) |= (1 << (n)))
#define FD_CLR(n, p) (*(p) &= ~(1 << (n)))
#define FD_ISSET(n, p) (*(p) & (1 << (n)))
#define FD_ZERO(p) (*(p) = 0)
#endif /* no FD_SET */

/* Mask of bits indicating the descriptors that we wait for input on */

SELECT_TYPE input_wait_mask;

/* Indexed by descriptor, gives the process (if any) for that descriptor */
Lisp_Object chan_process[MAXDESC];

/* Alist of elements (NAME . PROCESS) */
Lisp_Object Vprocess_alist;

Lisp_Object Qprocessp;

Lisp_Object get_process (Lisp_Object);

/* Buffered-ahead input char from process, indexed by channel.
   -1 means empty (no char is buffered).
   Used on sys V where the only way to tell if there is any
   output from the process is to read at least one char.
   Always -1 on systems that support FIONREAD.  */

int proc_buffered_char[MAXDESC];

/* 91.10.28, 92.9.11 by K.Handa -- intermediate status of code conversion. */
coding_type in_state[MAXDESC], out_state[MAXDESC];
/* end of patch */

/* These variables hold the filter about to be run, and its args,
   between read_process_output and run_filter.
   Also used in exec_sentinel for sentinels.  */
Lisp_Object this_filter;
Lisp_Object filter_process, filter_string;

/* Compute the Lisp form of the process status, p->status,
   from the numeric status that was returned by `wait'.  */

Lisp_Object status_convert(WAITTYPE);	/* 93.7.8 by T.Atsushiba */

void deactivate_process (Lisp_Object);
void status_notify (void);
void create_process (Lisp_Object, char **);
int read_process_output (Lisp_Object, int);
void exec_sentinel (Lisp_Object, Lisp_Object);

void
update_status (struct Lisp_Process *p)
{
  union { int i; WAITTYPE wt; } u;
  u.i = XFASTINT (p->raw_status_low) + (XFASTINT (p->raw_status_high) << 16);
  p->status = status_convert (u.wt);
  p->raw_status_low = Qnil;
  p->raw_status_high = Qnil;
}

/* Convert a process status word in Unix format
   to the list that we use internally.  */

Lisp_Object
status_convert (WAITTYPE w)
{
  if (WIFSTOPPED (w))
    return Fcons (Qstop, Fcons (make_number (WSTOPSIG (w)), Qnil));
  else if (WIFEXITED (w))
    return Fcons (Qexit, Fcons (make_number (WRETCODE (w)),
				WCOREDUMP (w) ? Qt : Qnil));
  else if (WIFSIGNALED (w))
    return Fcons (Qsignal, Fcons (make_number (WTERMSIG (w)),
				  WCOREDUMP (w) ? Qt : Qnil));
  else
    return Qrun;
}

/* Given a status-list, extract the three pieces of information
   and store them individually through the three pointers.  */

void
decode_status (Lisp_Object l, Lisp_Object *symbol, int *code, int *coredump)
{
  Lisp_Object tem;

  if (XTYPE (l) == Lisp_Symbol)
    {
      *symbol = l;
      *code = 0;
      *coredump = 0;
    }
  else
    {
      *symbol = XCONS (l)->car;
      tem = XCONS (l)->cdr;
      *code = XFASTINT (XCONS (tem)->car);
      tem = XFASTINT (XCONS (tem)->cdr);
      *coredump = !NILP (tem);
    }
}

/* Return a string describing a process status list.  */

Lisp_Object
status_message (Lisp_Object status)
{
  Lisp_Object symbol;
  int code, coredump;
  Lisp_Object string, string2;

  decode_status (status, &symbol, &code, &coredump);

  if (EQ (symbol, Qsignal) || EQ (symbol, Qstop))
    {
      string = build_string (code < NSIG ? strsignal(code) : "unknown");
      string2 = build_string (coredump ? " (core dumped)\n" : "\n");
      XSTRING (string)->data[0] = DOWNCASE (XSTRING (string)->data[0]);
      return concat2 (string, string2);
    }
  else if (EQ (symbol, Qexit))
    {
      if (code == 0)
	return build_string ("finished\n");
      string = Fint_to_string (make_number (code));
      string2 = build_string (coredump ? " (core dumped)\n" : "\n");
      return concat2 (build_string ("exited abnormally with code "),
		      concat2 (string, string2));
    }
  else
    return Fcopy_sequence (Fsymbol_name (symbol));
}

#ifdef HAVE_PTYS

/* Open an available pty, returning a file descriptor.
   Return -1 on failure.
   The file name of the terminal corresponding to the pty
   is left in the variable pty_name.  */

char pty_name[24];

int
allocate_pty (void)
{
  struct stat stb;
  register int c, i;
  int fd;

  /* Some systems name their pseudoterminals so that there are gaps in
     the usual sequence - for example, on HP9000/S700 systems, there
     are no pseudoterminals with names ending in 'f'.  So we wait for
     three failures in a row before deciding that we've reached the
     end of the ptys.  */
  int failed_count = 0;

#ifdef PTY_ITERATION
  PTY_ITERATION
#else
  for (c = FIRST_PTY_LETTER; c <= 'z'; c++)
    for (i = 0; i < 16; i++)
#endif
      {
#ifdef PTY_NAME_SPRINTF
	PTY_NAME_SPRINTF
#else
#ifdef HPUX
	sprintf (pty_name, "/dev/ptym/pty%c%x", c, i);
#else
#ifdef RTU
	sprintf (pty_name, "/dev/pty%x", i);
#else
	sprintf (pty_name, "/dev/pty%c%x", c, i);
#endif /* not RTU */
#endif /* not HPUX */
#endif /* no PTY_NAME_SPRINTF */

#ifdef PTY_OPEN
	PTY_OPEN;
#else /* no PTY_OPEN */
#ifndef IRIS
	if (stat (pty_name, &stb) < 0)
	  {
	    failed_count++;
	    if (failed_count >= 3)
	      return -1;
	  }
	else
	  failed_count = 0;
#ifdef O_NONBLOCK
	fd = open (pty_name, O_RDWR | O_NONBLOCK, 0);
#else
	fd = open (pty_name, O_RDWR | O_NDELAY, 0);
#endif
#else /* Unusual IRIS code */
 	fd = open ("/dev/ptc", O_RDWR | O_NDELAY, 0);
 	if (fd < 0)
 	  return -1;
	if (fstat (fd, &stb) < 0)
	  return -1;
#endif /* IRIS */
#endif /* no PTY_OPEN */

	if (fd >= 0)
	  {
	    /* check to make certain that both sides are available
	       this avoids a nasty yet stupid bug in rlogins */
#ifdef PTY_TTY_NAME_SPRINTF
	    PTY_TTY_NAME_SPRINTF
#else
	    /* In version 19, make these special cases use the macro above.  */
#ifdef HPUX
            sprintf (pty_name, "/dev/pty/tty%c%x", c, i);
#else
#ifdef RTU
            sprintf (pty_name, "/dev/ttyp%x", i);
#else
#ifdef IRIS
 	    sprintf (pty_name, "/dev/ttyq%d", minor (stb.st_rdev));
#else
            sprintf (pty_name, "/dev/tty%c%x", c, i);
#endif /* not IRIS */
#endif /* not RTU */
#endif /* not HPUX */
#endif /* no PTY_TTY_NAME_SPRINTF */
#ifndef UNIPLUS
	    if (access (pty_name, 6) != 0)
	      {
		close (fd);
#if !defined(IRIS) && !defined(IRIX5)
		continue;
#else
		return -1;
#endif /* IRIS */
	      }
#endif /* not UNIPLUS */
	    setup_pty (fd);
	    return fd;
	  }
      }
  return -1;
}
#endif /* HAVE_PTYS */

Lisp_Object
make_process (Lisp_Object name)
{
  register Lisp_Object val, tem, name1;
  register struct Lisp_Process *p;
  char suffix[10];
  register int i;

  /* size of process structure includes the vector header,
     so deduct for that.  But struct Lisp_Vector includes the first
     element, thus deducts too much, so add it back.  */
  val = Fmake_vector (make_number ((sizeof (struct Lisp_Process)
				    - sizeof (struct Lisp_Vector)
				    + sizeof (Lisp_Object))
				   / sizeof (Lisp_Object)),
		      Qnil);
  XSETTYPE (val, Lisp_Process);

  p = XPROCESS (val);
  XFASTINT (p->infd) = 0;
  XFASTINT (p->outfd) = 0;
  XFASTINT (p->pid) = 0;
  XFASTINT (p->tick) = 0;
  XFASTINT (p->update_tick) = 0;
  p->raw_status_low = Qnil;
  p->raw_status_high = Qnil;
  p->status = Qrun;
  p->mark = Fmake_marker ();

  /* If name is already in use, modify it until it is unused.  */

  name1 = name;
  for (i = 1; ; i++)
    {
      tem = Fget_process (name1);
      if (NILP (tem)) break;
      sprintf (suffix, "<%d>", i);
      name1 = concat2 (name, build_string (suffix));
    }
  name = name1;
  p->name = name;
  Vprocess_alist = Fcons (Fcons (name, val), Vprocess_alist);
  return val;
}

void
remove_process (register Lisp_Object proc)
{
  register Lisp_Object pair;

  pair = Frassq (proc, Vprocess_alist);
  Vprocess_alist = Fdelq (pair, Vprocess_alist);
  Fset_marker (XPROCESS (proc)->mark, Qnil, Qnil);

  deactivate_process (proc);
}

DEFUN ("processp", Fprocessp, Sprocessp, 1, 1, 0,
  "Return t if OBJECT is a process.")
  (Lisp_Object obj)
{
  return XTYPE (obj) == Lisp_Process ? Qt : Qnil;
}

DEFUN ("get-process", Fget_process, Sget_process, 1, 1, 0,
  "Return the process named NAME, or nil if there is none.")
  (register Lisp_Object name)
{
  if (XTYPE (name) == Lisp_Process)
    return name;
  CHECK_STRING (name, 0);
  return Fcdr (Fassoc (name, Vprocess_alist));
}

DEFUN ("get-buffer-process", Fget_buffer_process, Sget_buffer_process, 1, 1, 0,
  "Return the (or, a) process associated with BUFFER.\n\
BUFFER may be a buffer or the name of one.")
  (register Lisp_Object name)
{
  register Lisp_Object buf, tail, proc;

  if (NILP (name)) return Qnil;
  buf = Fget_buffer (name);
  if (NILP (buf)) return Qnil;

  for (tail = Vprocess_alist; !NILP (tail); tail = Fcdr (tail))
    {
      proc = Fcdr (Fcar (tail));
      if (XTYPE (proc) == Lisp_Process && EQ (XPROCESS (proc)->buffer, buf))
	return proc;
    }
  return Qnil;
}

/* This is how commands for the user decode process arguments */

Lisp_Object
get_process (register Lisp_Object name)
{
  register Lisp_Object proc;
  if (NILP (name))
    proc = Fget_buffer_process (Fcurrent_buffer ());
  else
    {
      proc = Fget_process (name);
      if (NILP (proc))
	proc = Fget_buffer_process (Fget_buffer (name));
    }

  if (!NILP (proc))
    return proc;

  if (NILP (name))
    error ("Current buffer has no process");
  else
    error ("Process %s does not exist", XSTRING (name)->data);
  /* NOTREACHED */
}

DEFUN ("delete-process", Fdelete_process, Sdelete_process, 1, 1, 0,
  "Delete PROCESS: kill it and forget about it immediately.\n\
PROCESS may be a process or the name of one, or a buffer name.")
  (register Lisp_Object proc)
{
  proc = get_process (proc);
  XPROCESS (proc)->raw_status_low = Qnil;
  XPROCESS (proc)->raw_status_high = Qnil;
  if (NETCONN_P (proc))
    {
      XPROCESS (proc)->status = Fcons (Qexit, Fcons (make_number (0), Qnil));
      XSETINT (XPROCESS (proc)->tick, ++process_tick);
    }
  else if (XFASTINT (XPROCESS (proc)->infd))
    {
      Fkill_process (proc, Qnil);
      /* Do this now, since remove_process will make sigchld_handler do nothing.  */
      XPROCESS (proc)->status
	= Fcons (Qsignal, Fcons (make_number (SIGKILL), Qnil));
      XSETINT (XPROCESS (proc)->tick, ++process_tick);
      status_notify ();
    }
  remove_process (proc);
  return Qnil;
}

DEFUN ("process-status", Fprocess_status, Sprocess_status, 1, 1, 0,
  "Return the status of PROCESS: a symbol, one of these:\n\
run  -- for a process that is running.\n\
stop -- for a process stopped but continuable.\n\
exit -- for a process that has exited.\n\
signal -- for a process that has got a fatal signal.\n\
open -- for a network stream connection that is open.\n\
closed -- for a network stream connection that is closed.\n\
nil -- if arg is a process name and no such process exists.")
/* command -- for a command channel opened to Emacs by another process.\n\
   external -- for an i/o channel opened to Emacs by another process.\n\  */
  (register Lisp_Object proc)
{
  register struct Lisp_Process *p;
  register Lisp_Object status;
  proc = Fget_process (proc);
  if (NILP (proc))
    return proc;
  p = XPROCESS (proc);
  if (!NILP (p->raw_status_low))
    update_status (p);
  status = p->status;
  if (XTYPE (status) == Lisp_Cons)
    status = XCONS (status)->car;
  if (NETCONN_P (proc))
    {
      if (EQ (status, Qrun))
	status = Qopen;
      else if (EQ (status, Qexit))
	status = Qclosed;
    }
  return status;
}

DEFUN ("process-exit-status", Fprocess_exit_status, Sprocess_exit_status,
       1, 1, 0,
  "Return the exit status of PROCESS or the signal number that killed it.\n\
If PROCESS has not yet exited or died, return 0.\n\
If PROCESS is a net connection that was closed remotely, return 256.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  if (!NILP (XPROCESS (proc)->raw_status_low))
    update_status (XPROCESS (proc));
  if (XTYPE (XPROCESS (proc)->status) == Lisp_Cons)
    return XCONS (XCONS (XPROCESS (proc)->status)->cdr)->car;
  return make_number (0);
}

DEFUN ("process-id", Fprocess_id, Sprocess_id, 1, 1, 0,
  "Return the process id of PROCESS.\n\
This is the pid of the Unix process which PROCESS uses or talks to.\n\
For a network connection, this value is nil.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->pid;
}

DEFUN ("process-name", Fprocess_name, Sprocess_name, 1, 1, 0,
  "Return the name of PROCESS, as a string.\n\
This is the name of the program invoked in PROCESS,\n\
possibly modified to make it unique among process names.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->name;
}

DEFUN ("process-command", Fprocess_command, Sprocess_command, 1, 1, 0,
  "Return the command that was executed to start PROCESS.\n\
This is a list of strings, the first string being the program executed\n\
and the rest of the strings being the arguments given to it.\n\
For a non-child channel, this is nil.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->command;
}

DEFUN ("set-process-buffer", Fset_process_buffer, Sset_process_buffer,
  2, 2, 0,
  "Set buffer associated with PROCESS to BUFFER (a buffer, or nil).")
  (register Lisp_Object proc, register Lisp_Object buffer)
{
  CHECK_PROCESS (proc, 0);
  if (!NILP (buffer))
    CHECK_BUFFER (buffer, 1);
  XPROCESS (proc)->buffer = buffer;
  return buffer;
}

DEFUN ("process-buffer", Fprocess_buffer, Sprocess_buffer,
  1, 1, 0,
  "Return the buffer PROCESS is associated with.\n\
Output from PROCESS is inserted in this buffer\n\
unless PROCESS has a filter.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->buffer;
}

DEFUN ("process-mark", Fprocess_mark, Sprocess_mark,
  1, 1, 0,
  "Return the marker for the end of the last output from PROCESS.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->mark;
}

DEFUN ("set-process-filter", Fset_process_filter, Sset_process_filter,
  2, 2, 0,
  "Give PROCESS the filter function FILTER; nil means no filter.\n\
When a process has a filter, each time it does output\n\
the entire string of output is passed to the filter.\n\
The filter gets two arguments: the process and the string of output.\n\
If the process has a filter, its buffer is not used for output.")
  (register Lisp_Object proc, register Lisp_Object filter)
{
  CHECK_PROCESS (proc, 0);
  XPROCESS (proc)->filter = filter;
  return filter;
}

DEFUN ("process-filter", Fprocess_filter, Sprocess_filter,
  1, 1, 0,
  "Returns the filter function of PROCESS; nil if none.\n\
See set-process-filter for more info on filter functions.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->filter;
}

DEFUN ("set-process-sentinel", Fset_process_sentinel, Sset_process_sentinel,
  2, 2, 0,
  "Give PROCESS the sentinel SENTINEL; nil for none.\n\
The sentinel is called as a function when the process changes state.\n\
It gets two arguments: the process, and a string describing the change.")
  (register Lisp_Object proc, register Lisp_Object sentinel)
{
  CHECK_PROCESS (proc, 0);
  XPROCESS (proc)->sentinel = sentinel;
  return sentinel;
}

DEFUN ("process-sentinel", Fprocess_sentinel, Sprocess_sentinel,
  1, 1, 0,
  "Return the sentinel of PROCESS; nil if none.\n\
See set-process-sentinel for more info on sentinels.")
  (register Lisp_Object proc)
{
  CHECK_PROCESS (proc, 0);
  return XPROCESS (proc)->sentinel;
}

DEFUN ("process-kill-without-query", Fprocess_kill_without_query,
  Sprocess_kill_without_query, 1, 2, 0,
  "Say no query needed if PROCESS is running when Emacs is exited.\n\
Optional second argument if non-nil says to require a query.\n\
Value is t if a query was formerly required.")
  (register Lisp_Object proc, register Lisp_Object value)
{
  Lisp_Object tem;
  CHECK_PROCESS (proc, 0);
  tem = XPROCESS (proc)->kill_without_query;
  XPROCESS (proc)->kill_without_query = Fnull (value);
  return Fnull (tem);
}

Lisp_Object
list_processes_1 (void)
{
  register Lisp_Object tail, tem;
  Lisp_Object proc, minspace, tem1;
  register struct buffer *old = current_buffer;
  register struct Lisp_Process *p;
  register int state;
  char tembuf[80];

  XFASTINT (minspace) = 1;

  set_buffer_internal (XBUFFER (Vstandard_output));
  Fbuffer_flush_undo (Vstandard_output);

  current_buffer->truncate_lines = Qt;

  write_string ("\
Proc         Status   Buffer         Command\n\
----         ------   ------         -------\n", -1);

  for (tail = Vprocess_alist; !NILP (tail); tail = Fcdr (tail))
    {
      Lisp_Object symbol;

      proc = Fcdr (Fcar (tail));
      p = XPROCESS (proc);
      if (NILP (p->childp))
	continue;

      Finsert (1, &p->name);
      Findent_to (make_number (13), minspace);

      if (!NILP (p->raw_status_low))
	update_status (p);
      symbol = p->status;
      if (XTYPE (p->status) == Lisp_Cons)
	symbol = XCONS (p->status)->car;

      if (EQ (symbol, Qsignal))
	{
	  Lisp_Object tem;
	  tem = Fcar (Fcdr (p->status));
	  if (XINT (tem) < NSIG)
	    write_string (strsignal(XINT (tem)), -1);
	  else
	    Fprinc (symbol, Qnil);
	}
      else if (NETCONN_P (proc))
	{
	  if (EQ (symbol, Qrun))
	    write_string ("open", -1);
	  else if (EQ (symbol, Qexit))
	    write_string ("closed", -1);
	  else
	    Fprinc (symbol, Qnil);
	}
      else
	Fprinc (symbol, Qnil);

      if (EQ (symbol, Qexit))
	{
	  Lisp_Object tem;
	  tem = Fcar (Fcdr (p->status));
	  if (XFASTINT (tem))
	    {
	      sprintf (tembuf, " %d", XFASTINT (tem));
	      write_string (tembuf, -1);
	    }
	}

      if (EQ (symbol, Qsignal) || EQ (symbol, Qexit))
	remove_process (proc);

      Findent_to (make_number (22), minspace);
      if (NILP (p->buffer))
	InsStr ("(none)");
      else if (NILP (XBUFFER (p->buffer)->name))
	InsStr ("(Killed)");
      else
	Finsert (1, &XBUFFER (p->buffer)->name);

      Findent_to (make_number (37), minspace);

      if (NETCONN_P (proc))
        {
	  sprintf (tembuf, "(network stream connection to %s)\n",
		   XSTRING (p->childp)->data);
	  InsStr (tembuf);
        }
      else 
	{
	  tem = p->command;
	  while (1)
	    {
	      tem1 = Fcar (tem);
	      Finsert (1, &tem1);
	      tem = Fcdr (tem);
	      if (NILP (tem))
		break;
	      InsStr (" ");
	    }
	  InsStr ("\n");
       }
    }

  return Qnil;
}

DEFUN ("list-processes", Flist_processes, Slist_processes, 0, 0, "",
  "Display a list of all processes.\n\
\(Any processes listed as Exited or Signaled are actually eliminated\n\
after the listing is made.)")
  (void)
{
  internal_with_output_to_temp_buffer ("*Process List*",
				       list_processes_1, Qnil);
  return Qnil;
}

DEFUN ("process-list", Fprocess_list, Sprocess_list, 0, 0, 0,
  "Return a list of all processes.")
  (void)
{
  return Fmapcar (Qcdr, Vprocess_alist);
}

DEFUN ("si:start-process", Fsi_start_process, Ssi_start_process, 5, MANY, 0,
  "Start a program in a subprocess.  Return the process object for it.\n\
Args are NAME BUFFER INCODE OUTCODE PROGRAM &rest PROGRAM-ARGS\n\
NAME is name for process.  It is modified if necessary to make it unique.\n\
BUFFER is the buffer or (buffer-name) to associate with the process.\n\
 Process output goes at end of that buffer, unless you specify\n\
 an output stream or filter function to handle the output.\n\
 BUFFER may be also nil, meaning that this process is not associated\n\
 with any buffer.\n\
INCODE and OUTCODE specify the coding-system objects used in input/output\n\
 from/to the process.\n\
Fifth arg is program file name.  It is searched for as in the shell.\n\
Remaining arguments are strings to give program as arguments.")
  (int nargs, register Lisp_Object *args)
{
  Lisp_Object buffer, name, program, proc, tem;
  Lisp_Object incode, outcode;	/* 91.11.6 by K.Handa */
  register unsigned char **new_argv;
  register int i;

  buffer = args[1];
  if (!NILP (buffer))
    buffer = Fget_buffer_create (buffer);

  name = args[0];
  CHECK_STRING (name, 0);

/* 91.10.28 by K.Handa */  
  program = args[4];

  CHECK_STRING (program, 4);

  incode = Fcheck_code(args[2]);
  outcode = Fcheck_code(args[3]);

  new_argv = (unsigned char **) alloca ((nargs - 3) * sizeof (char *));

  for (i = 5; i < nargs; i++)
    {
      tem = args[i];
      CHECK_STRING (tem, i);
      new_argv[i - 4] = XSTRING (tem)->data;
    }
  new_argv[i - 4] = 0;
/* end of patch */
  new_argv[0] = XSTRING (program)->data;

  /* If program file name is not absolute, search our path for it */
  if (new_argv[0][0] != '/')
    {
      tem = Qnil;
      openp (Vexec_path, program, "", &tem, 1);
      if (NILP (tem))
	report_file_error ("Searching for program", Fcons (program, Qnil));
      new_argv[0] = XSTRING (tem)->data;
    }

  proc = make_process (name);

  XPROCESS (proc)->childp = Qt;
  XPROCESS (proc)->command_channel_p = Qnil;
  XPROCESS (proc)->buffer = buffer;
  XPROCESS (proc)->sentinel = Qnil;
  XPROCESS (proc)->filter = Qnil;
/* 91.11.6 by K.Handa */
  XPROCESS (proc)->command = Flist (nargs - 4, args + 4);
  XPROCESS (proc)->incode = incode;
  XPROCESS (proc)->outcode = outcode;
/* end of patch */

  create_process (proc, new_argv);

  return proc;
}

/* 93.4.16 by K.Handa */
DEFUN ("start-process", Fstart_process, Sstart_process, 5, MANY, 0, "")
  (int nargs, register Lisp_Object *args)
{
  return Fsi_start_process (nargs, args);
}
/* end of patch */

void
create_process_1 (int signo)
{
#ifdef USG
  /* USG systems forget handlers when they are used;
     must reestablish each time */
  signal (signo, create_process_1);
#endif /* USG */
}

#if 0  /* This doesn't work; see the note before sigchld_handler.  */
#ifdef USG
#ifdef SIGCHLD
/* Mimic blocking of signals on system V, which doesn't really have it.  */

/* Nonzero means we got a SIGCHLD when it was supposed to be blocked.  */
int sigchld_deferred;

int
create_process_sigchld (void)
{
  signal (SIGCHLD, create_process_sigchld);

  sigchld_deferred = 1;
}
#endif
#endif
#endif

#ifdef WIN32 /* 93.2.17 by M.Higashida */

#define PIPE_BUFSIZ 1024

typedef struct {
  OVERLAPPED	oOverlap;
  HANDLE	hPipeInst;
  BOOL		fPendingIO;
  char		buf[PIPE_BUFSIZ];
} PIPEINST, *LPPIPEINST;

/* MAXDESC = 64,
 *  0      : stdin  (WM_CHAR Event)
 *  1      : stdout (ignore)
 *  2      : stderr (ignore)
 *  3 - 31 : Named Pipe
 * 32 - 63 : Socket
 */

static PIPEINST Pipe[MAXDESC];

HANDLE hWaitObject[MAXDESC]; /* MAXDESC should be less than 64 */

static SELECT_TYPE socket_wait_mask;
static int num_sockets = 0;
static CRITICAL_SECTION SocketCliticalSection;

static unsigned int named_pipe_descs;
static unsigned int socket_descs;

static int
open_channel (int *descs)
{
  int i;

  for (i = 0; i < 32; i++) {
    if (!(*descs & (1 << i))) {
      *descs |= (1 << i);
      return i;
    }
  }
  return -1;
}

static void
close_channel (int *descs, int channel)
{
  *descs &= ~(1 << channel);
}

void
Subprocess (char **new_argv)
{
  extern char **environ;
  char **env = environ;
  int in, out, err;

#if 0
  in = open ("nul", O_WRONLY);
  out = open ("nul", O_BINARY);
  err = open ("nul", O_BINARY);
  
  child_setup (in, out, err, new_argv, env);

  close (in);
  close (out);
  close (err);
#else
  child_setup (0, 0, 0, new_argv, env);
#endif
}

void
SelectSocket (void)
{
  int i, nfds;
  SELECT_TYPE Available;
  struct timeval zero;

  zero.tv_sec = 0;
  zero.tv_usec = 0;

  while (1) {
    if (!socket_descs) {
      _sleep (100);
    } else {
#if 1
      Available = socket_wait_mask;
#else
      FD_ZERO (&Available);
      for (i = 32; i < 64; i++) {
        if (FD_ISSET (i, &input_wait_mask) /* !NILP (chan_process[i]) */) {
	  FD_SET ((int) Pipe[i].hPipeInst, &Available);
        }
      }
#endif
		  
      EnterCriticalSection (&SocketCliticalSection);
      nfds = select (num_sockets, &Available, 0, 0, &zero);
      LeaveCriticalSection (&SocketCliticalSection);

      if (nfds > 0) {
	for (i = 32; i < 63; i++) {
	  if (FD_ISSET ((int) Pipe[i].hPipeInst, &Available)) {
	    SetEvent (hWaitObject[i]);
	  } else {
	    ResetEvent (hWaitObject[i]);
	  }
	}
      }
      _sleep (10);
    }
  }
}

void 
create_process (Lisp_Object process, char **new_argv)
{
  int pid;
  int inchannel, outchannel;
  int sv[2];
  int pty_flag = 0;

  {
    inchannel = outchannel = open_channel (&named_pipe_descs);

    if (inchannel < 0)
      error ("Too many named pipe.");

    {
      SECURITY_ATTRIBUTES SecurityAttr;
      SECURITY_DESCRIPTOR SecurityDesc;
      char *pipe_name[MAX_PATH];

      InitializeSecurityDescriptor(&SecurityDesc, SECURITY_DESCRIPTOR_REVISION);
      SetSecurityDescriptorDacl(&SecurityDesc, 0, 0, 0);
      
      SecurityAttr.nLength = sizeof(SecurityAttr);
      SecurityAttr.lpSecurityDescriptor = &SecurityDesc;
      SecurityAttr.bInheritHandle = 0;

      sprintf (pipe_name, "\\\\.\\pipe\\emacs\\%08x.%08x",
	       GetCurrentProcessId (), inchannel);

      SetEnvironmentVariable ("EmacsPipeName", pipe_name);

      Pipe[inchannel].hPipeInst
	= CreateNamedPipe (pipe_name,
			   PIPE_ACCESS_DUPLEX | FILE_FLAG_OVERLAPPED,
			   PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE |
			   PIPE_WAIT,
			   PIPE_UNLIMITED_INSTANCES,
			   0,
			   0,
			   1000,
			   &SecurityAttr);
      
      if (Pipe[inchannel].hPipeInst == INVALID_HANDLE_VALUE)
	error ("Failing to create named pipe.");
    }
  }

  XFASTINT (XPROCESS (process)->infd) = inchannel;
  XFASTINT (XPROCESS (process)->outfd) = outchannel;

  /* Record the tty descriptor used in the subprocess.  */
  XPROCESS (process)->subtty = Qnil;

/* 92.1.21, 92.9.11, 92.9.30 by K.Handa */
  encode_code(XPROCESS (process)->incode, &in_state[inchannel]);
  encode_code(XPROCESS (process)->outcode, &out_state[outchannel]);
  CODE_CNTL(&out_state[outchannel]) |= CC_END;
/* end of patch */
  XPROCESS (process)->pty_flag = (pty_flag ? Qt : Qnil);
  XPROCESS (process)->status = Qrun;
  /* Record this as an active process, with its channels.
     As a result, child_setup will close Emacs's side of the pipes.  */
  chan_process[inchannel] = process;

  /* Until we store the proper pid, enable sigchld_handler
     to recognize an unknown pid as standing for this process.  */
  XSETINT (XPROCESS (process)->pid, -1);

  /* Turn on the bit for our input from this process now,
     so that even if the process terminates very soon,
     we can clear the bit properly on termination.
     If fork fails, remove_process will clear the bit.  */
  FD_SET (inchannel, &input_wait_mask);

  {
    HANDLE hThread;
    
    {
      SECURITY_ATTRIBUTES sa;
      
      sa.nLength = sizeof (SECURITY_ATTRIBUTES);
      sa.bInheritHandle = 0;
      sa.lpSecurityDescriptor = 0;
    
      hThread = CreateThread (&sa, (DWORD) 0,
			      (LPTHREAD_START_ROUTINE) Subprocess,
			      (LPVOID) new_argv,
			      (DWORD) 0,
			      &pid);
    }

    XFASTINT (XPROCESS (process)->pid) = pid;
    memset (&Pipe[inchannel].oOverlap, 0, sizeof (OVERLAPPED));
    Pipe[inchannel].oOverlap.hEvent = hWaitObject[inchannel];

    {
      int try_count = 0;
      OVERLAPPED overlap;
      DWORD dErr;

    try_again:
      ConnectNamedPipe (Pipe[inchannel].hPipeInst, &Pipe[inchannel].oOverlap);
      dErr = GetLastError ();
      if (dErr == ERROR_PIPE_CONNECTED)
	{
	  SetEvent (Pipe[inchannel].oOverlap.hEvent);
	  Pipe[inchannel].fPendingIO = 0;
	}
      else if (dErr == ERROR_IO_PENDING)
	{
	  if (try_count < 10)
	    {
	      try_count++;
	      _sleep (300);
	      goto try_again;
	    }
	  else
	    {
	      TerminateThread (hThread, 0);
	      CloseHandle (Pipe[inchannel].hPipeInst);
	      error ("Failing to connect named pipe.");
	    }
	}
      else
	error ("Fatal error on connecting to named.pipe.");
    }
  }

  return;
}

#else /* not WIN32 */

void
create_process (Lisp_Object process, char **new_argv)
{
  int pid, inchannel, outchannel, forkin, forkout;
  int sv[2];
#ifdef SIGCHLD
  int (*sigchld)();
#endif
  char **env;
  int pty_flag = 0;
  extern char **environ;

#ifdef MAINTAIN_ENVIRONMENT
  env = (char **) alloca (size_of_current_environ ());
  get_current_environ (env);
#else
  env = environ;
#endif /* MAINTAIN_ENVIRONMENT */

  inchannel = outchannel = -1;

#ifdef HAVE_PTYS
  if (EQ (Vprocess_connection_type, Qt))
#ifdef DECOSF
/* use osf pty support for more pty channels */
    openpty(&outchannel,&inchannel,pty_name,0,0);
    close(inchannel);
    setup_pty(outchannel);
    inchannel = outchannel;
#else /* not DEC OSF/1  */
    outchannel = inchannel = allocate_pty ();
#endif /* DECOSF */
  if (inchannel >= 0)
    {
#ifndef USG
      /* On USG systems it does not work to open
	 the pty's tty here and then close and reopen it in the child.  */
#ifdef O_NOCTTY
      /* Don't let this terminal become our controlling terminal
	 (in case we don't have one).  */
      forkout = forkin = open (pty_name, O_RDWR | O_NOCTTY, 0);
#else
      forkout = forkin = open (pty_name, O_RDWR, 0);
#endif
      if (forkin < 0)
	report_file_error ("Opening pty", Qnil);
#else
      forkin = forkout = -1;
#endif
      pty_flag = 1;
    }
  else
#endif /* HAVE_PTYS */
#ifdef SKTPAIR
    {
      if (socketpair (AF_UNIX, SOCK_STREAM, 0, sv) < 0)
	report_file_error ("Opening socketpair", Qnil);
      outchannel = inchannel = sv[0];
      forkout = forkin = sv[1];
    }
#else /* not SKTPAIR */
    {
      int temp;
      temp = pipe (sv);
      if (temp < 0) goto io_failure;
      inchannel = sv[0];
      forkout = sv[1];
      temp = pipe (sv);
      if (temp < 0) goto io_failure;
      outchannel = sv[1];
      forkin = sv[0];
    }
#endif /* not SKTPAIR */

#if 0
  /* Replaced by close_process_descs */
  set_exclusive_use (inchannel);
  set_exclusive_use (outchannel);
#endif

/* Stride people say it's a mystery why this is needed
   as well as the O_NDELAY, but that it fails without this.  */
#if defined (STRIDE) || (defined (pfa) && defined (HAVE_PTYS))
  {
    int one = 1;
    ioctl (inchannel, FIONBIO, &one);
  }
#endif

#ifdef O_NONBLOCK
  fcntl (inchannel, F_SETFL, O_NONBLOCK);
#else
#ifdef O_NDELAY
  fcntl (inchannel, F_SETFL, O_NDELAY);
#endif
#endif

  XFASTINT (XPROCESS (process)->infd) = inchannel;
  XFASTINT (XPROCESS (process)->outfd) = outchannel;
  /* Record the tty descriptor used in the subprocess.  */
#ifdef SYSV4_PTYS
  /* On system V.4, if using a pty, we need to keep a descriptor
     for the tty that the inferior uses, in order to get the pgrp.
     If this uses too many descriptors, we could instead save the tty name
     and reopen it to send signals.  */
  if (pty_flag)
    {
      int temp = dup (forkin);
      if (temp < 0) goto io_failure;
      XFASTINT (XPROCESS (process)->subtty) = temp;
    }
  else
#endif
    XPROCESS (process)->subtty = Qnil;
/* 92.1.21, 92.9.11, 92.9.30 by K.Handa */
  encode_code(XPROCESS (process)->incode, &in_state[inchannel]);
  encode_code(XPROCESS (process)->outcode, &out_state[outchannel]);
  CODE_CNTL(&out_state[outchannel]) |= CC_END;
/* end of patch */
  XPROCESS (process)->pty_flag = (pty_flag ? Qt : Qnil);
  XPROCESS (process)->status = Qrun;
  /* Record this as an active process, with its channels.
     As a result, child_setup will close Emacs's side of the pipes.  */
  chan_process[inchannel] = process;

  /* Delay interrupts until we have a chance to store
     the new fork's pid in its process structure */
#ifdef SIGCHLD
#ifdef BSD4_1
  sighold (SIGCHLD);
#else /* not BSD4_1 */
#ifdef HPUX
  sigsetmask (sigmask (SIGCHLD));
#else /* not HPUX */
#if defined (BSD) || defined (UNIPLUS)
  sigsetmask (sigmask (SIGCHLD));
#else /* ordinary USG */
#if 0
  sigchld_deferred = 0;
  sigchld = (int (*)()) signal (SIGCHLD, create_process_sigchld);
#endif
#endif /* ordinary USG */
#endif /* not HPUX */
#endif /* not BSD4_1 */
#endif /* SIGCHLD */

  /* Until we store the proper pid, enable sigchld_handler
     to recognize an unknown pid as standing for this process.  */
  XSETINT (XPROCESS (process)->pid, -1);
  /* Turn on the bit for our input from this process now,
     so that even if the process terminates very soon,
     we can clear the bit properly on termination.
     If fork fails, remove_process will clear the bit.  */
  FD_SET (inchannel, &input_wait_mask);

  {
    /* child_setup must clobber environ on systems with true vfork.
       Protect it from permanent change.  */
    char **save_environ = environ;

    pid = vfork ();
    if (pid == 0)
      {
	int xforkin = forkin;
	int xforkout = forkout;

#if 0 /* This was probably a mistake--it duplicates code later on,
	 but fails to handle all the cases.  */
	/* Make SIGCHLD work again in the child.  */
	sigsetmask (SIGEMPTYMASK);
#endif

	/* Make the pty be the controlling terminal of the process.  */
#ifdef HAVE_PTYS
	/* First, disconnect its current controlling terminal.  */
#ifdef HAVE_SETSID
	setsid ();
#ifdef TIOCSCTTY
#ifndef linux			/* 93.7.17 by S.Komeda */
	/* Make the pty's terminal the controlling terminal.  */
	if (pty_flag)
          ioctl (xforkin, TIOCSCTTY, 0);  /* ignore errors for linux */
#endif
#endif
#else /* not HAVE_SETSID */
#ifdef USG
	/* It's very important to call setpgrp() here and no time
	   afterwards.  Otherwise, we lose our controlling tty which
	   is set when we open the pty. */
	setpgrp ();
#endif /* USG */
#endif /* not HAVE_SETSID */
#ifdef TIOCNOTTY
	/* In 4.3BSD, the TIOCSPGRP bug has been fixed, and now you
	   can do TIOCSPGRP only to the process's controlling tty.  */
	if (pty_flag)
	  {
	    /* I wonder: would just ioctl (0, TIOCNOTTY, 0) work here? 
	       I can't test it since I don't have 4.3.  */
	    int j = open ("/dev/tty", O_RDWR, 0);
	    ioctl (j, TIOCNOTTY, 0);
	    close (j);
#ifndef USG
	    /* In order to get a controlling terminal on some versions
	       of BSD, it is necessary to put the process in pgrp 0
	       before it opens the terminal.  */
	    setpgrp (0, 0);
#endif
	  }
#endif /* TIOCNOTTY */
#ifdef DECOSF
#ifdef TIOCSCTTY
	ioctl (xforkin, TIOCSCTTY, 0);
#endif
#endif

#if !defined (RTU) && !defined (UNIPLUS)
/*** There is a suggestion that this ought to be a
     conditional on TIOCSPGRP.  */
	/* Now close the pty (if we had it open) and reopen it.
	   This makes the pty the controlling terminal of the subprocess.  */
	if (pty_flag)
	  {
	    /* I wonder if close (open (pty_name, ...)) would work?  */
	    if (xforkin >= 0)
	      close (xforkin);
	    xforkout = xforkin = open (pty_name, O_RDWR, 0);

	    if (xforkin < 0)
	      abort ();
	  }
#endif /* not UNIPLUS and not RTU */
#ifdef SETUP_SLAVE_PTY
	if (pty_flag)
	  {
	    SETUP_SLAVE_PTY;
	  }
#endif /* SETUP_SLAVE_PTY */
#ifdef AIX
	/* On AIX, we've disabled SIGHUP above once we start a child on a pty.
	   Now reenable it in the child, so it will die when we want it to.  */
	if (pty_flag)
	  signal (SIGHUP, SIG_DFL);
#endif
#endif /* HAVE_PTYS */
#ifdef SIGCHLD
#ifdef BSD4_1
	sigrelse (SIGCHLD);
#else /* not BSD4_1 */
#if defined (BSD) || defined (UNIPLUS) || defined (HPUX)
	sigsetmask (SIGEMPTYMASK);
#else /* ordinary USG */
#if 0
	signal (SIGCHLD, sigchld);
#endif
#endif /* ordinary USG */
#endif /* not BSD4_1 */
#endif /* SIGCHLD */
	if (pty_flag)
	  child_setup_tty (xforkout);
	child_setup (xforkin, xforkout, xforkout, new_argv, env);
      }
    environ = save_environ;
  }

  if (pid < 0)
    {
      remove_process (process);
      report_file_error ("Doing vfork", Qnil);
    }

  XFASTINT (XPROCESS (process)->pid) = pid;

  /* If the subfork execv fails, and it exits,
     this close hangs.  I don't know why.
     So have an interrupt jar it loose.  */
  stop_polling ();
  signal (SIGALRM, create_process_1);
  alarm (1);
  if (forkin >= 0)
    close (forkin);
  alarm (0);
  start_polling ();
  if (forkin != forkout && forkout >= 0)
    close (forkout);

#ifdef SIGCHLD
#ifdef BSD4_1
  sigrelse (SIGCHLD);
#else /* not BSD4_1 */
#if defined (BSD) || defined (UNIPLUS) || defined (HPUX)
  sigsetmask (SIGEMPTYMASK);
#else /* ordinary USG */
#if 0
  signal (SIGCHLD, sigchld);
  /* Now really handle any of these signals
     that came in during this function.  */
  if (sigchld_deferred)
    kill (getpid (), SIGCHLD);
#endif
#endif /* ordinary USG */
#endif /* not BSD4_1 */
#endif /* SIGCHLD */
  return;

io_failure:
  {
    int temp = errno;
    close (forkin);
    close (forkout);
    close (inchannel);
    close (outchannel);
    errno = temp;
    report_file_error ("Opening pty or pipe", Qnil);
  }
}
#endif /* not WIN32 */

#ifdef HAVE_SOCKETS

/* open a TCP network connection to a given HOST/SERVICE.  Treated
   exactly like a normal process when reading and writing.  Only
   differences are in status display and process deletion.  A network
   connection has no PID; you cannot signal it.  All you can do is
   deactivate and close it via delete-process */

DEFUN ("si:open-network-stream", Fsi_open_network_stream, Ssi_open_network_stream, 
       6, MANY, 0, 
  "Open a TCP connection for a service to a host.\n\
Returns a subprocess-object to represent the connection.\n\
Input and output work as for subprocesses; `delete-process' closes it.\n\
Args are NAME BUFFER HOST SERVICE INCODE OUTCODE.\n\
NAME is name for process.  It is modified if necessary to make it unique.\n\
BUFFER is the buffer (or buffer-name) to associate with the process.\n\
 Process output goes at end of that buffer, unless you specify\n\
 an output stream or filter function to handle the output.\n\
 BUFFER may be also nil, meaning that this process is not associated\n\
 with any buffer\n\
Third arg is name of the host to connect to.\n\
Fourth arg SERVICE is name of the service desired, or an integer\n\
 specifying a port number to connect to.\n\
INCODE and OUTCODE specify the coding-system objects used in input/output\n\
 from/to the process.")
  (int nargs, Lisp_Object *args)		/* 91.10.19 by K.Handa */
{
  Lisp_Object name, buffer, host, service;
  Lisp_Object incode, outcode;
  Lisp_Object proc;
  register int i;
  struct sockaddr_in address;
  struct servent *svc_info;
  struct hostent *host_info;
  int s, outch, inch;
  char errstring[80];
  int port;
  struct gcpro gcpro1, gcpro2, gcpro3, gcpro4;

  name = args[0]; buffer = args[1]; host = args[2]; service = args[3];
  GCPRO4 (name, buffer, host, service);
  CHECK_STRING (name, 0);
  CHECK_STRING (host, 0);
  incode = Fcheck_code(args[4]);
  outcode = Fcheck_code(args[5]);
  if (XTYPE (service) == Lisp_Int)
    port = htons ((unsigned short) XINT (service));
  else
    {
      CHECK_STRING (service, 0);
      svc_info = getservbyname (XSTRING (service)->data, "tcp");
      if (svc_info == 0)
#ifdef WIN32
	error ("Unknown service \"%s\" (%d)",
	       XSTRING (service)->data, WSAGetLastError ());
#else
	error ("Unknown service \"%s\"", XSTRING (service)->data);
#endif
      port = svc_info->s_port;
    }

  bzero (&address, sizeof address);
  address.sin_addr.s_addr = inet_addr (XSTRING (host)->data);
  if (address.sin_addr.s_addr != -1)
    address.sin_family = AF_INET;
  else
    {
      host_info = gethostbyname (XSTRING (host)->data);
      if (host_info == 0)
	error ("Unknown host \"%s\"", XSTRING (host)->data);
      bcopy (host_info->h_addr, (char *) &address.sin_addr, host_info->h_length);
      address.sin_family = host_info->h_addrtype;
    }
  address.sin_port = port;

  s = socket (address.sin_family, SOCK_STREAM, 0);
  if (s < 0) 
    report_file_error ("error creating socket", Fcons (name, Qnil));

  /* Kernel bugs (on Ultrix at least) cause lossage (not just EINTR)
     when connect is interrupted.  So let's not let it get interrupted.  */
  if (interrupt_input)
    unrequest_sigio ();
  stop_polling ();

  while (1)
    {
      int value = connect (s, (struct sockaddr *)&address, sizeof address);
      /* Continue if successeful.  */
      if (value != -1)
	break;
      /* Report a "real" error.  */
      if (errno != EINTR)
	{
#ifdef WIN32 /* 93.2.25 by M.Higashida */
          closesocket (s);
#else
	  close (s);
#endif
	  error ("Host \"%s\" not responding", XSTRING (host)->data);
	}
      /* Loop around after temporary error.  */
    }

  if (interrupt_input)
    request_sigio ();
  start_polling ();

  inch = s;
#ifdef WIN32 /* 93.2.17 by M.Higashida */
  outch = s;
#else
  outch = dup (s);
#endif
  if (outch < 0) 
    report_file_error ("error duplicating socket", Fcons (name, Qnil));

  if (!NILP (buffer))
    buffer = Fget_buffer_create (buffer);
  proc = make_process (name);

#ifdef WIN32
  {
    int channel = open_channel (&socket_descs);
    if (channel < 0) {
      closesocket (s);
      error ("Too many sockets.");
    }
    inch = outch = channel + 32;
    Pipe[inch].hPipeInst = (HANDLE) s;
    FD_SET (s, &socket_wait_mask);
    num_sockets++;
  }
  chan_process[inch] = proc;
  {
    int one = 1;
    ioctlsocket (s, FIONBIO, &one);
  }
#else /* not WIN32 */
  chan_process[inch] = proc;

#ifdef O_NONBLOCK
  fcntl (inch, F_SETFL, O_NONBLOCK);
#else
#ifdef O_NDELAY
  fcntl (inch, F_SETFL, O_NDELAY);
#endif
#endif
#endif /* not WIN32 */

  XPROCESS (proc)->childp = host;
  XPROCESS (proc)->command_channel_p = Qnil;
  XPROCESS (proc)->buffer = buffer;
  XPROCESS (proc)->sentinel = Qnil;
  XPROCESS (proc)->filter = Qnil;
  XPROCESS (proc)->command = Qnil;
  XPROCESS (proc)->pid = Qnil;
  XPROCESS (proc)->kill_without_query = Qt;
#ifdef WIN32
  XFASTINT (XPROCESS (proc)->infd) = inch;
#else
  XFASTINT (XPROCESS (proc)->infd) = s;
#endif
  XFASTINT (XPROCESS (proc)->outfd) = outch;
  XPROCESS (proc)->status = Qrun;
/* 92.1.21, 92.9.11 by K.Handa */
  XPROCESS (proc)->incode = incode;
  XPROCESS (proc)->outcode = outcode;
  encode_code(incode, &in_state[inch]);
  encode_code(outcode, &out_state[outch]);
  CODE_CNTL(&out_state[outch]) |= CC_END;
/* end of patch */

  FD_SET (inch, &input_wait_mask);

  UNGCPRO;
  return proc;
}
/* 93.4.16 by K.Handa */
DEFUN ("open-network-stream", Fopen_network_stream, Sopen_network_stream, 
       6, MANY, 0, "")
  (int nargs, Lisp_Object *args)		/* 91.10.19 by K.Handa */
{
  return Fsi_open_network_stream (nargs, args);
}
/* end of patch */

#endif	/* HAVE_SOCKETS */

void
deactivate_process (Lisp_Object proc)
{
  register int inchannel, outchannel;
  register struct Lisp_Process *p = XPROCESS (proc);

  inchannel = XFASTINT (p->infd);
  outchannel = XFASTINT (p->outfd);

  if (inchannel)
    {
      /* Beware SIGCHLD hereabouts. */
      flush_pending_output (inchannel);
#ifdef WIN32 /* 93.2.25 by M.Higashida */
      if (inchannel < 32)
	{
	  ResetEvent (hWaitObject[inchannel]);
	  CloseHandle (Pipe[inchannel].hPipeInst);
	  close_channel (&named_pipe_descs, inchannel);
	}
      else
	{
	  ResetEvent (hWaitObject[inchannel]);
	  FD_CLR ((int) Pipe[inchannel].hPipeInst, &socket_wait_mask);
	  closesocket ((int) Pipe[inchannel].hPipeInst);
	  close_channel (&socket_descs, inchannel);
	  num_sockets--;
	}
#else
      close (inchannel);
      if (outchannel  &&  outchannel != inchannel)
 	close (outchannel);
#endif

      XFASTINT (p->infd) = 0;
      XFASTINT (p->outfd) = 0;
      chan_process[inchannel] = Qnil;
      FD_CLR (inchannel, &input_wait_mask);
    }
}

/* Close all descriptors currently in use for communication
   with subprocess.  This is used in a newly-forked subprocess
   to get rid of irrelevant descriptors.  */

void
close_process_descs (void)
{
  int i;
  for (i = 0; i < MAXDESC; i++)
    {
      Lisp_Object process;
      process = chan_process[i];
      if (!NILP (process))
	{
	  int in = XFASTINT (XPROCESS (process)->infd);
	  int out = XFASTINT (XPROCESS (process)->outfd);

	  if (in != 0)
	    close (in);
	  if (out != 0 && out != in)
	    close (out);
	  if (!NILP (XPROCESS (process)->subtty))
	    close (XFASTINT (XPROCESS (process)->subtty));
	}
    }
}

DEFUN ("accept-process-output", Faccept_process_output, Saccept_process_output,
  0, 1, 0,
  "Allow any pending output from subprocesses to be read by Emacs.\n\
It is read into the process' buffers or given to their filter functions.\n\
Non-nil arg PROCESS means do not return until some output has been received\n\
from PROCESS.")
  (register Lisp_Object proc)
{
  if (NILP (proc))
    wait_reading_process_input (-1, 0, 0);
  else
    {
      proc = get_process (proc);
      wait_reading_process_input (0, XPROCESS (proc), 0);
    }
  return Qnil;
}

/* This variable is different from waiting_for_input in keyboard.c.
   It is used to communicate to a lisp process-filter/sentinel (via the
   function Fwaiting_for_user_input_p below) whether emacs was waiting
   for user-input when that process-filter was called.
   waiting_for_input cannot be used as that is by definition 0 when
   lisp code is being evalled */
static int waiting_for_user_input_p;

/* Read and dispose of subprocess output
 while waiting for timeout to elapse and/or keyboard input to be available.

 time_limit is the timeout in seconds, or zero for no limit.
 -1 means gobble data available immediately but don't wait for any.

 read_kbd is 1 to return when input is available.
 -1 means caller will actually read the input.
 A pointer to a struct Lisp_Process means wait until
 something arrives from that process.

 do_display means redisplay should be done to show
 subprocess output that arrives.  */

void
wait_reading_process_input (int time_limit, Lisp_Object_Int read_kbd, int do_display)
{
  register int channel, nfds, m;
  SELECT_TYPE Available;
  SELECT_TYPE Exception;
  int xerrno;
  Lisp_Object proc;
#ifdef HAVE_TIMEVAL
  struct timeval timeout, end_time;
  struct timezone garbage;
#else
  time_t timeout, end_time, temp;
#endif /* not HAVE_TIMEVAL */
  SELECT_TYPE Atemp;
  int wait_channel = 0;
  struct Lisp_Process *wait_proc = 0;

  /* Detect when read_kbd is really the address of a Lisp_Process.  */
  if (read_kbd > 10 || read_kbd < -1)
    {
      wait_proc = (struct Lisp_Process *) read_kbd;
      wait_channel = XFASTINT (wait_proc->infd);
      read_kbd = 0;
    }
  waiting_for_user_input_p = read_kbd;

  /* Since we may need to wait several times,
     compute the absolute time to return at.  */
  if (time_limit)
    {
#ifdef HAVE_TIMEVAL
      gettimeofday (&end_time, &garbage);
      end_time.tv_sec += time_limit;
#else /* not HAVE_TIMEVAL */
      time (&end_time);
      end_time += time_limit;
#endif /* not HAVE_TIMEVAL */
    }

#if 0  /* Select emulator claims to preserve alarms.
	  And there are many ways to get out of this function by longjmp.  */
  /* Turn off periodic alarms (in case they are in use)
     because the select emulator uses alarms.  */
  stop_polling ();
#endif

  while (1)
    {
      /* If calling from keyboard input, do not quit
	 since we want to return C-g as an input character.
	 Otherwise, do pending quit if requested.  */
      if (read_kbd >= 0)
	{
#if 0
	  /* This is the same condition tested by QUIT.
	     We need to resume polling if we are going to quit.  */
	  if (!NILP (Vquit_flag) && NILP (Vinhibit_quit))
	    {
	      start_polling ();
	      QUIT;
	    }
#endif
	  QUIT;
	}

      /* If status of something has changed, and no input is available,
	 notify the user of the change right away */
      if (update_tick != process_tick && do_display)
	{
	  Atemp = input_wait_mask;
#ifdef HAVE_TIMEVAL
	  timeout.tv_sec=0; timeout.tv_usec=0;
#else /* not HAVE_TIMEVAL */
	  timeout = 0;
#endif /* not HAVE_TIMEVAL */
	  if (select (MAXDESC, &Atemp, 0, 0, &timeout) <= 0)
	    status_notify ();
	}

      /* Don't wait for output from a non-running process.  */
      if (wait_proc != 0 && !NILP (wait_proc->raw_status_low))
	update_status (wait_proc);
      if (wait_proc != 0
	  && ! EQ (wait_proc->status, Qrun))
	break;

      if (fix_screen_hook)
	(*fix_screen_hook) ();

      /* Compute time from now till when time limit is up */
      /* Exit if already run out */
      if (time_limit == -1)
	{
	  /* -1 specified for timeout means
	     gobble output available now
	     but don't wait at all. */
#ifdef HAVE_TIMEVAL
	  timeout.tv_sec = 0;
	  timeout.tv_usec = 0;
#else
	  timeout = 0;
#endif /* not HAVE_TIMEVAL */
	}
      else if (time_limit)
	{
#ifdef HAVE_TIMEVAL
	  gettimeofday (&timeout, &garbage);

	  /* In effect, timeout = end_time - timeout.
	     Break if result would be negative.  */
	  if (timeval_subtract (&timeout, end_time, timeout))
	    break;
#else /* not HAVE_TIMEVAL */
          time (&temp);
	  timeout = end_time - temp;
	  if (timeout < 0)
	    break;
#endif /* not HAVE_TIMEVAL */
	}
      else
	{
#ifdef HAVE_TIMEVAL
	  /* If no real timeout, loop sleeping with a big timeout
	     so that input interrupt can wake us up by zeroing it  */
	  timeout.tv_sec = 100;
	  timeout.tv_usec = 0;
#else /* not HAVE_TIMEVAL */
          timeout = 100000;	/* 100000 recognized by the select emulator */
#endif /* not HAVE_TIMEVAL */
	}

      /* Cause quitting and alarm signals to take immediate action,
	 and cause input available signals to zero out timeout */
      if (read_kbd < 0)
#ifdef HAVE_TIMEVAL
	set_waiting_for_input (&timeout.tv_sec);
#else
	set_waiting_for_input (&timeout);
#endif

      /* Wait till there is something to do */

      Available = Exception = input_wait_mask;
#ifdef WIN32 /* 93.2.25 by M.Higashida */
      {
	if (!read_kbd) {
	  FD_CLR (0, &Available);
	  ResetEvent (hWaitObject[0]);
	}

	if (read_kbd && kbd_count)
	  nfds = 0;
	else
	  {
	    int wait
	      = WaitForMultipleObjects (MAXDESC, hWaitObject, 0,
					timeout.tv_sec ?
					  timeout.tv_sec * 1000 : 0);

	    switch (wait) {
	    case WAIT_TIMEOUT:
	      nfds = 0;
	      FD_ZERO (&Available);
	      break;
	    case WAIT_OBJECT_0 + 0:
	      ResetEvent (hWaitObject[0]);
	    default:
	      if (FD_ISSET (wait, &Available)) {
		nfds = 1;
	      } else {
	        FD_ZERO (&Available);
		nfds = 0;
	      }
	    }
	  }
      }
#else /* not WIN32 */
      if (!read_kbd)
	FD_CLR (0, &Available);

      if (read_kbd && kbd_count)
	nfds = 0;
      else
	/* Since we don't do anything abt Exceptions,
	   let's notw wake up for them.  */
	nfds = select (MAXDESC, &Available, 0, 0, &timeout);
#if 0
#ifdef IBMRTAIX
	nfds = select (MAXDESC, &Available, 0, 0, &timeout);
#else
#ifdef HPUX
	nfds = select (MAXDESC, &Available, 0, 0, &timeout);
#else
	nfds = select (MAXDESC, &Available, 0, &Exception, &timeout);
#endif
#endif
#endif /* 0 */
      xerrno = errno;
#endif /* not WIN32 */

      if (fix_screen_hook)
	(*fix_screen_hook) ();

      /* Make C-g and alarm signals set flags again */
      clear_waiting_for_input ();

      /* If we woke up due to SIGWINCH, actually change size now.  */
      if (read_kbd)
	do_pending_window_change ();

      if (time_limit && nfds == 0)	/* timeout elapsed */
	break;
      if (nfds < 0)
	{
#ifdef WIN32 /* 93.2.17 by M.Higashida */
	  error("select error: %d", xerrno);
#else /* not WIN32 */
	  if (xerrno == EINTR)
	    FD_ZERO (&Available);
#ifdef ALLIANT
	  /* This happens for no known reason on ALLIANT.
	     I am guessing that this is the right response. -- RMS.  */
	  else if (xerrno == EFAULT)
	    FD_ZERO (&Available);
#endif
	  else if (xerrno == EBADF)
#ifdef AIX
	  /* AIX will return EBADF on a call to select involving a ptc if the
	     associated pts isn't open.  Since this will only happen just as
	     a child is dying, just ignore the situation -- SIGCHLD will come
	     along quite quickly, and after cleanup the ptc will no longer be
	     checked, so this error will stop recurring.  */
	    FD_ZERO (&Available);     /* Cannot depend on values returned.  */
#else /* not AIX */
	    abort ();
#endif /* not AIX */
	  else
	    error("select error: %s", err_str(xerrno));
#endif /* not WIN32 */
	}
#ifdef SIGIO
#if defined (sun) || defined (APOLLO)
      else if (nfds > 0 && FD_ISSET (0, &Available) && interrupt_input)
	/* System sometimes fails to deliver SIGIO.  */
	kill (getpid (), SIGIO);
#endif
#endif

      /* Check for keyboard input */
      /* If there is any, return immediately
	 to give it higher priority than subprocesses */

      if (read_kbd && detect_input_pending ())
	break;

      /* If checking input just got us a size-change event from X,
	 obey it now if we should.  */
      if (read_kbd)
	do_pending_window_change ();

      /* If screen size has changed, redisplay now
	 for either sit-for or keyboard input.  */
      if (read_kbd && screen_garbaged)
	redisplay_preserve_echo_area ();

#ifdef vipc
      /* Check for connection from other process */

      if (FD_ISSET (comm_server, &Available))
	{
	  FD_CLR (comm_server, &Available);
	  create_commchan ();
	}
#endif /* vipc */

      /* Check for data from a process or a command channel */

      for (channel = 3; channel < MAXDESC; channel++)
	{
	  if (FD_ISSET (channel, &Available))
	    {
	      int nread;

	      FD_CLR (channel, &Available);
	      /* If waiting for this channel,
		 arrange to return as soon as no more input
		 to be processed.  No more waiting.  */
	      if (wait_channel == channel)
		{
		  wait_channel = 0;
		  time_limit = -1;
		}
	      proc = chan_process[channel];
	      if (NILP (proc))
		continue;

#ifdef vipc
	      /* It's a command channel */
	      if (!NILP (XPROCESS (proc)->command_channel_p))
		{
		  ProcessCommChan (channel, proc);
		  if (NILP (XPROCESS (proc)->command_channel_p))
		    {
		      /* It has ceased to be a command channel! */
		      int bytes_available;
		      if (ioctl (channel, FIONREAD, &bytes_available) < 0)
			bytes_available = 0;
		      if (bytes_available)
			FD_SET (channel, &Available);
		    }
		  continue;
		}
#endif /* vipc */

	      /* Read data from the process, starting with our
		 buffered-ahead character if we have one.  */

	      nread = read_process_output (proc, channel);
	      if (nread > 0)
		{
		  /* Since read_process_output can run a filter,
		     which can call accept-process-output,
		     don't try to read from any other processes
		     before doing the select again.  */
		  FD_ZERO (&Available);

		  if (do_display)
		    redisplay_preserve_echo_area ();
		}
#ifdef EWOULDBLOCK
	      else if (nread == -1 && errno == EWOULDBLOCK)
		;
#else
#ifdef O_NONBLOCK
	      else if (nread == -1 && errno == EAGAIN)
		;
#else
#ifdef O_NDELAY
	      else if (nread == -1 && errno == EAGAIN)
		;
	      /* Note that we cannot distinguish between no input
		 available now and a closed pipe.
		 With luck, a closed pipe will be accompanied by
		 subprocess termination and SIGCHLD.  */
	      else if (nread == 0 && !NETCONN_P (proc))
		;
#endif /* O_NDELAY */
#endif /* O_NONBLOCK */
#endif /* EWOULDBLOCK */
#ifdef HAVE_PTYS
	      /* On some OSs with ptys, when the process on one end of
		 a pty exits, the other end gets an error reading with
		 errno = EIO instead of getting an EOF (0 bytes read).
		 Therefore, if we get an error reading and errno =
		 EIO, just continue, because the child process has
		 exited and should clean itself up soon (e.g. when we
		 get a SIGCHLD). */
	      else if (nread == -1 && errno == EIO && !NETCONN_P (proc))
		;
#endif /* HAVE_PTYS */
/* If we can detect process termination, don't consider the process
   gone just because its pipe is closed.  */
#ifdef SIGCHLD
	      else if (nread == 0 && !NETCONN_P (proc))
		;
#endif
	      else
		{
		  /* Preserve status of processes already terminated.  */
		  XSETINT (XPROCESS (proc)->tick, ++process_tick);
		  deactivate_process (proc);
		  if (!NILP (XPROCESS (proc)->raw_status_low))
		    update_status (XPROCESS (proc));
		  if (EQ (XPROCESS (proc)->status, Qrun))
		    XPROCESS (proc)->status
		      = Fcons (Qexit, Fcons (make_number (256), Qnil));
		}
	    }
	} /* end for */
    } /* end while */

  /* If calling from keyboard input, do not quit
     since we want to return C-g as an input character.
     Otherwise, do pending quit if requested.  */
  if (read_kbd >= 0)
    {
      /* Prevent input_pending from remaining set if we quit.  */
      clear_input_pending ();
      QUIT;
    }
}

/* Actually call the filter.  This gets the information via variables
   because internal_condition_case won't pass arguments.  */

Lisp_Object
run_filter (void)
{
  return call2 (this_filter, filter_process, filter_string);
}

/* Read pending output from the process channel,
   starting with our buffered-ahead character if we have one.
   Yield number of characters read.

   This function reads at most 1024 characters.
   If you want to read all available subprocess output,
   you must call it repeatedly until it returns zero.  */

#ifdef WIN32
int
win32_read (int channel, char *chars, int num_chars)
{
  int numRead = 0;

  if (!Pipe[channel].fPendingIO)
    {
      if (!ReadFile (Pipe[channel].hPipeInst,
		     Pipe[channel].buf, PIPE_BUFSIZ, &numRead,
		     &Pipe[channel].oOverlap))
	{
	  if (GetLastError () == ERROR_IO_PENDING)
	    {
	      Pipe[channel].fPendingIO = 1;
	      errno = EWOULDBLOCK;
	      return -1;
	    }
	  else
	    return 0;
	}
    }
  else
    {
      if (!GetOverlappedResult (Pipe[channel].hPipeInst,
				&Pipe[channel].oOverlap,
				&numRead, 0))
	{
	  if (GetLastError () == ERROR_IO_INCOMPLETE)
	    {
	      /* still pending... */
	      errno = EWOULDBLOCK;
	      return -1;
	    }
	  else
	    return 0;
	}
    }
  
  SetEvent (hWaitObject[channel]);
  Pipe[channel].fPendingIO = 0;
  strncpy (chars, Pipe[channel].buf, numRead);
  chars[numRead] = '\0';
  return numRead;
}

int
win32_write (int handle, char *buf, int numWrite, int *numWritten)
{
  OVERLAPPED Overlapped;
  HANDLE  EventHandle;

  EventHandle = CreateEvent (0, 1, 0, 0);
  if (EventHandle == 0) return 0;
  
  Overlapped.hEvent = EventHandle;

  if (WriteFile (handle, buf, numWrite, numWritten, &Overlapped)) {
    CloseHandle (EventHandle);
  } else {
    int result;
      
    if (GetLastError () != ERROR_IO_PENDING) {
      CloseHandle (EventHandle);
      return 0;
    }

    if (WaitForSingleObject (EventHandle, 60 /* INFINITE */) != 0) {
      CloseHandle (EventHandle);
      errno = EWOULDBLOCK;
      return -1;
    }

    result = GetOverlappedResult(handle, &Overlapped, numWritten, 0);
    CloseHandle (EventHandle);
    
    if (!result) {
      errno = EWOULDBLOCK;
      return -1;
    }
  }
  
  return 1;
}

#endif

int
read_process_output (Lisp_Object proc, register int channel)
{
  register int nchars, nchars2;	/* 91.10.28 by K.Handa */
  char chars[1024], *chars2;	/* 91.10.28 by K.Handa */
  Lisp_Object found_code = Qnil; /* 92.2.20 by K.Handa */
  register Lisp_Object outstream;
  register struct buffer *old = current_buffer;
  register struct Lisp_Process *p = XPROCESS (proc);
  register int opoint;

  if (proc_buffered_char[channel] < 0)
#ifdef WIN32 /* 93.2.17 by M.Higashida */
    if (channel < 32)
      {
	nchars = win32_read (channel, chars, sizeof chars);
      }
    else
      {
	ResetEvent (hWaitObject[channel]);
	EnterCriticalSection (&SocketCliticalSection);
	nchars = recv ((int) Pipe[channel].hPipeInst, chars, sizeof chars, 0);
	LeaveCriticalSection (&SocketCliticalSection);
	errno = h_errno;
      }
#else
    nchars = read (channel, chars, sizeof chars);
#endif
  else
    {
      chars[0] = proc_buffered_char[channel];
      proc_buffered_char[channel] = -1;
#ifdef WIN32 /* 93.2.17 by M.Higashida */
      if (channel < 32)
	{
	  nchars = win32_read (channel, chars + 1, sizeof chars - 1);
	}
      else
        {
          ResetEvent (hWaitObject[channel]);
	  EnterCriticalSection (&SocketCliticalSection);
	  nchars = recv ((int) Pipe[channel].hPipeInst, 
		         chars + 1, sizeof chars - 1, 0);
	  LeaveCriticalSection (&SocketCliticalSection);
	  errno = h_errno;
	}
#else
      nchars = read (channel, chars + 1, sizeof chars - 1);
#endif
      if (nchars < 0)
	nchars = 1;
      else
	nchars = nchars + 1;
    }

  if (nchars <= 0) return nchars;

/* 91.10.28 by K.Handa */
  if (CODE_TYPE(&in_state[channel]) == AUTOCONV
      || CODE_TYPE(&in_state[channel]) > ITNCODE) {
    chars2 = get_conversion_buffer(nchars, ITNCODE); /* 93.2.10 by K.Handa */
    nchars2 = encode(&in_state[channel], chars, chars2, nchars, &found_code);
    if (!NILP (found_code)) {
      XPROCESS (proc)->incode = found_code;
      if (NILP (XPROCESS (proc)->outcode)) { /* 92.12.20 by T.Enami */
	int outfd = XFASTINT (XPROCESS (proc)->outfd);

	XPROCESS (proc)->outcode = found_code;
	encode_code(found_code, &out_state[outfd]);
	CODE_CNTL(&out_state[outfd]) |= CC_END;
      }
    }
  } else {
    chars2 = chars; nchars2 = nchars;
  }
  if (nchars2 > 0) {
/* end of patch */
  outstream = p->filter;
  if (!NILP (outstream))
    {
      int count = specpdl_ptr - specpdl;
      specbind (Qinhibit_quit, Qt);
      this_filter = outstream;
      filter_process = proc;
      filter_string = make_string (chars2, nchars2); /* 91.10.28 by K.Handa */
      call2 (this_filter, filter_process, filter_string);
      /*   internal_condition_case (run_filter, Qerror, Fidentity);  */

      return unbind_to (count, nchars);
    }

  /* If no filter, write into buffer if it isn't dead.  */
  if (!NILP (p->buffer) && !NILP (XBUFFER (p->buffer)->name))
    {
      Lisp_Object tem;

      Fset_buffer (p->buffer);
      opoint = point;

      /* Insert new output into buffer
	 at the current end-of-output marker,
	 thus preserving logical ordering of input and output.  */
      if (XMARKER (p->mark)->buffer)
	SET_PT (marker_position (p->mark));
      else
	SET_PT (ZV);
      if (point <= opoint)
	opoint += nchars2;	/* 91.11.6 by K.Handa */

      tem = current_buffer->read_only;
      current_buffer->read_only = Qnil;
      insert (chars2, nchars2);	/* 91.10.28 by K.Handa */
      current_buffer->read_only = tem;
      Fset_marker (p->mark, make_number (point), p->buffer);
      update_mode_lines++;

      SET_PT (opoint);
      set_buffer_internal (old);
    }
  }				/* 91.10.28 by K.Handa */
  return nchars;
}

DEFUN ("waiting-for-user-input-p", Fwaiting_for_user_input_p, Swaiting_for_user_input_p,
       0, 0, 0,
  "Returns non-NIL if emacs is waiting for input from the user.\n\
This is intended for use by asynchronous process output filters and sentinels.")
       (void)
{
  return ((waiting_for_user_input_p) ? Qt : Qnil);
}

/* Sending data to subprocess */

jmp_buf send_process_frame;

void
send_process_trap (void)
{
#ifndef WIN32 /* 93.2.17 by M.Higashida */
#ifdef BSD4_1
  sigrelse (SIGPIPE);
  sigrelse (SIGALRM);
#endif /* BSD4_1 */
#endif /* not WIN32 */
  longjmp (send_process_frame, 1);
}

void
send_process (Lisp_Object proc, char *buf, int len)
{
  /* Don't use register vars; longjmp can lose them.  */
  int rv;
  unsigned char *procname = XSTRING (XPROCESS (proc)->name)->data;
  char *buf2;			/* 91.10.29 by K.Handa */
   coding_type *mccode		/* 91.10.29, 92.9.11 by K.Handa */
    = &out_state[XFASTINT (XPROCESS (proc)->outfd)]; /* 92.3.24 by T.Enami */

  if (!NILP (XPROCESS (proc)->raw_status_low))
    update_status (XPROCESS (proc));
  if (! EQ (XPROCESS (proc)->status, Qrun))
    error ("Process %s not running", procname);

/* 91.10.29, 92.7.15 by K.Handa, Y.Hirose */
  if (CODE_TYPE(mccode) > ITNCODE) {
    /* 93.2.10 by K.Handa */
    buf2 = get_conversion_buffer(len, CODE_TYPE(mccode));
    len = decode(mccode, buf, buf2, len);
    buf = buf2;
  }
/* end of patch */
#ifdef WIN32 /* 93.2.25 by M.Higashida */
  if (!_setjmp (send_process_frame))
#else
  if (!setjmp (send_process_frame))
#endif
    while (len > 0)
      {
	signal (SIGPIPE, send_process_trap);
#ifdef WIN32 /* 93.2.17 by M.Higashida */
	if (XFASTINT (XPROCESS (proc)->outfd) < 32)
	  {
	    win32_write (Pipe[XFASTINT (XPROCESS (proc)->outfd)].hPipeInst,
			 buf, len, &rv, 0);
	  }
	else
	  {
	    EnterCriticalSection (&SocketCliticalSection);
	    rv = send ((int) Pipe[XFASTINT (XPROCESS (proc)->outfd)].hPipeInst,
		       buf, len, 0);
	    LeaveCriticalSection (&SocketCliticalSection);
	    errno = h_errno;
	  }
#else
	rv = write (XFASTINT (XPROCESS (proc)->outfd), buf, len);
#endif
	signal (SIGPIPE, SIG_DFL);
	if (rv < 0)
	  {
	    if (0
#ifdef EWOULDBLOCK
		|| errno == EWOULDBLOCK
#endif
#ifdef EAGAIN
		|| errno == EAGAIN
#endif
		)
	      {
		/* It would be nice to accept process output here,
		   but that is difficult.  For example, it could
		   garbage what we are sending if that is from a buffer.  */
		immediate_quit = 1;
		QUIT;
		sleep (1);
		immediate_quit = 0;
		continue;
	      }
	    report_file_error ("writing to process", Fcons (proc, Qnil));
	  }
	buf += rv;
	len -= rv;
      }
  else
    {
      XPROCESS (proc)->raw_status_low = Qnil;
      XPROCESS (proc)->raw_status_high = Qnil;
      XPROCESS (proc)->status = Fcons (Qexit, Fcons (make_number (256), Qnil));
      XSETINT (XPROCESS (proc)->tick, ++process_tick);
      deactivate_process (proc);
      error ("SIGPIPE raised on process %s; closed it", procname);
    }
}

DEFUN ("process-send-region", Fprocess_send_region, Sprocess_send_region,
  3, 3, 0,
  "Send current contents of region as input to PROCESS.\n\
PROCESS may be a process name.\n\
Called from program, takes three arguments, PROCESS, START and END.")
  (Lisp_Object process, Lisp_Object start, Lisp_Object end)
{
  Lisp_Object proc;
  int start1;

  proc = get_process (process);
  validate_region (&start, &end);

  if (XINT (start) < GPT && XINT (end) > GPT)
    move_gap (start);

  start1 = XINT (start);
  send_process (proc, &FETCH_CHAR (start1), XINT (end) - XINT (start));

  return Qnil;
}

DEFUN ("process-send-string", Fprocess_send_string, Sprocess_send_string,
  2, 2, 0,
  "Send PROCESS the contents of STRING as input.\n\
PROCESS may be a process name.")
  (Lisp_Object process, Lisp_Object string)
{
  Lisp_Object proc;
  CHECK_STRING (string, 1);
  proc = get_process (process);
  send_process (proc, XSTRING (string)->data, XSTRING (string)->size);
  return Qnil;
}

/* send a signal number SIGNO to PROCESS.
   CURRENT_GROUP means send to the process group that currently owns
   the terminal being used to communicate with PROCESS.
   This is used for various commands in shell mode.
   If NOMSG is zero, insert signal-announcements into process's buffers
   right away.  */

void
process_send_signal (Lisp_Object process, int signo, Lisp_Object current_group, int nomsg)
{
  Lisp_Object proc;
  register struct Lisp_Process *p;
  int gid;
  int no_pgrp = 0;

  proc = get_process (process);
  p = XPROCESS (proc);

  if (!EQ (p->childp, Qt))
    error ("Process %s is not a subprocess",
	   XSTRING (p->name)->data);
  if (!XFASTINT (p->infd))
    error ("Process %s is not active",
	   XSTRING (p->name)->data);

  if (NILP (p->pty_flag))
    current_group = Qnil;

#ifdef DECOSF
#ifdef TIOCSIG
  else if (ioctl (XFASTINT (p->infd), TIOCSIG, signo) == 0)
	  return;
#endif
#endif

#ifdef TIOCGPGRP		/* Not sure about this! (fnf) */
  /* If we are using pgrps, get a pgrp number and make it negative.  */
  if (!NILP (current_group))
    {
      /* If possible, send signals to the entire pgrp
	 by sending an input character to it.  */
#ifndef SIGNALS_VIA_CHARACTERS
#if defined (TIOCGLTC) && defined (TIOCGETC)
      struct tchars c;
      struct ltchars lc;

      switch (signo)
	{
	case SIGINT:
#ifdef DECOSF
	  if (ioctl (XFASTINT (p->infd), TIOCGETC, &c) < 0) break;
#else
	  ioctl (XFASTINT (p->infd), TIOCGETC, &c);
#endif
	  send_process (proc, &c.t_intrc, 1);
	  return;
	case SIGQUIT:
#ifdef DECOSF
	  if (ioctl (XFASTINT (p->infd), TIOCGETC, &c) < 0) break;
#else
	  ioctl (XFASTINT (p->infd), TIOCGETC, &c);
#endif
	  send_process (proc, &c.t_quitc, 1);
	  return;
#ifdef SIGTSTP
	case SIGTSTP:
#ifdef DECOSF
	  if (ioctl (XFASTINT (p->infd), TIOCGLTC, &lc) < 0) break;
#else
	  ioctl (XFASTINT (p->infd), TIOCGLTC, &lc);
#endif
	  send_process (proc, &lc.t_suspc, 1);
	  return;
#endif
	}
#endif /* have TIOCGLTC and have TIOCGETC */
#endif /* not SIGNALS_VIA_CHARACTERS */
      /* It is possible that the following code would work
	 on other kinds of USG systems, not just on the IRIS.
	 This should be tried in Emacs 19.  */
#ifdef SIGNALS_VIA_CHARACTERS
      /* TERMIOS is the latest and bestest, and seems most likely to
	 work.  If the system has it, use it.  */
#ifdef HAVE_TERMIOS
      struct termios t;

      switch (signo)
	{
	case SIGINT:
	  tcgetattr (XINT (p->infd), &t);
	  send_process (proc, &t.c_cc[VINTR], 1);
	  return;

	case SIGQUIT:
	  tcgetattr (XINT (p->infd), &t);
	  send_process (proc, &t.c_cc[VQUIT], 1);
	  return;

	case SIGTSTP:
	  tcgetattr (XINT (p->infd), &t);
#if defined (VSWTCH) && !defined (PREFER_VSUSP)
	  send_process (proc, &t.c_cc[VSWTCH], 1);
#else
	  send_process (proc, &t.c_cc[VSUSP], 1);
#endif
	  return;
	}

#else /* ! HAVE_TERMIOS */
      struct termio t;
      switch (signo)
	{
	case SIGINT:
#ifdef DECOSF
	  if (ioctl (XFASTINT (p->infd), TCGETA, &t) < 0) break;
#else
	  ioctl (XFASTINT (p->infd), TCGETA, &t);
#endif
	  send_process (proc, &t.c_cc[VINTR], 1);
	  return;
	case SIGQUIT:
#ifdef DECOSF
	  if (ioctl (XFASTINT (p->infd), TCGETA, &t) < 0) break;
#else
	  ioctl (XFASTINT (p->infd), TCGETA, &t);
#endif
	  send_process (proc, &t.c_cc[VQUIT], 1);
	  return;
#ifdef SIGTSTP
	case SIGTSTP:
#ifdef DECOSF
	  if (ioctl (XFASTINT (p->infd), TCGETA, &t) < 0) break;
#else
	  ioctl (XFASTINT (p->infd), TCGETA, &t);
#endif
	  send_process (proc, &t.c_cc[VSWTCH], 1);
	  return;
#endif
	}
#endif /* HAVE_TERMIOS */
#endif /* SIGNALS_VIA_CHARACTERS */
/* 92.10.30 by K.Furuhata */
#if defined (USG) && defined (HAVE_TCATTR) && !defined(AIX) && !defined(nec_ews_svr4) && !defined(sun) /* hir@nec, 1992.11.24 */
      struct termios t;
      switch (signo)
	{
	case SIGINT:
	  ioctl (XFASTINT (p->infd), TCGETS, &t);
	  send_process (proc, &t.c_cc[VINTR], 1);
	  return;
	case SIGQUIT:
	  ioctl (XFASTINT (p->infd), TCGETS, &t);
	  send_process (proc, &t.c_cc[VQUIT], 1);
	  return;
	case SIGTSTP:
	  ioctl (XFASTINT (p->infd), TCGETS, &t);
	  send_process (proc, &t.c_cc[VSUSP], 1);
	  return;
	}
#endif /* USG and HAVE_TCATTR */

      /* Get the pgrp using the tty itself, if we have that.
	 Otherwise, use the pty to get the pgrp.  */

#if defined (pfa)
      /* TICGPGRP symbol defined in sys/ioctl.h at E50.
	 But, TIOCGPGRP does not work on E50.
	 This way, we will use -1, since the ioctl won't change it.
	 (saka@pfu.fujitsu.co.JP.)  */
      gid = -1;
#endif
      if (!NILP (p->subtty))
	ioctl (XFASTINT (p->subtty), TIOCGPGRP, &gid);
      else
	ioctl (XFASTINT (p->infd), TIOCGPGRP, &gid);
      if (gid == -1)
	no_pgrp = 1;
      else
	gid = - gid;
    }
  else
    gid = - XFASTINT (p->pid);
#else /* not using pgrps */
  /* Can't select pgrps on this system, so we know that
     the child itself heads the pgrp.  */
  gid = - XFASTINT (p->pid);
#endif /* not using pgrps */

  switch (signo)
    {
#ifdef SIGCONT
    case SIGCONT:
      p->raw_status_low = Qnil;
      p->raw_status_high = Qnil;
      p->status = Qrun;
      XSETINT (p->tick, ++process_tick);
      if (!nomsg)
	status_notify ();
      break;
#endif
    case SIGINT:
    case SIGQUIT:
    case SIGKILL:
      flush_pending_output (XFASTINT (p->infd));
      break;
    }

  /* If we don't have process groups, send the signal to the immediate subprocess.
     That isn't really right, but it's better than any obvious alternative.  */
  if (no_pgrp)
    {
      kill (XFASTINT (p->pid), signo);
      return;
    }

  /* gid may be a pid, or minus a pgrp's number */
#ifdef TIOCSIGSEND
  if (!NILP (current_group))
    ioctl (XFASTINT (p->infd), TIOCSIGSEND, signo);
  else
    {
      gid = - XFASTINT (p->pid);
      kill (gid, signo);
    }
#else /* no TIOCSIGSEND */
#ifdef BSD
  /* On bsd, [man says] kill does not accept a negative number to kill a pgrp.
     Must do that differently.  */
  killpg (-gid, signo);
#else /* Not BSD.  */
  kill (gid, signo);
#endif /* Not BSD.  */
#endif /* no TIOCSIGSEND */
}

DEFUN ("interrupt-process", Finterrupt_process, Sinterrupt_process, 0, 2, 0,
  "Interrupt process PROCESS.  May be process or name of one.\n\
Nil or no arg means current buffer's process.\n\
Second arg CURRENT-GROUP non-nil means send signal to\n\
the current process-group of the process's controlling terminal\n\
rather than to the process's own process group.\n\
If the process is a shell, this means interrupt current subjob\n\
rather than the shell.")
  (Lisp_Object process, Lisp_Object current_group)
{
  process_send_signal (process, SIGINT, current_group, 0);
  return process;
}

DEFUN ("kill-process", Fkill_process, Skill_process, 0, 2, 0,
  "Kill process PROCESS.  May be process or name of one.\n\
See function interrupt-process for more details on usage.")
  (Lisp_Object process, Lisp_Object current_group)
{
  process_send_signal (process, SIGKILL, current_group, 0);
  return process;
}

DEFUN ("quit-process", Fquit_process, Squit_process, 0, 2, 0,
  "Send QUIT signal to process PROCESS.  May be process or name of one.\n\
See function interrupt-process for more details on usage.")
  (Lisp_Object process, Lisp_Object current_group)
{
  process_send_signal (process, SIGQUIT, current_group, 0);
  return process;
}

DEFUN ("stop-process", Fstop_process, Sstop_process, 0, 2, 0,
  "Stop process PROCESS.  May be process or name of one.\n\
See function interrupt-process for more details on usage.")
  (Lisp_Object process, Lisp_Object current_group)
{
#ifndef SIGTSTP
  error ("no SIGTSTP support");
#else
  process_send_signal (process, SIGTSTP, current_group, 0);
#endif
  return process;
}

DEFUN ("continue-process", Fcontinue_process, Scontinue_process, 0, 2, 0,
  "Continue process PROCESS.  May be process or name of one.\n\
See function interrupt-process for more details on usage.")
  (Lisp_Object process, Lisp_Object current_group)
{
#ifdef SIGCONT
    process_send_signal (process, SIGCONT, current_group, 0);
#else
    error ("no SIGCONT support");
#endif
  return process;
}

DEFUN ("process-send-eof", Fprocess_send_eof, Sprocess_send_eof, 0, 1, 0,
  "Make PROCESS see end-of-file in its input.\n\
Eof comes after any text already sent to it.\n\
nil or no arg means current buffer's process.")
  (Lisp_Object process)
{
  Lisp_Object proc;

  proc = get_process (process);
  /* Sending a zero-length record is supposed to mean eof
     when TIOCREMOTE is turned on.  */
#ifdef DID_REMOTE
  {
    char buf[1];
    write (XFASTINT (XPROCESS (proc)->outfd), buf, 0);
  }
#else /* did not do TOICREMOTE */
  if (!NILP (XPROCESS (proc)->pty_flag))
    send_process (proc, "\004", 1);
  else
    {
      close (XPROCESS (proc)->outfd);
#ifdef WIN32 /* 93.2.17 by M.Higashida */
      XFASTINT (XPROCESS (proc)->outfd) = open ("nul", O_WRONLY);
#else
      XFASTINT (XPROCESS (proc)->outfd) = open ("/dev/null", O_WRONLY);
#endif
    }

#endif /* did not do TOICREMOTE */
  return process;
}

/* Kill all processes associated with `buffer'.
 If `buffer' is nil, kill all processes  */

void
kill_buffer_processes (Lisp_Object buffer)
{
  Lisp_Object tail, proc;

  for (tail = Vprocess_alist; XGCTYPE (tail) == Lisp_Cons;
       tail = XCONS (tail)->cdr)
    {
      proc = XCONS (XCONS (tail)->car)->cdr;
      if (XGCTYPE (proc) == Lisp_Process
	  && (NILP (buffer) || EQ (XPROCESS (proc)->buffer, buffer)))
	{
	  if (NETCONN_P (proc))
	    deactivate_process (proc);
	  else if (XFASTINT (XPROCESS (proc)->infd))
	    process_send_signal (proc, SIGHUP, Qnil, 1);
	}
    }
}

/* On receipt of a signal that a child status has changed,
 loop asking about children with changed statuses until
 the system says there are no more.
   All we do is change the status;
 we do not run sentinels or print notifications.
 That is saved for the next time keyboard input is done,
 in order to avoid timing errors.  */

/** WARNING: this can be called during garbage collection.
 Therefore, it must not be fooled by the presence of mark bits in
 Lisp objects.  */

/** USG WARNING:  Although it is not obvious from the documentation
 in signal(2), on a USG system the SIGCLD handler MUST NOT call
 signal() before executing at least one wait(), otherwise the handler
 will be called again, resulting in an infinite loop.  The relevant
 portion of the documentation reads "SIGCLD signals will be queued
 and the signal-catching function will be continually reentered until
 the queue is empty".  Invoking signal() causes the kernel to reexamine
 the SIGCLD queue.   Fred Fish, UniSoft Systems Inc. */

void
sigchld_handler (int signo)
{
#ifndef WIN32 /* 93.2.17 by M.Higashida */
  int old_errno = errno;
  Lisp_Object proc;
  register struct Lisp_Process *p;

#ifdef BSD4_1
  extern int synch_process_pid;
  extern int sigheld;
  sigheld |= sigbit (SIGCHLD);
#endif

  while (1)
    {
      register int pid;
      WAITTYPE w;
      Lisp_Object tail;

#ifdef WNOHANG
#ifndef WUNTRACED
#define WUNTRACED 0
#endif /* no WUNTRACED */
      /* Keep trying to get a status until we get a definitive result.  */
      do 
	{
	  errno = 0;
	  pid = wait3 (&w, WNOHANG | WUNTRACED, 0);
	}
      while (pid <= 0 && errno == EINTR);

      if (pid <= 0)
	{
	  /* A real failure.  We have done all our job, so return.  */

	  /* USG systems forget handlers when they are used;
	     must reestablish each time */
#ifdef USG
	  signal (signo, sigchld_handler);   /* WARNING - must come after wait3() */
#endif
#ifdef  BSD4_1
	  sigheld &= ~sigbit (SIGCHLD);
	  sigrelse (SIGCHLD);
#endif
	  errno = old_errno;
	  return;
	}
#else
      pid = wait (&w);
#endif /* no WNOHANG */

#ifdef BSD4_1
      if (synch_process_pid == pid)
	synch_process_pid = 0;         /* Zero it to show process has died. */
#endif

      /* Find the process that signaled us, and record its status.  */

      p = 0;
      for (tail = Vprocess_alist; XSYMBOL (tail) != XSYMBOL (Qnil); tail = XCONS (tail)->cdr)
	{
	  proc = XCONS (XCONS (tail)->car)->cdr;
	  p = XPROCESS (proc);
	  if (EQ (p->childp, Qt) && XFASTINT (p->pid) == pid)
	    break;
	  p = 0;
	}

      /* If we don't recognize the pid number,
	 look for a process being created.  */

      if (p == 0)
	for (tail = Vprocess_alist; XSYMBOL (tail) != XSYMBOL (Qnil); tail = XCONS (tail)->cdr)
	  {
	    proc = XCONS (XCONS (tail)->car)->cdr;
	    p = XPROCESS (proc);
	    if (XINT (p->pid) == -1)
	      break;
	    p = 0;
	  }

      /* Change the status of the process that was found.  */

      if (p != 0)
	{
	  union { int i; WAITTYPE wt; } u;

	  XSETINT (p->tick, ++process_tick);
	  u.wt = w;
	  XFASTINT (p->raw_status_low) = u.i & 0xffff;
	  XFASTINT (p->raw_status_high) = u.i >> 16;

	  /* If process has terminated, stop waiting for its output.  */
	  if (WIFSIGNALED (w) || WIFEXITED (w))
	    if (p->infd)
	      FD_CLR (p->infd, &input_wait_mask);
	}
      else
	{
	  /* Report the status of the synchronous process.  */
	  if (WIFEXITED (w))
	    synch_process_retcode = WRETCODE (w);
	  else if (WIFSIGNALED (w))
	    synch_process_death = strsignal(WTERMSIG (w));
	}

      /* On some systems, we must return right away.
	 If any more processes want to signal us, we will
	 get another signal.
	 Otherwise (on systems that have WNOHANG), loop around
	 to use up all the processes that have something to tell us.  */
#if defined (USG) && ! (defined (HPUX) && defined (WNOHANG))
#ifdef USG
      signal (signo, sigchld_handler);
#endif
      errno = old_errno;
      return;
#endif /* USG, but not HPUX with WNOHANG */
    }
#endif /* not WIN32 */
}

/* Report all recent events of a change in process status
   (either run the sentinel or output a message).
   This is done while Emacs is waiting for keyboard input.  */

void
status_notify (void)
{
  register Lisp_Object proc, buffer;
  Lisp_Object tail = Qnil;
  Lisp_Object msg = Qnil;
  struct gcpro gcpro1, gcpro2;

  /* We need to gcpro tail; if read_process_output calls a filter
     which deletes a process and removes the cons to which tail points
     from Vprocess_alist, tail becomes an unprotected reference.  */
  GCPRO2 (tail, msg);

  for (tail = Vprocess_alist; !NILP (tail); tail = Fcdr (tail))
    {
      Lisp_Object symbol;
      register struct Lisp_Process *p;

      proc = Fcdr (Fcar (tail));
      p = XPROCESS (proc);

      if (XINT (p->tick) != XINT (p->update_tick))
	{
	  XSETINT (p->update_tick, XINT (p->tick));

	  /* If process is still active, read any output that remains.  */
	  if (XFASTINT (p->infd))
	    while (read_process_output (proc, XFASTINT (p->infd)) > 0);

	  buffer = p->buffer;

	  /* Get the text to use for the message.  */
	  if (!NILP (p->raw_status_low))
	    update_status (p);
	  msg = status_message (p->status);

	  /* If process is terminated, deactivate it or delete it.  */
	  symbol = p->status;
	  if (XTYPE (p->status) == Lisp_Cons)
	    symbol = XCONS (p->status)->car;

	  if (EQ (symbol, Qsignal) || EQ (symbol, Qexit)
	      || EQ (symbol, Qclosed))
	    {
	      if (delete_exited_processes)
		remove_process (proc);
	      else
		deactivate_process (proc);
	    }

	  /* Now output the message suitably.  */
	  if (!NILP (p->sentinel))
	    exec_sentinel (proc, msg);
	  /* Don't bother with a message in the buffer
	     when a process becomes runnable.  */
	  else if (!EQ (symbol, Qrun) && !NILP (buffer))
	    {
	      Lisp_Object ro = XBUFFER (buffer)->read_only;
	      Lisp_Object tem;
	      struct buffer *old = current_buffer;
	      int opoint;

	      /* Avoid error if buffer is deleted
		 (probably that's why the process is dead, too) */
	      if (NILP (XBUFFER (buffer)->name))
		continue;
	      Fset_buffer (buffer);
	      opoint = point;
	      /* Insert new output into buffer
		 at the current end-of-output marker,
		 thus preserving logical ordering of input and output.  */
	      if (XMARKER (p->mark)->buffer)
		SET_PT (marker_position (p->mark));
	      else
		SET_PT (ZV);
	      if (point <= opoint)
		opoint += XSTRING (msg)->size + XSTRING (p->name)->size + 10;

	      tem = current_buffer->read_only;
	      current_buffer->read_only = Qnil;
	      InsStr ("\nProcess ");
	      Finsert (1, &p->name);
	      InsStr (" ");
	      Finsert (1, &msg);
	      current_buffer->read_only = tem;
	      Fset_marker (p->mark, make_number (point), p->buffer);

	      SET_PT (opoint);
	      set_buffer_internal (old);
	    }
	}
    } /* end for */

  update_mode_lines++;  /* in case buffers use %s in mode-line-format */
  redisplay_preserve_echo_area ();

  update_tick = process_tick;

  UNGCPRO;
}

void
exec_sentinel (Lisp_Object proc, Lisp_Object reason)
{
  Lisp_Object sentinel;
  register struct Lisp_Process *p = XPROCESS (proc);
  int count = specpdl_ptr - specpdl;

  sentinel = p->sentinel;
  if (NILP (sentinel))
    return;

  p->sentinel = Qnil;
  specbind (Qinhibit_quit, Qt);
  this_filter = sentinel;
  filter_process = proc;
  filter_string = reason;
  call2 (this_filter, filter_process, filter_string);
/*   internal_condition_case (run_filter, Qerror, Fidentity);  */
  unbind_to (count, Qnil);
  p->sentinel = sentinel;
}

/* 89.2.10, 91.10.28 by K.Handa */
DEFUN ("process-coding-system",
       Fprocess_coding_system, Sprocess_coding_system, 0, 1, 0,
  "Return a cons of coding-system objects for input and output of\n\
PROCESS (optional first arg).\n\
PROCESS defaults to current buffer's process.\n\
If no PROCESS, nil is returned.")
  (register Lisp_Object proc)
{
  if (NILP (proc)) proc = Fget_buffer_process(current_buffer->name);
  if (NILP (proc)) return Qnil;
  CHECK_PROCESS (proc, 0);
  return Fcons (XPROCESS (proc)->incode, XPROCESS (proc)->outcode);
}

DEFUN ("set-process-coding-system", Fset_process_coding_system,
       Sset_process_coding_system, 1, 3, 0,
  "Set PROCESS's coding-system object to CODE1 (input) and CODE2 (output).\n\
If PROCESS is nil, current buffer's process is applied.")
  (register Lisp_Object proc, register Lisp_Object incode, register Lisp_Object outcode)
{				/* 92.9.11 by K.Handa */
  if (NILP (proc)) proc = Fget_buffer_process(current_buffer->name);
  CHECK_PROCESS (proc, 0);
  XPROCESS (proc)->incode = Fcheck_code(incode);
  XPROCESS (proc)->outcode = Fcheck_code(outcode);
  encode_code(XPROCESS (proc)->incode,
	      &in_state[XFASTINT (XPROCESS (proc)->infd)]);
  encode_code(XPROCESS (proc)->outcode,
	      &out_state[XFASTINT (XPROCESS (proc)->outfd)]);
  /* 93.5.6 by K.Handa */
  CODE_CNTL(&out_state[XFASTINT (XPROCESS (proc)->outfd)]) |= CC_END;
  return Qnil;
}
/* end of patch */

void
init_process (void)
{
  register int i;

#ifdef SIGCHLD
#ifndef CANNOT_DUMP
  if (! noninteractive || initialized)
#endif
    signal (SIGCHLD, sigchld_handler);
#endif

  FD_ZERO (&input_wait_mask);
#ifdef WIN32 /* 93.2.17 by M.Higashida */
  {
    int i;

    named_pipe_descs = 7; /* 0...0111: for stdin, stdout and stderr. */
    socket_descs = 0;

    FD_ZERO (&socket_wait_mask);

    for (i = 0; i < MAXDESC; i++) {
      hWaitObject[i] = CreateEvent (0, 1, 0, 0);
    }
    {
      SECURITY_ATTRIBUTES sa;
      DWORD dummy;
      
      sa.nLength = sizeof (SECURITY_ATTRIBUTES);
      sa.bInheritHandle = TRUE;
      sa.lpSecurityDescriptor = 0;
    
      CreateThread (&sa, (DWORD) 0,
		    (LPTHREAD_START_ROUTINE) SelectSocket,
		    (LPVOID) 0,
		    (DWORD) 0,
		    &dummy);
    }
    InitializeCriticalSection (&SocketCliticalSection);
  }
#endif /* WIN32 */
  FD_SET (0, &input_wait_mask);
  Vprocess_alist = Qnil;
  for (i = 0; i < MAXDESC; i++)
    {
      chan_process[i] = Qnil;
      proc_buffered_char[i] = -1;
    }
}

void
syms_of_process (void)
{
  Qprocessp = intern ("processp");
  staticpro (&Qprocessp);
  Qrun = intern ("run");
  staticpro (&Qrun);
  Qstop = intern ("stop");
  staticpro (&Qstop);
  Qsignal = intern ("signal");
  staticpro (&Qsignal);

  /* Qexit is already staticpro'd by syms_of_eval; don't staticpro it
     here again.

     Qexit = intern ("exit");
     staticpro (&Qexit); */

  Qopen = intern ("open");
  staticpro (&Qopen);
  Qclosed = intern ("closed");
  staticpro (&Qclosed);

  staticpro (&Vprocess_alist);

  DEFVAR_BOOL ("delete-exited-processes", &delete_exited_processes,
    "*Non-nil means delete processes immediately when they exit.\n\
nil means don't delete them until `list-processes' is run.");

  delete_exited_processes = 1;

  DEFVAR_LISP ("process-connection-type", &Vprocess_connection_type,
    "Control type of device used to communicate with subprocesses.\n\
Values are nil to use a pipe, t for a pty (or pipe if ptys not supported).\n\
Value takes effect when `start-process' is called.");
  Vprocess_connection_type = Qt;

  defsubr (&Sprocessp);
  defsubr (&Sget_process);
  defsubr (&Sget_buffer_process);
  defsubr (&Sdelete_process);
  defsubr (&Sprocess_status);
  defsubr (&Sprocess_exit_status);
  defsubr (&Sprocess_id);
  defsubr (&Sprocess_name);
  defsubr (&Sprocess_command);
  defsubr (&Sset_process_buffer);
  defsubr (&Sprocess_buffer);
  defsubr (&Sprocess_mark);
  defsubr (&Sset_process_filter);
  defsubr (&Sprocess_filter);
  defsubr (&Sset_process_sentinel);
  defsubr (&Sprocess_sentinel);
  defsubr (&Sprocess_kill_without_query);
  defsubr (&Slist_processes);
  defsubr (&Sprocess_list);
  defsubr (&Sstart_process);
  defsubr (&Ssi_start_process);
#ifdef HAVE_SOCKETS
  defsubr (&Sopen_network_stream);
  defsubr (&Ssi_open_network_stream);
#endif /* HAVE_SOCKETS */
  defsubr (&Saccept_process_output);
  defsubr (&Sprocess_send_region);
  defsubr (&Sprocess_send_string);
  defsubr (&Sinterrupt_process);
  defsubr (&Skill_process);
  defsubr (&Squit_process);
  defsubr (&Sstop_process);
  defsubr (&Scontinue_process);
  defsubr (&Sprocess_send_eof);
  defsubr (&Swaiting_for_user_input_p);
  defsubr (&Sprocess_coding_system); /* 89.2.10, 91.10.28 by K.Handa */
  defsubr (&Sset_process_coding_system); /* 89.2.10, 91.10.28 by K.Handa */
}

#endif /* subprocesses */

