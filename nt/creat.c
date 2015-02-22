#include <windows.h>
#include <sys/param.h>

int 
creat (filename, pmode)
     const char *filename;
     int pmode;
{
  char new_filename[MAXPATHLEN+1];

  strcpy (new_filename, filename);
  dos_truncate_filename (new_filename);

  return _creat (new_filename, pmode);
}
