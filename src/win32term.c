/* Win32 graphics module for MS Windows NT and Windows 3.1
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

/* 93.6.1  created by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
	This file is created by modifying `sunterm.c'. */

#include "config.h"
#if defined(WIN32)

#include "lisp.h"
/* 92.10.28 by M.Higashida */
#include "paths.h"	/* `PATH_EXEC' was defined. */
/* end of patch */

#include <stdio.h>
#ifdef NULL
#undef NULL
#define NULL 0
#endif

#include <windows.h>
#include <winsock.h>

#if defined(WIN32) && defined(USE_FATFS)
#include "dispexte.h"
#include "termhook.h"
#else
#include "dispextern.h"
#include "termhooks.h"
#endif
#include "termopts.h"
#include "termchar.h"
#include "mule.h"
#include "codeconv.h"
#if 0
#include "../etc/bdf.h"
#endif

#define min(a,b) ((a)<(b) ? (a) : (b))
#define max(a,b) ((a)>(b) ? (a) : (b))

#define MINWIDTH 12	/* In pixels */
#define MINHEIGHT 5	/* In pixels */
#define MAXHEIGHT 300	/* In lines */

int XXfontw, XXfonth, XXbase, XXisColor;
/* 92.10.27 by M.Higashida */
int XXlinespace;
/* end of patch */

static HFONT hFont; /* 93.5.6 by H.Igarashi */

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

int CurHL;			/* Current Highlighting (ala mode line) */

int XXborder;			/* Window border width */
int XXInternalBorder;		/* Internal border width */
int updated[MAXHEIGHT];

char *rindex();

/* Definition of basic pixrect operations */

HBRUSH hWhiteBrush;
HBRUSH hBlackBrush;

extern HWND hwndMain;

FillRectangle (dx, dy, dw, dh)
  int dx, dy, dw, dh;
{
  HDC hDC = GetDC (hwndMain);
  RECT rc;

  rc.left   = dx;
  rc.top    = dy;
  rc.right  = (dx)+(dw)/*-1*/;
  rc.bottom = (dy)+(dh)/*-1*/;

  FillRect (hDC, &rc, hBlackBrush);
  ReleaseDC (hwndMain, hDC);
  /* InvalidateRect (hwndMain, &rc, FALSE); */
}

ClearArea (dx, dy, dw, dh)
  int dx, dy, dw, dh;
{
  HDC hDC = GetDC (hwndMain);
  RECT rc;

  rc.left   = dx;
  rc.top    = dy;
  rc.right  = (dx)+(dw)/*-1*/;
  rc.bottom = (dy)+(dh)/*-1*/;

  FillRect (hDC, &rc, hWhiteBrush);
  ReleaseDC (hwndMain, hDC);
  /* InvalidateRect (hwndMain, &rc, FALSE); */
}

InvertArea (dx, dy, dw, dh)
  int dx, dy, dw, dh;
{
  HDC hDC = GetDC (hwndMain);
  RECT rc;

  rc.left   = dx;
  rc.top    = dy;
  rc.right  = (dx)+(dw)/*-1*/;
  rc.bottom = (dy)+(dh)/*-1*/;

  InvertRect (hDC, &rc);
  ReleaseDC (hwndMain, hDC);
  /* InvalidateRect (hwndMain, &rc, FALSE); */
}

ClearWindow()
{
  int x, y;
  HDC hDC = GetDC (hwndMain);
  x = GetDeviceCaps(hDC, HORZRES);
  y = GetDeviceCaps(hDC, VERTRES);
  ReleaseDC (hwndMain, hDC);
  ClearArea(0,0,x,y);
}

InvertWindow()
{
  int x, y;
  HDC hDC = GetDC (hwndMain);
  x = GetDeviceCaps(hDC, HORZRES);
  y = GetDeviceCaps(hDC, VERTRES);
  ReleaseDC (hwndMain, hDC);
  InvertArea(0,0,x,y);
}

CopyArea (sx, sy, sw, sh, dx, dy)
  int sx, sy, sw, sh, dx, dy;
{
  HDC hDC = GetDC (hwndMain);
  RECT rc;

  rc.left   = dx;
  rc.top    = dy;
  rc.right  = (dx)+(sw)-1;
  rc.bottom = (dy)+(sh)-1;

  BitBlt (hDC, dx, dy, sw, sh, hDC, sx, sy, SRCCOPY);
  ReleaseDC (hwndMain, hDC);
  /* InvalidateRect (hwndMain, &rc, FALSE); */
}

Lisp_Object Vwin32term;

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
#if 0
	GrSetMode (GR_width_height_graphics, 640, 480);
#endif
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
#if 0
	GrSetMode (GR_default_text);
#endif
}

SCclear_screen ()
{
	SCHLmode (0);
	CursorExists = 0;

#if 0
#ifdef USE_IME
	ImeMoveConvertWin (hwndMain,
			   XXInternalBorder,
			   (screen_height-1)*XXfonth+XXInternalBorder);
#endif
#endif
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
		_DrawText (CurHL,
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
      _DrawText (CurHL,
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
    _DrawText (CurHL,
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

/* 92.10.28 by M.Higashida */
static
SCflash ()
{
#ifndef WIN32S
  PlaySound ("/winnt/ding.wav", 0, SND_FILENAME | SND_ASYNC | SND_NOWAIT);
#endif
  InvertWindow (), _sleep (10), InvertWindow ();
}
/* end of patch */

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
			_DrawText(0,
				 VisibleX*XXfontw+XXInternalBorder,
				 VisibleY*XXfonth+XXInternalBorder+XXbase,
				 &active_screen->contents[VisibleY][VisibleX],
				 1);
		else
			_DrawText(1,
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
			_DrawText(1,
				 VisibleX*XXfontw+XXInternalBorder,
				 VisibleY*XXfonth+XXInternalBorder+XXbase,
				 i, 1);
		}
	      }

	CursorExists = !CursorExists;

#ifdef USE_IME
	ImeMoveConvertWin (hwndMain,
			   VisibleX*XXfontw+XXInternalBorder,
			   VisibleY*XXfonth+XXInternalBorder);
#endif

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

/* used by dumprectangle which is usually invoked upon Expose
 * events which come from bit blt's or moving an obscuring opaque window
 */

dumpchars (active_screen, numcols, tempX, tempY, tempHL)
     register struct matrix *active_screen;
     register int numcols;
     register int tempX, tempY, tempHL;
{
	if (numcols <= 0)
		return;

	if (numcols-1+tempX > screen_width)
		numcols = screen_width-tempX+1;

	if (tempX < 0 || tempX >= screen_width ||
	    tempY < 0 || tempY >= screen_height)
		return;

				/* 91.11.28 by K.Handa */
	while (tempX > 0 && active_screen->contents[tempY][tempX] & MTRX_REST)
	  tempX--, numcols++;
	_DrawText(tempHL,
			 tempX*XXfontw+XXInternalBorder,
			 tempY*XXfonth+XXInternalBorder+XXbase,
			 (char *) &active_screen->contents[tempY][tempX],
			 numcols);
}

/* Used for Expose events.  Have to get the text
 * back into the newly blank areas.
 */

dumprectangle (top, left, rows, cols)
     register int top, left, rows, cols;
{
	register struct matrix *active_screen;
	register int ourindex;
	int localX, localY, localHL;

 	if (top < 0)
		top = 0;
	if (left < 0)
		left = 0;
	rows += top;
	cols += left;
	top /= XXfonth;
	/* Get row and col containing up and */
	/* left borders of exposed region -- */
	/* round down here*/
	left /= XXfontw;
	rows += XXfonth-1;
	cols += XXfontw-1;
	rows /= XXfonth;
	/* Get row and col containing bottom and */
	/* right borders -- round up here */
	rows -= top;
	cols /= XXfontw;
	cols -= left;

	if (rows < 0)
		return;
	if (cols < 0)
		return;
	if (top > screen_height - 1)
		return;
	if (left > screen_width - 1)
		return;
#if 0
	if (VisibleX >= left && VisibleX < left + cols &&
	    VisibleY >= top && VisibleY < top + rows)
		ClearCursor ();
#endif

	if (InUpdate)
		active_screen = new_screen;
	else
		/* When queue is dumped in update this */
		active_screen = current_screen;
	
	for (localY = top, ourindex = 0;
	     ourindex < rows && localY < screen_height;
	     ++ourindex, ++localY) {
		if (localY < 0 || localY >= screen_height ||
		    !active_screen->enable[localY] ||
		    left+1 > active_screen->used[localY])
			continue;
		localX = left;
		localHL = active_screen->highlight[localY];
		dumpchars (active_screen,
			   min (cols,
				active_screen->used[localY]-localX),
			   localX, localY, localHL);
	}
	if (!InUpdate && !CursorExists)
		SCCursorToggle ();
	/* Routine usually called */
	/* when not in update */
}


SCread_socket (sd, bufp, numchars)
    register int sd;
    register char *bufp;
    register int numchars;
{
  return (internal_socket_read (bufp, numchars));
}

static int XXcount;
static unsigned char *XXbufp;

internal_socket_read (bufp, numchars)
    register unsigned char *bufp;
    register int numchars;
{
  HANDLE hWnd;

#ifdef HAVE_THREAD
  hWnd = (HANDLE) 0;
#else
  hWnd = hwndMain;
#endif

  XXcount = 0;
  XXbufp = bufp;

#ifdef USE_IME
  {
    extern CRITICAL_SECTION KeyboardBufferCriticalSection;
    extern unsigned char *win32_keyboard_bufsp, *win32_keyboard_bufp;
    
    if (initialized && win32_keyboard_bufp > win32_keyboard_bufsp) {
      EnterCriticalSection (&KeyboardBufferCriticalSection);
      {
	unsigned char *p = win32_keyboard_bufsp;
	
	while (p < win32_keyboard_bufp) {
	  *XXbufp++ = *p++;
	  XXcount++;
	}
	win32_keyboard_bufp = win32_keyboard_bufsp;
      }
      LeaveCriticalSection (&KeyboardBufferCriticalSection);
    }
  }
#endif

  {
    MSG msg;

    while (initialized && PeekMessage (&msg, hWnd, 0, 0, PM_NOREMOVE))
      {
	if (GetMessage (&msg, hWnd, 0, 0)) {
#ifndef HAVE_THREAD
	  TranslateMessage (&msg);
#endif
	  win32_dispatcher (&msg);
	}
      }
  }

  return XXcount;
}

win32_dispatcher (msgp)
    MSG *msgp;
{
  switch (msgp->message) {
  case WM_SIZE:
    {
      int rows, cols;
      int width, height;
      RECT rc;
      
      rc.left = 0;
      rc.top = 0;
      rc.right = LOWORD (msgp->lParam);
      rc.bottom = HIWORD (msgp->lParam);
      AdjustWindowRect (&rc, 0, 0);
      width  = rc.right-rc.left+1;
      height = rc.bottom-rc.top+1;

      cols = (width-2*XXInternalBorder)/XXfontw;
      rows = (height-2*XXInternalBorder)/XXfonth;
      
      if (cols > 11 && rows > 4) {
        {
#if 0
          int new_width  = cols*XXfontw+2*XXInternalBorder;
          int new_height = rows*XXfonth+2*XXInternalBorder;

          if (new_width != width || new_height != height)
            SetWindowPos (hwndMain, (HWND) 0, 0, 0,
                          new_width, new_height,		      
                          SWP_NOMOVE | SWP_NOZORDER);
            else
#endif
          change_screen_size (rows, cols, 0, !waiting_for_input, 1);
	}
      }
    }
    break;

  case WM_PAINT:
    {
      PAINTSTRUCT ps;
      RECT rect;
      GetUpdateRect (hwndMain, &rect, FALSE);
      BeginPaint (hwndMain, (LPPAINTSTRUCT) &ps);
      dumprectangle (rect.top-XXInternalBorder,
	             rect.left-XXInternalBorder,
		     rect.bottom-rect.top,
		     rect.right-rect.left);
      EndPaint (hwndMain, (LPPAINTSTRUCT) &ps);
    }
    break; 

#if 1
  case WM_CHAR:
  case WM_SYSCHAR: /* 93.5.6 by H.Igarashi */
    {
      unsigned char c;

      c = (unsigned char) (msgp->wParam);
      *XXbufp++ = c | (((msgp->lParam) & 0x20000000) ? 0x80 : 0); /* ALT key */
      XXcount++;
    }
    break;
#endif

  default:
    return DefWindowProc (hwndMain, msgp->message, msgp->wParam, msgp->lParam);
  }   
}


/* ------------------------------------------------------------ */

#if 0
/* 92.10.28 by M.Higashida */
/* `0' is not loaded. */
#define DYNAMIC	0x01	/* Dynamically: the value should be `1'. */
#define STATIC	0x02	/* Pre-loaded */
#define MISSING	0x10	/* Missing the font */

static int bdf_staff_initialized = 0;

init_bdf_once ()
{
  extern char *bdf_path, *charsets;

  if (!bdf_staff_initialized) {
   bdf_initialize (bdf_path, charsets, 1); /* should be once */
   bdf_staff_initialized = 1;
  }
}
/* end of patch */
#endif

win32_term_init ()
{
	register int xxargc;
	register char **xxargv;
#if 0
	/* 92.10.28 by M.Higashida */
	extern char *bdf_path, *charsets;

	bdf_path = NULL;
	charsets = NULL;
	/* end of patch */
#endif
	/* 93.5.6 by H.Igarashi */
#ifndef WIN32S
	/* Initialize Winsock API */
	{
	  WORD wVersion = 0x0101;
	  WSADATA wsadata;
	  WSAStartup(wVersion, &wsadata);
	}
#endif

	baud_rate = 38400;
	min_padding_speed = 10000;
	must_write_spaces = 1;
	meta_key = 0;	/* 92.10.28 by M.Higashida */
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
        read_socket_hook = SCread_socket;
	move_cursor_hook = SCmove_cursor;
	reassert_line_highlight_hook = SCreassert_line_highlight;
	/* 92.10.28 by M.Higashida */
	ring_bell_hook = SCflash;
	/* end of patch */
	scroll_region_ok = 1;	/* we'll scroll partial screens */
	char_ins_del_ok = 0;
	line_ins_del_ok = 1;	/* we'll just blt 'em */
	fast_clear_end_of_line = 1; /* Pixrect does this well */
	memory_below_screen = 0; /* we don't remember what scrolls
				  * 		off the bottom */
	dont_calculate_costs = 1;
	calculate_costs_hook = SCcalculate_costs;

	/* New options section */
	XXborder = 0;
	XXInternalBorder = 0;
	XXlinespace = 0;	/* 92.10.28 by M.Higashida */
	screen_width = 80;
	screen_height = 25;	/* 92.10.28 by M.Higashida */

	/* Process Sun command line args...*/
	xxargc = xargc;
	xxargv = xargv;
	xxargv++;
	xxargc--;
	while (xxargc) {
		int sargc;
		sargc = xxargc;
#if 0
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
#endif
		if (sargc == xxargc) {
			xxargc--;
			xxargv++;
		}
	}


#ifndef CANNOT_DUMP
	if (initialized)
#endif /* CANNOT_DUMP */
		Vwin32term = Qt;

#if 0
	/* 92.10.28 by M.Higashida */
        {
	  bdf_path = (bdf_path != NULL ? bdf_path : BDF_PATH);
	  charsets = (charsets != NULL ? charsets : CHARSETS);
	  bdf_reinit_font();
	}
	/* end of patch */
#endif
	InitWindow ();
}

#if 0
/* ------------------------------------------------------------
 *  Load a font by name.  Return the font pointer, or NULL if
 *  it can't be loaded.  Do all appropriate calculations.
 */

/* 92.10.28 by M.Higashida */
SC_CalcForFont()
{
  font_struct *fontp = &font[0];

  if (!fontp->loaded) {
    bdf_reset_font(0);
    bdf_load_font(0);
    if (!(fontp->loaded & DYNAMIC)) return 0;
  }

  XXfonth = (font[0].ury - font[0].lly) + XXlinespace;
  XXfontw = font[0].urx - font[0].llx;
  XXbase = XXfonth - XXlinespace / 2;
  return 1;
}
/* end of patch */

/* ------------------------------------------------------------
 * Draw multilingual text.
 */
/* 92.10.28 by M.Higashida : almost rewriten.  */
static GrBitmap bdf_bitmap = { 0, 0, NULL, 0, 0, 0 };
static char tem[3] = { 0, 0, 0 };
static char missing_glyph[24*2] = {
  0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22,
  0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22,
  0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22,
  0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22,
  0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22,
  0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22,
};

DrawChar(x, y, ch, rflag)
     int x, y, rflag;
     unsigned int ch;
{
  int idx;
  unsigned char lc = MTRX_LC(ch), attr = MTRX_ATTR(ch);
  font_struct *fontp = &font[lc & 0x7F];

  idx = fontp->bytes == 1
    ? OFFIDX1(MTRX_CODEL(ch))
    : OFFIDX2((MTRX_CODEH(ch) & 0x7F) * 256 + (MTRX_CODEL(ch)));

  if (!fontp->loaded) {
    bdf_reset_font(lc & 0x7F);
    bdf_load_font(lc & 0x7F);
    if (!(fontp->loaded & DYNAMIC)) fontp->loaded = MISSING;
  }

  if (fontp->extra[idx] == NULL) {
    if ((fontp->loaded & DYNAMIC) && bdf_load_glyph(lc & 0x7F, idx, &glyph)) {
      int i, char_width = (glyph.bbw + 7) / 8;

      fontp->extra[idx] = (char *) malloc (char_width * glyph.bbh);
      for (i = 0; i < glyph.bbh * char_width; i++) {
	strncpy (tem, glyph.bitmap + (i * 2), 2);
	*(fontp->extra)[idx] + (i/char_width) + (i%char_width)*glyph.bbh)
	  = strtol (tem, NULL, 16);
      }
    } else {
      fontp->extra[idx] = missing_glyph;
    }
  }

  {
    int YYfonth = XXfonth - XXlinespace;
    int YYfontw = XXfontw * char_width[lc];
    GrContext save, window;

    GrCreateSubContext (x,y,x+YYfontw-1,y+YYfonth+XXlinespace-1,NULL,&window);
    GrSaveContext (&save);
    GrSetContext (&window);
    GrClearContext (GrBlack ());

    {
      int i, char_width = (YYfontw + 7) / 8;

      for (i = 0; i < char_width; i++) {
	bdf_bitmap.bmp_data = fontp->extra[idx] + YYfonth*i;
	GrPatternFilledBox(8*i,0,8*(i+1)-1,YYfonth-1,
			   (GrPattern *) &bdf_bitmap);
      }
    }
    if (attr & MTRX_BOLD2)
      GrBitBlt(&window,1,0,&window,0,0,YYfontw-2,YYfonth-1,GrOR);
    if (attr & MTRX_UNDERLINE2)
      GrLine(0,XXbase-1,YYfontw-1,XXbase-1,GrWhite());
    if (!(attr & MTRX_INVERSE2) ^ !rflag)
      InvertArea(0,0,YYfontw,YYfonth+XXlinespace);

    GrSetContext (&save);
  }
}
#endif /* 0 */

#ifdef UNICODEDISPLAY /* 93.5.6 by H.Igarashi */

int s2u(s, t, slength)
unsigned char *s;
WCHAR *t;
int slength;
{
  int i;
  BOOL twobytes = FALSE;
  unsigned char firstbyte;
  int tlength = 0;

#include "s2u.tbl"

  for ( i = 0; i < slength; s++, i++ ) {
       if (twobytes) {
	    *t++ = s2utbl[firstbyte <<8 | *s];
	    twobytes = FALSE;
	    tlength++;
       }
       else {
	    if ((*s>= 0xe0)  ||  ((0x80 <=  *s) && (*s <= 0x9f))) { 
		 firstbyte = *s;
		 twobytes = TRUE;
	    }
	    else {
		 *t++ = s2utbl[ *s];
		 tlength++;
	    }
       } 
  }
  return tlength;

}
#endif /* UNICODEDISPLAY */

_DrawText(rflag, x, y, line, count)
     int rflag;
     int x, y, count;
     unsigned int *line;
{
  HDC hDC = GetDC (hwndMain);
  /* HFONT hFont = GetStockObject (SYSTEM_FIXED_FONT); */
  SelectObject (hDC, hFont);
  SetTextAlign (hDC, TA_BOTTOM | TA_LEFT);

#if 1
  {
    char *line2 = get_conversion_buffer (count, LINECODE);
    int count2 = linecode_conversion (count, line, line2);
#ifdef UNICODEDISPLAY /* 93.5.6 by H.Igarashi */
    {
      int count3;
      WCHAR *line3;
      unsigned char conversion_buffer[1024];

      if (count2*2 > sizeof(conversion_buffer)) {
	line3 = malloc(count2*2);
	if (line3 == 0 ) {
	  memory_full();
	  line3 = conversion_buffer;
	}
      }
      else
	line3 = conversion_buffer;
      count3 = s2u(line2, line3, count2);
      TextOutW (hDC, x, y, line3, count3);
      if (line3 != conversion_buffer)
	free(line3);
    }
#else /* not UNICODEDISPLAY */
    TextOut (hDC, x, y, line2, count2);
#endif /* not UNICODEDISPLAY */
    if (rflag)
      InvertArea (x, y-XXfonth+XXlinespace, 
                  XXfontw*count2, XXfonth-XXlinespace);
  }
#else
  {
    int i;
    char *p, buf[512];

    p = buf;
    for (i = 0; i < count; i++) {
      if (!(*line & MTRX_REST))
#define OFFIDX1(c) ((c) &0x7F)
        *p++ = (char *) OFFIDX1(MTRX_CODEL(*line));
      line++;
    }
    *p = 0;
    TextOut (hDC, x, y, buf, strlen (buf));
    if (rflag)
      InvertArea (x, y-XXfonth+XXlinespace, XXfontw*strlen (buf), XXfonth-XXlinespace);
  }
#endif
  ReleaseDC (hwndMain, hDC);
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
    TEXTMETRIC textmetric;
#ifdef UNICODEDISPLAY /* 93.5.6 by H.Igarashi */
    static LOGFONTW lf = {
      -16, 0, 0, 0, 0,
      FALSE, FALSE, FALSE, 
      0, 0, 0, 0, 0x32, 
#if 1
      { 0xff2d, 0xff33, 0x20, 0x30b4, 0x30b7,0x30c3, 0x30af } /* gothic */
#else
      { 0xff2d, 0xff33, 0x20, 0x660e, 0x671d } /* mincho */
#endif
};

    hFont = CreateFontIndirectW(&lf);
#else /* not UNICODEDISPLAY */

    hFont = GetStockObject (SYSTEM_FIXED_FONT);
#endif /* not UNICODEDISPLAY */

    /* 93.5.6 by H.Igarashi */
    {
      HFONT hOldFont;
      HDC hDC = GetDC (hwndMain);
      
      hOldFont = SelectObject (hDC, hFont);
      SetTextAlign (hDC, TA_BOTTOM | TA_LEFT);

      GetTextMetrics (hDC, &textmetric);
      XXfonth = textmetric.tmHeight + XXlinespace;
      XXfontw = textmetric.tmAveCharWidth;
      XXbase = XXfonth - XXlinespace / 2;
      DeleteObject(hOldFont);
      /* SelectObject(hDC, hOldFont); */
      ReleaseDC (hwndMain, hDC);
    }

    CursorExists = 0;
    VisibleX = 0;
    VisibleY = 0;
}

#if 0
/*************************************************************************/
/* Can't share with `../etc/bdf.c' */
static char line[256], dummy[256];

/* Almost the same within `../etc/bdf.c', but can't share. */
bdf_reinit_font()
{
  int i, bytes;
  char *p;
  FILE *fp;
/* 92.10.28 by M.Higashida */
  extern char *charsets;

#if 0
  for (i = 0; i < 128; i++) {
    font[i].fp = NULL;
    font[i].filename = NULL;
    font[i].loaded = 0;
    font[i].offset = NULL;
    font[i].bytes = 1;
#ifndef emacs
    font[i].defined =NULL;
#endif
  }
#endif
/* end of patch */

  if ((fp = bdf_fopen(PATH_EXEC, charsets)) != NULL) {
    while (fgets(line, sizeof(line), fp)) {
      i = atoi(line) & 0x7F;
      if ((p = index(line, ':')) && (p = index(++p, ':'))
	  && (p = index(++p, ':'))) {
	font[i].bytes = atoi(++p) <= 1 ? 1 : 2;
	if ((p = index(++p, ':')) && (p = index(++p, ':'))
	    && (p = index(++p, ':')) && (p = index(++p, ':'))) {
	  p++;
	  p[strlen (p) - 1] = 0;	/* \n -> 0 */
	  bdf_set_filename(i, p);
	}
      }
    }
    fclose(fp);
  }
}

/* Why should be here?  But... */
static
bdf_proceed_line(fp, str)
     FILE *fp;
     char *str;
{
  int len = strlen(str);
  do {
    if (fgets(line, sizeof(line), fp) == NULL)
      return 0;
  } while (strncmp(line, str, len));
  return 1;
}

static
bdf_preload_font(lc)
  int lc;
{
  font_struct *fontp = &font[lc];
  int i, j, bbw, bbh, bbox, bboy;
  unsigned int idx;
  extern char *bdf_path;

  if (fontp->filename == NULL
      || (fontp->fp = bdf_fopen(bdf_path, fontp->filename)) == NULL)
    return 0;
  bdf_proceed_line(fontp->fp, "FONTBOUNDINGBOX ");
  sscanf(line, "%s %d %d %d %d", dummy, &bbw, &bbh, &bbox, &bboy);
  fontp->llx = bbox, fontp->lly = bboy;
  fontp->urx = bbw + bbox, fontp->ury = bbh + bboy;
  bdf_proceed_line(fontp->fp, "CHARS ");
  sscanf(line, "%s %d", dummy, &(fontp->chars));

  {
    int char_width = (bbw + 7) / 8;
    int size = (fontp->bytes == 1) ? 128 : 96 * 96;

    if (fontp->offset) free (fontp->offset);
    if (fontp->extra) free (fontp->extra);
    {
      char **q
	= fontp->extra
	  = (char**)malloc(size*(sizeof(char *)+(char_width*bbh)));
      if (!q) return 0;
      else bzero (fontp->extra, size*(sizeof(char *)+(char_width*bbh)));
      /* Arrange pointer to access with bracket. */
      {
	char *p = (char *) &fontp->extra[size];
	int i = size;
	while (i) { *q = p; q++, p += char_width*bbh, i--; }
      }
    }

    for (;;) {
      int idx;

      bdf_proceed_line (fontp->fp, "ENCODING ");
      sscanf (line, "%s %d", dummy, &idx);
      if (fontp->encoding && idx < 0x80) goto skip;
      else {
	idx &= 0x7F7F;
	idx = (fontp->bytes == 1) ? OFFIDX1(idx) : OFFIDX2(idx);
      }
      bdf_proceed_line(fontp->fp, "BITMAP");
      i = bbh; j = 0;
      for (i = 0; i < bbh; i++) {
	if (!fgets(line, sizeof(line), fontp->fp)) goto skip;
	{
	  j = char_width;
	  while (j--) {
	    fontp->extra[idx][i+bbh*j] = strtol(line+j*2,NULL,16);
	    line[j*2] = 0;
	  }
	}
      }
    skip:
      do {
	if (!fgets(line,sizeof(line),fontp->fp)) goto done;
      } while (strncmp (line,"STARTCHAR", 9));
    }
  }
 done:
  fontp->loaded = STATIC;
  close (fontp->fp);
  return 1;
}

DEFUN ("win32-load-font", Fwin32_load_font, Swin32_load_font, 1, 1, "", "")
  (lc)
{
  CHECK_NUMBER (lc, 0);
  if (!font[XFASTINT (lc)].loaded &&
      bdf_preload_font (XFASTINT (lc))) return Qt;
  return Qnil;
}
#endif /* 0 */

syms_of_win32term ()
{
  /* If not dumping, init_display ran before us, so don't override it.  */
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    Vwin32term = Qnil;
}
/* end of patch */
#endif /* WIN32 */
