/* getwd.c (emx+gcc) -- Copyright (c) 1992 by Eberhard Mattes */
/* 92.11.4  modified for Mule Ver.0.9.6 
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */

#include <sys/emx.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/param.h>

char *
getwd (buffer)
     char *buffer;
{
  char *p;

  if (buffer == NULL) {
    errno = EINVAL;
    return (NULL);
  }
  if (_getcwd2 (buffer, MAXPATHLEN) < 0) {
    (void)_strncpy (buffer, strerror (errno), MAXPATHLEN);
    return (NULL);
  }
  for (p = buffer; *p != 0; ++p) if (*p == '\\') *p = '/';
  return (strlwr (buffer));
}
