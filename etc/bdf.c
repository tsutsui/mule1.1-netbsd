/* bdfstaff Ver.1.0 -- BDF utilities
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

/* 92.10.14  written by K.Handa <handa@etl.go.jp> */
/* 92.10.21  modified for Mule 0.9.6 with DOS support
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp> */
/* 92.11.3  modified for Mule Ver.0.9.7
                by T.Matsuzawa <mzw_t@hpujisa.yhp.co.jp>
        Support NONSPACING characters and send smaller bitmap. */
/* 92.11.10 modified for Mule Ver.0.9.7
		by K.Sakaeda <saka@tomorose.trad.pfu.fujitsu.co.jp>
	Modified for SystemV. */
/* 92.11.24 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Modified to reduce memory. */
/* 92.12.15 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Look FONTPROPERTIES. */
/* 93.1.13  modified for Mule Ver.0.9.7.1
   			by T.Furuhata <furuhata@fujita3.iis.u-tokyo.ac.jp>
	Modified for AIX. */
/* 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In bdf_fopen(), declaration of 'path' is changed. */
/* 93.3.15  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	For AIX, now we don't need "#pragma alloca". */
/* 93.5.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In bdf_load_font(), bug fixed in handling private char-set. */
/* 93.5.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In bdf_load_font(), use value of PIXEL_SIZE instead of BBH.
	Support right-to-left character.
	Support Big5. */
/* 93.7.19  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Stop including "codeconv.h". */
/* 94.3.9   modified for Mule Ver.1.1 by Y.Niibe <gniibe@oz.etl.go.jp>
	In bdf_load_font(), fontp->extra->fs should not be set in emacs. */

#include <stdio.h>
#include <sys/param.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/file.h>
/* 91.10.21 by M.Higashida */
#include "../src/config.h"
#include "../src/paths.h"
#include "../etc/bdf.h"
#include "../src/mule.h"
#ifdef USG
#include <string.h>
#else
#include <strings.h>
#endif

#if !(defined(MSDOS) && defined(GO32))
/* 93.1.13 by T.Furuhata */
#include <stdlib.h>
/* end of patch */
#endif

#define B2G(eten, b1, b2, lc, g1, g2) { \
  unsigned int temp_i \
    = (b1 - 0xA1) * (0xFF-0xA1+0x7F-0x40) + b2 - (b2 < 0x7F ? 0x40 : 0x62); \
 \
  if (b1 < 0xC6 || b1 == 0xC6 && b2 < 0x7F) { \
    lc = LCBIG5_1; \
  } else { \
    lc = LCBIG5_2; \
    if (eten) temp_i -= (0xFF-0xA1+0x7F-0x40) * (0xC9-0xA1); \
    else  temp_i -= (0xFF-0xA1+0x7F-0x40) * (0xC6-0xA1) + (0x7F-0x40); \
  } \
  g1 = temp_i / (0xFF-0xA1) + 0xA1; \
  g2 = temp_i % (0xFF-0xA1) + 0xA1; \
}

static int in_emacs;

char *bdf_path;
char *charsets;

font_struct *font;
glyph_struct glyph;
static char *line, *dummy;
#ifndef LINE_BUF_SIZE
#define LINE_BUF_SIZE 256
#endif

/* Find BDF file */
#ifndef MAXPATHLEN
#define MAXPATHLEN 256
#endif

FILE *bdf_fopen (dirs, file)
     char *dirs, *file;
{
  char path[MAXPATHLEN];	/* 93.2.10 by I.Hirakura */
#ifdef MSDOS
  char drive = 0;

  if (strlen(file) >= 2 && file[1] == ':') {
    drive = tolower(file[0]);
    dirs = "", file += 2;
  }
#endif
  while (file[0] == '/') dirs = "", file++; /* file is absolute path */

  while (1)
    {
      char *tail;
      int len;
      FILE *fp;

#ifdef MSDOS
      if (strlen(dirs) < 2 || dirs[1] != ':') {
	char *temp = alloca (strlen(dirs)+3);
	
	temp[0] = drive, temp[1] = ':';
	dirs = strcpy (&temp[2], dirs);
      }
#endif
      (tail = index (dirs, ',')) || (tail = index (dirs, '\0'));

      len = tail - dirs;
      strncpy (path, dirs, len);

      while (path[--len] == '/'); /* back to non-slash */
      path[++len] = '/';
      strcpy (&path[++len], file);

/* 92.10.27 by M.Higashida */
#ifdef MSDOS
      fp = fopen (path, "rt");
#else
      fp = fopen (path, "r");
#endif
/* end of patch */
      if (fp) return fp;
 
      if (*tail == '\0') return (FILE *)NULL;
      dirs = tail + 1;
    }
}

bdf_reset_font(lc)
     int lc;
{
  int size1, size2;
  font_struct *fontp = &font[lc];
  font_extra *ext;

  if (fontp->bytes == 1) size1 = size2 = 128;
  else size1 = 96 * 96, size2 = size1 / 32;

  if (fontp->offset == NULL) {
    fontp->offset = (long *)malloc((sizeof (long)) * size1);
    bzero(fontp->offset, (sizeof (long)) * size1);
    if (in_emacs) {
      fontp->extra = (char **)malloc((sizeof (char *)) * size1);
      bzero(fontp->extra, (sizeof (char *)) * size1);
    } else {
      fontp->extra = (char **)malloc(sizeof *ext);
      ext = (font_extra *)(fontp->extra);
      ext->defined = (unsigned int *)malloc((sizeof (int)) * size2);
    }
  }
  if (!in_emacs) {
    bzero(ext->defined, (sizeof (int)) * size2);
    bzero(ext->code, (sizeof (int)) * 256);
    bzero(ext->count, (sizeof (int)) * 256);
    bzero(ext->new, (sizeof (char)) * 256);
  }
}

bdf_set_filename(lc, filename)
     int lc;
     char *filename;
{
  char *p;

  lc &= 0x7F;
  if (font[lc].filename) free (font[lc].filename);
  font[lc].filename = malloc (strlen(filename) + 1);
  strcpy(font[lc].filename, filename);
  if (p = index (font[lc].filename, ':')) {
    *p++ = 0;
    font[lc].encoding = atoi(p);
  } else
    font[lc].encoding = 0;
}

bdf_init_font()
{
  int i, bytes;
  char *p;
  FILE *fp;

  font = (font_struct *)malloc((sizeof (font_struct)) * 128);
  for (i = 0; i < 128; i++) {
    font[i].fp = NULL;
    font[i].filename = NULL;
    font[i].loaded = 0;
    font[i].offset = NULL;
    font[i].bytes = 1;
  }

  if ((fp = bdf_fopen(PATH_EXEC, charsets)) != NULL) {
    while (fgets(line, LINE_BUF_SIZE, fp)) {
      i = atoi(line) & 0x7F;
      if ((p = index(line, ':')) && (p = index(++p, ':'))
	  && (p = index(++p, ':'))) {
	font[i].bytes = atoi(++p) <= 1 ? 1 : 2;
	if ((p = index(p, ':')) && (p = index(++p, ':'))
	    && (p = index(++p, ':'))) {	/* 93.5.7 by K.Handa */
	  font[i].direction = atoi(++p);
	  if ((p = index(p, ':')) && (p = index(++p, ':'))) {
	    p++;
	    p[strlen (p) - 1] = 0;	/* \n -> 0 */
	    bdf_set_filename(i, p);
	  }
	}
      }
    }
    fclose(fp);
  }
}

bdf_init_glyph(glyphp)
     glyph_struct *glyphp;
{
  glyphp->bitmap_size = 100;
  glyphp->bitmap = malloc(glyph.bitmap_size * (sizeof (char)));
}

bdf_initialize(bp, ch, emacs)
     char *bp, *ch;
     int emacs;
{
  in_emacs = emacs;
  line = (char *)malloc(LINE_BUF_SIZE);
  dummy = (char *)malloc(LINE_BUF_SIZE);
  bdf_path = (bp != NULL ? bp : BDF_PATH);
  charsets = (ch != NULL ? ch : CHARSETS);
  bdf_init_font();
  bdf_init_glyph(&glyph);
}

bdf_proceed_line(fp, str)
     FILE *fp;
     char *str;
{
  int len = strlen(str);
  do {
    if (fgets(line, LINE_BUF_SIZE, fp) == NULL)
      return 0;
  } while (strncmp(line, str, len));
  return 1;
}

bdf_proceed_line2(fp, str, stop)
     FILE *fp;
     char *str, *stop;
{
  int len1 = strlen(str), len2 = strlen(stop);
  do {
    if (fgets(line, LINE_BUF_SIZE, fp) == NULL
	|| !strncmp(line, stop, len2))
      return 0;
  } while (strncmp(line, str, len1));
  return 1;
}

bdf_load_font(lc)
     int lc;
{
  font_struct *fontp = &font[lc];
  int i, j, bbw, bbh, bbox, bboy;
  unsigned int idx;

  if (fontp->filename == NULL
      || (fontp->fp = bdf_fopen(bdf_path, fontp->filename)) == NULL)
    return 0;
  bdf_proceed_line(fontp->fp, "FONTBOUNDINGBOX ");
  sscanf(line, "%s %d %d %d %d", dummy, &bbw, &bbh, &bbox, &bboy);
  fontp->llx = bbox, fontp->lly = bboy;
  fontp->urx = bbw + bbox, fontp->ury = bbh + bboy;
  fontp->yoffset = 0;
  fontp->relative_compose = 0;
  if (!in_emacs)
    ((font_extra *)fontp->extra)->fs = bbh;
  if (bdf_proceed_line2(fontp->fp, "STARTPROPERTIES ", "CHARS ")) {
    do {
      /* If there are properties of PIXEL_SIZE, FONT_ASCENT, FONT_DESCENT,
	 we believe them rather than FONTBOUNDINGBOX.
	 In addition, we also look private properties _MULE_BASELINE_OFFSET
	 and _MULE_RELATIVE_COMPOSE. */
      if (fgets(line, LINE_BUF_SIZE, fontp->fp) == NULL)
	return 0;
      if (!strncmp(line, "PIXEL_SIZE ", 11)) { /* 93.5.7 by K.Handa */
	if (!in_emacs) {	/* 94.3.9 by Y.Niibe */
	  sscanf(line, "%s %d", dummy, &i);
	  ((font_extra *)fontp->extra)->fs = i;
	}
      } else if (!strncmp(line, "FONT_ASCENT ", 12)) {
	sscanf(line, "%s %d", dummy, &fontp->ury);
      } else if (!strncmp(line, "FONT_DESCENT ", 13)) {
	sscanf(line, "%s %d", dummy, &i);
	fontp->lly = - i;
      } else if (!strncmp(line, "_MULE_BASELINE_OFFSET ", 22)) {
	sscanf(line, "%s %d", dummy, &i);
	fontp->yoffset = - i;
      } else if (!strncmp(line, "_MULE_RELATIVE_COMPOSE ", 23)) {
	sscanf(line, "%s %d", dummy, &fontp->relative_compose);
      }
    } while (strncmp(line, "ENDPROPERTIES", 13));
    bdf_proceed_line(fontp->fp, "CHARS ");
  }
  sscanf(line, "%s %d", dummy, &(fontp->chars));
  if (lc == (LCBIG5_2 & 0x7F))
    bdf_proceed_line(fontp->fp, "ENCODING 50814");
  fontp->last_offset = ftell(fontp->fp);
  fontp->loaded = 1;
  if ((lc >= (LCJPOLD & 0x7F) && lc < (LCPRV11 & 0x7F))	/* 93.5.7 by K.Handa */
      || (lc >= (LCPRV21EXT & 0x7F) && lc < (LCPRV3EXT & 0x7F)))
    fontp->yoffset =
      fontp->lly - (font[0].lly - (bbh - (font[0].ury - font[0].lly)) / 2);
  fontp->lly -= fontp->yoffset; fontp->ury -= fontp->yoffset;
  return 1;
}

bdf_load_glyph(lc, idx, glyph)
     int lc, idx;
     glyph_struct *glyph;
{
  font_struct *fontp = &font[lc];
  int i, j;
  int width, size;
  int h0, h1, k;

  if (fontp->fp == NULL) return 0;

  if (fontp->offset[idx]) {
    fseek(fontp->fp, fontp->offset[idx], 0);
  } else {
    fseek(fontp->fp, fontp->last_offset, 0);
    i = 0;
    while (i < idx && fontp->chars > 0) {
      bdf_proceed_line(fontp->fp, "ENCODING ");
      fontp->chars--;
      sscanf(line, "%s %d", dummy, &i);
      if (fontp->bytes == 1 && fontp->encoding && i < 0x80)
	i = 0;
      else {
	if (lc == (LCBIG5_1 & 0x7F) || lc == (LCBIG5_2 & 0x7F)) {
	  unsigned char b1 = (unsigned int)i >> 8, b2 = i & 0xFF, g1, g2, temp;
	  B2G(fontp->encoding == 1, b1, b2, temp, g1, g2);
	  i = (unsigned int)g1 * 256 + g2;
	}
	i &= 0x7F7F;
	i = fontp->bytes == 1 ? OFFIDX1(i) : OFFIDX2(i);
	fontp->offset[i] = ftell(fontp->fp);
      }
    }
    fontp->last_offset = ftell(fontp->fp);
    if (i != idx) return 0;
  }

  bdf_proceed_line(fontp->fp, "DWIDTH ");
  sscanf(line, "%s %d", dummy, &(glyph->dwidth));
  bdf_proceed_line(fontp->fp, "BBX ");
  sscanf(line, "%s %d %d %d %d",
	 dummy, &(glyph->bbw), &(glyph->bbh), &(glyph->bbox), &(glyph->bboy));
  bdf_proceed_line(fontp->fp, "BITMAP");
  width = ((glyph->bbw + 7) / 8) * 2;
  size = width * glyph->bbh + 1;
  if (glyph->bitmap_size < size)
    glyph->bitmap_size = size, glyph->bitmap = realloc(glyph->bitmap, size);

  h0 = h1 = -1;
  j = 0;
  for ( i = 0; i < glyph->bbh; i++ ) {
    if (!fgets(line, LINE_BUF_SIZE, fontp->fp)) return 0;
    line[width] = 0;
    for ( k = 0; k < width; k++ ) {
      if ( line[k] != '0' ) {
	if ( h0 < 0 ) {
	  h0 = i;
	}
	if ( h1 < i ) {
	  h1 = i;
	}
	break;
      }
    }
    if ( h0 < 0 ) {
      continue;
    }
    sprintf(glyph->bitmap + j, "%s", line);
    j += width;
  }
  glyph->bitmap[j] = 0;
  if ( h0 < 0 && h1 < 0 ) {
    h0 = 0;
  }
  glyph->bboy += ( glyph->bbh - h1 - 1) - fontp->yoffset;
  glyph->bbh = ( h1 - h0 + 1 );
  glyph->bitmap_size = width * glyph->bbh + 1;
  glyph->bitmap = realloc(glyph->bitmap, size );
  glyph->bitmap[glyph->bitmap_size - 1] = 0;
  return 1;
}
