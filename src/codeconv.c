/* Code conversion staffs.
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

/* 91.10.09 written for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.23  modified for Mule Ver.0.9.1 by T.Enami <enami@sys.ptg.sony.co.jp>
	In g2i(), lcg0 is set to LCASCII at the situation of CODE_ASCII_EOT */
/* 92.3.24  modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	In Fcode_convert_region and Fcode_convert_string,
	  first argument to encode() is fixed.
	Fcode_convert_region changed to now non-interactive,
	  use code-convert in mule-util.el instead. */
/* 92.4.3   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
	code_detect() does more precise check, arg prio is now simple flag.
	Fcode_detect_region() is changed to non-interactive,
	  use what-coding-system in mule-util.el instead.
	Fset_code_priority and Fget_code_priority is deleted,
	  array code_priority is updated automatically from Vcode_priority.
	update_code_priority() is created and called from code_detect(). */
/* 92.4.7   modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	Fcheck_code() checks coding-system more severely. */
/* 92.4.8   modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	In g2i(), 'graphic' should be set to CC_IN_GL when CODE_ASCII_EOT.
	In Fcode_convert_region(), error check is done only by CC_CHAR(state),
	and mc_flag should be recovered when error occurs. */
/* 92.4.17  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
	g2i(), designate() are changed to cope with new coding-system form.*/
/* 92.4.28  modified for Mule Ver.0.9.4 by T.Enami <enami@sys.ptg.sony.co.jp>
	i2g() handles SS2 and SS3 correctly. */
/* 92.5.20  modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
	code_detect() checks a character following ESC. */
/* 92.7.10  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
	code_detect() checks ISO2022 variant deeply.
	g2i() generates appropriate code for *euc-code-category*
	even if the buffer contents various multilingual characters. */
/* 92.7.14  modified for Mule Ver.0.9.5 by T.Ito <toshi@his.cpl.melco.co.jp>
	Unnecessary '*' in comments of variables deleted. */
/* 92.9.8  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	Support private char-sets. */
/* 92.9.14  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	code_detect() has big change. i2g() does not discard single ESC. */
/* 92.10.2  modified for Mule Ver.0.9.6 by T.Enami <enami@sys.ptg.sony.co.jp>
	Fcode_detect_region recovers mc-flag on error. */
/* 92.10.22 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	g2i() handles Locking-Shift correctly. */
/* 92.11.13 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	In code_detect(), EUC/CTEXT may use SO/SI. */
/* 92.12.16 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Many bug fixes in ISO2022 handling. */
/* 92.12.25 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	Now, coding-system is a symbol. */
/* 92.12.28 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
	code-detect() checks CRLF at end of line. */
/* 92.12.31 modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Bug fixed in g2i(). */
/* 93.1.5   modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Check validity of coding-system more rigidly. */
/* 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Arguments of get_conversion_buffer() changed. */
/* 93.3.4   modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In code_detect(), <CRLF> sequence is detected correctly. */
/* 93.3.4   modified for Mule Ver.0.9.7.1
   				by T.Enami <enami@sys.ptg.sony.co.jp>
	Bug fix in g2s() and g2b. */
/* 93.3.22  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	In designate(), short-form can't be used for G1..3 designation. */
/* 93.4.23  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
	Bug fix in b2g(); */
/* 93.5.14  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Support three types of EOL, LF, CRLF, and CR.
	CCL support. */
/* 93.5.24  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In code_detect(), bug in Big5 handling fixed. */
/* 93.6.2   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	designate() requires previous-leading-char argument.
	ISO6429 support for right-to-left characters. */
/* 93.6.16  modified for Mule Ver.0.9.8 by T.Atsushiba<toshiki@jit.dec-j.co.jp>
	In encode(), call encode_code() only when code is detected. */
/* 93.6.19  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	Fcode_convert_region() doesn't alter point if possible.
	Fcode_convert_string() is written in Emacslisp. */
/* 93.6.27  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In i2g(), handle invalid esc sequence in a better way. */
/* 93.6.28  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In code_detect(), SS2 is not allowed in *ctext*. */
/* 93.7.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In g2i(), CODE_ASCII_EOL and CC_END are handled correctly. */
/* 93.7.21  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	In g2i(), CC_SELECTIVE should not be reset. */
/* 93.8.12  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	In g2i(), if (form & CODE_NODIR), don't use ISO6429. */
/* 93.8.30  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	In g2i(), 'cntl' should not be reset at EOL. */
/* 93.11.15 modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	Sb2m() and Sm2b() are added for Big5 handling. */
/* 94.2.23  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	Big change of coding-system handling. */
/* 94.3.9   modified for Mule Ver.1.1 by T.Furuhata <furuhata@trl.ibm.co.jp>
	In Fcode_detect_region(), document fixed. */
/* 94.3.9   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	In code_detect_iso2022(), invalid esc-sequence is ignored,
	and bug fixed. */

#ifdef emacs
#include "config.h"
#undef NULL
#include "lisp.h"
#include "buffer.h"
#endif /* emacs */

#include "mule.h"
#include "codeconv.h"

#ifdef emacs
Lisp_Object Qcoding_system_error;

Lisp_Object Vkeyboard_coding_system, Vdisplay_coding_system;

#endif /* emacs */

/* Table of symbols of code-category. */
Lisp_Object code_category[IDX_BIN + 1];

/* Table of index to code_category[] of the code category
   of `n'th priority. */
char code_priority_category[IDX_BIN + 1];

#ifdef emacs
/* 92.4.3, 92.12.18 by K.Handa */
Lisp_Object Qcoding_system, Qcoding_system_p, Qnon_nil_coding_system_p;
Lisp_Object Qeol_type;
Lisp_Object Qpriority;
/* end of patch */
#endif /* emacs */

#ifdef emacs
DEFUN ("set-coding-priority-internal", Fset_code_priority, Sset_code_priority,
       0, 0, 0,
  "Don't call this directly, use set-code-priority instead.")
  ()
{
  Lisp_Object val;
  int i, j;
  
  for (i = 0; i <= IDX_BIN; i++) {
    val = Fget (code_category[i], Qpriority);
    if (XFASTINT (val) <= IDX_BIN)
      code_priority_category[XFASTINT (val)] = i;
  }
  return Qnil;
}
#endif /* emacs */

/* 92.7.10 by K.Handa */
unsigned char
lookup(c, lcg0, lcg1, lcg2, lcg3, esc_cntl)
     unsigned char c, *lcg0, *lcg1, *lcg2, *lcg3, esc_cntl;
{
  register unsigned char lc = LCINV, *lcp;

  switch (esc_cntl) {
  case CC_ESC:
    switch (c) {
    case '$': return CC_ESC_2_4;
    case 'N': return (*lcg2 == LCINV ? CC_ESC_INVALID : CC_ESC_SS2);
    case 'O': return (*lcg3 == LCINV ? CC_ESC_INVALID : CC_ESC_SS3);
    case '0': return CC_ESC_STARTCMP;
    case '1': return CC_ESC_ENDCMP;
    case '[': return CC_ESC_5_11;
    default:
      if (0x28 <= c && c <= 0x2F) return (c - 0x28);
      else return CC_ESC_INVALID;
    }
  case CC_ESC_2_4:
    if (0x28 <= c && c <= 0x2F) return (c - 0x20);
    if (0x40 <= c && c <= 0x42) lc = lc_table[TYPE94N][c], lcp = lcg0;
    else return CC_ESC_INVALID;
   break;
  case CC_ESC_5_11:		/* ISO6429 direction control */
    if (c == ']') return CC_ESC_RVT_DIR;
    else if (c == '0') return CC_ESC_5_11_0;
    else if (c == '1') return CC_ESC_5_11_1;
    else if (c == '2') return CC_ESC_5_11_2;
    else return CC_ESC_INVALID;
  case CC_ESC_5_11_0:
    if (c == ']') return CC_ESC_RVT_DIR;
    else return CC_ESC_INVALID;
  case CC_ESC_5_11_1:
    if (c == ']') return CC_ESC_L2R_DIR;
    else return CC_ESC_INVALID;
  case CC_ESC_5_11_2:
    if (c == ']') return CC_ESC_R2L_DIR;
    else return CC_ESC_INVALID;
  default:
    lc = lc_table[(esc_cntl >> 2) & 3][c];
    switch (esc_cntl & 3) {
    case 0: lcp = lcg0; break;
    case 1: lcp = lcg1; break;
    case 2: lcp = lcg2; break;
    default: lcp = lcg3; break;
    }
  }
  if (lc == LCINV) return CC_ESC_INVALID;
  if (lc == LCJPOLD) lc = LCJP;
  else if (lc == LCROMAN) lc = LCASCII;
  *lcp = lc;
  return CC_ESC_DESIGNATE;
}
/* end of patch */

code_detect_iso2022(buf, endp)
     unsigned char *buf, *endp;
{
  int mask = M_ISO_7 | M_ISO_8_1 | M_ISO_8_2 | M_ISO_ELSE;
  unsigned char lcg0, lcg1, lcg2, lcg3;
  unsigned char c, esc_cntl;

  lcg0 = lcg1 = lcg2 = lcg3 = LCASCII;
  while (buf < endp) {
    c = *buf++;
    switch (c) {
    case ESC:
      esc_cntl = CC_ESC;
      goto code_detect_esc_check;
    case 0x9B:
      mask &= ~M_ISO_7;
      esc_cntl = CC_ESC_5_11;
    code_detect_esc_check:
      while (buf < endp) {
	c = *buf++;
	esc_cntl = lookup(c, &lcg0, &lcg1, &lcg2, &lcg3, esc_cntl);
	/* 94.3.9 by K.Handa */
	if (esc_cntl == CC_ESC_DESIGNATE) {
	  if (lcg2 || lcg3) return M_ISO_ELSE;
	} else if (esc_cntl != CC_ESC_2_4
		   && esc_cntl > CC_ESC_2_4_15
		   && esc_cntl < CC_ESC_5_11) {
	  break;
	}
      }
      break;
    case SI: case SO:
      return M_ISO_ELSE;
      break;
    case SS2: case SS3:
      mask &= ~M_ISO_7;
      while (buf < endp && *buf >= 0xA0) buf++;
      break;
    default:
      if (c >= 0xA0) {
	int count = 1;
	mask &= ~M_ISO_7;
	while (buf < endp && *buf >= 0xA0) count++, buf++;
	if (count & 1 && buf < endp) /* 94.3.9 by K.Handa */
	  mask &= ~M_ISO_8_2;
      } else if (c >= 0x80) {
	return M_BIN;
      }
    }
  }
  if (mask & M_ISO_7) return M_ISO_7;
  return mask;
}

code_detect_internal(buf, endp)
     unsigned char *buf, *endp;
{
  unsigned char c;

  while (buf < endp) {
    c = *buf++;
    if (c == ESC || c == SI || c == SO || c >= 0xA0)
      return 0;
    if (c >= 0x80) {
      if (buf < endp && *buf++ >= 0xA0) {
	while (buf < endp &&  *buf >= 0xA0) buf++;
      } else {
	return 0;
      }
    }
  }
  return M_INT;
}

code_detect_sjis(buf, endp)
     unsigned char *buf, *endp;
{
  unsigned char c;

  while (buf < endp) {
    c = *buf++;
    if (c == ESC || c == SI || c == SO)
      return 0;
    if (c >= 0x80 && c < 0xA0 || c >= 0xE0) {
      if (buf < endp && *buf++ < 0x40) {
	return 0;
      }
    }
  }
  return M_SJIS;
}

code_detect_big5(buf, endp)
     unsigned char *buf, *endp;
{
  unsigned char c;

  while (buf < endp) {
    c = *buf++;
    if (c == ESC || c == SI || c == SO || (c >= 0x80 && c <= 0xA0)) {
      return 0;
    } else if (c >= 0xA1) {
      if (buf < endp && ((c = *buf++) < 0x40 || (c >= 0x80 && c <= 0xA0))) {
	return 0;
      }
    }
  }
  return M_BIG5;
}

/* Return mask of possible coding system.
   If only ASCII, M_ALL is returned.
   If there's no possible coding system, M_BIN is returned. */

code_detect(buf, n)
     unsigned char *buf;
     int n;
{
  unsigned char c, *endp = buf + n;
  int mask = M_ALL;

  while (buf < endp) {
    c = *buf++;
    if (c < 0x20) {		/* perhaps C0 control code */
      if (c == ESC || c == SI || c == SO) {
	buf--;
	mask = code_detect_iso2022(buf, endp);
	break;
      }
      continue;
    } else if (c < 0x80) {	/* ASCII */
      continue;
    } else if (c < 0xA0) {	/* C1 control code or Shift_JIS */
      buf--;
      mask = M_BIN;
      if (c == SS2 || c == SS3 || c == 0x9B) {
	mask |= code_detect_iso2022(buf, endp);
	mask |= code_detect_sjis(buf, endp);
	if (mask == M_BIN)
	  mask |= code_detect_internal(buf, endp);
      } else {
	if ((mask |= code_detect_sjis(buf, endp)) == M_BIN)
	  mask |= code_detect_internal(buf, endp);
      }
      break;
    } else {			/* ISO2022 with G1, Shift_JIS, or BIG5 */
      buf--;
      mask = M_BIN;
      mask |= code_detect_iso2022(buf, endp);
      mask |= code_detect_sjis(buf, endp);
      mask |= code_detect_big5(buf, endp);
      break;
    }
  }
  return mask;
}

eol_detect(buf, n)
     unsigned char *buf;
     int n;
{
  unsigned char c, *endp = buf + n;

  while (buf < endp) {
    c = *buf++;
    if (c == '\r') {
      if (buf < endp && *buf == '\n')
	return CODE_EOL_CRLF;
      else
	return CODE_EOL_CR;
    } else if (c == '\n') {
      return CODE_EOL_LF;
    }
  }
  return CODE_EOL_AUTO;
}

#ifdef emacs
DEFUN ("code-detect-region", Fcode_detect_region, Scode_detect_region,
       2, 2, 0,
  "Detect coding-system of the text in the region between START and END.\n\
Returned value is a list of possible coding-system ordered by priority.\n\
If only ASCII characters are found, it returns *autoconv* or its\n\
subsidieary coding-system accoding to a detected end-of-line type.")
  (b, e)
     Lisp_Object b, e;
{
  Lisp_Object val, val2, val3;
  int beg, end, mask, eol, i;
/* 92.10.2 by T.Enami */
  int count = specpdl_ptr - specpdl;
  specbind (intern ("mc-flag"), Qnil);
/* end of patch */

  validate_region(&b, &e);
  beg = XINT (b);
  end = XINT (e);
  if (beg < GPT && end >= GPT) move_gap (end);

/* 92.4.3, 94.1.31 by K.Handa */
  mask = code_detect(&FETCH_CHAR (beg), end - beg);
  eol = eol_detect(&FETCH_CHAR (beg), end - beg);
  if (mask == M_ALL) {
    val = intern ("*autoconv*");
    if (eol != CODE_EOL_AUTO) {
      val = Fget (val, Qeol_type);
      switch (eol) {
      case CODE_EOL_LF:
	val = XVECTOR (val)->contents[0]; break;
      case CODE_EOL_CRLF:
	val = XVECTOR (val)->contents[1]; break;
      case CODE_EOL_CR:
	val = XVECTOR (val)->contents[2]; break;
      }
    }
  } else {
    val = Qnil;
    for (i = IDX_BIN; i >= 0; i--) {
      if (mask & (1 << code_priority_category[i])) {
	val2 = Fsymbol_value (code_category[code_priority_category[i]]);
	val3 = Fget (val2, Qeol_type);
	if (eol != CODE_EOL_AUTO && XTYPE (val3) == Lisp_Vector) {
	  switch (eol) {
	  case CODE_EOL_LF:
	    val2 = XVECTOR (val3)->contents[0]; break;
	  case CODE_EOL_CRLF:
	    val2 = XVECTOR (val3)->contents[1]; break;
	  case CODE_EOL_CR:
	    val2 = XVECTOR (val3)->contents[2]; break;
	  }
	}
	val = Fcons (val2, val);
      }
    }
  }
/* end of patch */

  return unbind_to (count, val);	/* 92.10.2 by T.Enami */
}
#endif /* emacs */

/* Encode to INTERNAL. */
int
a2g(src, dst, n, mccode)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp, c;
  register unsigned int cntl, eol = CODE_FORM (mccode) & CODE_EOL_MASK;

  if (eol != CODE_EOL_CRLF && eol != CODE_EOL_CR) {
    bcopy(src, dst, n);
    return n;
  }

  dp = dst;
  cntl = CODE_CNTL (mccode);
  while (n--) {
    c = *src++;
    if (c == '\r') {
      if (eol == CODE_EOL_CR)
	*dp++ = '\n';
      else {
	if (cntl & CC_CR)
	  *dp++ = c;
	else
	  cntl |= CC_CR;
      }
    } else {
      if (cntl & CC_CR) {	/* eol == CODE_EOL_CRLF */
	if (c != '\n') *dp++ = '\r';
	cntl &= ~CC_CR;
      }
      *dp++ = c;
    }
  }

  CODE_CNTL_SET (mccode, cntl);
  return (dp - dst);
}

int
s2g(src, dst, n, mccode)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp = dst, c;
  register unsigned int cntl, ch, form, eol;

  CODE_DECOMPOSE0 (mccode, cntl, ch, form);
  eol = form & CODE_EOL_MASK;

  while (n--) {
    c = *src++;
    if (ch) {
      *dp++ = LCJP;
      S2E(ch, c, *dp, *(dp+1)); dp += 2; ch = 0;
    } else {
      if (c == '\r') {
	if (eol == CODE_EOL_CR)
	  *dp++ = '\n';
	else if (eol != CODE_EOL_CRLF || cntl & CC_CR)
	  *dp++ = c;
	else
	  cntl |= CC_CR;
      } else {
	if (cntl & CC_CR) {	/* eol == CODE_EOL_CRLF */
	  if (c != '\n') *dp++ = '\r';
	  cntl &= ~CC_CR;
	}
	if (SJIS_P(c)) {
	  ch = c;
	} else {
	  if (c & 0x80) *dp++ = LCKANA;
	  *dp++ = c;
	}
      }
    }
  }

  if (cntl & CC_END) {		/* 93.5.18 by K.Handa */
    if (ch) *dp++ = ch;
    else if (cntl & CC_CR) *dp++ = '\r';
  } else {
    CODE_COMPOSE0 (mccode, cntl, ch);
  }
  return (dp - dst);
}

int
b2g(src, dst, n, mccode)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp = dst, c;
  register unsigned int cntl, ch, form, eol;

  CODE_DECOMPOSE0 (mccode, cntl, ch, form);
  eol = form & CODE_EOL_MASK;

  while (n--) {
    c = *src++;			/* 93.4.23 by K.Handa */
    if (ch) {
      B2G(form & CODE_BIG5_ETEN, ch, c, *dp, *(dp+1), *(dp+2));
      dp += 3; ch = 0;
    } else {
      if (c == '\r') {
	if (eol == CODE_EOL_CR)
	  *dp++ = '\n';
	else if (eol != CODE_EOL_CRLF || cntl & CC_CR)
	  *dp++ = c;
	else
	  cntl |= CC_CR;
      } else {
	if (cntl & CC_CR) {	/* eol == CODE_EOL_CRLF */
	  if (c != '\n') *dp++ = '\r';
	  cntl &= ~CC_CR;
	}
	if (c > 0xa0)
	  ch = c;
	else
	  *dp++ = c;
      }
    }
  }

  if (cntl & CC_END) {		/* 93.5.18 by K.Handa */
    if (ch) *dp++ = ch;
    else if (cntl & CC_CR) *dp++ = '\r';
  } else {
    CODE_COMPOSE0 (mccode, cntl, ch);
  }
  return (dp - dst);
}

/* ISO2022 Interpreter */
i2g(src, dst, n, mccode)
     register unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  unsigned char lcg0, lcg1, lcg2, lcg3;
  register unsigned char c, lc, *dp = dst;
  register unsigned int cntl, ch, form, eol;

  CODE_DECOMPOSE (mccode, cntl, ch, form, lcg0, lcg1, lcg2, lcg3);
  eol = form & CODE_EOL_MASK;

  while (n--) {
    c = *src++;
    if (cntl & CC_ESCAPE) {	/* Within ESC sequence */
      /* 93.6.2 by K.Handa */
      switch (ch = lookup(c, &lcg0, &lcg1, &lcg2, &lcg3, cntl >> 16)) {
      case CC_ESC_DESIGNATE:
	cntl &= CC_LOCK; break;
      case CC_ESC_SS2:
	cntl = (cntl & CC_LOCK) | CC_SS2; break;
      case CC_ESC_SS3:
	cntl = (cntl & CC_LOCK) | CC_SS3; break;
      case CC_ESC_STARTCMP:
	cntl = (cntl & CC_LOCK) | CC_CMP; *dp++ = LCCMP; break;
      case CC_ESC_ENDCMP:
	cntl &= (CC_LOCK & ~CC_CMP); break;
      case CC_ESC_RVT_DIR:
      case CC_ESC_L2R_DIR:
	cntl &= (CC_LOCK & ~CC_R2L); break;
      case CC_ESC_R2L_DIR:
	cntl = (cntl & CC_LOCK) | CC_R2L; break;
      case CC_ESC_INVALID:	/* Just ouput the invalid sequence */
	ch = cntl >> 16;
	*dp++ = ESC;
	if (ch <= CC_ESC_2_15) *dp++ = ch + 0x28;
	else if (ch <= CC_ESC_2_4_15) *dp++ = '$', *dp++ = ch + 0x20;
	else if (ch == CC_ESC_2_4) *dp++ = '$';
	else if (ch == CC_ESC_5_11) *dp++ = '[';
	/* 93.6.27 by K.Handa */
	else if (ch >= CC_ESC_5_11_0 && ch <= CC_ESC_5_11_2)
	  *dp++ = '[', *dp++ = '0' + (ch - CC_ESC_5_11_0);
	cntl &= CC_LOCK;
	ch = 0, n++, src--;	/* Repeat the loop with the same character. */
	continue;
	/* end of patch */
      default:			/* Still in ESC sequence */
	cntl = (cntl & 0xFFFF) | (ch << 16);
      }
      ch = 0;
    } else if (C0_P (c) || C1_P (c)) { /* Control characters */
      while (ch) *dp++ = ch & 0x7F, ch >>= 8;
      if (cntl & CC_NON_LOCK) {
	if (cntl & CC_ESCAPE) *dp++ = ESC;
	else if (cntl & CC_SS2) *dp++ = SS2 & 0x7F;
	else if (cntl & CC_SS3) *dp++ = SS3 & 0x7F;
	else if (cntl & CC_CR && c != '\n') *dp++ = '\r';
	cntl &= CC_LOCK;
      }
      switch (c) {
      case ESC:			/* Start escape sequence */
	cntl |= CC_ESCAPE | (CC_ESC << 16); break;
      case SO:			/* Locking Shift for G1 charcter */
	if (lcg1 == LCINV) *dp++ = c;
	else cntl |= CC_SO;
	break;
      case SI:			/* Locking Shift for G0 charcter */
	if (lcg1 == LCINV) *dp++ = c;
	else cntl &= ~CC_SO;
	break;
      case SS2:			/* Single Shift for G2 character */
	if (lcg2 == LCINV) *dp++ = c;
	else cntl |= CC_SS2;
	break;
      case SS3:			/* Single Shift for G3 character */
	if (lcg3 == LCINV) *dp++ = c;
	else cntl |= CC_SS3;
	break;
      case 0x9B:		/* ISO6429 (specifying directionality) */
	cntl |= CC_ESCAPE | (CC_ESC_5_11 << 16);
	break;
      case '\r':
	if (eol == CODE_EOL_CR)
	  *dp++ = '\n';
	else if (eol == CODE_EOL_CRLF)
	  cntl |= CC_CR;
	else
	  *dp++ = c;
	break;
      default:			/* Other control characters */
	*dp++ = c;
      }
    } else {			/* Graphic characters */
      if (cntl & CC_CR) {
	*dp++ = '\r';
	cntl &= ~CC_CR;
      }
      lc =
	(cntl & CC_SS2) ? lcg2
	  : (cntl & CC_SS3) ? lcg3
	    : (cntl & CC_SO) || !ASCII_P (c) ? lcg1
	      : lcg0;
      if (lc == LCINV)		/* 92.12.15 by K.Handa */
	lc = LCASCII;
      else if ((c == ' ' || c == DEL)
	       && (char_type[lc] == TYPE94 || char_type[lc] == TYPE94N))
	lc = LCASCII;
      if (cntl & CC_R2L && !char_direction[lc]
	  || !(cntl & CC_R2L) && char_direction[lc])
	lc = rev_lc_table[lc];
      switch (char_bytes[lc]) {
      case ONEBYTE:		/* ASCII */
	while (ch) *dp++ = ch & 0x7F, ch >>= 8;
	if (cntl & CC_CMP) *dp++ = 0xA0, *dp++ = c | 0x80;
	else *dp++ = c & 0x7F;
	break;
      case TWOBYTE:
	while (ch) *dp++ = ch & 0x7F, ch >>= 8;
	if (cntl & CC_CMP) lc += 0x20;
	*dp++ = lc, *dp++ = c | 0x80;
	break;
      case THREEBYTE:
	if (0xA0 <= lc && lc < 0xC0) {
	  while (ch) *dp++ = ch & 0x7F, ch >>= 8;
	  *dp = lc < 0xB8 ? LCPRV11 : LCPRV12;
	  if (cntl & CC_CMP) *dp += 0x20;
	  dp++, *dp++ = lc, *dp++ = c | 0x80;
	} else {
	  while (ch > 0xFF) *dp++ = ch & 0x7F, ch >>= 8;
	  if (ch) {
	    if (cntl & CC_CMP) lc += 0x20;
	    *dp++ = lc, *dp++ = ch | 0x80, *dp++ = c | 0x80, ch = 0;
	  } else
	    ch = c;
	}
	break;
      default:			/* FOURBYTE */
	if (lc == LCPRV3) {
	  while (ch > 0xFFFF) *dp++ = ch & 0x7F, ch >>= 8;
	  if (ch > 0xFF) {
	    if (cntl & CC_CMP) lc += 0x20;
	    *dp++ = lc, *dp++ = (ch & 0xFF) + 0x40;
	    *dp++ = (ch >> 8) & 0xFF, *dp++ = c | 0xFF, ch = 0;
	  } else
	    ch = ch ? (ch | (c << 8)) : c;
	} else {
	  while (ch > 0xFF) *dp++ = ch & 0x7F, ch >>= 8;
	  if (ch) {
	    *dp = lc < 0xC8 ? LCPRV21 : LCPRV22;
	    if (cntl & CC_CMP) *dp += 0x20;
	    dp++, *dp++ = lc, *dp++ = ch | 0x80, *dp++ = c | 0x80, ch = 0;
	  } else
	    ch = c;
	}
      }
      if (!ch) cntl &= CC_LOCK;
    }
  }

  if (cntl & CC_END) {		/* 93.5.18 by K.Handa */
    while (ch) *dp++ = ch & 0x7F, ch >>= 8;
  } else {
    CODE_COMPOSE (mccode, cntl, ch, lcg0, lcg1, lcg2, lcg3);
  }
  return (dp - dst);
}

int
encode(mccode, src, dst, n, found)
     coding_type *mccode;
     unsigned int n;
     unsigned char *src, *dst;
     Lisp_Object *found;
{
  int len = 0, eol = CODE_EOL_AUTO;

  if (CODE_TYPE (mccode) == AUTOCONV) {
    int mask = code_detect(src, n), i;

    eol = CODE_FORM (mccode) & CODE_EOL_MASK;
    if (mask != M_ALL) {
      for (i = 0; i <= IDX_BIN; i++) {
	if (mask & (1 << code_priority_category[i])) break;
      }
      *found = Fsymbol_value (code_category[code_priority_category[i]]);
      encode_code(*found, mccode);
    }
  }

  if (eol != CODE_EOL_AUTO
      || (CODE_FORM (mccode) & CODE_EOL_MASK) == CODE_EOL_AUTO) {
    Lisp_Object val = Fget (*found, Qeol_type);

    if (eol == CODE_EOL_AUTO) eol = eol_detect(src, n);

    if (eol != CODE_EOL_AUTO && XTYPE (val) == Lisp_Vector) {
      switch (eol) {
      case CODE_EOL_LF:
	*found = XVECTOR (val)->contents[0]; break;
      case CODE_EOL_CRLF:
	*found = XVECTOR (val)->contents[1]; break;
      case CODE_EOL_CR:
	*found = XVECTOR (val)->contents[2]; break;
      }
      CODE_FORM (mccode) |= eol;
    }
  }

  switch (CODE_TYPE (mccode)) {
  case NOCONV: case ITNCODE:
    bcopy(src, dst, n);
    len = n;
    break;
  case AUTOCONV:
    len = a2g(src, dst, n, mccode);
    break;
  case SJIS:
    len = s2g(src, dst, n, mccode);
    break;
  case BIG5:
    len = b2g(src, dst, n, mccode);
    break;
  case CCL:
    len = ccl_driver(src, dst, n, CONV_BUF_SIZE (n, ITNCODE), mccode, 1);
    if (len < 0) len = - len;
    break;
  default:			/* ISO2022 */
    len = i2g(src, dst, n, mccode);
    break;
  }
  return len;
}

/* decode from INTERNAL */

int
g2a(src, dst, n, mccode)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp, c;
  register unsigned int selective = CODE_CNTL (mccode) & CC_SELECTIVE;
  register unsigned int eol = CODE_FORM (mccode) & CODE_EOL_MASK;

  if (eol != CODE_EOL_CRLF) {
    unsigned int i;

    bcopy(src, dst, n);
    if (selective) {
      i = n, dp = dst;
      while (i--)
	if (*dp++ == '\r') dp[-1] = '\n';
    }
    if (eol == CODE_EOL_CR) {
      i = n, dp = dst;
      while (i--)
	if (*dp++ == '\n') dp[-1] = '\r';
    }
    return n;
  }

  dp = dst;
  while (n--) {
    c = *src++;
    if (selective && c == '\r') c = '\n';
    if (c == '\n') *dp++ = '\r';
    *dp++ = c;
  }
  return (dp - dst);
}

int
g2s(src, dst, n, mccode)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp = dst, c;
  register unsigned int cntl, ch, form, selective;
  register unsigned int eol = CODE_FORM (mccode) & CODE_EOL_MASK;

  CODE_DECOMPOSE0 (mccode, cntl, ch, form);
  selective = cntl & CC_SELECTIVE;
  eol = form & CODE_EOL_MASK;

  while (n--) {
    c = *src++;
    if (selective && c == '\r') /* 93.5.6 by K.Handa */
      c = '\n';
    if (c == '\n') {
      if (eol != CODE_EOL_LF)	*dp++ = '\r';
      if (eol != CODE_EOL_CRLF) *dp++ = c;
      ch = 0;
    } else if (ASCII_P(c))
      *dp++ = c, ch = 0;
    else if (LC_P(c))
      ch = (c == LCKANA || c == LCJPOLD || c == LCJP) ? c : 0;
    else if (ch) {
      if (ch == LCKANA)
	*dp++ = c, ch = 0;
      else if (ch == LCJPOLD || ch == LCJP)
	ch = c;
      else {
	E2S(ch, c, *dp, *(dp+1)); dp += 2;
	ch = 0;
      }
    }
  }

  CODE_COMPOSE0 (mccode, cntl, ch);

  return (dp - dst);
}

int
g2b(src, dst, n, mccode)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp = dst, c, c1;
  register unsigned int cntl, ch, form, selective, eol;

  CODE_DECOMPOSE0 (mccode, cntl, ch, form);
  selective = cntl & CC_SELECTIVE;
  eol = form & CODE_EOL_MASK;

  while (n--) {
    c = *src++;			/* 93.3.4 by T.Enami */
    if (selective && c == '\r') /* 93.5.6 by K.Handa */
      c = '\n';
    if (c == '\n') {
      if (eol != CODE_EOL_LF)	*dp++ = '\r';
      if (eol != CODE_EOL_CRLF) *dp++ = c;
      ch = 0;
    } else if (ASCII_P(c))
      *dp++ = c, ch = 0;
    else if (LC_P(c))
      ch = (c == LCBIG5_1 || c == LCBIG5_2) ? c : 0;
    else if (ch) {
      if (ch == LCBIG5_1 || ch == LCBIG5_2)
	ch = ch << 8 | c;
      else {
	c1 = ch >> 8; ch &= 0xFF;
	G2B(c1, ch, c, form & CODE_BIG5_ETEN, *dp, *(dp+1));
	dp += 2;
	ch = 0;
      }
    }
  }

  CODE_COMPOSE0 (mccode, cntl, ch);

  return (dp - dst);
}

/* ISO2022 encodeer */
unsigned char *
designate(dp, oldlc, lc, graphic, form)
     register unsigned char *dp, oldlc, lc, graphic;
     register unsigned int form;
{
  char *inter94 = "()*+", *inter96= ",-./";

  if (char_type[oldlc] == char_type[lc] /* 93.6.2 by K.Handa */
      && char_final[oldlc] == char_final[lc])
    return dp;

  graphic %= 4;
  if (lc == LCASCII) {
    if (form & CODE_USE_ROMAN) lc = LCROMAN;
  } else if (lc == LCJP) {
    if (form & CODE_USE_OLDJIS) lc = LCJPOLD;
  }
  *dp++ = ESC;
  switch (char_type[lc]) {
  case TYPE94: case 0xFF:
    *dp++ = inter94[graphic];
    break;
  case TYPE96:
    *dp++ = inter96[graphic];
    break;
  case TYPE94N:
    *dp++ = '$';
    if (graphic != 0		/* 93.3.22 by K.Handa */
	|| !(form & CODE_SHORT)
	|| (lc != LCJPOLD && lc != LCJP && lc != LCCN))
      *dp++ = inter94[graphic];
    break;
  case TYPE96N:
    *dp++ = '$';
    *dp++ = inter96[graphic];
    break;
  }
  *dp++ = char_final[lc];
  return dp;
}

#define Designation_0(dp,lcg,lc,cntl,form) \
{ \
  if (cntl & CC_SHIFT_MASK) *dp++ = SI, cntl &= ~CC_SHIFT_MASK; \
  if (lc != lcg) dp = designate(dp, lcg, lc, 0, form), lcg = lc; \
  cntl = (cntl & ~CC_GRAPHIC_MASK) | CC_IN_G0; \
}

#define Designation_1(dp,lcg,lc,cntl,form) \
{ \
  if (cntl & CC_SHIFT_MASK) *dp++ = SI, cntl &= ~CC_SHIFT_MASK; \
  if (lc != lcg) dp = designate(dp, lcg, lc, 1, form), lcg = lc; \
  cntl = (cntl & ~CC_GRAPHIC_MASK) | CC_IN_G1; \
}

#define Locking_Shift(dp,lcg,lc,cntl,form) \
{ \
  if (lc != lcg) dp = designate(dp, lcg, lc, 1, form), lcg = lc; \
  cntl = (cntl & ~CC_GRAPHIC_MASK) | CC_IN_G1; \
  if (!(cntl & CC_SHIFT_G1)) { \
    *dp++ = SO, \
    cntl = (cntl & ~CC_SHIFT_MASK) | CC_SHIFT_G1; \
  } \
}
    
#define Single_Shift_2(dp,lcg,lc,cntl,form) \
{ \
  if (lc != lcg) dp = designate(dp, lcg, lc, 2, form), lcg = lc; \
  if (form & CODE_SEVEN) \
    *dp++ = ESC, *dp++ = 'N'; \
  else \
    *dp++ = SS2; \
  cntl = (cntl & ~CC_GRAPHIC_MASK) | CC_IN_G2; \
}

#define Single_Shift_3(dp,lcg,lc,cntl,form) \
{ \
  if (lc != lcg) dp = designate(dp, lcg, lc, 3, form), lcg = lc; \
  if (form & CODE_SEVEN) \
    *dp++ = ESC, *dp++ = 'N'; \
  else \
    *dp++ = SS3; \
  cntl = (cntl & ~CC_GRAPHIC_MASK) | CC_IN_G3; \
}

g2i(src, dst, n, mccode)
     register unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  register unsigned char *dp = dst, charmask, c;
  register char *p;
  register unsigned char lcg0, lcg1, lcg2, lcg3;
  unsigned int form, cntl, ch, selective, eol;
  unsigned char lc, char_boundary;

  CODE_DECOMPOSE (mccode, cntl, ch, form, lcg0, lcg1, lcg2, lcg3);
  selective = cntl & CC_SELECTIVE;
  eol = form & CODE_EOL_MASK;

  while (n--) {
    c = *src++;
    if (selective && c == '\r') /* 93.5.6 by K.Handa */
      c = '\n';
    if ((cntl & CC_CMP_MASK) == CC_CMP_LC) {
      if (c == 0xA0) {
	cntl = (cntl & ~CC_CMP_MASK) | CC_CMP_ASCII;
	continue;
      } else if (NONASCII_P (c)) {
	c -= 0x20;
      } else {
	*dp++ = ESC, *dp++ = '1'; /* End of composite character */
	cntl &= ~CC_CMP_MASK;
      }
    } else if ((cntl & CC_CMP_MASK) == CC_CMP_ASCII)
      c &= 0x7F;

    if (ASCII_P(c)) {		/* Processing ASCII character */
      ch = 0;
      if (cntl & CC_R2L) {	/* 93.6.2 by K.Handa */
	if (form & CODE_SEVEN)
	  *dp++ = ESC, *dp++ = '[', *dp++ = '0', *dp++ = ']';
	else
	  *dp++ = 0x9B, *dp++ = ']';
	cntl &= ~CC_R2L;
      }
      if (((C0_P(c) || c == ' ' || c == DEL) && form & CODE_ASCII_CNTL)
	  || (c > ' ' && c < DEL)) {
	if (cntl & CC_SHIFT_MASK)
	  *dp++ = SI, cntl &= ~CC_SHIFT_MASK;
	if (lcg0 != LCASCII)
	  dp = designate(dp, lcg0, LCASCII, 0, form), lcg0 = LCASCII;
      }
      if (c == '\n' && form & CODE_ASCII_EOL) {	/* 93.7.7 by K.Handa */
	if (cntl & CC_R2L) {
	  if (form & CODE_SEVEN)
	    *dp++ = ESC, *dp++ = '[', *dp++ = '0', *dp++ = ']';
	  else
	    *dp++ = 0x9B, *dp++ = ']';
	  cntl &= ~CC_R2L;
	}
	if (cntl & CC_CMP_MASK) *dp++ = ESC, *dp++ = '1';
	if (cntl & CC_SHIFT_MASK) *dp++ = SI;
	if (lcg0 != mccode->olcg0 && mccode->olcg0 != LCINV)
	  dp = designate(dp,lcg0,mccode->olcg0,0,form), lcg0 = mccode->olcg0;
	if (lcg1 != mccode->olcg1 && mccode->olcg1 != LCINV)
	  dp = designate(dp,lcg1,mccode->olcg1,1,form), lcg1 = mccode->olcg1;
	if (lcg2 != mccode->olcg2 && mccode->olcg2 != LCINV)
	  dp = designate(dp,lcg2,mccode->olcg2,2,form), lcg2 = mccode->olcg2;
	if (lcg3 != mccode->olcg3 && mccode->olcg3 != LCINV)
	  dp = designate(dp,lcg3,mccode->olcg3,3,form), lcg3 = mccode->olcg3;
	/* 92.4.8, 93.7.21, 93.8.30 by K.Handa */
	cntl = (cntl & (CC_SELECTIVE | CC_END)) | CC_IN_G0;
      }	
      cntl = (cntl & ~CC_GRAPHIC_MASK) | CC_IN_G0;
      if (c == '\n') {
	if (eol != CODE_EOL_LF) *dp++ = '\r';
	if (eol != CODE_EOL_CR) *dp++ = c;
      } else
	*dp++ = c;
      char_boundary = 1;
      if (cntl & CC_CMP_ASCII) cntl = (cntl & ~CC_CMP_MASK) | CC_CMP_LC;
    } else if (c == LCCMP) {	/* Start of composite character */
      ch = 0;
      *dp++ = ESC, *dp++ = '0';
      cntl = (cntl & ~CC_CMP_MASK) | CC_CMP_LC;
      char_boundary = 0;
    } else if (LC_P(c) || LC_P(ch)) { /* Processing Leading Character */
      ch = 0;
      lc = c;
      if (LCPRV11 <= lc && lc <= LCPRV22)
	ch = lc;
      else {
	if (cntl & CC_R2L && !char_direction[lc]) { /* 93.6.2 by K.Handa */
	  if (form & CODE_SEVEN)
	    *dp++ = ESC, *dp++ = '[', *dp++ = '0', *dp++ = ']';
	  else
	    *dp++ = 0x9B, *dp++ = ']';
	  cntl &= ~CC_R2L;
	} else if (!(form & CODE_NODIR)	/* 93.8.12 by K.Handa */
		   && !(cntl & CC_R2L) && char_direction[lc]) {
	  if (form & CODE_SEVEN)
	    *dp++ = ESC, *dp++ = '[';
	  else
	    *dp++ = 0x9B;
	  *dp++ = '2', *dp++ = ']';
	  cntl |= CC_R2L;
	}
	if (lc == lcg0 || lc == mccode->olcg0) {
	  if (mccode->ilcg0) lcg0 = LCINV, mccode->ilcg0 = 0;
	  Designation_0 (dp, lcg0, lc, cntl, form);
	} else if (lc == lcg1 || lc == mccode->olcg1) {
	  if (mccode->ilcg1) lcg1 = LCINV, mccode->ilcg1 = 0;
	  if (form & CODE_SEVEN) {
	    Locking_Shift (dp, lcg1, lc, cntl, form);
	  } else {
	    Designation_1 (dp, lcg1, lc, cntl, form);
	  }
	} else if (lc == lcg2 || lc == mccode->olcg2) {
	  if (mccode->ilcg2) lcg2 = LCINV, mccode->ilcg2 = 0;
	  Single_Shift_2(dp, lcg2, lc, cntl, form);
	} else if (lc == lcg3 || lc == mccode->olcg3) {
	  if (mccode->ilcg3) lcg3 = LCINV, mccode->ilcg3 = 0;
	  Single_Shift_3(dp, lcg3, lc, cntl, form);
	} else {		/* Not initially designated char-sets. */
	  if (char_graphic[lc] != GRAPHIC0) {
	    if (lcg1 != LCINV && !(form & CODE_SEVEN)) {
	      Designation_1 (dp, lcg1, lc, cntl, form);
	    } else if (lcg1 != LCINV && form & CODE_LOCK_SHIFT) {
	      Locking_Shift (dp, lcg1, lc, cntl, form);
	    } else if (lcg2 != LCINV) {
	      Single_Shift_2 (dp, lcg2, lc, cntl, form);
	    } else if (lcg3 != LCINV) {
	      Single_Shift_3 (dp, lcg3, lc, cntl, form);
	    } else {
	      Designation_0 (dp, lcg0, lc, cntl, form);
	    }
	  } else {
	    Designation_0 (dp, lcg0, lc, cntl, form);
	  }
	}
      }
      char_boundary = 0;
      if ((cntl & CC_CMP_MASK) == CC_CMP_LC)
	cntl = (cntl & ~CC_CMP_MASK) | CC_CMP_NONASCII;
    } else {			/* Processing Non-ASCII character */
      charmask = (form & CODE_SEVEN) ? 0x7F : 0xFF;
      switch (cntl & CC_GRAPHIC_MASK) {
      case CC_IN_G2: lc = lcg2; break;
      case CC_IN_G3: lc = lcg3; break;
      case CC_IN_G1: lc = lcg1; break;
      default: lc = lcg0; charmask = 0x7F;
      }
      char_boundary = 1;
      switch (char_bytes[lc]) {
      case TWOBYTE:
	*dp++ = c & charmask; break;
      case THREEBYTE:
	if (0xA0 <= lc && lc < 0xC0) *dp++ = c & charmask, ch = 0;
	else if (ch) *dp++ = ch & charmask, *dp++ = c & charmask, ch = 0;
	else ch = c, char_boundary = 0;
	break;
      case FOURBYTE:
	if (0xC0 <= lc) {
	  if (ch) *dp++ = ch & charmask, *dp++ = c & charmask, ch = 0;
	  else ch = c, char_boundary = 0;
	} else {
	  if (ch > 0xFF) {
	    *dp++ = ch & charmask; *dp++ = (ch >> 8) & charmask,
	    *dp++ = c & charmask, ch = 0;
	  } else {
	    if (ch) ch |= c << 8;
	    else ch = c;
	    char_boundary = 0;
	  }
	}
      }
      if (char_boundary && (cntl & CC_CMP_MASK) == CC_CMP_NONASCII)
	cntl = (cntl & ~CC_CMP_MASK) | CC_CMP_LC;
    }
  }
  if (char_boundary && cntl & CC_END) {
    if (cntl & CC_R2L) {	/* 93.6.2 by K.Handa */
      if (form & CODE_SEVEN)
	*dp++ = ESC, *dp++ = '[', *dp++ = '0', *dp++ = ']';
      else
	*dp++ = 0x9B, *dp++ = ']';
      cntl &= ~CC_R2L;
    }
    if (cntl & CC_CMP_MASK) *dp++ = ESC, *dp++ = '1';
    if (cntl & CC_SHIFT_MASK) *dp++ = SI;
    if (lcg0 != mccode->olcg0 && mccode->olcg0 != LCINV)
      dp = designate(dp, lcg0, mccode->olcg0, 0, form), lcg0 = mccode->olcg0;
    if (lcg1 != mccode->olcg1 && mccode->olcg1 != LCINV)
      dp = designate(dp, lcg1, mccode->olcg1, 1, form), lcg1 = mccode->olcg1;
    if (lcg2 != mccode->olcg2 && mccode->olcg2 != LCINV)
      dp = designate(dp, lcg2, mccode->olcg2, 2, form), lcg2 = mccode->olcg2;
    if (lcg3 != mccode->olcg3 && mccode->olcg3 != LCINV)
      dp = designate(dp, lcg3, mccode->olcg3, 3, form), lcg3 = mccode->olcg3;
    cntl = CC_IN_G0;		/* 92.4.8 by K.Handa */
  }

  CODE_COMPOSE (mccode, cntl, ch, lcg0, lcg1, lcg2, lcg3);
  return (dp - dst);
}

int
decode(mccode, src, dst, n)
     unsigned char *src, *dst;
     unsigned int n;
     coding_type *mccode;
{
  int len;

  switch (CODE_FORM (mccode) & CODE_EOL_MASK) {
  case CODE_EOL_NOCONV:
    CODE_FORM (mccode) &= ~CODE_EOL_MASK; /* fall through */
  case CODE_EOL_AUTO:
    CODE_FORM (mccode) |= CODE_EOL_LF;
    break;
  }

  switch (CODE_TYPE (mccode)) {	/* 94.2.1 by K.Handa */
  case NOCONV: case ITNCODE:
    bcopy(src, dst, n);
    if (CODE_CNTL(mccode) & CC_SELECTIVE) { /* 93.5.6 by K.Handa */
      unsigned char *end = dst + n;
      while (dst < end)
	if (*dst++ == '\015') dst[-1] = '\n';
    }
    len = n;
    break;
  case AUTOCONV:
    len = g2a(src, dst, n, mccode);
    break;
  case SJIS:
    len = g2s(src, dst, n, mccode);
    break;
  case BIG5:
    len = g2b(src, dst, n, mccode);
    break;
  case CCL:
    len = ccl_driver(src, dst, n, CONV_BUF_SIZE (n, CCL), mccode, 0);
    if (len < 0) len = - len;
    break;
  default:
    len = g2i(src, dst, n, mccode);
    break;
  }
  return len;
}

#ifdef emacs

char conversion_buffer[CONVERSION_BUFFER_SIZE];
char *current_conv_buf;
int current_conv_buf_size;

char *
get_conversion_buffer(size,type)
     int size, type;
{
  size = CONV_BUF_SIZE (size, type); /* 93.2.10 by K.Handa */
  if (size > current_conv_buf_size) {
    if (current_conv_buf != &conversion_buffer[0]) free(current_conv_buf);
    current_conv_buf_size = size;
    if ((current_conv_buf = (char *)malloc(size)) == (char *)0) {
      current_conv_buf = conversion_buffer;
      current_conv_buf_size = CONVERSION_BUFFER_SIZE;
      memory_full ();
    }
  }
  return current_conv_buf;
}

/* 92.12.21 by K.Handa */
DEFUN ("coding-system-p", Fcoding_system_p, Scoding_system_p, 1, 1, 0,
  "T if OBJECT is a coding-system.")
  (obj)
     register Lisp_Object obj;
{
  if (NULL (obj))
    return Qt;
  while (!NULL (obj) && XTYPE (obj) == Lisp_Symbol)
    obj = Fget (obj, Qcoding_system);
  if (NULL (obj))
    return Qnil;

  if (XTYPE (obj) == Lisp_Vector
      && XVECTOR (obj)->size == 5
      && (XFASTINT (XVECTOR (obj)->contents[0]) != 2
	  || (XTYPE (XVECTOR (obj)->contents[4]) == Lisp_Vector
	      && XVECTOR (XVECTOR (obj)->contents[4])->size == 32)))
    return Qt;
  return Qnil;
}

DEFUN ("non-nil-coding-system-p", Fnon_nil_coding_system_p, Snon_nil_coding_system_p, 1, 1, 0,
  "T if OBJECT is a non-nil coding-system.")
  (obj)
     register Lisp_Object obj;
{
  if (NULL (obj))
    return Qnil;
  return Fcoding_system_p (obj);
}

DEFUN ("read-coding-system", Fread_coding_system, Sread_coding_system, 1, 1, 0,
  "Read a coding-system from the minibuffer, prompting with string PROMPT.")
  (prompt)
     Lisp_Object prompt;
{
  return Fcompleting_read (prompt, Vobarray, Qcoding_system_p, Qt, Qnil);
}

DEFUN ("read-non-nil-coding-system",
       Fread_non_nil_coding_system, Sread_non_nil_coding_system, 1, 1, 0,
  "Read a non-nil coding-system from the minibuffer, prompting with string PROMPT.")
  (prompt)
     Lisp_Object prompt;
{
  return Fcompleting_read (prompt, Vobarray, Qnon_nil_coding_system_p,
			   Qt, Qnil);
}

DEFUN ("check-coding-system", Fcheck_code, Scheck_code, 1, 2, 0,
  "Check validity of CODING-SYSTEM.\n\
CODING-SYSTEM is valid if it is a symbol and has \"coding-system\" property.\n\
The value of property should be a vector of length 5.\n\
See document of make-coding-system for more detail.\n\
If not valid, coding-system-error is signaled.")
  (code)
     Lisp_Object code;
{				/* 92.4.7 by K.Handa */
  Lisp_Object prop;

  CHECK_SYMBOL (code, 0);

  if (!NULL (Fcoding_system_p (code)))
    return code;

  while (1)
    Fsignal (Qcoding_system_error, code);
}

encode_code(code, mccode)
     Lisp_Object code;
     coding_type *mccode;
{
  Lisp_Object type, prop, eol_type, *flags;
  int lcg0, lcg1, lcg2, lcg3;

  CODE_TYPE_SET (mccode, NOCONV);
  CODE_FORM (mccode) = 0;

  prop = code;
  while (!NULL (prop) && XTYPE (prop) == Lisp_Symbol)
    prop = Fget (prop, Qcoding_system);

  if (XTYPE (prop) == Lisp_Vector
      && XVECTOR (prop)->size == 5) {
    type = XVECTOR (prop)->contents[0];
    eol_type = Fget(code, Qeol_type);
    CODE_FORM (mccode) =
      XTYPE (eol_type) == Lisp_Vector ? CODE_EOL_AUTO
	: NULL (eol_type) ? CODE_EOL_NOCONV
	  : XFASTINT (eol_type) == 1 ? CODE_EOL_LF
	    : XFASTINT (eol_type) == 2 ? CODE_EOL_CRLF : CODE_EOL_CR;
    CODE_CHAR_SET (mccode, 0);
    switch (XFASTINT (type)) {
    case 0:
      CODE_TYPE_SET (mccode, ITNCODE);
      break;
    case 1:
      CODE_TYPE_SET (mccode, SJIS);
      break;
    case 2:
      prop = XVECTOR (prop)->contents[4];
      if (XTYPE (prop) != Lisp_Vector || XVECTOR (prop)->size != 32)
	break;
      CODE_TYPE_SET (mccode, ISO2022);
      flags = XVECTOR (prop)->contents;
      lcg0 = NULL (flags[0]) ? LCASCII : XINT (flags[0]);
      lcg1 = NULL (flags[1]) ? LCASCII : XINT (flags[1]);
      lcg2 = NULL (flags[2]) ? LCASCII : XINT (flags[2]);
      lcg3 = NULL (flags[3]) ? LCASCII : XINT (flags[3]);
      CODE_LC_SET (mccode, lcg0, lcg1, lcg2, lcg3);
      CODE_FORM_SET (mccode,
		     flags[4], flags[5], flags[6], flags[7],
		     flags[8], flags[9], flags[10], flags[11]);
      break;
    case 3:
      CODE_TYPE_SET (mccode, BIG5);
      CODE_FORM_SET (mccode, Qnil, Qnil, Qnil, Qnil, Qnil, Qnil,
		     XVECTOR (prop)->contents[4], Qnil);
      break;
    case 4:
      CODE_TYPE_SET (mccode, CCL);
      prop = XVECTOR (prop)->contents[4];
      CODE_CCL_ENCODE (mccode) = Fcar (prop);
      CODE_CCL_DECODE (mccode) = Fcdr (prop);
      break;
    default:
      if (EQ (type, Qt))
	CODE_TYPE_SET (mccode, AUTOCONV);
      else 
	CODE_TYPE_SET (mccode, NOCONV);
      break;
    }
  }
}

DEFUN ("s2e", Fs2e, Ss2e, 2, 2, 0,
  "Convert Shift-JIS code C1, C2 to EUC code e1, e2,\n\
and return cons of them.")
  (c1, c2)
     Lisp_Object c1, c2;
{
  Lisp_Object e1, e2;

  CHECK_NUMBER (c1, 0); CHECK_NUMBER (c2, 1);
  S2E (XFASTINT (c1), XFASTINT (c2), XFASTINT (e1), XFASTINT (e2));
  return Fcons (e1, e2);
}

DEFUN ("e2s", Fe2s, Se2s, 2, 2, 0,
  "Convert EUC code E1, E2 to Shift-JIS code c1, c2,\n\
and return cons of them.")
  (e1, e2)
     Lisp_Object e1, e2;
{
  Lisp_Object c1, c2;

  CHECK_NUMBER (e1, 0); CHECK_NUMBER (e2, 1);
  E2S (XFASTINT (e1), XFASTINT (e2), XFASTINT (c1), XFASTINT (c2));
  return Fcons (c1, c2);
}

/* 93.11.15 by K.Handa */
DEFUN ("b2m", Fb2m, Sb2m, 2, 2, 0,
  "Convert Big5 code BIG5 of type ETEN to a character.\n\
If ETEN is nil, HKU type is assumed.")
  (big5, eten)
     Lisp_Object big5, eten;
{
  unsigned char a1, a2, str[4];
  Lisp_Object ch;

  CHECK_NUMBER (big5, 0);
  a1 = (XFASTINT (big5)) >> 8, a2 = (XFASTINT (big5)) & 0xFF;
  B2G (!NULL (eten), a1, a2, str[0], str[1], str[2]);
  str[3] = 0;
  XSET (ch, Lisp_Int, string_to_mchar (str, 4));
  return ch;
}

DEFUN ("m2b", Fm2b, Sm2b, 2, 2, 0,
  "Convert a Big5 character CHAR to Big5 code of type ETEN.\n\
If ETEN is nil, converted HKU code.\n\
If CHAR is not a Big5 character, nil is returned. ")
  (ch, eten)
     Lisp_Object ch, eten;
{
  unsigned char a1, a2, str[4];
  unsigned int c;
  Lisp_Object big5;

  CHECK_CHARACTER (ch, 0);
  c = XINT (ch);
  CHARtoSTR(c, str);
  if (str[0] != LCBIG5_1 && str[0] != LCBIG5_2)
    return Qnil;
  G2B (str[0], str[1], str[2], !NULL (eten), a1, a2);
  XSET (big5, Lisp_Int, (a1 << 8) | a2);
  return big5;
}
/* end of patch */

/* 92.3.24 by K.Handa - make it non-interactive */
/* 93.6.19 by K.Handa - big change for not altering point. */
DEFUN ("code-convert-region", Fcode_convert_region,
       Scode_convert_region, 4, 4, 0,
  "Convert coding sytem of the text between START and END from SOURCE\n\
to TARGET.  On successful conversion returns t,\n\
else returns nil without modifying buffer.")
  (b, e, src, tgt)
      Lisp_Object b, e, src, tgt;
{
  int len, beg, end, pos;
  char *buf;
  coding_type scode, tcode;
  Lisp_Object code;

  CHECK_NUMBER_COERCE_MARKER (b, 0);
  CHECK_NUMBER_COERCE_MARKER (e, 1);

  encode_code(Fcheck_code(src), &scode);
  encode_code(Fcheck_code(tgt), &tcode);

  prepare_to_modify_buffer ();
  /* 93.6.19 by K.Handa  -- We can't call validate_region because
     it signals error and we don't have a chance to recover mc_flag. */
  /* validate_region (&b, &e); */
  beg = XINT (b);
  end = XINT (e);
  if (beg > end)
    beg = end, end = XINT (b);

  if (!(BEGV <= beg && end <= ZV))
    args_out_of_range (b, e);

  if (beg < GPT && end >= GPT) /* 89-09-03 by S.Tomura, 91.11.1 by K.Handa */
    move_gap (end);

  len = end - beg;
  if (CODE_TYPE(&scode) == ITNCODE) {
    buf = get_conversion_buffer(len, CODE_TYPE(&tcode)); /* 93.2.10 by K.Handa */
    CODE_CNTL(&tcode) |= CC_END;
    len = decode(&tcode, &FETCH_CHAR (beg), buf, len);
    if (CODE_CHAR(&tcode)) len = -1;
  } else if (CODE_TYPE(&tcode) == ITNCODE) {
    buf = get_conversion_buffer(len, ITNCODE); /* 93.2.10 by K.Handa */
    code = src;
    len = encode(&scode, &FETCH_CHAR (beg), buf, len, &code);
    if (CODE_CHAR(&scode)) len = -1;
  } else {			/* 92.3.24 by K.Handa */
    error ("At least one of SOURCE and TARGET should be *internal*.");
  }
  if (len >= 0) {
    pos = PT;
    SET_PT (beg);
    insert (buf, len);
    del_range(beg + len, end + len);
    SET_PT (pos <= beg ? pos : pos >= end ? pos + len - (end - beg) : beg);
  }
  return (len < 0 ? Qnil : Qt);
}

#if 0
/* 93.6.20 by K.Handa - defined in Emacslisp */
DEFUN ("code-convert-string", Fcode_convert_string,
       Scode_convert_string, 3, 3, 0,
  "Convert code in STRING from SOURCE code to TARGET code,\n\
and return the result string on successful converion.\n\
If fails, return nil.")
  (str, src, tgt)
      Lisp_Object str, src, tgt;
{
  int len;
  char *buf;
  coding_type scode, tcode;
  Lisp_Object dummy;

  encode_code(Fcheck_code(src), &scode);
  encode_code(Fcheck_code(tgt), &tcode);
  CHECK_STRING(str, 0);

  len = XSTRING(str)->size;
  if (CODE_TYPE(&scode) == ITNCODE) {
    buf = get_conversion_buffer(len, CODE_TYPE(&tcode)); /* 93.2.10 by K.Handa */
    CODE_CNTL(&tcode) |= CC_END;
    len = decode(&tcode, XSTRING (str)->data, buf, len);
    if (CODE_CHAR(&tcode)) len = -1;
  } else if (CODE_TYPE(&tcode) == ITNCODE) {
    buf = get_conversion_buffer(len, ITNCODE); /* 93.2.10 by K.Handa */
    len = encode(&scode, XSTRING (str)->data, buf, len, &dummy);
    if (CODE_CHAR(&scode)) len = -1;
  } else
    error ("At least one of SOURCE and TARGET should be *internal*.");

  return (len < 0 ? Qnil : make_string(buf, len));
}
#endif /* 0 */

init_codeconv()
{
  current_conv_buf_size = CONVERSION_BUFFER_SIZE;
  current_conv_buf = conversion_buffer;
}

syms_of_codeconv ()
{
  Lisp_Object val;

  Qcoding_system_error = intern ("coding-system-error");
  staticpro (&Qcoding_system_error); /* 94.2.8 by K.Handa */

  Fput (Qcoding_system_error, Qerror_conditions,
	Fcons (Qcoding_system_error, Fcons (Qerror, Qnil)));
  Fput (Qcoding_system_error, Qerror_message,
	build_string ("Coding-system error"));

  defsubr (&Sset_code_priority);
  defsubr (&Scode_detect_region);
  defsubr (&Scoding_system_p);
  defsubr (&Snon_nil_coding_system_p);
  defsubr (&Sread_coding_system);
  defsubr (&Sread_non_nil_coding_system);
  defsubr (&Scheck_code);
  defsubr (&Ss2e);
  defsubr (&Se2s);
  defsubr (&Sb2m);		/* 93.11.15 by K.Handa */
  defsubr (&Sm2b);		/* 93.11.15 by K.Handa */
  defsubr (&Scode_convert_region);
  /* defsubr (&Scode_convert_string); */

  DEFVAR_LISP ("keyboard-coding-system", &Vkeyboard_coding_system,
    "Coding-system object for keyboard input.");
  Vkeyboard_coding_system = Qnil;

  DEFVAR_LISP ("display-coding-system", &Vdisplay_coding_system,
    "Coding_system object for terminal output.");
  Vdisplay_coding_system = Qnil;

/* 94.2.8 by K.Handa */
  Qeol_type = intern ("eol-type");
  staticpro (&Qeol_type);

  Qpriority = intern ("priority");
  staticpro (&Qpriority);

  code_category[IDX_ITN] = intern ("*coding-category-internal*");
  staticpro (&code_category[IDX_ITN]);

  code_category[IDX_SJIS] = intern ("*coding-category-sjis*");
  staticpro (&code_category[IDX_SJIS]);

  code_category[IDX_ISO_7] = intern ("*coding-category-iso-7*");
  staticpro (&code_category[IDX_ISO_7]);

  code_category[IDX_ISO_8_1] = intern ("*coding-category-iso-8-1*");
  staticpro (&code_category[IDX_ISO_8_1]);

  code_category[IDX_ISO_8_2] = intern ("*coding-category-iso-8-2*");
  staticpro (&code_category[IDX_ISO_8_2]);

  code_category[IDX_ISO_ELSE] = intern ("*coding-category-iso-else*");
  staticpro (&code_category[IDX_ISO_ELSE]);

  code_category[IDX_BIG5] = intern ("*coding-category-big5*");
  staticpro (&code_category[IDX_BIG5]);

  code_category[IDX_BIN] = intern ("*coding-category-bin*");
  staticpro (&code_category[IDX_BIN]);
/* end of patch */

/* 92.12.18 by K.Handa */
  Qcoding_system = intern ("coding-system");
  staticpro (&Qcoding_system);

  Qcoding_system_p = intern ("coding-system-p");
  staticpro (&Qcoding_system_p);

  Qnon_nil_coding_system_p = intern ("non-nil-coding-system-p");
  staticpro (&Qnon_nil_coding_system_p);
/* end of patch */
}
#endif /* emacs */
