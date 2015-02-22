/* Sun's pixrect handling module for Sun's console display.
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

/* 92.3.29  created for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	This file is created by modifying x11term.c.
	I did not support color display.  Someone please send the patches
	to support color. */
/* 92.5.15  modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
	In SCdelete_chars(), udpateline (0) => SCupdateline (0).*/
/* 92.11.25 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Modified according to new version of etc/bdf.c. */
/* 93.3.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	InitWindow() should be declared as static at first. */

/* On 4.3 this loses if it comes after x11term.h.
   On hp-ux it loses if it comes after config.h.  */
#include <signal.h>
#include <sys/ioctl.h>

/* Load sys/types.h if not already loaded.
   In some systems loading it twice is suicidal.  */
#ifndef makedev
#include <sys/types.h>
#endif

#include "config.h"

#ifdef HAVE_SUN_CONSOLE

/* Get FIONREAD, if it is available.
   It would be logical to include <sys/ioctl.h> here,
   but it was moved up above to avoid problems.  */
#ifdef USG
#include <termio.h>
#include <fcntl.h>
#endif /* USG */

#include "lisp.h"
#undef NULL

/* Allow m- file to inhibit use of interrupt-driven input.  */
#ifdef BROKEN_FIONREAD
#undef FIONREAD
#endif

/* We are unable to use interrupts if FIONREAD is not available,
   so flush SIGIO so we won't try.  */
#ifndef FIONREAD
#ifdef SIGIO
#undef SIGIO
#endif
#endif

#include <pixrect/pixrect_hs.h>
#include <pixrect/pr_io.h>

#ifdef IRIS
#include <sys/sysmacros.h>	/* for "minor" */
#include <sys/time.h>
#else
#ifdef UNIPLUS
#include <sys/time.h>

#else /* not IRIS, not UNIPLUS */
/* Use socket.h just to control whether to use time.h or sys/time.h.
   This works like the code in process.c.  */
#ifdef HAVE_SOCKETS
#include <sys/socket.h>
#endif
#ifdef HAVE_TIMEVAL
/* _h_BSDTYPES is checked because on ISC unix, socket.h includes
   both time.h and sys/time.h, and the latter file is protected
   from repeated inclusion.  */
#if defined(USG) && !defined(_h_BSDTYPES)
#include <time.h>
#else /* _h_BSDTYPES or not USG */
#include <sys/time.h>
#endif /* _h_BSDTYPES or not USG */
#endif /* HAVE_TIMEVAL */
#endif /* not UNIPLUS */
#endif /* not IRIS */

#ifdef BAT68K
#include <sys/time.h>   /* In addition to time.h.  */
#endif

#ifdef AIX
#include <sys/time.h>   /* In addition to time.h.  */

static KeySym XMOD_Alt[] = { XK_Alt_L };
static KeySym XMOD_Shift[] = { XK_Shift_L };
static KeySym XMOD_ShiftAlt[] = { XK_Alt_L, XK_Shift_L };
static KeySym XMOD_CtrlAlt[] = { XK_Control_L, XK_Alt_L };
static KeySym XMOD_Ctrl[] = { XK_Control_L };
static KeySym XMOD_CtrlShift[] = { XK_Control_L, XK_Shift_L };
static KeySym XMOD_ShiftCtrlAlt[] = { XK_Control_L, XK_Alt_L, XK_Shift_L };
#endif

#include <fcntl.h>
#include <stdio.h>
#include <ctype.h>
#include <errno.h>
#ifdef BSD
#include <strings.h>
#endif
#include <sys/stat.h>

#include "dispextern.h"
#include "termhooks.h"
#include "termopts.h"
#include "termchar.h"
#include "mule.h"
#include "codeconv.h"
#include "../etc/bdf.h"

#define min(a,b) ((a)<(b) ? (a) : (b))
#define max(a,b) ((a)>(b) ? (a) : (b))

#define MINWIDTH 12	/* In pixels */
#define MINHEIGHT 5	/* In pixels */
#define MAXHEIGHT 300	/* In lines */

int XXfontw, XXfonth, XXbase, XXisColor;

extern int initialized;
extern int screen_width, screen_height;

extern char *alternate_display;
extern int xargc;
extern char **xargv;

static int flexlines;  		/* last line affected by dellines or
				 * inslines functions */
int VisibleX, VisibleY;		/* genuine location of cursor on screen
				 * if it is there */

/* Last cursor position specified by move_cursor.
   During an update, this does not display a cursor on the screen;
   But it controls the position that is output.  */
static int local_cursor_hpos;
static int local_cursor_vpos;

static int SavedX, SavedY;	/* Where the cursor was before update
				 * started */


int CursorExists;		/* during updates cursor is turned off */
static int InUpdate;		/* many of functions here may be invoked
				 * even if no update in progress; when
				 * no update is in progress the action
				 * can be slightly different */

Pixrect *screen;
Pixrect *window;

int CurHL;			/* Current Highlighting (ala mode line) */

int XXborder;			/* Window border width */
int XXInternalBorder;		/* Internal border width */
int updated[MAXHEIGHT];

static int InitWindow ();

char *rindex();

/* Definition of basic pixrect operations */

#define FillRectangle(dx, dy, dw, dh) \
  pr_rop(window, dx, dy, dw, dh, PIX_SET, 0, 0, 0)
#define ClearArea(dx, dy, dw, dh) \
  pr_rop(window, dx, dy, dw, dh, PIX_CLR, 0, 0, 0)
#define InvertArea(dx, dy, dw, dh) \
  pr_rop(window, dx, dy, dw, dh, PIX_NOT(PIX_DST), 0, 0, 0)
#define ClearWindow() \
  ClearArea(0, 0, (window->pr_size).x, (window->pr_size).y)
#define InvertWindow() \
  InvertArea(0, 0, (window->pr_size).x, (window->pr_size).y)
#define CopyArea(sx, sy, sw, sh, dx, dy) \
  pr_rop(window, dx, dy, sw, sh, PIX_SRC, window, sx, sy)

Lisp_Object Vsunterm;

check_sunterm ()
{
  extern Lisp_Object Qnil;
  if (Vsunterm == Qnil)
    error ("Mule does not started on Sun's console.");
}

/* HLmode -- Changes the GX function for output strings.  Could be used to
 * change font.  Check an XText library function call.
 */

SCHLmode (new)
     int new;
{
	extern Lisp_Object inverse_video;
	
	CurHL = new;
}

/* External interface to control of standout mode.
   Call this when about to modify line at position VPOS
   and not change whether it is highlighted.  */

SCreassert_line_highlight (highlight, vpos)
     int highlight, vpos;
{
	SCHLmode (highlight);
}

/* Call this when about to modify line at position VPOS
   and change whether it is highlighted.  */

SCchange_line_highlight (new_highlight, vpos, first_unused_hpos)
     int new_highlight, vpos, first_unused_hpos;
{
	SCHLmode (new_highlight);
	SCmove_cursor (vpos, 0);
	sc_clear_end_of_line (0);
}


/* Used for starting or restarting (after suspension) the X window.  Puts the
 * cursor in a known place, update does not begin with this routine but only
 * with a call to redisplay.
 */

SCset_terminal_modes ()
{
	int stuffpending;

	InUpdate = 0;
	stuffpending = 0;
	if (!initialized) {
		CursorExists = 0;
		VisibleX = 0;
		VisibleY = 0;
	}
	SCclear_screen ();
}

/* SCmove_cursor moves the cursor to the correct location and checks whether an
 * update is in progress in order to toggle it on.
 */

SCmove_cursor (row, col)
     register int row, col;
{
	local_cursor_hpos = col;
	local_cursor_vpos = row;

	if (InUpdate) {
		if (CursorExists)
			SCCursorToggle ();
		return;
		/* Generally, SCmove_cursor will be invoked */
		/* when InUpdate with !CursorExists */
		/* so that wasteful XFlush is not called */
	}
	if ((row == VisibleY) && (col == VisibleX)) {
		if (!CursorExists)
			SCCursorToggle ();
		return;
	}
	if (CursorExists)
		SCCursorToggle ();
	VisibleX = col;
	VisibleY = row;
	if (!CursorExists)
		SCCursorToggle ();
}

/* Erase current line from current column to column END.
   Leave cursor at END.  */

SCclear_end_of_line (end)
     register int end;
{
  register int numcols;

  if (local_cursor_vpos < 0 || local_cursor_vpos >= screen_height)
    return;

  if (end <= local_cursor_hpos)
    return;
  if (end >= screen_width)
    end = screen_width;

  numcols = end - local_cursor_hpos;
  if (local_cursor_vpos == VisibleY && VisibleX >= local_cursor_hpos && VisibleX < end)
    if (CursorExists) SCCursorToggle ();
  if (CurHL)
    FillRectangle (local_cursor_hpos*XXfontw+XXInternalBorder,
		   local_cursor_vpos*XXfonth+XXInternalBorder,
		   XXfontw*numcols,
		   XXfonth);
  else
    ClearArea (local_cursor_hpos*XXfontw+XXInternalBorder,
	       local_cursor_vpos*XXfonth+XXInternalBorder,
	       XXfontw*numcols,
	       XXfonth);
  SCmove_cursor (local_cursor_vpos, end);
}

/* Erase current line from column START to right margin.
   Leave cursor at START.  */

sc_clear_end_of_line (start)
     register int start;
{
  register int numcols;

  if (local_cursor_vpos < 0 || local_cursor_vpos >= screen_height)
    return;

  if (start >= screen_width)
    return;
  if (start < 0)
    start = 0;

  numcols = screen_width - start;
  if (local_cursor_vpos == VisibleY && VisibleX >= start)
    if (CursorExists) SCCursorToggle ();
  if (CurHL)
    FillRectangle (start*XXfontw+XXInternalBorder,
		   local_cursor_vpos*XXfonth+XXInternalBorder,
		   XXfontw*numcols,
		   XXfonth);
  else
    ClearArea (start*XXfontw+XXInternalBorder,
	       local_cursor_vpos*XXfonth+XXInternalBorder,
	       XXfontw*numcols,
	       XXfonth);
  SCmove_cursor (local_cursor_vpos, start);
}

SCreset_terminal_modes ()
{
	SCclear_screen ();
}

SCclear_screen ()
{
	SCHLmode (0);
	CursorExists = 0;

	local_cursor_hpos = 0;
	local_cursor_vpos = 0;
	SavedX = 0;
	SavedY = 0;
	VisibleX = 0;
	VisibleY = 0;
	ClearWindow();
	SCCursorToggle ();
}

/* When a line has been changed this function is called.  Due to various
 * bits of braindamage on the parts of both X11 and Emacs, the new
 * version of the line is simply output if this function is invoked while
 * in UpDate.  Sometimes writechars can be invoked when not in update if
 * text is to be output at the end of the line.  In this case the whole
 * line is not output.  Simply the new text at the current cursor
 * position given by VisibleX,Y.  The cursor is moved to the end of the
 * new text.
 */

SCupdateline (first)
	int first;
{
	register int temp_length;

	if ((local_cursor_vpos < 0) || (local_cursor_vpos >= screen_height)
	    || updated[local_cursor_vpos]) {
		return;
	}
	if (!first)
		updated[local_cursor_vpos] = 1;
	if (CursorExists)
		SCCursorToggle ();
	if (new_screen->enable[local_cursor_vpos])
		temp_length = new_screen->used[local_cursor_vpos]-first;
	else
		temp_length = 0;
	if (temp_length > 0) {
		DrawText (CurHL,
			  first*XXfontw+XXInternalBorder,
			  local_cursor_vpos*XXfonth+XXInternalBorder+XXbase,
			  &new_screen->contents[local_cursor_vpos][first],
			  temp_length);
		if (temp_length < screen_width)
			sc_clear_end_of_line (temp_length);
		SCmove_cursor (local_cursor_vpos, temp_length);
	}
	else {
		sc_clear_end_of_line (0);
		SCmove_cursor (local_cursor_vpos, 0);
	}
}

SCwritechars (start, end)
     register int *start, *end;
{
  if ((local_cursor_vpos < 0) || (local_cursor_vpos >= screen_height))
    {
      return;
    }

  if (CursorExists)
    SCCursorToggle ();

  if (InUpdate)
    {
      DrawText (CurHL,
		local_cursor_hpos*XXfontw+XXInternalBorder,
		local_cursor_vpos*XXfonth+XXInternalBorder+XXbase,
		start,
		(end - start) + 1);
      SCmove_cursor (local_cursor_vpos, (end - start) + 1);
      return;
    }

  if ((VisibleX < 0) || (VisibleX >= screen_width)) {
    return;
  }
  if ((VisibleY < 0) || (VisibleY >= screen_height)) {
    return;
  }
  if (((end - start) + VisibleX) >= screen_width)
    end = start + (screen_width - (VisibleX + 1));
  if (end >= start) {
    DrawText (CurHL,
	      (VisibleX * XXfontw+XXInternalBorder),
	      VisibleY * XXfonth+XXInternalBorder+XXbase,
	      start,
	      ((end - start) + 1));
    VisibleX = VisibleX + (end - start) + 1;
  }
  if (!CursorExists)
    SCCursorToggle ();
}

static
SCoutput_chars (start, len)
     register unsigned int *start;
     register int len;
{
	SCwritechars (start, start+len-1);
}

SCflash ()
{
#ifdef HAVE_TIMEVAL
#ifdef HAVE_SELECT
	struct timeval to;

	InvertWindow();

	to.tv_sec = 0;
	to.tv_usec = 250000;
	
	select(0, 0, 0, 0, &to);
	
	InvertWindow();
#endif
#endif
}	

/* Artificially creating a cursor is hard, the actual position on the
 * screen (either where it is or last was) is tracked with VisibleX,Y.
 * Gnu Emacs code tends to assume a cursor exists in hardward at local_cursor_hpos,Y
 * and that output text will appear there.  During updates, the cursor is
 * supposed to be blinked out and will only reappear after the update
 * finishes.
 */

SCCursorToggle ()
{
	register struct matrix *active_screen;

	if (VisibleX < 0 || VisibleX >= screen_width ||
	    VisibleY < 0 || VisibleY >= screen_height) {
		/* Not much can be done */
		CursorExists = 0;
		return 0;
	}

	active_screen = current_screen;

	if (active_screen->highlight[VisibleY])
	  /* If the cursor is in the modeline, it means display was preempted.
	     Don't actually display the cursor there, just say we did.
	     The code below doesn't display it right, and nobody wants
	     to see it anyway.  */
	  ;
	else if (active_screen->enable[VisibleY]
		 && VisibleX < active_screen->used[VisibleY]) {
		if (CursorExists)
			DrawText(0,
				 VisibleX*XXfontw+XXInternalBorder,
				 VisibleY*XXfonth+XXInternalBorder+XXbase,
				 &active_screen->contents[VisibleY][VisibleX],
				 1);
		else
			DrawText(1,
				 VisibleX*XXfontw+XXInternalBorder,
				 VisibleY*XXfonth+XXInternalBorder+XXbase,
				 &active_screen->contents[VisibleY][VisibleX],
				 1);
	      }
	else {
		if (CursorExists)
			ClearArea (VisibleX*XXfontw+XXInternalBorder,
				   VisibleY*XXfonth+XXInternalBorder,
				   XXfontw, XXfonth);
		else {
		  unsigned int i[1];
		  i[0] = ' ';
			DrawText(1,
				 VisibleX*XXfontw+XXInternalBorder,
				 VisibleY*XXfonth+XXInternalBorder+XXbase,
				 i, 1);
		}
	      }

	CursorExists = !CursorExists;

	return 1;
}

SCupdate_begin ()
{
	register int i;
	
	InUpdate = 1;
	if (CursorExists)
		SCCursorToggle ();

	for (i=0;i<MAXHEIGHT;i++)
		updated[i] = 0;
	
	SavedX = local_cursor_hpos;
	SavedY = local_cursor_vpos;
	/* Thw initial "hardware" cursor position is */
	/* saved because that is where gnu emacs */
	/* expects the cursor to be at the end of */
	/* the update */
}

SCupdate_end ()
{	
	if (CursorExists)
		SCCursorToggle ();

	InUpdate = 0;
	/* Display cursor at last place requested.  */
	SCmove_cursor (local_cursor_vpos, local_cursor_hpos);
}

/* What sections of the window will be modified from the UpdateDisplay
 * routine is totally under software control.  Any line with Y coordinate
 * greater than flexlines will not change during an update.  This is really
 * used only during dellines and inslines routines (scraplines and stufflines)
 */

SCset_terminal_window (n)
     register int n;
{
	if (n <= 0 || n > screen_height)
		flexlines = screen_height;
	else
		flexlines = n;
}

SCins_del_lines (vpos, n)
     int vpos, n;
{
	SCmove_cursor (vpos, 0);
	if (n >= 0)
		sc_stufflines (n);
	else
		sc_scraplines (-n);
}

/* Estimate the cost of scrolling as equal to drawing one fifth
   of the character cells copied if black and white,
   or half of those characters if color.  */

static
SCcalculate_costs (extra, costvec, ncostvec)
     int extra;
     int *costvec, *ncostvec;
{
  int color_p = 0;

  CalcLID (0, screen_width / (color_p ? 2 : 5), 0, 0, costvec, ncostvec);
}

static
SCinsert_chars (start, len)
     register unsigned int *start;
     register int len;
{
	SCupdateline (0);
}

static
SCdelete_chars (n)
     register int n;
{
	SCupdateline (0);	/* 92.5.15 by K.Handa */
}

sc_stufflines (n)
     register int n;
{
	register int topregion, bottomregion;
	register int length, newtop;

	if (local_cursor_vpos >= flexlines)
		return;

	if (CursorExists)
		SCCursorToggle ();

	topregion = local_cursor_vpos;
	bottomregion = flexlines-(n+1);
	newtop = local_cursor_vpos+n;
	length = bottomregion-topregion+1;

	if (length > 0 && newtop <= flexlines) {
		CopyArea (XXInternalBorder,
			  topregion*XXfonth+XXInternalBorder,
			  screen_width*XXfontw,
			  length*XXfonth,
			  XXInternalBorder, newtop*XXfonth+XXInternalBorder);
	}

	newtop = min (newtop, flexlines-1);
	length = newtop-topregion;
	if (length > 0)
		ClearArea (XXInternalBorder,
			   topregion*XXfonth+XXInternalBorder,
			   screen_width*XXfontw,
			   n*XXfonth);
}

sc_scraplines (n)
     register int n;
{
	if (local_cursor_vpos >= flexlines)
		return;

	if (CursorExists)
		SCCursorToggle ();

	if (local_cursor_vpos+n >= flexlines) {
		if (flexlines >= (local_cursor_vpos + 1))
			ClearArea (XXInternalBorder,
				   local_cursor_vpos*XXfonth+XXInternalBorder,
				   screen_width*XXfontw,
				   (flexlines-local_cursor_vpos) * XXfonth);
	}
	else {
		CopyArea (XXInternalBorder,
			  (local_cursor_vpos+n)*XXfonth+XXInternalBorder,
			  screen_width*XXfontw,
			  (flexlines-local_cursor_vpos-n)*XXfonth,
			  XXInternalBorder,
			  local_cursor_vpos*XXfonth+XXInternalBorder);

		ClearArea (XXInternalBorder,
			   (flexlines-n)*XXfonth+XXInternalBorder,
			   screen_width*XXfontw,
			   n*XXfonth);
	}
}
	
/* ------------------------------------------------------------
 */
static int  reversevideo;

sc_term_init ()
{
	register char *vardisplay;
	register int xxargc;
	register char **xxargv;
	char *ptr;
	extern Lisp_Object Qt;
	int  ix;
	char *bdf_path = NULL, *charsets = NULL;

	vardisplay = (alternate_display ? alternate_display : "/dev/fb");
	if (!vardisplay) {
		fprintf (stderr, "Sun frame buffer must be set.\n");
		exit (-200);
	}

	screen = pr_open(vardisplay);
	if (!screen) {
		fprintf (stderr, "Frame buffer %s open fail.\n", vardisplay);
		exit (-99);	
	}

	baud_rate = 9600;
	min_padding_speed = 10000;
	must_write_spaces = 1;
	meta_key = 1;
	visible_bell = 1;
	inverse_video = 0;
	
	clear_screen_hook = SCclear_screen;
	clear_end_of_line_hook = SCclear_end_of_line;
	ins_del_lines_hook = SCins_del_lines;
	change_line_highlight_hook = SCchange_line_highlight;
	insert_chars_hook = SCinsert_chars;
	output_chars_hook = SCoutput_chars;
	delete_chars_hook = SCdelete_chars;
	reset_terminal_modes_hook = SCreset_terminal_modes;
	set_terminal_modes_hook = SCset_terminal_modes;
	update_begin_hook = SCupdate_begin;
	update_end_hook = SCupdate_end;
	set_terminal_window_hook = SCset_terminal_window;
	move_cursor_hook = SCmove_cursor;
	reassert_line_highlight_hook = SCreassert_line_highlight;
	scroll_region_ok = 1;	/* we'll scroll partial screens */
	char_ins_del_ok = 0;
	line_ins_del_ok = 1;	/* we'll just blt 'em */
	fast_clear_end_of_line = 1; /* Pixrect does this well */
	memory_below_screen = 0; /* we don't remember what scrolls
				  * 		off the bottom */
	dont_calculate_costs = 1;
	calculate_costs_hook = SCcalculate_costs;

	/* New options section */
	XXborder = 1;
	XXInternalBorder = 1;
	screen_width = 80;
	screen_height = 30;
	
	reversevideo = 0;

	/* Process Sun command line args...*/
	xxargc = xargc;
	xxargv = xargv;
	xxargv++;
	xxargc--;
	while (xxargc) {
		int sargc;
		sargc = xxargc;
		if (xxargc && !strcmp (*xxargv, "-r")) {
			reversevideo = !reversevideo;
			xxargc--;
			xxargv++;
		}
		if (xxargc && !strcmp (*xxargv, "-fp")) {
		  bdf_path = *(xxargv+1);
		  xxargc -= 2;
		  xxargv += 2;
		}
		if (xxargc && !strcmp (*xxargv, "-cs")) {
		  charsets = *(xxargv+1);
		  xxargc -= 2;
		  xxargv += 2;
		}
		if (sargc == xxargc) {
			xxargc--;
			xxargv++;
		}
	}

	/*  Now, actually Parse and Set colors...
	 */
	if (reversevideo) {
	  pr_reversevideo(screen, 0, 1);
	}


#ifndef CANNOT_DUMP
	if (initialized)
#endif /* CANNOT_DUMP */
		Vsunterm = Qt;

	bdf_initialize(bdf_path, charsets, 1); /* 92.10.15 by K.Handa */
	InitWindow ();
}

SCSetFlash ()
{
	ring_bell_hook = SCflash;
}

/* ------------------------------------------------------------
 *  Load a font by name.  Return the font pointer, or NULL if
 *  it can't be loaded.  Do all appropriate calculations.
 */

SC_CalcForFont()
{
  bdf_reset_font(0);
  if (!bdf_load_font(0))
    return 0;

  XXfonth = (font[0].ury - font[0].lly) + 2;
  XXfontw = font[0].urx - font[0].llx;
  XXbase = font[0].ury + 1;
  return 1;
}

/* Flip foreground/background colors */

DEFUN ("sc-flip-color", Fsc_flip_color, Ssc_flip_color, 0, 0, "",
  "Toggle the background and foreground colors")
  ()
{
	check_sunterm ();
	pr_rop(window, 0, 0, window->pr_size.x, window->pr_size.y,
	       PIX_NOT(PIX_DST),
	       0, 0, 0);
	return Qt;
}

/* ------------------------------------------------------------
 * Draw multilingual text.
 */
typedef struct {
  int bbox, bboy;
  Pixrect *pixrect;
} char_data;

set_pixrect(fontp, idx, glyphp)
     font_struct *fontp;
     int idx;
     glyph_struct *glyphp;
{
  int i, j, k, w;
  unsigned short *data;
  char_data *chardata;

  if (!(data =
	(unsigned short *)xmalloc((glyphp->bbw + 15) / 16 * 2 * glyphp->bbh)))
    return 0;
  chardata = (char_data *)xmalloc(sizeof (char_data));
  chardata->bbox = glyphp->bbox;
  chardata->bboy = XXbase - (glyphp->bbh + glyphp->bboy);
  chardata->pixrect = mem_point(glyphp->bbw, glyphp->bbh, 1, data);
  (char_data *)fontp->extra[idx] = chardata;

  w = (glyphp->bbw + 7) / 8 * 2;
  for (i = 0; i < glyphp->bbh; i++) {
    for (j = 0; j < w; j += 2) {
      sscanf(glyphp->bitmap + (i * w + j), "%2x", &k);
      if (j % 4) {
	*data = *data << 8 | k;
	data++;
      } else {
	*data = k;
      }
    }
    if (w % 4)
      *data++ <<= 8;
  }
  return 1;
}

DrawChar(x, y, ch, rflag)
     int x, y, rflag;
     unsigned int ch;
{
  int width, idx;
  unsigned char lc = MTRX_LC(ch), attr = MTRX_ATTR(ch);
  font_struct *fontp = &font[lc & 0x7F];
  char_data *chardata;

  idx = fontp->bytes == 1
    ? OFFIDX1(MTRX_CODEL(ch))
    : OFFIDX2((MTRX_CODEH(ch) & 0x7F) * 256 + (MTRX_CODEL(ch)));

  if (!fontp->loaded) {
    if (!(bdf_reset_font(lc & 0x7F), bdf_load_font(lc & 0x7F)))
      return 0;
  }
  if (fontp->extra[idx] == NULL) {
    if (bdf_load_glyph(lc & 0x7F, idx, &glyph))
      set_pixrect(fontp, idx, &glyph);
  }
  chardata = (char_data *)fontp->extra[idx];

  width = char_width[lc] * XXfontw;

  pr_rop(window, x, y, width, XXfonth, PIX_CLR, 0, 0, 0);
  if (chardata != NULL) {
    int xx = x + chardata->bbox;
    int yy = y + chardata->bboy;

    pr_rop(window, xx, yy, width, XXfonth - 2,
	   PIX_SRC, chardata->pixrect, 0, 0);
    if (attr & MTRX_BOLD2)
      pr_rop(window, xx + 1, yy, width - 1, XXfonth - 2,
	     PIX_SRC | PIX_DST, chardata->pixrect, 0, 0);
  }
  if (attr & MTRX_UNDERLINE2)
    pr_vector(window, x, y + XXfonth - 2, x + width, y + XXfonth - 2,
	      PIX_SET, 0);
  if (!(attr & MTRX_INVERSE2) ^ !rflag)
    pr_rop(window, x, y, width, XXfonth, PIX_NOT(PIX_DST), 0, 0 ,0);
}

DrawText(rflag, x, y, line, count)
     int rflag;
     int x, y, count;
     unsigned int *line;
{
  int i;

  for (i = 0; i < count; i++) {
    if (!(*line & MTRX_REST))
      DrawChar(x, y - XXbase, *line, rflag);
    x += XXfontw;
    line++;
  }
}

/* ------------------------------------------------------------
 */
static int
InitWindow ()
{
    extern int xargc;
    extern char **xargv;
    int x, y, width, height, pr;
    char  *dp;

    if (!SC_CalcForFont()) {
      fprintf (stderr, "Sun console unable to find font for ASCII\n");
      fflush (stderr);
      pr_close(screen);
      exit (-97);
    }

    width = screen_width * XXfontw + 2 * XXInternalBorder;
    height = screen_height * XXfonth + 2 * XXInternalBorder;
    x = (screen->pr_size.x - width) / 2;
    y = (screen->pr_size.y - height) / 2;
    window = pr_region(screen, x, y, width, height);
    if (!window)
    {
	fprintf (stderr, "Could not create Sun console window!\n");
	fflush (stderr);
	exit (-97);
    }

    CursorExists = 0;
    VisibleX = 0;
    VisibleY = 0;
}

syms_of_sunterm ()
{
  /* If not dumping, init_display ran before us, so don't override it.  */
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    Vsunterm = Qnil;

  defsubr (&Ssc_flip_color);
}

#endif /* HAVE_SUN_CONSOLE */
