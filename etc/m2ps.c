/* m2ps Ver.1.0 -- Convert multilingual text to PostScript
   Copyright (C) 1992 Free Software Foundation, Inc. */

/* This file is part of Mule (MULtilingual Enhancement of GNU Emacs).

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

/* 92.10.8  written by K.Handa <handa@etl.go.jp> */
/* 92.11.3  modified for Mule Ver.0.9.7
                by T.Matsuzawa <mzw_t@hpujisa.yhp.co.jp>
        Support NONSPACING characters and send smaller bitmap. */
/* 92.11.6  modified for Mule Ver.0.9.7 by K.Shibata <shibata@sgi.co.jp>
	Modified for ANSI-C. */
/* 92.11.10 modified for Mule Ver.0.9.7
		by K.Sakaeda <saka@tomorose.trad.pfu.fujitsu.co.jp>
	Modified for SystemV. */
/* 92.11.24 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Modified to reduce memory. */
/* 92.12.14 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Support composite character. */
/* 93.5.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Bug in handling missing font fixed.
	Support Big5. */
/* 93.5.29  modified for Mule Ver.0.9.8 by Y.Niibe <gniibe@mri.co.jp>
	Include config.h in src directory */  
/* 93.6.4   modified for Mule Ver.0.9.8 by K.Shibata <shibata@sgi.co.jp>
	Modified for ANSI-C. */
/* 93.12.25 modified for Mule Ver.1.0 by K.Handa <handa@etl.go.jp>
	In textmode(), bug of right-to-left handling fixed  */
/* 94.3.8   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	Bug in find_encoding() fixed. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/file.h>
#include "../src/config.h"
#include "../src/paths.h"
#include "../src/mule.h"
#include "bdf.h"

#ifndef PSHeader
#define PSHeader "m2ps.ps"
#endif

#ifndef DPI
#define DPI 300
#endif

#ifndef FontScale
#define FontScale 10
#endif

#ifndef LinePitch
#define LinePitch 14
#endif

#ifndef MaxLine
#define MaxLine 56
#endif

#ifndef TopMargin
#define TopMargin 800	/* To widen top margin, specify smaller value. */
#endif

#ifndef LeftMargin
#define LeftMargin 30	/* To widen left margin, specify larger value. */
#endif

#ifndef ShortMemory
#define ShortMemory 0
#endif

char *psheader = PSHeader;
int dpi = DPI;
int fontscale = FontScale;
int linepitch = LinePitch;
int maxline = MaxLine;
int topmargin = TopMargin;
int leftmargin = LeftMargin;
int shortmemory = ShortMemory;

/***************/
/* Main staffs */
/***************/

void warning1(char *, int);
void warning2(char *, int, int);
void fatal(char *);
void set_font(int, int);
void renew_font(int);
int set_glyph1(int, int);
int find_encoding(font_struct *, int);
int set_glyph2(int, int);
void swap_buf(unsigned char *, int, int);
void textmode(void);
void control_char(int);
void invalid_char(int);
void ps_bot(void);
void ps_eot(void);
void ps_newfont(int, int);
void ps_setfont(int);
void ps_newglyph(int, glyph_struct *);
void ps_bop(void);
void ps_eop(void);

extern font_struct *font;

extern glyph_struct glyph;	/* 92.11.6 by K.Shibata */

int clm, row, current_lc;

void
warning1(char *format, int arg)
{
  fprintf(stderr, format, arg);
  fflush(stderr);
}

void
warning2(char *format, int arg1, int arg2)
{
  fprintf(stderr, format, arg1, arg2);
  fflush(stderr);
}

void
fatal(char *msg)
{
  fprintf(stderr, "m2ps: %s\n", msg);
  fflush(stderr);
  exit(1);
}

void
set_font(int lc, int cache)
{				/* 93.5.7 by K.Handa -- Big change */
  if (font[lc].loaded == 0) {
    bdf_reset_font(lc);
    if (font[lc].fp == NULL) {
      if (bdf_load_font(lc))
	ps_newfont(lc, cache);
      else {
	if (lc == 0) fatal("Font for ASCII not found.\n");
	warning1("Font(%d) not found.  Substituted by ASCII font.\n", lc);
	font[lc] = font[0];
	font[lc].loaded = -1;
	lc = 0;
      }
    }
  } else if (font[lc].loaded < 0)
    lc = 0;
  if (lc != current_lc) {
    ps_setfont(lc);
    current_lc = lc;
  }
}

void
renew_font(int lc)
{
  bzero(((font_extra *)font[lc].extra)->new, 256 * (sizeof (char)));
}

/* Load specified glyph, then return the index to glyph.  Note the index
   is within the range of [0,255].  Return -1 if error. */
int
set_glyph1(int lc, int c)
{
  int idx = OFFIDX1(c);
  font_struct *fontp = &font[lc];

  if (!DEFINED1(fontp, idx)) {
    if (bdf_load_glyph(lc, idx, &glyph))
      ps_newglyph(idx, &glyph);
    else {
      warning2("Glyph of char(%d) for font(%d) not found.\n", idx, lc);
      return -1;
    }
    DEFINE1(fontp, idx);
  }
  return (idx);
}

int
find_encoding(font_struct *fontp, int idx)
{
  font_extra *ext = (font_extra *)fontp->extra;
  int i, min_count = ext->count[0], j = 0;

  if (min_count > 0) {
    min_count = 0x7FFF;		/* 94.3.8 by K.Handa */
    for (i = 0; i < 256; i++) {
      if (ext->count[i] <= min_count && !ext->new[i]) {
	min_count = ext->count[i], j = i;
	if (min_count == 0) break;
      }
    }
  }
  if (min_count > 0)
    UNDEFINE2(fontp, ext->code[j]);

  ext->count[j] = ext->new[j] = 1;
  ext->code[j] = idx;
  DEFINE2(fontp, ext->code[j]);
  return j;
}

/* Load specified glyph, replacing previously loaded glyph if necessary,
   then return the index to glyph.  Note the index is within the range
   of [0,255].  Return -1 if error. */
int
set_glyph2(int lc, int c)
{
  int idx = OFFIDX2((unsigned int)c), code;
  font_struct *fontp = &font[lc];
  font_extra *ext = (font_extra *)fontp->extra;

  if (!DEFINED2(fontp, idx)) {
    if (bdf_load_glyph(lc, idx, &glyph))
      code = find_encoding(fontp, idx);
    else {
      warning2("Glyph of char(%d) for font(%d) not found.\n", c, lc);
      return -1;
    }
    ps_newglyph(code, &glyph);
  } else {
    for (code = 0; code < 256; code++) {
      if (ext->code[code] == idx) break;
    }
    ext->new[code] = 1;
    ext->count[code]++;
  }
  return code;
}

void
swap_buf(unsigned char *buf, int from, int to)
{
  int i, j;
  unsigned char buf2[1024], *p = buf2;

  i = j = to;
  while (--i >= from) {
    if (NONASCII_P(buf[i])) continue;
    bcopy(buf + i, p, j - i);
    p += j - i;
    j = i;
  }
  bcopy(buf2, buf + from, to - from);
}

void
textmode(void)
{
  register int i, j, k, c, lc;
  char buf[1024];		/* 92.11.6 by K.Shibata */
  unsigned char line[1024], *p;
  int cmp_flag = 0, len, r2l_chars;

  ps_bot(); ps_bop();
  clm = row = 0; current_lc = -1;
  /* set_font(0, 1); */
  while (fgets((char *)line, 1024, stdin)) { /* 93.6.4 by K.Shibata */
    /* We should process line by line to handle r2l direction. */
    len = strlen(line);
    if (line[len - 1] == '\n') line[--len] = 0;
    j = 0; r2l_chars = 0;

    /* At first, re-order characters of r2l direction. */
    while (j < len) {
      p = line + j;
      if (*p <= 0x7F) {
	lc = 0;
	p++;
      } else {
	lc = *p++;
	if (lc == LCCMP) lc = *p++ - 0x20;
	if (lc >= LCPRV11) lc = *p++;
      }
      while (NONASCII_P(*p)) p++;
      if (font[lc & 0x7F].direction) {
	if (!r2l_chars) k = j;
	r2l_chars++;
      } else {
	if (r2l_chars > 1) 
	  swap_buf(line, k, j);
	r2l_chars = 0;
      }
      j = p - line;
    }
    if (r2l_chars > 1) swap_buf(line, k, j); /* 93.12.25 by K.Handa */

    /* Then output characters. */
    for (j = 0; j < len; j++) {
      c = line[j];

      if (c == LCCMP) {		/* start of composite characters */
	cmp_flag = 1;
	continue;
      }
      if (cmp_flag) {		/* composed characters have special encoding */
	if (c == 0xA0) c = line[++j] & 0x7F;
	else if (c > 0xA0) c -= 0x20;
	else cmp_flag = 0;
      }

      if (c < 0x20 || c == 0x7F) { /* Control code */
	switch (c) {
	case '\t':
	  i = 8 - (clm % 8);
	  clm += i;
	  set_font(0, 1);
	  if (set_glyph1(0, ' ') >= 0) {
	    putchar('(');
	    while (i--) putchar(' ');
	    printf(") s ");
	  }
	  break;
	case '\f': 
	  ps_eop(), ps_bop();
	  break;
	default:
	  if (c < ' ') control_char(c);
	  else invalid_char(c);
	}
      } else if (c < 0x7F) {	/* ASCII */
	set_font(0, 1);
	i = 0;
	do {
	  if ((c = set_glyph1(0, c)) >= 0) {
	    if (c == '\\' || c == '(' || c == ')')
	      buf[i++] = '\\', buf[i++] = c;
	    else
	      buf[i++] = c;
	    clm++;
	  }
	  c = line[++j];
	} while (!cmp_flag	/* composite character should be
				   processed one by one*/
		 && 0x20 <= c && c < 0x7F);
	j--;
	buf[i] = 0;
	switch (cmp_flag) {
	case 0:			/* not composite character */
	  printf("(%s) s ", buf);
	  break;
	case 1:			/* first of composite character */
	  printf("(%s) cs1 ", buf);
	  cmp_flag = 2;
	  break;
	default:		/* case 2: rest of composite character*/
	  if (font[0].relative_compose)
	    printf("(%s) cs2 ", buf);
	  else
	    printf("(%s) cs3 ", buf);
	}
      } else if (c < LCINV) {	/* Multilingual character */
	if (c >= LCPRV11)
	  c = line[++j];
	set_font(c & 0x7F, c < 0x90 || (c >= LCPRV11EXT && c < LCPRV21EXT));
	i = 0;
	do {
	  lc = c;
	  c = line[++j];
	  if (lc < 0x90 || (lc >= LCPRV11EXT && lc < LCPRV21EXT))
	    c = set_glyph1(lc & 0x7F, c);
	  else if (current_lc != (lc & 0x7F)) { /* 93.5.7 by K.Handa */
	    c = set_glyph1(0, c);
	    j++;
	  } else
	    c = set_glyph2(lc & 0x7F, (c & 0x7F) * 256 + (line[++j] & 0x7F));
	  if (c >= 0) {
	    if (c == '\\' || c == '(' || c == ')')
	      buf[i++] = '\\', buf[i++] = c;
	    else if (isalpha(c))
	      buf[i++] = c;
	    else
	      sprintf(buf + i, "\\%03o", c), i += 4;
	    clm += lc < 0x90 || (lc >= LCPRV11EXT && lc < LCPRV21EXT) ? 1 : 2;
	  }
	  c = line[++j];
	} while (!cmp_flag && c == lc);
	j--;
	buf[i] = 0;
	switch (cmp_flag) {
	case 0:
	  printf("(%s) s ", buf);
	  break;
	case 1:
	  printf("(%s) cs1 ", buf);
	  cmp_flag = 2;
	  break;
	case 2:
	default:
	  if (font[lc & 0x7F].relative_compose)
	    printf("(%s) cs2 ", buf);
	  else
	    printf("(%s) cs3 ", buf);
	}
	renew_font(lc & 0x7F);
      } else {
	invalid_char(c);
      }
    }
    printf("n\n");
    row++, clm = 0;
    if (row >= maxline) ps_eop(), ps_bop();
  }

  ps_eop();
  ps_eot();
}

void
control_char(int c)
{
  c += '@';
  set_font(0, 1);
  if ((set_glyph1(0, '^') >= 0) && (set_glyph1(0, c) >= 0)) {
    printf("(^%c) s ", c);
    clm += 2;
  }
}    

void
invalid_char(int c)
{
  int i;

  set_font(0, 1);
  if (set_glyph1(0, '\\') >= 0) {
    for (i = '0'; i <= '9'; i++) {
      if (set_glyph1(0, i) < 0) break;
    }
    if (i > '9') {
      printf("(\\\\%03o) s ", c);
      clm += 4;
    }
  }
}

int
main(int argc, char *argv[])
{
  register int i = 1;
  char *bdf_path = NULL, *charsets = NULL;

  while (i < argc) {
    if (!strcmp(argv[i], "-ps") && (i + 1) < argc) {
      psheader = argv[i + 1];
      i += 2;
    } else if (!strcmp(argv[i], "-fp") && (i + 1) < argc) {
      bdf_path = argv[i + 1];
      i += 2;
    } else if (!strcmp(argv[i], "-cs") && (i + 1) < argc) {
      charsets = argv[i + 1];
      i += 2;
    } else if (!strcmp(argv[i], "-dpi") && (i + 1) < argc) {
      dpi = atoi(argv[i + 1]);
      i += 2;
    } else if (!strcmp(argv[i], "-fs") && (i + 1) < argc) {
      fontscale = atoi(argv[i + 1]);
      i += 2;
    } else if (!strcmp(argv[i], "-lp") && (i + 1) < argc) {
      linepitch = atoi(argv[i + 1]);
      i += 2;
    } else if (!strcmp(argv[i], "-ml") && (i + 1) < argc) {
      maxline = atoi(argv[i + 1]);
      i += 2;
    } else if (!strcmp(argv[i], "-tm") && (i + 1) < argc) {
      topmargin = atoi(argv[i + 1]);
      i += 2;
    } else if (!strcmp(argv[i], "-lm") && (i + 1) < argc) {
      leftmargin = atoi(argv[i + 1]);
      i += 2;
    } else if (!strcmp(argv[i], "-sm")) {
      shortmemory = 1;
      i++;
    } else if (!strcmp(argv[i], "-bm")) {
      shortmemory = 0;
      i++;
    } else {
      fprintf(stderr, "%s: Invalid argument: %s\n", argv[0], argv[i]);
      exit(1);
    }
  }

  bdf_initialize(bdf_path, charsets, 0);
  textmode();
  exit(0);
}

/*********************/
/* PostScript staffs */
/*********************/

void
ps_bot(void)
{
  int c;
  FILE *fp;

  if ((fp = bdf_fopen(PATH_EXEC, psheader)) == NULL)
    fatal("PostScript header file not found.");

  while ((c = getc(fp)) != EOF) putchar(c);
  fclose(fp);
  printf("Mydict begin\n");
  printf("/DPI %d def\n", dpi);
  printf("/FontScale %d def\n", fontscale);
  printf("/LinePitch %d def\n", linepitch);
  printf("/TopMargin %d def\n", topmargin);
  printf("/LeftMargin %d def\n", leftmargin);
  printf("/ShortMemory %s def\n", (shortmemory ? "true" : "false"));
}

void
ps_eot(void)
{
  printf("end\n");
}

/* Define new PS font for a leading char LC.
   No_cache flag is for the fonts be modified (replacing the glyphs, etc.)
   at execution time. */
void
ps_newfont(int lc, int cache)
{
  printf("/F%02x /FF%02x %d [%d %d %d %d] %d %s nf\n",
	 lc, lc, ((font_extra *)font[lc].extra)->fs,
	 font[lc].llx, font[lc].lly, font[lc].urx, font[lc].ury,
	 font[lc].relative_compose,
	 (cache ? "true" : "false"));
}

void
ps_setfont(int lc)
{
  printf("F%02x f\n", lc);
}

void
ps_newglyph(int encoding, glyph_struct *glyph)
{
  printf("/C%d%s[ %d %d %d %d %d %d %d %d %d <%s> ] g\n",
	 encoding, (encoding < 10 ? "XX " : encoding < 100 ? "X " : " "),
	 glyph->dwidth,
	 glyph->bbox, glyph->bboy,
	 glyph->bbw + glyph->bbox, glyph->bbh + glyph->bboy,
	 glyph->bbw, glyph->bbh,
	 glyph->bbox, glyph->bbh + glyph->bboy,
	 glyph->bitmap);
}

void
ps_bop(void)
{
  int lc;

  row = clm = 0;
  printf("bp\n");
  if (shortmemory) {
    current_lc = -1;
    for (lc = 0; lc < 20; lc++) { /* 93.5.7 by K.Handa */
      if (font[lc].loaded == 1) font[lc].loaded = 0;
    }
  }
}

void
ps_eop(void)
{
  printf("ep\n");
}
