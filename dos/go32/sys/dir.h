/* Demacs 1.1.2 91/10/20 Manabu Higashida	*/
/*
 * @(#) dir.h 1.4 87/11/06   Public Domain.
 *
 *  A public domain implementation of BSD directory routines for
 *  MS-DOS.  Written by Michael Rendell ({uunet,utai}michael@garfield),
 *  August 1897
 *  Ported to OS/2 by Kai Uwe Rommel and added scandir prototype
 *  December 1989
 */

#if defined(__TURBOC__)
typedef	unsigned short	ino_t;
#else
#include <sys/types.h>
#endif

#define	rewinddir(dirp)	seekdir(dirp, 0L)

#define	MAXNAMLEN	12

struct direct
{
	ino_t	d_ino;			/* a bit of a farce */
	int	d_reclen;		/* more farce */
	int	d_namlen;		/* length of d_name */
        char    d_name[MAXNAMLEN + 1];  /* garentee null termination */
};

struct _dircontents
{
	char	*_d_entry;
	struct _dircontents	*_d_next;
};

typedef struct _dirdesc
{
	int		dd_id;	/* uniquely identify each open directory */
	long		dd_loc;	/* where we are in directory entry is this */
	struct _dircontents	*dd_contents;	/* pointer to contents of dir */
	struct _dircontents	*dd_cp;	/* pointer to current position */
} DIR;

extern  DIR            *opendir(char *);
extern  struct direct  *readdir(DIR *);
extern  void            seekdir(DIR *, long);
extern  long            telldir(DIR *);
extern  void            closedir(DIR *);

extern  int             scandir(char *, struct direct ***,
                                int (*)(struct direct *), int (*)());
