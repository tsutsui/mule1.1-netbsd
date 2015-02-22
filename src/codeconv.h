/* 91.10.09 written by K.Handa <handa@etl.go.jp> */

/* Header for code conversion staffs.
   Copyright (C) 1991 Free Software Foundation, Inc.

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

/* 92.4.17  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	CODE_XXXX is changed to cope with new coding-system form.*/
/* 92.10.22 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Handles Locking-Shift correctly. */
/* 92.12.25 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Now, coding-system is a symbol. */
/* 92.12.31 modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Bug fixed in the macro CC_COMPOSE. */
/* 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	CONV_BUF_SIZE: macro to get buffer size for conversion. */
/* 93.3.4   modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Macro CC_INVALID is introduced for SJIS and BIG5. */
/* 93.5.6   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Macro CC_SELECTIVE is introduced for 'selective display' handling. */
/* 93.8.12  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	CODE_NODIR introduced. */
/* 94.2.23  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	Big change of coding-system handling. */

#ifndef emacs
typedef unsigned int Lisp_Object;
#define Qnil	0
#define Qt	1
#define XFASTINT(n) ((unsigned int)(n))
#endif

/* Coding-systems supported in this version. */
#define NOCONV 0		/* No conversion */
#define AUTOCONV 1		/* Automatic conversion. */
#define ITNCODE 2		/* Used for buffer contents. */
#define SJIS 3			/* Hankaku KANA is also supported. */
#define ISO2022 4		/* Includes JIS, EUC, CTEXT */
#define BIG5 5
#define CCL 6			/* Converter written in CCL. */
#define LINECODE 7		/* Used for a display-buffer contents. */

#ifdef emacs
extern Lisp_Object Vkeyboard_coding_system, Vdisplay_coding_system;

extern Lisp_Object Qcoding_system, Qeol_type;
#endif

typedef struct {
  unsigned int type;
  unsigned int cntl;
  unsigned int ch;
  unsigned int form;
  unsigned char lcg0, lcg1, lcg2, lcg3;
  unsigned char olcg0, olcg1, olcg2, olcg3;
  unsigned char ilcg0, ilcg1, ilcg2, ilcg3;
  Lisp_Object ccl_encode, ccl_decode;
#ifndef emacs
  unsigned char designations[128];
  char mnemonic, *name, *doc;
#endif
} coding_type;

/* Macros for an intermediate status while converting code. */
/* For encoding ... */
#define CC_R2L		0x80
#define CC_END		0x40
#define CC_CR		0x20
#define CC_ESCAPE	0x10
#define CC_CMP		0x08
#define CC_SO		0x04
#define CC_SS2		0x02
#define CC_SS3		0x01
#define CC_LOCK		(CC_END | CC_CMP | CC_SO | CC_R2L)
#define CC_NON_LOCK	(CC_CR | CC_ESCAPE | CC_SS2 | CC_SS3)

#define CC_ESC		0x10
#define CC_ESC_2_4	0x11
#define CC_ESC_SS2	0x12
#define CC_ESC_SS3	0x13
#define CC_ESC_DESIGNATE 0x14
#define CC_ESC_INVALID	0x15
#define CC_ESC_STARTCMP	0x16	/* Private usage for START COMPOSING */
#define CC_ESC_ENDCMP	0x17	/* Private usage for END COMPOSING */
#define CC_ESC_2_8	0x00
#define CC_ESC_2_9	0x01
#define CC_ESC_2_10	0x02
#define CC_ESC_2_11	0x03
#define CC_ESC_2_12	0x04
#define CC_ESC_2_13	0x05
#define CC_ESC_2_14	0x06
#define CC_ESC_2_15	0x07
#define CC_ESC_2_4_8	0x08
#define CC_ESC_2_4_9	0x09
#define CC_ESC_2_4_10	0x0A
#define CC_ESC_2_4_11	0x0B
#define CC_ESC_2_4_12	0x0C
#define CC_ESC_2_4_13	0x0D
#define CC_ESC_2_4_14	0x0E
#define CC_ESC_2_4_15	0x0F
#define CC_ESC_RVT_DIR	0x18
#define CC_ESC_L2R_DIR	0x19
#define CC_ESC_R2L_DIR	0x1A
#define CC_ESC_5_11	0x1B
#define CC_ESC_5_11_0	0x1C
#define CC_ESC_5_11_1	0x1D
#define CC_ESC_5_11_2	0x1E

/* For decoding ... */
/* Used by all coding-system */
/* #define CC_END	0x40  -- already defined */
/* #define CC_R2L	0x80  -- already defined */
#define CC_SELECTIVE	0x100

/* Used by ISO2022-base coding-system */
#define CC_GRAPHIC_MASK	0x03
#define CC_IN_G0	0x00	/* lc = lcg0 */
#define CC_IN_G1	0x01	/* lc = lcg1 */
#define CC_IN_G2	0x02	/* lc = lcg2 */
#define CC_IN_G3	0x03	/* lc = lcg3 */

#define CC_SHIFT_MASK	0x0C
#define CC_SHIFT_G1	0x04
#define CC_SHIFT_G2	0x08
#define CC_SHIFT_G3	0x0C

#define CC_CMP_MASK	0x30
#define CC_CMP_LC	0x10
#define CC_CMP_ASCII	0x20
#define CC_CMP_NONASCII	0x30

/* Macros to access coding-system structure 'coding_type' */

#define CODE_TYPE_SET(mccode,t) (mccode)->type = t, (mccode)->cntl = 0
#define CODE_FORM_SET(mccode,short,eol,cntl,seven,lock,roman,oldjis,nodir) \
  (mccode)->form |= \
  (short == Qnil ? 0 : CODE_SHORT) \
  | (eol == Qnil ? 0 : CODE_ASCII_EOL) \
  | (cntl == Qnil ? 0 : CODE_ASCII_CNTL) \
  | (seven == Qnil ? 0 : CODE_SEVEN) \
  | (lock == Qnil ? 0 : CODE_LOCK_SHIFT) \
  | (roman == Qnil ? 0 : CODE_USE_ROMAN) \
  | (oldjis == Qnil ? 0 : CODE_USE_OLDJIS) \
  | (nodir == Qnil ? 0 : CODE_NODIR)
#define CODE_LC_SET(mccode,lc0,lc1,lc2,lc3) \
  (mccode->lcg0 = (mccode->ilcg0 = (lc0 < 0)) ? - lc0 : lc0), \
  (mccode->lcg1 = (mccode->ilcg1 = (lc1 < 0)) ? - lc1 : lc1), \
  (mccode->lcg2 = (mccode->ilcg2 = (lc2 < 0)) ? - lc2 : lc2), \
  (mccode->lcg3 = (mccode->ilcg3 = (lc3 < 0)) ? - lc3 : lc3), \
  mccode->olcg0 = mccode->lcg0, mccode->olcg1 = mccode->lcg1, \
  mccode->olcg2 = mccode->lcg2, mccode->olcg3 = mccode->lcg3
#define CODE_LCG0_SET(mccode,lc0) (mccode)->lcg0 = lc0
#define CODE_CNTL_SET(mccode,c) (mccode)->cntl = c
#define CODE_CHAR_SET(mccode,c) (mccode)->ch = c

#define CODE_TYPE(mccode) (mccode)->type
#define CODE_FORM(mccode) (mccode)->form
#define CODE_LCG0(mccode) (mccode)->lcg0
#define CODE_LCG1(mccode) (mccode)->lcg1
#define CODE_LCG2(mccode) (mccode)->lcg2
#define CODE_LCG3(mccode) (mccode)->lcg3
#define CODE_CNTL(mccode) (mccode)->cntl
#define CODE_CHAR(mccode) (mccode)->ch
#define CODE_CCL_ENCODE(mccode) ((mccode)->ccl_encode)
#define CODE_CCL_DECODE(mccode) ((mccode)->ccl_decode)

#define CODE_NODIR	0x0800
#define CODE_EOL_MASK	0x0700
#define CODE_EOL_AUTO	0x0000
#define CODE_EOL_LF	0x0100
#define CODE_EOL_CRLF	0x0200
#define CODE_EOL_CR	0x0300
#define CODE_EOL_NOCONV 0x0400
#define CODE_SHORT	0x80
#define CODE_ASCII_EOL	0x40
#define CODE_ASCII_CNTL	0x20
#define CODE_SEVEN	0x10
#define CODE_LOCK_SHIFT 0x08
/* #define CODE_ASCII_EOT	0x04	/* not used now */
#define CODE_USE_ROMAN	0x02
#define CODE_USE_OLDJIS 0x01

#define CODE_BIG5_HKU	0x00
#define CODE_BIG5_ETEN	0x01

#define CODE_DECOMPOSE0(mccode,cntl,ch,form) \
  cntl = CODE_CNTL(mccode), ch = CODE_CHAR(mccode), form = CODE_FORM(mccode)

#define CODE_DECOMPOSE(mccode,cntl,ch,form,lcg0,lcg1,lcg2,lcg3) \
  CODE_DECOMPOSE0(mccode,cntl,ch,form), \
  lcg0 = CODE_LCG0(mccode), lcg1 = CODE_LCG1(mccode), \
  lcg2 = CODE_LCG2(mccode), lcg3 = CODE_LCG3(mccode)

#define CODE_COMPOSE0(mccode,cntl,ch) \
  CODE_CNTL_SET(mccode,cntl), CODE_CHAR_SET(mccode,ch)

#define CODE_COMPOSE(mccode,cntl,ch,lcg0,lcg1,lcg2,lcg3) \
  CODE_COMPOSE0(mccode,cntl,ch), \
  CODE_LCG0(mccode) = lcg0, CODE_LCG1(mccode) = lcg1, \
  CODE_LCG2(mccode) = lcg2, CODE_LCG3(mccode) = lcg3


/* Code conversoin staffs */

#define SJIS_P(c) \
  ((unsigned char)(c) & 0x80 \
   && ((unsigned char)(c) < 0xA0 || (unsigned char)(c) >= 0xE0))

#define S2E(i1, i2, c1, c2) \
{ \
  if (i2 >= 0x9f) { \
    if (i1 >= 0xe0) c1 = i1*2 - 0xe0; \
    else c1 = i1*2 - 0x60; \
    c2 = i2 + 2; \
  } else { \
    if (i1 >= 0xe0) c1 = i1*2 - 0xe1; \
    else c1 = i1*2 - 0x61; \
    if (i2 >= 0x7f) c2 = i2 + 0x60; \
    else c2 = i2 +  0x61; \
  } \
}

#define E2S(i1, i2, c1, c2) \
{ \
  if (i1 & 1) { \
    if (i1 < 0xdf) c1 = i1/2 + 0x31; \
    else c1 = i1/2 + 0x71; \
    if (i2 >= 0xe0) c2 = i2 - 0x60; \
    else c2 = i2 - 0x61; \
  } else {			 \
    if (i1 < 0xdf) c1 = i1/2 + 0x30; \
    else  c1 = i1/2 + 0x70; \
    c2 = i2 - 2; \
  } \
}

#define G2B(lc, g1, g2, eten, b1, b2) { \
  unsigned int temp_i = (g1 - 0xA1) * (0xFF-0xA1) + (g2 - 0xA1); \
 \
  if (lc == LCBIG5_2) { \
    if (eten) temp_i += (0xFF-0xA1+0x7F-0x40) * (0xC9-0xA1); \
    else  temp_i += (0xFF-0xA1+0x7F-0x40) * (0xC6-0xA1) + (0x7F-0x40); \
  } \
  b1 = temp_i / (0xFF-0xA1+0x7F-0x40) + 0xA1; \
  b2 = temp_i % (0xFF-0xA1+0x7F-0x40); \
  b2 += b2 < 0x3F ? 0x40 : 0x62; \
}

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

/* Code conversion functions. */
/* 93.2.10, 93.5.14 by K.Handa */
#define CONV_BUF_EXTRA 256
#define CONV_BUF_SIZE(n,type) \
  (((type) == ITNCODE ? (n) * 3 : (type) == LINECODE ? (n) * 10 : (type) == ISO2022 ? (n) * 5 : (n)) + CONV_BUF_EXTRA)

extern int encode();
extern int decode();

extern char *get_conversion_buffer();
extern Lisp_Object check_code();

#define CONVERSION_BUFFER_SIZE 1024
extern char conversion_buffer[CONVERSION_BUFFER_SIZE];

/* For detecting coding-system */
#define IDX_ITN		0	/* Index for Intenal Code, and so on. */
#define IDX_SJIS	1
#define IDX_ISO_7	2
#define IDX_ISO_8_1	3
#define IDX_ISO_8_2	4
#define IDX_ISO_ELSE	5
#define IDX_BIG5	6
#define IDX_BIN		7

extern int code_priority[IDX_BIN + 1];

#define M_INT		(1<<IDX_ITN)
#define M_SJIS		(1<<IDX_SJIS)
#define M_ISO_7		(1<<IDX_ISO_7)
#define M_ISO_8_1	(1<<IDX_ISO_8_1)
#define M_ISO_8_2	(1<<IDX_ISO_8_2)
#define M_ISO_ELSE	(1<<IDX_ISO_ELSE)
#define M_BIG5		(1<<IDX_BIG5)
#define M_BIN		(1<<IDX_BIN)

#define M_ALL (M_INT|M_SJIS|M_ISO_7|M_ISO_8_1|M_ISO_8_2|M_ISO_ELSE|M_BIG5|M_BIN)
