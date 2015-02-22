/* Fake stat.h to define stat to mc_stat.
   Copyright (C) 1985, 1986 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

#ifndef _FAKE_STAT_H
#  define _FAKE_STAT_H
/* We can't include mcpath.h here.  Because open will be defined in s-*.h */
#  ifndef MCPATH_SOURCE
#    ifdef STAT_IS_XSTAT		/* hir, 1993.10.22 */
#      define _xstat mc_xstat
#    else
#      define stat mc_stat
#    endif
#    define MC_STAT_DEFINED
#  endif /* !MCPATH_SOURCE */
#  ifndef SYSTEM_STAT_H
#    if __GNUC__ > 1
#      include <sys/stat_gcc2.h>
#    else  /* !(__GNUC__ > 1) */
#      include "/usr/include/sys/stat.h"
#    endif /* !(__GNUC__ > 1) */
#  else /* SYSTEM_STAT_H */
#    include SYSTEM_STAT_H
#  endif /* SYSTEM_STAT_H */
#endif /* _FAKE_STAT_H */
