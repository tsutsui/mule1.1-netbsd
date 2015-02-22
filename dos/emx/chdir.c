/* chdir.c (emx+gcc) -- Copyright (c) 1990-1992 by Eberhard Mattes */
/* 92.11.4  modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */

#include <sys/emx.h>
#include <stdlib.h>
#include <string.h>

int 
chdir (name)
     const char *name;
{
  int i;
  char *tmp;

  i = strlen (name);
  if (i > 1 && (name[i-1] == '\\' || name[i-1] == '/') &&
      (name[i-2] != '\\' && name[i-2] != '/' && name[i-2] != ':'))
    {
      tmp = alloca (i);
      (void)memcpy (tmp, name, i);
      tmp[i-1] = 0;
      name = tmp;
    }
  return (_chdir2 (name));
}
