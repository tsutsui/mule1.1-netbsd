#include <windows.h>
#include <sys/stat.h>

int 
fstat (handle, buffer)
     int handle;
     struct stat *buffer;
{
  return _fstat (handle, buffer);
}
