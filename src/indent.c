/* Indentation functions.
   Copyright (C) 1985, 1986, 1987, 1988, 1990 Free Software Foundation, Inc.

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

/* 87.4.16  modified by K.Handa */
/* 87.7.12  modified by K.Handa */
/* 87.12.10 modified for Nemacs Ver.2.0 by K.Handa */
/* 88.5.30  modified for Nemacs Ver.2.1 by K.Handa */
/* 89.3.10  modified for Nemacs Ver.3.0 by K.Handa */
/* 89.9.7   modified for Nemacs Ver.3.2 by K.Handa */
/* 89.12.23 modified for Nemacs Ver.3.2.3 by K.Handa
	In compute_motion, fixed a bug of handling truncated lines. */
/* 90.4.10  modified for Nemacs Ver.3.3.2 by K.Handa
	Make compatible with original when kanji-flag is off. */
/* 91.10.27 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.21  modified for Mule Ver.0.9.1
   by K.Handa <handa@etl.go.jp> and Y.Niibe <gniibe@mri.co.jp>
	current_column() and compute_motion() is changed for handling
	multi-column character. */
/* 92.3.27  modified for Mule Ver.0.9.2 by Y.Niibe <gniibe@mri.co.jp>
	In compute_motion, 'continue' is inserted to skip unnecessary code. */
/* 92.4.1   modified for Mule Ver.0.9.2 by Y.Niibe <gniibe@mri.co.jp>
	Calculation of tab_offset is fixed. */
/* 92.4.30  modified for Mule Ver.0.9.4 by Y.Niibe  <gniibe@mri.co.jp>
	Fmove_to_column() handles invalid multi-byte chars correctly. */
/* 92.9.9  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	current_column(), Fmove_to_column(), and compute_motion() are
	modified for private char-sets. */
/* 92.11.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Composite character is supported. */
/* 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
        Preliminary support (92.8.2) for right-to-left languages. */
/* 93.2.28  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In compute_motion(), line continuation in minibuffer
	is handled correctly. */
/* 93.4.8   modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	Buf fixed in compute_motion(). */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	compute_motion(): full support for composite character and
	private char-sets, and right-to-left char-sets. */

#include "config.h"
#include "lisp.h"
#include "buffer.h"
#include "indent.h"
#include "window.h"
#include "termchar.h"
#include "termopts.h"
#include "mule.h"		/* 91.10.27 by K.Handa */

#define CR '\015'

/* Indentation can insert tabs if this is non-zero;
   otherwise always uses spaces */
int indent_tabs_mode;

#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

/* These three values memoize the current column to avoid recalculation */
/* Some things in set last_known_column_point to -1
  to mark the memoized value as invalid */
/* Last value returned by current_column */
int last_known_column;
/* Value of point when current_column was called */
int last_known_column_point;
/* Value of MODIFF when current_column was called */
int last_known_column_modified;

extern int minibuf_prompt_width;

DEFUN ("current-column", Fcurrent_column, Scurrent_column, 0, 0, 0,
  "Return the horizontal position of point.  Beginning of line is column 0.\n\
This is calculated by adding together the widths of all the displayed\n\
representations of the character between the start of the previous line\n\
and point.  (eg control characters will have a width of 2 or 4, tabs\n\
will have a variable width)\n\
Ignores finite width of screen, which means that this function may return\n\
values greater than (screen-width).\n\
Whether the line is visible (if `selective-display' is t) has no effect.")
  (void)
{
  Lisp_Object temp;
  XFASTINT (temp) = current_column ();
  return temp;
}

/* Cancel any recorded value of the horizontal position.  */

void
invalidate_current_column (void)
{
  last_known_column_point = 0;
}

int
current_column (void)
{
  register int col;
  register unsigned char *ptr, *stop, c;
  register int tab_seen;
  register int post_tab;
  register int tab_width = XINT (current_buffer->tab_width);
  int ctl_arrow = !NILP (current_buffer->ctl_arrow);
  int mc_flag = !NILP(current_buffer->mc_flag); /* 91.10.27 by K.Handa */
  int non_ascii = 0;		/* 92.3.21 by K.Handa */
  int last_non_ascii;		/* 92.11.11 by K.Handa */

  if (point == last_known_column_point
      && MODIFF == last_known_column_modified)
    return last_known_column;

  /* Make a pointer for decrementing through the chars before point.  */
  ptr = &FETCH_CHAR (point - 1) + 1;
  /* Make a pointer to where consecutive chars leave off,
     going backwards from point.  */
  if (point == BEGV)
    stop = ptr;
  else if (point <= GPT || BEGV > GPT)
    stop = BEGV_ADDR;
  else
    stop = GAP_END_ADDR;

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;

  col = 0, tab_seen = 0, post_tab = 0;

  while (1)
    {				/* 92.9.9 by K.Handa */
      if (ptr == stop)
	{
	  /* We stopped either for the beginning of the buffer
	     or for the gap.  */
	  if (ptr == BEGV_ADDR)
	    break;
	  /* It was the gap.  Jump back over it.  */
	  stop = BEGV_ADDR;
	  ptr = GPT_ADDR;
	  /* Check whether that brings us to beginning of buffer.  */
	  if (BEGV >= GPT) break;
	}

      c = *--ptr;
      if (c >= 040 && c < 0177)
	{
	  col++;
	}
      else if (c == '\n')
	break;
      else if (c == '\r' && EQ (current_buffer->selective_display, Qt))
	break;
      else if (c == '\t')
	{
	  col += non_ascii * 4, non_ascii = 0;
	  if (tab_seen)
	    col = ((col + tab_width) / tab_width) * tab_width;

	  post_tab += col;
	  col = 0;
	  tab_seen = 1;
	}
      else if (mc_flag && NONASCII_P(c)) /* 92.3.21 by K.Handa */
	non_ascii++, last_non_ascii = c;
      else if (mc_flag && LC_P(c)) {
	non_ascii++;
	if (c == LCCMP) {	/* 92.11.15 by K.Handa */
	  unsigned char *p;
	  int bytes;

	  if (non_ascii > 1
	      && non_ascii > (bytes = char_bytes[last_non_ascii - 0x20])) {
	    p = ptr + bytes + 1;
	    non_ascii -= bytes + 1;
	    while (non_ascii) {
	      if (p >= GPT_ADDR && p < GAP_END_ADDR)
		p += current_buffer->text.gap_size;
	      if ((bytes = char_bytes[*p - 0x20]) <= non_ascii)
		p += bytes, non_ascii -= bytes;
	      else
		break;
	    }
	    col += char_width[last_non_ascii - 0x20] + non_ascii * 4;
	  } else
	    col += non_ascii * 4;
	} else {
	  if (char_bytes[c] <= non_ascii)
	    col += char_width[c] + (non_ascii - char_bytes[c]) * 4;
	  else
	    col += non_ascii * 4;
	}
	non_ascii = 0;
      } else
	col += (ctl_arrow && c < 0200) ? 2 : 4;
    }

  col += non_ascii * 4;		/* 92.9.9 by K.Handa */
  if (tab_seen)
    {
      col = ((col + tab_width) / tab_width) * tab_width;
      col += post_tab;
    }

  last_known_column = col;
  last_known_column_point = point;
  last_known_column_modified = MODIFF;

  return col;
}

void
ToCol (int col)
{
  register int fromcol = current_column ();
  register int n;
  register int tab_width = XINT (current_buffer->tab_width);

  if (fromcol > col)
    return;

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;

  if (indent_tabs_mode)
    {
      n = col / tab_width - fromcol / tab_width;
      if (n)
	{
	  while (n-- > 0)
	    insert ("\t", 1);

	  fromcol = (col / tab_width) * tab_width;
	}
    }

  while (fromcol < col)
    {
      insert ("        ", min (8, col - fromcol));
      fromcol += min (8, col - fromcol);
    }

  last_known_column = col;
  last_known_column_point = point;
  last_known_column_modified = MODIFF;
}

DEFUN ("indent-to", Findent_to, Sindent_to, 1, 2, "NIndent to column: ",
  "Indent from point with tabs and spaces until COLUMN is reached.\n\
Always do at least MIN spaces even if that goes past COLUMN;\n\
by default, MIN is zero.")
  (Lisp_Object col, Lisp_Object minimum)
{
  int mincol;
  register int fromcol;
  register int tab_width = XINT (current_buffer->tab_width);

  CHECK_NUMBER (col, 0);
  if (NILP (minimum))
    XFASTINT (minimum) = 0;
  CHECK_NUMBER (minimum, 1);

  fromcol = current_column ();
  mincol = fromcol + XINT (minimum);
  if (mincol < XINT (col)) mincol = XINT (col);

  if (fromcol == mincol)
    return make_number (fromcol);

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;

  if (indent_tabs_mode)
    {
      Lisp_Object n;
      XFASTINT (n) = mincol / tab_width - fromcol / tab_width;
      if (XFASTINT (n) != 0)
	{
	  Finsert_char (make_number ('\t'), n);

	  fromcol = (mincol / tab_width) * tab_width;
	}
    }

  XFASTINT (col) = mincol - fromcol;
  Finsert_char (make_number (' '), col);

  last_known_column = mincol;
  last_known_column_point = point;
  last_known_column_modified = MODIFF;

  XSETINT (col, mincol);
  return col;
}

DEFUN ("current-indentation", Fcurrent_indentation, Scurrent_indentation,
  0, 0, 0,
  "Return the indentation of the current line.\n\
This is the horizontal position of the character\n\
following any initial whitespace.")
  (void)
{
  Lisp_Object val;

  XFASTINT (val) = position_indentation (find_next_newline (point, -1));
  return val;
}

int
position_indentation (register int pos)
{
  register int column = 0;
  register int tab_width = XINT (current_buffer->tab_width);
  register unsigned char *p;
  register unsigned char *stop;

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;

  stop = &FETCH_CHAR (BufferSafeCeiling (pos)) + 1;
  p = &FETCH_CHAR (pos);
  while (1)
    {
      while (p == stop)
	{
	  if (pos == ZV)
	    return column;
	  pos += p - &FETCH_CHAR (pos);
	  p = &FETCH_CHAR (pos);
	  stop = &FETCH_CHAR (BufferSafeCeiling (pos)) + 1;
	}
      switch (*p++)
	{
	case ' ':
	  column++;
	  break;
	case '\t':
	  column += tab_width - column % tab_width;
	  break;
	default:
	  return column;
	}
    }
}

DEFUN ("move-to-column", Fmove_to_column, Smove_to_column, 1, 1, 0,
  "Move point to column COLUMN in the current line.\n\
COLUMN is calculated by adding together the widths of all the displayed\n\
representations of the character between the start of the previous line\n\
and point.  (eg control characters will have a width of 2 or 4, tabs\n\
will have a variable width)\n\
Ignores finite width of screen, which means that this function may be\n\
passed values greater than (screen-width)")
  (Lisp_Object column)
{
  register int pos = point;
  register int col = current_column ();
/* 92.9.9, 92.11.11 by K.Handa */
  register int mc_bytes;
/* end of patch */
  register int goal;
  register int end = ZV;
  register int tab_width = XINT (current_buffer->tab_width);
  register int ctl_arrow = !NILP (current_buffer->ctl_arrow);
  int mc_flag = !NILP(current_buffer->mc_flag); /* 91.10.27 by K.Handa */
  Lisp_Object val;

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;
  CHECK_NUMBER (column, 0);
  goal = XINT (column);
  if (col > goal)
    {
      pos = find_next_newline (pos, -1);
      col = 0;
    }

  while (col < goal && pos < end)
    {
      int c = FETCH_CHAR (pos);
      if (c == '\n')
	break;
      if (c == '\r' && EQ (current_buffer->selective_display, Qt))
	break;
/* 92.4.30, 93.5.22 by Y.Niibe */
      if (c == '\t')
	{
	  col += tab_width;
	  col = col / tab_width * tab_width;
	  pos++;
	}
      else if (c >= 040 && c < 0177)
	col++, pos++;
      else
	if (mc_flag)  /* 91.10.27,92.9.9,92.11.11 by K.Handa */
	  {
	    int next_pos_if_invalid = ++pos;

	    if (c == LCCMP)
	      {
		if (pos >= end || !NONASCII_P (c = FETCH_CHAR (pos)))
		  col += 4;
		else
		  {
		    pos++;
		    mc_bytes = char_bytes[c - 0x20];
		    if (pos + mc_bytes -1 <= end)
		      while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
			pos++;
		    if (mc_bytes)
		      col += 4,	pos = next_pos_if_invalid;
		    else
		      {
			col += char_width[c - 0x20];

			while (pos < end && NONASCII_P (c = FETCH_CHAR (pos)))
			  {
			    next_pos_if_invalid = pos;
			    pos++;
			    mc_bytes = char_bytes[c - 0x20];
			    if (pos + mc_bytes -1 <= end)
			      while (--mc_bytes
				     && NONASCII_P (FETCH_CHAR (pos)))
				pos++;
			    if (mc_bytes)
			      {
				pos = next_pos_if_invalid;
				break;
			      }
			  }
		      }
		  }
	      }
	    else if (LC_P(c))
	      {
		mc_bytes = char_bytes[c];
		if (pos + mc_bytes -1 <= end)
		  while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
		    pos++;
		if (mc_bytes)
		  col += 4, pos = next_pos_if_invalid;
		else
		  col += char_width[c];
	      }
	    else
	      col += (ctl_arrow && c < 0200) ? 2 : 4;
	  }
	else
	  col += (ctl_arrow && c < 0200) ? 2 : 4, pos++;
/* end of patch */
    }

  SET_PT (pos);

  last_known_column = col;
  last_known_column_point = point;
  last_known_column_modified = MODIFF;

  XFASTINT (val) = col;
  return val;
}

/* 93.5.22 Y.Niibe */
static int c_w_d[2]; /* c_width_on_point and int dir_on_point */

#define set_c_w_d(c_width,dir)    c_w_d[0] = c_width, c_w_d[1] = dir
int *
char_width_dir_on (int pt, int buffer_dir)
{
  register int mc_bytes;
  register unsigned int c;
  int c_width, dir, p;

  if (pt >= ZV)
    {
      set_c_w_d (1, buffer_dir);
      return c_w_d;
    }

  c = FETCH_CHAR (pt);
  p = pt;

  if (c == '\n' || c == '\t')
    set_c_w_d (1, buffer_dir);
  else if (c >= 000 && c < 0200)
    set_c_w_d (1, LEFT_TO_RIGHT);
  else if (c == LCCMP)
    {
      p++;
      if (p >= ZV || !NONASCII_P (c = FETCH_CHAR (p)))
	set_c_w_d (1, LEFT_TO_RIGHT);
      else
	{
	  p++;
	  mc_bytes = char_bytes[c - 0x20];
	  if (pt + mc_bytes -1 <= ZV)
	    while (--mc_bytes && NONASCII_P (FETCH_CHAR (p)))
	      p++;
	  if (mc_bytes)
	    set_c_w_d (1, LEFT_TO_RIGHT);
	  else
	    {
	      c_width = char_width[c - 0x20];
	      dir = char_direction[c - 0x20];
	      if (dir == DIRECTION_UNDEFINED)
		/* fetch extended leading char */
		dir = char_direction[FETCH_CHAR (pt+2)];

	      set_c_w_d (c_width, dir);
	    }
	}
    }
  else if (LC_P (c))
    {
      p++;
      mc_bytes = char_bytes[c];
      if (pt + mc_bytes -1 <= ZV)
	while (--mc_bytes && NONASCII_P (FETCH_CHAR (p)))
	  p++;
      if (mc_bytes)
	set_c_w_d (1, LEFT_TO_RIGHT);

      c_width = char_width[c];
      dir = char_direction[c];
      if (dir == DIRECTION_UNDEFINED)
	/* fetch extended leading char */
	dir = char_direction[FETCH_CHAR (pt+1)];

      set_c_w_d (c_width, dir);
    }
  else
    set_c_w_d (1, LEFT_TO_RIGHT);

  return c_w_d;
}
/* end of patch */

struct position val_compute_motion;

struct position *
compute_motion (  /* 92.8.2 Y.Niibe */
    Lisp_Object_Int from,
    int fromvpos,
    int fromhpos,
    Lisp_Object_Int to,
    Lisp_Object_Int tovpos,
    Lisp_Object_Int tohpos,
    register Lisp_Object_Int width,
    Lisp_Object_Int hscroll,
    int tab_offset,
    int rev_hpos  /* hpos in reverse text */ /* 92.8.2 Y.Niibe */
)
{
  register int hpos = fromhpos;
  register int vpos = fromvpos;

  register Lisp_Object_Int pos;
  register unsigned int c;	/* 92.3.21 by K.Handa */
  register Lisp_Object_Int tab_width = XFASTINT (current_buffer->tab_width);
  register int ctl_arrow = !NILP (current_buffer->ctl_arrow);
  int selective
    = XTYPE (current_buffer->selective_display) == Lisp_Int
      ? XINT (current_buffer->selective_display)
	: !NILP (current_buffer->selective_display) ? -1 : 0;
  int prev_vpos, prev_hpos;
  /* 92.9.9, 92.11.12 by K.Handa, 93.5.22 by Y.Niibe*/
  register int mc_bytes;
  int last_mc = 0;		/* 92.3.21 by K.Handa */
  int mc_flag = !NILP(current_buffer->mc_flag); /* 91.10.27 by K.Handa */
/* 92.4.1 by Y.Niibe */
  int truncate = hscroll
    || (truncate_partial_width_windows
	&& width + 1 < screen_width)
    || !NILP (current_buffer->truncate_lines); /* 92.4.1 by Y.Niibe */
  int lastpos;
/* end of patch */
/* 92.8.2, 93.5.22 by Y.Niibe */
  int display_direction =
    NILP(current_buffer->display_direction)? LEFT_TO_RIGHT: RIGHT_TO_LEFT;
  int vir_hpos; /* virtual hpos */
/* end of patch */

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;
  for (pos = from; pos < to; pos++)
    {
      /* Stop if past the target screen position.  */
      if (vpos > tovpos
	  || (vpos == tovpos && hpos >= tohpos))
	break;

      prev_vpos = vpos;
      prev_hpos = hpos;

      last_mc = 0; lastpos = pos; /* 92.4.1 by Y.Niibe */
      c = FETCH_CHAR (pos);
      if (c >= 040 && c < 0177)
/* 92.8.2, 93.5.22 by Y.Niibe */
	{
	  hpos++;
	  if (display_direction == RIGHT_TO_LEFT)
	    rev_hpos++;
	  else
	    rev_hpos = 0;
	}
/* end of patch */
      else if (c == '\t')
	{
	  hpos += tab_width - ((hpos + tab_offset + hscroll - (hscroll > 0)
				/* Add tab_width here to make sure positive.
				   hpos can be negative after continuation
				   but can't be less than -tab_width.  */
				+ tab_width) /* ^--on continuation, hpos is */
			       % tab_width); /* always positive in mule */
	  rev_hpos = 0; /* 93.5.22 by Y.Niibe */
	}
      else if (c == '\n')
	{
	  rev_hpos = 0; /* 92.8.2 by Y.Niibe */

	  if (selective > 0 && position_indentation (pos + 1) >= selective)
	    {
	      /* Skip any number of invisible lines all at once */
	      do
		{
		  while (++pos < to && FETCH_CHAR (pos) != '\n');
		}
	      while (pos < to && position_indentation (pos + 1) >= selective);
	      pos--;
	      /* Allow for the " ..." that is displayed for them. */
	      if (!NILP (current_buffer->selective_display_ellipses))
		{
		  hpos += 4;
		  if (hpos >= width)
		    hpos = width;
		}
	      /* We have skipped the invis text, but not the newline after.  */
	    }
	  else
	    {
	      /* A visible line follows.
		 Skip this newline and advance to next line.  */
	      vpos++;
	      hpos = 0;
	      hpos -= hscroll;
	      if (hscroll > 0) hpos++; /* Count the ! on column 0 */
	      tab_offset = 0;
	    }
	}
      else if (c == CR && selective < 0)
	{
	  rev_hpos = 0; /* 92.8.2 by Y.Niibe */
	  /* In selective display mode,
	     everything from a ^M to the end of the line is invisible */
	  while (pos < to && FETCH_CHAR (pos) != '\n') pos++;
	  /* Stop *before* the real newline.  */
	  pos--;
	  /* Allow for the " ..." that is displayed for them. */
	  if (!NILP (current_buffer->selective_display_ellipses))
	    {
	      hpos += 4;
	      if (hpos >= width)
		hpos = width;
	    }
	}
/* 93.5.22 by Y.Niibe */
      else if (mc_flag) /* 91.10.27, 92.3.21 by K.Handa */
	{
	  int next_pos_if_invalid = ++pos;
	  int dir;

	  if (c == LCCMP)
	    { /* We found start of comosite char.
	       The next char should be LC embeded in the composite char. */
	      if (pos >= to || !NONASCII_P (c = FETCH_CHAR (pos)))
		{
		  hpos += 4;
		  if (display_direction == RIGHT_TO_LEFT)
		    rev_hpos += 4;
		  else
		    rev_hpos = 0;
		}
	      else
		{
		  ++pos;
		  mc_bytes = char_bytes[c - 0x20];
		  if (pos + mc_bytes -1 <= to)
		    while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
		      pos++;
		  if (mc_bytes)
		    {
		      hpos += 4;
		      pos = next_pos_if_invalid;
		      if (display_direction == RIGHT_TO_LEFT)
			rev_hpos += 4;
		      else
			rev_hpos = 0;
		    }
		  else
		    {
		      last_mc = 1;
		      hpos += char_width[c - 0x20];
		      dir = char_direction[c - 0x20];
		      if (dir == DIRECTION_UNDEFINED)
			/* fetch extended leading char */
			dir = char_direction[FETCH_CHAR (next_pos_if_invalid+1)];
		      if (dir != display_direction)
			rev_hpos += char_width[c - 0x20];
		      else
			rev_hpos = 0;

		      while (pos < to && NONASCII_P (c = FETCH_CHAR (pos)))
			{
			  next_pos_if_invalid = pos;
			  pos++;
			  mc_bytes = char_bytes[c - 0x20];
			  if (pos + mc_bytes -1 <= to)
			    while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
			      pos++;
			  if (mc_bytes)
			    {
			      pos = next_pos_if_invalid;
			      break;
			    }
			}
		    }
		}
	      pos--;  /* since for-loop has pos++ */
	    }
	  else if (LC_P(c)) /* 92.9.9 by K.Handa */
	    { /* We found start of multi-byte char. */
	      mc_bytes = char_bytes[c];
	      if (pos + mc_bytes -1 <= to)
		while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
		  pos++;
	      if (mc_bytes)
		{
		  hpos += 4;
		  pos = next_pos_if_invalid;
		  if (display_direction == RIGHT_TO_LEFT)
		    rev_hpos += 4;
		  else
		    rev_hpos = 0;
		}
	      else
		{
		  last_mc = 1;
		  hpos += char_width[c];
		  dir = char_direction[c];
		  if (dir == DIRECTION_UNDEFINED)
		    /* fetch extended leading char */
		    dir = char_direction[FETCH_CHAR (next_pos_if_invalid)];
		  if (dir != display_direction)
		    rev_hpos += char_width[c];
		  else
		    rev_hpos = 0;
		}
	      pos--;  /* since for-loop has pos++ */
	    }
	  else
	    {
	      hpos += (ctl_arrow && c < 0200) ? 2 : 4;
	      if (display_direction == RIGHT_TO_LEFT)
		rev_hpos += (ctl_arrow && c < 0200) ? 2 : 4;
	      else
		rev_hpos = 0;
	      pos--;  /* since for-loop has pos++ */
	    }
	}
/* end of patch */
      else
/* 92.8.2 by Y.Niibe */
	{
	  hpos += (ctl_arrow && c < 0200) ? 2 : 4;
          if (display_direction == RIGHT_TO_LEFT)
            rev_hpos += (ctl_arrow && c < 0200) ? 2 : 4;
          else
            rev_hpos = 0;
	}
/* end of patch */

      /* Handle right margin.  */
      if (hpos > width) /* 92.4.1, 93.4.8 by Y.Niibe */
	{
	  if (vpos > tovpos
	      || (vpos == tovpos && hpos >= tohpos))
	    break;
	  if (truncate)  /* 92.4.1 by Y.Niibe */
	    {
	      /* Truncating: skip to newline.  */
	      while (pos < to && FETCH_CHAR (pos) != '\n') pos++;
	      pos--;
	      hpos = width;
	      rev_hpos = 0;	/* 92.8.2 by Y.Niibe */
	    }
	  else
	    {
	      /* Continuing.  */
	      vpos++;
	      if (last_mc) {
		/* 91.10.27, 93.3.27 by K.Handa, 92.4.1 by Y.Niibe */
		/* We have gone beyond right margin because of a char of multi
		   column width.  We display the whole char in the next line,
		   which means that we should increase hpos for the char. */
		hpos -= prev_hpos;
		tab_offset += prev_hpos;
		if (rev_hpos) rev_hpos = hpos; /* 92.8.2 by Y.Niibe */
	      } else {
		hpos -= width;
		tab_offset += width;
		rev_hpos = 0;	/* 92.8.2 by Y.Niibe */
	      }
	    }

	}
    }

/* 92.4.8 by Y.Niibe */
  if (!truncate)
    {
      if (vpos > tovpos
	  || (vpos == tovpos && hpos >= tohpos)) /* 93.4.8 by Y.Niibe */
	{
	  if (pos > from
	      && prev_vpos != vpos
	      && !(vpos == tovpos && 0 < tohpos))
	    {
	      int len, c_prev;

	      c_prev = FETCH_CHAR (lastpos);
	      if (c_prev == '\n')
		len = 0;
	      else if (mc_flag)
		{
		  if (c_prev == LCCMP) {
		    /* 92.11.12 by K.Handa, 93.5.22 by Y.Niibe */
		    if (pos > lastpos + 1) /* this check is enough */
		      {
			c_prev = FETCH_CHAR (lastpos+1); /* LCN1 */
			len = char_width[c_prev - 0x20];
		      }
		    else
		      len = 1;
		  } else if (LC_P (c_prev)
			     && lastpos == pos - char_bytes[c_prev])
		    len = char_width[c_prev];
		  else
		    len = 1;
		}
	      else
		len = 1;

	      if (prev_hpos + len > width)
		{
		  hpos = 0;
		  pos = lastpos;
		  /* the value of prev_hpos is different from
		     one which original method
		     caluculate, but harmless */
		  rev_hpos =0;  /* 92.8.2 by Y.Niibe */
		}
	    }
	}
      else if (hpos <= width && pos < ZV)
	{ /* Here we check if the following char can be on the same line. */
	  int len, c_next;
	  int pos_old = pos;

	  c_next = FETCH_CHAR (pos);
	  if (c_next == '\n')
	    /* No visible char following. */
	    len = 0;
	  else if (mc_flag)
	    {
	      if (c_next == LCCMP) {
		/* 92.11.15 by K.Handa, 93.5.22 by Y.Niibe */
		/* Composite char is following. */
		/* it is enough to validate the first character in composite
		       LCN1 C11 ... C1n
		 */
		pos++;
		if (pos < ZV && NONASCII_P (c_next = FETCH_CHAR (pos)))
		  {
		    pos++;
		    mc_bytes = char_bytes[c_next - 0x20];
		    if (pos + mc_bytes -1 <= ZV)
		      while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
			pos++;
		    if (mc_bytes)
		      len = 1;
		    else
		      len = char_width[c_next - 0x20];
		  }
		else
		  len = 1;
		pos = pos_old;
	      } else if (LC_P (c_next)) {
		/* Multi-byte (not composite) char is following. */
		pos++;
		mc_bytes = char_bytes[c_next];
		if (pos + mc_bytes -1 <= ZV)
		  while (--mc_bytes && NONASCII_P (FETCH_CHAR (pos)))
		    pos++;
		if (mc_bytes)
		  len = 1;
		else
		  len = char_width[c_next];
		pos = pos_old;
	      } else
		len = 1;
	    }
	  else
	    len = 1;

	  if (hpos + len > width)
	    {
	      /* The following char can't be on the same line. */
	      tab_offset += hpos;
	      vpos++;
	      hpos = 0;
	      rev_hpos =0;  /* 92.8.2 by Y.Niibe */
	    }
	}
    }
/* end of patch */

/* 92.8.2, 93.5.22 by Y.Niibe */
  vir_hpos = hpos;
  if (mc_flag && pos < ZV)
    {
      int dir, c_width;
      int p, *ip;
      unsigned int old_c = c;

      c = FETCH_CHAR (pos);
      ip = char_width_dir_on (pos,display_direction);
      c_width = ip[0]; dir = ip[1];
      
      if ((c != '\n') && (c != '\t') && dir != display_direction)
	{ /* point is in reverse text */
	  int rest_rev_hpos_prev;
	  int rest_rev_hpos;
	  int pp;
	  
	  /* find end of reverse string */
	  for (p = pos, rest_rev_hpos = rest_rev_hpos_prev = 0; p < ZV;)
	    {
	      rest_rev_hpos_prev = rest_rev_hpos;
	      c = FETCH_CHAR (p);
	      
	      if (c == '\t') break;
	      if (c == '\n') break;
	      if (c >= 040 && c < 0177)
		/* ASCII printable characters. */
		if (display_direction == LEFT_TO_RIGHT)
		  break;
		else
		  {
		    p++;
		    rest_rev_hpos++;
		  }
	      else if (c == CR && selective < 0)
		break;
	      else if (c == LCCMP)
		{
		  p++;
		  if (p >= ZV || !NONASCII_P (c = FETCH_CHAR (p)))
		    if (display_direction == LEFT_TO_RIGHT)
		      break;
		    else
		      rest_rev_hpos += 4;
		  else
		    {
		      pp = p;
		      p++;
		      mc_bytes = char_bytes[c - 0x20];
		      if (p + mc_bytes -1 <= ZV)
			while (--mc_bytes && NONASCII_P (FETCH_CHAR (p)))
			  p++;
		      if (mc_bytes)
			if (display_direction == LEFT_TO_RIGHT)
			  break;
			else
			  {
			    rest_rev_hpos += 4;
			    p = pp;
			  }
		      else
			{
			  dir = char_direction[c - 0x20];
			  if (dir == DIRECTION_UNDEFINED)
			    /* fetch extended leading char */
			    dir = char_direction[FETCH_CHAR (pp+1)];
			  if (dir != display_direction)
			    {
			      rest_rev_hpos += char_width[c - 0x20];

			      while (p < ZV &&
				     NONASCII_P (c = FETCH_CHAR (p)))
				{
				  pp = p;
				  p++;
				  mc_bytes = char_bytes[c-0x20];
				  if (p + mc_bytes -1 <= ZV)
				    while (--mc_bytes
					   && NONASCII_P (FETCH_CHAR (p)))
				      p++;
				  if (mc_bytes)
				    {
				      p = pp;
				      break;
				    }
				}
			    }
			  else
			    break;
			}
		    }
		}
	      else if (LC_P(c))
		{
		  pp = ++p;
		  mc_bytes = char_bytes[c];
		  if (p + mc_bytes -1 <= ZV)
		    while (--mc_bytes && NONASCII_P (FETCH_CHAR (p)))
		      p++;
		  if (mc_bytes)
		    /* invalid sequence --> left to right */
		    if (display_direction == LEFT_TO_RIGHT)
		      break;
		    else
		      {
			rest_rev_hpos += 4;
			p = pp;
		      }
		  else
		    {
		      dir = char_direction[c];
		      if (dir == DIRECTION_UNDEFINED)
			/* fetch extended leading char */
			dir = char_direction[FETCH_CHAR (pp)];
		      if (dir != display_direction)
			rest_rev_hpos += char_width[c];
		      else
			break;
		    }
		  }
		else
		  if (display_direction == LEFT_TO_RIGHT)
		    break;
		  else
		    {
		      p++;
		      rest_rev_hpos += (ctl_arrow && c < 0200) ? 2 : 4;
		    }

	      if (hpos + rest_rev_hpos > width)
		break;
	    }

	  if (rest_rev_hpos)
	    {
	      if (hpos + rest_rev_hpos <= width)
		hpos = hpos + rest_rev_hpos - rev_hpos - c_width;
	      else
		hpos = hpos + rest_rev_hpos_prev - rev_hpos - c_width;
	    }
	}
      c = old_c;
    }
/* end of patch */

  val_compute_motion.bufpos = pos;
  val_compute_motion.hpos = hpos;
  val_compute_motion.vpos = vpos;
  val_compute_motion.prevhpos = prev_hpos;
  val_compute_motion.tab_offset = tab_offset; /* 92.4.1 Y.Niibe */
/* 92.8.2 by Y.Niibe */
  val_compute_motion.rev_hpos = rev_hpos;
  val_compute_motion.vir_hpos = vir_hpos;
/* end of patch */

  /* Nonzero if have just continued a line */
  val_compute_motion.contin
    = (pos != from
       && (val_compute_motion.vpos != prev_vpos)
       && c != '\n');

  return &val_compute_motion;
}

int
pos_tab_offset (struct window *w, register int pos)
{				/* 92.4.1 by Y.Niibe - completely rewritten */
  struct position val;
  int prevline;

  prevline = find_next_newline (pos, -1);
  val = *compute_motion (prevline, 0,
			 XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0,
			 pos, 1 << (INTBITS - 2), 0,
			 XFASTINT (w->width) - 1
			 - (XFASTINT (w->width) + XFASTINT (w->left) != screen_width),
			 XINT (w->hscroll), 0, 0);   /* 92.8.2 Y.Niibe */

  return val.tab_offset;
}

/* start_hpos is the hpos of the first character of the buffer:
   zero except for the minibuffer window,
   where it is the width of the prompt.  */

struct position val_vmotion;

struct position *
vmotion (register int from, register int vtarget, register int width, int hscroll, Lisp_Object window)
{
  struct position pos;
  /* vpos is cumulative vertical position, changed as from is changed */
  register int vpos = 0;
  register int prevline;
  register int first;
  int lmargin = hscroll > 0 ? 1 - hscroll : 0;
  int selective
    = XTYPE (current_buffer->selective_display) == Lisp_Int
      ? XINT (current_buffer->selective_display)
	: !NILP (current_buffer->selective_display) ? -1 : 0;
  int start_hpos = (EQ (window, minibuf_window) ? minibuf_prompt_width : 0);

 retry:
  if (vtarget > vpos)
    {
      /* Moving downward is simple, but must calculate from beg of line 
	 to determine hpos of starting point */
      if (from > BEGV && FETCH_CHAR (from - 1) != '\n')
	{
	  prevline = find_next_newline (from, -1);
	  while (selective > 0
		 && prevline > BEGV
		 && position_indentation (prevline) >= selective)
	    prevline = find_next_newline (prevline - 1, -1);
	  pos = *compute_motion (prevline, 0,
				 lmargin + (prevline == 1 ? start_hpos : 0),
				 from, 1 << (INTBITS - 2), 0,
				 width, hscroll, 0, 0);   /* 92.8.2 Y.Niibe */
	}
      else
	{
	  pos.vir_hpos = lmargin + (from == 1 ? start_hpos : 0); /* 92.8.2 by Y.Niibe */
	  pos.vpos = 0;
	  pos.tab_offset = 0;	/* 92.4.1 by Y.Niibe */
	  pos.rev_hpos = 0;	/* 92.8.2 by Y.Niibe */
	}
      /* 92.4.1, 92.8.2 by Y.Niibe */
      return compute_motion (from, vpos, pos.vir_hpos,
			     ZV, vtarget, - (1 << (INTBITS - 2)),
			     width, hscroll, pos.tab_offset, pos.rev_hpos);
    }

  /* To move upward, go a line at a time until
     we have gone at least far enough */

  first = 1;

  while ((vpos > vtarget || first) && from > BEGV)
    {
      prevline = from;
      while (1)
	{
	  prevline = find_next_newline (prevline - 1, -1);
	  if (prevline == BEGV
	      || selective <= 0
	      || position_indentation (prevline) < selective)
	    break;
	}
      pos = *compute_motion (prevline, 0,
			     lmargin + (prevline == 1 ? start_hpos : 0),
			     from, 1 << (INTBITS - 2), 0,
			     width, hscroll, 0, 0);   /* 92.8.2 Y.Niibe */
      vpos -= pos.vpos;
      first = 0;
      from = prevline;
    }

  /* If we made exactly the desired vertical distance,
     or if we hit beginning of buffer,
     return point found */
  if (vpos >= vtarget)
    {
      val_vmotion.bufpos = from;
      val_vmotion.vpos = vpos;
      val_vmotion.hpos = lmargin;
      val_vmotion.contin = 0;
      val_vmotion.prevhpos = 0;
      val_vmotion.tab_offset = 0;
      val_vmotion.vir_hpos = lmargin;
      val_vmotion.rev_hpos = 0;
      return &val_vmotion;
    }
  
  /* Otherwise find the correct spot by moving down */
  goto retry;
}

DEFUN ("vertical-motion", Fvertical_motion, Svertical_motion, 1, 1, 0,
  "Move to start of screen line LINES lines down.\n\
If LINES is negative, this is moving up.\n\
Sets point to position found; this may be start of line\n\
 or just the start of a continuation line.\n\
Returns number of lines moved; may be closer to zero than LINES\n\
 if beginning or end of buffer was reached.")
  (Lisp_Object lines)
{
  struct position pos;
  register struct window *w = XWINDOW (selected_window);

  CHECK_NUMBER (lines, 0);

  pos = *vmotion (point, XINT (lines),
		  XFASTINT (w->width) - 1
		  - (XFASTINT (w->width) + XFASTINT (w->left)
		     != XFASTINT (XWINDOW (minibuf_window)->width)),
		  /* Not XFASTINT since perhaps could be negative */
		  XINT (w->hscroll), selected_window);

  SET_PT (pos.bufpos);
  return make_number (pos.vpos);
}

void
syms_of_indent (void)
{
  DEFVAR_BOOL ("indent-tabs-mode", &indent_tabs_mode,
    "*Indentation can insert tabs if this is non-nil.\n\
Setting this variable automatically makes it local to the current buffer.");
  indent_tabs_mode = 1;

  defsubr (&Scurrent_indentation);
  defsubr (&Sindent_to);
  defsubr (&Scurrent_column);
  defsubr (&Smove_to_column);
  defsubr (&Svertical_motion);
}
