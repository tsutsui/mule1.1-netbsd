#include <windows.h>
#include <sys/param.h>

int 
open (filename, oflag, pmode)
     const char *filename;
     int oflag;
     int pmode;
{
  char new_filename[MAXPATHLEN+1];

  strcpy (new_filename, filename);
  dos_truncate_filename (new_filename);

  return _open (new_filename, oflag, pmode);
}
