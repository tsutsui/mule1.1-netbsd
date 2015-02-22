#include <dos.h>

int
setdisk (drv)
     int drv;
{
  union REGS regs;
#if 0
#else
  {
    char *temp = "x:/";
    int s;
    
    temp[0] = 'a' + drv;
    s = access (temp, 0);
    if (s < 0) return -1; /* Caution: DJ's GCC is buggy with optimization. */
  }
#endif 0

  regs.h.ah = 0x0e;
  regs.x.dx = drv;
  intdos (&regs, &regs);
  return (regs.h.al > 0 ? regs.h.al : 0);
}
