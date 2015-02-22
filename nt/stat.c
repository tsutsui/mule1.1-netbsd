#include <windows.h>
#include <sys/param.h>
#include <sys/stat.h>

int 
stat (filename, buffer)
     const char *filename;
     struct stat *buffer;
{
  char *new_filename[MAXPATHLEN+1];

  strcpy (new_filename, filename);
  dos_truncate_filename (new_filename);
  
  return _stat ((const char *) new_filename, buffer);
}
