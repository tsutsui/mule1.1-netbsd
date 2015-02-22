/* 91.10.18 modified for Nemacs on GO32 by boo@soum.co.jp */
/*
 * @(#)dir.c 1.4 87/11/06	Public Domain.
 *
 *  A public domain implementation of BSD directory routines for
 *  MS-DOS.  Written by Michael Rendell ({uunet,utai}michael@garfield),
 *  August 1897
 *  Modified to use modern MS C library functions by Kai Uwe Rommel
 *  Ported to OS/2 by Kai Uwe Rommel
 *  December 1989
 */

#include <sys/stat.h>
#ifdef __TURBOC__
# include <alloc.h>
# include <dir.h>
#else /* MS-C or GCC */
# include <malloc.h>
#endif
#include <string.h>
#ifdef OS2
# define INCL_NOPM
# include <os2.h>
#else /* DOS */
# include <dos.h>
#endif
#ifdef GO32
#include <dir.h>
#include "sys/dir.h"
#endif

/* boo@soum.co.jp patched */
#undef NULL
#define NULL 0

#ifndef	MAXPATHLEN
# define MAXPATHLEN	255
#endif	/* MAXPATHLEN */

/* attribute stuff */
#define	A_RONLY		0x01
#define	A_HIDDEN	0x02
#define	A_SYSTEM	0x04
#define	A_LABEL		0x08
#define	A_DIR		0x10
#define	A_ARCHIVE	0x20

#define Newisnull(a, t) ((a = (t *) malloc(sizeof(t))) == (t *) NULL)

/* #define ATTRIBUTES	(A_DIR) */
#define ATTRIBUTES	(A_DIR | A_HIDDEN | A_SYSTEM)
/* #define ATTRIBUTES	(A_RONLY | A_SYSTEM | A_DIR) */

static  char    *getdirent(char *);
static	void	free_dircontents(struct _dircontents *);

#ifndef OS2
#if defined(__TURBOC__) || defined(MSDOS)
#define	_dos_findfirst(p, a, b)	findfirst((p), (b), (a))
#define	_dos_findnext(p)	findnext(p)
#define	find_t	ffblk
#define ffname	ff_name
#else /* MS-C */
#define ffname	name
#endif
static struct find_t find;
#else /* OS2 */
static HDIR hdir;
static USHORT count;
static FILEFINDBUF find;
#endif

DIR	*
opendir(name)
     char	*name;
{
  struct		stat		statb;
  DIR			*dirp;
  char			c;
  char			*s;
  struct _dircontents	*dp;
  char			nbuf[MAXPATHLEN + 1];

#ifdef MSDOS
  if (strcmp (name, ".") && strcmp (name, "..") &&
      strcmp  (name, "/") && strcmp (name + 1, ":/"))
    if (stat(name, &statb) < 0 || (statb.st_mode & S_IFMT) != S_IFDIR)
      return (DIR *) NULL;
#else
  if (stat (name, &statb) < 0 || (statb.st_mode & S_IFMT) != S_IFDIR)
    return (DIR *) NULL;
#endif
  if (Newisnull(dirp, DIR))
    return (DIR *) NULL;
#ifdef MSDOS
  if (*name && name[strlen (name) - 1] != '/')
    (void) strcat (strcpy (nbuf, name), "/*.*");
#else
  if (*name && (c = name[strlen(name) - 1]) != '\\' && c != '/')
    (void) strcat(strcpy(nbuf, name), "\\*.*");
#endif
  else
    (void) strcat(strcpy(nbuf, name), "*.*");
  dirp->dd_loc = 0;
  dirp->dd_contents = dirp->dd_cp = (struct _dircontents *) NULL;

  if ((s = getdirent(nbuf)) == (char *) NULL)
    return dirp;
  do {
    if (Newisnull(dp, struct _dircontents) ||
	(dp->_d_entry = malloc((unsigned) (strlen(s) + 1))) == (char *) NULL)
      {
	if (dp)
	  free((char *) dp);
	free_dircontents(dirp->dd_contents);
	return (DIR *) NULL;
      }
    if (dirp->dd_contents)
      dirp->dd_cp = dirp->dd_cp->_d_next = dp;
    else
      dirp->dd_contents = dirp->dd_cp = dp;
    (void) strcpy(dp->_d_entry, s);
    dp->_d_next = (struct _dircontents *) NULL;
  } while ((s = getdirent((char *) NULL)) != (char *) NULL);

  dirp->dd_cp = dirp->dd_contents;
  
  return dirp;
}

void
closedir(dirp)
	DIR	*dirp;
{
	free_dircontents(dirp->dd_contents);
	free((char *) dirp);
}

struct direct	*
readdir(dirp)
	DIR	*dirp;
{
	static	struct direct	dp;

	if (dirp->dd_cp == (struct _dircontents *) NULL)
		return (struct direct *) NULL;
	dp.d_namlen = dp.d_reclen =
		strlen(strcpy(dp.d_name, dirp->dd_cp->_d_entry));
#ifdef MSDOS
	{
	  register int i;
	  for (i = 0; i < dp.d_namlen; i++)
	    dp.d_name[i] = tolower(dp.d_name[i]);
        }
#endif
	dp.d_ino = 0;
	dirp->dd_cp = dirp->dd_cp->_d_next;
	dirp->dd_loc++;

	return &dp;
}

void
seekdir(dirp, off)
	DIR	*dirp;
	long	off;
{
	long			i = off;
	struct _dircontents	*dp;

	if (off < 0)
		return;
	for (dp = dirp->dd_contents ; --i >= 0 && dp ; dp = dp->_d_next)
		;
	dirp->dd_loc = off - (i + 1);
	dirp->dd_cp = dp;
}

long
telldir(dirp)
	DIR	*dirp;
{
	return dirp->dd_loc;
}

static	void
free_dircontents(dp)
	struct	_dircontents	*dp;
{
	struct _dircontents	*odp;

	while (dp) {
		if (dp->_d_entry)
			free(dp->_d_entry);
		dp = (odp = dp)->_d_next;
		free((char *) odp);
	}
}

static char *getdirent(dir)
char *dir;
{
  int done;

  if (dir != (char *) NULL)
#ifndef OS2
    done = _dos_findfirst(dir, ATTRIBUTES, &find);
#else /* OS2 */
  {                                     /* get first entry */
    hdir = HDIR_CREATE;
    count = 1;
    done = DosFindFirst(dir, &hdir, ATTRIBUTES,
                        &find, sizeof(find), &count, 0L);
  }
#endif
  else                                  /* get next entry */
#ifndef OS2
    done = _dos_findnext(&find);
#else /* OS2 */
    done = DosFindNext(hdir, &find, sizeof(find), &count);
#endif

  if (done==0)
#ifndef OS2
    return find.ffname;
#else /* OS2 */
    return find.achName;
#endif
  else
#ifndef OS2
    return (char *) NULL;
#else /* OS2 */
  {
    DosFindClose(hdir);
    return (char *) NULL;
  }
#endif
}
