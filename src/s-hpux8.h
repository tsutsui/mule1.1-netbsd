/* s- file for hpux version 8.
   This contains changes that were suggested "for the hp700".
   They were not needed for the 800.
   Our conjecture that they are needed for hpux version 8,
   which is what runs on the 700.  */

/* 93.7.17  modified for Mule Ver.0.9.8 by K.Sakai <ksakai@mtl.t.u-tokyo.ac.jp>
	Modified for X11R5. */

#include "s-hpux7.h"

#define C_SWITCH_SYSTEM -I/usr/include/X11R5 -I/usr/include/X11R4

/* Don't use shared libraries.  unexec doesn't handle them.  */
#ifdef __GNUC__
#define LD_SWITCH_SYSTEM -Xlinker -a -Xlinker archive  -L/usr/lib/X11R5 -L/usr/lib/X11R4
#else
#define LD_SWITCH_SYSTEM -a archive  -L/usr/lib/X11R5 -L/usr/lib/X11R4
#endif

/* Some hpux 8 machines seem to have TIOCGWINSZ,
   and none have sioctl.h, so might as well define this.  */
#define NO_SIOCTL_H

/* Specify compiler options for compiling oldXMenu.  */
#define OLDXMENU_OPTIONS CFLAGS="-I/usr/include/X11R5 -I/usr/include/X11R4"

#undef NO_X_DESTROY_DATABASE
