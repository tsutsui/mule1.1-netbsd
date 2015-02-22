#include <dos.h>

int
getdisk ()
{
  union REGS regs;

  regs.h.ah = 0x19;
  regs.x.dx = 0x00;
  intdos (&regs, &regs);
  return (int) regs.h.al;
}
