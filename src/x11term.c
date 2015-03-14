/* X Communication module for terminals which understand the X protocol.
   Copyright (C) 1988, 1990 Free Software Foundation, Inc.

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

/*          modified for Nemacs Ver.2.1 by A.Kato */
/* 89.3.13  modified for Nemacs Ver.3.0 by K.Handa */
/* 89.11.24 modified for attribute of characters by K.Handa */
/* 89.12.12 modified for Nemacs Ver.3.2.1 by K.Handa
	- GR encoded Japanese fonts (MSB=1) can be used.
	- Calculation of width and height of fonts are changed.
	- Underline is drawn by GXcopy or GXcopyInverted. */
/* 89.12.15 modified for Nemacs Ver.3.2.1 by T.Hasei */
/* 89.12.19 modified for Nemacs Ver.3.2.3 by K.Handa
	- Underline is drawn by GXset or GXclear. */
/* 90.3.26  modified for Nemacs Ver.3.3.2 by Ishisone
	- GC for underline is changed. */
/* 91.11.28 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.19  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
	- Handle color of cursor correctly. */
/* 92.3.21  modified for Mule Ver.0.9.1 by T.Sakakibara <tomo@axis.co.jp>
	- In MCSetFontSize(), work is declared as 'static char'. */
/* 92.3.25  modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	- In MCDrawText(), clear sticking-out char of bold face. */
/* 92.4.8   modified for Mule Ver.0.9.3 by M.Ishisone <ishisone@sra.co.jp>
	- Big change to decide appropriate fontsize.
	- Default fontsize is now changed to 16... but i prefer 24... :-p */
/* 92.4.16  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	- In internal_socket_read(), octal notation \033 is used instead of
	  embedding real ESC code in a string. */
/* 92.4.27  modified for Mule Ver.0.9.4 by K.Kawabe <kawabe@sra.co.jp>
	- default_encoding[] is declared as static. */
/* 92.5.21  modified for Mule Ver.0.9.4 by K.Kawabe <kawabe@sra.co.jp>
	- Selection event is handled if HAVE_X_SELECTION is defined. */
/* 92.6.27  modified for Mule Ver.0.9.5 by A.Tanaka <aries@isl.melco.co.jp>
	- 'work' in MCSetFontSize() is declared outside.
/* 92.7.18  modified for Mule Ver.0.9.5 by Y.Niibe <gniibe@mri.co.jp>
	- Mistype in xDefaultsValueTable) corrected.  fonthwb -> fonthbw
/* 92.7.30  modified for Mule Ver.0.9.5
			by I.Hirakura <hir@necbs6.uxp.bs2.mt.nec.co.jp>
	In MCSetFont(), an argument -fnjp2 is also handled. */
/* 92.9.2   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Big change to support private character-set. */
/* 92.9.11  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	User can specify inter-line space by dots. */
/* 92.9.30  modified for Mule Ver.0.9.6 by M.Shikida <shikida@cs.titech.ac.jp>
	lineSpace related bugs are fixed.
	Entries in default_fonts are augmented. */
/* 92.10.10 modified for Mule Ver.0.9.6
   			by T.Sakakibara <tomo@dolphin.axis.co.jp>
	Pointer returned by XrmGetResource() should not be freed. */
/* 92.10.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Change for setting default fonts by EmacsLisp.
	Encoding can be set by command line arg and X's resouce. */
/* 92.11.11 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Composite character is supported. */
/* 92.11.25 modified for Mule Ver.0.9.7 by T.Enami <enami@sys.ptg.sony.co.jp>
	In MCDrawText(), bug in handling linespace fixed. */
/* 92.11.30  modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	In CursorToggle(), bug fixed. */
/* 92.12.10 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Above and below linespaces can be specified independently.
	Font manipulation methods changed. */
/* 92.12.31 modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Bug in handling XXfontsize fixed. */
/* 93.3.4   modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In MCDrawText(), check the count of composed chars. */
/* 93.3.19  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	No need for including <X11/Xatom.h> here, it's included in x11term.h */
/* 93.4.11  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Shape of bold characters are controlled by x-horizontal-bold-style.
	Handling of cursor color is improved.
	Highlight anti-direction characters. */
/* 93.4.29  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	CNS11643 support.
	Bugs fixed in handling font. */
/* 93.5.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In MCNewFont(), take priority of specified 'encoding'. */
/* 93.5.22  modified for Mule Ver.0.9.8 by Y.Niibe <gniibe@mri.co.jp>
	Double cursor support. */
/* 93.5.29  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In MCDrawText(), bug in handling composite char fixed. */
/* 93.6.21  modified for Mule Ver.0.9.8 by D.Chee <dana@thumper.bellcore.com>
	Original bug of x-set-*-color fixed. */
/* 93.6.24  modified for Mule Ver.0.9.8 by N.Demizu <nori-d@is.aist-nara.ac.jp>
	Bugs in calling xmalloc fixed. */
/* 93.6.25  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Set fonts[lc].encoding from Vx_default_encoding.
	Big change in MCLoadFont() */
/* 93.6.28  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In XT_CalcForFont(), don't free X_DEFAULT_FONT. */
/* 93.7.15  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In x_term_init(), consult resource for ASCII font. */
/* 93.7.15  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In MCNewFont(), don't call XFreeFont() for not-opened font. */
/* 93.7.16  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In x_term_init(), ASCII default font should be concerned. */
/* 93.7.27  modified for Mule Ver.0.9.8 by T.Saneto <sanewo@pdp.crl.sony.co.jp>
	Avoid warning of GCC. */
/* 93.8.30  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	In MCDrawText(), underline length should be 1-dot shorter. */

/* Written by Yakim Martillo, mods and things by Robert Krawitz  */
/* Redone for X11 by Robert French */
/* Thanks to Mark Biggers for all of the Window Manager support */

/*
 *	$Source: /mit/emacs/src/RCS/11xterm.c,v $
 *	$Author: rfrench $
 *	$Locker:  $
 *	$Header: x11term.c,v 1.12 88/02/29 14:11:07 rfrench Exp $
 */

#ifndef lint
static char *rcsid_xterm_c = "$Header: x11term.c,v 1.12 88/02/29 14:11:07 rfrench Exp $";
#endif

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

#ifdef HAVE_X_WINDOWS

/* Get FIONREAD, if it is available.
   It would be logical to include <sys/ioctl.h> here,
   but it was moved up above to avoid problems.  */
#ifdef USG
#include <termio.h>
#endif /* USG */
#include <fcntl.h>

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

/* This may include sys/types.h, and that somehow loses
   if this is not done before the other system files.
   However, perhaps the problem has been avoided by loading types.h above.  */

#include "x11term.h"

#include "X11/Xresource.h"

/* Allow the config file to specify whether we can assume X11R4.  */
#ifdef SPECIFY_X11R4
#if SPECIFY_X11R4 > 0
#define X11R4
#endif
#else /* not SPECIFY_X11R4 */
/* Try to guess whether this is release 4 or newer.  */
#ifdef PBaseSize
#define X11R4
#endif
#endif /* not SPECIFY_X11R4 */

#ifdef HAVE_SOCKETS
#include <sys/socket.h>		/* Must be done before gettime.h.  */
#endif
/* Include time.h, sys/time.h, or both.  */
#include "gettime.h"

#ifdef AIX
static KeySym XMOD_Alt[] = { XK_Alt_L };
static KeySym XMOD_Shift[] = { XK_Shift_L };
static KeySym XMOD_ShiftAlt[] = { XK_Alt_L, XK_Shift_L };
static KeySym XMOD_CtrlAlt[] = { XK_Control_L, XK_Alt_L };
static KeySym XMOD_Ctrl[] = { XK_Control_L };
static KeySym XMOD_CtrlShift[] = { XK_Control_L, XK_Shift_L };
static KeySym XMOD_ShiftCtrlAlt[] = { XK_Control_L, XK_Alt_L, XK_Shift_L };
#endif

#if 0 /* On some machines, stdio.h doesn't define NULL
	 if stddef.h has been included already!  */
#ifdef NULL  /* Sometimes various definitions conflict here.  */
#undef NULL
#endif
#endif
#include <stdio.h>
#include <ctype.h>
#include <errno.h>
#ifdef BSD
#include <strings.h>
#endif
#ifdef IRIX
#include <string.h>
#endif
#include <sys/stat.h>

#ifndef NULL
#define NULL 0
#endif

#include "dispextern.h"
#include "termhooks.h"
#include "termopts.h"
#include "termchar.h"

#include "sink11.h"
#include "sink11mask.h"

#include "mule.h"		/* 91.11.28 by K.Handa */
#include "codeconv.h"		/* 92.3.6 by K.Handa */

#define min(a,b) ((a)<(b) ? (a) : (b))
#define max(a,b) ((a)>(b) ? (a) : (b))

extern int errno;

#define sigunblockx(sig) sigblock (SIGEMPTYMASK)
#define sigblockx(sig) sigblock (sigmask ((sig)))

#define METABIT 0200
#define MINWIDTH 12	/* In pixels */
#define MINHEIGHT 5	/* In pixels */
#define MAXHEIGHT 300	/* In lines */

int pixelwidth,pixelheight;
char *progname;

XEvent *XXm_queue[XMOUSEBUFSIZE];
int XXm_queue_num, XXm_queue_in, XXm_queue_out;

/* The following tree variables always have the same value as
   fonts[0].name, fonts[0].fs, and fonts0].fs->fid respectively. */
char *XXcurrentfont;
XFontStruct *fontinfo;
Font XXfid;
int XXfontw, XXfonth, XXbase, XXisColor;

/* Nonzero means Emacs has explicit keyboard focus.  */
int x_focus_flag;

Colormap XXColorMap;
char *default_window;
extern int initialized;
extern int screen_width, screen_height;
extern int delayed_size_change;

/* Function for init_keyboard to call with no args (if nonzero).  */
extern void (*keyboard_init_hook) ();

extern char *alternate_display;
extern int xargc;
extern char **xargv;

int XXdebug;
int XXpid;

int WindowMapped;

char  *XXidentity;	/* Resource name of this invocation of Emacs */
static char  *XXicon_name;	/* user-supplied icon info */
static int   XXicon_usebitmap;	/* Use bitmap or not */
static char  *XXheader;		/* user-supplied window header info */

static int flexlines;  		/* last line affected by dellines or
				 * inslines functions */
int VisibleX, VisibleY;		/* genuine location of cursor on screen
				 * if it is there */
int VisibleXRev, VisibleYRev; /* 93.5.22 Y.Niibe */

/* Last cursor position specified by move_cursor.
   During an update, this does not display a cursor on the screen;
   But it controls the position that is output.  */
static int local_cursor_hpos;
static int local_cursor_vpos;

static int SavedX, SavedY;	/* Where the cursor was before update
				 * started */


int CursorExists;		/* during updates cursor is turned off */
int CursorOutline; 	    	/* when the pointer is not in the Emacs
    	    	    	    	 * widow the cursor should be drawn in
    	    	    	         * outline form a la xterm */
static int InUpdate;		/* many of functions here may be invoked
				 * even if no update in progress; when
				 * no update is in progress the action
				 * can be slightly different */
int CursorExistsRev; /* 93.5.22 Y.Niibe */

Display *XXdisplay;
int XXscreen;
Window XXwindow;
GC XXgc_norm,XXgc_rev,XXgc_curs,XXgc_temp,XXgc_curs_rev;
XGCValues XXgcv;
Cursor EmacsCursor;
Pixmap SinkPixmap, SinkMaskPixmap;

static XrmDatabase db, db2;

/* 91.11.28 by K.Handa */
Atom XXboff_atom, XXrcmp, XXpixel_size;	/* 92.12.10, 92.12.31 by K.Handa */
GC XXgc_r2l, XXgc_r2l_rev;	/* 93.4.13 by K.Handa */
static char *XXfontsizestr;
static unsigned int XXfontsize; /* 92.8.13, 92.12.31 by K.Handa */
/* 92.10.11 by K.Handa */
Lisp_Object Vx_default_fonts, Vx_default_encoding;
/* end of patch */
Lisp_Object Vx_ccl_programs; /* 93.5.28 by K.Handa */
int x_horizontal_bold_style; /* 93.4.11 by K.Handa */
font_struct fonts[128];
char *xt_fonts[128], *xt_encoding[128];	/* 92.10.10 by T.Sakakibara */
/* 92.9.11, 92.12.10 by K.Handa */
char *XXlinespacestr;
int XXlspABOVE, XXlspBELOW;
int XXunderline_offset;
/* 93.4.12 by K.Handa */
#define r2l_bmp_width 8
#define r2l_bmp_height 8
static unsigned char r2l_bmp_bits[]
  = { 0xFE, 0xF7, 0xBF, 0xFD, 0xEF, 0x7F, 0xFB, 0xDF };
/* end of patch */

char *fore_color;	/* Variables to store color names */
char *back_color;
char *brdr_color;
char *curs_color;
char *mous_color;
char *r2l_color;		/* 93.4.13 by K.Handa */
char *r2l_rev_color;		/* 93.4.13 by K.Handa */

unsigned long fore;	/* Variables to store pixel values */
unsigned long back;
unsigned long brdr;
unsigned long curs;
unsigned long r2l;		/* 93.4.13 by K.Handa */
unsigned long r2l_rev;		/* 93.4.13 by K.Handa */

char *desiredwindow;

int CurHL;			/* Current Highlighting (ala mode line) */

int XXborder;			/* Window border width */
int XXInternalBorder;		/* Internal border width */
int updated[MAXHEIGHT];

static char  *temp_font;                /* needed because of loading hacks */
static char  *temp_reverseVideo;
static char  *temp_borderWidth;
static char  *temp_internalBorder;
static char  *temp_useBitmap;

struct _xdeftab 
{
  char *iname;			/* instance name */
  char *cname;			/* class name (fake it) */
  char **varp;			/* variable to set */
};

static struct _xdeftab xDefaultsValueTable[]
 = {
     { "reverseVideo",	"ReverseVideo",		&temp_reverseVideo },
     { "borderWidth",	"BorderWidth",		&temp_borderWidth },
     { "internalBorder","BorderWidth",		&temp_internalBorder },
     { "bitmapIcon",	"BitmapIcon",		&temp_useBitmap },
     { "borderColor",	"BorderColor",		&brdr_color },
     { "background",	"Background",		&back_color },
     { "foreground",	"Foreground",		&fore_color },
     { "pointerColor",	"Foreground",		&mous_color },
     { "cursorColor",	"Foreground",		&curs_color },
/* 91.12.12, 92.8.11 by K.Handa, 92.10.10 by T.Sakakibara */
     { "font",		"Font",		&xt_fonts[0] },
     { "fontltn1",	"FontLTN1",	&xt_fonts[LCLTN1 & 0x1F] },
     { "fontltn2",	"FontLTN2",	&xt_fonts[LCLTN2 & 0x1F] },
     { "fontltn3",	"FontLTN3",	&xt_fonts[LCLTN3 & 0x1F] },
     { "fontltn4",	"FontLTN4",	&xt_fonts[LCLTN4 & 0x1F] },
     { "fontgrk",	"FontGRK",	&xt_fonts[LCGRK & 0x1F] },
     { "fontarb",	"FontARB",	&xt_fonts[LCARB & 0x1F] },
     { "fonthbw",	"FontHBW",	&xt_fonts[LCHBW & 0x1F] },
     { "fontkana",	"FontKANA",	&xt_fonts[LCKANA & 0x1F] },
     { "fontroman",	"FontROMAN",	&xt_fonts[LCROMAN & 0x1F] },
     { "fontcrl",	"FontCRL",	&xt_fonts[LCCRL & 0x1F] },
     { "fontltn5",	"FontLTN5",	&xt_fonts[LCLTN5 & 0x1F] },
     { "fontjpold",	"FontJPOLD",	&xt_fonts[LCJPOLD & 0x1F] },
     { "fontcn",	"FontCN",	&xt_fonts[LCCN & 0x1F] },
     { "fontjp",	"FontJP",	&xt_fonts[LCJP & 0x1F] },
     { "fontkr",	"FontKR",	&xt_fonts[LCKR & 0x1F] },
     { "fontjp2",	"FontJP2",	&xt_fonts[LCJP2 & 0x1F] },
/* 93.4.29 by K.Handa */
     { "fontcns1",	"FontCNS1",	&xt_fonts[LCCNS1 & 0x1F] },
     { "fontcns2",	"FontCNS2",	&xt_fonts[LCCNS2 & 0x1F] },
     { "fontcns14",	"FontCNS14",	&xt_fonts[LCCNS14 & 0x1F] },
/* end of patch */
     { "fontbig5",	"FontBig5",	&xt_fonts[LCBIG5_1 & 0x1F] },
     { "fontsize",	"FontSize",	&XXfontsizestr },
/* 92.9.11 by K.Handa */
     { "ecd",		"Ecd",		&xt_encoding[LCASCII & 0x1F] },
     { "ecdltn1",	"EcdLTN1",	&xt_encoding[LCLTN1 & 0x1F] },
     { "ecdltn2",	"EcdLTN2",	&xt_encoding[LCLTN2 & 0x1F] },
     { "ecdltn3",	"EcdLTN3",	&xt_encoding[LCLTN3 & 0x1F] },
     { "ecdltn4",	"EcdLTN4",	&xt_encoding[LCLTN4 & 0x1F] },
     { "ecdgrk",	"EcdGRK",	&xt_encoding[LCGRK & 0x1F] },
     { "ecdarb",	"EcdARB",	&xt_encoding[LCARB & 0x1F] },
     { "ecdhbw",	"EcdHBW",	&xt_encoding[LCHBW & 0x1F] },
     { "ecdkana",	"EcdKANA",	&xt_encoding[LCKANA & 0x1F] },
     { "ecdroman",	"EcdROMAN",	&xt_encoding[LCROMAN & 0x1F] },
     { "ecdcrl",	"EcdCRL",	&xt_encoding[LCCRL & 0x1F] },
     { "ecdltn5",	"EcdLTN5",	&xt_encoding[LCLTN5 & 0x1F] },
     { "lineSpace",	"LineSpace",	&XXlinespacestr },
/* end of patch */
     { "geometry",	"Geometry",		&desiredwindow },
     { "title",		"Title",		&XXheader },
     { "iconName",	"Title",		&XXicon_name },
     { NULL,		NULL,			NULL }
   };


int (*handler)();

static void x_init_1 ();
static int XInitWindow ();

/* HLmode -- Changes the GX function for output strings.  Could be used to
 * change font.  Check an XText library function call.
 */

HLmode (new)
     int new;
{
	extern int inverse_video;
	
	CurHL = new;
}

/* External interface to control of standout mode.
   Call this when about to modify line at position VPOS
   and not change whether it is highlighted.  */

XTreassert_line_highlight (highlight, vpos)
     int highlight, vpos;
{
	HLmode (highlight);
}

/* Call this when about to modify line at position VPOS
   and change whether it is highlighted.  */

XTchange_line_highlight (new_highlight, vpos, first_unused_hpos)
     int new_highlight, vpos, first_unused_hpos;
{
	HLmode (new_highlight);
	XTmove_cursor (vpos, 0);
	x_clear_end_of_line (0);
}


/* Used for starting or restarting (after suspension) the X window.  Puts the
 * cursor in a known place, update does not begin with this routine but only
 * with a call to redisplay.
 */

XTset_terminal_modes ()
{
	int stuffpending;
#ifdef XDEBUG
	fprintf (stderr, "XTset_terminal_modes\n");
#endif

	InUpdate = 0;
	stuffpending = 0;
	if (!initialized) {
		CursorExists = 0;
		CursorOutline = 1;
		VisibleX = 0;
		VisibleY = 0;
/* 93.5.22 Y.Niibe */
		CursorExistsRev = 0;
		VisibleXRev = 0;
		VisibleYRev = 0;
/* end of patch */
	}
	XTclear_screen ();
}

/* XTmove_cursor moves the cursor to the correct location and checks whether an
 * update is in progress in order to toggle it on.
 */

XTmove_cursor (row, col)
     register int row, col;
{
	BLOCK_INPUT_DECLARE ();
#ifdef XDEBUG
	fprintf (stderr, "XTmove_cursor (X %d, Y %d)\n",col,row);
#endif

	BLOCK_INPUT ();
	local_cursor_hpos = col;
	local_cursor_vpos = row;

	if (InUpdate) {
		if (CursorExists)
			CursorToggle ();
		UNBLOCK_INPUT ();
		return;
		/* Generally, XTmove_cursor will be invoked */
		/* when InUpdate with !CursorExists */
		/* so that wasteful XFlush is not called */
	}
	if ((row == VisibleY) && (col == VisibleX)) {
		if (!CursorExists)
			CursorToggle ();
		XFlush (XXdisplay);
		UNBLOCK_INPUT ();
		return;
	}
	if (CursorExists)
		CursorToggle ();
	VisibleX = col;
	VisibleY = row;
	if (!CursorExists)
		CursorToggle ();
	XFlush (XXdisplay);
	UNBLOCK_INPUT ();
}

/* Used to get the terminal back to a known state after resets.  Usually
 * used when restarting suspended or waiting emacs
 */

cleanup ()
{
	inverse_video = 0;
	HLmode (0);
}

/* Erase current line from current column to column END.
   Leave cursor at END.  */

XTclear_end_of_line (end)
     register int end;
{
  register int numcols;
  BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
  fprintf (stderr, "XTclear_end_of_line (to %d)\n",end);
#endif

  if (local_cursor_vpos < 0 || local_cursor_vpos >= screen_height)
    return;

  if (end <= local_cursor_hpos)
    return;
  if (end >= screen_width)
    end = screen_width;

  numcols = end - local_cursor_hpos;
  BLOCK_INPUT ();
  if (local_cursor_vpos == VisibleY && VisibleX >= local_cursor_hpos && VisibleX < end)
    if (CursorExists) CursorToggle ();
  if (CurHL)
    XFillRectangle (XXdisplay, XXwindow, XXgc_norm,
		    local_cursor_hpos*XXfontw+XXInternalBorder,
		    local_cursor_vpos*XXfonth+XXInternalBorder,
		    XXfontw*numcols,
		    XXfonth);
  else
    XClearArea (XXdisplay, XXwindow,
		local_cursor_hpos*XXfontw+XXInternalBorder,
		local_cursor_vpos*XXfonth+XXInternalBorder,
		XXfontw*numcols,
		XXfonth,
		0);
  XTmove_cursor (local_cursor_vpos, end);
  UNBLOCK_INPUT ();
}

/* Erase current line from column START to right margin.
   Leave cursor at START.  */

x_clear_end_of_line (start)
     register int start;
{
  register int numcols;
  BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
  fprintf (stderr, "x_clear_end_of_line (start %d)\n", start);
#endif

  if (local_cursor_vpos < 0 || local_cursor_vpos >= screen_height)
    return;

  if (start >= screen_width)
    return;
  if (start < 0)
    start = 0;

  numcols = screen_width - start;
  BLOCK_INPUT ();
  if (local_cursor_vpos == VisibleY && VisibleX >= start)
    if (CursorExists) CursorToggle ();
  if (CurHL)
    XFillRectangle (XXdisplay, XXwindow, XXgc_norm,
		    start*XXfontw+XXInternalBorder,
		    local_cursor_vpos*XXfonth+XXInternalBorder,
		    XXfontw*numcols,
		    XXfonth);
  else
    XClearArea (XXdisplay, XXwindow,
		start*XXfontw+XXInternalBorder,
		local_cursor_vpos*XXfonth+XXInternalBorder,
		XXfontw*numcols,
		XXfonth,
		0);
  XTmove_cursor (local_cursor_vpos, start);
  UNBLOCK_INPUT ();
}

XTreset_terminal_modes ()
{
#ifdef XDEBUG
	fprintf (stderr, "XTreset_terminal_modes\n");
#endif

	XTclear_screen ();
}

XTclear_screen ()
{
	BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
	fprintf (stderr, "XTclear_screen\n");
#endif

	BLOCK_INPUT ();
	HLmode (0);
	CursorExists = 0;
	CursorExistsRev = 0; /* 93.5.22 Y.Niibe */

	local_cursor_hpos = 0;
	local_cursor_vpos = 0;
	SavedX = 0;
	SavedY = 0;
	VisibleX = 0;
	VisibleY = 0;
/* 93.5.22 Y.Niibe */
	VisibleXRev = 0;
	VisibleYRev = 0;
/* end of patch */
	XClearWindow(XXdisplay, XXwindow);
	CursorToggle ();
	if (!InUpdate)
		XFlush (XXdisplay);
	UNBLOCK_INPUT ();
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
	MCDrawText(XXdisplay, XXwindow, tempHL ? XXgc_rev : XXgc_norm,
			 tempX*XXfontw+XXInternalBorder,
			 tempY*XXfonth+XXInternalBorder+XXbase,
			 (char *) &active_screen->contents[tempY][tempX],
			 numcols);
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

updateline (first)
	int first;
{
	register int temp_length;
	BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
	fprintf(stderr, "updateline\n");
#endif /* XDEBUG */

	BLOCK_INPUT ();
	if ((local_cursor_vpos < 0) || (local_cursor_vpos >= screen_height)
	    || updated[local_cursor_vpos]) {
		UNBLOCK_INPUT ();
		return;
	}
	if (!first)
		updated[local_cursor_vpos] = 1;
	if (CursorExists)
		CursorToggle ();
	if (new_screen->enable[local_cursor_vpos])
		temp_length = new_screen->used[local_cursor_vpos]-first;
	else
		temp_length = 0;
	if (temp_length > 0) {
				/* 91.11.28 by K.Handa */
		MCDrawText (XXdisplay, XXwindow,
				  CurHL ? XXgc_rev : XXgc_norm,
				  first*XXfontw+XXInternalBorder,
				  local_cursor_vpos*XXfonth+XXInternalBorder+XXbase,
				  (char *) &new_screen->contents[local_cursor_vpos][first],
				  temp_length);
		if (temp_length < screen_width)
			x_clear_end_of_line (temp_length);
		XTmove_cursor (local_cursor_vpos, temp_length);
	}
	else {
		x_clear_end_of_line (0);
		XTmove_cursor (local_cursor_vpos, 0);
	}
	UNBLOCK_INPUT ();
}

writechars (start, end)
	register int *start, *end; /* 91.11.28 by K.Handa */
{
  BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
  fprintf(stderr, "writechars (local_cursor_hpos %d temp_len %d InUpd %d)\n",
	  local_cursor_hpos, end-start+1, InUpdate);
#endif /* XDEBUG */

  BLOCK_INPUT ();

  if ((local_cursor_vpos < 0) || (local_cursor_vpos >= screen_height))
    {
      UNBLOCK_INPUT ();
      return;
    }

  if (CursorExists)
    CursorToggle ();


  if (InUpdate)
    {
				/* 91.11.28 by K.Handa */
      MCDrawText (XXdisplay, XXwindow,
			CurHL ? XXgc_rev : XXgc_norm,
			local_cursor_hpos*XXfontw+XXInternalBorder,
			local_cursor_vpos*XXfonth+XXInternalBorder+XXbase,
			start,
			(end - start) + 1);
      XTmove_cursor (local_cursor_vpos, (end - start) + 1);

      UNBLOCK_INPUT ();
      return;
    }

  if ((VisibleX < 0) || (VisibleX >= screen_width)) {
    UNBLOCK_INPUT ();
    return;
  }
  if ((VisibleY < 0) || (VisibleY >= screen_height)) {
    UNBLOCK_INPUT ();
    return;
  }
  if (((end - start) + VisibleX) >= screen_width)
    end = start + (screen_width - (VisibleX + 1));
  if (end >= start) {
				/* 91.11.28 by K.Handa */
    MCDrawText (XXdisplay, XXwindow,
		      CurHL ? XXgc_rev : XXgc_norm,
		      (VisibleX * XXfontw+XXInternalBorder),
		      VisibleY * XXfonth+XXInternalBorder+XXbase,
		      start,
		      ((end - start) + 1));
    VisibleX = VisibleX + (end - start) + 1;
  }
  if (!CursorExists)
    CursorToggle ();
  UNBLOCK_INPUT ();
}

static
XToutput_chars (start, len)
     register unsigned int *start; /* 91.11.28 by K.Handa */
     register int len;
{
#ifdef XDEBUG
	fprintf (stderr, "XToutput_chars (len %d)\n",len);
#endif

	writechars (start, start+len-1);
}

XTflash ()
{
#ifdef HAVE_TIMEVAL
#ifdef HAVE_SELECT
	XGCValues gcv_temp;
	struct timeval wakeup, now;
	BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
	fprintf (stderr, "XTflash\n");
#endif

	BLOCK_INPUT ();
	XXgc_temp = XCreateGC(XXdisplay, XXwindow, 0, &gcv_temp);
	XSetState(XXdisplay, XXgc_temp, WhitePixel (XXdisplay, XXscreen),
		  BlackPixel(XXdisplay, XXscreen), GXinvert,
		  AllPlanes);

	/* For speed, flash just 1/4 of the window's area, a rectangle in
	   the center.  */
	XFillRectangle (XXdisplay, XXwindow, XXgc_temp,
			screen_width*XXfontw/4, screen_height*XXfonth/4,
			screen_width*XXfontw/2, screen_height*XXfonth/2);
	XFlush (XXdisplay);

	UNBLOCK_INPUT ();

	gettimeofday (&wakeup, (struct timezone *)0);

	/* Compute time to wait until, propagating carry from usecs.  */
	wakeup.tv_usec += 150000;
	wakeup.tv_sec += (wakeup.tv_usec / 1000000);
	wakeup.tv_usec %= 1000000;

	/* Keep waiting until past the time wakeup.  */
	while (1)
	  {
	    struct timeval timeout;

	    gettimeofday (&timeout, (struct timezone *)0);

	    /* In effect, timeout = wakeup - timeout.
	       Break if result would be negative.  */
	    if (timeval_subtract (&timeout, wakeup, timeout))
	      break;

	    /* Try to wait that long--but we might wake up sooner.  */
	    select (0, 0, 0, 0, &timeout);
	  }
	
	BLOCK_INPUT ();

	XFillRectangle (XXdisplay, XXwindow, XXgc_temp,
			screen_width*XXfontw/4, screen_height*XXfonth/4,
			screen_width*XXfontw/2, screen_height*XXfonth/2);

	XFreeGC(XXdisplay, XXgc_temp);
	XFlush (XXdisplay);

	UNBLOCK_INPUT ();
#endif
#endif
}	

XTfeep ()
{
	BLOCK_INPUT_DECLARE ();
#ifdef XDEBUG
	fprintf (stderr, "XTfeep\n");
#endif
	BLOCK_INPUT ();
	XBell (XXdisplay, 0);
	XFlush (XXdisplay);
	UNBLOCK_INPUT ();
}

/* Artificially creating a cursor is hard, the actual position on the
 * screen (either where it is or last was) is tracked with VisibleX,Y.
 * Gnu Emacs code tends to assume a cursor exists in hardward at local_cursor_hpos,Y
 * and that output text will appear there.  During updates, the cursor is
 * supposed to be blinked out and will only reappear after the update
 * finishes.
 */

CursorToggle ()
{
	register struct matrix *active_screen;

	if (!WindowMapped) {
		CursorExists = 0;
		CursorOutline = 1;
		return 0;
		/* Currently the return values are not */
		/* used, but I could anticipate using */
		/* them in the future. */
	}
	
	if (VisibleX < 0 || VisibleX >= screen_width ||
	    VisibleY < 0 || VisibleY >= screen_height) {
		/* Not much can be done */
		XFlush (XXdisplay);
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
			MCDrawText(XXdisplay, XXwindow, XXgc_norm,
				    VisibleX*XXfontw+XXInternalBorder,
				    VisibleY*XXfonth+XXInternalBorder+XXbase,
				    (int *) &active_screen->contents[VisibleY][VisibleX],
				    1);
		else if (CursorOutline) {
		  unsigned int len, c; /* 92.11.12 by K.Handa */
		  c = active_screen->contents[VisibleY][VisibleX];
		  len = MTRX_CMPCHAR (c)
		    ? char_width[*(MTRX_CMPPTR (c) + 1) - 0x20]
		    : char_width[MTRX_LC (c)];
			MCDrawText(XXdisplay, XXwindow, XXgc_norm,
				    VisibleX*XXfontw+XXInternalBorder,
				    VisibleY*XXfonth+XXInternalBorder+XXbase,
				    (int *) &active_screen->contents[VisibleY][VisibleX],
				    1);
			XDrawRectangle (XXdisplay, XXwindow, XXgc_curs_rev,
					VisibleX*XXfontw+XXInternalBorder,
					VisibleY*XXfonth+XXInternalBorder,
					XXfontw * len - 1, XXfonth - 1);
		} else
			MCDrawText(XXdisplay, XXwindow, XXgc_curs,
				    VisibleX*XXfontw+XXInternalBorder,
				    VisibleY*XXfonth+XXInternalBorder+XXbase,
				    (int *) &active_screen->contents[VisibleY][VisibleX],
				    1);
	      }
	else {
	  unsigned int len, c; /* 92.11.30 by K.Handa */
	  c = active_screen->contents[VisibleY][VisibleX];
	  len = MTRX_CMPCHAR (c)
	    ? char_width[*(MTRX_CMPPTR (c) + 1) - 0x20]
	    : char_width[MTRX_LC (c)];
		if (CursorExists)
			XClearArea (XXdisplay, XXwindow,
				    VisibleX*XXfontw+XXInternalBorder,
				    VisibleY*XXfonth+XXInternalBorder,
				    XXfontw * len, XXfonth, 0);
		else if (CursorOutline)
			XDrawRectangle (XXdisplay, XXwindow, XXgc_curs_rev,
 					VisibleX*XXfontw+XXInternalBorder,
					VisibleY*XXfonth+XXInternalBorder,
					XXfontw * len - 1, XXfonth - 1);
		else {		/* 92.3.19 by K.Handa */
		  unsigned int i[1];
		  i[0] = ' ';
			MCDrawText(XXdisplay, XXwindow, XXgc_curs,
				    VisibleX*XXfontw+XXInternalBorder,
				    VisibleY*XXfonth+XXInternalBorder+XXbase,
				    i, 1);
		}
	      }

	CursorExists = !CursorExists;

	if (!InUpdate)
		XFlush (XXdisplay);

	return 1;
}

/* 93.5.22 Y.Niibe */
static
CursorToggleRev ()
{
	register struct matrix *active_screen;

	if (!WindowMapped) {
		CursorExistsRev = 0;
		return 0;
		/* Currently the return values are not */
		/* used, but I could anticipate using */
		/* them in the future. */
	}
	
	if (VisibleXRev < 0 || VisibleXRev >= screen_width ||
	    VisibleYRev < 0 || VisibleYRev >= screen_height) {
		/* Not much can be done */
		XFlush (XXdisplay);
		CursorExistsRev = 0;
		return 0;
	}

	active_screen = current_screen;

	if (active_screen->highlight[VisibleYRev])
	  /* If the cursor is in the modeline, it means display was preempted.
	     Don't actually display the cursor there, just say we did.
	     The code below doesn't display it right, and nobody wants
	     to see it anyway.  */
	  ;
	else if (active_screen->enable[VisibleYRev]
		 && VisibleXRev < active_screen->used[VisibleYRev]) {
		if (CursorExistsRev)
		  MCDrawText(XXdisplay, XXwindow, XXgc_norm,
			     VisibleXRev*XXfontw+XXInternalBorder,
			     VisibleYRev*XXfonth+XXInternalBorder+XXbase,
			     (int *) &active_screen->contents[VisibleYRev][VisibleXRev],
			     1);
		else if (CursorOutline) {
		  unsigned int len, c; /* 92.11.12 by K.Handa */
		  c = active_screen->contents[VisibleYRev][VisibleXRev];
		  len = MTRX_CMPCHAR (c)
		    ? char_width[*(MTRX_CMPPTR (c) + 1) - 0x20]
		    : char_width[MTRX_LC (c)];
		  MCDrawText(XXdisplay, XXwindow, XXgc_norm,
			     VisibleXRev*XXfontw+XXInternalBorder,
			     VisibleYRev*XXfonth+XXInternalBorder+XXbase,
			     (int *) &active_screen->contents[VisibleYRev][VisibleXRev],
			     1);
		  XDrawRectangle (XXdisplay, XXwindow, XXgc_curs_rev,
				  VisibleXRev*XXfontw+XXInternalBorder,
				  VisibleYRev*XXfonth+XXInternalBorder,
				  XXfontw * len - 1, XXfonth - 1);
		} else
			MCDrawText(XXdisplay, XXwindow, XXgc_curs,
				   VisibleXRev*XXfontw+XXInternalBorder,
				   VisibleYRev*XXfonth+XXInternalBorder+XXbase,
				   (int *) &active_screen->contents[VisibleYRev][VisibleXRev],
				   1);
	      }
	else {
	  unsigned int len, c; /* 92.11.30 by K.Handa */
	  c = active_screen->contents[VisibleYRev][VisibleXRev];
	  len = MTRX_CMPCHAR (c)
	    ? char_width[*(MTRX_CMPPTR (c) + 1) - 0x20]
	    : char_width[MTRX_LC (c)];
		if (CursorExistsRev)
			XClearArea (XXdisplay, XXwindow,
				    VisibleXRev*XXfontw+XXInternalBorder,
				    VisibleYRev*XXfonth+XXInternalBorder,
				    XXfontw * len, XXfonth, 0);
		else if (CursorOutline)
			XDrawRectangle (XXdisplay, XXwindow, XXgc_curs_rev,
 					VisibleXRev*XXfontw+XXInternalBorder,
					VisibleYRev*XXfonth+XXInternalBorder,
					XXfontw * len - 1, XXfonth - 1);
		else {		/* 92.3.19 by K.Handa */
		  unsigned int i[1];
		  i[0] = ' ';
			MCDrawText(XXdisplay, XXwindow, XXgc_curs,
				   VisibleXRev*XXfontw+XXInternalBorder,
				   VisibleYRev*XXfonth+XXInternalBorder+XXbase,
				   i, 1);
		}
	      }

	CursorExistsRev = !CursorExistsRev;

	if (!InUpdate)
		XFlush (XXdisplay);

	return 1;
}
/* end of patch */

/* This routine is used by routines which are called to paint regions */
/* designated by Expose events.  If the cursor may be in the exposed */
/* region, this routine makes sure it is gone so that dumprectangle can */
/* toggle it back into existance if dumprectangle is invoked when not in */
/* the midst of a screen update. */

static
ClearCursor ()
{
	BLOCK_INPUT_DECLARE ();

	BLOCK_INPUT ();
	if (!WindowMapped) {
		CursorExists = 0;
		CursorOutline = 1;
		UNBLOCK_INPUT ();
		return;
	}
	
	if (VisibleX < 0 || VisibleX >= screen_width ||
	    VisibleY < 0 || VisibleY >= screen_height) {
		/* Not much can be done */
		CursorExists = 0;
		UNBLOCK_INPUT ();
		return;
	}

	XClearArea (XXdisplay, XXwindow,
		    VisibleX*XXfontw+XXInternalBorder,
		    VisibleY*XXfonth+XXInternalBorder,
		    XXfontw, XXfonth, 0);

	CursorExists = 0;
	UNBLOCK_INPUT ();
}

XTupdate_begin ()
{
	BLOCK_INPUT_DECLARE ();
	register int i;
	
#ifdef XDEBUG
	fprintf (stderr, "XTupdate_begin\n");
#endif

	BLOCK_INPUT ();
	InUpdate = 1;
	if (CursorExists)
		CursorToggle ();

	for (i=0;i<MAXHEIGHT;i++)
		updated[i] = 0;
	
	SavedX = local_cursor_hpos;
	SavedY = local_cursor_vpos;
	/* Thw initial "hardware" cursor position is */
	/* saved because that is where gnu emacs */
	/* expects the cursor to be at the end of */
	/* the update */

/* 93.5.22 Y.Niibe */
	/* clear REVERSE CURSOR */
	if (CursorExistsRev)
	  CursorToggleRev ();
/* end of patch */

	UNBLOCK_INPUT ();
}

XTupdate_end ()
{	
	BLOCK_INPUT_DECLARE ();

#ifdef XDEBUG
	fprintf (stderr, "XTupdate_end\n");
#endif

	BLOCK_INPUT ();
	if (CursorExists)
		CursorToggle ();

	InUpdate = 0;
	/* Display cursor at last place requested.  */
	XTmove_cursor (local_cursor_vpos, local_cursor_hpos);
/* 93.5.22 Y.Niibe */
	/* display REVERSE CURSOR */
	if ((cursor_form & CURSOR_DOUBLE) && r2l_double_cursor)
	  if ((cursor_vpos == VisibleYRev)
	      && (cursor_hpos_rev == VisibleXRev))
	    {
	      if (!CursorExistsRev)
		CursorToggleRev ();
	    }
	  else
	    {
	      if (CursorExistsRev)
		if (VisibleXRev == VisibleX
		    && VisibleYRev == VisibleY)
		  CursorExists = 0;
		else
		  CursorToggleRev ();
	      VisibleXRev = cursor_hpos_rev;
	      VisibleYRev = cursor_vpos;
	      if (!CursorExistsRev)
		CursorToggleRev ();
	    }
	else
	  if (CursorExistsRev)
	    if (VisibleXRev == VisibleX
		&& VisibleYRev == VisibleY)
	      CursorExists = 0;
	    else
	      CursorToggleRev ();
/* end of patch */
	XFlush (XXdisplay);
	UNBLOCK_INPUT ();
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
	if (VisibleX >= left && VisibleX < left + cols &&
	    VisibleY >= top && VisibleY < top + rows)
		ClearCursor ();

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
		CursorToggle ();
	/* Routine usually called */
	/* when not in update */
}

/* What sections of the window will be modified from the UpdateDisplay
 * routine is totally under software control.  Any line with Y coordinate
 * greater than flexlines will not change during an update.  This is really
 * used only during dellines and inslines routines (scraplines and stufflines)
 */

XTset_terminal_window (n)
     register int n;
{
#ifdef XDEBUG
	fprintf (stderr, "XTset_terminal_window\n");
#endif

	if (n <= 0 || n > screen_height)
		flexlines = screen_height;
	else
		flexlines = n;
}

XTins_del_lines (vpos, n)
     int vpos, n;
{
#ifdef XDEBUG
	fprintf (stderr, "XTins_del_lines\n");
#endif

	XTmove_cursor (vpos, 0);
	if (n >= 0)
		stufflines (n);
	else
		scraplines (-n);
}

/* Estimate the cost of scrolling as equal to drawing one fifth
   of the character cells copied if black and white,
   or half of those characters if color.  */

static
XTcalculate_costs (extra, costvec, ncostvec)
     int extra;
     int *costvec, *ncostvec;
{
  int color_p = DisplayCells (XXdisplay, XXscreen) > 2;

  CalcLID (0, screen_width / (color_p ? 2 : 5), 0, 0, costvec, ncostvec);
}

static
XTinsert_chars (start, len)
     register unsigned int *start; /* 91.11.28 by K.Handa */
     register int len;
{
#ifdef XDEBUG
	fprintf (stderr, "XTinsert_chars\n");
#endif

	updateline (0);
}

static
XTdelete_chars (n)
     register int n;
{
	char *msg = "Major foobars!  This shouldn't show up!";
	
#ifdef XDEBUG
	fprintf (stderr, "XTdelete_chars (num %d local_cursor_hpos %d)\n",n,local_cursor_hpos);
#endif

	updateline (0);
}

stufflines (n)
     register int n;
{
	register int topregion, bottomregion;
	register int length, newtop;
	BLOCK_INPUT_DECLARE ();

	if (local_cursor_vpos >= flexlines)
		return;

	BLOCK_INPUT ();

	if (CursorExists)
		CursorToggle ();

	topregion = local_cursor_vpos;
	bottomregion = flexlines-(n+1);
	newtop = local_cursor_vpos+n;
	length = bottomregion-topregion+1;

	if (length > 0 && newtop <= flexlines) {
		XCopyArea (XXdisplay, XXwindow, XXwindow, XXgc_norm,
			   XXInternalBorder,
			   topregion*XXfonth+XXInternalBorder,
			   screen_width*XXfontw,
			   length*XXfonth,
			   XXInternalBorder, newtop*XXfonth+XXInternalBorder);
	}

	newtop = min (newtop, flexlines-1);
	length = newtop-topregion;
	if (length > 0)
		XClearArea (XXdisplay, XXwindow,
			    XXInternalBorder,
			    topregion*XXfonth+XXInternalBorder,
			    screen_width*XXfontw,
			    n*XXfonth, 0);
	UNBLOCK_INPUT ();
}

scraplines (n)
     register int n;
{
	BLOCK_INPUT_DECLARE ();

	if (local_cursor_vpos >= flexlines)
		return;

	BLOCK_INPUT ();

	if (CursorExists)
		CursorToggle ();

	if (local_cursor_vpos+n >= flexlines) {
		if (flexlines >= (local_cursor_vpos + 1))
			XClearArea (XXdisplay, XXwindow,
				    XXInternalBorder,
				    local_cursor_vpos*XXfonth+XXInternalBorder,
				    screen_width*XXfontw,
				    (flexlines-local_cursor_vpos) * XXfonth,
				    0);
		UNBLOCK_INPUT ();
	}
	else {
		XCopyArea (XXdisplay, XXwindow, XXwindow, XXgc_norm,
			   XXInternalBorder,
			   (local_cursor_vpos+n)*XXfonth+XXInternalBorder,
			   screen_width*XXfontw,
			   (flexlines-local_cursor_vpos-n)*XXfonth,
			   XXInternalBorder, local_cursor_vpos*XXfonth+XXInternalBorder);

		XClearArea (XXdisplay, XXwindow, XXInternalBorder,
			    (flexlines-n)*XXfonth+XXInternalBorder,
			    screen_width*XXfontw,
			    n*XXfonth, 0);
		UNBLOCK_INPUT ();
	}
}
	
/* Substitutes for standard read routine.  Under X not interested in individual
 * bytes but rather individual packets.
 */

XTread_socket (sd, bufp, numchars)
     register int sd;
     register char *bufp;
     register int numchars;
{
#ifdef XDEBUG
	fprintf(stderr,"XTread_socket\n");
#endif

	return (internal_socket_read (bufp, numchars));
}

/*
 * Interpreting incoming keycodes. Should have table modifiable as needed
 * from elisp.
 */

#ifdef sun
char *stringFuncVal(keycode)
	KeySym keycode;
{
	switch (keycode) {
	case XK_L1:
		return("192");
	case XK_L2:
		return("193");
	case XK_L3:
		return("194");
	case XK_L4:
		return("195");
	case XK_L5:
		return("196");
	case XK_L6:
		return("197");
	case XK_L7:
		return("198");
	case XK_L8:
		return("199");
	case XK_L9:
		return("200");
	case XK_L10:
		return("201");

	case XK_R1:
		return("208");
	case XK_R2:
		return("209");
	case XK_R3:
		return("210");
	case XK_R4:
		return("211");
	case XK_R5:
		return("212");
	case XK_R6:
		return("213");
	case XK_R7:
		return("214");
	case XK_R8:
		return("215");
	case XK_R9:
		return("216");
	case XK_R10:
		return("217");
	case XK_R11:
		return("218");
	case XK_R12:
		return("219");
	case XK_R13:
		return("220");
	case XK_R14:
		return("221");
	case XK_R15:
		return("222");

	case XK_Break:			/* Sun3 "Alternate" key */
		return("223");

	case XK_F1:
		return("224");
	case XK_F2:
		return("225");
	case XK_F3:
		return("226");
	case XK_F4:
		return("227");
	case XK_F5:
		return("228");
	case XK_F6:
		return("229");
	case XK_F7:
		return("230");
	case XK_F8:
		return("231");
	case XK_F9:
		return("232");
	case XK_F10:
		return("233");

	default:
		return("-1");
	}
}
#else
#ifndef AIX
char *stringFuncVal(keycode)
	KeySym keycode;
{
	switch (keycode) {
	case XK_F1:
		return("11");
	case XK_F2:
		return("12");
	case XK_F3:
		return("13");
	case XK_F4:
		return("14");
	case XK_F5:
		return("15");
	case XK_F6:
		return("17");
	case XK_F7:
		return("18");
	case XK_F8:
		return("19");
	case XK_F9:
		return("20");
	case XK_F10:
		return("21");
	case XK_F11:
		return("23");
	case XK_F12:
		return("24");
	case XK_F13:
		return("25");
	case XK_F14:
		return("26");
	case XK_F15:
#ifdef nec_ews					/* hir@nec, 1992.10.5 */
		return("27");
#else /* not nec_ews */
		return("28");
#endif /* nec_ews */
	case XK_Help:
		return("28");
	case XK_F16:
		return("29");
	case XK_Menu:
		return("29");
	case XK_F17:
		return("31");
	case XK_F18:
		return("32");
	case XK_F19:
		return("33");
	case XK_F20:
		return("34");
	
	case XK_Find :
		return("1");
	case XK_Insert:
		return("2");
	case XK_Delete:
		return("3");
	case XK_Select:
		return("4");
	case XK_Prior:
		return("5");
	case XK_Next:
		return("6");
	default:
		return("-1");
	}
}
#endif /* not AIX */
#endif /* not sun */

internal_socket_read(bufp, numchars)
	register unsigned char *bufp;
	register int numchars;
{
  /* Number of keyboard chars we have produced so far.  */
  int count = 0;
  int nbytes;
  char mapping_buf[20];
  BLOCK_INPUT_DECLARE ();
  XEvent event;
  /* Must be static since data is saved between calls.  */
  static XComposeStatus status;
  KeySym keysym;
  SIGMASKTYPE oldmask;

  BLOCK_INPUT ();
#ifdef BSD
#ifndef BSD4_1
  oldmask = sigblock (sigmask (SIGALRM));
#endif
#endif
#ifdef FIOSNBIO
  /* If available, Xlib uses FIOSNBIO to make the socket
     non-blocking, and then looks for EWOULDBLOCK.  If O_NDELAY is set, FIOSNBIO is
     ignored, and instead of signalling EWOULDBLOCK, a read returns
     0, which Xlib interprets as equivalent to EPIPE. */
  fcntl (fileno (stdin), F_SETFL, 0);
#endif
#ifndef HAVE_SELECT
  if (! (fcntl (fileno (stdin), F_GETFL, 0) & O_NDELAY))
    {
      extern int read_alarm_should_throw;
      read_alarm_should_throw = 1;
      XPeekEvent (XXdisplay,&event);
      read_alarm_should_throw = 0;
    }
#endif
  while (XPending (XXdisplay)) {
    XNextEvent (XXdisplay,&event);
    event.type &= 0177;		/* Mask out XSendEvent indication */

    switch (event.type) {

    default:
      break;

    case MappingNotify:
      XRefreshKeyboardMapping(&event.xmapping);
      break;

    case MapNotify:
      WindowMapped = 1;
      break;

    case UnmapNotify:
      WindowMapped = 0;
      break;
			
    case ConfigureNotify:
      if (abs(pixelheight-event.xconfigure.height) >= XXfonth
	  || abs(pixelwidth-event.xconfigure.width) >= XXfontw)
	{
	  int rows, cols;

	  rows = (event.xconfigure.height-2*XXInternalBorder)/XXfonth;
	  cols = (event.xconfigure.width-2*XXInternalBorder)/XXfontw;
	  pixelwidth = cols*XXfontw+2*XXInternalBorder;
	  pixelheight = rows*XXfonth+2*XXInternalBorder;

	  /* This is absolutely, amazingly gross.  However, without
	     it, emacs will core dump if the window gets too small.
	     And uwm is too brain-damaged to handle large minimum size
	     windows.  */
	  if (cols > 11 && rows > 4)
	    /* Delay the change unless Emacs is waiting for input.  */
	    change_screen_size (rows, cols, 0, !waiting_for_input, 1);
	}
      break;

    case Expose:
      if (!delayed_size_change)
	dumprectangle (event.xexpose.y-XXInternalBorder,
		       event.xexpose.x-XXInternalBorder,
		       event.xexpose.height,
		       event.xexpose.width);
      break;

    case GraphicsExpose:
      if (!delayed_size_change)
	dumprectangle (event.xgraphicsexpose.y-XXInternalBorder,
		       event.xgraphicsexpose.x-XXInternalBorder,
		       event.xgraphicsexpose.height,
		       event.xgraphicsexpose.width);
      break;

    case NoExpose:
      break;

#if 0
    case FocusIn:
    case FocusOut:
    case EnterNotify:
    case LeaveNotify:
      {
	int cursor = -1;	/* 0=on, 1=off, -1=no change */

	if (event.type == FocusIn) cursor = 0;
	else if (event.type == FocusOut) cursor = 1;
	else
	  {
	    Window focus;
	    int revert_to;	/* dummy return val */
	    XGetInputFocus (XXdisplay, &focus, &revert_to);
	    if (focus == PointerRoot)
	      cursor = (event.type == LeaveNotify) ? 1 : 0;
	  }
	if (cursor == -1) break;
	CursorToggle();
	CursorOutline = cursor;
	CursorToggle();
      }
#endif
    case FocusIn:
      /* kenc@viewlogic.com says adding the following line fixes the
	 problems with grabbing and twm.  */
      if (event.xfocus.mode == NotifyNormal)
	x_focus_flag = 1;
    case EnterNotify:
      if (event.type == FocusIn || (!x_focus_flag && event.xcrossing.focus))
	{
	  CursorToggle ();
	  CursorOutline = 0;
	  CursorToggle ();
	}
      break;

    case FocusOut:
      x_focus_flag = 0;
    case LeaveNotify:
      if (event.type == FocusOut || (!x_focus_flag && event.xcrossing.focus))
	{
	  CursorToggle ();
	  CursorOutline = 1;
	  CursorToggle ();
	}
      break;

    case KeyPress:
      nbytes = XLookupString (&event.xkey,
			      mapping_buf, 20, &keysym,
			      0);

#ifndef AIX
      /* Someday this will be unnecessary as we will
	 be able to use XRebindKeysym so XLookupString
	 will have already given us the string we want. */
      if (IsFunctionKey(keysym)
	  || IsMiscFunctionKey(keysym)
	  || keysym == XK_Prior
	  || keysym == XK_Next) {
	strcpy(mapping_buf,"\033["); /* 92.4.16 by K.Handa */
	strcat(mapping_buf,stringFuncVal(keysym));
#ifdef sun
	strcat(mapping_buf,"z");
#else
	strcat(mapping_buf,"~");
#endif /* sun */
	nbytes = strlen(mapping_buf);
      }
      else {
#endif /* not AIX */
	switch (keysym) {
	case XK_Left:
	  strcpy(mapping_buf,"\002");
	  nbytes = 1;
	  break;
	case XK_Right:
	  strcpy(mapping_buf,"\006");
	  nbytes = 1;
	  break;
	case XK_Up:
	  strcpy(mapping_buf,"\020");
	  nbytes = 1;
	  break;
	case XK_Down:
	  strcpy(mapping_buf,"\016");
	  nbytes = 1;
	  break;
	case XK_BackSpace:
	  strcpy(mapping_buf,"\177");
	  nbytes = 1;
	  break;
#ifdef nec_ews					/* hir@nec, 1992.10.5 */
	case XK_KP_F1:
	  strcpy(mapping_buf,"\033OP");
	  nbytes = 3;
	  break;
	case XK_KP_F2:
	  strcpy(mapping_buf,"\033OQ");
	  nbytes = 3;
	  break;
	case XK_KP_F3:
	  strcpy(mapping_buf,"\033OR");
	  nbytes = 3;
	  break;
	case XK_KP_F4:
	  strcpy(mapping_buf,"\033OS");
	  nbytes = 3;
	  break;
	case XK_Kanji:
	  strcpy(mapping_buf,"\033[210z");
	  nbytes = 6;
	  break;
	case XK_Muhenkan:
	  strcpy(mapping_buf,"\033[209z");
	  nbytes = 6;
	  break;
	case XK_Prior:
	  strcpy(mapping_buf,"\033[5~");
	  nbytes = 4;
	  break;
	case XK_Next:
	  strcpy(mapping_buf,"\033[6~");
	  nbytes = 4;
	  break;
#endif /* nec_ews */
	}
#ifndef AIX
      }
#endif  /* not AIX */
      if (nbytes) {
	if ((nbytes == 1) && (event.xkey.state & Mod1Mask))
	  *mapping_buf |= METABIT;
	if ((nbytes == 1) && (event.xkey.state & ControlMask))
	  *mapping_buf &= 0x9F;		/* mask off bits 1 and 2 */
	if (numchars-nbytes > 0) {
	  bcopy (mapping_buf, bufp, nbytes);
	  bufp += nbytes;
	  count += nbytes;
	  numchars -= nbytes;
	}
      }
      break;

    case ButtonPress:
    case ButtonRelease:
      *bufp++ = (char) 'X' & 037;
      ++count;
      --numchars;
      *bufp++ = (char) '@' & 037;
      ++count;
      --numchars;
      if (XXm_queue_num == XMOUSEBUFSIZE)
	break;
      XXm_queue[XXm_queue_in] = (XEvent *) malloc (sizeof(XEvent));
      *XXm_queue[XXm_queue_in] = event;
      XXm_queue_num++;
      XXm_queue_in = (XXm_queue_in + 1) % XMOUSEBUFSIZE;
      break;
#ifdef HAVE_X_SELECTION
    case SelectionClear:
      HandleSelectionClear (&event);
      break;
    case SelectionRequest:
      HandleSelectionRequest (&event);
      break;
#endif /* HAVE_X_SELECTION */
    }
  }

  if (CursorExists)
    xfixscreen ();

#ifdef BSD
#ifndef BSD4_1
  sigsetmask (oldmask);
#endif
#endif
  UNBLOCK_INPUT ();
  return count;
}

/* Exit gracefully from gnuemacs, doing an autosave and giving a status.
 */

void
XExitGracefully ()
{
	XCleanUp();
	exit (70);
}

XIgnoreError ()
{
	return 0;
}

static int server_ping_timer;

xfixscreen ()
{
	BLOCK_INPUT_DECLARE ();

	if (server_ping_timer > 0)
	  server_ping_timer--;
	else
	  {
	    server_ping_timer = 100;

	    /* Yes, this is really what I mean -- Check to see if we've
	     * lost our connection */

	    BLOCK_INPUT ();
	    XSetErrorHandler(0);
	    XSetIOErrorHandler(0);
	    XNoOp (XXdisplay);
	    XFlush (XXdisplay);
	    XSetErrorHandler(handler);
	    XSetIOErrorHandler(handler);
	    if (!InUpdate && !CursorExists)
		    CursorToggle ();

	    UNBLOCK_INPUT ();
	  }
}
	

/* ------------------------------------------------------------
 */
static int  reversevideo;

static int
XT_GetDefaults (class)
    char *class;
{
  register struct _xdeftab *entry;
  char *iname, *cname;

  char *disp = 0, *scrn = 0;

  int len = strlen (CLASS);
  if (strlen (class) > len)
    len = strlen (class);

  /* 100 is bigger than any of the resource names in our fixed set.  */
  iname = (char *) alloca (len + 100);
  cname = (char *) alloca (len + 100);

  XrmInitialize ();

  /* Merge all databases on root window.  */

  disp = XResourceManagerString (XXdisplay);
  if (disp) db = XrmGetStringDatabase (disp);

#if (XlibSpecificationRelease >= 5)
  scrn = XScreenResourceString (ScreenOfDisplay (XXdisplay, XXscreen));
  if (scrn) db2 = XrmGetStringDatabase (scrn);

  /* Screen database takes precedence over global database.  */
  XrmMergeDatabases (db2, &db);
#endif

  /*
   * Walk the table reading in the resources.  Instance names supersede
   * class names.
   */

  for (entry = xDefaultsValueTable; entry->iname; entry++)
    {
      /* Build the instance name and class name of resource.  */
      XrmValue value;
      char *dummy;
      register char  *option;

      strcpy (iname, class);
      strcat (iname, ".");
      strcat (iname, entry->iname);
      strcpy (cname, CLASS);
      strcat (cname, ".");
      strcat (cname, entry->cname);

      if (XrmGetResource (db, iname, cname, &dummy, &value))
	{
	  if (entry->varp)
	    {
	      *entry->varp = (char *)xmalloc(strlen((char*)value.addr) + 1);
	      strcpy(*entry->varp, (char*)value.addr);
	    }
	}
      else
	{
#ifdef XBACKWARDS
	  if (!(option = XGetDefault (XXdisplay, entry->iname, class)))
	    if (!(option = XGetDefault (XXdisplay, entry->iname, CLASS)))
	      if (!(option = XGetDefault (XXdisplay, entry->cname, class)))
		option = XGetDefault (XXdisplay, entry->cname, CLASS);
#else
	  if (!(option = XGetDefault (XXdisplay, class, entry->iname)))
	    if (!(option = XGetDefault (XXdisplay, CLASS, entry->iname)))
	      if (!(option = XGetDefault (XXdisplay, class, entry->cname)))
		option = XGetDefault (XXdisplay, CLASS, entry->cname);
#endif
	  if (option && entry->varp)
	    {
	      *entry->varp = (char *)xmalloc(strlen(option) + 1);
	      strcpy(*entry->varp, option);
	    }
	}
    }

  /*
   * Now set global variables that aren't character strings; yes it would
   * be nice to do this automatically as part of the scanning step, but this
   * is less likely to screw up.  The real answer is to use the resource
   * manager.
   */

  if (temp_reverseVideo)
    {
      if (strcmp (temp_reverseVideo, "on") == 0)
	reversevideo = 1;
      else if (strcmp (temp_reverseVideo, "off") == 0)
	reversevideo = 0;
    }

  if (temp_borderWidth) 
    XXborder = atoi (temp_borderWidth);

  if (temp_internalBorder)
    XXInternalBorder = atoi (temp_internalBorder);

  if (temp_useBitmap)
    {
      if (strcmp (temp_useBitmap, "on") == 0)
	XXicon_usebitmap = 1;
      else if (strcmp (temp_useBitmap, "off") == 0)
	XXicon_usebitmap = 0;
    }

  return 0;
}

x_error_handler (disp, event)
     Display *disp;
     XErrorEvent *event;
{
  char msg[200];
  XGetErrorText (disp, event->error_code, msg, 200);
  fprintf (stderr, "Fatal X-windows error: %s\n", msg);
  Fkill_emacs (make_number (70));
}

void
x_io_error_handler ()
{
  int save_errno = errno;
  if (errno == EPIPE)
    kill (0, SIGHUP);
  Fdo_auto_save (0);
  errno = save_errno;
  perror ("Fatal X-windows I/O error");
  kill (0, SIGILL);
}

/* 92.10.13 by K.Handa */
x_get_lc_from_arg(arg)
     char *arg;
{
  int lc;
  
  if (strlen(arg) == 0) lc = LCASCII;
  else if (!strcmp(arg, "ltn1")) lc = LCLTN1;
  else if (!strcmp(arg, "ltn2")) lc = LCLTN2;
  else if (!strcmp(arg, "ltn3")) lc = LCLTN3;
  else if (!strcmp(arg, "ltn4")) lc = LCLTN4;
  else if (!strcmp(arg, "grk")) lc = LCGRK;
  else if (!strcmp(arg, "arb")) lc = LCARB;
  else if (!strcmp(arg, "hbw")) lc = LCHBW;
  else if (!strcmp(arg, "kana")) lc = LCKANA;
  else if (!strcmp(arg, "roman")) lc = LCROMAN;
  else if (!strcmp(arg, "crl")) lc = LCCRL;
  else if (!strcmp(arg, "ltn5")) lc = LCLTN5;
  else if (!strcmp(arg, "jpold")) lc = LCJPOLD;
  else if (!strcmp(arg, "cn")) lc = LCCN;
  else if (!strcmp(arg, "jp")) lc = LCJP;
  else if (!strcmp(arg, "kr")) lc = LCKR;
  else if (!strcmp(arg, "jp2")) lc = LCJP2;
  else if (!strcmp(arg, "cns1")) lc = LCCNS1;
  else if (!strcmp(arg, "cns2")) lc = LCCNS2;
  else if (!strcmp(arg, "big5")) lc = LCBIG5_1;
  else return -1;
  return (lc & 0x1F);
}
/* end of patch */

/* 92.12.10 by K.Handa */
/* Set XXlspABOVE, XXlspBELOW, and XXunderline_offset from a string 'str'.
   str -> "a+b", "+b", "a+", or "l",
   where a(bove) and b(elow) defaults to 1 and l defaults to 2.
   It also updates XXfonth, XXfontw, and XXbase. */
x_set_linespace(str)
     char *str;
{
  font_struct *f = &fonts[0];
  char *p;

  if (str == NULL)
    XXlspABOVE = 1, XXlspBELOW = 1;
  else {
    if (p = (char *)index(str, '+')) {
      XXlspABOVE = (p++ == str) ? 1 : atoi(str);
      XXlspBELOW = (*p != '\0') ? atoi(p) : 1;
    } else {
      int ix = atoi(str);
      XXlspABOVE = ix / 2;
      XXlspBELOW = ix - XXlspABOVE;
    }
  }

  XXunderline_offset = 1 + (XXlspBELOW > 0);

  XXfonth = f->fs->ascent + f->fs->descent + XXlspABOVE + XXlspBELOW;
  XXfontw = f->fs->max_bounds.width;
  XXbase = f->fs->ascent + XXlspABOVE - f->yoffset;
}
/* end of patch */

x_term_init ()
{
	register char *vardisplay;
	register int xxargc;
	register char **xxargv;
	char *ptr;
	XColor cdef;

	extern XTinterrupt_signal ();
	extern Lisp_Object Vxterm, Vxterm1, Qt;
	extern int XIgnoreError();
	int  ix;
	

	vardisplay = (alternate_display ? alternate_display : "");
	if (!vardisplay) {
		fprintf (stderr, "DISPLAY environment variable must be set\n");
		exit (-200);
	}

	XXdisplay = XOpenDisplay (vardisplay);
	if (XXdisplay == (Display *) 0) {
		fprintf (stderr, "X server not responding.  Check your DISPLAY environment variable.\n");
		exit (-99);	
	}

	XXscreen = DefaultScreen (XXdisplay);
	XXisColor = DisplayCells (XXdisplay, XXscreen) > 2;
	XXColorMap = DefaultColormap (XXdisplay, XXscreen);

/* 92.12.10 by K.Handa */
	XXboff_atom = XInternAtom(XXdisplay, "_MULE_BASELINE_OFFSET", False);
	XXrcmp = XInternAtom(XXdisplay, "_MULE_RELATIVE_COMPOSE", False);
	XXpixel_size = XInternAtom(XXdisplay, "PIXEL_SIZE", False);
/* end of patch */

	XSetErrorHandler (x_error_handler);
	XSetIOErrorHandler (x_io_error_handler);
	signal (SIGPIPE, x_io_error_handler);

	WindowMapped = 0;
	baud_rate = 9600;
	min_padding_speed = 10000;
	must_write_spaces = 1;
	meta_key = 1;
	visible_bell = 1;
	inverse_video = 0;
	
	fix_screen_hook = xfixscreen;
	clear_screen_hook = XTclear_screen;
	clear_end_of_line_hook = XTclear_end_of_line;
	ins_del_lines_hook = XTins_del_lines;
	change_line_highlight_hook = XTchange_line_highlight;
	insert_chars_hook = XTinsert_chars;
	output_chars_hook = XToutput_chars;
	delete_chars_hook = XTdelete_chars;
	ring_bell_hook = XTfeep;
	reset_terminal_modes_hook = XTreset_terminal_modes;
	set_terminal_modes_hook = XTset_terminal_modes;
	update_begin_hook = XTupdate_begin;
	update_end_hook = XTupdate_end;
	set_terminal_window_hook = XTset_terminal_window;
	read_socket_hook = XTread_socket;
	move_cursor_hook = XTmove_cursor;
	reassert_line_highlight_hook = XTreassert_line_highlight;
	scroll_region_ok = 1;	/* we'll scroll partial screens */
	char_ins_del_ok = 0;
	line_ins_del_ok = 1;	/* we'll just blt 'em */
	fast_clear_end_of_line = 1; /* X does this well */
	memory_below_screen = 0; /* we don't remember what scrolls
				  * 		off the bottom */
	dont_calculate_costs = 1;
	calculate_costs_hook = XTcalculate_costs;

	/* New options section */
	XXborder = 1;
	XXInternalBorder = 1;
	screen_width = 80;
	screen_height = 66;
	
	reversevideo = 0;

	XXdebug = 0;
	XXm_queue_num = 0;
	XXm_queue_in = 0;
	XXm_queue_out = 0;

#if 0
	handler = XIgnoreError;
	XSetErrorHandler (handler);
	XSetIOErrorHandler (handler);
#endif

	desiredwindow =
	XXcurrentfont =
	XXidentity =
	XXicon_name =
	XXheader = (char *) NULL;

	XXicon_usebitmap = 0;
	
	XXfontsizestr = NULL;	/* 92.4.8 by M.Ishisone */
	XXlinespacestr = NULL;	/* 92.9.11 by K.Handa */
/* 91.11.28, 92.8.14, 92.12.10 by K.Handa, 92.10.10.by T.Sakakibara */
	for (ix = 0; ix < 128; ix++) {
	    fonts[ix].name = fonts[ix].opened = NULL;
	    fonts[ix].encoding = -1;
	    xt_fonts[ix] = xt_encoding[ix] = NULL;
	}
/* end of patch */
#ifdef X_DEFAULT_FONT
	temp_font = X_DEFAULT_FONT;
#else
	temp_font = "fixed";
#endif
	progname = xargv[0];
	if (ptr = rindex(progname, '/'))
	  progname = ptr+1;
	XXpid = getpid ();
	default_window = "=80x24+0+0";

#if 0
	handler = XIgnoreError;
	XSetErrorHandler (handler);
	XSetIOErrorHandler (handler);
#endif

	/*  Get resource name and its defaults, it it exists...
	 */
	for (ix = 1; ix < xargc && xargv[ix][0] == '-'; ix++)
	{
	    int  valx;
	
	    if (strcmp(xargv[ix], "-rn") == 0 &&
		(valx = ix + 1) < xargc)
	    {
		XXidentity = (char *) xmalloc (strlen(xargv[valx]) + 1 );
		(void) strcpy(XXidentity, xargv[valx]);

		break;
	    }
	}

	if (!XXidentity)
	{
	    char  *t;

	    if ( (t = getenv("WM_RES_NAME")) != (char *) NULL )
		XXidentity = t;

	    if (!XXidentity)
	    {
		XXidentity = progname;
	    }
	}

	if (XXidentity)
	    XT_GetDefaults(XXidentity);
	else
	    XT_GetDefaults(CLASS);

	XXpid = getpid ();
	default_window = "=80x24+0+0";

	/* Process X command line args...*/
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
		if ((xxargc > 1) && (!strcmp (*xxargv, "-font") ||
				     !strcmp (*xxargv, "-fn"))) {
			xxargc--;
			xxargv++;
			if (XXcurrentfont != NULL)
				free(XXcurrentfont);
			XXcurrentfont = (char *) xmalloc (strlen (*xxargv)+1);
			strcpy (XXcurrentfont, *xxargv);
			xxargc--;
			xxargv++;
		}
/* 91.11.28, 92.8.14, 92.10.13, 93.6.1 by K.Handa */
		else if ((xxargc > 1) && !strncmp (*xxargv, "-fn", 3)) {
		  if ((ix = x_get_lc_from_arg(*xxargv + 3)) >= 0) {
		    fonts[ix].name = (char *)xmalloc (strlen(*(xxargv+1)) + 1);
		    strcpy (fonts[ix].name, *(xxargv+1));
		  }
		  xxargc -= 2;
		  xxargv += 2;
		}
		if ((xxargc > 1) && (!strncmp (*xxargv, "-ecd", 4))) {
		  if ((ix = x_get_lc_from_arg(*xxargv + 4)) >= 0)
		    fonts[ix].encoding = atoi (*(xxargv+1));
		  xxargc -= 2;
		  xxargv += 2;
		}
		if ((xxargc > 1) && !strcmp (*xxargv, "-fs")) {
		  xxargc--;
		  xxargv++;
		  XXfontsizestr = (char *) xmalloc (strlen (*xxargv) + 1);
		  strcpy (XXfontsizestr, *xxargv);
		  xxargc--;
		  xxargv++;
		}
/* 92.9.11 by K.Handa */
		if ((xxargc > 1) && !strcmp (*xxargv, "-lsp")) {
		  xxargc--;
		  xxargv++;
		  XXlinespacestr = (char *) xmalloc (strlen (*xxargv) + 1);
		  strcpy (XXlinespacestr, *xxargv);
		  xxargc--;
		  xxargv++;
		}
/* end of patch */
		if ((xxargc > 1) && !strcmp (*xxargv, "-wn")) {
			xxargc--;
			xxargv++;
			XXheader = (char *) xmalloc (strlen (*xxargv)+1);
			strcpy (XXheader, *xxargv);
			xxargc--;
			xxargv++;
		}
		if ((xxargc > 1) && !strcmp (*xxargv, "-in")) {
			xxargc--;
			xxargv++;
			XXicon_name = (char *) xmalloc (strlen (*xxargv)+1);
			strcpy (XXicon_name, *xxargv);
			xxargc--;
			xxargv++;
		}
		if (xxargc && !strcmp (*xxargv, "-i")) {
			xxargc--;
			xxargv++;
			XXicon_usebitmap = 1;
		}
		if ((xxargc > 1) && !strcmp (*xxargv, "-b")) {
			xxargc--;
			xxargv++;
			XXborder = atoi (*xxargv);
			xxargc--;
			xxargv++;
		}
		if ((xxargc > 1) && !strcmp (*xxargv, "-ib")) {
			xxargc--;
			xxargv++;
			XXInternalBorder = atoi (*xxargv);
			xxargc--;
			xxargv++;
		}
		if ((xxargc > 1) && (!strcmp (*xxargv, "-w") ||
				     !strcmp (*xxargv, "-geometry"))) {
			xxargc--;
			xxargv++;
			desiredwindow = (char *) xmalloc (strlen (*xxargv)+1);
			strcpy (desiredwindow, *xxargv);
			xxargc--;
			xxargv++;
		}
		if (XXisColor) {
			if ((xxargc > 1 && !strcmp (*xxargv, "-fg"))) {
			        xxargc--;
			        xxargv++;

			        fore_color =
				    (char *) xmalloc (strlen (*xxargv)+1);
			        strcpy (fore_color, *xxargv);

				xxargc--;
				xxargv++;
			}
			if ((xxargc > 1 && !strcmp (*xxargv, "-bg"))) {
			        xxargc--;
			        xxargv++;

				back_color =
				    (char *) xmalloc (strlen (*xxargv)+1);
				strcpy (back_color, *xxargv);

				xxargc--;
				xxargv++;
			}
			if ((xxargc > 1 && !strcmp (*xxargv, "-bd"))) {
				xxargc--;
				xxargv++;

				brdr_color =
				    (char *) xmalloc (strlen (*xxargv)+1);
				strcpy (brdr_color, *xxargv);

				xxargc--;
				xxargv++;
			}
			if ((xxargc > 1 && !strcmp (*xxargv, "-cr"))) {
				xxargc--;
				xxargv++;

				curs_color =
				    (char *) xmalloc (strlen (*xxargv)+1);
				strcpy (curs_color, *xxargv);

				xxargc--;
				xxargv++;
			}
			if ((xxargc > 1 && !strcmp (*xxargv, "-ms"))) {
				xxargc--;
				xxargv++;

				mous_color =
				    (char *) xmalloc (strlen (*xxargv)+1);
				strcpy (mous_color, *xxargv);

				xxargc--;
				xxargv++;
			}
		}
		if (sargc == xxargc) {
			xxargc--;
			xxargv++;
		}
	}

	/*  Now, actually Parse and Set colors...
	 */
	if (XXisColor) {
	  if (fore_color || back_color)
	    reversevideo = 0;
	  if (fore_color &&
	      XParseColor (XXdisplay, XXColorMap, fore_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    fore = cdef.pixel;
	  else {
	    fore_color = black_color;
	    fore = BlackPixel (XXdisplay, XXscreen);
	  }

	  if (back_color &&
	      XParseColor (XXdisplay, XXColorMap, back_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    back = cdef.pixel;
	  else {
	    back_color = white_color;
	    back = WhitePixel (XXdisplay, XXscreen);
	  }

	  if (curs_color &&
	      XParseColor (XXdisplay, XXColorMap, curs_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    curs = cdef.pixel;
	  else {
	    curs_color = black_color;
	    curs = BlackPixel (XXdisplay, XXscreen);
	  }

	  if (mous_color &&
	      XParseColor (XXdisplay, XXColorMap, mous_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    ;
	  else mous_color = black_color;

	  if (brdr_color &&
	      XParseColor (XXdisplay, XXColorMap, brdr_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    brdr = cdef.pixel;
	  else {
	    brdr_color = black_color;
	    brdr = BlackPixel (XXdisplay, XXscreen);
	  }

	  /* 93.4.13 by K.Handa */
	  r2l_color = "gray80";
	  if (XParseColor (XXdisplay, XXColorMap, r2l_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    r2l = cdef.pixel;
	  else {
	    r2l_color = "white";
	    r2l = WhitePixel (XXdisplay, XXscreen);
	  }
	  r2l_rev_color = "gray60";
	  if (XParseColor (XXdisplay, XXColorMap, r2l_rev_color, &cdef) &&
	      XAllocColor (XXdisplay, XXColorMap, &cdef))
	    r2l_rev = cdef.pixel;
	  else {
	    r2l_rev_color = "black";
	    r2l_rev = BlackPixel (XXdisplay, XXscreen);
	  }
	  /* end of patch */
	}
	else {
		fore_color  = curs_color = mous_color = brdr_color
		  = black_color;
		fore = curs = brdr = BlackPixel (XXdisplay, XXscreen);
		back_color = white_color;
		back = WhitePixel (XXdisplay, XXscreen);
		/* 93.4.13 by K.Handa */
		r2l_color = back_color, r2l = back;
		r2l_rev_color = fore_color, r2l_rev = fore;
		/* end of patch */
	}


	if (reversevideo) {
		unsigned Lisp_Object_Int tempcolor;
		char *tempname;
		brdr = back;
		brdr_color = back_color;
		tempcolor = fore;
		fore = back;
		back = tempcolor;
		tempname = fore_color;
		fore_color = back_color;
		back_color = tempname;
		/* 93.4.14 by K.Handa */
		tempcolor = r2l;
		r2l = r2l_rev;
		r2l_rev = tempcolor;
		tempname = r2l_color;
		r2l_color = r2l_rev_color;
		r2l_rev_color = tempname;
		/* end of patch */
		if (!strcmp (mous_color, back_color))
		  mous_color = fore_color;
		else if (!strcmp (mous_color, fore_color))
		  mous_color = back_color;
		if (!strcmp (curs_color, back_color))
		  curs_color = fore_color, curs = fore;
		else if (!strcmp (curs_color, fore_color))
		  curs_color = back_color, curs = back;
	}

/* 92.8.13, 92.10.11, 93.6.1 by K.Handa */
#ifndef CANNOT_DUMP
	if (!initialized)
#endif /* CANNOT_DUMP */
	  {
	    Vx_default_fonts = Fmake_vector (128, Qnil);
	    Vx_default_encoding = Fmake_vector (128, Qnil);
	  }
	for (ix = 0; ix < 128; ix++) {
	  if (xt_fonts[ix] != NULL)
	    XVECTOR (Vx_default_fonts)->contents[ix]
	      = build_string (xt_fonts[ix]);
	  if (xt_encoding[ix] != NULL)
	    XVECTOR (Vx_default_encoding)->contents[ix]
	      = make_number (atoi (xt_encoding[ix]));
	}
	if (!XXcurrentfont) {
	  Lisp_Object val = XVECTOR (Vx_default_fonts)->contents[0];
	  if (XTYPE (val) == Lisp_String) {
	    XXcurrentfont = (char *)xmalloc (XSTRING (val)->size + 1);
	    strcpy (XXcurrentfont, XSTRING (val)->data);
	  }
	}

	if (!XXcurrentfont)
	{
	    XXcurrentfont = (char *) xmalloc (strlen (temp_font) + 1);
	
	    if (!XXcurrentfont) {
		fprintf (stderr, "Memory allocation failure.\n");
		exit (-150);
	    }

	    strcpy (XXcurrentfont, temp_font);
	}
	fonts[0].name = XXcurrentfont;

/* 92.9.11, 92.12.10, 92.12.31 by K.Handa */
        if (XXfontsizestr == NULL
            || ((XXfontsize = (unsigned int)atoi(XXfontsizestr)) > 100))
          XXfontsize = 0;
/* end of patch */

	signal (SIGPIPE, XExitGracefully);

#ifndef CANNOT_DUMP
	if (initialized)
#endif /* CANNOT_DUMP */
		Vxterm = Qt;

	Fset (intern ("window-system-version"), make_number (11));

	XInitWindow ();

	keyboard_init_hook = x_init_1;
}

/* Initialize for keyboard input using X.
   This is called by init_keyboard via keyboard_init_hook.  */

static void
x_init_1 ()
{
#ifdef F_SETOWN
	extern int old_fcntl_owner;
#endif
#if defined(F_SETFL) && defined(FASYNC)
	extern int old_fcntl_flags;
#endif

	dup2 (ConnectionNumber(XXdisplay), 0);
#ifndef SYSV_STREAMS
	/* Streams somehow keeps track of which descriptor number
	   is being used to talk to X.  So it is not safe to substitute
	   descriptor 0.  But it is safe to make descriptor 0 a copy of it.  */
	close (ConnectionNumber(XXdisplay));
	ConnectionNumber(XXdisplay) = 0;	/* Looks a little strange?
						 * check the def of the macro;
						 * it is a genuine lvalue */
#endif

#ifdef USG
	setpgrp ();		/* No arguments but equivalent in this case */
#else
	setpgrp (0, getpid ());
#endif /* USG */
	
#ifdef F_SETOWN
	old_fcntl_owner = fcntl (0, F_GETOWN, 0);
#ifdef F_SETOWN_SOCK_NEG
	fcntl (0, F_SETOWN, -getpid ());	/* stdin is a socket here */
#else
	fcntl (0, F_SETOWN, getpid ());
#endif /* F_SETOWN_SOCK_NEG */
#endif /* F_SETOWN */
#if defined(F_SETFL) && defined(FASYNC)
	/*
	 * Since libxcb sets O_NONBLOCK, copy the bit so that it won't
	 * dropped by unrequest_sigio().
	 */
	old_fcntl_flags = fcntl (0, F_GETFL, 0) & ~FASYNC;
#endif

	/* Enable interrupt_input because otherwise we cannot asynchronously
	   detect C-g sent as a keystroke event from the X server.  */
	Fset_input_mode (Qt, Qnil, Qnil);
}

XSetFlash ()
{
	ring_bell_hook = XTflash;
}

XSetFeep ()
{
	ring_bell_hook = XTfeep;
}

/* 92.1.14 by K.Handa */
static char work[256];	/* 92.3.21 by T.Sakakibara, 92.6.27 by A.Tanaka  */

/* 92.8.11 by K.Handa - Returns original string if we can't set size. */
char *
MCSetFontSize (str)
     char *str;
{				/* 92.12.9 by K.Handa */
  char *p;

  p = str;
  while (*p)
    if (*p++ == '-' && *p == '-') break;
  if (*p++ && *p == '*') {	/* We can set font size! */
    strncpy(work, str, p - str);
    /* 92.12.31 by K.Handa */
    sprintf(work + (p - str), "%d%s", XXfontsize, p + 1);
    return work;
  }
  return str;			/* 92.8.11 by K.Handa */
}
/* end of patch */

/* ------------------------------------------------------------
 *  Load a font by name.  Return the font pointer, or NULL if
 *  it can't be loaded.  Do all appropriate calculations.
 *  This function is used only for ASCII font.  Other fonts
 *  are loaded by MCLoadFont().
 */
static XFontStruct *
XT_CalcForFont(fontname)
    char  *fontname;
{
    char *str = fontname;	/* 92.4.8 by M.Ishisone, 92.8.14 by K.Handa */
    unsigned long value;	/* 92.12.10 by K.Handa */
    XFontStruct  *fontp;

    if (XXfontsize)		/* 92.1.14 by K.Handa, 92.4.8 by M.Ishisone */
      str = MCSetFontSize(fontname); /* 92.8.11 by K.Handa */
    if ( (fontp = XLoadQueryFont(XXdisplay, str)) == (XFontStruct *) 0) {
      if (str == fontname
	  || (str = fontname,
	      (fontp = XLoadQueryFont(XXdisplay, str)) == (XFontStruct *) 0))
	return  (XFontStruct *) NULL;
    }

    XXfid = fontp->fid;
/* 92.9.11 by K.Handa */
    fonts[0].encoding = 0;
    fonts[0].fs = fontp;
/* 91.11.29, 92.8.14, 92.12.10 by K.Handa */
    fonts[0].yoffset = 
      XGetFontProperty(fontp, XXboff_atom, &value) ? - (long)value : 0;
    fonts[0].relative_compose =
      XGetFontProperty(fontp, XXrcmp, &value) ? value : 0;
    x_set_linespace(XXlinespacestr);
    /* get font size */
    if (XGetFontProperty(fontp, XXpixel_size, &value))
      XXfontsize = value;
    else
      /* simple estimation */
      XXfontsize = fontp->ascent + fontp->descent;
/* 92.12.10 by K.Handa */
    if (fonts[0].name)		/* 93.6.30 by K.Handa */
      free(fonts[0].name);
    fonts[0].name = (char *) xmalloc (strlen(fontname) + 1);
    strcpy(fonts[0].name, fontname);
    XXcurrentfont = fonts[0].name;
    if (fonts[0].opened) free(fonts[0].opened);
    /* 93.4.30 by K.Handa */
    if (XGetFontProperty(fontp, XA_FONT, &value))
      str = XGetAtomName(XXdisplay, value);
    else
      str = fonts[0].name;
    fonts[0].opened = (char *) xmalloc (strlen(str) + 1);
    strcpy(fonts[0].opened, str);
    if (str != fonts[0].name)
      XFree(str);
/* end of patch */
    return  fontp;
}


/* ------------------------------------------------------------
 */
XNewFont (newname)
     register char *newname;
{
	XFontStruct *temp;
	BLOCK_INPUT_DECLARE ();

	BLOCK_INPUT ();
	XFlush (XXdisplay);


	temp = XT_CalcForFont(newname);

	if (temp == (XFontStruct *) NULL)
	{
	    UNBLOCK_INPUT ();
	    return  -1;
	}

	XSetFont (XXdisplay, XXgc_norm, XXfid);
	XSetFont (XXdisplay, XXgc_rev, XXfid);
	XSetFont (XXdisplay, XXgc_curs, XXfid);
	XSetFont (XXdisplay, XXgc_curs_rev, XXfid);

	XFreeFont (XXdisplay, fontinfo);
	fontinfo = temp;

	XSetWindowSize(screen_height, screen_width);


	UNBLOCK_INPUT ();
	return 0;
}

/* 92.12.10 by K.Handa */
x_set_fontname(lc)
     unsigned int lc;
{
  Lisp_Object val = XVECTOR (Vx_default_fonts)->contents[lc];
  if (XTYPE (val) == Lisp_String) {
    fonts[lc].name = (char *)xmalloc (XSTRING (val)->size + 1);
    strcpy (fonts[lc].name, XSTRING (val)->data);
  }
}

/* 93.6.25 by K.Handa */
x_set_encoding(lc)
     unsigned int lc;
{
  Lisp_Object val = XVECTOR (Vx_default_encoding)->contents[lc];
  if (XTYPE (val) == Lisp_Int)
    fonts[lc].encoding = XINT (val);
  else
    fonts[lc].encoding = 0;
}

/* ------------------------------------------------------------
 * Load font for multilingual character and return its FID.
 */
/* 92.8.11 by K.Handa - If font not found, use ASCII font instead. */
/* 92.11.11 by K.Handa - Return (XFontStruct *) */
/* 93.6.25 by K.Handa - Info of ASCII font is always updated for no-font lc. */
XFontStruct *
MCLoadFont(lc)
     register unsigned int lc;
{
  register unsigned int lc1;
  XFontStruct *fs;
  unsigned long value;		/* 92.12.10 by K.Handa */
  char *str;

  if (lc == LCBIG5_2) lc = LCBIG5_1;
  lc1 = lc & 0x7F;
  if (fonts[lc1].fs) {
    if (fonts[lc1].opened) return fonts[lc1].fs;
    goto use_ascii_font;	/* Font not */
  }
  if (fonts[lc1].name == NULL)  /* 92.10.13, 92.12.10 by K.Handa */
    x_set_fontname(lc1);
  if (fonts[lc1].name == NULL)
    goto use_ascii_font;
  if (fonts[lc1].encoding < 0)	/* 93.6.25 by K.Handa */
    x_set_encoding(lc1);

  str = MCSetFontSize(fonts[lc1].name);
  if ((fs = XLoadQueryFont(XXdisplay, str)) == (XFontStruct *)NULL
      && (str == fonts[lc1].name
	  || (str = fonts[lc1].name,
	      fs = XLoadQueryFont(XXdisplay, str)) == (XFontStruct *)NULL))
    /* Font not found, use ASCII font instead. */
    goto use_ascii_font;

  fonts[lc1].fs = fs;
  /* 92.12.10 by K.Handa */
  if (fonts[lc1].opened)
    free(fonts[lc1].opened);
  /* 93.4.30 by K.Handa */
  if (XGetFontProperty(fs, XA_FONT, &value))
    str = XGetAtomName(XXdisplay, value);
  else
    str = fonts[lc1].name;
  fonts[lc1].opened = (char *) xmalloc (strlen(str) + 1);
  strcpy(fonts[lc1].opened, str);
  if (str != fonts[lc1].name)
      XFree(str);
  /* end of patch */
  if (char_type[lc] == TYPE94N || char_type[lc] == TYPE96N)
    fonts[lc1].yoffset = XXfonth - XXbase - XXlspBELOW - fs->descent;
  else
    fonts[lc1].yoffset =
      XGetFontProperty(fs, XXboff_atom, &value) ? - (long)value : 0;
  fonts[lc1].relative_compose =
    XGetFontProperty(fs, XXrcmp, &value) ? value : 0;
  if (lc == LCBIG5_1) {
    /* Check encoding of fonts (ETen or HKU) by examining existence of
       character 50849 (C6A1).
       Thanks to ishisone@sra.co.jp	for telling me how to do it. */
#define HKU_CHAR 0xC6A1
    int chars_in_a_row = fs->max_char_or_byte2 - fs->min_char_or_byte2 + 1;
    int high = HKU_CHAR / 0xFF - fs->min_byte1;
    int low = HKU_CHAR % 0xFF - fs->min_char_or_byte2;
    XCharStruct *csp
      = fs->per_char ? fs->per_char + high * chars_in_a_row + low
	: (XCharStruct *)0;
    fonts[lc1].encoding =
      (csp && (csp->lbearing || csp->rbearing || csp->width
	       || csp->ascent || csp->descent)) ? 2 : 1;
    fonts[LCBIG5_2 & 0x7F] = fonts[lc1]; /* 93.5.10 by K.Handa */
  } else if (fs->min_byte1 != 0 || fs->max_byte1 != 0)
      /* 93.4.22 by T.Atsushiba
	 Use max_char_or_byte2 instead of min_char_or_byte2. */
      fonts[lc1].encoding = (fs->max_char_or_byte2 >= 0x80);

  return fonts[lc1].fs;

 use_ascii_font:
  fonts[lc1].fs = fonts[0].fs;
  fonts[lc1].encoding = fonts[0].encoding;
  fonts[lc1].yoffset = fonts[0].yoffset;
  fonts[lc1].relative_compose = fonts[0].relative_compose;
  if (fonts[lc1].opened) {
    free(fonts[lc1].opened);
    fonts[lc1].opened = NULL;
  }
  return fonts[lc1].fs;
}

/* 92.9.11 by K.Handa */
MCNewFont (newname, lc, encoding)
     register char *newname;
     register unsigned char lc, encoding;
{
  BLOCK_INPUT_DECLARE ();

  BLOCK_INPUT ();
  XFlush (XXdisplay);

#define TEMPLC (LCINV & 0x7F)
  fonts[TEMPLC].fs = NULL;
  fonts[TEMPLC].name = newname;
  fonts[TEMPLC].encoding = encoding;
  fonts[TEMPLC].opened = NULL;	/* 92.12.10 by K.Handa */

  MCLoadFont(LCINV);		/* 93.4.30 by K.Handa */
  if (!fonts[TEMPLC].opened) {
    UNBLOCK_INPUT ();
    return -1;
  }
  lc &= 0x7F;
  if (fonts[lc].opened) {	/* 93.7.15 by K.Handa */
    XFreeFont (XXdisplay, fonts[lc].fs);
    free (fonts[lc].opened);
  }
  if (fonts[lc].name)
    free (fonts[lc].name);
  fonts[lc] = fonts[TEMPLC];
/* 93.5.7 by K.Handa */
  if (lc != LCBIG5_1 && lc != LCBIG5_2
      && (fonts[lc].fs->min_byte1 != 0 || fonts[lc].fs->max_byte1 != 0))
    fonts[lc].encoding = encoding;
/* end of patch */

  UNBLOCK_INPUT ();
  return 0;
}
/* end of patch */

/* Flip foreground/background colors */

XFlipColor ()
{
	Lisp_Object_Int tempcolor;
	char *tempname;
	XColor forec, backc;
	BLOCK_INPUT_DECLARE ();

	BLOCK_INPUT ();
	CursorToggle ();
	XSetWindowBackground(XXdisplay, XXwindow, fore);
	if (XXborder)
		XSetWindowBorder(XXdisplay, XXwindow, back);

	brdr = back;
	brdr_color = back_color;
	tempcolor = fore;
	fore = back;
	back = tempcolor;
	tempname = fore_color;
	fore_color = back_color;
	back_color = tempname;
	XClearArea (XXdisplay, XXwindow, 0, 0,
		    screen_width*XXfontw+2*XXInternalBorder,
		    screen_height*XXfonth+2*XXInternalBorder, 0);

	XXgc_temp = XXgc_norm;
	XXgc_norm = XXgc_rev;
	XXgc_rev = XXgc_temp;
	/* 93.4.13 by K.Handa */
	XXgc_temp = XXgc_r2l;
	XXgc_r2l = XXgc_r2l_rev;
	XXgc_r2l_rev = XXgc_temp;
	/* end of patch */

	if (!strcmp (mous_color, back_color))
	  mous_color = fore_color;
	else if (!strcmp (mous_color, fore_color))
	  mous_color = back_color;

	x_set_cursor_colors ();

	XRedrawDisplay ();
	if (!strcmp (curs_color, back_color))
	  curs_color = fore_color, curs = fore;
	else if (!strcmp (curs_color, fore_color))
	  curs_color = back_color, curs = back;

	XSetState (XXdisplay, XXgc_curs, back, curs, GXcopy, AllPlanes);
	XSetState (XXdisplay, XXgc_curs_rev, curs, back, GXcopy, AllPlanes);

	CursorToggle ();
	XFlush (XXdisplay);
	UNBLOCK_INPUT ();
}

/* ------------------------------------------------------------
 */

#define NO_MANAGER  1


/* ------------------------------------------------------------
 */
static XClassHint  class_hint;


static int
XT_Set_Class_Hints(w)
    Window  w;
{

    if (XXidentity == (char *) NULL)
	XXidentity = "";	/* XSCH() doesn't like NULL pointers! */

    class_hint.res_name = XXidentity;
    class_hint.res_class = CLASS;

	
    XSetClassHint(XXdisplay, w, &class_hint);
}


/* ------------------------------------------------------------
 */
static int
XT_Set_Command_Line(w)
    Window  w;
{

    XSetCommand(XXdisplay, w, xargv, xargc);
}


/* ------------------------------------------------------------
 */
static char  hostname[100];

static int
XT_Set_Host(w)
    Window  w;
{

    gethostname(hostname, 100);
    hostname[99] = '\0';

    XChangeProperty(XXdisplay, w, XA_WM_CLIENT_MACHINE, XA_STRING, 8,
		    PropModeReplace,
		    (unsigned char *) hostname, strlen(hostname));
}


/* ------------------------------------------------------------
 *  Set header title to window-name (from '-wn'), or if none,
 *  "optional-id: class-of-appl @ host"
 */
static int
XT_Set_Title(w)
    Window  w;
{
    char  header_info[200];


    if (XXheader != (char *) NULL)
    {
	    strcpy(header_info, XXheader);
    }
    else
    {
	char  *next;

	next = header_info;
	
	if (strlen(class_hint.res_name) != 0)
	{
	    sprintf(header_info, "%s: ",
		    class_hint.res_name);
	
	    next += strlen(header_info);
	}
	
	sprintf(next, "%s @ %s",
		class_hint.res_class,
		hostname);
    }


    XStoreName(XXdisplay, w, header_info);
}


/* ------------------------------------------------------------
 *  Set icon title to icon-name (from '-in'),
 *  or if none, to "invocation-or-class @ host".
 *
 */
static int
XT_Set_Icon_Title(w)
    Window  w;
{
    char  title_info[100];

    if (XXicon_name != (char *) NULL)
    {
	    strcpy(title_info, XXicon_name);
    }
    else
    {
	if (strlen(class_hint.res_name) != 0)
	{
	    sprintf(title_info, "%s@", class_hint.res_name);
	}
	else
	{
	    sprintf(title_info, "%s@", class_hint.res_class);
	}

	strcat(title_info, hostname);
    }


    XChangeProperty(XXdisplay, w, XA_WM_ICON_NAME, XA_STRING, 8,
		    PropModeReplace,
		    (unsigned char *) title_info, strlen(title_info));
}


/* Arg PR carries value returned by XGeometry at startup, or 0.  */

static int
XT_Set_Size_Hints(w, x, y, width, height, do_resize, pr)
    int  x, y;			/* only used at Startup: do_resize == FALSE */
    int  width, height;
    Window  w;
    Bool  do_resize;
    int pr;
{
#ifndef X11R4
    XSizeHints  sizehints;

    sizehints.flags = (pr & (WidthValue | HeightValue)) ? USSize : PSize;

    if (!do_resize)
      sizehints.flags |= (pr & (XValue | YValue)) ? USPosition : PPosition;

    sizehints.flags |= PResizeInc|PMinSize;


    sizehints.x = x;
    sizehints.y = y;
    sizehints.width = width*XXfontw + 2 * XXInternalBorder;
    sizehints.height = height*XXfonth + 2 * XXInternalBorder;

    pixelwidth = sizehints.width;
    pixelheight = sizehints.height;
    flexlines = height;


    change_screen_size (height, width, 0 - (do_resize == False), 0, 0);

    sizehints.width_inc = XXfontw;
    sizehints.height_inc = XXfonth;

    sizehints.min_width = XXfontw*MINWIDTH+2*XXInternalBorder;
    sizehints.min_height = XXfonth*MINHEIGHT+2*XXInternalBorder;

#if 0
    /* old, broken versions */
    sizehints.min_width = 3 * XXInternalBorder;
    sizehints.min_height = 3 * XXInternalBorder;
#endif

    XSetNormalHints(XXdisplay, w, &sizehints);

    if (do_resize)
    {
	XResizeWindow(XXdisplay, XXwindow, pixelwidth, pixelheight);
	XFlush(XXdisplay);
    }
#else /* not X11R4 */
    XSizeHints sizehints;
    XWindowChanges changes;
    unsigned int change_mask = 0;
    
    sizehints.flags = 0;
    
    if (! do_resize) {
	 changes.x = x;
	 changes.y = y;
	 sizehints.flags |= (pr & (XValue | YValue)) ? USPosition : PPosition;
	 change_mask |= CWX | CWY;
    }

    sizehints.base_width = 2 * XXInternalBorder;
    sizehints.base_height = 2 * XXInternalBorder;
    changes.width = sizehints.base_width + width * XXfontw;
    changes.height = sizehints.base_height + height * XXfonth;
    sizehints.flags |= ((pr & (WidthValue | HeightValue)) ? USSize : PSize) |
	 PBaseSize;

    /* If user has specified precise position, ... */
    if ((pr & XValue) || (pr & YValue))
      {
	sizehints.flags |= USSize | USPosition | PWinGravity;
	/* Tell window manager which corner to keep fixed.  */
	switch (pr & (XNegative | YNegative))
	  {
	  case 0:
	    sizehints.win_gravity = NorthWestGravity;
	    break;
	  case XNegative:
	    sizehints.win_gravity = NorthEastGravity;
	    break;
	  case YNegative:
	    sizehints.win_gravity = SouthWestGravity;
	    break;
	  default:
	    sizehints.win_gravity = SouthEastGravity;
	    break;
	  }
      }

    change_mask |= CWWidth | CWHeight;
    
    /*
     * NOTE: The sizehints.x, sizehints.y, sizehints.width and
     * sizehints.height fields are OBSOLETE according to the ICCC, and
     * no window manager should be considering them, even if USSize/PSize
     * and/or USPosition/PPosition are set.  Unfortunately, many
     * window managers consider them anyway, and programs like xprop
     * display their values when fetching the normal hints property
     * from the window.  Therefore, I set them here just to make
     * things a little bit more robust.
     */
    if (! do_resize) {
	 sizehints.x = x;
	 sizehints.y = y;
    }
    sizehints.width = changes.width;
    sizehints.height = changes.height;

    pixelwidth = sizehints.base_width;
    pixelheight = sizehints.base_height;
    flexlines = height;

    change_screen_size (height, width, 0 - (do_resize == False), 0, 0);

    sizehints.min_width = XXfontw * MINWIDTH + 2 * XXInternalBorder;
    sizehints.min_height = XXfonth * MINHEIGHT + 2 * XXInternalBorder;
    sizehints.flags |= PMinSize;

    sizehints.width_inc = XXfontw;
    sizehints.height_inc = XXfonth;
    sizehints.flags |= PResizeInc;

    XSetWMNormalHints(XXdisplay, w, &sizehints);
    XConfigureWindow(XXdisplay, w, change_mask, &changes);
#endif /* not X11R4 */
}


/* ------------------------------------------------------------
 */
/*ARGSUSED*/
static int
XT_Set_Zoom_Sizes(w)
    Window  w;
{
}


/* ------------------------------------------------------------
 *  Set our state and icon parameters.
 */
static int
XT_Set_WM_Hints(w)
    Window  w;
{
    XWMHints  wmhints;

    wmhints.flags = InputHint | StateHint;
    if (XXicon_usebitmap)
	    wmhints.flags |= IconPixmapHint | IconMaskHint;

    wmhints.input = True;
    wmhints.initial_state = NormalState;

    SinkPixmap = XCreateBitmapFromData (XXdisplay, w,
					sink_bits, sink_width,
					sink_height);

    SinkMaskPixmap = XCreateBitmapFromData (XXdisplay, w,
					    sink_mask_bits,
					    sink_mask_width,
					    sink_mask_height);

    if (XXicon_usebitmap) {
	    wmhints.icon_pixmap = SinkPixmap;
	    wmhints.icon_mask = SinkMaskPixmap;
    }
    else {
	    wmhints.icon_pixmap = 0;
	    wmhints.icon_mask = 0;
    }

    XSetWMHints(XXdisplay, w, &wmhints);
}


/* ------------------------------------------------------------
 *  Change just the size of the window.
 */
XSetWindowSize(rows, cols)
    int rows, cols;
{
    XT_Set_Size_Hints(XXwindow, 0, 0, cols, rows, NO_MANAGER, 0);
}

/* ------------------------------------------------------------
 * Draw multilingual text.
 */
typedef struct {		/* 92.11.27 by K.Handa */
  XChar2b ch;
  int y;
  XFontStruct *fs;
} MCCompositeChar;

typedef struct {		/* 92.11.10 by K.Handa */
  XChar2b *chars;
  int nchars, x, y, char_width;
  XFontStruct *fs;
  GC gc, gc_back;		/* 92.3.18 by K.Handa */
  unsigned char attribute;	/* 92.3.18 by K.Handa */
  MCCompositeChar *cmp;		/* 92.11.27 by K.Handa */
}  MCTextItem16;

/* 92.11.27 by K.Handa */
#define MAX_CMP_CHARS 16

#define MCGetCSP(fs, byte1, byte2) \
  (fs->per_char \
   ? fs->per_char + byte2 - fs->min_char_or_byte2 \
     + ((fs->min_byte1 || fs->max_byte1) \
	? (byte1 - fs->min_byte1) * \
	  (fs->max_char_or_byte2 - fs->min_char_or_byte2 + 1) \
	: 0) \
   : NULL)

unsigned char *
MCSetChar(p, fsp, charp)
     unsigned char *p;
     XFontStruct **fsp;
     XChar2b *charp;
{
  unsigned char lc, c1, c2, bytes;

  if (lc = *p++ - 0xA0) lc |= 0x80;
  bytes = char_bytes[lc];
  if (lc >= LCPRV11 && lc <= LCPRV22)
    lc = *p++, bytes--;
  c1 = bytes >= 3 ? *p++ : 0;
  c2 = *p++;
  if (!(*fsp = fonts[lc & 0x7F].fs)) *fsp = MCLoadFont(lc);
  MCSetXChar2b(lc, c1, c2, charp, fsp);
  return p;
}

MCSetXChar2b(lc, c1, c2, charp)
     unsigned char lc, c1, c2;
     XChar2b *charp;
{
  if (XVECTOR (Vx_ccl_programs)->contents[lc & 0x7F] != Qnil) {
    coding_type mccode;
    unsigned char src[2], dst[2 + CONV_BUF_EXTRA];
    int n;

    CODE_CNTL (&mccode) = 0;
    CODE_CCL_DECODE (&mccode) =
      XVECTOR (Vx_ccl_programs)->contents[lc & 0x7F];
    if (c1)
      n = 2, src[0] = c1, src[1] = c2;
    else
      n = 1, src[0] = c2;
    n = ccl_driver(src, dst, n, sizeof dst, &mccode, 0);
    if (n > 1)
      charp->byte1 = dst[0], charp->byte2 = dst[1];
    else
      charp->byte1 = 0, charp->byte2 = dst[0];
  } else if (lc == LCBIG5_1 || lc == LCBIG5_2) {
    G2B(lc, c1, c2, fonts[lc & 0x7F].encoding == 1,
	charp->byte1, charp->byte2);
  } else {
    int mask = fonts[lc & 0x7F].encoding ? 0xFF : 0x7F;
    charp->byte1 = c1 & mask, charp->byte2 = c2 & mask;
  }
}
/* end of patch */

MCDrawText(display, window, gc, x, y, lp, count)
     Display *display;
     Drawable window;
     GC gc;
     unsigned int *lp;
     int x, y, count;
{
  /* 92.11.10 by K.Handa -- Big change for composite character. */

  MCTextItem16 *items, *item, *enditem;
  MCCompositeChar *cmp;
  XChar2b *chars;
  int i, j, xx, *ncharsp;
  unsigned int lc0 = 0xFF, lc1, mask;
  register unsigned char c1, c2, attr0 = 0xFF, attr1;
  GC gc_back =			/* 92.3.19, 93.4.13 by K.Handa */
    gc == XXgc_norm ? XXgc_rev : gc == XXgc_rev ? XXgc_norm : XXgc_curs_rev;
  GC gc_r2l =
    gc == XXgc_norm ? XXgc_r2l : XXgc_r2l_rev;
  GC gc_r2l_rev =
    gc == XXgc_norm ? XXgc_r2l_rev : XXgc_r2l;

  if ((items = (MCTextItem16 *)alloca((sizeof *items) * count)) == NULL)
    memory_full();
  if ((chars = (XChar2b *)alloca((sizeof *chars) * count)) == NULL)
    memory_full();

  /* Pack text in an array at first */
  j = 0;
  item = items;
  for (i = 0; i < count; i++) {
    if (!MTRX_ORDER(*lp)) {
      if (MTRX_CMPCHAR(*lp)) {
	unsigned char *p = MTRX_CMPPTR(*lp);
	int highest, lowest, char_count;
	XCharStruct *csp;

	item->attribute = *p++ & 0x7F;
	if (lc0 = *p - 0xA0) lc0 |= 0x80;
	if (lc0 >= LCPRV11 && lc0 <= LCPRV22)
	  lc0 = *(p + 1);
	item->nchars = 1;
	item->char_width = char_width[lc0];
	item->x = x + XXfontw * i;
	item->y = y + fonts[lc0 & 0x7F].yoffset;
	if (item->attribute & MTRX_INVERSE2)
	  item->gc = gc_back, item->gc_back = gc;
	else
	  item->gc = gc, item->gc_back = gc_back;
	item->chars = chars + j++;
	p = MCSetChar(p, &item->fs, item->chars);
	if (fonts[lc0 & 0x7F].relative_compose /* 93.5.29 by K.Handa */
	    && (csp = MCGetCSP(item->fs,
			       item->chars->byte1, item->chars->byte2))) {
	  highest = max (csp->ascent, fonts[lc0 & 0x7F].relative_compose);
	  lowest = max (csp->descent, 0);
	}
#ifdef IRIX
	{
	  MCCompositeChar *wk;
	  wk = (MCCompositeChar *)alloca((sizeof *cmp) * MAX_CMP_CHARS);
	  item->cmp = wk;
	}
#else
	item->cmp =
	  (MCCompositeChar *)alloca((sizeof *cmp) * MAX_CMP_CHARS);
#endif
	cmp = item->cmp;
	char_count = 1;
	while (char_count++ < MAX_CMP_CHARS && *p) { /* 93.3.4 by K.Handa */
	  p = MCSetChar(p, &cmp->fs, &cmp->ch);
	  cmp->y = item->y;
	  if (fonts[lc0 & 0x7F].relative_compose) {
	    csp = MCGetCSP(cmp->fs, cmp->ch.byte1, cmp->ch.byte2);
	    if (csp) {
	      if (- csp->descent >= fonts[lc0 & 0x7F].relative_compose) {
		cmp->y -= highest + csp->descent;
		highest += csp->ascent + csp->descent;
	      } else if (csp->ascent <= 0) {
		cmp->y += lowest + csp->ascent;
		lowest += csp->ascent + csp->descent;
	      }
	    }
	  }
	  cmp++;
	}
	cmp->fs = NULL;
	lc0 = 0xFF;
	item++;
      } else {
	MTRX_DECOMPOSE(*lp,attr1,lc1,c1,c2);
	if (lc0 != lc1 || attr0 != attr1) {
	  lc0 = lc1; attr0 = attr1;
	  item->chars = chars + j;
	  item->nchars = 0;
	  ncharsp = &item->nchars;
	  item->char_width = char_width[lc0];
	  item->x = x + XXfontw * i;
	  item->fs = MCLoadFont(lc0);
	  item->y = y + fonts[lc0 & 0x7F].yoffset;
	  mask = fonts[lc0 & 0x7F].encoding ? 0xFF : 0x7F;
	  item->attribute = attr0;
	  if (attr0 & MTRX_INVERSE2)
	    item->gc = gc_back,
	    item->gc_back = ((attr0 & MTRX_REV_DIR2)
			     && highlight_reverse_direction) ? gc_r2l_rev : gc;
	  else
	    item->gc = gc,
	    item->gc_back =  ((attr0 & MTRX_REV_DIR2)
			      && highlight_reverse_direction)? gc_r2l : gc_back;
	  item->cmp = NULL;
	  item++;
	}
	MCSetXChar2b(lc0, c1, c2, chars + j);
	j++;
	(*ncharsp)++;
      }
    }
    lp++;
  }

  /* 92.3.19 by K.Handa - Draw text with attributes. */
  enditem = item;
  item = items;
  for (item = items; item < enditem; item++) {
    xx = item->nchars * XXfontw * item->char_width;
    XFillRectangle(display, window, item->gc_back,
		   item->x, y - XXbase, xx, XXfonth);
    XSetFont(display, item->gc, item->fs->fid);
    XDrawString16(display, window, item->gc, item->x, item->y,
		       item->chars, item->nchars);
    if (cmp = item->cmp) {	/* 93.4.11 by K.Handa */
      while (cmp->fs != NULL) {
	XSetFont(display, item->gc, cmp->fs->fid);
	XDrawString16(display, window, item->gc, item->x, cmp->y,
		      &cmp->ch, 1);
	cmp++;
      }
      XSetFont(display, item->gc, item->fs->fid);
    }

    if (item->attribute & MTRX_BOLD2) { /* 92.3.25, 93.4.11 by K.Handa */
      XRectangle rect;

      rect.x = rect.y = 0;
      rect.width = xx, rect.height = XXfonth;
      XSetClipRectangles(display, item->gc, item->x, y - XXbase,
			  &rect, 1, Unsorted);
      if (x_horizontal_bold_style)
	XDrawString16(display, window, item->gc, item->x + 1, item->y,
		      item->chars, item->nchars);
      else
	XDrawString16(display, window, item->gc, item->x, item->y - 1,
		      item->chars, item->nchars);
      XSetClipMask(display, item->gc, None);
    }
    if (item->attribute & MTRX_UNDERLINE2)
      /* 93.8.30 by K.Handa */
      XDrawLine(display, window, item->gc,
		item->x, y - XXbase + XXfonth - XXunderline_offset,
		item->x + xx - 1, y - XXbase + XXfonth - XXunderline_offset);
  }
}
/* end of patch */

/* ------------------------------------------------------------
 */
static int
XInitWindow ()
{
  extern int xargc;
  extern char **xargv;
  int x, y, width, height, pr;
  char  *dp;
  Window  desktop;
  XColor forec, backc;

 retry:
  fontinfo = XT_CalcForFont(XXcurrentfont);
  if (fontinfo == (XFontStruct *) NULL)
    {
      if (strcmp (XXcurrentfont, "fixed"))
	{
	  free (XXcurrentfont);
	  XXcurrentfont = (char *) xmalloc (6);
	  strcpy (XXcurrentfont, "fixed");
	  goto retry;
	}
      fatal ("X server unable to find requested font `%s'\n",
	     (XXcurrentfont == NULL) ? "(null)" :  XXcurrentfont);
    }

  pr = XGeometry (XXdisplay, 0, desiredwindow, default_window,
		  XXborder, XXfontw, XXfonth,
		  XXInternalBorder*2, XXInternalBorder*2,
		  &x, &y, &width, &height);

  /*  Which desktop do we start up on?
   */
  if ( (dp = getenv("WM_DESKTOP")) != (char *) NULL )
    {
      desktop = atoi(dp);
    }
  else
    {
      desktop = RootWindow(XXdisplay, DefaultScreen(XXdisplay));
    }

  XXwindow = XCreateSimpleWindow(XXdisplay, desktop,
				 x, y,
				 width*XXfontw + 2*XXInternalBorder,
				 height*XXfonth + 2*XXInternalBorder,
				 XXborder, brdr, back);
  if (!XXwindow)
    {
      fprintf (stderr, "Could not create X window!\n");
      fflush (stderr);
      exit (-97);
    }

  XXgcv.font = XXfid;
  XXgcv.foreground = fore;
  XXgcv.background = back;
  XXgc_norm = XCreateGC(XXdisplay, XXwindow,
			GCFont|GCForeground|GCBackground,
			&XXgcv);
  XXgcv.foreground = back;
  XXgcv.background = fore;
  XXgc_rev = XCreateGC(XXdisplay, XXwindow,
		       GCFont|GCForeground|GCBackground,
		       &XXgcv);
  XXgcv.foreground = back;
  XXgcv.background = curs;
  XXgc_curs = XCreateGC(XXdisplay, XXwindow,
			GCFont|GCForeground|GCBackground,
			&XXgcv);
  XXgcv.foreground = curs;
  XXgcv.background = back;
  XXgc_curs_rev = XCreateGC(XXdisplay, XXwindow,
			    GCFont|GCForeground|GCBackground,
			    &XXgcv);
/* 93.4.13 by K.Handa */
  XXgcv.stipple = XCreateBitmapFromData(XXdisplay, XXwindow, r2l_bmp_bits,
					r2l_bmp_width, r2l_bmp_height);
  XXgcv.fill_style = XXisColor ? FillSolid : FillOpaqueStippled;
  XXgcv.foreground = r2l;
  XXgcv.background = fore;
  XXgc_r2l = XCreateGC(XXdisplay, XXwindow,
		       GCForeground|GCBackground|GCFillStyle|GCStipple,
		       &XXgcv);
  XXgcv.foreground = r2l_rev;
  XXgcv.background = back;
  XXgc_r2l_rev = XCreateGC(XXdisplay, XXwindow,
			   GCForeground|GCBackground|GCFillStyle|GCStipple,
			   &XXgcv);
/* end of patch */

  EmacsCursor = XCreateFontCursor(XXdisplay, XC_left_ptr);

  x_set_cursor_colors ();

  XDefineCursor (XXdisplay, XXwindow, EmacsCursor);

  CursorExists = 0;
  CursorOutline = 1;
  VisibleX = 0;
  VisibleY = 0;


  XT_Set_Class_Hints(XXwindow);
  XT_Set_Command_Line(XXwindow);
  XT_Set_Host(XXwindow);
  XT_Set_Title(XXwindow);
  XT_Set_Icon_Title(XXwindow);
  XT_Set_Size_Hints(XXwindow, x, y, width, height, False, pr);
  XT_Set_Zoom_Sizes(XXwindow);
  XT_Set_WM_Hints(XXwindow);

  XSelectInput(XXdisplay, XXwindow, KeyPressMask |
	       ExposureMask | ButtonPressMask | ButtonReleaseMask |
	       EnterWindowMask | LeaveWindowMask | FocusChangeMask |
	       StructureNotifyMask);

  XMapWindow (XXdisplay, XXwindow);
  XFlush (XXdisplay);

#ifdef AIX          
#include "xkeys-aix.h"
#endif /* AIX */

  /* Free XrmGetStringDatabase */

#ifndef NO_X_DESTROY_DATABASE
  XrmDestroyDatabase (db);
#if (XlibSpecificationRelease >= 5)
  XrmDestroyDatabase (db2);
#endif
#endif
}

#endif /* HAVE_X_WINDOWS */

/*#include "xundebug.h"*/

