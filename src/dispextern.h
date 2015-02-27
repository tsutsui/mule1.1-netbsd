/* Interface definitions for display code.
   Copyright (C) 1985, 1990 Free Software Foundation, Inc.

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

/* 89.2.9   modified for Nemacs Ver.3.0 by K.Handa */
/* 89.11.24 modified for attribute of characters by K.Handa */
/*	Currently supported attributes are underline and inverse. */
/* 91.10.19 modified for Nemaacs Ver.4.0.0 by K.Handa (handa@etl.go.jp) */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/*	Now bold-face is also supported. */
/* 92.4.15  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Size of message_buf is widen to (screen_width * 3) + 1. */
/* 92.9.8   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Format of matrix->contents changed. */
/* 92.10.19 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	MTRX_COMPOSE should not directly shift str[n]. */
/* 92.11.9  modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	MTRX_CMPCHAR is used to check a composite character. */
/* 93.1.13  modified for Mule Ver.0.9.7.1 by T.Enami <enami@sys.ptg.sony.co.jp>
	MTRX_CMPCHAR should consern DATA_SEG_BITS. */
/* 93.4.11  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Add MTRX_REV_DIR to highlight anti-direction characters.  */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	Merge highlight and double cursor.
	Change the value of MTRX_CMPPTR_MASK for MTRX_REV_DIR.
	Double cursor support. */
/* 93.6.21  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Composite chars are stored in cmp_char_table. */

/* Nonzero means do not assume anything about current
 contents of actual terminal screen */

extern int screen_garbaged;

/* Desired terminal cursor position (to show position of point),
 origin zero.  */

extern int cursor_hpos, cursor_vpos;

/* 93.5.22 Y.Niibe for double cursor */
#define CURSOR_LEFT        0x0
#define CURSOR_RIGHT       0x1
#define CURSOR_DOUBLE      0x2
extern int cursor_form;
extern int cursor_hpos_rev;
/* end of patch */

/* Nonzero means last display completed
   and cursor is really at cursor_hpos, cursor_vpos.
   Zero means it was preempted. */

extern int display_completed;

/* Nonzero while trying to read keyboard input at main program level.  */

extern int waiting_for_input;

/* 92.12.6 by K.Handa */
/* Maximum bytes required in cmp_chars for one composite char.
   Maximum bytes for one character is 4.
   Maximum 16 characters can be composed into one composite char.
   Within the area cmp_chars, we need additional 2 bytes:
   one preceeding byte for attribute information, and
   one succeeding byte for '\0' termination.
   So, (4 * 16) + 2 => 66.  */
#define CMP_CHAR_SIZE 66

struct matrix
{
  /* Height of this matrix.  */
  int height;
  /* Width of this matrix.  */
  int width;
  /* Vector of used widths of lines, indexed by vertical position.  */
  int *used;
  /* Vector of line contents.
     m->contents[V][H] is the character at position V, H.
     Note that ->contents[...][screen_width] is always 0
     and so is ->contents[...][-1].  */
  unsigned int **contents;	/* 91.10.19 by K.Handa */
  /* Long vector from which the line contents are taken.  */
  unsigned int *total_contents; /* 91.10.19 by K.Handa */
  /* Vector indicating, for each line, whether it is highlighted.  */
  char *highlight;
  /* Vector indicating, for each line, whether its contents mean anything.  */
  char *enable;
  /* Index to access cmp_char_table. */
  int *cmp_char_idx;		/* 93.6.21 by K.Handa */
};

/* 93.6.21 by K.Handa */
/* Vector of composite chars at each line.
   If MTRX_CMPCHAR (m->contents[V][H]), MTRX_CMPPTR (m->contents[V][H])
   is an index to cmp_char_table.
   In a buffer, a composite character is represented as
	LCCMP LC' C1 LC' C1 C2 ...  (LCCMP = 0x80, LC' = LC + 0x20),
   but in cmp_chars, it is represented as
	ATTR_INFO LC' C1 LC' C1 C2 ... \0.
  The area for each line is dynamically 'malloc'ed/'free'd. */
extern unsigned char **cmp_char_table;
#define CMP_CHAR_TABLE(m,v) cmp_char_table[(m)->cmp_char_idx[v]]

/* patch by K.Handa 91.10.19, 92.11.9 */
/* Masks for matrix->contents */
#define MTRX_CMPCHAR_MASK 0x80000000
#define MTRX_CMPPTR_MASK1 0x00FFF000 /* 93.6.21 by K.Handa */
#define MTRX_CMPPTR_MASK2 0x00000FFF /* 93.6.21 by K.Handa */
#define MTRX_ORDER_MASK	0x40000000
#define MTRX_ATTR_MASK	0x3C000000
#define MTRX_LC_MASK	0x00FF0000
#define MTRX_CODE_MASK	0x0000FFFF
#define MTRX_CODEH_MASK	0x0000FF00
#define MTRX_CODEL_MASK	0x000000FF

#define MTRX_FIRST	0x00000000
#define MTRX_REST	0x40000000
#define MTRX_UNDERLINE	0x04000000
#define MTRX_INVERSE	0x08000000
#define MTRX_BOLD	0x10000000
#define MTRX_REV_DIR	0x20000000

#define MTRX_CMPCHAR(m) ((unsigned int)(m) & MTRX_CMPCHAR_MASK)
#define MTRX_CMPPTR(m) \
  (cmp_char_table[((m) & MTRX_CMPPTR_MASK1) >> 12] \
   + ((m) & MTRX_CMPPTR_MASK2) * CMP_CHAR_SIZE)
#define MTRX_COMPOSE_CMPPTR(m,v,h) ((m->cmp_char_idx[v] << 12) | h)
#define MTRX_ORDER(m) ((m) & MTRX_ORDER_MASK)
#define MTRX_LC(m) (MTRX_CMPCHAR(m) ? LCCMP : (((m) >> 16) & 0xFF))
/* The following macros can be used only when !MTRX_CMPCHAR(m) */
#define MTRX_ATTR(m) (((m) >> 26) & 0x7F)
#define MTRX_CODEH(m) (((m) >> 8) & 0xFF)
#define MTRX_CODEL(m) ((m) & 0xFF)
#define MTRX_UNDERLINE2 0x01
#define MTRX_INVERSE2	0x02
#define MTRX_BOLD2	0x04
#define MTRX_REV_DIR2	0x08

#define MTRX_COMPOSE(c,str,attr) { \
  if (ASCII_P(str[0])) c = str[0]; \
  else if (str[0] < 0x90) c = str[0], c = (c << 16) | str[1]; \
  else if (str[0] < 0x9A) c = str[0], c = (c<<8)|str[1], c = (c<<8)|str[2]; \
  else if (str[0] < 0x9C) c = str[1], c = (c << 16) | str[2]; \
  else c = str[1], c = (c << 8) | str[2], c = (c << 8) | str[3]; \
  c |= attr; \
}

#define MTRX_DECOMPOSE(m,attr,lc,c0,c1) \
  attr = MTRX_ATTR(m), \
  lc = ((m) >> 16) & 0xFF, \
  c0 = MTRX_CODEH(m), \
  c1 = MTRX_CODEL(m)
/* end of patch */

/* Current screen contents.  */
extern struct matrix *current_screen;
/* Screen contents to be displayed.  */
extern struct matrix *new_screen;
/* Temporary buffer for screen contents.  */
extern struct matrix *temp_screen;

/* Get ready to display on screen line VPOS at column HPOS
   and return the string where the text of that line is stored.  */

unsigned int *get_display_line (int, int); /* 91.10.19 by K.Handa */

/* 92.12.7 by K.Handa */
/* Store a composite character to cmp_char_table.
   If the area is not allocated, allocate it.
   The return value is a pointer to the stored composite char. */
unsigned int store_composite_char(struct matrix *, int, int, unsigned char *, int);

int timeval_subtract (struct timeval *, struct timeval, struct timeval);

/* Buffer used by `message' for formatting a message, and by print.c.  */
extern char *message_buf;
#define MSG_BUF_SIZE (screen_width * 3)

/* Nonzero means message_buf is being used by print.  */
extern int message_buf_print;

/* Message to display instead of minibuffer contents
   This is what the functions error and message make,
   and command echoing uses it as well.
   It overrides the minibuf_prompt as well as the buffer.  */
extern char *echo_area_contents;

/* All costs measured in characters.
   So no cost can exceed the area of a screen, measured in characters.
   This should not be more than million.
   Meanwhile, we can add lots of millions together without overflow.  */

#define INFINITY 1000000

/* 93.4.13 K.Handa -- Nonzero means highlight anti-direction characters. */
extern int highlight_reverse_direction;
/* 93.5.22 Y.Niibe -- Nonzero means display double cursor */
extern int r2l_double_cursor;
