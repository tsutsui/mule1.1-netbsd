/* Support for Non-ASCII Path Name
   Copyright (C) 1985, 1986, 1992, 1993 Free Software Foundation, Inc.

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

/* 94.3.9   modified for Mule Ver.1.1 by T.Emami <enami@sys.ptg.sony.co.jp>
	The last arg of encode() should be a pointer to a real Lisp_Object. */

#define MCPATH_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>

/* mcpath.h should be included in config.h */
#include "config.h"

#ifdef MCPATH_ASSERT			/* for debugging */
#include <assert.h>
#endif

#ifdef SYSV_SYSTEM_DIR

#include <dirent.h>
#define DIRENTRY struct dirent
#define NAMLEN(p) strlen (p->d_name)

#else

#ifdef NONSYSTEM_DIR_LIBRARY
#include "ndir.h"
#else /* not NONSYSTEM_DIR_LIBRARY */
#include <sys/dir.h>
#endif /* not NONSYSTEM_DIR_LIBRARY */

#define DIRENTRY struct direct
#define NAMLEN(p) p->d_namlen
#define HAVE_NAMLEN_ENTRY

extern DIR *opendir ();
extern struct direct *readdir ();

#endif

#include "lisp.h"
#include "buffer.h"

#include "mule.h"
#include "codeconv.h"

/* From the top of this file to here is copied from dired.c */

#ifndef MCPATH_NO_BACKWARD_COMPATIBILITY
Lisp_Object Qfile_system_coding_system = 0;
#endif
Lisp_Object Qpathname_coding_system = 0;

/* this function should be lisp function. */
DEFUN ("set-pathname-coding-system",
  Fset_pathname_coding_system, Sset_pathname_coding_system,
  1, 1, 0,
  "Set the pathname-coding-system to CODING_SYSTEM.")
  (register Lisp_Object coding_system)
{
  Fcheck_code (coding_system);
  Fset (Qpathname_coding_system, coding_system);
}

static void
mcpath_encode_code (coding_type *cp)
{
  Lisp_Object coding_system;

  coding_system = Fsymbol_value (Qpathname_coding_system);
#ifndef MCPATH_NO_BACKWARD_COMPATIBILITY
  if (NILP(coding_system))
    coding_system = Fsymbol_value (Qfile_system_coding_system);
#endif

  encode_code(coding_system, cp);
}

static int
encode_path_1 (unsigned char *src, unsigned int srcsize, unsigned char *dst, unsigned int dstsize)
{
  coding_type code;

  mcpath_encode_code (&code);
  if (CODE_TYPE(&code) > ITNCODE)
    {
      unsigned char *buf;

					/* get_conversion_buffer () is not */
					/* re-entrant. */
      buf = (unsigned char *) alloca (CONV_BUF_SIZE (srcsize, ITNCODE));
      if (buf)
	{
	  int len;
	  Lisp_Object dummy = Qnil; /* 94.3.9 by T.Enami */

	  len = encode(&code, src, buf, srcsize, &dummy);
	  if (!CODE_CHAR(&code) && len <= dstsize)
	    {
	      bcopy (buf, dst, len);
	      return len;
	    }
	}
    }
  return -1;				/* use original */
}

static unsigned char *
decode_path_1 (unsigned char *src, unsigned char *dst, unsigned int dstsize)
{
  coding_type code;

  mcpath_encode_code (&code);
  if (CODE_TYPE(&code) > ITNCODE)
    {
      int len;
      unsigned char *buf;

      len = strlen (src) + 1;		/* + 1 for '\0' */

					/* get_conversion_buffer () is not */
					/* re-entrant. */
      buf = (unsigned char *) alloca (CONV_BUF_SIZE (len, CODE_TYPE (&code)));
      if (buf)
	{
	  CODE_CNTL(&code) |= CC_END;
	  len = decode(&code, src, buf, len);
	  if (!CODE_CHAR(&code) && len <= dstsize)
	    {
	      bcopy (buf, dst, len);	/* len should include '\0' */
	      return dst;
	    }
	}
    }
  return src;
}

static unsigned char *
decode_path (unsigned char *path, unsigned char ext_path[MAXPATHLEN])
{
  return
    (
     (Qpathname_coding_system
#ifndef MCPATH_NO_BACKWARD_COMPATIBILITY
      || Qfile_system_coding_system
#endif
      )
     ? decode_path_1 (path, ext_path, MAXPATHLEN)
     : path);				/* in case of before initialization */
}

int
mc_creat (int path, int mode)
{
  unsigned char buffer[MAXPATHLEN];
  return creat (decode_path (path, buffer), mode);
}

#ifdef INTERRUPTABLE_OPEN
#define open sys_open			/* call open in sysdep.c */
#endif
int
mc_open (int path, int flag, int mode)
{
  unsigned char buffer[MAXPATHLEN];
  return open (decode_path (path, buffer), flag, mode);
}

int
mc_access (int path, int mode)
{
  unsigned char buffer[MAXPATHLEN];
  return access (decode_path (path, buffer), mode);
}

int
mc_chmod (int path, int mode)
{
  unsigned char buffer[MAXPATHLEN];
  return chmod (decode_path (path, buffer), mode);
}

/* if system does not have symbolic links, it does not have lstat.
   In that case, use ordinary stat instead.  */

#ifdef S_IFLNK
int
mc_lstat (unsigned char *path, struct stat *st_addr)
{
  unsigned char buffer[MAXPATHLEN];
  return lstat (decode_path (path, buffer), st_addr);
}

int
mc_readlink (unsigned char *path, unsigned char *buf, int size)
{
  unsigned char buffer[MAXPATHLEN], buffer2[MAXPATHLEN+1];
  int nread;

  nread = readlink (decode_path (path, buffer), buffer2, MAXPATHLEN);
  if (nread > 0)
    {
      int len;
      unsigned char *p;

#if 0
      buffer2[nread] = '\0';
#endif
      len = encode_path_1 (buffer2, nread, buffer, sizeof (buffer));
      if (0 <= len && len <= size)
	{
	  bcopy (buffer, buf, len);
	  return len;
	}
    }
  return -1;
}
#endif

#ifndef STAT_IS_XSTAT		/* hir, 1993.10.22 */
int
mc_stat (unsigned char *path, struct stat *st_addr)
#else
int
mc_xstat (int v, unsigned char *path, struct stat *st_addr)
#endif
{
  unsigned char buffer[MAXPATHLEN];
#ifndef STAT_IS_XSTAT		/* hir, 1993.10.22 */
  return stat (decode_path (path, buffer), st_addr);
#else
  return _xstat (v, decode_path (path, buffer), st_addr);
#endif
}

int
mc_unlink (unsigned char *path)
{
  unsigned char buffer[MAXPATHLEN];
  return unlink (decode_path (path, buffer));
}

#ifdef HAVE_RENAME
int
mc_rename (unsigned char *path, unsigned char *newpath)
{
  unsigned char buffer[MAXPATHLEN], buffer2[MAXPATHLEN];
  return rename (decode_path (path, buffer), decode_path (newpath, buffer2));
}
#endif

int
mc_link (unsigned char *path, unsigned char *newpath)
{
  unsigned char buffer[MAXPATHLEN], buffer2[MAXPATHLEN];
  return link (decode_path (path, buffer), decode_path (newpath, buffer2));
}

int
mc_symlink (unsigned char *path, unsigned char *newpath)
{
  unsigned char buffer[MAXPATHLEN], buffer2[MAXPATHLEN];
  return symlink (decode_path (path, buffer), decode_path (newpath, buffer2));
}

int
mc_chdir (unsigned char *path)
{
  unsigned char buffer[MAXPATHLEN];
  return chdir (decode_path (path, buffer));
}

#ifdef MSDOS
#ifndef HAVE_GETWD
unsigned char *
mc_getcwd (
    unsigned char *null,		/* in sysdep.c, always 0. */
    size_t size
)
{
  unsigned char buffer[MAXPATHLEN];
  unsigned char *path;

  path = (unsigned char *) getcwd ((char *)buffer, MAXPATHLEN);
  if (path)
    {
      /* here, shoule be (path == buffer). */
      path = (unsigned char *) malloc (MAXPATHLEN);
      if (path)
	{
	  int len;
	  int buffer_length = strlen (buffer) + 1;

	  len = encode_path_1 (buffer, buffer_length, path, MAXPATHLEN);
	  if (len < 0)
	    {
	      /* conversion failed.  use value that is returned from system. */
	      bcopy (buffer, path, buffer_length);
	    }
	}
    }
  return path;
}
#else /* HAVE_GETWD */
unsigned char *
mc_getwd (unsigned char path[])
{
  unsigned char *p;
 
  p = getwd (path);
  if (p)
    {
      unsigned char buffer[MAXPATHLEN];
      int len;
      
      len = encode_path_1 (path, strlen (path) + 1, buffer, sizeof buffer);
      if (len > 0)
	{
	  bcopy (buffer, path, len);
	}
    }
  return p;
}
#endif /* HAVE_GETWD */
#endif /* MSDOS */

/* In callproc.c, execvp() is called like this:
 * 	execvp (new_argv[0], new_argv);
 * following implement depends this.
 */
#ifndef NO_MC_EXECVP
void
mc_execvp (unsigned char *path, unsigned char *argv[])
{
  unsigned char buffer[MAXPATHLEN];
  argv[0] = path = decode_path (path, buffer);
  execvp (path, argv);
}
#endif /* !NO_MC_EXECVP */

DIR *
mc_opendir (unsigned char *path)
{
  unsigned char buffer[MAXPATHLEN];
  return opendir (decode_path (path, buffer));
}

/* 1. some s-*.h defines static as null string, so we cannot use it inside */
/*    of the function. */
/* 2. on hpux, should we actually include <ndir.h> instead of <sys/dir.h>? */
#if !defined(SYSV_SYSTEM_DIR) && !defined(hpux)
static DIRENTRY mcpath_directory_entry;
#else /* SYSV_SYSTEM_DIR || hpux */
/* d_name is defined as d_name[1]; */
static struct
{
  DIRENTRY mcpath_directory_entry_header;
  unsigned char d_name_rest[MAXNAMLEN]; /* +1 is included in DIRENTRY. */
} mcpath_directory_entry;
#endif /* SYSV_SYSTEM_DIR || hpux */

DIRENTRY *
mc_readdir (DIR *d)
{
  DIRENTRY *dp;

  dp = readdir (d);
  if (dp)
    {
      int len;
      unsigned char buffer[MAXNAMLEN + 1], *p; /* + 1 for \0. */

#ifdef MCPATH_ASSERT
      assert (NAMLEN(dp) < MAXNAMLEN + 1);
      assert (dp->d_name[NAMLEN(dp)] == 0);
#endif

      len = encode_path_1 (dp->d_name, NAMLEN(dp) + 1,
			   buffer, sizeof (buffer));

      if (len > 0 && len <= MAXNAMLEN + 1) /* len includes \0. */
	{

/* MCPATH_DIRSIZE is a macro to get real size of *dp. */
#if !defined (MCPATH_DIRSIZE)
#  if defined (SYSV_SYSTEM_DIR) || defined (hpux)
#    define MCPATH_DIRSIZE(x) (sizeof (DIRENTRY))
#  else /* !SYSV_SYSTEM_DIR && !hpux */
#    if defined (DIRSIZ)
#      define MCPATH_DIRSIZE(x) (DIRSIZ(x))
#    else /* !DIRSIZ */
       MCPATH_DIRSIZE for your system should be defined in config file.
#    endif /* !DIRSIZ */
#  endif /* !SYSV_SYSTEM_DIR && !hpux */
#endif /* !MCPATH_DIRSIZE */

	  bcopy (dp, &mcpath_directory_entry, MCPATH_DIRSIZE (dp));
	  dp = (DIRENTRY *) &mcpath_directory_entry;

#ifdef MCPATH_ASSERT
	  assert (len <= MAXNAMLEN + 1);
#endif
	  bcopy (buffer, dp->d_name, len);
#ifdef MCPATH_ASSERT
	  assert (dp->d_name[len - 1] == 0);
#endif

#ifdef HAVE_NAMLEN_ENTRY
	  dp->d_namlen = len - 1;
#endif
	}
    }
  return dp;
}

int
syms_of_mcpath (void)
{
  Qpathname_coding_system = intern ("pathname-coding-system");
  Fset_pathname_coding_system (Qnil);

#ifndef MCPATH_NO_BACKWARD_COMPATIBILITY
  Qfile_system_coding_system = intern ("file-system-coding-system");
  Fset (Qfile_system_coding_system, Qnil);
#endif

  defsubr (&Sset_pathname_coding_system);
}
