/* Header for multilingual functions.
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

/* 91.10.09 written by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.21  modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
	Declarations of char_... are changed.
	Definition of LC_P is changed. */
/* 92.9.2   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Big change to support private character-set. */
/* 92.11.10 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Composite character is supported. */
/* 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
	Preliminary support (92.8.2) for right-to-left languages. */
/* 93.4.29  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	CNS11643 support. */
/* 93.5.22  modified for Mule Ver.0.9.7.1 by Y.Niibe <gniibe@mri.co.jp>
	Add the macro DIRECTION_UNDEFINED,
	so that private char-set could have direction */
/* 93.10.18 modified for Mule Ver.1.1 by T.Enami <enami@sys.ptg.sony.co.jp>
	Definition of CHARtoSTR and STRtoCHAR modified for private char. */

/* Definition of leading chars. */
/** The followings are for 1-byte characters. **/
#define LCASCII 0x00		/* Omitted in a buffer */
#define LCLTN1	0x81		/* Right half of ISO 8859-n */
#define LCLTN2	0x82		/* same */
#define LCLTN3	0x83		/* same */
#define LCLTN4	0x84		/* same */
#define LCGRK	0x86		/* same */
#define LCARB	0x87		/* same */
#define LCHBW	0x88		/* same */
#define LCKANA	0x89		/* Right half of JIS X0201-1976 */
#define LCROMAN	0x8A		/* Left half of JIS X0201-1976 */
#define LCCRL	0x8C		/* Right half of ISO 8859-5 */
#define LCLTN5	0x8D		/* same */

/** The followings are for 2-byte characters. **/
#define LCJPOLD	0x90		/* For Japanese JIS X0208-1976 */
#define LCCN	0x91		/* For Chinese Hanzi GB2312-1980 */
#define LCJP	0x92		/* For Japanese JIS X0208-1983 */
#define LCKR	0x93		/* For Hangul KS C5601-1987 */
#define LCJP2	0x94		/* For Japanese JIS X0212-1990 */
#define LCCNS1	0x95		/* For Chinese CNS11643 Set 1 */
#define LCCNS2	0x96		/* For Chinese CNS11643 Set 2 */
#define LCCNS14	0x97		/* For Chinese CNS11643 Set 14 */
#define LCBIG5_1 0x98		/* For Big5 Level 1 */
#define LCBIG5_2 0x99		/* For Big5 Level 2 */
#define LCPRV11	0x9A		/* 1-byte/1-clm character-set of private use */
#define LCPRV12 0x9B		/* 1-byte/2-clm character-set of private use */
#define LCPRV21	0x9C		/* 2-byte/1-clm character-set of private use */
#define LCPRV22	0x9D		/* 2-byte/2-clm character-set of private use */
#define LCPRV3	0x9E		/* 3-byte/?-clm character-set of private use */

#define LCCMP	0x80		/* 92.11.10 -- for a composite character */
#define LCINV	0x9F		/* Never used */

#define LCPRV11EXT 0xA0
#define LCPRV12EXT 0xB8
#define LCPRV21EXT 0xC0
#define LCPRV22EXT 0xC8
#define LCPRV3EXT  0xE0

/* Special control characters */
#undef ESC
#define ESC 0x1B		/* Escape character */
#undef DEL
#define DEL 0x7F		/* DELETE character */
#undef SS2
#define SS2 0x8E		/* Single Shift character */
#undef SS3
#define SS3 0x8F		/* Single Shift character */
#undef SO
#define SO  0x0E		/* Locking Shift for G1 */
#undef SI
#define SI  0x0F		/* Locking Shift for G0 */

/* Macros for identification of various type of character. */
/* 92.12.15 by K.Handa -- Note that SP and DEL are not included. */
#define C0_P(c) ((unsigned char)(c) < 0x20)
#define C1_P(c) ((unsigned char)(c) >= 0x80 && (unsigned char)(c) < 0xA0)
#define ASCII_P(c) ((unsigned char)(c) < 0x80)
/* 92.11.10 by K.Handa -- Now 0x80 is a leading-char for a composite char. */
#define LC_P(c) (0x80 <= (unsigned char)(c) && (unsigned char)(c) < LCINV)
#define NONASCII_P(c) ((unsigned char)(c) >= 0xA0)

#define LEADING_CHAR(c) \
  ((c) <= 0x80 ? 0 : (c) <= 0xFF ? c : \
   (c) <= 0xFFFF ? ((c) >> 8) | 0x80 : ((c) >> 16) | 0x80)

#define MC_CHAR_P(c) ((unsigned int)c > 0xFF)

/* Table of byte-length for a character-set indexed by leading char. */
extern unsigned char char_bytes[256];

#define ONEBYTE	1
#define TWOBYTE	2
#define THREEBYTE 3
#define FOURBYTE 4

/* Table of character-width of characters in a character-set. */
extern unsigned char char_width[256];

#define ONECOLUMN 1
#define TWOCOLUMN 2

/* Following tables are meaningful on output with ISO2022 coding system. */
/* Table of graphic-set to be designated for a character-set. */
extern unsigned char *char_graphic;

#define GRAPHIC0 0
#define GRAPHIC1 1
#define GRAPHIC2 2
#define GRAPHIC3 3

/* Table of type of a character-set. */
extern unsigned char *char_type;
#define TYPE94  0		/* This char-set includes 94 characters. */
#define TYPE96  1		/* This char-set includes 96 characters. */
#define TYPE94N 2		/* This char-set includes 94x94 characters. */
#define TYPE96N 3		/* This char-set includes 96x96 characters. */

/* 92.8.2, 93.5.33 Y.Niibe */
/* Table of direction of a character-set. */
extern unsigned char char_direction[256];

#define LEFT_TO_RIGHT 0
#define RIGHT_TO_LEFT 1
#define DIRECTION_UNDEFINED 255 
  /* In case of private character sets,
     we have to check extended leading char. */
/* end of patch */

/* Table of a final character of a character-set. */
extern unsigned char *char_final;

/* Table of leading-char indexed by TYPE/FINAL_CHAR. */
extern unsigned char lc_table[4][128];
/* Table of leading-char indexed by leading-char of the same TYPE/FINAL_CHAR
   but reverse DIRECTION. */
extern unsigned char rev_lc_table[256];

/* Table of a descrition for a character-set. */
extern char *char_description[128];

#ifdef emacs

#define FETCH_MC_CHAR(c, pos) { \
  register unsigned char *p; \
  register int len; \
  if ((pos) == ZV) c = 0; \
  else { \
    p = ((pos) >= GPT ? GAP_SIZE : 0) + (pos) + BEG_ADDR - 1; \
    len = ((pos) >= GPT ? ZV : GPT) - pos; \
    c = STRtoCHAR (p, len); \
  } \
}

#define INC_POS(pos) \
  while (++pos < ZV && NONASCII_P(FETCH_CHAR (pos)))

#define DEC_POS(pos) \
  while (--pos > BEGV && NONASCII_P(FETCH_CHAR (pos)))

#define REVERSE_BYTES(c) \
  ((c) < 0x100 ? (c) \
   : (c) < 0x10000 ? ((c) & 0xFF00) >> 8 | ((c) & 0xFF) << 8 | 0x80 \
   : ((c) & 0xFF0000) >> 16 | ((c) & 0xFF00) | ((c) & 0xFF) << 16 | 0x80)

/* 93.10.18 by T.Enami */
#define CHARtoSTR(c,s) \
  ((unsigned int)(c) < 0x100 ? \
   *(s) = (unsigned int)(c), 1 : mchar_to_string(c, s))

#define STRtoCHAR(s,len) \
  ((len == 1 || *s < 0x80 || *s > LCPRV3) ? \
   *(s) : string_to_mchar(s, len))
/* end of patch */

#endif /* emacs */
