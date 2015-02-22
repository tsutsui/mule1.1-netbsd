#include <windows.h>
#include <sys/param.h>

int 
unlink (filename)
     const char *filename;
{
  char new_filename[MAXPATHLEN+1];

  strcpy (new_filename, filename);
  dos_truncate_filename (new_filename);

  return _unlink (new_filename);
}
