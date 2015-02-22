/* PURESIZE definition file
   Copyright (C) 1992 Free Software Foundation, Inc.

This file is part of Mule (MULtilingual Enhancement of GNU Emacs).

Mule is free software distributed in the form of patches to GNU Emacs.
You can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

Mule is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. */

/* 90.2.27  created for Nemacs Ver.3.3.1 by K.Handa */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.25  modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	PURESIZE increased for non EGG system. */
/* 92.4.30  modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
	PURESIZE increased again for non EGG system. */
/* 92.5.15  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	PURESIZE increased again for non X window system. */
/* 92.8.5   modified for Mule Ver.0.9.5.1 by M.Minda <minmin@astec.co.jp>
	Modified for CANNA. */
/* 93.5.4   modified for Mule Ver.0.9.8
   				by S.Komeda <komeda@ics.es.osaka-u.ac.jp>
	PURESIZE increased for SJ3 with EGG. */
/* 93.5.4   modified for Mule Ver.0.9.8 by Y.Hirose <yuuji@ae.keio.ac.jp>
	Comment for CANNA corrected. */
/* 93.7.14  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	PURESIZE decreased for EGG on Wnn. */

#undef PURESIZE

#ifdef EGG
#define EGG_PURESIZE 30000 /* egg */
#else
#define EGG_PURESIZE 0
#endif

#ifdef SJ3
#define SJ3_PURESIZE 31000 /* sj3 additional size to egg */
#else
#define SJ3_PURESIZE 0
#endif

#ifdef CANNA
# define CANNA_PURESIZE 10000  /* canna */
#else
# define CANNA_PURESIZE 0
#endif

#define PURESIZE_BASE (200000 + EGG_PURESIZE + SJ3_PURESIZE + CANNA_PURESIZE)

#ifndef LISP_OBJECT_BITS
#define LISP_OBJECT_BITS 32
#endif

/* In 64 bit environment, PURESIZE should be multiplied by about 1.6. */

#ifndef PURESIZE_RATE
#if LISP_OBJECT_BITS > 32
#define PURESIZE_RATE 8/5	/* Don't surround with `()'. */
#else
#define PURESIZE_RATE 1
#endif
#endif

#define PURESIZE (PURESIZE_BASE * PURESIZE_RATE)
