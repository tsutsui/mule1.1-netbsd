#include <windows.h>
#include <sys/param.h>
#include <sys/stat.h>

int 
access (filename, mode)
     const char *filename;
     int mode;
{
  char *new_filename[MAXPATHLEN+1];

  strcpy (new_filename, filename);
  dos_truncate_filename (new_filename);
  
  return _access (new_filename, mode);
}
