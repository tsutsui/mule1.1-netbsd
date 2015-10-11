/* Synchronous subprocess invocation for GNU Emacs.
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
/* 87.7.7   modified by K.Handa */
/* 87.12.10 modified for Nemacs Ver.2.0 by K.Handa */
/* 88.1.25  modified by K.Handa according to a patch by Mr.Sanewo (88.3.6) */
/* 88.5.25  modified for Nemacs Ver.2.1 by K.Handa */
/* 88.3.23  modified for Nemacs Ver.3.0 by K.Handa, S.Tomura */
/* 89.9.12  modified for Nemacs Ver.3.2 by S.Tomura */
/* 90.2.28  modified for Nemacs Ver.3.3.1 by K.Handa
	do GCPRO (proc) before Ffuncall */
/* 91.10.27 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.4.27  modified for Mule Ver.0.9.4 by T.Enami <enami@sys.ptg.sony.co.jp>
	In Fcall_process(), 'state' is set before calling encode(). */
/* 92.10.21 modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>,
		   S.Hirano <hirano@etl.go.jp>
        DOS-Extender GO32 supported. */
/* 92.11.4  modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	DOS-Extender EMX supported. */
/* 92.11.14 modified for Mule Ver.0.9.6 with DOS support by S.Namba */
/* 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Arguments of get_conversion_buffer() changed. */
/* 93.2.25  modified for Mule Ver.0.9.7
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	Win32 (Windows NT and Windows 3.1) supported. */
/* 93.3.3   modified for Mule Ver.0.9.7
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */
/* 93.4.16  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	'si:call-process' has document now. */

/* This must precede sys/signal.h on certain machines.  */
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>

#include "config.h"

#ifdef BSD
#include <sys/resource.h>
#endif

#define PRIO_PROCESS 0
#include <sys/file.h>
#ifdef USG5
#include <fcntl.h>
#endif
/* 91.10.16 by S.Hirano, 92.11.4, 93.2.25 by M.Higashida */
#ifdef MSDOS
#ifdef EMX
#include <process.h>
#endif
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <errno.h>
#endif /* MSDOS */
#ifdef WIN32
#include <sys/param.h>
#endif /* WIN32 */
/* end of patch */

#ifndef O_RDONLY
#define O_RDONLY 0
#endif

#ifndef O_WRONLY
#define O_WRONLY 1
#endif

#include "lisp.h"
#include "commands.h"
#include "buffer.h"
#include "paths.h"
#include "mule.h"		/* 89.2.23, 89.3.20, 91.10.28 by K.Handa */
#include "codeconv.h"		/* 92.1.6 by K.Handa */

#define max(a, b) ((a) > (b) ? (a) : (b))

Lisp_Object Vexec_path, Vexec_directory;

Lisp_Object Vshell_file_name;

#ifndef MAINTAIN_ENVIRONMENT
/* List of strings to append to front of environment of
   all subprocesses when they are started.  */

Lisp_Object Vprocess_environment;
#endif

#ifdef BSD4_1
/* Set nonzero when a synchronous subprocess is made,
   and set to zero again when it is observed to die.
   We wait for this to be zero in order to wait for termination.  */
int synch_process_pid;
#endif /* BSD4_1 */

/* True iff we are about to fork off a synchronous process or if we
   are waiting for it.  */
int synch_process_alive;

/* Nonzero => this is a string explaining death of synchronous subprocess.  */
char *synch_process_death;

/* Exit code of synchronous subprocess if positive,
   minus the signal number if negative.  */
int synch_process_retcode;

Lisp_Object
call_process_cleanup (fdpid)
     Lisp_Object fdpid;
{
/* 91.10.22 by M.Higashida */
#ifdef MSDOS
  register Lisp_Object fd, file;
  fd = Fcar (fdpid);
  file = Fcdr (fdpid);
  close (XFASTINT (fd));
  if (strcmp (XSTRING (file)-> data, "nul") != 0)
    unlink (XSTRING (file)->data);
#else /* not MSDOS */
  register Lisp_Object fd, pid;
  fd = Fcar (fdpid);
  pid = Fcdr (fdpid);
#ifdef WIN32 /* 93.2.17, 93.3.3 by M.Higashida */
  CloseHandle (XFASTINT (fd));
#else
  close (XFASTINT (fd));
  kill (XFASTINT (pid), SIGKILL);
#endif /* not WIN32 */
#endif /* not MSDOS */
/* end of patch */
  return Qnil;
}

#ifdef VMS
#ifdef __GNUC__
#define	environ $$PsectAttributes_NOSHR$$environ
extern char **environ;
#else
extern noshare char **environ;
#endif
#else
extern char **environ;
#endif

DEFUN ("si:call-process", Fsi_call_process, Ssi_call_process, 1, MANY, 0,
  "Call PROGRAM in separate process.\n\
Program's input comes from file INFILE (nil means /dev/null).\n\
Insert output in BUFFER before point; t means current buffer;\n\
 nil for BUFFER means discard it; 0 means discard and don't wait.\n\
Fourth arg DISPLAY non-nil means redisplay buffer as output is inserted.\n\
Fifth arg CODE specifies the coding-system object for input from PROCESS.\n\
Remaining arguments are strings passed as command arguments to PROGRAM.\n\
Returns nil if BUFFER is 0; otherwise waits for PROGRAM to terminate\n\
and returns a numeric exit status or a signal description string.\n\
If you quit, the process is killed with SIGKILL.")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
{
  Lisp_Object display, buffer, path;
  Lisp_Object dummy = Qnil; /* 92.2.20 by K.Handa */
  int fd[2];
  int filefd;
  register int pid;
  char buf[1024];
#ifdef MSDOS /* 91.10.16 by S.Hirano, 92.11.14, 93.2.17 by M.Higashida */
  char tempfile[MAXPATHLEN+1];
  int return_status;
#endif
  int count = specpdl_ptr - specpdl;
  register unsigned char **new_argv /* 91.11.6 by K.Handa */
    = (unsigned char **) alloca ((max (2, nargs - 3)) * sizeof (char *));
  struct buffer *old = current_buffer;
  coding_type mccode;		/* 91.10.28, 92.9.11 by K.Handa */
  encode_code(Fcheck_code(nargs < 5 ? Qnil : args[4]), &mccode);

  CHECK_STRING (args[0], 0);

  if (nargs <= 1 || NILP (args[1]))
#ifdef VMS
    args[1] = build_string ("NLA0:");
#else
/* 91.10.16 by S.Hirano, 93.2.17 by M.Higashida */
#if defined(MSDOS) || defined(WIN32)
    args[1] = build_string ("nul");
#else
    args[1] = build_string ("/dev/null");
#endif
/* end of patch */
#endif /* not VMS */
  else
    args[1] = Fexpand_file_name (args[1], current_buffer->directory);

  CHECK_STRING (args[1], 1);

  {
    register Lisp_Object tem;
    buffer = tem = args[2];
    if (nargs <= 2)
      buffer = Qnil;
    else if (!(EQ (tem, Qnil) || EQ (tem, Qt)
	       || XFASTINT (tem) == 0))
      {
	buffer = Fget_buffer (tem);
	CHECK_BUFFER (buffer, 2);
      }
  }

  display = nargs > 3 ? args[3] : Qnil;

  {
    register int i;
    for (i = 5; i < nargs; i++)	/* 91.10.28 by K.Handa */
      {
	CHECK_STRING (args[i], i);
	new_argv[i - 4] = XSTRING (args[i])->data; /* 91.10.28 by K.Handa */
      }
    /* Program name is first command arg */
    new_argv[0] = XSTRING (args[0])->data;
    new_argv[i - 4] = 0;	/* 91.10.28 by K.Handa */
  }

  filefd = open (XSTRING (args[1])->data, O_RDONLY, 0);
  if (filefd < 0)
    {
      report_file_error ("Opening process input file", Fcons (args[1], Qnil));
    }
  /* Search for program; barf if not found.  */
/* 91.10.22,93.2.17 by M.Higashida */
#if defined(MSDOS) || defined(WIN32)
  openp (Vexec_path, args[0], ".exe:.com:.bat:", &path, 1);
#else
  openp (Vexec_path, args[0], "", &path, 1);
#endif
/* end of patch */
  if (NILP (path))
    {
      close (filefd);
      report_file_error ("Searching for program", Fcons (args[0], Qnil));
    }
  new_argv[0] = XSTRING (path)->data;

/* 91.10.22, 92.11.14, 93.2.17 by M.Higashida */
#ifndef MSDOS
  if (XTYPE (buffer) == Lisp_Int)
#ifdef VMS
    fd[1] = open ("NLA0:", 0), fd[0] = -1;
#else
#ifdef WIN32 /* 93.2.17 by M.Higashida */
    fd[1] = open ("nul", O_WRONLY), fd[0] = -1;
#else /* not WIN32 */
    fd[1] = open ("/dev/null", O_WRONLY), fd[0] = -1;
#endif /* not WIN32 */
#endif /* not VMS */
  else
    {
      pipe (fd);
#if 0
      /* Replaced by close_process_descs */
      set_exclusive_use (fd[0]);
#endif
    }
#else /* MSDOS */
  {
    char *outf;

  if (XTYPE (buffer) == Lisp_Int)
    outf = "nul";
  else 
    {
	/* DOS can't create pipe for interprocess communication, 
	   so redirect child process's standard output to temporary file
	   and later read the file. */
	
      if ((outf = egetenv ("TMP")) || (outf = egetenv ("TEMP")))
	{
	  strcpy (tempfile, outf);
	  dostounix_filename (tempfile);
	}
      else
        *tempfile = '\0';
      if (strlen (tempfile) == 0 || tempfile[strlen (tempfile) - 1] != '/')
	strcat (tempfile, "/");
      strcat (tempfile, "demacs.XXX");
      mktemp (tempfile);
      outf = tempfile;
    }

    if ((fd[1] = creat (outf, S_IREAD | S_IWRITE)) < 0)
      report_file_error ("Can't open temporary file", Qnil);
    fd[0] = -1;
    }
#endif /* MSDOS */
/* end of patch */

  synch_process_death = 0;
  synch_process_retcode = 0;

  {
    /* child_setup must clobber environ in systems with true vfork.
       Protect it from permanent change.  */
    register char **save_environ = environ;
    register int fd1 = fd[1];
    char **env;

#ifdef MAINTAIN_ENVIRONMENT
    env = (char **) alloca (size_of_current_environ ());
    get_current_environ (env);
#else
    env = environ;
#endif /* MAINTAIN_ENVIRONMENT */

#ifdef MSDOS /* 92.2.17 by M.Higashida */
    {
      child_setup (filefd, fd1, fd1, new_argv, env);
    }
#else /* not MSDOS */
#ifdef WIN32 /* 92.2.17 by M.Higashida */
    {
      HANDLE temp;
      
      DuplicateHandle (GetCurrentProcess (), (HANDLE) fd[0],
                       GetCurrentProcess (), &temp, 0,
		       FALSE, DUPLICATE_SAME_ACCESS);

      CloseHandle ((HANDLE) fd[0]);
      fd[0] = (int) temp; /* for lator access */

      child_setup (filefd, fd1, fd1, new_argv, env);
    }
#else /* not WIN32 */
    pid = vfork ();
#ifdef BSD4_1
    /* cause SIGCHLD interrupts to look for this pid. */
    synch_process_pid = pid;
#endif /* BSD4_1 */

    if (pid == 0)
      {
	if (fd[0] >= 0)
	  close (fd[0]);
#ifdef USG
#ifdef HAVE_PTYS
	setpgrp ();
#endif
#endif
	child_setup (filefd, fd1, fd1, new_argv, env);
      }
#endif /* not WIN32 */
#endif /* not MSDOS */

    environ = save_environ;

    close (filefd);
#ifdef WIN32 /* 93.2.25 by M.Higashida */
    CloseHandle ((HANDLE) fd1);
#else
    close (fd1);
#endif
  }

#if !defined(MSDOS) && !defined(WIN32)
  if (pid < 0)
    {
      close (fd[0]);
      report_file_error ("Doing vfork", Qnil);
    }
#endif /* not MSDOS nor WIN32 */

  if (XTYPE (buffer) == Lisp_Int)
    {
#ifndef subprocesses
      wait_without_blocking ();
#endif
      return Qnil;
    }

#ifdef MSDOS /* 92.2.17 by M.Higashida */
  if ((fd[0] = open (tempfile, O_TEXT)) < 0) 
    {
      unlink(tempfile);
      report_file_error ("Can't open temporary file", Qnil);
    }
  record_unwind_protect (call_process_cleanup,
			 Fcons (make_number (fd[0]), build_string (tempfile)));
#else /* not MSDOS */
  record_unwind_protect (call_process_cleanup,
			 Fcons (make_number (fd[0]), make_number (pid)));
#endif /* not MSDOS */

  if (XTYPE (buffer) == Lisp_Buffer)
    Fset_buffer (buffer);

  immediate_quit = 1;
  QUIT;

  {				/* 91.11.1, 93.5.18 by K.Handa */
#ifdef WIN32 /* 93.2.25 by M.Higashida */
    int nread;
#else
    register int nread;
#endif
    register int state = 1;
    char *buf2;

    while (state)
      {
/* 91.10.28 by M.Higashida */
#ifdef WIN32 /* 93.2.25 by M.Higashida */
	ReadFile ((HANDLE) fd[0], buf, sizeof buf, &nread, 0);
#else /* not WIN32 */
#if defined(MSDOS) && defined(GO32)
	nread = (nread = read (fd[0], buf, sizeof buf)) ? nread : -1;
#else
	nread = read (fd[0], buf, sizeof buf);
#endif
#endif /* not WIN32 */
	if (nread <= 0) state = 0;
/* end of patch */
	immediate_quit = 0;
	if (!NILP (buffer)) {	/* 91.10.28 by K.Handa */
	  if (CODE_TYPE(&mccode) == AUTOCONV || CODE_TYPE(&mccode) > ITNCODE) {
	    /* 93.2.10 by K.Handa */
	    if (state)
	      buf2 = get_conversion_buffer(nread, ITNCODE);
	    else {
	      nread = 0;
	      buf2 = get_conversion_buffer(0, ITNCODE);
	      CODE_CNTL(&mccode) |= CC_END;
	    }
	    if (nread = encode(&mccode, buf, buf2, nread, &dummy))
	      insert (buf2, nread);
	  } else {
	    if (state)
	      insert (buf, nread);
	  }
	}
	if (!NILP (display) && FROM_KBD)
	  redisplay_preserve_echo_area ();
	immediate_quit = 1;
	QUIT;
      }
  }

  /* Wait for it to terminate, unless it already has.  */
#ifndef MSDOS /* 93.3.4 by M.Higashida */
  wait_for_termination (pid);
#endif

  immediate_quit = 0;

  set_buffer_internal (old);

  unbind_to (count, Qnil);

  if (synch_process_death)
    return build_string (synch_process_death);
  return make_number (synch_process_retcode);
}

DEFUN ("call-process", Fcall_process, Scall_process, 1, MANY, 0, "")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
{
  return Fsi_call_process (nargs, args);
}

/* 91.10.28 by K.Handa */
/* call-process-region is rewritten in Emacslisp now. */
#if 0
DEFUN ("call-process-region", Fcall_process_region, Scall_process_region,
  3, MANY, 0,
  "Send text from START to END to a process running PROGRAM.\n\
Delete the text if DELETE is non-nil.\n\
Insert output in BUFFER before point; t means current buffer;\n\
 nil for BUFFER means discard it; 0 means discard and don't wait.\n\
Sixth arg DISPLAY non-nil means redisplay buffer as output is inserted.\n\
Remaining arguments are strings passed as command arguments to PROGRAM.\n\
Returns nil if BUFFER is 0; otherwise waits for PROGRAM to terminate\n\
and returns a numeric exit status or a signal description string.\n\
If you quit, the process is killed with SIGKILL.")
  (nargs, args)
     int nargs;
     register Lisp_Object *args;
{
  register Lisp_Object filename_string, start, end, status;
/* 91.10.16 by S.Hirano, 93.6.1 by M.Higashida */
#ifdef MSDOS
  char tempfile[MAXPATHLEN+1];
  char *outf = '\0';

  if ((outf = getenv ("TMP")) || (outf = egetenv ("TEMP")))
    {
      strcpy(tempfile, outf);
      dostounix_filename (tempfile);
    }
  else
    *tempfile = '\0';
  if (strlen (tempfile) == 0 || tempfile[strlen (tempfile) - 1] != '/')
    strcat (tempfile, "/");
  strcat (tempfile, "demacs.XXX");
  mktemp (tempfile);
#else /* not MSDOS */
  char tempfile[20];

  strcpy (tempfile, "/tmp/emacsXXXXXX");
  mktemp (tempfile);
#endif /* not MSDOS */
/* end of patch */

  filename_string = build_string (tempfile);
  start = args[0];
  end = args[1];
  Fwrite_region (start, end, filename_string, Qnil, Qlambda);

  if (!NILP (args[3]))
    Fdelete_region (start, end);

  args[3] = filename_string;
  status = Fcall_process (nargs - 2, args + 2);
  unlink (tempfile);
  return status;
}
#endif	/* 0 */

/* This is the last thing run in a newly forked inferior
   either synchronous or asynchronous.
   Copy descriptors IN, OUT and ERR as descriptors 0, 1 and 2.
   Initialize inferior's priority, pgrp, connected dir and environment.
   then exec another program based on new_argv.

   This function may change environ for the superior process.
   Therefore, the superior process must save and restore the value
   of environ around the vfork and the call to this function.

   ENV is the environment */

#ifdef MSDOS /* 91.10.16 by S.Hirano, 92.11.14, 93.2.17 by M.Higashida */

child_setup (in, out, err, new_argv, env)
     int in, out, err;
     register char **new_argv;
     char **env;
{
  register int i;
  int st;
  char oldwd[MAXPATHLEN+1];
#ifdef GO32  /* 92.11.4 by M.Higashida */
  char com[256];

  /* 92.6.1 by S.Namba, 93.2.25 by M.Higashida */
  *com = '\0';
  /* Copy command name into command line buffer. */
  {
    char *suffix = strchr (new_argv[0], '.');
    if (strncmp (new_argv[0], ".bat", 4))
      {
        strcat (com, XSTRING(Vshell_file_name)->data);
        strcat (com, " -c ");
      }
  }
  strcat (com, new_argv[0]);
  strcat (com, " ");
  /* Convert path delimiter in command name into MSDOS fashon. */
  {
    char *p;
    for (p = com; *p; p++)
      if (*p == '/')
	*p = '\\';
      else if (*p == '-')
        *p = '/';
  }
  for (i = 1; new_argv[i]; i++)
    strcat (strcat (com, new_argv[i]), " ");
  /* end of patch */
#endif /* GO32 */

  getwd (oldwd);
    
  {
    /* change directory */
    if (XTYPE (current_buffer->directory) == Lisp_String)
      {
	register unsigned char *temp;
	register int i;
	
	i = XSTRING (current_buffer->directory)->size;
	temp = (unsigned char *) alloca (i + 2);
	bcopy (XSTRING (current_buffer->directory)->data, temp, i);
	if (temp[i - 1] != '/') temp[i++] = '/';
	temp[i] = 0;
	chdir (temp);
      }
  }
    
  {
    int inbak, outbak, errbak;

    inbak = dup (0); outbak = dup (1); errbak = dup (2);
    if (inbak < 0 || outbak < 0 || errbak < 0)
      goto skip;

    dup2 (in, 0);
    dup2 (out, 1);
    dup2 (out, 2);
    
#ifdef GO32 /* 92.11.4 by M.Higashida */
    synch_process_retcode = system (com);
#else
#ifdef EMX
    synch_process_retcode
      = spawnvpe (P_WAIT, new_argv[0], (char **) new_argv, (char **) environ);
#endif
#endif
      
    close (in);
    close (out);
    dup2 (inbak, 0); dup2 (outbak, 1); dup2 (errbak, 2);
      
  skip:
    close (inbak); close (outbak); close (errbak);
  }

  chdir (oldwd);
#if 0
  if (synch_process_retcode < 0)
    report_file_error ("Can't execute", Fcons (args[0], Qnil));
#endif
}

#else /* not MSDOS */
#ifdef WIN32 /* 93.2.17, 93.2.25, 93.3.3 by M.Higashida */

child_setup (in, out, err, new_argv, env)
     int in, out, err;
     register char **new_argv;
     char **env;
{
  register int i;
  int st;
  char *com;
#if 1
  char oldwd[MAXPATHLEN+1];
#else
  char *asynch_process_directory;
#endif

  com = (char *) malloc (1024);
  *com = '\0';
  /* Copy command name into command line buffer. */
  {
    char *suffix = strchr (new_argv[0], '.');
    if (strncmp (new_argv[0], ".bat", 4))
      {
        lstrcpy (com, XSTRING(Vshell_file_name)->data);
        lstrcat (com, " -c ");
      }
  }
  lstrcat (com, new_argv[0]);
  lstrcat (com, " ");
  /* Convert path delimiter in command name into MSDOS fashon. */
  {
    char *p;
    for (p = com; *p; p++)
      if (*p == '/')
	*p = '\\';
      else if (*p == '-')
        *p = '/';
  }
  for (i = 1; new_argv[i]; i++)
    lstrcat (lstrcat (com, new_argv[i]), " ");

#if 1
  getwd (oldwd);
    
  {
    /* change directory */
    if (XTYPE (current_buffer->directory) == Lisp_String)
      {
	register unsigned char *temp;
	register int i;
	
	i = XSTRING (current_buffer->directory)->size;
	temp = (unsigned char *) alloca (i + 2);
	bcopy (XSTRING (current_buffer->directory)->data, temp, i);
	if (temp[i - 1] != '/') temp[i++] = '/';
	temp[i] = 0;
	chdir (temp);
      }
  }
#else
  if (XTYPE (current_buffer->directory) == Lisp_String)
    {
      register int i;
      
      i = XSTRING (current_buffer->directory)->size;
      asynch_process_directory = (unsigned char *) alloca (i + 2);
      bcopy (XSTRING (current_buffer->directory)->data,
	     asynch_process_directory, i);
      if (asynch_process_directory[i - 1] != '/')
	asynch_process_directory[i++] = '/';
      asynch_process_directory[i] = 0;
    }
#endif
    
    {
      extern HANDLE hStdin, hStdout, hStderr;

      if (in && out && err) {
	if (!SetStdHandle (STD_INPUT_HANDLE, (HANDLE) in) ||
	    !SetStdHandle (STD_OUTPUT_HANDLE, (HANDLE) out) ||
	    !SetStdHandle (STD_ERROR_HANDLE, (HANDLE) err))
	  goto restore;
      }

      {
        PROCESS_INFORMATION piProcInfo;
	STARTUPINFO siStartInfo;
	    
	/* Set up fields of STARTUPINFO structure */
	siStartInfo.cb = sizeof (STARTUPINFO);
	siStartInfo.lpReserved = 0;
	siStartInfo.lpReserved2 = 0;
	siStartInfo.cbReserved2 = 0;
	siStartInfo.lpDesktop = 0;
	siStartInfo.dwFlags = 0;

	/* Create child process */
        {
	  st = CreateProcess ((LPCTSTR) 0, /* 93.3.3 by M.Higashida */
			      (LPCTSTR) com,
	                      (LPSECURITY_ATTRIBUTES) 0,
			      (LPSECURITY_ATTRIBUTES) 0, 
			      TRUE,  /* inherit handles */
			      0,
			      (LPVOID) 0,
#if 1
			      (LPTSTR) 0,
#else
			      asnych_process_directory,
#endif
			      &siStartInfo, &piProcInfo);
	}
      }
      
    restore:
      if (in && out && err) {
	SetStdHandle (STD_INPUT_HANDLE,  hStdin);
	SetStdHandle (STD_OUTPUT_HANDLE, hStdout);
	SetStdHandle (STD_ERROR_HANDLE,  hStderr);
      }
    }

  free (com);
#if 1
  chdir (oldwd);
#endif
    if (!st)
      report_file_error ("Can't execute", Fcons (new_argv[0], Qnil));
}

#else /* not WIN32 */

void
child_setup (in, out, err, new_argv, env)
     int in, out, err;
     register char **new_argv;
     char **env;
{
  register int pid = getpid();

  setpriority (PRIO_PROCESS, pid, 0);

#ifdef subprocesses
  /* Close Emacs's descriptors that this process should not have.  */
  close_process_descs ();
#endif

  /* Note that use of alloca is always safe here.  It's obvious for systems
     that do not have true vfork or that have true (stack) alloca.
     If using vfork and C_ALLOCA it is safe because that changes
     the superior's static variables as if the superior had done alloca
     and will be cleaned up in the usual way.  */

  if (XTYPE (current_buffer->directory) == Lisp_String)
    {
      register unsigned char *temp;
      register int i;

      i = XSTRING (current_buffer->directory)->size;
      temp = (unsigned char *) alloca (i + 2);
      bcopy (XSTRING (current_buffer->directory)->data, temp, i);
      if (temp[i - 1] != '/') temp[i++] = '/';
      temp[i] = 0;
      chdir (temp);
    }

#ifndef MAINTAIN_ENVIRONMENT
  /* Set `env' to a vector of the strings in Vprocess_environment.  */
  {
    register Lisp_Object tem;
    register char **new_env;
    register int new_length;

    new_length = 0;
    for (tem = Vprocess_environment;
	 (XTYPE (tem) == Lisp_Cons
	  && XTYPE (XCONS (tem)->car) == Lisp_String);
	 tem = XCONS (tem)->cdr)
      new_length++;

    /* new_length + 1 to include terminating 0 */
    env = new_env = (char **) alloca ((new_length + 1) * sizeof (char *));

    /* Copy the env strings into new_env.  */
    for (tem = Vprocess_environment;
	 (XTYPE (tem) == Lisp_Cons
	  && XTYPE (XCONS (tem)->car) == Lisp_String);
	 tem = XCONS (tem)->cdr)
      *new_env++ = (char *) XSTRING (XCONS (tem)->car)->data;
    *new_env = 0;
  }
#endif /* Not MAINTAIN_ENVIRONMENT */

  close (0);
  close (1);
  close (2);

  dup2 (in, 0);
  dup2 (out, 1);
  dup2 (err, 2);
  close (in);
  close (out);
  close (err);

#ifdef USG
#ifndef HAVE_PTYS
  setpgrp ();			/* No arguments but equivalent in this case */
#endif
#else
  setpgrp (pid, pid);
#endif /* USG */
  setpgrp_of_tty (pid);

#ifdef vipc
  something missing here;
#endif

  /* execvp does not accept an environment arg so the only way
     to pass this environment is to set environ.  Our caller
     is responsible for restoring the ambient value of environ.  */
  environ = env;
  execvp (new_argv[0], new_argv);

  write (1, "Couldn't exec the program ", 26);
  write (1, new_argv[0], strlen (new_argv[0]));
  _exit (1);
}

#endif /* not WIN32 */
#endif /* not MSDOS */
/* end of patch */

void
init_callproc ()
{
  register char * sh;
  extern char **environ;
  register char **envp;
  Lisp_Object execdir;

  /* Turn PATH_EXEC into a path.  Don't look at environment.  */
/* 91.11.13 by M.Higashida */
#if defined(MSDOS) || defined(WIN32)
  Vexec_path = decode_env_path ("EMACSEXECPATH", PATH_EXEC);
#else
  Vexec_path = decode_env_path (0, PATH_EXEC);
#endif
/* end of patch */
  Vexec_directory = Ffile_name_as_directory (Fcar (Vexec_path));
  Vexec_path = nconc2 (decode_env_path ("PATH", ""), Vexec_path);

  execdir = Fdirectory_file_name (Vexec_directory);
  if (access (XSTRING (execdir)->data, 0) < 0)
    {
      printf ("Warning: executable/documentation dir (%s) does not exist.\n",
	      XSTRING (Vexec_directory)->data);
      sleep (2);
    }

  sh = (char *) egetenv ("SHELL");
/* 91.10.16 by S.Hirano, 93.6.1 by M.Higashida */
#if defined(MSDOS) || defined(WIN32)
  if (!sh) sh = egetenv("COMSPEC");
  {
    char *tem;
    if (sh)
      {
	tem = (char *) alloca (strlen (sh) + 1);
	sh = dostounix_filename (strcpy (tem, sh));
      }
  }
#ifdef WIN32
  Vshell_file_name = build_string (sh ? sh : "/winnt/system32/cmd.exe");
#else /* MSDOS */
  Vshell_file_name = build_string (sh ? sh : "/command.com");
#endif /* MSDOS */
#else
  Vshell_file_name = build_string (sh ? sh : "/bin/sh");
#endif
/* end of patch */

#ifndef MAINTAIN_ENVIRONMENT
  /* The equivalent of this operation was done
     in init_environ in environ.c if MAINTAIN_ENVIRONMENT */
  Vprocess_environment = Qnil;
#ifndef CANNOT_DUMP
  if (initialized)
#endif
    for (envp = environ; *envp; envp++)
      Vprocess_environment = Fcons (build_string (*envp),
				    Vprocess_environment);
#endif /* MAINTAIN_ENVIRONMENT */
}

void
syms_of_callproc ()
{
  DEFVAR_LISP ("shell-file-name", &Vshell_file_name,
    "*File name to load inferior shells from.\n\
Initialized from the SHELL environment variable.");

  DEFVAR_LISP ("exec-path", &Vexec_path,
    "*List of directories to search programs to run in subprocesses.\n\
Each element is a string (directory name) or nil (try default directory).");

  DEFVAR_LISP ("exec-directory", &Vexec_directory,
    "Directory that holds programs that come with GNU Emacs,\n\
intended for Emacs to invoke.");

#ifndef MAINTAIN_ENVIRONMENT
  DEFVAR_LISP ("process-environment", &Vprocess_environment,
    "List of strings to append to environment of subprocesses that are started.\n\
Each string should have the format ENVVARNAME=VALUE.");
#endif

  defsubr (&Scall_process);
  defsubr (&Ssi_call_process);
}

