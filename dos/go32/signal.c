/* This is file `signal.c'

Copyright (C) 1992 M.Kobayashi (EastWind)

  This file is distributed under the conditions described in the
GNU CC General Public License.   A copy of this license is
supposed to have been given to you along with GNU CC so you
can know your rights and responsibilities.  It should be in a
file named COPYING.  Among other things, the copyright notice
and this notice must be preserved on all copies.  
*/

#include <signal.h>
#include <dos.h>

extern void	_sigint_service ();
SignalHandler	_sigint_func = SIG_DFL;
static SignalHandler	_sigvector[SIGMAXIMUM];
int	_sigint_val=SIGINT;

SignalHandler 
signal (sig, action)
     int sig;
     SignalHandler action;
{
  union REGS r;
  SignalHandler old_func;

  r.h.ah = 0x30;        /* get DOS version */
  r.x.bx = 0x474F3332;  /* "GO32" */
  intdos (&r,&r);
  if (((r.x.bx & 0x80000000) == 0) &&
      ((r.x.cx & 0x0000FFFF) != 0x3938)) return SIG_ERR;  /*version check */
  if (sig < SIGNO && sig >= SIGMAXIMUM) return SIG_ERR;
  old_func = _sigvector[sig];
  _sigvector[sig] = action;
	
  switch (sig)	
    {
    case  SIGINT:
      _sigint_func = _sigvector[SIGINT];
      switch ((int) action) 
	{
	case (int) SIG_DFL:
	case (int) SIG_ERR:
	  r.x.dx = 0;
	  break;
	default:
	  r.x.dx = (int) _sigint_service;
	  break;
	}
      r.h.ah = 0x25;  /* int 21h ah=25h : setvect */
      r.h.al = 0x23;  /* Ctrl-C vector */
      intdos (&r, &r);
      /* Pseudo set vector routine (really this tells the SIGINT service 
	 function address to GO32, the vector would not be set) */
      return old_func;
    default:
      return SIG_ERR; /* not yet installed */
    }
}

void 
_sigint_reset ()
{
  signal (SIGINT, SIG_DFL);
}

int 
raise (sig)
     int sig;
{
  switch (sig)	
    {
    case  SIGINT:
      if (_sigvector[SIGINT] == SIG_DFL)
	exit(3);
      else
	_sigint_service ();
    default:
      /* nothing done */
    }
}

set_hot_key (c)
     int c;
{
  union REGS r;
	
  r.h.ah = 0x30;        /* get DOS version */
  r.x.bx = 0x474F3332;  /* "GO32" */
  intdos (&r, &r);
  if (((r.x.bx & 0x80000000) == 0) &&
      ((r.x.cx & 0x0000FFFF) != 0x3938)) return;  /* version check */
  r.x.dx = 0xffffffff;
  r.x.bx = 1;
  r.x.cx = c;   /* hot key data */
	
  r.h.ah = 0x25;  /* int 21h ah=25h : setvect */
  r.h.al = 0x23;  /* Ctrl-C vector */
  intdos (&r,&r);
}
