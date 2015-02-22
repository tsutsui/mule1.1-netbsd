#include <windows.h>

int
pipe (fd)
     int fd[2];
{
  SECURITY_ATTRIBUTES saAttr;
  
  /* Set bInheritHandle flag so pipe handles are iherited */
  saAttr.nLength = sizeof (SECURITY_ATTRIBUTES);
  saAttr.bInheritHandle = TRUE;
  saAttr.lpSecurityDescriptor = 0;
  
  return CreatePipe ((HANDLE *) &fd[0], (HANDLE *) &fd[1], &saAttr, 0);
}
