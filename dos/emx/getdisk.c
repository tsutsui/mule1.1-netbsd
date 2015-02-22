#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <sys/param.h>

int 
getdisk () 
{ 
  return (int) (_getdrive () - 'A'); 
}
