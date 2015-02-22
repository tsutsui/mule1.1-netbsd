/* Support for Non-ASCII Path Name
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

/* This part cannot be surround with #ifdef emacs, because it is needed */
/* during generate xmakefile. */
#ifndef MCPATH
# define MCPATH
#endif /* !MCPATH */

/* not to confuse while compiling etc/*.c */
#ifdef emacs
#ifdef MCPATH
#  ifndef _MCPATH_H			/* enable to include twice */
#    ifndef MCPATH_SOURCE		/* not to define in mcpath.c */
#      define creat mc_creat
#      ifdef INTERRUPTABLE_OPEN
#        undef open
#      endif /* INTERRUPTABLE_OPEN */
#      define open mc_open
#      define access mc_access
#      define chmod mc_chmod
#      define lstat mc_lstat
#      define readlink mc_readlink
#      ifndef MC_STAT_DEFINED		/* may be defined in fake sys/stat.h */
#        ifdef STAT_IS_XSTAT		/* hir, 1993.10.22 */
#          define _xstat mc_xstat
#        else
#          define stat mc_stat
#        endif
#      endif /* MC_STAT_DEFINED */
#      define unlink mc_unlink
#      ifdef HAVE_RENAME
#        define rename mc_rename
#      endif
#      define link mc_link
#      define symlink mc_symlink
#      define chdir mc_chdir
#      ifdef MSDOS
#        ifndef HAVE_GETWD
#          define getcwd mc_getcwd
#        else /* HAVE_GETWD */
#          define getwd mc_getwd
#        endif /* HAVE_GETWD */
#      endif /* MSDOS */
#      ifndef NO_MC_EXECVP
#        define execvp mc_execvp
#      endif /* !NO_MC_EXECVP */
#      define opendir mc_opendir
#      define readdir mc_readdir
#    endif /* MCPATH_SOURCE */
#  endif /* _MCPATH_H */
#endif /* MCPATH */
#endif /* emacs */
