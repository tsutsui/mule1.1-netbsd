/* Display generation from window structure and buffer text.
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

/* 87.4.30  modified by K.Handa */
/* 87.7.12  modified by K.Handa */
/* 88.2.1   modified for Nemacs Ver.2.0 by K.Handa */
/* 88.5.30  modified for Nemacs Ver.2.1 by K.Handa */
/* 89.3.5   modified for Nemacs Ver.3.0 by K.Handa */
/* 89.11.18 modified for Nemacs Ver.3.2 by K.Handa */
/* 89.11.24 modified for attribute of characters by K.Handa */
/* 90.3.2   modified for Nemacs Ver.3.3.1 by S.Tomura
	'C' in mode-line-format */
/* 90.3.11  modified for Nemacs Ver.3.3.2 by A.Shibata
	Kanji display at left edge of screen when scrolled left. */
/* 91.10.21 modified for Nemacs Ver.4.0.0 by K.Handa (handa@etl.go.jp) */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.21  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
	display_text_line() and display_string is changed
	for handling invalid multi-byte character correctly. */
/* 92.3.28   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	In display_text_line(), prev_pos is initialized to (pos - 1). */
/* 92.4.1   modified for Mule Ver.0.9.2 by  Y.Niibe <gniibe@mri.co.jp>
	Calculation of tab_offset is fixed. */
/* 92.4.9   modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Support hexadecimal display of binary data. */
/* 92.4.15  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Size of message_buf is given by macro MSG_BUF_SIZE. */
/* 92.4.30  modified for Mule Ver.0.9.4 by Y.Niibe <gniibe@mri.co.jp>
	In display_string(), w->buffer is used instead of current_buffer. */
/* 92.5.18  modified for Mule Ver.0.9.4
	   	by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	In decode_mode_spec(), non-subprocess system is concerned. */
/* 92.7.2  modified for Mule Ver.0.9.5
			by M.Murakami <murakami@acrl.msr.mei.co.jp
	In display_text_line(), 'len + startp' -> 'endp'. */
/* 92.7.18  modified for Mule Ver.0.9.5 by Y.Niibe <gniibe@mri.co.jp>
	Bugs fixed in display_string() and display_text_line(). */
/* 92.9.8   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Big change in display_string() and display_text_line(). */
/* 92.9.30 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Fupdate_mode_lines() return nil. */
/* 92.11.10 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Composite character is supported. */
/* 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
        Preliminary support (92.8.2) for right-to-left languages. */
/* 93.4.14  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Highlight anti-direction characters. */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	display_text_line(): full support for composite character and
	private char-sets, and right-to-left char-sets.
	Support for double cursor for r2l. */

#include "config.h"
#include <stdio.h>
/*#include <ctype.h>*/
#undef NULL
#include "lisp.h"
#include "window.h"
#include "termchar.h"
#if defined(WIN32) && defined(USE_FATFS) /* 93.2.25 by M.Higashida */
#include "dispexte.h"
#else
#include "dispextern.h"
#endif
#include "buffer.h"
#include "indent.h"
#include "commands.h"
#include "macros.h"
#include "mule.h"		/* 91.10.19 by K.Handa */
#include "codeconv.h"		/* 92.1.21 by K.Handa */
#include "process.h"		/* 91.10.19 by K.Handa */

extern int interrupt_input;
extern int command_loop_level;

/* Nonzero means print newline before next minibuffer message.  */

int noninteractive_need_newline;

#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

/* The buffer position of the first character appearing
 entirely or partially on the current screen line.
 Or zero, which disables the optimization for the current screen line. */
static int this_line_bufpos;

/* Number of characters past the end of this line,
   including the terminating newline */
static int this_line_endpos;

/* The vertical position of this screen line. */
static int this_line_vpos;

/* Hpos value for start of display on this screen line.
   Usually zero, but negative if first character really began
   on previous line */
static int this_line_start_hpos;

/* Buffer that this_line variables are describing. */
static struct buffer *this_line_buffer;

/* Value of echo_area_contents when it was last acted on.
  If this is nonzero, there is a message on the screen
  in the minibuffer and it should be erased as soon
  as it is no longer requested to appear. */
char *prev_echo_area_contents;

/* Nonzero means truncate lines in all windows less wide than the screen */
int truncate_partial_width_windows;

Lisp_Object Vglobal_mode_string;

/* Marker for where to display an arrow on top of the buffer text.  */
Lisp_Object Voverlay_arrow_position;

/* String to display for the arrow.  */
Lisp_Object Voverlay_arrow_string;

/* Values of those variables at last redisplay.  */
Lisp_Object last_arrow_position, last_arrow_string;

/* If cursor motion alone moves point off screen,
   Try scrolling this many lines up or down if that will bring it back.  */
int scroll_step;

/* Nonzero means send various TERMCAP strings when screen is cleared.  */
int reset_terminal_on_clear;

/* Nonzero if try_window_id has made blank lines at window bottom
 since the last redisplay that paused */
static int blank_end_of_window;

/* Number of windows showing the buffer of the selected window.
   keyboard.c refers to this.  */
int buffer_shared;

/* display_text_line sets these to the screen position (origin 0) of point,
  whether the window is selected or not.
 Set one to -1 first to determine whether point was found afterwards.  */

static int point_vpos;
static int point_hpos;

int debug_end_pos;

/* Nonzero means display mode line highlighted */
int mode_line_inverse_video;

/* 93.4.14 by K.Handa -- Nonzero means highlight anti-direction characters. */
int highlight_reverse_direction;

struct position *display_text_line ();

/* Prompt to display in front of the minibuffer contents */
char *minibuf_prompt;

extern Lisp_Object Vminibuf_preprompt; /* 92.2.17 by K.Handa */

/* Width in columns of current minibuffer prompt.  */
int minibuf_prompt_width;

/* Message to display instead of minibuffer contents
   This is what the functions error and message make,
   and command echoing uses it as well.
   It overrides the minibuf_prompt as well as the buffer.  */
char *echo_area_contents;

/* True iff we should redraw the mode lines on the next redisplay */
int update_mode_lines;

/* Smallest number of characters before the gap
   at any time since last redisplay that finished.
   Valid for current buffer when try_window_id can be called.  */
int beg_unchanged;

/* Smallest number of characters after the gap
   at any time since last redisplay that finished.
   Valid for current buffer when try_window_id can be called.  */
int end_unchanged;

/* MODIFF as of last redisplay that finished;
 if it matches MODIFF, beg_unchanged and end_unchanged
 contain no useful information */
int unchanged_modified;

/* Nonzero if head_clip or tail_clip of current buffer has changed
 since last redisplay that finished */
int clip_changed;

/* Nonzero if window sizes or contents have changed
 since last redisplay that finished */
int windows_or_buffers_changed;

char *decode_mode_spec ();

Lisp_Object_Int display_string (struct window *, int, unsigned char *, int, char, Lisp_Object_Int, Lisp_Object_Int);


DEFUN ("redraw-display", Fredraw_display, Sredraw_display, 0, 0, "",
  "Clear the screen and output again what is supposed to appear on it.")
  ()
{
  if (screen_height == 0) abort (); /* Some bug zeros some core */
  if (reset_terminal_on_clear)
    set_terminal_modes ();
  clear_screen ();
  fflush (stdout);
  clear_screen_records ();
  if (screen_height == 0) abort (); /* Some bug zeros some core */
  windows_or_buffers_changed++;
  /* Mark all windows as INaccurate,
     so that every window will have its redisplay done.  */
  mark_window_display_accurate (XWINDOW (minibuf_window)->prev, 0);
  if (screen_height == 0) abort (); /* Some bug zeros some core */
  return Qnil;
}

/* Buffer used for messages formatted by `message', and by print.  */
char *message_buf;

/* Nonzero if message_buf is being used by print;
   zero if being used by message.  */
int message_buf_print;

/* dump an informative message to the minibuf */
/* VARARGS 1 */
message (m, a1, a2, a3)
     Lisp_Object_Int a1, a2, a3;
     char *m;
{
  if (noninteractive)
    {
      if (noninteractive_need_newline)
	putchar ('\n');
      noninteractive_need_newline = 0;
      printf (m, a1, a2, a3);
      printf ("\n");
      fflush (stdout);
    }
  else if (FROM_KBD)
    {
#ifdef NO_ARG_ARRAY
      Lisp_Object_Int a[3];
      a[0] = a1;
      a[1] = a2;
      a[2] = a3;

      doprnt (message_buf, MSG_BUF_SIZE, m, 3, a); /* 92.4.15 by K.Handa */
#else
      doprnt (message_buf, MSG_BUF_SIZE, m, 3, &a1); /* 92.4.15 by K.Handa */
#endif /* NO_ARG_ARRAY */
      echo_area_contents = message_buf;
      message_buf_print = 0;
      do {
	do_pending_window_change ();
	display_echo_area_contents ();
	update_screen (1, 1);
	do_pending_window_change ();
      } while (screen_garbaged);
    }
}

/* Specify m, a string, as a message in the minibuf.  */
message1 (m)
     char *m;
{
  if (noninteractive)
    {
      if (noninteractive_need_newline)
	putchar ('\n');
      noninteractive_need_newline = 0;
      printf ("%s\n", m);
      fflush (stdout);
    }
  else if (FROM_KBD)
    {
      echo_area_contents = m;
      do {
	do_pending_window_change ();
	display_echo_area_contents ();
	update_screen (1, 1);
	do_pending_window_change ();
      } while (screen_garbaged);
    }
}

display_echo_area_contents ()
{
  register Lisp_Object_Int vpos;

  if (screen_garbaged)
    {
      Fredraw_display ();
      screen_garbaged = 0;
    }

  if (echo_area_contents || minibuf_level == 0)
    {
      vpos = XFASTINT (XWINDOW (minibuf_window)->top);
      get_display_line (vpos, 0);
      display_string (XWINDOW (minibuf_window), vpos,
		      echo_area_contents ? echo_area_contents : "",
		      0, 0, 0, screen_width);

      /* If desired cursor location is on this line, put it at end of text */
      if (cursor_vpos == vpos)
	cursor_hpos = new_screen->used[vpos];

      /* Fill the rest of the minibuffer window with blank lines.  */
      {
	int i;

	for (i = vpos + 1; i < vpos + XWINDOW (minibuf_window)->height; i++)
	  {
	    get_display_line (i, 0);
	    display_string (XWINDOW (minibuf_window), vpos,
			    "", 0, 0, 0, screen_width);
	  }
      }
    }
  else if (!EQ (minibuf_window, selected_window))
    windows_or_buffers_changed++;

  if (EQ (minibuf_window, selected_window))
    this_line_bufpos = 0;

  prev_echo_area_contents = echo_area_contents;
}

/* 92.8.2, 93.5.22 Y.Niibe */

static
r2l_double_cursor_set (pos_p,w,p)
     struct position *pos_p;
     struct window *w;
     int p;
{
  int *ip;
  int c_width, dir;
  int display_direction = NULL(XBUFFER(w->buffer)->display_direction)?
    LEFT_TO_RIGHT: RIGHT_TO_LEFT;

  ip = char_width_dir_on (p,display_direction);
  c_width = ip[0]; dir = ip[1];

  if (display_direction == LEFT_TO_RIGHT)
    { /* LEFT TO RIGHT */
      if (pos_p->rev_hpos)
	{
	  if (pos_p->hpos == pos_p->vir_hpos && dir == LEFT_TO_RIGHT)
	    {
	      /*|123cba456 */
	      /*    [  [   *//*]]*/
	      cursor_form = CURSOR_LEFT | CURSOR_DOUBLE;
	      cursor_hpos_rev = pos_p->hpos - pos_p->rev_hpos;
	      cursor_hpos_rev = max (0,cursor_hpos_rev) + XFASTINT (w->left);
	    }
	  else
	    /*|123cba456 *//*[*/
	    /*     ]     */
	    cursor_form = CURSOR_RIGHT;
	}
      else
	{
	  if (dir == RIGHT_TO_LEFT)
	    {
	      /*|123cba456 *//*[[*/
	      /*   ]  ]    */
	      cursor_form = CURSOR_RIGHT | CURSOR_DOUBLE;
	      cursor_hpos_rev = pos_p->prevhpos;
	      if (pos_p->vir_hpos == 0)
		cursor_form &= ~CURSOR_DOUBLE;
	      cursor_hpos_rev = max (0,cursor_hpos_rev) + XFASTINT (w->left);
	    }
	  else
	    /*|123cba456 */
	    /*  [        *//*]*/
	    cursor_form = CURSOR_LEFT;
	}
    }
  else
    { /* RIGHT TO LEFT */
      int width = XFASTINT (w->width) - 1
	- (XFASTINT (w->width) + XFASTINT (w->left) != screen_width);
      cursor_hpos =
	2*XFASTINT(w->left) + width - cursor_hpos - c_width + 1;

      if (pos_p->rev_hpos)
	{
	  if (pos_p->hpos == pos_p->vir_hpos && dir == RIGHT_TO_LEFT)
	    {/*[[*/
	      /* fed123cba|*/
	      /*   ]  ]    */
	      cursor_form = CURSOR_RIGHT | CURSOR_DOUBLE;
	      cursor_hpos_rev = pos_p->hpos - pos_p->rev_hpos;
	      DEC_POS (p);
	      c_width = *char_width_dir_on (p,display_direction);
	      cursor_hpos_rev = XFASTINT (w->left) + width
		- max (0,cursor_hpos_rev) - c_width + 1;
	    }
	  else
	    /* fed123cba|*/
	    /*     [     *//*]*/
	    cursor_form = CURSOR_LEFT;
	}
      else
	{
	  if (dir == LEFT_TO_RIGHT)
	    {
	      /* fed123cba|*/
	      /*    [  [   *//*]]*/
	      cursor_form = CURSOR_LEFT | CURSOR_DOUBLE;
	      if (pos_p->vir_hpos == 0)
		cursor_form &= ~CURSOR_DOUBLE;
	      cursor_hpos_rev = pos_p->prevhpos;
	      DEC_POS (p);
	      c_width = *char_width_dir_on (p,display_direction);
	      cursor_hpos_rev = XFASTINT (w->left) + width
		- max (0,cursor_hpos_rev) - c_width + 1;
	    }
	  else
	    /* fed123cba|*//*[*/
	    /*        ]  */
	    cursor_form = CURSOR_RIGHT;
	}
    }
}
/* end of patch */

/* Do a screen update, taking possible shortcuts into account.
   This is the main external entry point for redisplay.

   If the last redisplay displayed an echo area message and that
   message is no longer requested, we clear the echo area
   or bring back the minibuffer if that is in use.

   Everyone would like to have a hook here to call eval,
   but that cannot be done safely without a lot of changes elsewhere.
   This can be called from signal handlers; with alarms set up;
   or with synchronous processes running.
   See the function `echo' in keyboard.c.
   See Fcall_process; if you called it from here, it could be
   entered recursively.  */

redisplay ()
{
  register struct window *w = XWINDOW (selected_window);
  register int pause;
  int inhibit_hairy_id = 0;
  int must_finish = 0;
  int all_windows;
  register Lisp_Object_Int tlbufpos, tlendpos;
  struct position pos;
  extern int input_pending;

  if (noninteractive)
    return;

  /* Notice any pending interrupt request to change screen size.  */
  do_pending_window_change ();

  if (screen_garbaged)
    {
      Fredraw_display ();
      screen_garbaged = 0;
    }

  /* Initially we have nothing to update on the screen.  */
  bzero (new_screen->enable, new_screen->height);

  if (echo_area_contents != 0 || prev_echo_area_contents != 0)
    {
      display_echo_area_contents ();
      must_finish = 1;
    }

  if (clip_changed || windows_or_buffers_changed)
    update_mode_lines++;

  /* Detect case that we need to write a star in the mode line.  */
  if (XFASTINT (w->last_modified) < MODIFF
      && XFASTINT (w->last_modified) <= current_buffer->save_modified)
    {
      w->update_mode_line = Qt;
      if (buffer_shared > 1)
	update_mode_lines++;
    }

  all_windows = update_mode_lines || buffer_shared > 1;

  /* If specs for an arrow have changed, do thorough redisplay
     to ensure we remove any arrow that should no longer exist.  */
  if (Voverlay_arrow_position != last_arrow_position
      || Voverlay_arrow_string != last_arrow_string)
    all_windows = 1, clip_changed = 1;

  tlbufpos = this_line_bufpos;
  tlendpos = this_line_endpos;
  if (!all_windows && tlbufpos > 0 && NULL (w->update_mode_line)
      /* Make sure recorded data applies to current buffer, etc */
      && this_line_buffer == current_buffer
      && current_buffer == XBUFFER (w->buffer)
      && NULL (w->force_start)
      /* Point must be on the line that we have info recorded about */
      && point >= tlbufpos
      && point <= Z - tlendpos
      /* All text outside that line, including its final newline,
	 must be unchanged */
      && (XFASTINT (w->last_modified) >= MODIFF
	  || (beg_unchanged >= tlbufpos - 1
	      && GPT >= tlbufpos
	      /* If selective display, can't optimize
		 if the changes start at the beginning of the line.  */
	      && ((XTYPE (current_buffer->selective_display) == Lisp_Int
		   && XINT (current_buffer->selective_display) > 0
		   ? (beg_unchanged >= tlbufpos
		      && GPT > tlbufpos)
		   : 1))
	      && end_unchanged >= tlendpos
	      && Z - GPT >= tlendpos)))
    {
      if (tlbufpos > BEGV && FETCH_CHAR (tlbufpos - 1) != '\n'
	  && (tlbufpos == ZV
	      || FETCH_CHAR (tlbufpos) == '\n'))
	/* Former continuation line has disappeared by becoming empty */
	goto cancel;
      else if (XFASTINT (w->last_modified) < MODIFF
	       || EQ (selected_window, minibuf_window))
	{
	  struct position val;	/* 92.4.1 by Y.Niibe */
	  int prevline;		/* 92.4.1 by Y.Niibe */

	  point_vpos = -1;
/* 92.4.1 by Y.Niibe */
	  prevline = find_next_newline (tlbufpos, -1);
	  val = *compute_motion (prevline, 0,
				 XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0,
				 tlbufpos, 1 << (INTBITS - 2), 0,
				 XFASTINT (w->width) - 1
				 - (XFASTINT (w->width) + XFASTINT (w->left)
				    != screen_width),
				 XINT (w->hscroll), 0, 0); /* 92.8.2 Y.Niibe */
	  if (val.hpos != this_line_start_hpos)
	    goto cancel;
/* end of patch */
	  display_text_line (w, tlbufpos, this_line_vpos, this_line_start_hpos,
			     val.tab_offset); /* 92.4.1 by Y.Niibe */
	  /* If line contains point, is not continued,
		 and ends at same distance from eob as before, we win */
	  if (point_vpos >= 0 && this_line_bufpos
	      && this_line_endpos == tlendpos)
	    {
	      /* Done by display_text_line
		 cursor_hpos = point_hpos;
	         cursor_vpos = this_line_vpos;
	       */
	      if (XFASTINT (w->width) != screen_width)
		preserve_other_columns (w);
	      goto update;
	    }
	  else
	    goto cancel;
	}
      else if (point == XFASTINT (w->last_point))
	{
	  if (!must_finish)
	    return;
	  goto update;
	}
      else
	{
	  pos = *compute_motion (tlbufpos, 0,
				 XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0,
				 point, 2, - (1 << (SHORTBITS - 1)),
				 XFASTINT (w->width) - 1
				 - (XFASTINT (w->width) + XFASTINT (w->left)
				    != screen_width),
				 XINT (w->hscroll),
				 pos_tab_offset (w, tlbufpos), 0);/* 92.8.2 Y.Niibe */
	  if (pos.vpos < 1)
	    {
/* original line is
	      cursor_hpos = max (XFASTINT (w->left), pos.hpos);
   but I guess that's bug... 92.8.2 Y.Niibe
 */
	      cursor_hpos = max (0, pos.hpos) + XFASTINT (w->left);
	      cursor_vpos = this_line_vpos;
	      r2l_double_cursor_set (&pos,w,point); /* 93.5.22 Y.Niibe */
	      goto update;
	    }
	  else
	    goto cancel;
	}
    cancel:
      /* Text changed drastically or point moved off of line */
      cancel_line (this_line_vpos);
    }

  this_line_bufpos = 0;

  if (all_windows)
    redisplay_all_windows ();
  else
    {
      redisplay_window (selected_window, 1);
      if (XFASTINT (w->width) != screen_width)
	preserve_other_columns (w);
    }

update: 
  /* Prevent various kinds of signals during display update.
     stdio is not robust about handling signals,
     which can cause an apparent I/O error.  */
  if (interrupt_input)
    unrequest_sigio ();
  stop_polling ();

  pause = update_screen (0, 0);

  /* If screen does not match, prevent doing single-line-update next time.
     Also, don't forget to check every line to update the arrow.  */
  if (pause)
    {
      this_line_bufpos = 0;
      if (!NULL (last_arrow_position))
	{
	  last_arrow_position = Qt;
	  last_arrow_string = Qt;
	}
      /* If we pause after scrolling, some lines in PhysScreen may be null
	 and then preserve_other_columns won't be able to preserve all
	 the vertical-bar separators.  So avoid using it in that case.  */
      if (XFASTINT (w->width) != screen_width)
	update_mode_lines = 1;
    }

  /* Now text on screen agrees with windows, so
     put info into the windows for partial redisplay to follow */

  if (!pause)
    {
      struct buffer *b = XBUFFER (w->buffer);

      blank_end_of_window = 0;
      clip_changed = 0;
      unchanged_modified = BUF_MODIFF (b);
      beg_unchanged = BUF_GPT (b) - BUF_BEG (b);
      end_unchanged = BUF_Z (b) - BUF_GPT (b);

      XFASTINT (w->last_point) = BUF_PT (b);
      XFASTINT (w->last_point_x) = cursor_hpos;
      XFASTINT (w->last_point_y) = cursor_vpos;

      if (all_windows)
	mark_window_display_accurate (XWINDOW (minibuf_window)->prev, 1);
      else
	{
	  w->update_mode_line = Qnil;
	  XFASTINT (w->last_modified) = BUF_MODIFF (b);
	  w->window_end_valid = Qt;
	  last_arrow_position = Voverlay_arrow_position;
	  last_arrow_string = Voverlay_arrow_string;
	}
      update_mode_lines = 0;
      windows_or_buffers_changed = 0;
    }

  /* Start SIGIO interrupts coming again.
     Having them off during the code above
     makes it less likely one will discard output,
     but not impossible, since there might be stuff
     in the system buffer here.
     But it is much hairier to try to do anything about that.  */

  if (interrupt_input)
    request_sigio ();
  start_polling ();

  do_pending_window_change ();

  if (screen_garbaged)
    redisplay ();
}

/* Redisplay, but leave alone any recent echo area message
   unless another message has been requested in its place.  */

redisplay_preserve_echo_area ()
{
  if (echo_area_contents == 0 && prev_echo_area_contents != 0)
    {
      echo_area_contents = prev_echo_area_contents;
      redisplay ();
      echo_area_contents = 0;
    }
  else
    redisplay ();
}

mark_window_display_accurate (window, flag)
     Lisp_Object window;
     int flag;
{
  register struct window *w;

  for (;!NULL (window); window = w->next)
    {
      w = XWINDOW (window);

      if (!NULL (w->buffer))
	XFASTINT (w->last_modified)
	  = !flag ? 0 : BUF_MODIFF (XBUFFER (w->buffer));
      w->window_end_valid = Qt;
      w->update_mode_line = Qnil;

      if (!NULL (w->vchild))
	mark_window_display_accurate (w->vchild, flag);
      if (!NULL (w->hchild))
	mark_window_display_accurate (w->hchild, flag);
    }

  if (flag)
    {
      last_arrow_position = Voverlay_arrow_position;
      last_arrow_string = Voverlay_arrow_string;
    }
  else
    {
      /* t is unequal to any useful value of Voverlay_arrow_... */
      last_arrow_position = Qt;
      last_arrow_string = Qt;
    }
}

int do_id = 1;

/* Do full redisplay of one or all windows.
  This does not include updating the screen;
  just generating lines to pass to update_screen.  */

/* Entry point to redisplay all windows */

redisplay_all_windows ()
{
  buffer_shared = 0;

  redisplay_windows (XWINDOW (minibuf_window)->prev);
}

redisplay_windows (window)
     Lisp_Object window;
{
  for (; !NULL (window); window = XWINDOW (window)->next)
    redisplay_window (window, 0);
}

redisplay_window (window, just_this_one)
     Lisp_Object window;
     int just_this_one;
{
  register struct window *w = XWINDOW (window);
  Lisp_Object_Int height;
  struct buffer *old = current_buffer;
  register Lisp_Object_Int width = XFASTINT (w->width) - 1
    - (XFASTINT (w->width) + XFASTINT (w->left) != screen_width);
  register int startp;
  register Lisp_Object_Int hscroll = XINT (w->hscroll);
  struct position pos;
  int opoint;
  int tem;

  if (screen_height == 0) abort (); /* Some bug zeros some core */

  /* If this is a combination window, do its children; that's all.  */

  if (!NULL (w->vchild))
    {
      redisplay_windows (w->vchild);
      return;
    }
  if (!NULL (w->hchild))
    {
      redisplay_windows (w->hchild);
      return;
    }
  if (NULL (w->buffer))
    abort ();

  if (update_mode_lines)
    w->update_mode_line = Qt;

  /* Otherwise set up data on this window; select its buffer and point value */

  height = XFASTINT (w->height);
  if (w != XWINDOW (minibuf_window))
    height--;
  else if (echo_area_contents)
    return 0;

  current_buffer = XBUFFER (w->buffer);

  if (!just_this_one
      && current_buffer == XBUFFER (XWINDOW (selected_window)->buffer))
    buffer_shared++;

  /* Go temporarily to where point is in the window being displayed.
     We will restore point at the end.  */
  opoint = point;
  if (!EQ (window, selected_window))
    {
      SET_PT (marker_position (w->pointm));
      if (point < BEGV)
	point = BEGV;
      else if (point > ZV)
	point = ZV;
    }

  /* If window-start is screwed up, choose a new one.  */

  if (XMARKER (w->start)->buffer != current_buffer)
    goto recenter;

  startp = marker_position (w->start);

  /* Handle case where place to start displaying has been specified */

  if (!NULL (w->force_start))
    {
      w->update_mode_line = Qt;
      w->force_start = Qnil;
      XFASTINT (w->last_modified) = 0;

      /* Constrain the starting position to be within the visible range.  */
      startp = clip_to_bounds (BEGV, startp, ZV);

      try_window (window, startp);
      if (point_vpos < 0)
	{
	  /* If point does not appear, move point so it does appear */
	  pos = *compute_motion (startp, 0,
				((EQ (window, minibuf_window) && startp == 1)
				 ? minibuf_prompt_width : 0)
				+
				(hscroll ? 1 - hscroll : 0),
				ZV, height / 2,
				- (1 << (SHORTBITS - 1)),
				/* 92.8.2 Y.Niibe */
				width, hscroll, pos_tab_offset (w, startp), 0);
	  SET_PT (pos.bufpos);
	  if (w != XWINDOW (selected_window))
	    Fset_marker (w->pointm, make_number (point), Qnil);
	  else
	    /* We want to change point permanently,
	       so don't restore the old value.  */
	    opoint = point;

	  if (EQ (window, selected_window))
	    {
	      cursor_hpos = max (0, pos.hpos) + XFASTINT (w->left);
	      cursor_vpos = pos.vpos + XFASTINT (w->top);
	      r2l_double_cursor_set (&pos,w,point); /* 93.5.22 Y.Niibe */
	    }
	}
      goto done;
    }

  /* Handle case where text has not changed, only point,
     and it has not moved off the screen */

  /* This code is not used for minibuffer for the sake of
     the case of redisplaying to replace an echo area message;
     since in that case the minibuffer contents per se are usually unchanged.
     This code is of no real use in the minibuffer since
     the handling of this_line_bufpos, etc.,
     in redisplay handles the same cases.  */

  if (XFASTINT (w->last_modified) >= MODIFF
      && point >= startp && !clip_changed
      && (just_this_one || XFASTINT (w->width) == screen_width)
      && !EQ (window, minibuf_window))
    {
      pos = *compute_motion (startp, 0, (hscroll ? 1 - hscroll : 0),
			     point, height + 1, 10000, width, hscroll,
			     pos_tab_offset (w, startp), 0); /* 92.8.2 Y.Niibe */

      if (pos.vpos < height)
	{
	  /* Ok, point is still on screen */
	  if (w == XWINDOW (selected_window))
	    {
	      /* These variables are supposed to be origin 1 */
	      cursor_hpos = max (0, pos.hpos) + XFASTINT (w->left);
	      cursor_vpos = pos.vpos + XFASTINT (w->top);
	      r2l_double_cursor_set (&pos,w,point); /* 93.5.22 Y.Niibe */
	    }
/* This doesn't do the trick, because if a window to the right of
 this one must be redisplayed, this does nothing because there
 is nothing in DesiredScreen yet, and then the other window is
 redisplayed, making likes that are empty in this window's columns.
	  if (XFASTINT (w->width) != screen_width)
	    preserve_my_columns (w);
*/
	  goto done;
	}
      /* Don't bother trying redisplay with same start;
	we already know it will lose */
    }
  /* If current starting point was originally the beginning of a line
     but no longer is, find a new starting point.  */
  else if (!NULL (w->start_at_line_beg)
	   && !(startp == BEGV
		|| FETCH_CHAR (startp - 1) == '\n'))
    {
      goto recenter;
    }
  else if (just_this_one && !EQ (window, minibuf_window)
	   && point >= startp
	   && XFASTINT (w->last_modified)
	   && ! EQ (w->window_end_valid, Qnil)
	   && do_id && !clip_changed
	   && !blank_end_of_window
	   && XFASTINT (w->width) == screen_width
	   && EQ (last_arrow_position, Voverlay_arrow_position)
	   && EQ (last_arrow_string, Voverlay_arrow_string)
	   && (tem = try_window_id (selected_window))
	   && tem != -2)
    {
      /* tem > 0 means success.  tem == -1 means choose new start.
	 tem == -2 means try again with same start,
	  and nothing but whitespace follows the changed stuff.
	 tem == 0 means try again with same start.  */
      if (tem > 0)
	{
	  goto done;
	}
    }
  else if (startp >= BEGV && startp <= ZV
	   /* Avoid starting display at end of buffer! */
	   && (startp < ZV || startp == BEGV
	       || (XFASTINT (w->last_modified) >= MODIFF)))
    {
      /* Try to redisplay starting at same place as before */
      /* If point has not moved off screen, accept the results */
      try_window (window, startp);
      if (point_vpos >= 0)
	goto done;
      else
	cancel_my_columns (w);
    }

  XFASTINT (w->last_modified) = 0;
  w->update_mode_line = Qt;

  /* Try to scroll by specified few lines */

  if (scroll_step && !clip_changed)
    {
      if (point > startp)
	{
	  pos = *vmotion (Z - XFASTINT (w->window_end_pos),
			  scroll_step, width, hscroll, window);
	  if (pos.vpos >= height)
	    goto scroll_fail;
	}

      pos = *vmotion (startp, point < startp ? - scroll_step : scroll_step,
		      width, hscroll, window);

      if (point >= pos.bufpos)
	{
	  try_window (window, pos.bufpos);
	  if (point_vpos >= 0)
	    goto done;
	  else
	    cancel_my_columns (w);
	}
    scroll_fail: ;
    }

  /* Finally, just choose place to start which centers point */

recenter:
  pos = *vmotion (point, - height / 2, width, hscroll, window);
  try_window (window, pos.bufpos);

  startp = marker_position (w->start);
  w->start_at_line_beg = 
    (startp == BEGV || FETCH_CHAR (startp - 1) == '\n') ? Qt : Qnil;

done:
  /* If window not full width, must redo its mode line
     if the window to its side is being redone */
  if ((!NULL (w->update_mode_line)
       || (!just_this_one && width < screen_width - 1))
      && !EQ (window, minibuf_window))
    display_mode_line (w);

  SET_PT (opoint);
  current_buffer = old;
}

/* Do full redisplay on one window,
   starting at position `pos'.  */

try_window (window, pos)
     Lisp_Object window;
     register int pos;
{
  register struct window *w = XWINDOW (window);
  register int height = XFASTINT (w->height) - !EQ (window, minibuf_window);
  register int vpos = XFASTINT (w->top);
  register int last_text_vpos = vpos;
  int tab_offset = pos_tab_offset (w, pos);

  struct position val;

  Fset_marker (w->start, make_number (pos), Qnil);

  point_vpos = -1;
  val.hpos = XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0;

  while (--height >= 0)
    {
      val = *display_text_line (w, pos, vpos, val.hpos, tab_offset);
      tab_offset = val.tab_offset; /* 92.4.1 by Y.Niibe */
      if (val.vpos) tab_offset = 0;
      vpos++;
      if (pos != val.bufpos)
	last_text_vpos
	  /* Next line, unless prev line ended in end of buffer with no cr */
	  = vpos - (val.vpos && FETCH_CHAR (val.bufpos - 1) != '\n');
      pos = val.bufpos;
    }

  /* If last line is continued in middle of character,
     include the split character in the text considered on the screen */
  if (val.hpos < (XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0))
    pos++;

  /* Say where last char on screen will be, once redisplay is finished.  */
  XFASTINT (w->window_end_pos) = Z - pos;
  XFASTINT (w->window_end_vpos) = last_text_vpos - XFASTINT (w->top);
  /* But that is not valid info until redisplay finishes.  */
  w->window_end_valid = Qnil;
}

/* Try to redisplay when buffer is modified locally,
 computing insert/delete line to preserve text outside
 the bounds of the changes.
 Return 1 if successful, 0 if if cannot tell what to do,
 or -1 to tell caller to find a new window start,
 or -2 to tell caller to do normal redisplay with same window start.  */

static struct position debug_bp, debug_ep, debug_xp, debug_pp;
static int debug_start_vpos, debug_stop_vpos, debug_scroll_amount;
static int debug_dont_scroll;

try_window_id (window)
     Lisp_Object window;
{
  int pos;
  register struct window *w = XWINDOW (window);
  register int height = XFASTINT (w->height) - !EQ (window, minibuf_window);
  Lisp_Object_Int top = XFASTINT (w->top);
  Lisp_Object_Int start = marker_position (w->start);
  int width = XFASTINT (w->width) - 1
    - (XFASTINT (w->width) + XFASTINT (w->left) != screen_width);
  int hscroll = XINT (w->hscroll);
  int lmargin = hscroll > 0 ? 1 - hscroll : 0;
  register int vpos;
  register int i, tem;
  int last_text_vpos = 0;
  int stop_vpos;

  struct position val, bp, ep, xp, pp;
  int scroll_amount = 0;
  int delta;
  int tab_offset, epto;

  if (GPT - BEG < beg_unchanged)
    beg_unchanged = GPT - BEG;
  if (Z - GPT < end_unchanged)
    end_unchanged = Z - GPT;

  if (beg_unchanged + 1 < start)
    return 0;			/* Give up if changes go above top of window */

  /* Find position before which nothing is changed.  */
  bp = *compute_motion (start, 0, lmargin,
			beg_unchanged + 1, height + 1, 0, width, hscroll,
			pos_tab_offset (w, start), 0); /* 92.8.2 Y.Niibe */
  if (bp.vpos >= height)
    {
      if (point < bp.bufpos && !bp.contin)
	{
	  /* All changes are below the screen, and point is on the screen.
	     We don't need to change the screen at all.
	     But we need to update window_end_pos to account for
	     any change in buffer size.  */
	  bp = *compute_motion (start, 0, lmargin,
				Z, height, 0,
				/* 92.8.2 Y.Niibe */
				width, hscroll, pos_tab_offset (w, start), 0);
	  XFASTINT (w->window_end_vpos) = height;
	  XFASTINT (w->window_end_pos) = Z - bp.bufpos;
	  return 1;
	}
      return 0;
    }

  vpos = bp.vpos;

  /* Find beginning of that screen line.  Must display from there.  */
  bp = *vmotion (bp.bufpos, 0, width, hscroll, window);

  pos = bp.bufpos;
  val.hpos = lmargin;
  if (pos < start)
    return -1;

  /* If about to start displaying at the beginning of a continuation line,
     really start with previous screen line, in case it was not
     continued when last redisplayed */
  if ((bp.contin && bp.bufpos - 1 == beg_unchanged && vpos > 0)
      ||
      /* Likewise if we have to worry about selective display.  */
      (XTYPE (current_buffer->selective_display) == Lisp_Int
       && XINT (current_buffer->selective_display) > 0
       && bp.bufpos - 1 == beg_unchanged && vpos > 0))
    {
      bp = *vmotion (bp.bufpos, -1, width, hscroll, window);
      --vpos;
      pos = bp.bufpos;
    }

  if (bp.contin && bp.hpos != lmargin)
    {
      val.hpos = bp.prevhpos - width + lmargin;
      pos--;
    }

  bp.vpos = vpos;

  /* Find first visible newline after which no more is changed.  */
  tem = find_next_newline (Z - max (end_unchanged, Z - ZV),
			   1);
  if (XTYPE (current_buffer->selective_display) == Lisp_Int
      && XINT (current_buffer->selective_display) > 0)
    while (tem < ZV - 1
	   && (position_indentation (tem)
	       >= XINT (current_buffer->selective_display)))
      tem = find_next_newline (tem, 1);

  /* Compute the cursor position after that newline.  */
  ep = *compute_motion (pos, vpos, val.hpos, tem,
			height, - (1 << (SHORTBITS - 1)),
			width, hscroll, pos_tab_offset (w, bp.bufpos),
			0);  /* 92.8.2 Y.Niibe */

  /* If changes reach past the text available on the screen,
     just display rest of screen.  */
  if (ep.bufpos > Z - XFASTINT (w->window_end_pos))
    stop_vpos = height;
  else
    stop_vpos = ep.vpos;

  /* If no newline before ep, the line ep is on includes some changes
     that must be displayed.  Make sure we don't stop before it.  */
  /* Also, if changes reach all the way until ep.bufpos,
     it is possible that something was deleted after the
     newline before it, so the following line must be redrawn. */
  if (stop_vpos == ep.vpos
      && (ep.bufpos == BEGV
	  || FETCH_CHAR (ep.bufpos - 1) != '\n'
	  || ep.bufpos == Z - end_unchanged))
    stop_vpos = ep.vpos + 1;

  point_vpos = -1;
  debug_dont_scroll = 0;

  /* If changes do not reach to bottom of window,
     figure out how much to scroll the rest of the window */
  if (stop_vpos < height)
    {
      /* Now determine how far up or down the rest of the window has moved */
      epto = pos_tab_offset (w, ep.bufpos);
      /* 92.8.2 Y.Niibe */
      xp = *compute_motion (ep.bufpos, ep.vpos, ep.vir_hpos,
			    Z - XFASTINT (w->window_end_pos),
			    10000, 0, width, hscroll, epto, ep.rev_hpos);
      scroll_amount = xp.vpos - XFASTINT (w->window_end_vpos);

      /* Is everything on screen below the changes whitespace?
	 If so, no scrolling is really necessary.  */
      for (i = ep.bufpos; i < xp.bufpos; i++)
	{
	  tem = FETCH_CHAR (i);
	  if (tem != ' ' && tem != '\n' && tem != '\t')
	    break;
	}
      if (i == xp.bufpos)
	return -2;

      XFASTINT (w->window_end_vpos) += scroll_amount;

      /* Before doing any scrolling, verify that point will be on screen. */
      if (point > ep.bufpos && !(point <= xp.bufpos && xp.bufpos < height))
	{
	  if (point <= xp.bufpos)
	    {
	      /* 92.8.2 Y.Niibe */
	      pp = *compute_motion (ep.bufpos, ep.vpos, ep.vir_hpos,
				    point, height, - (1 << (SHORTBITS - 1)),
				    width, hscroll, epto, ep.rev_hpos);
	    }
	  else
	    {
	      /* 92.8.2 Y.Niibe */
	      pp = *compute_motion (xp.bufpos, xp.vpos, xp.vir_hpos,
				    point, height, - (1 << (SHORTBITS - 1)),
				    width, hscroll,
				    pos_tab_offset (w, xp.bufpos),
				    xp.rev_hpos);
	    }
	  if (pp.bufpos < point || pp.vpos == height)
	    return 0;
/* 93.5.22 Y.Niibe*/
	  cursor_vpos = point_vpos = pp.vpos + top;
	  cursor_hpos = max(pp.hpos,0) + XFASTINT (w->left);
	  r2l_double_cursor_set (&pp,w,point); /* 93.5.22 Y.Niibe */
/* end of patch */
	}

      if (stop_vpos - scroll_amount >= height
	  || ep.bufpos == xp.bufpos)
	{
	  if (scroll_amount < 0)
	    stop_vpos -= scroll_amount;
	  scroll_amount = 0;
	  debug_dont_scroll = 1;
	  /* In this path, we have altered window_end_vpos
	     and not left it negative.
	     We must make sure that, in case display is preempted
	     before the screen changes to reflect what we do here,
	     further updates will not come to try_window_id
	     and assume the screen and window_end_vpos match.  */
	  blank_end_of_window = 1;
	}
      else if (!scroll_amount)
	{}
      else if (bp.bufpos == Z - end_unchanged)
	{
	  /* If reprinting everything is nearly as fast as scrolling,
	     don't bother scrolling.  Can happen if lines are short.  */
	  if (scroll_cost (bp.vpos + top - scroll_amount,
			   top + height - max (0, scroll_amount),
			   scroll_amount)
	      > xp.bufpos - bp.bufpos - 20)
	    /* Return "try normal display with same window-start."
	       Too bad we can't prevent further scroll-thinking.  */
	    return -2;
	  /* If pure deletion, scroll up as many lines as possible.
	     In common case of killing a line, this can save the
	     following line from being overwritten by scrolling
	     and therefore having to be redrawn.  */
	  tem = scroll_screen_lines (bp.vpos + top - scroll_amount,
				     top + height - max (0, scroll_amount),
				     scroll_amount);
	  if (!tem) stop_vpos = height;
	}
      else if (scroll_amount)
	{
	  /* If reprinting everything is nearly as fast as scrolling,
	     don't bother scrolling.  Can happen if lines are short.  */
	  /* Note that if scroll_amount > 0, xp.bufpos - bp.bufpos is an
	     overestimate of cost of reprinting, since xp.bufpos
	     would end up below the bottom of the window.  */
	  if (scroll_cost (ep.vpos + top - scroll_amount,
			   top + height - max (0, scroll_amount),
			   scroll_amount)
	      > xp.bufpos - ep.bufpos - 20)
	    /* Return "try normal display with same window-start."
	       Too bad we can't prevent further scroll-thinking.  */
	    return -2;
	  tem = scroll_screen_lines (ep.vpos + top - scroll_amount,
				     top + height - max (0, scroll_amount),
				     scroll_amount);
	  if (!tem) stop_vpos = height;
	}
    }

  debug_scroll_amount = scroll_amount;
  debug_bp = bp;
  debug_ep = ep;
  debug_xp = xp;
  debug_pp = pp;

  /* In any case, do not display past bottom of window */
  if (stop_vpos >= height)
    {
      stop_vpos = height;
      scroll_amount = 0;
    }

  debug_stop_vpos = stop_vpos;
  debug_start_vpos = vpos;

  /* Handle case where pos is before w->start --
     can happen if part of line had been clipped and is not clipped now */
  if (vpos == 0 && pos < marker_position (w->start))
    Fset_marker (w->start, make_number (pos), Qnil);

  /* Redisplay the lines where the text was changed */
  last_text_vpos = vpos;
  tab_offset = pos_tab_offset (w, pos);
  if (val.hpos + hscroll - (hscroll > 0) < 0)
    tab_offset += (XFASTINT (w->width) - 1
		   - (XFASTINT (w->width) + XFASTINT (w->left)
		      != screen_width));
  while (vpos < stop_vpos)
    {
      val = *display_text_line (w, pos, top + vpos++, val.hpos, tab_offset);
      tab_offset = val.tab_offset; /* 92.4.1 by Y.Niibe */
      if (val.vpos) tab_offset = 0;
      if (pos != val.bufpos)
	last_text_vpos
	  /* Next line, unless prev line ended in end of buffer with no cr */
	    = vpos - (val.vpos && FETCH_CHAR (val.bufpos - 1) != '\n');
      pos = val.bufpos;
    }

  /* There are two cases:
     1) we have displayed down to the bottom of the window
     2) we have scrolled lines below stop_vpos by scroll_amount  */

  if (vpos == height)
    {
      /* If last line is continued in middle of character,
	 include the split character in the text considered on the screen */
      if (val.hpos < lmargin)
	val.bufpos++;
      XFASTINT (w->window_end_vpos) = last_text_vpos;
      XFASTINT (w->window_end_pos) = Z - val.bufpos;
    }

  /* If scrolling made blank lines at window bottom,
     redisplay to fill those lines */
  if (scroll_amount < 0)
    {
      vpos = xp.vpos;
      pos = xp.bufpos;
      val.hpos = lmargin;
      if (pos == ZV)
	vpos = height + scroll_amount;
      else if (xp.contin && xp.hpos != lmargin)
	{
	  val.hpos = xp.prevhpos - width + lmargin;
	  pos--;
	}

      blank_end_of_window = 1;
      tab_offset = pos_tab_offset (w, pos);
      if (val.hpos < 0)
	tab_offset += (XFASTINT (w->width) - 1
		       - (XFASTINT (w->width) + XFASTINT (w->left)
			  != screen_width));

      while (vpos < height)
	{
	  val = *display_text_line (w, pos, top + vpos++, val.hpos, tab_offset);
	  tab_offset = val.tab_offset; /* 92.4.1 by Y.Niibe */
	  if (val.vpos) tab_offset = 0;
	  pos = val.bufpos;
	}

      /* Here is a case where display_text_line sets point_vpos wrong.
	 Make it be fixed up, below.  */
      if (xp.bufpos == ZV
	  && xp.bufpos == point)
	point_vpos = -1;
    }

  /* Attempt to adjust end-of-text positions to new bottom line */
  if (scroll_amount)
    {
      delta = height - xp.vpos;
      if (delta < 0
	  || (delta > 0 && xp.bufpos < ZV)
	  || (delta == 0 && xp.hpos))
	{
	  val = *vmotion (Z - XFASTINT (w->window_end_pos),
			  delta, width, hscroll, window);
	  XFASTINT (w->window_end_pos) = Z - val.bufpos;
	  XFASTINT (w->window_end_vpos) += val.vpos;
	}
    }

  w->window_end_valid = Qnil;

  /* If point was not in a line that was displayed, find it */
  if (point_vpos < 0)
    {
      val = *compute_motion (start, 0, lmargin, point, 10000, 10000,
			     /* 92.8.2 Y.Niibe */
			     width, hscroll, pos_tab_offset (w, start), 0);
      /* Admit failure if point is off screen now */
      if (val.vpos >= height)
	{
	  for (vpos = 0; vpos < height; vpos++)
	    cancel_line (vpos + top);
	  return 0;
	}
/* 93.5.22 Y.Niibe */
      cursor_vpos = point_vpos = val.vpos + top;
      cursor_hpos = max(val.hpos,0) + XFASTINT (w->left);
      r2l_double_cursor_set (&pp,w,point); /* 93.5.22 Y.Niibe */
/* end of patch */
    }

/* delete setting cursor_hpos, cursor_vpos 93.5.22 Y.Niibe */

  if (debug_end_pos)
    {
      val = *compute_motion (start, 0, lmargin, ZV,
			     height, - (1 << (SHORTBITS - 1)),
			     /* 92.8.2 Y.Niibe */
			     width, hscroll, pos_tab_offset (w, start), 0);
      if (val.vpos != XFASTINT (w->window_end_vpos))
	abort ();
      if (XFASTINT (w->window_end_pos) != Z - val.bufpos)
	abort ();
    }

  return 1;
}

/* patch for attribute by K.Handa  89.11.24, 92.1.30 */
Lisp_Object
current_attribute(pos)
     int pos;
{
  register unsigned int i, attr = 0;
  Lisp_Object p1, p2;

  if (NULL (p1 = current_buffer->attributed_region))
    return Qnil;
  do {
    p2 = p1;
    p1 = XCONS (p1)->cdr;
  } while (!NULL (p1)
	   && marker_position (XCONS (XCONS (p1)->car)->car) <= pos);
  return p2;
}

/* Display one line of window w, starting at position `start' in w's buffer.
 Display starting at horizontal position `hpos',
  which is normally zero or negative.
  A negative value causes output up to hpos = 0 to be discarded.
  This is done for negative hscroll, or when this is a continuation line
  and the continuation occurred in the middle of a multi-column character.

 `taboffset' is an offset for ostensible hpos, used in tab stop calculations.

 Display on position `vpos' on the screen.  (origin 0).

 Returns a `struct position' giving character to start next line with
 and where to display it, including a zero or negative hpos.
 The vpos field is not really a vpos; it is 1 unless the line is continued */

struct position val_display_text_line;

struct position *
display_text_line (w, start, vpos, hpos, taboffset)
     struct window *w;
     Lisp_Object_Int start;
     Lisp_Object_Int vpos;
     Lisp_Object_Int hpos;
     int taboffset;
{
  register int pos = start;
  register unsigned int c;
  register unsigned int *p1;	/* 91.10.19 by K.Handa */
  int end;
  register int pause;
  register unsigned char *p;
  unsigned int *endp;		/* 91.11.1 by K.Handa */
  register unsigned int *startp; /* 91.11.1 by K.Handa */
  register unsigned int *p1prev = 0; /* 91.10.19 by K.Handa */
  int tab_width = XINT (current_buffer->tab_width);
  int ctl_arrow = !NULL (current_buffer->ctl_arrow);
  int ctl_hexa = !NULL (current_buffer->ctl_hexa); /* 92.4.9 by K.Handa */
  char *hexa = "0123456789ABCDEF"; /* 92.4.9 by K.Handa */
  int width = XFASTINT (w->width) - 1
    - (XFASTINT (w->width) + XFASTINT (w->left) != screen_width);
  struct position val;
  int lastpos;
  int invis;
  int hscroll = XINT (w->hscroll);
  int truncate = hscroll
    || (truncate_partial_width_windows
	&& XFASTINT (w->width) < screen_width)
    || !NULL (current_buffer->truncate_lines);
  int selective
    = XTYPE (current_buffer->selective_display) == Lisp_Int
      ? XINT (current_buffer->selective_display)
	: !NULL (current_buffer->selective_display) ? -1 : 0;
  int selective_e = selective && !NULL (current_buffer->selective_display_ellipses);
  int mc_flag = !NULL(current_buffer->mc_flag); /* 91.10.19 by K.Handa */
/* patch for attribute of characters by K.Handa  89.11.21, 91.10.19, 92.3.21 */
  unsigned int attribute_bits = 0;
  Lisp_Object apositions;
  int prev_pos, apos;
/* 92.9.7, 92.11.10 by K.Handa, 93.5.22 Y.Niibe */
  unsigned char mc_chars[CMP_CHAR_SIZE];
  register int mc_bytes;
  int display_direction = NULL(XBUFFER(w->buffer)->display_direction)?
    LEFT_TO_RIGHT: RIGHT_TO_LEFT;
/* end of patch */

  hpos += XFASTINT (w->left);
  get_display_line (vpos, XFASTINT (w->left));
  if (tab_width <= 0 || tab_width > 20) tab_width = 8;

  if (w == XWINDOW (minibuf_window) && start == 1
      && vpos == XFASTINT (w->top))
    {
      if (minibuf_prompt) {	/* 92.2.17 by K.Handa */
	if (XTYPE (Vminibuf_preprompt) == Lisp_String)
	  hpos = display_string (w, vpos, XSTRING (Vminibuf_preprompt)->data,
				 hpos, !truncate ? '\\' : '$', -1, -1);
	else if (XTYPE (Vminibuf_preprompt) == Lisp_Cons) {
	  Lisp_Object temp = Vminibuf_preprompt;
	  while (!NULL (temp)) {
	    if (XTYPE (Fcar (temp)) == Lisp_String)
	      hpos = display_string (w, vpos, XSTRING (Fcar (temp))->data,
				     hpos, !truncate ? '\\' : '$', -1, -1);
	    temp = Fcdr (temp);
	  }
	}
	hpos = display_string (w, vpos, minibuf_prompt, hpos,
			       !truncate ? '\\' : '$', -1, -1);
      }
      minibuf_prompt_width = hpos;
    }

  p1 = new_screen->contents[vpos] + hpos;

  end = ZV;

  startp = new_screen->contents[vpos] + XFASTINT (w->left);
  endp = startp + width;

/* patch for attribute by K.Handa 89.11.24, 91.10.19 */
  if (NULL (apositions = current_attribute(start))) {
    attribute_bits = 0;
    apos = end;
  } else {
    attribute_bits = XFASTINT (XCONS (XCONS (apositions)->car)->cdr);
    attribute_bits <<= 26;	/* See dispextern.h, 92.11.10 */
    apositions = XCONS (apositions)->cdr;
    if (NULL (apositions))
      apos = end;
    else
      apos = marker_position (XCONS (XCONS (apositions)->car)->car);
  }
/* end of patch */

  /* Loop generating characters.
   Stop at end of buffer, before newline,
   or if reach or pass continuation column.  */

  prev_pos = pos - 1;		/* 92.3.28 by K.Handa */
  pause = pos;
  while (p1 < endp)
    {
      p1prev = p1;
      if (pos == pause)
	{
	  if (pos == end)
	    break;
	  if (pos == point && point_vpos < 0)
	    {
	      point_vpos = vpos;
	      point_hpos = p1 - startp + XFASTINT (w->left); /* 93.5.22 Y.Niibe */
	    }

	  pause = end;
	  if (pos < point && point < pause)
	    pause = point;
	  if (pos < GPT && GPT < pause)
	    pause = GPT;

	  p = &FETCH_CHAR (pos);
	}
/* patch for attribute of characters by K.Handa 89.11.21 */
      while (pos >= apos) {
	attribute_bits = XFASTINT (XCONS (XCONS (apositions)->car)->cdr);
	attribute_bits <<= 26;	/* See dispextern.h, 92.11.10 */
	apositions = XCONS (apositions)->cdr;
	if (NULL (apositions))
	  apos = end;
	else
	  apos = marker_position (XCONS (XCONS (apositions)->car)->car);
      }
/* end of patch */
      c = *p++;
      if (c >= 040 && c < 0177)
	{
	  c |= attribute_bits /* 91.10.19 by K.Handa */
	    |  ((display_direction == RIGHT_TO_LEFT)?MTRX_REV_DIR:0);

	  if (p1 >= startp)
	    *p1 = c;
	  p1++;
	}
      else if (c == '\n')
	{
	  invis = 0;
	  while (pos < end
		 && selective > 0
		 && position_indentation (pos + 1) >= selective)
	    {
	      invis = 1;
	      pos = find_next_newline (pos + 1, 1);
	      if (FETCH_CHAR (pos - 1) == '\n')
		pos--;
	    }
	  if (invis && selective_e)
	    {
	      p1 += 4;
	      if (p1 - startp > width)
		p1 = endp;
	      if (p1prev >= startp) { /* 91.10.21 by K.Handa */
		unsigned int *ptemp = p1prev;
		*ptemp++ = ' '| attribute_bits;
		while (ptemp < p1) *ptemp++ = '.'| attribute_bits;
/*		strncpy (p1prev, " ...", p1 - p1prev);*/
	      }
	    }
	  break;
	}
      else if (c == '\t')
	{
	  c = ' ' | attribute_bits; /* 91.10.21 by K.Handa */

	  do
	    {
	      if (p1 >= startp && p1 < endp)
		*p1 = c; /* 91.10.21 by K.Handa, 93.5.22 Y.Niibe*/
	      p1++;
	    }
	  while ((p1 - startp + taboffset + hscroll - (hscroll > 0))
		 % tab_width);
	}
      else if (c == Ctl ('M') && selective == -1)
	{
	  pos = find_next_newline (pos, 1);
	  if (FETCH_CHAR (pos - 1) == '\n')
	    pos--;
	  if (selective_e)
	    {
	      p1 += 4;
	      if (p1 - startp > width)
		p1 = endp;
	      if (p1prev >= startp) { /* 91.10.21 by K.Handa */
		unsigned int *ptemp = p1prev;
		*ptemp++ = ' ' | attribute_bits;
		while (ptemp < p1) *ptemp++ = '.' | attribute_bits;
/*		strncpy (p1prev, " ...", p1 - p1prev);*/
	      }
	    }
	  break;
	}
      else if (c < 0200 && ctl_arrow)
	{
	  unsigned int a_bits = attribute_bits
	    |  ((display_direction == RIGHT_TO_LEFT)?MTRX_REV_DIR:0);

	  if (p1 >= startp)
	    *p1 = '^' | a_bits; /* 91.10.21 by K.Handa */
	  p1++;
	  if (p1 >= startp && p1 < endp)
	    *p1 = (c ^ 0100) | a_bits; /* 91.10.21 by K.Handa */
	  p1++;
	}
/* 87.4.30, 88.1.8, 88.5.30, 89.3.9, 90.3.3, 91.10.21, 92.3.21 by K.Handa */
      else if (mc_flag)
	{
	  int i = 0;
	  int prev_c = c;
	  int c_width, dir;

	  prev_pos = pos;
	  if (c == LCCMP)
	    {
	      pos++; mc_chars[i++] = c;
	      if (pos < end && NONASCII_P (c = FETCH_CHAR (pos)))
		{
		  pos++; mc_chars[i++] = c;
		  mc_bytes = char_bytes[c - 0x20];
		  c_width = char_width[c - 0x20];
		  dir = char_direction[c - 0x20];

		  if (pos + mc_bytes - 1 <= end)
		    while (--mc_bytes && NONASCII_P (c = FETCH_CHAR (pos)))
		      mc_chars[i++] = c, pos++;
		  if (mc_bytes)
		    {
		      pos = prev_pos;
		      c = prev_c;
		      goto nongraphic;
		    }

		  if (dir == DIRECTION_UNDEFINED)
		    /* fetch extended leading char */
		    dir = char_direction[FETCH_CHAR (prev_pos+2)];

		  while (pos < end && NONASCII_P (c = FETCH_CHAR (pos)))
		    {
		      int prev_pos_1 = pos++;
		      int prev_i = i;

		      mc_chars[i++] = c;
		      mc_bytes = char_bytes[c - 0x20];
		      if (pos + mc_bytes - 1 <= end)
			while (--mc_bytes && NONASCII_P (c = FETCH_CHAR (pos)))
			  mc_chars[i++] = c, pos++;
		      if (mc_bytes)
			{
			  i = prev_i;
			  pos = prev_pos_1;
			  break;
			}
		    }

		  mc_chars[0] = MTRX_ATTR(attribute_bits) | 0x80;
		  if (p1 >= startp)
		    {
		      c = store_composite_char(new_screen, vpos,
					       p1 - new_screen->contents[vpos],
					       mc_chars, i)
			  | MTRX_CMPCHAR_MASK;
		      if (dir != display_direction)
			c |= MTRX_REV_DIR;
		      /* end of patch */
		      *p1++ = c | MTRX_FIRST;
		      while (c_width-- > 1)
			if (p1 < endp)
			  *p1++ = c | MTRX_REST;
			else
			  p1++;
		    }
		  else
		    {
		      c = ' ' | attribute_bits
			| ((display_direction != dir)?MTRX_REV_DIR:0);
		      p1++;
		      while (c_width-- > 1)
			if (p1 >= startp)
			  *p1++ = c;
			else
			  p1++;
		    }

		  if ((prev_pos < point) && (point < pos)
		      && point_vpos < 0)
		    {
		      point_vpos = vpos;
		      point_hpos = p1prev - startp + XFASTINT (w->left);
		    }
		  pause = pos;
		  continue;
		}
	      else
		{
		  pos = prev_pos;
		  goto nongraphic;
		}
	    }
	  else if (LC_P(c))
	    {
	      c_width = char_width[c];
	      dir = char_direction[c];
	      mc_chars[i++] = c;
	      pos++;
	      mc_bytes = char_bytes[c];
	      if (pos + mc_bytes -1 <= end)
		while (--mc_bytes && NONASCII_P (c = FETCH_CHAR (pos)))
		  mc_chars[i++] = c, pos++;
	      if (mc_bytes)
		{
		  pos = prev_pos;
		  c = prev_c;
		  goto nongraphic;
		}
	      else
		{
		  if (dir == DIRECTION_UNDEFINED)
		    /* fetch extended leading char */
		    dir = char_direction[FETCH_CHAR (prev_pos+1)];

		  if (p1 >= startp)
		    {
		      unsigned int a_bits = attribute_bits
			| ((display_direction != dir)?MTRX_REV_DIR:0);

		      MTRX_COMPOSE (c, mc_chars, a_bits);
		      *p1++ = c | MTRX_FIRST;
		      while (c_width-- > 1)
			if (p1 < endp)
			  *p1++ = c | MTRX_REST;
			else
			  p1++;
		    }
		  else
		    {
		      c = ' ' | attribute_bits
			| ((display_direction != dir)?MTRX_REV_DIR:0);
		      p1++;
		      while (c_width-- > 1)
			if (p1 > startp)
			  *p1++ = c;
			else
			  p1++;
		    }
		  if (pos > pause) /* GAP or point is in this mc char. */
		    pause = end;
		  p = &FETCH_CHAR (pos);
		  continue;
		}
	    }
	  else
	    goto nongraphic;
	}
/* end of patch */
      else
	{
	  unsigned int a_bits;

	nongraphic:		/* 92.3.21 by K.Handa */
	  a_bits = attribute_bits
	    |  ((display_direction == RIGHT_TO_LEFT)?MTRX_REV_DIR:0);
	  if (p1 >= startp)
	    *p1 = '\\' | a_bits; /* 91.10.21 by K.Handa */
	  p1++;
	  if (p1 >= startp && p1 < endp)
	    *p1 =		/* 91.10.21, 92.4.9 by K.Handa */
	      (ctl_hexa ? 'x' : (c >> 6) + '0') | a_bits;
	  p1++;
	  if (p1 >= startp && p1 < endp)
	    *p1 =		/* 91.10.21, 92.4.9 by K.Handa */
	      hexa[ctl_hexa ? 0xF & (c >> 4) : 7 & (c >> 3)] | a_bits;
	  p1++;
	  if (p1 >= startp && p1 < endp)
	    *p1 =		/* 91.10.21, 92.4.9 by K.Handa */
	      hexa[ctl_hexa ? 0xF & c : 7 & c] | a_bits;
	  p1++;
	}
      prev_pos = pos++;		/* 92.3.21 by K.Handa */
    }

  val.hpos = - XINT (w->hscroll);
  if (val.hpos)
    val.hpos++;

  val.vpos = 1;
  val.tab_offset = taboffset + width; /* 92.4.1 by Y.Niibe */

  lastpos = pos;

  /* Handle continuation in middle of a character */
  /* by backing up over it */
  if (p1 > endp)
    {
      /* Start the next line with that same character */
      /* but at a negative hpos, to skip the columns output on this line.  */
/* 88.1.10, 88.5.30, 89.3.10, 91.10.21, 92.3.21  by K.Handa */
      c = FETCH_CHAR (prev_pos); /* 92.11.12 by K.Handa */
      if (mc_flag
	  && LC_P (c)
	  && prev_pos + 1 < pos)
	{ /* Multi-byte char can't be broken. */
	  val.tab_offset += p1prev - endp;
	  while (p1prev < endp) { /* 92.4.1 by Y.Niibe */
	    if (truncate)
	      *p1prev++ = '$' | attribute_bits;
	    else
	      *p1prev++ = '\\' | attribute_bits;
	  }
	  lastpos = pos = prev_pos;
	  if (point == pos)
	    point_vpos = -1; /* point must not be on this line */
	}
      else
	{
	  if (p1prev)
	    {	
	      pos = prev_pos;		/* 92.3.21 by K.Handa */
	      val.hpos += p1prev - endp;
	    }
	}
       /* Keep in this line everything up to the continuation column.  */
       p1 = endp;
/* end of patch */
    }

  /* Finish deciding which character to start the next line on,
     and what hpos to start it at.
     Also set `lastpos' to the last position which counts as "on this line"
     for cursor-positioning.  */

  if (pos < ZV)
    {
      if (FETCH_CHAR (pos) == '\n')
	/* If stopped due to a newline, start next line after it */
	pos++;
      else
	/* Stopped due to right margin of window */
	{
	  if (truncate)
	    {
	      *p1++ = '$';
	      /* Truncating => start next line after next newline,
		 and point is on this line if it is before the newline,
		 and skip none of first char of next line */
	      pos = find_next_newline (pos, 1);
	      val.hpos = XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0;

	      lastpos = pos - (FETCH_CHAR (pos - 1) == '\n');
	    }
	  else
	    {
	      *p1++ = '\\';
	      val.vpos = 0;
	      /* 92.4.1 by Y.Niibe
		 The following code is wrong if there's multibyte char,
		 but harmless. */
	      lastpos--;
	    }
	}
    }

  /* If point is at eol or in invisible text at eol,
     record its screen location now.  */

  if (start <= point && point <= lastpos && point_vpos < 0)
    {
      point_vpos = vpos;
      point_hpos = p1 - startp + XFASTINT (w->left); /* 93.5.22 Y.Niibe */
    }

  if (point_vpos == vpos)
    {
/* delete setting point_hpos 93.5.22 Y.Niibe */
      if (w == XWINDOW (selected_window))
	{
	  cursor_vpos = point_vpos;
	  cursor_hpos = point_hpos;
/* 93.5.22 Y.Niibe */
	  if (cursor_hpos < XFASTINT (w->left))
	    cursor_hpos = XFASTINT (w->left);
	  if (cursor_hpos > XFASTINT (w->left) + width)
	    cursor_hpos = XFASTINT (w->left) + width;
	  cursor_form = CURSOR_LEFT;
/* end of patch */

	  /* Line is not continued and did not start in middle of character */
	  if (hpos == (XINT (w->hscroll) ? 1 - XINT (w->hscroll) : 0)
	      && val.vpos)
	    {
	      this_line_bufpos = start;
	      this_line_buffer = current_buffer;
	      this_line_vpos = point_vpos;
	      this_line_start_hpos = hpos;
	      this_line_endpos = Z - lastpos;
	    }
	  else
	    this_line_bufpos = 0;
	}
    }

  /* If hscroll and line not empty, insert truncation-at-left marker */
  if (hscroll && lastpos != start)
    {
      *startp = '$';
      if (p1 <= startp)
	p1 = startp + 1;
/* 92.3.21 by K.Handa */
      else {
	p1prev = startp + 1;
	while (p1prev < p1 && *p1prev & MTRX_REST)
	  {
	    *p1prev = (*p1prev & MTRX_ATTR_MASK) | '$';
	    p1prev++;
	  }
      }
/* end of patch */
    }

  if (XFASTINT (w->width) + XFASTINT (w->left) != screen_width)
    {
      endp++;
      if (p1 < startp) p1 = startp;
      while (p1 < endp)
	*p1++ = ' ';
      *p1++ = '|';
    }
  new_screen->used[vpos] = max (new_screen->used[vpos],
				p1 - new_screen->contents[vpos]);
  new_screen->contents[vpos][new_screen->used[vpos]] = 0;

  /* If the start of this line is the overlay arrow-position,
     then put the arrow string into the display-line.  */

  if (XTYPE (Voverlay_arrow_position) == Lisp_Marker
      && current_buffer == XMARKER (Voverlay_arrow_position)->buffer
      && start == marker_position (Voverlay_arrow_position)
      && XTYPE (Voverlay_arrow_string) == Lisp_String)
    {
      unsigned int *p2, *endp2; /* 93.5.22 Y.Niibe */
      unsigned char *p = XSTRING (Voverlay_arrow_string)->data;
      int len = XSTRING (Voverlay_arrow_string)->size;
      int minlen = (XFASTINT (w->width) - 1
		    - (XFASTINT (w->width) + XFASTINT (w->left)
		       != screen_width));

      if (len > minlen)
	len = minlen;
/* 92.3.21 by K.Handa, 93.5.22 Y.Niibe don't use p1 and endp, it's using */
      p2 = startp; endp2 = startp + len;
      while (p2 < endp2) *p2++ = *p++;
/* end of patch */
/* 92.7.2 by M.Murakami */
      if (new_screen->used[vpos] < endp2 - new_screen->contents[vpos])
	new_screen->used[vpos] = endp2 - new_screen->contents[vpos];
    }

/* 92.8.2, 93.5.22 Y.Niibe */
  if (display_direction == LEFT_TO_RIGHT)
    {
      unsigned int *rev_text = /* get enough space */
	(unsigned int *) alloca ((screen_width +1)
				 * sizeof (unsigned int));

      p1 = startp;
      endp = startp + width;
      while (p1 < endp)
        {
          if (*p1 & MTRX_REV_DIR)
            {
	      int i,j,k;
	      int rt_width, c_width;
	      unsigned int *rt;

              i = 0;
              rt = p1;
              while (p1 < endp)
                {
                  if (*p1 & MTRX_REV_DIR)
		    rev_text[i++] = *p1++;
                  else
                    break;
                }
	      rev_text[i] = 0; /* the sentinel */

              j = 0; rt_width = k = i;
              while (k > 0)
                {
                  c_width =1;
		  while (MTRX_ORDER (rev_text[j+c_width])) c_width++;

                  for (i=0; i < c_width; i++)
                    rt[k-c_width+i] = rev_text[j++];
                  k -= c_width;
                }

	      if (point_vpos == vpos
		  && w == XWINDOW (selected_window))
		{
		  if (rt - startp == point_hpos)
		    {
		      cursor_vpos = point_vpos;
		      cursor_hpos = rt_width + point_hpos - 1;
		      while (MTRX_ORDER (*(cursor_hpos+startp)))
			cursor_hpos--;
		      cursor_hpos_rev = point_hpos -1;
		      if (cursor_hpos_rev >= XFASTINT (w->left))
			{
			  while (MTRX_ORDER (*(cursor_hpos_rev+startp)))
			    cursor_hpos_rev--;
			  cursor_form = CURSOR_RIGHT | CURSOR_DOUBLE;
			}
		      else
			cursor_form = CURSOR_RIGHT;
		    }
		  else if (rt - startp < point_hpos
			   && point_hpos < rt - startp + rt_width)
		    {
		      cursor_vpos = point_vpos;
		      cursor_hpos = rt_width - point_hpos + (rt-startp)*2 -1;
		      while (MTRX_ORDER (*(cursor_hpos+startp)))
			cursor_hpos--;
		      cursor_form = CURSOR_RIGHT;
		    }
		  else if (point_hpos == rt - startp + rt_width)
		    {
		      cursor_vpos = point_vpos;
		      cursor_hpos = point_hpos;
		      cursor_hpos_rev = point_hpos - rt_width;
		      cursor_form = CURSOR_LEFT | CURSOR_DOUBLE;
		    }
		}
            }
          else
            p1++;
        }
    }
  else  /* RIGHT_TO_LEFT */
    {
      unsigned int *rev_text = /* get enough space */
        (unsigned int *) alloca ((screen_width +1) * sizeof (unsigned int));
      unsigned int *p2, *rt;
      int cursor_is_not_set = 1;

      p2 = startp;
      rt = rev_text;
      while (p2 < p1)
        *rt++ = *p2++;
      while (p2 <= endp)
        {
          *rt++ = ' ';
          p2++;
        }
      *rt = 0; /* the sentinel */
      new_screen->used[vpos] =
        max(new_screen->used[vpos], p2 - new_screen->contents[vpos]);
      new_screen->contents[vpos][new_screen->used[vpos]] = 0;
      rt = rev_text;
      endp = rt + width + 1;
      p1 = startp + width + 1;
      while (rt < endp)
        {
          int j, this_chunk_is_r2l;
          int rt_width;
	  unsigned int *rt1;

          if (*rt & MTRX_REV_DIR)
            {
              rt1 = rt;
              while (rt1 < endp)
		if (*rt1 & MTRX_REV_DIR) rt1++;
		else break;
              rt_width = rt1 - rt;
	      this_chunk_is_r2l = 0;
            }
	  else
	    {
	      rt_width = 1; this_chunk_is_r2l = 1;
	      while (MTRX_ORDER (rt[rt_width])) rt_width++;
	    }

          p1 -= rt_width;
          p2 = p1;
	  rt1 = rt;
          for (j=0; j < rt_width; j++)
            *p2++ = *rt1++;

          if (point_vpos == vpos
	      && w == XWINDOW (selected_window)
              && cursor_is_not_set)
	    {
	      if (rt - rev_text == point_hpos)
		{
		  if (cursor_is_not_set < 0)
		    cursor_hpos = p1 - startp;
		  else
		    {
		      cursor_hpos = p1 - startp;
		      cursor_hpos_rev = cursor_hpos + rt_width;
		      cursor_form = (this_chunk_is_r2l)?CURSOR_RIGHT
			:(CURSOR_LEFT | CURSOR_DOUBLE);
		    }
		  cursor_vpos = point_vpos;
		  cursor_is_not_set = 0;
		}
              else if (rt - rev_text < point_hpos
		       && point_hpos < rt - rev_text + rt_width)
		{
		  cursor_vpos = point_vpos;
		  cursor_hpos = point_hpos - (rt-rev_text) + p1 - startp;
		  cursor_form = (this_chunk_is_r2l)?CURSOR_RIGHT:CURSOR_LEFT;
		  cursor_is_not_set = 0;
		}
	      else if (point_hpos == rt - rev_text + rt_width)
		{
		  if (!this_chunk_is_r2l)
		    {
		      cursor_is_not_set = -1;
		      cursor_hpos_rev = rt_width + p1 - startp -1;
		      if (cursor_hpos_rev < XFASTINT (w->left) + width + 1)
			{
			  while (MTRX_ORDER (*(cursor_hpos_rev+startp)))
			    cursor_hpos_rev--;
			  cursor_form = CURSOR_RIGHT | CURSOR_DOUBLE;
			}
		      else
			cursor_form = CURSOR_RIGHT;
		    }
		}
	    }
	  rt = rt1;
        }
    }
/* end of patch */

  val.bufpos = pos;
  val_display_text_line = val;
  return &val_display_text_line;
}

/* Display the mode line for window w */

display_mode_line (w)
     struct window *w;
{
  register int vpos = XFASTINT (w->height) + XFASTINT (w->top) - 1;
  register int left = XFASTINT (w->left);
  register int right = XFASTINT (w->width) + left;
  get_display_line (vpos, left);

  display_mode_element (w, vpos, left, 0, right, right,
			current_buffer->mode_line_format);

  /* Make the mode line inverse video if the entire line
     is made of mode lines.
     I.e. if this window is full width,
     or if it is the child of a full width window
     (which implies that that window is split side-by-side
     and the rest of this line is mode lines of the sibling windows).  */
  if (XFASTINT (w->width) == screen_width ||
      XFASTINT (XWINDOW (w->parent)->width) == screen_width)
    new_screen->highlight[vpos] = mode_line_inverse_video;

}

/* Contribute ELT to the mode line for window W.
   How it translates into text depends on its data type.

   LINE is the display-line that the mode line is being displayed in.

   HPOS is the position (absolute on screen) where this element's text
   should start.  The output is truncated automatically at the right
   edge of window W.

   DEPTH is the depth in recursion.  It is used to prevent
   infinite recursion here.

   MINENDCOL is the hpos before which the element may not end.
   The element is padded at the right with spaces if nec
   to reach this column.

   MAXENDCOL is the hpos past which this element may not extend.
   If MINENDCOL is > MAXENDCOL, MINENDCOL takes priority.
   (This is necessary to make nested padding and truncation work.)

   Returns the hpos of the end of the text generated by ELT.
   The next element will receive that value as its HPOS arg,
   so as to concatenate the elements.  */

int
display_mode_element (w, vpos, hpos, depth, minendcol, maxendcol, elt)
     struct window *w;
     int vpos;
     register int hpos;
     int depth;
     int minendcol;
     register int maxendcol;
     register Lisp_Object elt;
{
 tail_recurse:
  if (depth > 10)
    goto invalid;

  depth++;

#ifdef SWITCH_ENUM_BUG
  switch ((int) XTYPE (elt))
#else
  switch (XTYPE (elt))
#endif
    {
    case Lisp_String:
      {
	/* A string: output it and check for %-constructs within it.  */
	register unsigned char c;
	register unsigned char *this = XSTRING (elt)->data;

	while (hpos < maxendcol && *this)
	  {
	    unsigned char *last = this;
	    while ((c = *this++) != '\0' && c != '%')
	      ;
	    if (this - 1 != last)
	      {
		register int lim = --this - last + hpos;
		hpos = display_string (w, vpos, last, hpos, 0, hpos,
				       min (lim, maxendcol));
	      }
	    else /* c == '%' */
	      {
		register int spec_width = 0;

		/* We can't allow -ve args due to the "%-" construct */
		/* Argument specifies minwidth but not maxwidth
		   (maxwidth can be specified by
		     (<negative-number> . <stuff>) mode-line elements) */

		while ((c = *this++) >= '0' && c <= '9')
		  {
		    spec_width = spec_width * 10 + (c - '0');
		  }

		spec_width += hpos;
		if (spec_width > maxendcol)
		  spec_width = maxendcol;

		if (c == 'M')
		  hpos = display_mode_element (w, vpos, hpos, depth,
					       spec_width, maxendcol,
					       Vglobal_mode_string);
		else if (c != 0)
		  hpos = display_string (w, vpos,
					 decode_mode_spec (w, c,
							   spec_width - hpos),
					 hpos, 0, spec_width, maxendcol);
	      }
	  }
      }
      break;

    case Lisp_Symbol:
      /* A symbol: process the value of the symbol recursively
	 as if it appeared here directly.  Avoid error if symbol void.
	 Special case: if value of symbol is a string, output the string
	 literally.  */
      {
	register Lisp_Object tem;
	tem = Fboundp (elt);
	if (!NULL (tem))
	  {
	    tem = Fsymbol_value (elt);
	    /* If value is a string, output that string literally:
	       don't check for % within it.  */
	    if (XTYPE (tem) == Lisp_String)
	      hpos = display_string (w, vpos, XSTRING (tem)->data,
				     hpos, 0, minendcol, maxendcol);
	    /* Give up right away for nil or t.  */
	    else if (!EQ (tem, elt))
	      { elt = tem; goto tail_recurse; }
	  }
      }
      break;

    case Lisp_Cons:
      {
	register Lisp_Object car, tem;

	/* A cons cell: three distinct cases.
	   If first element is a string or a cons, process all the elements
	   and effectively concatenate them.
	   If first element is a negative number, truncate displaying cdr to
	   at most that many characters.  If positive, pad (with spaces)
	   to at least that many characters.
	   If first element is a symbol, process the cadr or caddr recursively
	   according to whether the symbol's value is non-nil or nil.  */
	car = XCONS (elt)->car;
	if (XTYPE (car) == Lisp_Symbol)
	  {
	    tem = Fboundp (car);
	    elt = XCONS (elt)->cdr;
	    if (XTYPE (elt) != Lisp_Cons)
	      goto invalid;
	    /* elt is now the cdr, and we know it is a cons cell.
	       Use its car if CAR has a non-nil value.  */
	    if (!NULL (tem))
	      {
		tem = Fsymbol_value (car);
		if (!NULL (tem))
		  { elt = XCONS (elt)->car; goto tail_recurse; }
	      }
	    /* Symbol's value is nil (or symbol is unbound)
	       Get the cddr of the original list
	       and if possible find the caddr and use that.  */
	    elt = XCONS (elt)->cdr;
	    if (NULL (elt))
	      break;
	    else if (XTYPE (elt) != Lisp_Cons)
	      goto invalid;
	    elt = XCONS (elt)->car;
	    goto tail_recurse;
	  }
	else if (XTYPE (car) == Lisp_Int)
	  {
	    register int lim = XINT (car);
	    elt = XCONS (elt)->cdr;
	    if (lim < 0)
	      /* Negative int means reduce maximum width.
		 DO NOT change MINENDCOL here!
		 (20 -10 . foo) should truncate foo to 10 col
		 and then pad to 20.  */
	      maxendcol = min (maxendcol, hpos - lim);
	    else if (lim > 0)
	      {
		/* Padding specified.  Don't let it be more than
		   current maximum.  */
		lim += hpos;
		if (lim > maxendcol)
		  lim = maxendcol;
		/* If that's more padding than already wanted, queue it.
		   But don't reduce padding already specified even if
		   that is beyond the current truncation point.  */
		if (lim > minendcol)
		  minendcol = lim;
	      }
	    goto tail_recurse;
	  }
	else if (XTYPE (car) == Lisp_String || XTYPE (car) == Lisp_Cons)
	  {
	    register int limit = 50;
	    /* LIMIT is to protect against circular lists.  */
	    while (XTYPE (elt) == Lisp_Cons && --limit > 0
		   && hpos < maxendcol)
	      {
		hpos = display_mode_element (w, vpos, hpos, depth,
					     hpos, maxendcol,
					     XCONS (elt)->car);
		elt = XCONS (elt)->cdr;
	      }
	  }
      }
      break;

    default:
    invalid:
      return (display_string (w, vpos, "*invalid*", hpos, 0,
			      minendcol, maxendcol));
    }

 end:
  if (minendcol > hpos)
    hpos = display_string (w, vpos, "", hpos, 0, minendcol, -1);
  return hpos;
}

/* 92.2.20 by K.Handa */
decode_mode_spec_coding(code, buf, eol)
     Lisp_Object code;
     char *buf;
     int eol;
{
  if (NULL (code)) {
    *buf = '-';
    if (eol) *++buf = '-';
  } else {
    Lisp_Object val = code;

    while (!NULL (val) && XTYPE (val) == Lisp_Symbol)
      val = Fget (val, Qcoding_system);
    *buf = XFASTINT (XVECTOR (val)->contents[1]);
    if (eol) {
      val = Fget (code, Qeol_type);
      *++buf =
	NULL (val) ? '-' :
	  XTYPE (val) == Lisp_Vector ? '_'
	    : XFASTINT (val) == 1 ? '.' : XFASTINT (val) == 2 ? ':' : '\'';
    }
  }
}

/* Return a string for the output of a mode line %-spec
   for window W, generated by character C and width MAXWIDTH.  */

char *
decode_mode_spec (w, c, maxwidth)
     struct window *w;
     register char c;
     register int maxwidth;
{
  Lisp_Object obj = Qnil;
  char *decode_mode_spec_buf = (char *) temp_screen->total_contents;
/* 91.11.6 by K.Handa */
  int i = 0;
/* end of patch */

  switch (c)
    {
    case 'b': 
      obj = current_buffer->name;
#if 0
      if (maxwidth >= 3 && XSTRING (obj)->size > maxwidth)
	{
	  bcopy (XSTRING (obj)->data, decode_mode_spec_buf, maxwidth - 1);
	  decode_mode_spec_buf[maxwidth - 1] = '\\';
	  decode_mode_spec_buf[maxwidth] = '\0';
	  return decode_mode_spec_buf;
	}
#endif
      break;

/* 89.11.19 patch by enami@ptgd.sony.co.jp, 91.10.21, 94.2.9 by K.Handa */
    case 'c':
    case 'C':
      decode_mode_spec_coding(current_buffer->file_coding_system,
			      decode_mode_spec_buf, 1);
      i = 2;
      if (c == 'C') {
	decode_mode_spec_coding(Vkeyboard_coding_system,
				decode_mode_spec_buf + 2, 0);
	decode_mode_spec_coding(Vdisplay_coding_system,
				decode_mode_spec_buf + 3, 0);
	i = 4;
      }
/* 92.5.18 by M.Higashida */
#ifdef subprocesses
      obj = Fget_buffer_process(Fcurrent_buffer ());
      if (!NULL(obj)) {
	decode_mode_spec_coding(XPROCESS (obj)->incode,
				decode_mode_spec_buf + i, 1);
	decode_mode_spec_coding(XPROCESS (obj)->outcode,
				decode_mode_spec_buf + i + 2, 1);
	i += 4;
      }
#endif
      decode_mode_spec_buf[i] = 0;
/* end of patch by M.Higashida */
      return decode_mode_spec_buf;
/* end of patch */

    case 'f': 
      obj = current_buffer->filename;
#if 0
      if (XTYPE (obj) == Lisp_String && XSTRING (obj)->size > maxwidth)
	{
	  bcopy ("...", decode_mode_spec_buf, 3);
	  bcopy (XSTRING (obj)->data + XSTRING (obj)->size - maxwidth + 3,
		 decode_mode_spec_buf + 3, maxwidth - 3);
	  return decode_mode_spec_buf;
	}
#endif
      break;

    case 'm': 
      obj = current_buffer->mode_name;
      break;

    case 'n':
      if (BEGV > BEG || ZV < Z)
	return " Narrow";
      break;

    case '*':
      if (!NULL (current_buffer->read_only))
	return "%";
      if (MODIFF > current_buffer->save_modified)
	return "*";
      return "-";

    case 's':
      /* status of process */
#ifdef subprocesses
      obj = Fget_buffer_process (Fcurrent_buffer ());
      if (NULL (obj))
	return "no process";
      obj = Fsymbol_name (Fprocess_status (obj));
      break;
#else
      return "no processes";
#endif /* subprocesses */

    case 'p':
      {
	int pos = marker_position (w->start);
	int total = ZV - BEGV;

	if (XFASTINT (w->window_end_pos) <= Z - ZV)
	  {
	    if (pos <= BEGV)
	      return "All";
	    else
	      return "Bottom";
	  }
	else if (pos <= BEGV)
	  return "Top";
	else
	  {
	    total = ((pos - BEGV) * 100 + total - 1) / total;
	    /* We can't normally display a 3-digit number,
	       so get us a 2-digit number that is close.  */
	    if (total == 100)
	      total = 99;
	    sprintf (decode_mode_spec_buf, "%2d%%", total);
	    return decode_mode_spec_buf;
	  }
      }

    case '[': 
      {
	int i;
	char *p;
	if (command_loop_level > 5)
	  return "[[[... ";
	p = decode_mode_spec_buf;
	for (i = 0; i < command_loop_level; i++)
	  *p++ = '[';
	*p = 0;
	return decode_mode_spec_buf;
      }

    case '%':
      return "%";

    case ']': 
      {
	int i;
	char *p;
	if (command_loop_level > 5)
	  return " ...]]]";
	p = decode_mode_spec_buf;
	for (i = 0; i < command_loop_level; i++)
	  *p++ = ']';
	*p = 0;
	return decode_mode_spec_buf;
      }

    case '-':
      {
	int i;
	if (maxwidth < 140)
	  return "--------------------------------------------------------------------------------------------------------------------------------------------";
	for (i = 0; i < maxwidth; i++)
	  decode_mode_spec_buf[i] = '-';
	return decode_mode_spec_buf;
      }
    }

  if (XTYPE (obj) == Lisp_String)
    return (char *) XSTRING (obj)->data;
  else
    return "";
}

/* Display STRING on one line of window W, starting at HPOS.
   Display at position VPOS.  Caller should do get_display_line first.

  TRUNCATE is character to display at end if truncated.  Zero for none.

  MINCOL is the first column ok to end at.  (Pad with spaces to this col.)
  MAXCOL is the last column ok to end at.  Truncate here.
    -1 for MINCOL or MAXCOL means no explicit minimum or maximum.
  Both count from the left edge of the screen, as does HPOS.
  The right edge of W is an implicit maximum.
  If TRUNCATE is nonzero, the implicit maximum is one column before the edge.

  Returns ending hpos */

Lisp_Object_Int
display_string (w, vpos, string, hpos, truncate, mincol, maxcol)
     struct window *w;
     int vpos;
     unsigned char *string;
     int hpos;
     char truncate;
     Lisp_Object_Int mincol, maxcol;
{
  register unsigned int c;	/* 92.3.21 by K.Handa */
  register unsigned int *p1;	/* 91.10.21 by K.Handa */
  int hscroll = XINT (w->hscroll);
  /* 92.4.30 by Y.Niibe */
  int tab_width = XINT (XBUFFER (w->buffer)->tab_width);
  register unsigned int *start;	/* 91.10.21 by K.Handa */
  register unsigned int *end;	/* 91.10.21 by K.Handa */
  unsigned int *p1start = new_screen->contents[vpos] + hpos;
				/* 91.10.21 by K.Handa */
  int window_width = XFASTINT (w->width);
  /* 91.10.21 by K.Handa, 92.4.30 by Y.Niibe */
  int mc_flag = !NULL(XBUFFER (w->buffer)->mc_flag);
  /* 92.3.21, 92.9.7 by K.Handa */
  register unsigned char *mc_start;
  register unsigned char *endp = string + strlen(string);
  register int mc_bytes = 0, resumed_bytes;
  char *hexa = "0123456789ABCDEF"; /* 92.4.9 by K.Handa */
  /* 92.4.9 by K.Handa, 92.4.30 by Y.Niibe */
  int ctl_hexa = !NULL (XBUFFER (w->buffer)->ctl_hexa);
  int last_mc;
  unsigned int *prev;

  if (tab_width <= 0 || tab_width > 20) tab_width = 8;

  p1 = p1start;
  start = new_screen->contents[vpos] + XFASTINT (w->left);
  end = start + window_width - (truncate != 0);

  if ((window_width + XFASTINT (w->left)) != screen_width)
    *end-- = '|';

  if (maxcol >= 0 && end - new_screen->contents[vpos] > maxcol)
    end = new_screen->contents[vpos] + maxcol;
  if (maxcol >= 0 && mincol > maxcol)
    mincol = maxcol;

  prev = p1;
  while (p1 < end)
    {
      c = *string++;
      if (!c) break;
      last_mc = 0;
/* 92.3.21 by K.Handa */
      if (mc_bytes) {
	if (NONASCII_P(c)) {
	  if (mc_bytes < 0) { /* 92.11.12 by K.Handa */
	    mc_bytes = char_bytes[c - 0x20] + resumed_bytes;
	  }
	  if (mc_bytes == ++resumed_bytes) {
	    if (*mc_start != LCCMP
		|| !NONASCII_P (*string)) {
	      int w = char_width[*mc_start == LCCMP
				 ? *(mc_start + 1) - 0x20 : *mc_start];

	      if (p1 >= start) {
		if (*mc_start == LCCMP)
		  c = store_composite_char(new_screen, vpos,
					   p1 - new_screen->contents[vpos],
					   mc_start, resumed_bytes)
		      | MTRX_CMPCHAR_MASK;
		else
		  MTRX_COMPOSE(c, mc_start, 0);
		*p1 = c | MTRX_FIRST;
	      }
	      p1++;
	      while (w-- > 1) {
		if (p1 > start && p1 < end)
		  *p1 = c | MTRX_REST;
		else if (p1 == start)
		  *p1 = ' ';
		p1++;
	      }
	      mc_bytes = 0, last_mc = 1;
	    } else
	      mc_bytes = -1;
	  }
	} else {
	  c = *mc_start;
	  mc_bytes = 0;
	  string = mc_start + 1;
	  goto nongraphic_string; /* to display leading char as non-graphic */
	}
      } else {
	prev = p1;
/* end of patch */
      if (c >= 040 && c < 0177)
	{
	  if (p1 >= start)
	    *p1 = c;
	  p1++;
	}
      else if (c == '\t')
	{
	  do
	    {
	      if (p1 >= start && p1 < end)
		*p1 = ' ';
	      p1++;
	    }
	  while ((p1 - start + hscroll - (hscroll > 0)) % tab_width);
	}
/* 87.4.30, 87.7.12, 89.11.18, 91.10.21, 92.3.21, 92.11.12 by K.Handa */
      else if (mc_flag && LC_P(c) && string + char_bytes[c] - 1 <= endp)
	{
	  mc_bytes = c == LCCMP ? -1 : char_bytes[c];
	  mc_start = string - 1;
	  resumed_bytes = 1;
	}
/* end of patch */
      else if (c < 0200 && buffer_defaults.ctl_arrow)
	{
	  if (p1 >= start)
	    *p1 = '^';
	  p1++;
	  if (p1 >= start && p1 < end)
	    *p1 = c ^ 0100;
	  p1++;
	}
      else
	{
	nongraphic_string:	/* 92.3.21 by K.Handa */
	  if (p1 >= start)
	    *p1 = '\\';
	  p1++;
	  if (p1 >= start && p1 < end)
	    *p1 = ctl_hexa ? 'x' : ((c >> 6) + '0'); /* 92.4.9 by K.Handa */
	  p1++;
	  if (p1 >= start && p1 < end)
	    /* 92.4.9 by K.Handa */
	    *p1 = hexa[ctl_hexa ? 0xF & (c >> 4) : 7 & (c >> 3)];
	  p1++;
	  if (p1 >= start && p1 < end)
	    *p1 = hexa[ctl_hexa ? 0xF & c : 7 & c]; /* 92.4.9 by K.Handa */
	  p1++;
	}
      }				/* 92.3.21 by K.Handa */
    }

  if (c)
    {
      /* 91.10.21, 92.3.21 by K.Handa */
      if (last_mc)
	{
	  p1 = prev;
	  while (p1 <= end)
	    *p1++ = truncate ? truncate : ' ';
	}
      else
	{
	  p1 = end;
	  if (truncate) *p1++ = truncate;
	}
    }
  else if (mincol >= 0)
    {
      end = new_screen->contents[vpos] + mincol;
      while (p1 < end)
	*p1++ = ' ';
    }

  {
    register Lisp_Object_Int len = p1 - new_screen->contents[vpos];
    if (len > new_screen->used[vpos])
      new_screen->used[vpos] = len;
    new_screen->contents[vpos][new_screen->used[vpos]] = 0;
    return len;
  }
}

/* 92.1.17, 92.9.30 by K.Handa */
DEFUN ("update-mode-lines", Fupdate_mode_lines, Supdate_mode_lines, 0, 0, 0,
  "Update mode-lines.")
  ()
{
  update_mode_lines++;
  return Qnil;
}
/* end of patch */

syms_of_xdisp ()
{
  staticpro (&last_arrow_position);
  staticpro (&last_arrow_string);
  last_arrow_position = Qnil;
  last_arrow_string = Qnil;

  DEFVAR_LISP ("global-mode-string", &Vglobal_mode_string,
    "String displayed by mode-line-format's \"%m\" specifiation.");
  Vglobal_mode_string = Qnil;

  DEFVAR_LISP ("overlay-arrow-position", &Voverlay_arrow_position,
    "Marker for where to display an arrow on top of the buffer text.\n\
This must be the beginning of a line in order to work.\n\
See also overlay-arrow-string.");
  Voverlay_arrow_position = Qnil;

  DEFVAR_LISP ("overlay-arrow-string", &Voverlay_arrow_string,
    "String to display as an arrow.  See also overlay-arrow-position.");
  Voverlay_arrow_string = Qnil;

  DEFVAR_INT ("scroll-step", &scroll_step,
    "*The number of lines to try scrolling a window by when point moves out.\n\
If that fails to bring point back on screen, point is centered instead.\n\
If this is zero, point is always centered after it moves off screen.");

  DEFVAR_BOOL ("reset-terminal-on-clear", &reset_terminal_on_clear,
    "Non-nil means re-init terminal modes for clear screen as on entry to Emacs.");
  reset_terminal_on_clear = 1;

  DEFVAR_INT ("debug-end-pos", &debug_end_pos, "Don't ask");

  DEFVAR_BOOL ("truncate-partial-width-windows",
	       &truncate_partial_width_windows,
    "*Non-nil means truncate lines in all windows less than full screen wide.");
  truncate_partial_width_windows = 1;

  DEFVAR_BOOL ("mode-line-inverse-video", &mode_line_inverse_video,
    "*Non-nil means use inverse video, or other suitable display mode, for the mode line.");
  mode_line_inverse_video = 1;

  /* 93.4.14 by K.Handa */
  DEFVAR_BOOL ("highlight-reverse-direction", &highlight_reverse_direction,
    "*Non-nil means highlight a character whose direction is different from\n\
that of buffer.\n\
For color X, use gray color, for mono X, use tile pattern,\n\
for terminal, use 'md (bold or extra bright)' of termcap.");
  highlight_reverse_direction = 1;
  /* end of patch */

  defsubr (&Sredraw_display);
  defsubr (&Supdate_mode_lines); /* 92.2.17 by K.Handa */
}

/* initialize the window system */
init_xdisp ()
{
  Lisp_Object root_window;
#ifndef COMPILER_REGISTER_BUG
  register
#endif
    struct window *mini_w;

  this_line_bufpos = 0;

  mini_w = XWINDOW (minibuf_window);
  root_window = mini_w->prev;

  echo_area_contents = 0;
  prev_echo_area_contents = 0;

  if (!noninteractive)
    {
      XFASTINT (XWINDOW (root_window)->top) = 0;
      set_window_height (root_window, screen_height - 1, 0);
      XFASTINT (mini_w->top) = screen_height - 1;
      set_window_height (minibuf_window, 1, 0);

      XFASTINT (XWINDOW (root_window)->width) = screen_width;
      XFASTINT (mini_w->width) = screen_width;
    }
}
