/* Functions for the X window system.
   Copyright (C) 1988, 1990, 1992 Free Software Foundation.

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

/* 92.5.21  modified for Mule Ver.0.9.4 by Y.Kawabe <kawabe@sra.co.jp>
	Fx_store_compound_text() and Fx_get_compound_text() are added. */
/* 92.6.14  modified for Mule Ver.0.9.5 by Y.Kawabe <kawabe@sra.co.jp>
	Fx_store_compound_text() calls XFlush() at the end. */
/* 92.7.30  modified for Mule Ver.0.9.5 by Y.Kawabe <kawabe@sra.co.jp>
	Macro DEFATOM has 3 arguments now. */
/* 92.9.7   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Fx_set_font() can set non ASCII font now. */
/* 92.10.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	x-default-fonts and x-default-encoding are defined.
	New function Fx_set_linespace().*/
/* 92.11.25 modified for Mule Ver.0.9.7 by T.Enami <enami@sys.ptg.sony.co.jp>
	In Fx_set_linespace(), bug in handling linespace fixed. */
/* 92.12.10 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Above and below linespaces can be specified independently.
	Font manipulation methods changed. */
/* 92.12.16 modified for Mule Ver.0.9.7 by A.Furuta <furuta@sra.co.jp>
	Fx_get_compound_text() accepts "STRING". */
/* 93.4.11  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Shape of bold characters are controlled by x-horizontal-bold-style.
	Handling of cursor color is improved. */
/* 93.4.30  modified for Mule Ver.0.9.8 by Y.Kawabe <kawabe@sra.co.jp>
	Fx_set_font() should not do free (XXcurrentfont). */
/* 93.5.20  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	CCL support. */

/* Written by Yakim Martillo; rearranged by Richard Stallman.  */
/* Color and other features added by Robert Krawitz*/
/* Converted to X11 by Robert French */

#include <stdio.h>
#include <signal.h>
#include "config.h"

/* Get FIONREAD, if it is available.  */
#ifdef USG
#include <termio.h>
#endif /* USG */
#include <fcntl.h>

#ifndef VMS
#include <sys/ioctl.h>
#endif /* not VMS */

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

/* 93.5.20 by K.Handa */
/* Now we have to include "lisp.h" before "x11term.h" */
#include "lisp.h"
/* but "x11term.h" sometimes include "stddef.h", so .. */
#undef NULL
#include "x11term.h"
/* and here again define NULL just as the same way as in "lisp.h" */
#undef NULL
#define NULL(x)  (XFASTINT (x) == XFASTINT (Qnil))
/* end of patch */

#include "dispextern.h"
#include "termchar.h"

#ifdef HAVE_SOCKETS
#include <sys/socket.h>		/* Must be done before gettime.h.  */
#endif
/* Include time.h or sys/time.h or both.  */
#include "gettime.h"
#include <setjmp.h>

#include "window.h"

#ifdef HAVE_X_WINDOWS

#define abs(x) ((x < 0) ? ((x)) : (x))
#define sgn(x) ((x < 0) ? (-1) : (1))
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))
  
/* Non-nil if Emacs is running with an X window for display.
   Nil if Emacs is run on an ordinary terminal.  */

Lisp_Object Vxterm;

Lisp_Object Vx_mouse_pos;
Lisp_Object Vx_mouse_abs_pos;

Lisp_Object Vx_mouse_item;

/* These are standard "white" and "black" strings, used in the
   *_color variables when the color was not specially allocated for them.  */
char *white_color = "white";
char *black_color = "black";

extern Lisp_Object MouseMap;

extern Lisp_Object minibuf_window;
extern int minibuf_prompt_width;

extern XEvent *XXm_queue[XMOUSEBUFSIZE];
extern int XXm_queue_num;
extern int XXm_queue_in;
extern int XXm_queue_out;
extern char *fore_color;
extern char *back_color;
extern char *brdr_color;
extern char *mous_color;
extern char *curs_color;

extern unsigned long fore;
extern unsigned long back;
extern unsigned long brdr;
extern unsigned long curs;

extern int XXborder;
extern int XXInternalBorder;

extern char *progname;

extern XFontStruct *fontinfo;
extern Font XXfid;
extern GC XXgc_norm,XXgc_rev,XXgc_curs,XXgc_temp,XXgc_curs_rev;
extern XGCValues XXgcv;
extern int XXfontw,XXfonth,XXbase,XXisColor;
extern Colormap XXColorMap;

extern int PendingExposure;
extern char *default_window;
extern char *desiredwindow;

extern int XXscreen;
extern Window XXwindow;
extern Cursor EmacsCursor;
extern short MouseCursor[], MouseMask[];
extern char *XXcurrentfont;
extern int informflag;

extern int WindowMapped;
extern int CurHL;
extern int pixelwidth, pixelheight;
extern int XXpid;

extern char *XXidentity;

extern Display *XXdisplay;
extern int bitblt, CursorExists, VisibleX, VisibleY;

/* 92.10.11 by K.Handa */
extern font_struct fonts[128];
extern Lisp_Object Vx_default_fonts, Vx_default_encoding;
extern int x_horizontal_bold_style; /* 93.4.11 by K.Handa */
extern Lisp_Object Vx_ccl_programs; /* 93.5.28 by K.Handa */

check_xterm ()
{
	if (NULL (Vxterm))
		error ("Terminal does not understand X protocol.");
}

DEFUN ("x-set-bell", Fx_set_bell, Sx_set_bell, 1, 1, "P",
  "For X window system, set audible vs visible bell.\n\
With non-nil argument (prefix arg), use visible bell; otherwise, audible bell.")
   (arg)
     Lisp_Object arg;
{
	BLOCK_INPUT_DECLARE ();

	check_xterm ();
	BLOCK_INPUT ();
	if (!NULL (arg))
		XSetFlash ();
	else
		XSetFeep ();
	UNBLOCK_INPUT ();
	return arg;
}

DEFUN ("x-flip-color", Fx_flip_color, Sx_flip_color, 0, 0, "",
  "Toggle the background and foreground colors")
  ()
{
	check_xterm ();
	XFlipColor ();
	return Qt;
}

DEFUN ("x-set-foreground-color", Fx_set_foreground_color,
       Sx_set_foreground_color, 1, 1, "sSet foreground color:  ",
       "Set foreground (text) color to COLOR.")
  (arg)
     Lisp_Object arg;
{
	XColor cdef;
	BLOCK_INPUT_DECLARE ();
	char *save_color;
	unsigned long save;

	save_color = fore_color;
	save = fore;
	check_xterm ();
	CHECK_STRING (arg,1);
	fore_color = (char *) xmalloc (XSTRING (arg)->size + 1);
	bcopy (XSTRING (arg)->data, fore_color, XSTRING (arg)->size + 1);

	BLOCK_INPUT ();

	if (fore_color && XXisColor &&
	    XParseColor (XXdisplay, XXColorMap, fore_color, &cdef) &&
	    XAllocColor(XXdisplay, XXColorMap, &cdef))
	  fore = cdef.pixel;
	else if (fore_color && !strcmp (fore_color, "white"))
	  fore = WhitePixel (XXdisplay, XXscreen), fore_color = white_color;
	else if (fore_color && !strcmp (fore_color, "black"))
	  fore = BlackPixel (XXdisplay, XXscreen), fore_color = black_color;
	else
	  fore_color = save_color;

	/* Now free the old background color
	   if it was specially allocated and we are not still using it.  */
	if (save_color != white_color && save_color != black_color
	    && save_color != fore_color)
	  {
	    XFreeColors (XXdisplay, XXColorMap, &save, 1, 0);
	    free (save_color);
	  }

	XSetForeground(XXdisplay, XXgc_norm, fore);
	XSetBackground(XXdisplay, XXgc_rev, fore);
	
	Fredraw_display ();
	UNBLOCK_INPUT ();

	XFlush (XXdisplay);
	return Qt;
}

DEFUN ("x-set-background-color", Fx_set_background_color,
       Sx_set_background_color, 1, 1, "sSet background color: ",
       "Set background color to COLOR.")
  (arg)
     Lisp_Object arg;
{
	XColor cdef;
	BLOCK_INPUT_DECLARE ();
	char *save_color;
	unsigned long save;

	check_xterm ();
	CHECK_STRING (arg,1);
	save_color = back_color;
	save = back;
	back_color = (char *) xmalloc (XSTRING (arg)->size + 1);
	bcopy (XSTRING (arg)->data, back_color, XSTRING (arg)->size + 1);

	BLOCK_INPUT ();

	if (back_color && XXisColor &&
	    XParseColor (XXdisplay, XXColorMap, back_color, &cdef) &&
	    XAllocColor(XXdisplay, XXColorMap, &cdef))
	  back = cdef.pixel;
	else if (back_color && !strcmp (back_color, "white"))
	  back = WhitePixel (XXdisplay, XXscreen), back_color = white_color;
	else if (back_color && !strcmp (back_color, "black"))
	  back = BlackPixel (XXdisplay, XXscreen), back_color = black_color;
	else
	  back_color = save_color;

	/* Now free the old background color
	   if it was specially allocated and we are not still using it.  */
	if (save_color != white_color && save_color != black_color
	    && save_color != back_color)
	  {
	    XFreeColors (XXdisplay, XXColorMap, &save, 1, 0);
	    free (save_color);
	  }

	XSetBackground (XXdisplay, XXgc_norm, back);
	XSetForeground (XXdisplay, XXgc_rev, back);
	XSetForeground (XXdisplay, XXgc_curs, back);
	XSetBackground (XXdisplay, XXgc_curs_rev, back);
	XSetWindowBackground(XXdisplay, XXwindow, back);
	XClearArea (XXdisplay, XXwindow, 0, 0,
		    screen_width*XXfontw+2*XXInternalBorder,
		    screen_height*XXfonth+2*XXInternalBorder, 0);
	
	UNBLOCK_INPUT ();
	Fredraw_display ();

	XFlush (XXdisplay);
	return Qt;
}

DEFUN ("x-set-border-color", Fx_set_border_color, Sx_set_border_color, 1, 1,
       "sSet border color: ",
       "Set border color to COLOR.")
  (arg)
     Lisp_Object arg;
{
	XColor cdef;
	BLOCK_INPUT_DECLARE ();
	unsigned long save;
	char *save_color;

	check_xterm ();
	CHECK_STRING (arg,1);
	brdr_color= (char *) xmalloc (XSTRING (arg)->size + 1);
	save = brdr;
	save_color = brdr_color;
	bcopy (XSTRING (arg)->data, brdr_color, XSTRING (arg)->size + 1);

	BLOCK_INPUT ();

	if (brdr_color && XXisColor &&
	    XParseColor (XXdisplay, XXColorMap, brdr_color, &cdef) &&
	    XAllocColor(XXdisplay, XXColorMap, &cdef))
	  brdr = cdef.pixel;
	else
	  {
	    if (brdr_color && !strcmp (brdr_color, "black"))
	      {
		brdr = BlackPixel (XXdisplay, XXscreen);
		brdr_color = black_color;
	      }
	    else
	      if (brdr_color && !strcmp (brdr_color, "white"))
		{
		  brdr = WhitePixel (XXdisplay, XXscreen);
		  brdr_color = white_color;
		}
	      else {
		brdr_color = black_color;
		brdr = BlackPixel (XXdisplay, XXscreen);
	      }
	  }

	/* Now free the old background color
	   if it was specially allocated and we are not still using it.  */
	if (save_color != white_color && save_color != black_color
	    && save_color != brdr_color)
	  {
	    XFreeColors (XXdisplay, XXColorMap, &save, 1, 0);
	    free (save_color);
	  }

	if (XXborder) {
		XSetWindowBorder(XXdisplay, XXwindow, brdr);
		XFlush (XXdisplay);
	}
	
	UNBLOCK_INPUT ();

	return Qt;
}

DEFUN ("x-set-cursor-color", Fx_set_cursor_color, Sx_set_cursor_color, 1, 1,
       "sSet text cursor color: ",
       "Set text cursor color to COLOR.")
  (arg)
     Lisp_Object arg;
{
	XColor cdef;
	BLOCK_INPUT_DECLARE ();
	char *save_color;
	unsigned long save;

	check_xterm ();
	CHECK_STRING (arg,1);
	save_color = curs_color;
	save = curs;
	curs_color = (char *) xmalloc (XSTRING (arg)->size + 1);
	bcopy (XSTRING (arg)->data, curs_color, XSTRING (arg)->size + 1);

	BLOCK_INPUT ();

	if (curs_color && XXisColor &&
	    XParseColor (XXdisplay, XXColorMap, curs_color, &cdef) &&
	    XAllocColor(XXdisplay, XXColorMap, &cdef))
	  curs = cdef.pixel;
	else if (curs_color && !strcmp (curs_color, "white"))
	  curs = WhitePixel (XXdisplay, XXscreen), curs_color = white_color;
	else if (curs_color && !strcmp (curs_color, "black"))
	  curs = BlackPixel (XXdisplay, XXscreen), curs_color = black_color;
	else
	  curs_color = save_color;

	/* Now free the old background color
	   if it was specially allocated and we are not still using it.  */
	if (save_color != white_color && save_color != black_color
	    && save_color != curs_color)
	  {
	    XFreeColors (XXdisplay, XXColorMap, &save, 1, 0);
	    free (save_color);
	  }

	XSetBackground(XXdisplay, XXgc_curs, curs);
	XSetForeground(XXdisplay, XXgc_curs_rev, curs);
	
	CursorToggle ();
	CursorToggle ();

	UNBLOCK_INPUT ();
	return Qt;
}

DEFUN ("x-set-mouse-color", Fx_set_mouse_color, Sx_set_mouse_color, 1, 1,
       "sSet mouse cursor color: ",
       "Set mouse cursor color to COLOR.")
  (arg)
     Lisp_Object arg;
{
  BLOCK_INPUT_DECLARE ();
  char *save_color;

  check_xterm ();
  CHECK_STRING (arg,1);
  save_color = mous_color;
  mous_color = (char *) xmalloc (XSTRING (arg)->size + 1);
  bcopy (XSTRING (arg)->data, mous_color, XSTRING (arg)->size + 1);

  BLOCK_INPUT ();

  if (! x_set_cursor_colors ())
    mous_color = save_color;
  else if (save_color != white_color && save_color != black_color
	   && save_color != mous_color)
    free (save_color);

  XFlush (XXdisplay);
	
  UNBLOCK_INPUT ();
  return Qt;
}   

/* Set the actual X cursor colors from `mous_color' and `back_color'.  */

int
x_set_cursor_colors ()
{
  XColor forec, backc;

  char	 *useback;

  /* USEBACK is the background color, but on monochrome screens
     changed if necessary not to match the mouse.  */

  useback = back_color;

  if (!XXisColor && !strcmp (mous_color, back_color))
    {
      if (strcmp (back_color, "white"))
	useback = white_color;
      else
	useback = black_color;
    }

  if (XXisColor && mous_color
      && XParseColor (XXdisplay, XXColorMap, mous_color, &forec)
      && XParseColor (XXdisplay, XXColorMap, useback, &backc))
    {
      XRecolorCursor (XXdisplay, EmacsCursor, &forec, &backc);
      return 1;
    }
  else return 0;
}

DEFUN ("x-color-p", Fx_color_p, Sx_color_p, 0, 0, 0,
       "Returns t if the display is a color X terminal.")
  ()
{
	check_xterm ();

	if (XXisColor)
		return Qt;
	else
		return Qnil;
}
	
DEFUN ("x-get-foreground-color", Fx_get_foreground_color,
       Sx_get_foreground_color, 0, 0, 0,
       "Returns the color of the foreground, as a string.")
  ()
{
	Lisp_Object string;

	check_xterm ();
	string = build_string (fore_color);
	return string;
}

DEFUN ("x-get-background-color", Fx_get_background_color,
       Sx_get_background_color, 0, 0, 0,
       "Returns the color of the background, as a string.")
  ()
{
	Lisp_Object string;

	check_xterm ();
	string = build_string (back_color);
	return string;
}

DEFUN ("x-get-border-color", Fx_get_border_color,
       Sx_get_border_color, 0, 0, 0,
       "Returns the color of the border, as a string.")
  ()
{
	Lisp_Object string;

	check_xterm ();
	string = build_string (brdr_color);
	return string;
}

DEFUN ("x-get-cursor-color", Fx_get_cursor_color,
       Sx_get_cursor_color, 0, 0, 0,
       "Returns the color of the cursor, as a string.")
  ()
{
	Lisp_Object string;

	check_xterm ();
	string = build_string (curs_color);
	return string;
}

DEFUN ("x-get-mouse-color", Fx_get_mouse_color,
       Sx_get_mouse_color, 0, 0, 0,
       "Returns the color of the mouse cursor, as a string.")
  ()
{
	Lisp_Object string;

	check_xterm ();
	string = build_string (mous_color);
	return string;
}

DEFUN ("x-get-default", Fx_get_default, Sx_get_default, 1, 1, 0,
       "Get default for X-window attribute ATTRIBUTE from the system.\n\
ATTRIBUTE must be a string.\n\
Returns nil if attribute default isn't specified.")
  (arg)
     Lisp_Object arg;
{
	char *default_name, *value;

	check_xterm ();
	CHECK_STRING (arg, 1);
	default_name = (char *) XSTRING (arg)->data;

#ifdef XBACKWARDS
	/* Some versions of X11R4, at least, have the args backwards.  */
	if (XXidentity && *XXidentity)
		value = XGetDefault (XXdisplay, default_name, XXidentity);
	else
		value = XGetDefault (XXdisplay, default_name, CLASS);
#else
	if (XXidentity && *XXidentity)
		value = XGetDefault (XXdisplay, XXidentity, default_name);
	else
		value = XGetDefault (XXdisplay, CLASS, default_name);
#endif
 	
	if (value)
		return build_string (value);
	return (Qnil);
}

DEFUN ("x-set-font", Fx_set_font, Sx_set_font, 1, 3, "sFont Name: \nP\nP",
      "Sets the font to be used for the X window.\n\
When called from a program, expects three arguments,\n\
 FONTNAME, LEADING-CHAR (0 or 0x81..0xFF), and ENCODING (0 or 1).\n\
LEADING-CHAR and ENCODING default to 0.\n\
Return t if the fonts is loaded successfully, else return nil.")
  (arg, leading_char, encoding)
     Lisp_Object arg, leading_char, encoding;
{
	register char *newfontname;
	register unsigned char lc, encode;
	
	CHECK_STRING (arg, 1);
	check_xterm ();

	newfontname = (char *) xmalloc (XSTRING (arg)->size + 1);
	bcopy (XSTRING (arg)->data, newfontname, XSTRING (arg)->size + 1);
	if (XSTRING (arg)->size == 0)
		goto badfont;

/* 92.9.7 by K.Handa */
	lc = XTYPE (leading_char) == Lisp_Int ? XFASTINT (leading_char) : 0;
	if (lc != 0 && (lc <= 0x80 || lc == 0x9F)) goto badfont;
	encode = XTYPE (encoding) == Lisp_Int ? XFASTINT (encoding) : 0;
	if (encode > 1) goto badfont;

	if (lc) {
	  if (!MCNewFont (newfontname, lc, XFASTINT (encoding)))
	    return Qt;
	} else
/* end of patch */
	if (!XNewFont (newfontname)) {
		/* 93.4.30 by Y.Kawabe
		free (XXcurrentfont);
		XXcurrentfont = newfontname;
		*/
		return Qt;
	}
      badfont:
	error ("Font \"%s\" is not defined", newfontname);
	free (newfontname);

	return Qnil;
}

/* 93.5.20 by K.Handa */
extern int ccl_program_idx;

DEFUN ("x-set-ccl", Fx_set_ccl, Sx_set_ccl, 2, 2, 0,
      "Sets to charset LC the CCL-PROGRAM.\n\
CCL-PROGMAM is used to convert a char of LC into the struct XChar2b.\n\
If CCL-PROGMAM is nill, unset any CCL program of LC.")
  (leading_char, ccl_prog)
     Lisp_Object leading_char, ccl_prog;
{
  int lc = XINT (leading_char);

  if (lc < 0 || (lc > 0 && lc < 0x81) || lc >= 0x100)
    error ("Invalid LEADING-CHAR (%d).", lc);
  if (!NULL (ccl_prog) && XTYPE (ccl_prog) != Lisp_String)
    error ("Invalid CCL program format.");
  XVECTOR (Vx_ccl_programs)->contents[lc & 0x7F] = ccl_prog;

  return Qnil;
}
/* end of patch */

/* 92.10.13, 92.12.10 by K.Handa */
DEFUN ("x-set-linespace", Fx_set_linespace, Sx_set_linespace, 1, 1,
       "sSet linespace (dots or above+below): ",
       "Set linespace.")
  (arg)
     Lisp_Object arg;
{
  int i1, i2;

  BLOCK_INPUT_DECLARE ();

  check_xterm ();
  CHECK_STRING (arg, 0);
  BLOCK_INPUT ();
  XFlush (XXdisplay);

  x_set_linespace(XSTRING (arg)->data); /* 92.12.10 by K.Handa */
  if (XXlinespacestr) free (XXlinespacestr);
  /* 94.2.24 by K.Handa */
  XXlinespacestr = (char *) xmalloc (XSTRING (arg)->size + 1);
  bcopy (XSTRING (arg)->data, XXlinespacestr, XSTRING (arg)->size + 1);

  XSetWindowSize(screen_height, screen_width);
  UNBLOCK_INPUT ();
  return Qt;
}

DEFUN ("x-get-fontinfo", Fx_get_fontinfo, Sx_get_fontinfo, 1, 1, 0,
       "Return font information for the character set LEADING-CHAR\n\
by a list of:\n\
  REQUESTED-NAME: Fontname specified for openining font.\n\
  OPENED-NAME: Fontname of the font actually opened.\n\
  OPENED: t if the font has already opened, else nil.")
  (leading_char)
     Lisp_Object leading_char;
{
  unsigned int lc;
  Lisp_Object requested_name = Qnil, opened_name = Qnil, opened = Qnil;

  check_xterm ();
  CHECK_NUMBER (leading_char, 0);
  lc = XFASTINT (leading_char) & 0x7F;
  if (!fonts[lc].name)
    x_set_fontname(lc);
  if (fonts[lc].name)
    requested_name = build_string (fonts[lc].name);
  if (fonts[lc].opened)
    opened_name = build_string (fonts[lc].opened);
  if (fonts[lc].fs)
    opened = Qt;
  return Fcons (requested_name, Fcons (opened_name, Fcons (opened, Qnil)));
}
/* end of patch */

DEFUN ("coordinates-in-window-p", Fcoordinates_in_window_p,
  Scoordinates_in_window_p, 2, 2, 0,
  "Return non-nil if POSITIONS (a list, (SCREEN-X SCREEN-Y)) is in WINDOW.\n\
Returned value is list of positions expressed\n\
relative to window upper left corner.")
  (coordinate, window)
     register Lisp_Object coordinate, window;
{
	register Lisp_Object xcoord, ycoord;
	int height;
	
	if (!CONSP (coordinate))
		wrong_type_argument (Qlistp, coordinate);

	CHECK_WINDOW (window, 2);
	xcoord = Fcar (coordinate);
	ycoord = Fcar (Fcdr (coordinate));
	CHECK_NUMBER (xcoord, 0);
	CHECK_NUMBER (ycoord, 1);
	if ((XINT (xcoord) < XINT (XWINDOW (window)->left)) ||
	    (XINT (xcoord) >= (XINT (XWINDOW (window)->left) +
			       XINT (XWINDOW (window)->width))))
		return Qnil;

	XFASTINT (xcoord) -= XFASTINT (XWINDOW (window)->left);

	height = XINT (XWINDOW (window)->height);

	if (window != minibuf_window)
	  height --;

	if ((XINT (ycoord) < XINT (XWINDOW (window)->top)) ||
	    (XINT (ycoord) >= XINT (XWINDOW (window)->top) + height))
	  return Qnil;

	XFASTINT (ycoord) -= XFASTINT (XWINDOW (window)->top);
	return Fcons (xcoord, Fcons (ycoord, Qnil));
}

DEFUN ("x-mouse-events", Fx_mouse_events, Sx_mouse_events, 0, 0, 0,
  "Return number of pending mouse events from X window system.")
  ()
{
	register Lisp_Object tem;

	check_xterm ();

	XSET (tem, Lisp_Int, XXm_queue_num);
	
	return tem;
}

DEFUN ("x-proc-mouse-event", Fx_proc_mouse_event, Sx_proc_mouse_event,
  0, 0, 0,
  "Pulls a mouse event out of the mouse event buffer and dispatches\n\
the appropriate function to act upon this event.")
  ()
{
	XEvent event;
	register Lisp_Object mouse_cmd;
	register char com_letter;
	register char key_mask;
	register Lisp_Object tempx;
	register Lisp_Object tempy;
	extern int meta_prefix_char;
	
	check_xterm ();

	if (XXm_queue_num) {
		event = *XXm_queue[XXm_queue_out];
		free (XXm_queue[XXm_queue_out]);
		XXm_queue_out = (XXm_queue_out + 1) % XMOUSEBUFSIZE;
		XXm_queue_num--;
		com_letter = 3-(event.xbutton.button & 3);
		key_mask = (event.xbutton.state & 15) << 4;
		/* Get rid of the shift-lock bit.  */
		key_mask &= ~0x20;
		/* Report meta in 2 bit, not in 8 bit.  */
		if (key_mask & 0x80)
		  {
		    key_mask |= 0x20;
		    key_mask &= ~0x80;
		  }
		com_letter |= key_mask;
		if (event.type == ButtonRelease)
			com_letter |= 0x04;
		XSET (tempx, Lisp_Int,
		      min (screen_width-1,
			   max (0, (event.xbutton.x-XXInternalBorder)/
				XXfontw)));
		XSET (tempy, Lisp_Int,
		      min (screen_height-1,
			   max (0, (event.xbutton.y-XXInternalBorder)/
				XXfonth)));
		Vx_mouse_pos = Fcons (tempx, Fcons (tempy, Qnil));
		XSET (tempx, Lisp_Int, event.xbutton.x_root);
		XSET (tempy, Lisp_Int, event.xbutton.y_root);
		Vx_mouse_abs_pos = Fcons (tempx, Fcons (tempy, Qnil));
		Vx_mouse_item = make_number (com_letter);
		mouse_cmd
		  = get_keyelt (access_keymap (MouseMap, com_letter));
		if (NULL (mouse_cmd)) {
			if (event.type != ButtonRelease)
				bell ();
			Vx_mouse_pos = Qnil;
		}
		else
			return call1 (mouse_cmd, Vx_mouse_pos);
	}
	return Qnil;
}

DEFUN ("x-get-mouse-event", Fx_get_mouse_event, Sx_get_mouse_event,
  1, 1, 0,
  "Get next mouse event out of mouse event buffer (com-letter (x y)).\n\
ARG non-nil means return nil immediately if no pending event;\n\
otherwise, wait for an event.")
  (arg)
     Lisp_Object arg;
{
	XEvent event;
	register char com_letter;
	register char key_mask;

	register Lisp_Object tempx;
	register Lisp_Object tempy;
	
	check_xterm ();

	if (NULL (arg))
		while (!XXm_queue_num)
		  {
		    consume_available_input ();
		    Fsleep_for (make_number (1));
		  }
	/*** ??? Surely you don't mean to busy wait??? */

	if (XXm_queue_num) {
		event = *XXm_queue[XXm_queue_out];
		free (XXm_queue[XXm_queue_out]);
		XXm_queue_out = (XXm_queue_out + 1) % XMOUSEBUFSIZE;
		XXm_queue_num--;
		com_letter = 3-(event.xbutton.button & 3);
		key_mask = (event.xbutton.state & 15) << 4;
		/* Report meta in 2 bit, not in 8 bit.  */
		if (key_mask & 0x80)
		  {
		    key_mask |= 0x20;
		    key_mask &= ~0x80;
		  }
		com_letter |= key_mask;
		if (event.type == ButtonRelease)
			com_letter |= 0x04;
		XSET (tempx, Lisp_Int,
		      min (screen_width-1,
			   max (0, (event.xbutton.x-XXInternalBorder)/
				XXfontw)));
		XSET (tempy, Lisp_Int,
		      min (screen_height-1,
			   max (0, (event.xbutton.y-XXInternalBorder)/
				XXfonth)));
		Vx_mouse_pos = Fcons (tempx, Fcons (tempy, Qnil));
		XSET (tempx, Lisp_Int, event.xbutton.x_root);
		XSET (tempy, Lisp_Int, event.xbutton.y_root);
		Vx_mouse_abs_pos = Fcons (tempx, Fcons (tempy, Qnil));
		Vx_mouse_item = make_number (com_letter);
		return Fcons (com_letter, Fcons (Vx_mouse_pos, Qnil));
	}
	return Qnil;
}

DEFUN ("x-store-cut-buffer", Fx_store_cut_buffer, Sx_store_cut_buffer,
  1, 1, "sSend string to X:",
  "Store contents of STRING into the cut buffer of the X window system.")
  (string)
     register Lisp_Object string;
{
	BLOCK_INPUT_DECLARE ();

	CHECK_STRING (string, 1);
	check_xterm ();

	BLOCK_INPUT ();
	XStoreBytes (XXdisplay, (char *) XSTRING (string)->data,
		     XSTRING (string)->size);
	/* Clear the selection owner, so that other applications
	   will use the cut buffer rather than a selection.  */
        XSetSelectionOwner (XXdisplay, XA_PRIMARY, None, CurrentTime);
	UNBLOCK_INPUT ();

	return Qnil;
}

DEFUN ("x-get-cut-buffer", Fx_get_cut_buffer, Sx_get_cut_buffer, 0, 0, 0,
  "Return contents of cut buffer of the X window system, as a string.")
  ()
{
	int len;
	register Lisp_Object string;
	BLOCK_INPUT_DECLARE ();
	register char *d;

	check_xterm ();
	BLOCK_INPUT ();
	d = XFetchBytes (XXdisplay, &len);
	string = make_string (d, len);
	UNBLOCK_INPUT ();

	return string;
}

#ifdef HAVE_X_SELECTION

/*
 * Atom Cache
 */

/* 92.7.30 by Y.Kawabe */
#define DEFATOM(FUNC,NAME,ATOM)						\
static	Atom	ATOM;						\
Atom FUNC () {								\
	if (ATOM == 0) ATOM = XInternAtom (XXdisplay, NAME, False);	\
	return ATOM;							\
}

DEFATOM (XA_CLASS,"CLASS",xa_class_atom)
DEFATOM (XA_COMPOUND_TEXT,"COMPOUND_TEXT",xa_ctext_atom)
DEFATOM (XA_HOSTNAME,"HOSTNAME",xa_hostname_atom)
DEFATOM (XA_LIST_LENGTH,"LIST_LENGTH",xa_length_atom)
DEFATOM (XA_NAME,"NAME",xa_name_atom)
DEFATOM (XA_TEXT,"TEXT",xa_text_atom)
DEFATOM (XA_TARGETS,"TARGETS",xa_targets_atom)
/* end of patch */

/*
 * Selection Table
 */

typedef struct _SelectionTable {
	Atom				atom;
	Lisp_Object 			data;
	Bool				escp;
	struct _SelectionTable		*next;
} SelectionTable ;

static  SelectionTable	*x_selection_table;
Lisp_Object		Qx_selection_table;

SelectionTable* FindSelectionTableByName (name, only_of_exist)
	register Lisp_Object name;
	Bool only_of_exist;
{
	char			*p;
	SelectionTable		*table;
	Atom			atom;

	/* Find Table */
	for (table = x_selection_table; table; table = table->next) {
		register Lisp_Object name2 = XCONS (table->data)->car;
		if ((XSTRING (name)->size == XSTRING (name2)->size) &&
		    bcmp (XSTRING (name)->data, XSTRING (name2)->data,
			  XSTRING (name)->size) == 0) {
			return table;
		}
	}
	
	if (only_of_exist) return (SelectionTable*) 0;
	
	/* Intern Atom */
	p = (char*) xmalloc (XSTRING (name)->size + 1);
	if (p == 0) return (SelectionTable*) 0;
	strncpy(p, (char *) XSTRING (name)->data, XSTRING (name)->size);
	p[XSTRING (name)->size] = '\0';
	atom = XInternAtom (XXdisplay, p, False);
	free(p);

	/* Create Table */
	table = (SelectionTable *) xmalloc(sizeof(SelectionTable));
	if (table == 0) return (SelectionTable*) 0;

	table->atom = atom;
	table->data = Fcons(name, Qnil);
	table->next = x_selection_table;
	x_selection_table = table;

	/* protect GC */
	Qx_selection_table = Fcons(table->data, Qx_selection_table);

	return table;
}

SelectionTable* FindSelectionTableByAtom (atom, only_of_exist)
	register Atom atom;
	Bool only_of_exist;
{
	char			*p;
	SelectionTable		*table;
	Lisp_Object		name;
	
	/* Find Table */
	for (table = x_selection_table; table; table = table->next) {
		if (table->atom == atom) {
			return table;
		}
	}
	if (only_of_exist) return (SelectionTable*) 0;
	
	/* Get Atom Name */
	p = XGetAtomName(XXdisplay, atom);
	if (p == 0) return (SelectionTable*) 0;
	name = make_string(p, strlen(p));
	XFree(p);
	
	/* Create Table */
	table = (SelectionTable *) xmalloc(sizeof(SelectionTable));
	if (table == 0) return (SelectionTable*) 0;

	table->atom = atom;
	table->data = Fcons(name, Qnil);
	table->next = x_selection_table;
	x_selection_table = table;

	/* protect GC */
	Qx_selection_table = Fcons(table->data, Qx_selection_table);

	return table;
}


DEFUN ("x-store-compound-text", Fx_store_compound_text, Sx_store_compound_text,
       2, 2, 0, "Store TEXT in a particular SELECTION.")
	(text, selection)
	register Lisp_Object text;
	register Lisp_Object selection;
{
	SelectionTable		*table;
	Lisp_Object		name;
	int			i;
	char			*p;
	BLOCK_INPUT_DECLARE ();

	check_xterm ();
	CHECK_STRING (text, 1);
	CHECK_SYMBOL (selection, 2);
	BLOCK_INPUT ();
	
	XSET (name, Lisp_String, XSYMBOL (selection)->name);
	table = FindSelectionTableByName (name, False);
	if (!table) {
		UNBLOCK_INPUT ();
		return Qnil;
	}
	XCONS (table->data)->cdr = text;
	table->escp = False;

	/* check escape character in text */
	p = (char*) XSTRING (text)->data;
	for (i = 0; i < XSTRING (text)->size; i++) {
		if (p[i] == 033) {
			table->escp = True;
			break;
		}
	}
	
	/* Acquire Selection Ownership */
	XSetSelectionOwner(XXdisplay, table->atom, XXwindow, CurrentTime);
	XFlush (XXdisplay);	/* 92.6.14 by Y.Kawabe */
	UNBLOCK_INPUT ();
	return Qt;
}

#ifdef HAVE_SELECT
#ifdef FD_SET
#define		MAXDESC 64
#define		SELECT_TYPE fd_set
#else /* FD_SET */
#define		MAXDESC 32
#define		SELECT_TYPE int
#define		FD_SET(n, p) (*(p) |= (1 << (n)))
#define		FD_ZERO(p) (*(p) = 0)
#endif /* FD_SET */
#endif /* HAVE_SELECT */

Lisp_Object XWaitRequestSelection()
{
	int			timeout = 10;
	Lisp_Object		text = Qnil;
	XEvent			event;
#ifdef HAVE_SELECT
	SELECT_TYPE		input_mask;
	struct timeval		howlong;
	int			result;
#endif

	while (timeout > 0) {
		
		if (XCheckTypedWindowEvent(XXdisplay, XXwindow, 
					   SelectionNotify, &event)){
			
			Atom			type;
			unsigned long 		nitems;
			unsigned long 		after;
			int	 		format;
			unsigned char*		prop;
			
			if (event.xselection.property == None) {
				break;
			}
			
			if (XGetWindowProperty(XXdisplay,
					       event.xselection.requestor, 
					       event.xselection.property,
					       0L, 102400L,
					       True, AnyPropertyType,
					       &type, &format, &nitems,
					       &after, &prop) != Success) {
				break;
			}
			if (format == 8) {
				text = make_string((char*)prop, nitems);
				XFree((void *)prop);
				break;
			}
			break;
		}
#ifdef HAVE_SELECT
		FD_ZERO(&input_mask);
		FD_SET(ConnectionNumber(XXdisplay), &input_mask);
		howlong.tv_sec = timeout--;
		howlong.tv_usec = 0;
		result = select(MAXDESC, &input_mask, (SELECT_TYPE *)0,
			   	(SELECT_TYPE *)0, &howlong);
		if (result == -1 || result == 0) {
			break;
		}
#else /* HAVE_SELECT */
		sleep(1);
		timeout--;
#endif /* HAVE_SELECT */
	}
	return text;
}

/* 92.12.16 by A.Furuta */
DEFUN ("x-get-compound-text", Fx_get_compound_text, Sx_get_compound_text,
       1, 1, 0, "Obtain text of a particular SELECTION.")
	(selection)
	register Lisp_Object selection;
{
	BLOCK_INPUT_DECLARE ();
	SelectionTable		*table;
	Lisp_Object		text;
	Lisp_Object		name;
	
	check_xterm ();
	CHECK_SYMBOL (selection, 1);
	BLOCK_INPUT ();
	
	XSET (name, Lisp_String, XSYMBOL (selection)->name);
	table = FindSelectionTableByName (name, False);
	if (!table) {
		UNBLOCK_INPUT ();
		return make_string(0, 0);
	}
	if (!NULL(XCONS (table->data)->cdr)) {
		UNBLOCK_INPUT ();
		return XCONS (table->data)->cdr;
	}
	XConvertSelection(XXdisplay, table->atom, XA_TEXT(), XA_TEXT(), 
			  XXwindow, CurrentTime);
	text = XWaitRequestSelection();

	if (NULL (text)) {
		XConvertSelection(XXdisplay, table->atom,
				  XA_STRING, XA_STRING, XXwindow, CurrentTime);
		text = XWaitRequestSelection();
		UNBLOCK_INPUT ();
		if (NULL (text)) return make_string(0, 0);
	}
	UNBLOCK_INPUT ();
	return text;
}
/* end of patch */

void HandleSelectionClear(event)
	XEvent *event;
{
	SelectionTable	*table;
	table = FindSelectionTableByAtom (event->xselectionclear.selection,
					  True);
	if (table) { XCONS (table->data)->cdr = Qnil; }
}

void HandleSelectionRequest(event)
	XEvent *event;
{
	XEvent		 notify;
	SelectionTable	*table;
	
	table = FindSelectionTableByAtom (event->xselectionrequest.selection,
					  True);
	if (!table) goto fail;
	
	if (event->xselectionrequest.target == XA_STRING) {
		register Lisp_Object text = XCONS (table->data)->cdr;
		if (NULL(text) || table->escp) goto fail;
		XChangeProperty (XXdisplay, 
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 XA_STRING, 8, PropModeReplace,
				 (unsigned char *) XSTRING (text)->data,
				 XSTRING (text)->size);
		goto success;
	} else if (event->xselectionrequest.target == XA_TEXT()) {
		register Lisp_Object text = XCONS (table->data)->cdr;
		Atom atom = (table->escp) ?  XA_COMPOUND_TEXT() : XA_STRING;
		if (NULL(text)) goto fail;
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 atom, 8, PropModeReplace,
				 (unsigned char *) XSTRING (text)->data,
				 XSTRING (text)->size);
		goto success;
	} else if (event->xselectionrequest.target == XA_COMPOUND_TEXT()) {
		register Lisp_Object text = XCONS (table->data)->cdr;
		if (NULL(text)) goto fail;
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 event->xselectionrequest.target,
				 8, PropModeReplace,
				 (unsigned char *) XSTRING (text)->data,
				 XSTRING (text)->size);
		goto success;
	} else if (event->xselectionrequest.target == XA_TARGETS()) {
		int i = 0;
		Atom targets[10];
		register Lisp_Object text = XCONS (table->data)->cdr;
		
		if (!NULL(text)) {
			targets[i++] = XA_TEXT();
			targets[i++] = XA_COMPOUND_TEXT();
			if (table->escp) targets[i++] = XA_STRING;
		}
		targets[i++] = XA_LIST_LENGTH();
		targets[i++] = XA_HOSTNAME();
		targets[i++] = XA_CLASS();
		targets[i++] = XA_NAME();
		
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 XA_ATOM, 32, PropModeReplace,
				 (unsigned char*) targets, i);
		goto success;
        } else if (event->xselectionrequest.target == XA_LIST_LENGTH()) {
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property, 
				 XA_INTEGER, 32, PropModeReplace,
				 (unsigned char*) 1L, 1);
		goto success;
        } else if (event->xselectionrequest.target == XA_HOSTNAME()) {
		char* name = (char*) get_system_name ();
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 XA_STRING, 8, PropModeReplace,
				 (unsigned char *) name, 
				 name ? strlen(name) : 0);
		goto success;
        } else if (event->xselectionrequest.target == XA_CLASS()) {
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 XA_STRING, 8, PropModeReplace,
				 (unsigned char *) CLASS, strlen(CLASS));
		goto success;
        } else if (event->xselectionrequest.target == XA_NAME()) {
		XChangeProperty (XXdisplay,
				 event->xselectionrequest.requestor,
				 event->xselectionrequest.property,
				 XA_STRING, 8, PropModeReplace,
				 (unsigned char *) XXidentity,
				 XXidentity ? strlen(XXidentity) : 0);
		goto success;
        } else {
		goto fail;
        }
	
 fail:
	notify.xselection.type = SelectionNotify;
	notify.xselection.display = event->xselectionrequest.display;
	notify.xselection.requestor = event->xselectionrequest.requestor;
	notify.xselection.selection = event->xselectionrequest.selection;
	notify.xselection.target = event->xselectionrequest.target;
	notify.xselection.property = None;
	notify.xselection.time = event->xselectionrequest.time;
	XSendEvent(event->xselectionrequest.display,
		   event->xselectionrequest.requestor,
		   False, 0L, &notify);
	XFlush(XXdisplay);
	return;
	
 success:
	notify.xselection.type = SelectionNotify;
	notify.xselection.display = event->xselectionrequest.display;
	notify.xselection.requestor = event->xselectionrequest.requestor;
	notify.xselection.selection = event->xselectionrequest.selection;
	notify.xselection.target = event->xselectionrequest.target;
	notify.xselection.time = event->xselectionrequest.time;
	if (event->xselectionrequest.property == None) {
		notify.xselection.property = event->xselectionrequest.target;
	} else {
		notify.xselection.property = event->xselectionrequest.property;
	}
	XSendEvent(event->xselectionrequest.display,
		   event->xselectionrequest.requestor,
		   False, 0L, &notify);
	XFlush(XXdisplay);
	return;
}

#endif /* HAVE_X_SELECTION */

DEFUN ("x-set-border-width", Fx_set_border_width, Sx_set_border_width,
  1, 1, "nBorder width: ",
  "Set width of border to WIDTH, in the X window system.")
  (borderwidth)
     register Lisp_Object borderwidth;
{
	BLOCK_INPUT_DECLARE ();

	CHECK_NUMBER (borderwidth, 0);

	check_xterm ();
  
	if (XINT (borderwidth) < 0)
		XSETINT (borderwidth, 0);
  
	BLOCK_INPUT ();
	XSetWindowBorderWidth(XXdisplay, XXwindow, XINT(borderwidth));
	XFlush(XXdisplay);
	UNBLOCK_INPUT ();

	return Qt;
}


DEFUN ("x-set-internal-border-width", Fx_set_internal_border_width,
       Sx_set_internal_border_width, 1, 1, "nInternal border width: ",
  "Set width of internal border to WIDTH, in the X window system.")
  (internalborderwidth)
     register Lisp_Object internalborderwidth;
{
	BLOCK_INPUT_DECLARE ();

	CHECK_NUMBER (internalborderwidth, 0);

	check_xterm ();
  
	if (XINT (internalborderwidth) < 0)
		XSETINT (internalborderwidth, 0);

	BLOCK_INPUT ();
	XXInternalBorder = XINT(internalborderwidth);
	XSetWindowSize(screen_height,screen_width);
	UNBLOCK_INPUT ();

	return Qt;
}

#ifdef foobar
DEFUN ("x-rebind-key", Fx_rebind_key, Sx_rebind_key, 3, 3, 0,
  "Rebind KEYCODE, with shift bits SHIFT-MASK, to new string NEWSTRING.\n\
KEYCODE and SHIFT-MASK should be numbers representing the X keyboard code\n\
and shift mask respectively.  NEWSTRING is an arbitrary string of keystrokes.\n\
If SHIFT-MASK is nil, then KEYCODE's key will be bound to NEWSTRING for\n\
all shift combinations.\n\
Shift Lock  1	   Shift    2\n\
Meta	    4	   Control  8\n\
\n\
For values of KEYCODE, see /usr/lib/Xkeymap.txt (remember that the codes\n\
in that file are in octal!)\n")

  (keycode, shift_mask, newstring)
     register Lisp_Object keycode;
     register Lisp_Object shift_mask;
     register Lisp_Object newstring;
{
#ifdef notdef
	char *rawstring;
	int rawkey, rawshift;
	int i;
	int strsize;

	CHECK_NUMBER (keycode, 1);
	if (!NULL (shift_mask))
		CHECK_NUMBER (shift_mask, 2);
	CHECK_STRING (newstring, 3);
	strsize = XSTRING (newstring) ->size;
	rawstring = (char *) xmalloc (strsize);
	bcopy (XSTRING (newstring)->data, rawstring, strsize);
	rawkey = ((unsigned) (XINT (keycode))) & 255;
	if (NULL (shift_mask))
		for (i = 0; i <= 15; i++)
			XRebindCode (rawkey, i<<11, rawstring, strsize);
	else
	{
		rawshift = (((unsigned) (XINT (shift_mask))) & 15) << 11;
		XRebindCode (rawkey, rawshift, rawstring, strsize);
	}
#endif /* notdef */
	return Qnil;
}
  
DEFUN ("x-rebind-keys", Fx_rebind_keys, Sx_rebind_keys, 2, 2, 0,
  "Rebind KEYCODE to list of strings STRINGS.\n\
STRINGS should be a list of 16 elements, one for each all shift combination.\n\
nil as element means don't change.\n\
See the documentation of x-rebind-key for more information.")
  (keycode, strings)
     register Lisp_Object keycode;
     register Lisp_Object strings;
{
#ifdef notdef
	register Lisp_Object item;
	register char *rawstring;
	int rawkey, strsize;
	register unsigned i;

	CHECK_NUMBER (keycode, 1);
	CHECK_CONS (strings, 2);
	rawkey = ((unsigned) (XINT (keycode))) & 255;
	for (i = 0; i <= 15; strings = Fcdr (strings), i++)
	{
		item = Fcar (strings);
		if (!NULL (item))
		{
			CHECK_STRING (item, 2);
			strsize = XSTRING (item)->size;
			rawstring = (char *) xmalloc (strsize);
			bcopy (XSTRING (item)->data, rawstring, strsize);
			XRebindCode (rawkey, i << 11, rawstring, strsize);
		}
	}
#endif /* notdef */
	return Qnil;
}

#endif /* foobar */

XExitWithCoreDump ()
{
	XCleanUp ();
	abort ();
}

DEFUN ("x-debug", Fx_debug, Sx_debug, 1, 1, 0,
  "ARG non-nil means that X errors should generate a coredump.")
  (arg)
     register Lisp_Object arg;
{
	int (*handler)();

	check_xterm ();
	if (!NULL (arg))
		handler = XExitWithCoreDump;
	else
	{
		extern int XIgnoreError ();
		handler = XIgnoreError;
	}
	XSetErrorHandler(handler);
	XSetIOErrorHandler(handler);
	return (Qnil);
}

XRedrawDisplay ()
{
	Fredraw_display ();
}

XCleanUp ()
{
	Fdo_auto_save (Qt);

#ifdef subprocesses
	kill_buffer_processes (Qnil);
#endif				/* subprocesses */
}

syms_of_xfns ()
{
  /* If not dumping, init_display ran before us, so don't override it.  */
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    Vxterm = Qnil;

  DEFVAR_LISP ("x-mouse-item", &Vx_mouse_item,
	       "Encoded representation of last mouse click, corresponding to\n\
numerical entries in x-mouse-map.");
  Vx_mouse_item = Qnil;
  DEFVAR_LISP ("x-mouse-pos", &Vx_mouse_pos,
	       "Current x-y position of mouse by row, column as specified by font.");
  Vx_mouse_pos = Qnil;
  DEFVAR_LISP ("x-mouse-abs-pos", &Vx_mouse_abs_pos,
	       "Current x-y position of mouse relative to root window.");
  Vx_mouse_abs_pos = Qnil;

/* 93.4.11 by K.Handa */
  DEFVAR_BOOL ("x-horizontal-bold-style", &x_horizontal_bold_style,
    "*T means show bold characters by drawing twice shifting one pixel right.\n\
If not T, show bold characters by drawing twice shifting one pixel up.");
  x_horizontal_bold_style = 0;
/* end of patch */

#ifdef HAVE_X_SELECTION
  staticpro (&Qx_selection_table);
  Qx_selection_table = Qnil;
#endif

/* 93.5.20 by K.Handa */
  staticpro (&Vx_ccl_programs);
  Vx_ccl_programs = Fmake_vector (128, Qnil);

  DEFVAR_LISP ("x-default-fonts", &Vx_default_fonts,
    "Vector of default fonts of each character set.\n\
The length is 128 and each element is indexed by (leading-char & 0x7F).");
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    Vx_default_fonts = Fmake_vector (128, Qnil);

  DEFVAR_LISP ("x-default-encoding", &Vx_default_encoding,
    "Vector of default font-encoding of each character set.\n\
The length is 128 and each element is indexed by (leading-char & 0x7F).");
#ifdef CANNOT_DUMP
  if (noninteractive)
#endif
    Vx_default_encoding = Fmake_vector (128, Qnil);

  defsubr (&Sx_set_linespace);
  defsubr (&Sx_get_fontinfo);	/* 92.12.10 by K.Handa */
/* end of patch */

  defsubr (&Sx_set_bell);
  defsubr (&Sx_flip_color);
  defsubr (&Sx_set_font);
#ifdef notdef
  defsubr (&Sx_set_icon);
#endif
  defsubr (&Scoordinates_in_window_p);
  defsubr (&Sx_mouse_events);
  defsubr (&Sx_proc_mouse_event);
  defsubr (&Sx_get_mouse_event);
  defsubr (&Sx_store_cut_buffer);
  defsubr (&Sx_get_cut_buffer);
#ifdef HAVE_X_SELECTION
  defsubr (&Sx_store_compound_text);
  defsubr (&Sx_get_compound_text);
#endif
  defsubr (&Sx_set_border_width);
  defsubr (&Sx_set_internal_border_width);
  defsubr (&Sx_set_foreground_color);
  defsubr (&Sx_set_background_color);
  defsubr (&Sx_set_border_color);
  defsubr (&Sx_set_cursor_color);
  defsubr (&Sx_set_mouse_color);
  defsubr (&Sx_get_foreground_color);
  defsubr (&Sx_get_background_color);
  defsubr (&Sx_get_border_color);
  defsubr (&Sx_get_cursor_color);
  defsubr (&Sx_get_mouse_color);
  defsubr (&Sx_color_p);
  defsubr (&Sx_get_default);
#ifdef notdef
  defsubr (&Sx_rebind_key);
  defsubr (&Sx_rebind_keys);
#endif
  defsubr (&Sx_debug);
  defsubr (&Sx_set_ccl);	/* 93.5.20 by K.Handa */
}

#endif /* HAVE_X_WINDOWS */

