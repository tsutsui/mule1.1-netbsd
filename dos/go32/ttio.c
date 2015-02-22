#include <dos.h>

static int dos_version;	/* MS-DOS version number.   */
static int break_stat;	/* BREAK check mode status. */
static int stdin_stat;	/* stdin IOCTRL status.	    */
static int stdout_stat;	/* stdout IOCTRL status.    */

/*
 * Ng 1.3 90/02/11 S.Yoshida
 * This function sets the Ctrl-C check function off.
 */
int
tty_raw() 
{
  union REGS inregs, outregs;

  inregs.h.ah = 0x30;		/* Check MS-DOS version. */
  intdos (&inregs, &outregs);
  dos_version = outregs.h.al;
	
  if (dos_version > 1)
    {
      inregs.h.ah = 0x33;	/* Get BREAK check status. */
      inregs.h.al = 0x00;
      intdos (&inregs, &outregs);
      break_stat = outregs.h.dl;

      inregs.h.al = 0x01;	/* Set BREAK check status to */
      inregs.h.dl = 0x00;	/* no BREAK checking.	     */
      intdos (&inregs, &outregs);
      if (outregs.h.al == 0xff)
	{
	  return 0;
	}
      
      {
        inregs.h.ah = 0x44;     /* IOCTRL */
        {
          inregs.x.bx = 0x00;	/* 0 = stdin. */

          inregs.h.al = 0x00;	/* Get IOCTRL status. */
          intdos (&inregs, &outregs);
          stdin_stat = outregs.h.dl;

	  /* 0x20 = 0010 0000 in binary */
	  /* 0x27 = 0010 0111 in binary */
          inregs.h.al = 0x01;     /* Set IOCTRL status. */
          inregs.x.dx = (outregs.x.dx | 0x0020) & 0x0027; /* raw mode */
          intdos (&inregs, &outregs);
          if (outregs.x.cflag != 0x00)
	    return 0;
	}
#if 0
        {
          inregs.x.bx = 0x01;	/* 1 = stdout. */

          inregs.h.al = 0x00;	/* Get IOCTRL status. */
          intdos (&inregs, &outregs);
          stdout_stat = outregs.h.dl;

          inregs.h.al = 0x01;     /* Set IOCTRL status. */
          inregs.x.dx = (outregs.x.dx | 0x0020) & 0x0027; /* raw mode */
          intdos (&inregs, &outregs);
          if (outregs.x.cflag != 0x00)
	    return 0;
        }
#endif
      }
    }
  else
    {
      return 0;
    }
  return 1;
}

/*
 * Ng 1.3 90/02/11 S.Yoshida
 * This function reset Ctrl-C check function on.
 */
int
tty_reset() 
{
  union REGS inregs, outregs;

  if (dos_version > 1)
    {
      inregs.h.ah = 0x33;	/* Reset BREAK check status. */
      inregs.h.al = 0x01;
      inregs.h.dl = break_stat;
      intdos (&inregs, &outregs);
      if (outregs.h.al == 0xff)
	{
	  return 0;
	}

      inregs.h.ah = 0x44;	/* Reset IOCTRL status.	*/
      inregs.h.al = 0x01;

      inregs.x.bx = 0x00;	/* 0 = stdin.		*/
      inregs.x.dx = stdin_stat & 0x7;
      intdos (&inregs, &outregs);
      if (outregs.x.cflag != 0x00)
        return 0;

#if 0
      inregs.x.bx = 0x01;	/* 1 = stdout.		*/
      inregs.x.dx = stdout_stat & 0x7;
      intdos (&inregs, &outregs);
      if (outregs.x.cflag != 0x00)
        return 0;
#endif 0
    }
  return 1;
}
