/* s- file for building Emacs on AIX 3.2.
   This is a guess, since AIX 3.2 hasn't been released yet.  */

#include "s-aix3-1.h"

/* Stop m-ibmrs6000.h from defining this.  */
#define SPECIFY_X11R4 1

/* These work in 3.2, and are optimized when string.h is used.  */
#undef index
#undef rindex

/* 93.5.2 by T.Furuhata */
/* Uncomment the following line for AIX 3.2.3E (AIX windows 1.2.3) */
/* #define LIBX11_SYSTEM -lIM -liconv */

/* 93.11.11 by T.Furuhata */
/* Uncomment the following line for AIX 3.2.4 (AIX windows 1.2.4) */
/* #define LIBX11_SYSTEM -lIM -liconv -bI:/usr/lpp/X11/bin/smt.exp */
