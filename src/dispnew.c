/* Newly written part of redisplay code.
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

/* 87.5.28  modified by K.Handa */
/* 89.3.23  modified for Nemacs Ver.3.0 by K.Handa */
/* 89.11.24 modified for attribute of characters by K.Handa */
/* 90.2.27  modified for Nemacs Ver.3.3 by K.Handa
	Attribute related bugs are fixed in update_line. */
/* 91.10.21 modified for Nemacs Ver.4.0.0 by K.Handa (handa@etl.go.jp) */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.19  modified for Mule Ver.0.9.1 by T.Enami <enami@sys.ptg.sony.co.jp>
	In update_line(), bug in multi-byte chars handling is fixed. */
/* 92.3.31  modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	Sun console feature added. */
/* 92.4.15  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Size of message_buf is given by macro MSG_BUF_SIZE. */
/* 92.10.21 modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>,
		   S.Hirano <hirano@etl.go.jp>
	DOS-Extender GO32 and EMX supported. */
/* 92.11.9  modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	MTRX_CMPCHAR is used to check a composite character. */
/* 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
        Preliminary support (92.8.2) for right-to-left languages. */
/* 93.2.25  modified for Mule Ver.0.9.7
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	Win32 (Windows NT and Windows 3.1) supported. */
/* 93.3.10  modified for Mule Ver.0.9.7.1
			by T.Enami <enami@sys.ptg.sony.co.jp>
	store_composite_char() should return a pointer with MSBs reset. */
/* 93.3.14  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In preserve_other_columns(), we don't have to care about cmp_chars. */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	Double cursor support, and bug fix of compare_char (). */
/* 93.6.21  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Composite chars are stored in cmp_char_table. */
/* 93.7.28  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	When screen->enable[n] == 1, cmp_char_table should not be freed. */

/* This must precede sys/signal.h on certain machines.  */
#include <sys/types.h>
#include <signal.h>

#include "config.h"
#include <stdio.h>
#include <errno.h>

#ifdef HAVE_TIMEVAL
#ifdef HPUX
#include <time.h>
#else
#include <sys/time.h>
#endif
#endif

#ifdef HAVE_TERMIO
#include <termio.h>
#ifdef TCOUTQ
#undef TIOCOUTQ
#define TIOCOUTQ TCOUTQ
#include <fcntl.h>
#endif /* TCOUTQ defined */
#else
#ifndef VMS
#include <sys/ioctl.h>
#endif /* not VMS */
#endif /* not HAVE_TERMIO */

/* Allow m- file to inhibit use of FIONREAD.  */
#ifdef BROKEN_FIONREAD
#undef FIONREAD
#endif

/* We are unable to use interrupts if FIONREAD is not available,
   so flush SIGIO so we won't try. */
#ifndef FIONREAD
#ifdef SIGIO
#undef SIGIO
#endif
#endif

#include "termchar.h"
#include "termopts.h"
#include "cm.h"
#if defined(WIN32) && defined(USE_FATFS)
#include "dispexte.h"
#else
#include "dispextern.h"
#endif
#include "lisp.h"
#include "buffer.h"
#include "process.h"
#include "window.h"
#include "commands.h"
#ifdef HAVE_X_WINDOWS
#include "x11term.h"
#endif
#include "mule.h"		/* 91.10.21 by K.Handa */

#define max(a, b) ((a) > (b) ? (a) : (b))
#define min(a, b) ((a) < (b) ? (a) : (b))

#ifndef PENDING_OUTPUT_COUNT
/* Get number of chars of output now in the buffer of a stdio stream.
   This ought to be built in in stdio, but it isn't.
   Some s- files override this because their stdio internals differ.  */
#ifdef __GNU_LIBRARY__
#define	PENDING_OUTPUT_COUNT(FILE) ((FILE)->__bufp - (FILE)->__buffer)
#else
#define PENDING_OUTPUT_COUNT(FILE) ((FILE)->_ptr - (FILE)->_base)
#endif
#endif /* No PENDING_OUTPUT_COUNT */

/* Nonzero means do not assume anything about current
   contents of actual terminal screen */

int screen_garbaged;

/* Desired terminal cursor position (to show position of point),
   origin zero */

int cursor_hpos, cursor_vpos;

/* 93.5.22 by Y.Niibe for double cursor */
int cursor_form;
int cursor_hpos_rev;
/* end of patch */

/* Nonzero means last display completed and cursor is really at
   cursor_hpos, cursor_vpos.  Zero means it was preempted. */

int display_completed;

/* Lisp variable visible-bell; enables use of screen-flash
   instead of audible bell.  */

int visible_bell;

/* Invert the color of the whole screen, at a low level.  */

int inverse_video;

/* Line speed of the terminal.  */

int baud_rate;

/* nil or a symbol naming the window system
   under which emacs is running
   ('x is the only current possibility).  */

Lisp_Object Vwindow_system;

/* Version number of window system, or nil if no window system.  */

Lisp_Object Vwindow_system_version;

/* Nonzero means reading single-character input with prompt
   so put cursor on minibuffer after the prompt.  */

int cursor_in_echo_area;

/* Nonzero means finish redisplay regardless of available input.
   This is used with X windows to avoid a weird timing-dependent bug.  */

int force_redisplay;

/* Description of actual screen contents.  */
 
struct matrix *current_screen;

/* Description of desired screen contents.  */

struct matrix *new_screen;

/* Buffer sometimes used to hold partial screen contents.  */

struct matrix *temp_screen;

/* Stdio stream being used for copy of all terminal output.  */

FILE *termscript;

/* Structure for info on cursor positioning */

struct cm Wcm;

int delayed_size_change;  /* 1 means SIGWINCH happened when not safe.  */
int delayed_screen_height;  /* Remembered new screen height.  */
int delayed_screen_width;   /* Remembered new screen width.  */

/* This buffer records the history of display preemption.  */

struct preempt
{
  /* Number of keyboard characters read so far at preempt.  */
  int keyboard_char_count;
  /* Vertical position at which preemption occurred.  */
  int vpos;
};

#define N_PREEMPTIONS 50

/* Circular buffer recording recent display preemptions.  */
struct preempt preemptions[N_PREEMPTIONS];

/* Index of next element in preemptions.  */
int preemption_index;

/* Set these variables in the debugger to force a display preemption.  */
int debug_preemption_vpos = -1;
int debug_preemption_char_count = -1;

/* 93.5.22 Y.Niibe -- Nonzero means display double cursor */
int r2l_double_cursor;

/* Free and reallocate current_screen and new_screen.  */

struct matrix *make_screen_structure (int);

void free_screen_structure (struct matrix *);
int count_blanks (int *);
void rotate_vector (void *, int, int);
void safe_bcopy (void *, void *, int);
int scrolling (void);
void update_line (int);
int compare_char (unsigned int, unsigned int);
int count_match (int *, int *);
void change_screen_size_1 (int, int, int, int);
void bell (void);

unsigned char **cmp_char_table;	/* 93.6.21 by K.Handa */
int cmp_char_idx_max;		/* 93.6.21 by K.Handa */

void
remake_screen_structures (void)
{
  int i;

  if (current_screen)
    free_screen_structure (current_screen);
  if (new_screen)
    free_screen_structure (new_screen);
  if (temp_screen)
    free_screen_structure (temp_screen);

  /* 93.6.21 by K.Handa */
  if (cmp_char_idx_max > 0) {
    while (cmp_char_idx_max > 0) {
      if (cmp_char_table[--cmp_char_idx_max])
	free (cmp_char_table[cmp_char_idx_max]);
    }
    free (cmp_char_table);
  }
  cmp_char_table =
    (unsigned char **)xmalloc (sizeof (char *) * screen_height * 3);
  bzero (cmp_char_table, sizeof (char *) * screen_height * 3);
  /* end of patch */

  current_screen = make_screen_structure (0);
  new_screen = make_screen_structure (0);
  temp_screen = make_screen_structure (1);

  if (message_buf)
    {
      /* The echo_area_contents, used by error and message, may be pointing at
	 the string we are replacing.  If so, update it.  */
      int repair_echo_area_contents = echo_area_contents == message_buf;

      message_buf = (char *) xrealloc (message_buf, MSG_BUF_SIZE + 1);

      if (repair_echo_area_contents) echo_area_contents = message_buf;
    } 
  else
    message_buf = (char *) xmalloc (MSG_BUF_SIZE + 1);

  /* This may fix a problem of occasionally displaying garbage in the echo area
     after a resize in X Windows.  */
  for (i = 0; i < MSG_BUF_SIZE; i++)
    message_buf[i] = ' ';
  message_buf[MSG_BUF_SIZE] = 0;
}

struct matrix *
make_screen_structure (int empty)
{
  int i;
  struct matrix *new = (struct matrix *) xmalloc (sizeof (struct matrix));

  new->height = screen_height;
  new->width = screen_width;
  new->highlight = (char *) xmalloc (screen_height);
  new->enable = (char *) xmalloc (screen_height);
  /* 91.10.22 by K.Handa */
  new->contents = (unsigned int **) xmalloc (screen_height * sizeof (int *));
  new->used = (int *) xmalloc (screen_height * sizeof (int));
  /* end of patch */
  if (empty)
    {
      /* Make the buffer used by decode_mode_spec.  */
      new->total_contents =	/* 91.10.22 by K.Handa */
	(unsigned int *) xmalloc ((screen_width + 2) * sizeof (int));
      for (i = 0; i < screen_width; i++)
	new->total_contents[i] = ' ';
      new->total_contents[screen_width] = 0;
    }
  else
    {
      /* Add 2 to leave extra bytes at beginning and end of each line.  */ 
      new->total_contents =	/* 91.10.22 by K.Handa */
	(unsigned int *) xmalloc (screen_height * (screen_width + 2) * sizeof (int));
      for (i = 0; i < screen_height; i++)
	{
	  int j;

	  new->contents[i] = new->total_contents + i * (screen_width + 2) + 1;
	  new->contents[i][screen_width] = 0;
	  new->contents[i][-1] = 0;
	  for (j = 0; j < screen_width; j++)
	    new->contents[i][j] = ' ';
	}
    }
  bzero (new->enable, screen_height);
  /* 93.6.21 by K.Handa */
  new->cmp_char_idx = (int *) xmalloc (screen_height * sizeof (int));
  for (i = 0; i < screen_height; i++)
    new->cmp_char_idx[i] = cmp_char_idx_max++;
  /* end of patch */
  return new;
}

/* 92.12.8 by K.Handa */
#define ALLOC_CMP_CHAR(m,i) \
  if (!CMP_CHAR_TABLE (m, i)) \
    CMP_CHAR_TABLE (m, i) = (unsigned char *) xmalloc(CMP_CHAR_SIZE * m->width)

#define FREE_CMP_CHAR(m,i) \
  if (CMP_CHAR_TABLE (m, i)) \
    free (CMP_CHAR_TABLE (m, i)), CMP_CHAR_TABLE (m, i) = (unsigned char *)0
/* end of patch */

void
free_screen_structure (struct matrix *matrix)
{
  int i;			/* 92.12.6 by K.Handa */

  if (matrix->total_contents)
    free (matrix->total_contents);
  free (matrix->contents);
  free (matrix->highlight);
  free (matrix->enable);
  free (matrix->used);
  free (matrix->cmp_char_idx);	/* 93.6.21 by K.Handa */
  free (matrix);
}

/* Return the hash code of contents of line VPOS of screen-matrix M.  */

int
line_hash_code (struct matrix *m, int vpos)
{
  register unsigned int *body;	/* 91.10.23 by K.Handa */
  register int h = 0;
  /* Give all lighlighted lines the same hash code
     so as to encourage scrolling to leave them in place.  */
  if (m->highlight[vpos])
    return -1;

  body = m->contents[vpos];

  if (must_write_spaces)
    {
      while (1)
	{
	  int c = *body++;
	  if (c == 0)
	    break;
	  h = (((h << 4) + (h >> 24)) & 0x0fffffff)
	    + (c & MTRX_CODEL_MASK) - ' '; /* 92.11.9 by K.Handa */
	}
    }
  else
    {
      while (1)
	{
	  int c = *body++;
	  if (c == 0)
	    break;
	  h = (((h << 4) + (h >> 24)) & 0x0fffffff)
	    + (c & MTRX_CODEL_MASK); /* 92.11.9 by K.Handa */
	}
    }
  if (h)
    return h;
  return 1;
}

/* Return number of characters in line in M at vpos VPOS,
   except don't count leading and trailing spaces
   unless the terminal requires those to be explicitly output.  */

int
line_draw_cost (struct matrix *m, int vpos)
{
  register unsigned int *body;	/* 91.10.23 by K.Handa */
  register int i;

  if (must_write_spaces)
    return m->used[vpos];

  body = m->contents[vpos];
  for (i = m->used[vpos]; i > 0 && body[i - 2] == ' '; i--);

  i -= count_blanks (body);
  return max (i, 0);
}

/* The functions on this page are the interface from xdisp.c to redisplay.

 The only other interface into redisplay is through setting
 cursor_hpos and cursor_vpos (in xdisp.c) and setting screen_garbaged. */

/* cancel_line eliminates any request to display a line at position `vpos' */

void
cancel_line (int vpos)
{
  new_screen->enable[vpos] = 0;
  FREE_CMP_CHAR (new_screen, vpos); /* 92.12.8 by K.Handa */
}

void
clear_screen_records (void)
{
  int i;

  bzero (current_screen->enable, screen_height);
  for (i = 0; i < current_screen->height; i++) /* 92.12.7 by K.Handa */
    FREE_CMP_CHAR (current_screen, i);
}

/* Get ready to display on line `vpos'
   and set it up for outputting starting at `hpos' within it.
   Return the text string where that line is stored.  */

unsigned int *			/* 91.10.23 by K.Handa */
get_display_line (int vpos, register int hpos)
{
  if (new_screen->enable[vpos] && new_screen->used[vpos] > hpos)
    abort ();
  if (! new_screen->enable[vpos])
    {
      new_screen->used[vpos] = 0;
      new_screen->highlight[vpos] = 0;
      new_screen->enable[vpos] = 1;
      /* FREE_CMP_CHAR (new_screen, vpos); */	/* 93.6.21 by K.Handa */
    }

  if (hpos > new_screen->used[vpos])
    {				/* 91.10.23 by K.Handa */
      unsigned int *p = new_screen->contents[vpos] + new_screen->used[vpos];
      unsigned int *end = new_screen->contents[vpos] + hpos;
      new_screen->used[vpos] = hpos;
      while (p != end)
	*p++ = ' ';
    }

  return new_screen->contents[vpos];
}

/* 92.12.7, 93.6.21 by K.Handa */
/* Set a composite character to cmp_char_table.
   If the area is not allocated, allocate it.
   The return value is an index to the stored composite char. */
unsigned int
store_composite_char (struct matrix *m, int vpos, int hpos, unsigned char *cmpchars, int cmpsize)
{
  register unsigned char *p;

  ALLOC_CMP_CHAR(m, vpos);

  p = CMP_CHAR_TABLE (m, vpos) + CMP_CHAR_SIZE * hpos;
  if (cmpsize >= CMP_CHAR_SIZE)
    cmpsize = CMP_CHAR_SIZE - 1;
  bcopy(cmpchars, p, cmpsize);
  *(p + cmpsize) = 0;
  return (unsigned int) MTRX_COMPOSE_CMPPTR (m, vpos, hpos);
}
/* end of patch */

/* Scroll lines from vpos `from' up to but not including vpos `end'
 down by `amount' lines (`amount' may be negative).
 Returns nonzero if done, zero if terminal cannot scroll them. */

int
scroll_screen_lines (Lisp_Object_Int from, Lisp_Object_Int end, Lisp_Object_Int amount)
{
  register int i;

  if (!line_ins_del_ok)
    return 0;

  if (amount == 0)
    return 1;
  if (amount > 0)
    {
      set_terminal_window (end + amount);
      if (!scroll_region_ok)
	ins_del_lines (end, -amount);
      ins_del_lines (from, amount);
      set_terminal_window (0);

      rotate_vector (current_screen->contents + from, /* 91.10.19 by K.Handa */
		     sizeof (int *) * (end + amount - from),
		     amount * sizeof (int *));
      safe_bcopy (current_screen->used + from,
		  current_screen->used + from + amount,
		  (end - from) * sizeof current_screen->used[0]);
      safe_bcopy (current_screen->highlight + from,
		  current_screen->highlight + from + amount,
		  (end - from) * sizeof current_screen->highlight[0]);
      safe_bcopy (current_screen->enable + from,
		  current_screen->enable + from + amount,
		  (end - from) * sizeof current_screen->enable[0]);
      /* 92.12.7, 93.6.21 by K.Handa */
      rotate_vector (current_screen->cmp_char_idx + from,
		     sizeof (int) * (end + amount - from),
		     amount * sizeof (int));
      /* Mark the lines made empty by scrolling as enabled, empty and
	 normal video.  */
      bzero (current_screen->used + from,
	     amount * sizeof current_screen->used[0]);
      bzero (current_screen->highlight + from,
	     amount * sizeof current_screen->highlight[0]);
      for (i = from; i < from + amount; i++)
	{
	  current_screen->contents[i][0] = '\0';
	  current_screen->enable[i] = 1;
	  /* FREE_CMP_CHAR (current_screen, i); */ /* 92.12.8 by K.Handa */
	}
    }
  if (amount < 0)
    {
      set_terminal_window (end);
      ins_del_lines (from + amount, amount);
      if (!scroll_region_ok)
	ins_del_lines (end + amount, -amount);
      set_terminal_window (0);
				/* 91.10.19 by K.Handa */
      rotate_vector (current_screen->contents + from + amount,
		     sizeof (int *) * (end - from - amount),
		     (end - from) * sizeof (int *));
      safe_bcopy (current_screen->used + from,
		  current_screen->used + from + amount,
		  (end - from) * sizeof current_screen->used[0]);
      safe_bcopy (current_screen->highlight + from,
		  current_screen->highlight + from + amount,
		  (end - from) * sizeof current_screen->highlight[0]);
      safe_bcopy (current_screen->enable + from,
		  current_screen->enable + from + amount,
		  (end - from) * sizeof current_screen->enable[0]);
      /* 92.12.7, 93.6.21 by K.Handa */
      rotate_vector (current_screen->cmp_char_idx + from + amount,
		     sizeof (int) * (end - from - amount),
		     (end - from) * sizeof (int));
      /* Mark the lines made empty by scrolling as enabled, empty and
	 normal video.  */
      bzero (current_screen->used + end + amount,
	     - amount * sizeof current_screen->used[0]);
      bzero (current_screen->highlight + end + amount,
	     - amount * sizeof current_screen->highlight[0]);
      for (i = end + amount; i < end; i++)
	{
	  current_screen->contents[i][0] = '\0';
	  current_screen->enable[i] = 1;
	  /* FREE_CMP_CHAR (current_screen, i); */ /* 92.12.8 by K.Handa */
	}
    }
  return 1;
}

/* Rotate a vector of SIZE bytes, by DISTANCE bytes.
   DISTANCE may be negative.  */

void
rotate_vector (void *v, int size, int distance)
{
  char *vector = v;
  char *temp = (char *) alloca (size);

  if (distance < 0)
    distance += size;

  bcopy (vector, temp + distance, size - distance);
  bcopy (vector + size - distance, temp, distance);
  bcopy (temp, vector, size);
}

/* Like bcopy except never gets confused by overlap.  */

void
safe_bcopy (void *src, void *dst, int size)
{
  char *from = src;
  char *to = dst;
  register char *endf;
  register char *endt;

  if (size == 0)
    return;
  if (from > to)
    {
      /* If destination is lower in memory, we can go from the beginning.  */
      endf = from + size;
      while (from != endf)
	*to++ = *from++;
      return;
    }

  /* If destination is higher in memory, we can go backwards from the end.  */
  endf = from + size;
  endt = to + size;

  do
    *--endt = *--endf;
  while (endf != from);
}

/* After updating a window w that isn't the full screen wide,
 copy all the columns that w does not occupy
 from current_screen to new_screen,
 so that update_screen will not change those columns.  */

void
preserve_other_columns (struct window *w)
{
  register int vpos;
  int start = XFASTINT (w->left);
  int end = XFASTINT (w->left) + XFASTINT (w->width);
  int bot = XFASTINT (w->top) + XFASTINT (w->height);

  for (vpos = XFASTINT (w->top); vpos < bot; vpos++)
    {
      if (current_screen->enable[vpos] && new_screen->enable[vpos])
	{
	  if (start > 0)
	    {
	      int len;

	      bcopy (current_screen->contents[vpos], /* 91.11.1 by K.Handa */
		     new_screen->contents[vpos], start * sizeof (int));
	      len = min (start, current_screen->used[vpos]);
	      if (new_screen->used[vpos] < len)
		new_screen->used[vpos] = len;
	    }
	  if (current_screen->used[vpos] > end
	      && new_screen->used[vpos] < current_screen->used[vpos])
	    {
	      while (new_screen->used[vpos] < end)
		new_screen->contents[vpos][new_screen->used[vpos]++] = ' ';
				/* 91.11.1 by K.Handa */
	      bcopy (current_screen->contents[vpos] + end,
		     new_screen->contents[vpos] + end,
		     (current_screen->used[vpos] - end) * sizeof (int));
	      new_screen->used[vpos] = current_screen->used[vpos];
	    }
	}
    }
}

/* On discovering that the redisplay for a window was no good,
 cancel the columns of that window,
 so that when the window is displayed over again
 get_display_line will not complain. */

void
cancel_my_columns (struct window *w)
{
  register int vpos;
  register int start = XFASTINT (w->left);
  register int bot = XFASTINT (w->top) + XFASTINT (w->height);

  for (vpos = XFASTINT (w->top); vpos < bot; vpos++)
    if (new_screen->enable[vpos] && new_screen->used[vpos] >= start)
      new_screen->used[vpos] = start;
}


/* These functions try to perform directly and immediately on the screen
   the necessary output for one change in the buffer.
   They may return 0 meaning nothing was done if anything is difficult,
   or 1 meaning the output was performed properly.
   They assume that the screen was up to date before the buffer
   change being displayed.  THey make various other assumptions too;
   see command_loop_1 where these are called.  */

int
direct_output_for_insert (
    unsigned int c		/* 92.1.28 by K.Handa */
)
{
#ifndef COMPILER_REGISTER_BUG
  register
#endif
    struct window *w = XWINDOW (selected_window);
#ifndef COMPILER_REGISTER_BUG
  register
#endif
    int hpos = cursor_hpos;
#ifndef COMPILER_REGISTER_BUG
  register
#endif
    int vpos = cursor_vpos;
  Lisp_Object apositions;	/* 92.1.28 by K.Handa */

  /* Give up if about to continue line */
  if (hpos - XFASTINT (w->left) + 1 + 1 >= XFASTINT (w->width)

/* 92.8.2 by Y.Niibe */
  /* Give up if the buffer has right-to-left attribute */
      || !NILP(XBUFFER(w->buffer)->display_direction)
/* end of patch */

  /* Avoid losing if cursor is in invisible text off left margin */
      || (XINT (w->hscroll) && hpos == XFASTINT (w->left))

  /* Give up if cursor outside window (in minibuf, probably) */
      || cursor_vpos < XFASTINT (w->top)
      || cursor_vpos >= XFASTINT (w->top) + XFASTINT (w->height)

  /* Give up if cursor not really at cursor_hpos, cursor_vpos */
      || !display_completed

  /* Give up if w is minibuffer and a message is being displayed there */
      || (EQ (selected_window, minibuf_window) && echo_area_contents))
    return 0;

  apositions = current_attribute(point - 1); /* 92.1.28 by K.Handa */
  if (!NILP (apositions))
    c |= XFASTINT (XCONS (XCONS (apositions)->car)->cdr) << 24;

  current_screen->contents[vpos][hpos] = c;
  unchanged_modified = MODIFF;
  beg_unchanged = GPT - BEG;
  XFASTINT (w->last_point) = point;
  XFASTINT (w->last_point_x) = cursor_hpos;
  XFASTINT (w->last_modified) = MODIFF;

  reassert_line_highlight (0, cursor_vpos);
  output_chars (&current_screen->contents[vpos][hpos], 1);
  fflush (stdout);
  ++cursor_hpos;
  if (hpos == current_screen->used[vpos])
    {
      current_screen->used[vpos] = hpos + 1;
      current_screen->contents[vpos][hpos + 1] = 0;
    }
  return 1;
}

int
direct_output_forward_char (int n)
{
  register struct window *w = XWINDOW (selected_window);

  /* Avoid losing if cursor is in invisible text off left margin */
  if (XINT (w->hscroll) && cursor_hpos == XFASTINT (w->left))
    return 0;
  /* Don't lose if we are in the truncated text at the end.  */
  if (cursor_hpos >= XFASTINT (w->left) + XFASTINT (w->width) - 1)
    return 0;
  /* Don't move past the window edges.  */
  if (cursor_hpos + n >= XFASTINT (w->left) + XFASTINT (w->width) - 1)
    return 0;
  if (cursor_hpos + n <= XFASTINT (w->left))
    return 0;

  cursor_hpos += n;
  XFASTINT (w->last_point_x) = cursor_hpos;
  XFASTINT (w->last_point) = point;
  move_cursor (cursor_vpos, cursor_hpos);
  fflush (stdout);
  return 1;
}

/* Update the actual terminal screen based on the data in new_screen.
   Value is nonzero if redisplay stopped due to pending input.
   FORCE nonzero means do not stop for pending input.  */

int
update_screen (int force, int inhibit_hairy_id)
{
  register struct display_line **p;
  register struct display_line *l, *lnew;
  register int i;
  int pause;
  int preempt_count = baud_rate / 2400 + 1;

  if (screen_height == 0) abort (); /* Some bug zeros some core */

  if (force_redisplay)
    force = 1;

  if (!force)
    detect_input_pending ();
  if (!force
      && ((num_input_chars == debug_preemption_char_count
	   && debug_preemption_vpos == screen_height - 1)
	  || input_pending))
    {
      pause = screen_height;
      goto do_pause;
    }

  update_begin ();

  if (!line_ins_del_ok)
    inhibit_hairy_id = 1;

  /* Don't compute for i/d line if just want cursor motion. */
  for (i = 0; i < screen_height; i++)
    if (new_screen->enable)
      break;

  /* Try doing i/d line, if not yet inhibited.  */
  if (!inhibit_hairy_id && i < screen_height)
    force |= scrolling ();

  /* Update the individual lines as needed.  Do bottom line first.  */

  if (new_screen->enable[screen_height - 1])
    update_line (screen_height - 1);
  for (i = 0; i < screen_height - 1 && (force || !input_pending); i++)
    {
      if (!force && num_input_chars == debug_preemption_char_count
	  && debug_preemption_vpos == i)
	break;
      if (new_screen->enable[i])
	{
	  /* Flush out every so many lines.
	     Also flush out if likely to have more than 1k buffered
	     otherwise.   I'm told that telnet connections get really
	     screwed by more than 1k output at once.  */
	  int outq = PENDING_OUTPUT_COUNT (stdout);
	  if (outq > 900
	      || (outq > 20 && ((i - 1) % preempt_count == 0)))
	    {
	      fflush (stdout);
	      if (preempt_count == 1)
		{
#ifdef TIOCOUTQ
		  if (ioctl (0, TIOCOUTQ, &outq) < 0)
		    /* Probably not a tty.  Ignore the error and reset
		     * the outq count. */
		    outq = PENDING_OUTPUT_COUNT (stdout);
#endif
		  outq *= 10;
		  sleep (outq / baud_rate);
		}
	    }
	  if ((i - 1) % preempt_count == 0 && !force)
	    detect_input_pending ();
	  /* Now update this line.  */
	  update_line (i);
	}
    }
  pause = (i < screen_height - 1) ? i + 1 : 0;

  /* Now just clean up termcap drivers and set cursor, etc.  */
  if (!pause)
    {
      if (cursor_in_echo_area < 0)
	move_cursor (screen_height - 1, 0);
      else if (cursor_in_echo_area > 0
	       && !current_screen->enable[screen_height - 1])
	move_cursor (screen_height - 1, 0);
      else if (cursor_in_echo_area)
	move_cursor (screen_height - 1,
		     min (screen_width - 1,
			  current_screen->used[screen_height - 1]));
      else
	move_cursor (cursor_vpos, cursor_hpos); /* 93.5.22 Y.Niibe */
    }

  update_end ();

  if (termscript)
    fflush (termscript);
  fflush (stdout);

  /* Here if output is preempted because input is detected.  */
 do_pause:

  if (screen_height == 0) abort (); /* Some bug zeros some core */
  display_completed = !pause;
  if (pause)
    {
      preemptions[preemption_index].vpos = pause - 1;
      preemptions[preemption_index].keyboard_char_count = num_input_chars;
      preemption_index++;
      if (preemption_index == N_PREEMPTIONS)
	preemption_index = 0;
    }

  bzero (new_screen->enable, screen_height);
  return pause;
}

/* Called when about to quit, to check for doing so
   at an improper time.  */

void
quit_error_check (void)
{
  if (new_screen == 0)
    return;
  if (new_screen->enable[0])
    abort ();
  if (new_screen->enable[screen_height - 1])
    abort ();
}

/* Decide what insert/delete line to do, and do it */

int
scrolling (void)
{
  int unchanged_at_top, unchanged_at_bottom;
  int window_size;
  int changed_lines;
  int *old_hash = (int *) alloca (screen_height * sizeof (int));
  int *new_hash = (int *) alloca (screen_height * sizeof (int));
  int *draw_cost = (int *) alloca (screen_height * sizeof (int));
  register int i;
  int free_at_end_vpos = screen_height;
  
  /* Compute hash codes of all the lines.
     Also calculate number of changed lines,
     number of unchanged lines at the beginning,
     and number of unchanged lines at the end.  */

  changed_lines = 0;
  unchanged_at_top = 0;
  unchanged_at_bottom = screen_height;
  for (i = 0; i < screen_height; i++)
    {
      /* Give up on this scrolling if some old lines are not enabled.  */
      if (!current_screen->enable[i])
	return 0;
      old_hash[i] = line_hash_code (current_screen, i);
      if (!new_screen->enable[i])
	new_hash[i] = old_hash[i];
      else
	new_hash[i] = line_hash_code (new_screen, i);
      if (old_hash[i] != new_hash[i])
	{
	  changed_lines++;
	  unchanged_at_bottom = screen_height - i - 1;
	}
      else if (i == unchanged_at_top)
	unchanged_at_top++;
      /* If line is not changing, its redraw cost is infinite,
	 since we can't redraw it.  */
      if (!new_screen->enable[i])
	draw_cost[i] = INFINITY;
      else
	draw_cost[i] = line_draw_cost (new_screen, i);
    }

  /* If changed lines are few, don't allow preemption, don't scroll.  */
  if (changed_lines < baud_rate / 2400 || unchanged_at_bottom == screen_height)
    return 1;

  window_size = screen_height - unchanged_at_top - unchanged_at_bottom;

  if (scroll_region_ok)
    free_at_end_vpos -= unchanged_at_bottom;
  else if (memory_below_screen)
    free_at_end_vpos = -1;

  /* If large window, fast terminal and few lines in common between
     current_screen and new_screen, don't bother with i/d calc.  */
  if (window_size >= 18 && baud_rate > 2400
      && (window_size >=
	  10 * scrolling_max_lines_saved (unchanged_at_top,
					  screen_height - unchanged_at_bottom,
					  old_hash, new_hash, draw_cost)))
    return 0;

  scrolling_1 (window_size, unchanged_at_top, unchanged_at_bottom,
	       draw_cost + unchanged_at_top - 1,
	       old_hash + unchanged_at_top - 1,
	       new_hash + unchanged_at_top - 1,
	       free_at_end_vpos - unchanged_at_top);

  return 0;
}

void
update_line (int vpos)
{
				/* 91.10.21 by K.Handa */
  register unsigned int *obody, *nbody, *op1, *op2, *np1;
  int tem;
  int osp, nsp, begmatch, endmatch, olen, nlen;
  int save;
  unsigned int *temp;		/* 91.10.21 by K.Handa */

  /* Check for highlighting change.  */
  if (new_screen->highlight[vpos]
      != (current_screen->enable[vpos] && current_screen->highlight[vpos]))
    {
      change_line_highlight (new_screen->highlight[vpos], vpos,
			     (current_screen->enable[vpos]
			      ? current_screen->used[vpos] : 0));
      current_screen->enable[vpos] = 0;
    }
  else
    reassert_line_highlight (new_screen->highlight[vpos], vpos);

  /* ??? */
  if (! current_screen->enable[vpos])
    {
      olen = 0;
    }
  else
    {
      obody = current_screen->contents[vpos];
      olen = current_screen->used[vpos];

      /* Check for bugs that clobber obody[-1].
	 Such bugs might well clobber more than that,
	 so we need to find them, not try to ignore them.  */
      if (obody[-1] != 0)
	abort ();

      if (! current_screen->highlight[vpos])
	{
	  /* Note obody[-1] is always 0.  */
	  if (!must_write_spaces)
	    while (obody[olen - 1] == ' ')
	      olen--;
	}
      else
	{
	  /* For an inverse-video line, remember we gave it
	     spaces all the way to the screen edge
	     so that the reverse video extends all the way across.  */
	  while (olen < screen_width - 1)
	    obody[olen++] = ' ';
	}
    }

  /* One way or another, this will enable the line being updated.  */
  current_screen->enable[vpos] = 1;
  current_screen->used[vpos] = new_screen->used[vpos];
#if !defined (ALLIANT) || defined (ALLIANT_2800)
  current_screen->highlight[vpos] = new_screen->highlight[vpos];
#else
  {
    /* Work around for compiler bug in cc on FX/80 which causes
       "dispnew.c", line 896: compiler error: no table entry for op OREG.  */
    char tmp;
    tmp = new_screen->highlight[vpos];
    current_screen->highlight[vpos] = tmp;
  }
#endif

  if (!new_screen->enable[vpos])
    {
      nlen = 0;
      goto just_erase;
    }

  nbody = new_screen->contents[vpos];
  nlen = new_screen->used[vpos];

  /* Pretend trailing spaces are not there at all,
     unless for one reason or another we must write all spaces.  */
  /* We know that the previous character byte contains 0.  */
  if (! new_screen->highlight[vpos])
    {
      if (!must_write_spaces)
	while (nlen > 0 && nbody[nlen - 1] == ' ')
	  nlen--;
      if (nlen == 0)
	goto just_erase;
    }
  else
    {
      /* For an inverse-video line, give it extra trailing spaces
	 all the way to the screen edge
	 so that the reverse video extends all the way across.  */
      while (nlen < screen_width - 1)
	nbody[nlen++] = ' ';
    }

  /* If there's no i/d char, quickly do the best we can without it.  */
  if (!char_ins_del_ok)
    {
      int i,j;

      for (i = 0; i < nlen; i++)
	{
	  if (i >= olen
	      || compare_char(nbody[i], obody[i])) /* 92.12.7 by K.Handa */
	    {
	      /* We found a non-matching char.  */
	      move_cursor (vpos, i);
	      for (j = 1; (i + j < nlen &&
			   (i + j >= olen
			    || compare_char(nbody[i + j], obody[i + j])));
		   j++);
	      /* Output this run of non-matching chars.  */ 
	      output_chars (nbody + i, j);
	      i += j - 1;
	      /* Now find the next non-match.  */
	    }
	}
      /* Clear the rest of the line, or the non-clear part of it.  */
      if (olen > nlen)
	{
	  move_cursor (vpos, nlen);
	  clear_end_of_line (olen);
	}

      /* Exchange contents between current_screen and new_screen.  */
      temp = new_screen->contents[vpos];
      new_screen->contents[vpos] = current_screen->contents[vpos];
      current_screen->contents[vpos] = temp;
/* 92.12.8, 93.6.21 by K.Handa */
      tem = current_screen->cmp_char_idx[vpos];
      current_screen->cmp_char_idx[vpos] = new_screen->cmp_char_idx[vpos];
      new_screen->cmp_char_idx[vpos] = tem;
/* end of patch */
      return;
    }

  if (!olen)
    {
      nsp = (must_write_spaces || new_screen->highlight[vpos])
	      ? 0 : count_blanks (nbody);
      if (nlen > nsp)
	{
	  move_cursor (vpos, nsp);
	  output_chars (nbody + nsp, nlen - nsp);
	}

      /* Exchange contents between current_screen and new_screen.  */
      temp = new_screen->contents[vpos];
      new_screen->contents[vpos] = current_screen->contents[vpos];
      current_screen->contents[vpos] = temp;
/* 92.12.8, 93.6.21 by K.Handa
      tem = current_screen->cmp_char_idx[vpos];
      current_screen->cmp_char_idx[vpos] = new_screen->cmp_char_idx[vpos];
      new_screen->cmp_char_idx[vpos] = tem;
   end of patch */
      return;
    }

  obody[olen] = 1;
  save = nbody[nlen];
  nbody[nlen] = 0;

  /* Compute number of leading blanks in old and new contents.  */
  osp = count_blanks (obody);
  if (!new_screen->highlight[vpos])
    nsp = count_blanks (nbody);
  else
    nsp = 0;

  /* Compute number of matching chars starting with first nonblank.  */
  begmatch = count_match (obody + osp, nbody + nsp);

  /* Spaces in new match implicit space past the end of old.  */
  /* A bug causing this to be a no-op was fixed in 18.29.  */
  if (!must_write_spaces && osp + begmatch == olen)
    {
      np1 = nbody + nsp;
      while (np1[begmatch] == ' ')
	begmatch++;
    }

  /* Avoid doing insert/delete char
     just cause number of leading spaces differs
     when the following text does not match. */
  if (begmatch == 0 && osp != nsp)
    osp = nsp = min (osp, nsp);

  /* Find matching characters at end of line */
  op1 = obody + olen;
  np1 = nbody + nlen;
  op2 = op1 + begmatch - min (olen - osp, nlen - nsp);
  /* 92.12.7 by K.Handa */
  while (op1 > op2 && !compare_char(op1[-1], np1[-1]))
    {
      op1--;
      np1--;
    }
  endmatch = obody + olen - op1;

  /* Put correct value back in nbody[nlen].
     This is important because direct_output_for_insert
     can write into the line at a later point.  */
  nbody[nlen] = save;
  /* Likewise, make sure that the null after the usable space in obody
     always remains a null.  */
  obody[olen] = 0;

  /* tem gets the distance to insert or delete.
     endmatch is how many characters we save by doing so.
     Is it worth it?  */

  tem = (nlen - nsp) - (olen - osp);
  if (endmatch && tem && endmatch <= DCICcost[tem])
    endmatch = 0;

  /* nsp - osp is the distance to insert or delete.
     begmatch + endmatch is how much we save by doing so.
     Is it worth it?  */

  if (begmatch + endmatch > 0 && nsp != osp
      && begmatch + endmatch <= DCICcost[nsp - osp])
    {
      begmatch = 0;
      endmatch = 0;
      osp = nsp = min (osp, nsp);
    }

  /* Now go through the line, inserting, writing and deleting as appropriate.  */

  if (osp > nsp)
    {
      move_cursor (vpos, nsp);
      delete_chars (osp - nsp);
    }
  else if (nsp > osp)
    {
      /* If going to delete chars later in line
	 and insert earlier in the line,
	 must delete first to avoid losing data in the insert */
      if (endmatch && nlen < olen + nsp - osp)
	{
	  move_cursor (vpos, nlen - endmatch + osp - nsp);
	  delete_chars (olen + nsp - osp - nlen);
	  olen = nlen - (nsp - osp);
	}
      move_cursor (vpos, osp);
      insert_chars ((int *)0, nsp - osp);
    }
  olen += nsp - osp;

  tem = nsp + begmatch + endmatch;
  if (nlen != tem || olen != tem)
    {
      move_cursor (vpos, nsp + begmatch);
      if (!endmatch || nlen == olen)
	{
	  /* If new text being written reaches right margin,
	     there is no need to do clear-to-eol at the end.
	     (and it would not be safe, since cursor is not
	     going to be "at the margin" after the text is done) */
	  if (nlen == screen_width)
	    olen = 0;
	  output_chars (nbody + nsp + begmatch, nlen - tem);
#ifdef obsolete
/* the following code loses disastrously if tem == nlen.
   Rather than trying to fix that case, I am trying the simpler
   solution found above.  */
	  /* If the text reaches to the right margin,
	     it will lose one way or another (depending on AutoWrap)
	     to clear to end of line after outputting all the text.
	     So pause with one character to go and clear the line then.  */
	  if (nlen == screen_width && fast_clear_end_of_line && olen > nlen)
	    {
	      /* endmatch must be zero, and tem must equal nsp + begmatch */
	      output_chars (nbody + tem, nlen - tem - 1);
	      clear_end_of_line (olen);
	      olen = 0;		/* Don't let it be cleared again later */
	      output_chars (nbody + nlen - 1, 1);
	    }
	  else
	    output_chars (nbody + nsp + begmatch, nlen - tem);
#endif
	}
      else if (nlen > olen)
	{
/* 92.3.19 by T.Enami -- to handle multi-column character.
	  output_chars (nbody + nsp + begmatch, olen - tem);
	  insert_chars (nbody + nsp + begmatch + olen - tem, nlen - olen);
*/
	  int out = olen - tem;
	  int ins;

	  while (MTRX_ORDER(nbody[nsp + begmatch + out])) out++;
	  ins = out - (olen - tem);

	  if (ins) {
	    extern char *TS_ins_multi_chars;
	    insert_chars ((int *)0, ins);
	    if (!TS_ins_multi_chars)
	      move_cursor (vpos, nsp + begmatch);
	  }
	  output_chars (nbody + nsp + begmatch, out);
	  if (nlen - olen - ins)
	    insert_chars (nbody + nsp + begmatch + out, nlen - olen - ins);
/* end of patch */
	  olen = nlen;
	}
      else if (olen > nlen)
	{
	  output_chars (nbody + nsp + begmatch, nlen - tem);
	  delete_chars (olen - nlen);
	  olen = nlen;
	}
    }

 just_erase:
  /* If any unerased characters remain after the new line, erase them.  */
  if (olen > nlen)
    {
      move_cursor (vpos, nlen);
      clear_end_of_line (olen);
    }
  
  /* Exchange contents between current_screen and new_screen.  */
  temp = new_screen->contents[vpos];
  new_screen->contents[vpos] = current_screen->contents[vpos];
  current_screen->contents[vpos] = temp;
/* 92.12.8, 93.6.21 by K.Handa
   tem = current_screen->cmp_char_idx[vpos];
   current_screen->cmp_char_idx[vpos] = new_screen->cmp_char_idx[vpos];
   new_screen->cmp_char_idx[vpos] = tem;
   end of patch */
}

int
count_blanks (
    int *str			/* 91.10.21 by K.Handa */
)
{
  register int *p = str;	/* 91.10.21 by K.Handa */
  while (*str++ == ' ');
  return str - p - 1;
}

int
count_match (
    int *str1, int *str2          /* 91.10.21 by K.Handa */
)
{
  register int *p1 = str1;	/* 91.10.21 by K.Handa */
  register int *p2 = str2;	/* 91.10.21 by K.Handa */
  while (!compare_char (*p1++, *p2++)); /* 92.12.7 by K.Handa */
  return p1 - str1 - 1;
}

/* 92.12.7 by K.Handa */
int
compare_char (unsigned int c1, unsigned int c2)
{
  register unsigned char *p1, *p2;

  if (MTRX_CMPCHAR (c1)) {
    if (MTRX_CMPCHAR (c2)) {
      if (MTRX_ORDER (c1) != MTRX_ORDER (c2)) /* 93.5.22 Y.Niibe */
	return 1;
      p1 = MTRX_CMPPTR (c1), p2 = MTRX_CMPPTR (c2);
      while (*p1 == *p2 && *p1) p1++, p2++;
      return (*p1 != *p2);
    } else
      return 1;
  } else {
    if (MTRX_CMPCHAR (c2))
      return 1;
    return (c1 != c2);
  }
}
/* end of patch */

DEFUN ("open-termscript", Fopen_termscript, Sopen_termscript,
  1, 1, "FOpen termscript file: ",
  "Start writing all terminal output to FILE as well as the terminal.\n\
FILE = nil means just close any termscript file currently open.")
  (Lisp_Object file)
{
  if (termscript != 0) fclose (termscript);
  termscript = 0;

  if (! NILP (file))
    {
      file = Fexpand_file_name (file, Qnil);
      termscript = fopen (XSTRING (file)->data, "w");
      if (termscript == 0)
	report_file_error ("Opening termscript", Fcons (file, Qnil));
    }
  return Qnil;
}

DEFUN ("set-screen-height", Fset_screen_height, Sset_screen_height, 1, 2, 0,
  "Tell redisplay that the screen has LINES lines.\n\
Optional second arg non-nil means that redisplay should use LINES lines\n\
but that the idea of the actual height of the screen should not be changed.")
  (Lisp_Object n, Lisp_Object pretend)
{
  CHECK_NUMBER (n, 0);
  change_screen_size (XINT (n), 0, !NILP (pretend), 0, 0);
  return Qnil;
}

DEFUN ("set-screen-width", Fset_screen_width, Sset_screen_width, 1, 2, 0,
  "Tell redisplay that the screen has COLS columns.\n\
Optional second arg non-nil means that redisplay should use COLS columns\n\
but that the idea of the actual width of the screen should not be changed.")
  (Lisp_Object n, Lisp_Object pretend)
{
  CHECK_NUMBER (n, 0);
  change_screen_size (0, XINT (n), !NILP (pretend), 0, 0);
  return Qnil;
}

DEFUN ("screen-height", Fscreen_height, Sscreen_height, 0, 0, 0,
  "Return number of lines on screen available for display.")
  (void)
{
  return make_number (screen_height);
}

DEFUN ("screen-width", Fscreen_width, Sscreen_width, 0, 0, 0,
  "Return number of columns on screen available for display.")
  (void)
{
  return make_number (screen_width);
}

#ifdef SIGWINCH
void
window_change_signal (int sig)
{
  int width, height;
  int old_errno = errno;

#ifdef nec_ews_svr2				/* hir@nec, 1990.3.10 */
  signal (SIGWINCH, SIG_IGN);
#endif /* nec_ews_svr2 */
  get_screen_size (&width, &height);
  /* Record the new size, but don't reallocate the data structures now.
     Let that be done later outside of the signal handler.  */
  change_screen_size (height, width, 0, 1, 0);
  signal (SIGWINCH, window_change_signal);

  errno = old_errno;
}
#endif /* SIGWINCH */

/* Do any change in screen size that was requested by a signal.  */

void
do_pending_window_change (void)
{
  /* If change_screen_size should have run before, run it now.  */
  while (delayed_size_change)
    {
      int newwidth = delayed_screen_width;
      int newheight = delayed_screen_height;
      delayed_size_change = 0;
      change_screen_size_1 (newheight, newwidth, 0, 0);
    }
}

/* Change the screen height and/or width.  Values may be given as zero to
   indicate no change is to take place.

   PRETEND is normally 0; 1 means change used-size only but don't
   change the size used for calculations; -1 means don't redisplay.

   If DELAYED, don't change the screen size now; just record the new
   size and do the actual change at a more convenient time.  The
   SIGWINCH handler and the X Windows ConfigureNotify code use this,
   because they can both be called at inconvenient times.

   FORCE means finish redisplay now regardless of pending input.
   This is effective only is DELAYED is not set.  */

void
change_screen_size (register int newlength, register int newwidth, register int pretend, register int delayed, register int force)
{
  /* Don't queue a size change if we won't really do anything.  */
  if ((newlength == 0 || newlength == screen_height)
      && (newwidth == 0 || newwidth == screen_width)) {
    /* 94.2.24 by K.Handa */
    delayed_screen_width = newwidth;
    delayed_screen_height = newlength;
    return;
  }
  /* If we can't deal with the change now, queue it for later.  */
  if (delayed)
    {
      delayed_screen_width = newwidth;
      delayed_screen_height = newlength;
      delayed_size_change = 1;
    }
  else
    {
      delayed_size_change = 0;
      change_screen_size_1 (newlength, newwidth, pretend, force);
    }
}

void
change_screen_size_1 (register int newlength, register int newwidth, register int pretend, register int force)
{
  if ((newlength == 0 || newlength == screen_height)
      && (newwidth == 0 || newwidth == screen_width))
    return;
  if (newlength && newlength != screen_height)
    {
      set_window_height (XWINDOW (minibuf_window)->prev, newlength - 1, 0);
      XFASTINT (XWINDOW (minibuf_window)->top) = newlength - 1;
      set_window_height (minibuf_window, 1, 0);
      screen_height = newlength;
      if (pretend <= 0)
	ScreenRows = newlength;
      set_terminal_window (0);
    }
  if (newwidth && newwidth != screen_width)
    {
      set_window_width (XWINDOW (minibuf_window)->prev, newwidth, 0);
      set_window_width (minibuf_window, newwidth, 0);
      screen_width = newwidth;
      if (pretend <= 0)
	ScreenCols = newwidth;
    }
  remake_screen_structures ();
  screen_garbaged = 1;
  calculate_costs ();
  force_redisplay += force;
  if (pretend >= 0)
    redisplay_preserve_echo_area ();
  force_redisplay -= force;
}

DEFUN ("baud-rate", Fbaud_rate, Sbaud_rate, 0, 0, 0,
  "Return the output baud rate of the terminal.")
  (void)
{
  Lisp_Object temp;
  XSET (temp, Lisp_Int, baud_rate);
  return temp;
}

DEFUN ("send-string-to-terminal", Fsend_string_to_terminal,
  Ssend_string_to_terminal, 1, 1, 0,
  "Send STRING to the terminal without alteration.\n\
Control characters in STRING will have terminal-dependent effects.")
  (Lisp_Object str)
{
  CHECK_STRING (str, 0);
  fwrite (XSTRING (str)->data, 1, XSTRING (str)->size, stdout);
  fflush (stdout);
  if (termscript)
    {
      fwrite (XSTRING (str)->data, 1, XSTRING (str)->size, termscript);
      fflush (termscript);
    }
  return Qnil;
}

DEFUN ("ding", Fding, Sding, 0, 1, 0,
  "Beep, or flash the screen.\n\
Terminates any keyboard macro currently executing unless an argument\n\
is given.")
  (Lisp_Object arg)
{
  if (!NILP (arg))
    {
      if (noninteractive)
	putchar (07);
      else
	ring_bell ();
      fflush (stdout);
    }
  else
    bell ();
  return Qnil;
}

void
bell (void)
{
  if (noninteractive)
    putchar (07);
  else if (!FROM_KBD)  /* Stop executing a keyboard macro. */
    error ("Keyboard macro terminated by a command ringing the bell");
  else
    ring_bell ();
  fflush (stdout);
}

DEFUN ("sleep-for", Fsleep_for, Ssleep_for, 1, 1, 0,
  "Pause, without updating display, for ARG seconds.")
  (Lisp_Object n)
{
  register int t;
#ifndef subprocesses
#ifdef HAVE_TIMEVAL
  struct timeval timeout, end_time, garbage1;
#endif /* HAVE_TIMEVAL */
#endif /* no subprocesses */

  CHECK_NUMBER (n, 0);
  t = XINT (n);
  if (t <= 0)
    return Qnil;

#ifdef subprocesses
  wait_reading_process_input (t, 0, 0);
#else /* No subprocesses */
  immediate_quit = 1;
  QUIT;

#ifdef VMS
  sys_sleep (t);
#else /* not VMS */
/* The reason this is done this way 
    (rather than defined (H_S) && defined (H_T))
   is because the VMS preprocessor doesn't grok `defined' */
#ifdef HAVE_SELECT
#ifdef HAVE_TIMEVAL
  gettimeofday (&end_time, &garbage1);
  end_time.tv_sec += t;

  while (1)
    {
      gettimeofday (&timeout, &garbage1);

      /* In effect, timeout = end_time - timeout.
	 Break if result would be negative.  */
      if (timeval_subtract (&timeout, end_time, timeout))
	break;

      if (!select (1, 0, 0, 0, &timeout))
	break;
    }
#else /* not HAVE_TIMEVAL */
  /* Is it safe to quit out of `sleep'?  I'm afraid to trust it.  */
  sleep (t);
#endif /* HAVE_TIMEVAL */
#else /* not HAVE_SELECT */
  sleep (t);
#endif /* HAVE_SELECT */
#endif /* not VMS */
  
  immediate_quit = 0;
#endif /* no subprocesses */
  return Qnil;
}

#ifdef HAVE_TIMEVAL

/* Subtract the `struct timeval' values X and Y,
   storing the result in RESULT.
   Return 1 if the difference is negative, otherwise 0.  */

int
timeval_subtract (struct timeval *result, struct timeval x, struct timeval y)
{
  /* Perform the carry for the later subtraction by updating y.
     This is safer because on some systems
     the tv_sec member is unsigned.  */
  if (x.tv_usec < y.tv_usec)
    {
      int nsec = (y.tv_usec - x.tv_usec) / 1000000 + 1;
      y.tv_usec -= 1000000 * nsec;
      y.tv_sec += nsec;
    }
  if (x.tv_usec - y.tv_usec > 1000000)
    {
      int nsec = (y.tv_usec - x.tv_usec) / 1000000;
      y.tv_usec += 1000000 * nsec;
      y.tv_sec -= nsec;
    }

  /* Compute the time remaining to wait.  tv_usec is certainly positive.  */
  result->tv_sec = x.tv_sec - y.tv_sec;
  result->tv_usec = x.tv_usec - y.tv_usec;

  /* Return indication of whether the result should be considered negative.  */
  return x.tv_sec < y.tv_sec;
}
#endif /* HAVE_TIMEVAL */

DEFUN ("sit-for", Fsit_for, Ssit_for, 1, 2, 0,
  "Perform redisplay, then wait for ARG seconds or until input is available.\n\
Optional second arg non-nil means don't redisplay.\n\
Redisplay is preempted as always if input arrives, and does not happen\n\
if input is available before it starts.\n\
Value is t if waited the full time with no input arriving.")
  (Lisp_Object n, Lisp_Object nodisp)
{
#ifndef subprocesses
#ifdef HAVE_TIMEVAL
  struct timeval timeout;
#else
  int timeout_sec;
#endif
  int waitchannels;
#endif /* no subprocesses */

  CHECK_NUMBER (n, 0);

  if (detect_input_pending ())
    return Qnil;

  if (EQ (nodisp, Qnil))
    redisplay_preserve_echo_area ();
  if (XINT (n) > 0)
    {
#ifdef subprocesses
#ifdef SIGIO
      gobble_input ();
#endif				/* SIGIO */
      wait_reading_process_input (XINT (n), 1, 1);
#else /* not subprocesses */
      immediate_quit = 1;
      QUIT;

      waitchannels = 1;
#ifdef VMS
      input_wait_timeout (XINT (n));
#else /* not VMS */
/* 91.10.16 by S.Hirano, 93.6.1 by M.Higashida */
#if defined(MSDOS) || defined(WIN32S)
      input_wait_timeout (XINT (n));
#else /* not MSDOS */
#ifndef HAVE_TIMEVAL
      timeout_sec = XINT (n);
      select (1, &waitchannels, 0, 0, &timeout_sec);
#else /* HAVE_TIMEVAL */
      timeout.tv_sec = XINT (n);  
      timeout.tv_usec = 0;
      select (1, &waitchannels, 0, 0, &timeout);
#endif /* HAVE_TIMEVAL */
#endif /* not MSDOS */
/* end of patch */
#endif /* not VMS */

      immediate_quit = 0;
#endif /* not subprocesses */
    }
  return detect_input_pending () ? Qnil : Qt;
}

char *terminal_type;

/* Initialization done when Emacs fork is started, before doing stty. */
/* Determine terminal type and set terminal_driver */
/* Then invoke its decoding routine to set up variables
  in the terminal package */

void
init_display (void)
{
/* 92.3.31 by K.Handa, 92.10.17, 93.2.17 by M.Higashida */
#ifdef HAVE_X_WINDOWS
  extern Lisp_Object Vxterm;
#endif
#ifdef HAVE_SUN_CONSOLE
  extern Lisp_Object Vsunterm;
#endif
#if defined(MSDOS) && defined(HAVE_VGA_ADAPTER)
  extern Lisp_Object Vvgaterm;
#endif
#ifdef WIN32
  extern Lisp_Object Vwin32term;
#endif
#ifdef HAVE_X_WINDOWS
  Vxterm = Qnil;
#endif
#ifdef HAVE_SUN_CONSOLE
  Vsunterm = Qnil;
#endif
#if defined(MSDOS) && defined(HAVE_VGA_ADAPTER)
  Vvgaterm = Qnil;
#endif
#ifdef WIN32
  Vwin32term = Qnil;
#endif
/* end of patch */

  Vwindow_system = Qnil;
  meta_key = 0;
  inverse_video = 0;
  cursor_in_echo_area = 0;
  terminal_type = (char *) 0;

  if (!inhibit_window_system)
    {
#ifdef HAVE_X_WINDOWS
      extern char *alternate_display;
      char *disp = (char *) egetenv ("DISPLAY");

      /* Note KSH likes to provide an empty string as an envvar value.  */
      if (alternate_display || (disp && *disp))
	{
	  x_term_init ();
	  Vxterm = Qt;
	  Vwindow_system = intern ("x");
#ifdef X11
	  Vwindow_system_version = make_number (11);
#else
	  Vwindow_system_version = make_number (10);
#endif
	  goto term_init_done;
	}
#endif /* HAVE_X_WINDOWS */
      ;
    }
/* 92.3.31 by K.Handa, 92.10.17, 93.2.17 by M.Higashida */
  else if (inhibit_window_system < 0)
    {
#ifdef HAVE_SUN_CONSOLE
      extern char *alternate_display;

      if (alternate_display) {
	sc_term_init ();
	Vsunterm = Qt;
	Vwindow_system = intern ("sc");
	goto term_init_done;
      }
#endif /* HAVE_SUN_CONSOLE */
#if defined(MSDOS) && defined(HAVE_VGA_ADAPTER)
      vga_term_init ();
      Vvgaterm = Qt;
      Vwindow_system = intern ("vga");
      goto term_init_done;
#endif /* MSDOS and HAVE_VGA_ADAPTER */
#ifdef WIN32
      win32_term_init ();
      Vwin32term = Qt;
      Vwindow_system = intern ("win32");
      goto term_init_done;
#endif /* WIN32 */
      ;
    }
/* end of patch */

  /* Record we aren't using a window system.  */
  inhibit_window_system = 1;

  /* Look at the TERM variable */
  terminal_type = (char *) getenv ("TERM");
  if (!terminal_type)
    {
#ifdef VMS
      fprintf (stderr, "Please specify your terminal type.\n\
For types defined in VMS, use  set term /device=TYPE.\n\
For types not defined in VMS, use  define emacs_term \"TYPE\".\n\
\(The quotation marks are necessary since terminal types are lower case.)\n");
#else
      fprintf (stderr, "Please set the environment variable TERM; see tset(1).\n");
#endif
      exit (1);
    }
  term_init (terminal_type);

 term_init_done:
  cmp_char_idx_max = 0;		/* 93.6.21 by K.Handa */
  remake_screen_structures ();
  calculate_costs ();

#ifdef SIGWINCH
#ifndef CANNOT_DUMP
  if (initialized)
#endif /* CANNOT_DUMP */
    if (inhibit_window_system > 0) /* 92.3.31 by K.Handa */
      signal (SIGWINCH, window_change_signal);
#endif /* SIGWINCH */
}

void
syms_of_display (void)
{
  defsubr (&Sopen_termscript);
  defsubr (&Sding);
  defsubr (&Ssit_for);
  defsubr (&Sscreen_height);
  defsubr (&Sscreen_width);
  defsubr (&Sset_screen_height);
  defsubr (&Sset_screen_width);
  defsubr (&Ssleep_for);
  defsubr (&Sbaud_rate);
  defsubr (&Ssend_string_to_terminal);

  DEFVAR_BOOL ("inverse-video", &inverse_video,
    "*Non-nil means use inverse-video.");
  DEFVAR_BOOL ("visible-bell", &visible_bell,
    "*Non-nil means try to flash the screen to represent a bell.\n\
Note: for X windows, you must use x-set-bell instead.");
  DEFVAR_BOOL ("no-redraw-on-reenter", &no_redraw_on_reenter,
    "*Non-nil means no need to redraw entire screen after suspending.\n\
It is up to you to set this variable to inform Emacs.");
  DEFVAR_LISP ("window-system", &Vwindow_system,
    "A symbol naming the window-system under which Emacs is running,\n\
\(such as `x'), or nil if emacs is running on an ordinary terminal.");
  DEFVAR_LISP ("window-system-version", &Vwindow_system_version,
    "Version number of the window system Emacs is running under.");
  DEFVAR_BOOL ("cursor-in-echo-area", &cursor_in_echo_area,
    "Non-nil means put cursor in minibuffer after any message displayed there.");
  /* 93.5.22 Y.Niibe */
  DEFVAR_BOOL ("r2l-double-cursor", &r2l_double_cursor,
    "*Non-nil means display double cursor when point comes between \n\
characters of different direction.");
  r2l_double_cursor = 1;
  /* end of patch */

  /* Initialize `window-system', unless init_display already decided it.  */
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    {
      Vwindow_system_version = Qnil;
      Vwindow_system = Qnil;
    }
}

