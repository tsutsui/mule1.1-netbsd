/* 92.12.10 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Support composite character. */
/* 93.5.20  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	CCL support. */

#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/keysym.h>
#include <X11/cursorfont.h>
#include <X11/Xutil.h>
#include "emacssignal.h"

#define XMOUSEBUFSIZE 64

#define BLOCK_INPUT_DECLARE() SIGMASKTYPE BLOCK_INPUT_mask
#ifdef SIGIO
#define BLOCK_INPUT() BLOCK_INPUT_mask = sigblock (sigmask (SIGIO))
#define UNBLOCK_INPUT() sigsetmask (BLOCK_INPUT_mask)
#else /* not SIGIO */
#define BLOCK_INPUT() stop_polling ()
#define UNBLOCK_INPUT() start_polling ()
#endif /* SIGIO */

#define CLASS  "Emacs"	/* class id for GNU Emacs, used in .Xdefaults, etc. */

extern char *black_color;
extern char *white_color;

/* 92.12.9 by K.Handa */
typedef struct {
  XFontStruct *fs;		/* Font Info */
  int encoding;			/* 0: 0x21-0x7F 1: 0xA1-0xFE or ETen 2: HKU */
  int yoffset;			/* Vertical offset from baseline */
  int relative_compose;		/* Non zero means characters should be
				   composed at relative vertical position. */
  char *name;			/* Requested font name */
  char *opened;			/* Name of a font actually opened */
} font_struct;
/* end of patch */

extern char *XXlinespacestr;

extern void xfixscreen (void);
extern int x_set_cursor_colors (void);
extern void x_set_fontname (unsigned int);
extern void x_set_linespace (char *);
extern void x_term_init (void);
extern int CursorToggle (void);
extern void HandleSelectionClear (XEvent *);
extern void HandleSelectionRequest(XEvent *);
extern int MCNewFont (char *, unsigned char, unsigned char);
extern void XCleanUp (void);
extern void XFlipColor (void);
extern int XNewFont (char *);
extern void XRedrawDisplay (void);
extern void XSetFeep (void);
extern void XSetFlash (void);
extern void XSetWindowSize(int, int);
