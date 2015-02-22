/* This file is Demacs specific, so should be placed the source directory. */
/*		    previously
 * int kbdhit () <- dos_keysns ()
 * int getkey () <- dos_keyread ()
 */

static int prev_get_char = -1;

#if 0
dos_keysns ()
#else
kbhit ()
#endif
{
  if (prev_get_char != -1)
    return 1;
  else if ((prev_get_char = rawgetc ()) != -1)
    return 1;
  else
    return 0;
}

#if 0
dos_keyread ()
#else
getkey ()
#endif
{
  int c;

  if (prev_get_char != -1) {
    c = prev_get_char;
    prev_get_char = -1;
  } else {
    c = rawgetc ();
  }
  return c;
}

/* The following objects are declared `static' (means this file specific). */

#include "config.h"
#include "lisp.h"      /* `EQ' macro and etc. was defined. */
#include "termopts.h"  /* `meta_key' was externed. */
#include "dosfns.h"
#include <dos.h>

#if defined(J3100) || defined(IBMPC)
static char ibmpc_remap_extended_key_code[][2] = {
  /* KEY#: KeyTop CHR. */
  /* 0x00:             */ {0,0,},
  /* 0x01:             */ {0,0,},
  /* 0x02:             */ {0,0,},
  /* 0x03: Null        */ {0,0,},
  /* 0x04:             */ {0,0,},
  /* 0x05:             */ {0,0,},
  /* 0x06:             */ {0,0,},
  /* 0x07:             */ {0,0,},
  /* 0x08:             */ {0,0,},
  /* 0x09:             */ {0,0,},
  /* 0x0a:             */ {0,0,},
  /* 0x0b:             */ {0,0,},
  /* 0x0c:             */ {0,0,},
  /* 0x0d:             */ {0,0,},
  /* 0x0e:             */ {0,0,},
  /* 0x0f: Shift-TAB   */ {0,0,},
  /* 0x10: Q           */ {'q','Q',},
  /* 0x11: W           */ {'w','W',},
  /* 0x12: E           */ {'e','E',},
  /* 0x13: R           */ {'r','R',},
  /* 0x14: T           */ {'t','T',},
  /* 0x15: Y           */ {'y','Y',},
  /* 0x16: U           */ {'u','U',},
  /* 0x17: I           */ {'i','I',},
  /* 0x18: O           */ {'o','O',},
  /* 0x19: P           */ {'p','P',},
  /* 0x1a:             */ {0,0,},
  /* 0x1b:             */ {0,0,},
  /* 0x1c:             */ {0,0,},
  /* 0x1d: 	       */ {0,0,},
  /* 0x1e: A           */ {'a','A',},
  /* 0x1f: S           */ {'s','S',},
  /* 0x20: D           */ {'d','D',},
  /* 0x21: F           */ {'f','F',},
  /* 0x22: G           */ {'g','G',},
  /* 0x23: H           */ {'h','H',},
  /* 0x24: J           */ {'j','J',},
  /* 0x25: K           */ {'k','K',},
  /* 0x26: L           */ {'l','L',},
  /* 0x27:             */ {0,0,},
  /* 0x28:             */ {0,0,},
  /* 0x29:             */ {0,0,},
  /* 0x2a:             */ {0,0,},
  /* 0x2b:             */ {0,0,},
  /* 0x2c: Z           */ {'z','Z',},
  /* 0x2d: X           */ {'x','X',},
  /* 0x2e: C           */ {'c','C',},
  /* 0x2f: V           */ {'v','V',},
  /* 0x30: B           */ {'b','B',},
  /* 0x31: N           */ {'n','N',},
  /* 0x32: M           */ {'m','M',},
  /* 0x33:             */ {0,0,},
  /* 0x34:             */ {0,0,},
  /* 0x35:             */ {0,0,},
  /* 0x36:             */ {0,0,},
  /* 0x37:             */ {0,0,},
  /* 0x38:             */ {0,0,},
  /* 0x39:             */ {0,0,},
  /* 0x3a:             */ {0,0,},
  /* 0x3b: F1          */ {0,0,}, /* "59", */
  /* 0x3c: F2          */ {0,0,}, /* "60", */
  /* 0x3d: F3          */ {0,0,}, /* "61", */
  /* 0x3e: F4          */ {0,0,}, /* "62", */
  /* 0x3f: F5          */ {0,0,}, /* "63", */
  /* 0x40: F6          */ {0,0,}, /* "64", */
  /* 0x41: F7          */ {0,0,}, /* "65", */
  /* 0x42: F8          */ {0,0,}, /* "66", */
  /* 0x43: F9          */ {0,0,}, /* "67", */
  /* 0x44: F10         */ {0,0,}, /* "68", */
  /* 0x45:             */ {0,0,},
  /* 0x46:             */ {0,0,},
  /* 0x47: Home        */ {0,0,}, /* "71", */
  /* 0x48: Up Arrow    */ {0,0,}, /* "72", */
  /* 0x49: PgUp        */ {0,0,}, /* "73", */
  /* 0x4a:             */ {0,0,},
  /* 0x4b: Left Arrow  */ {0,0,}, /* "75", */
  /* 0x4c:             */ {0,0,},
  /* 0x4d: Right Arrow */ {0,0,}, /* "77", */
  /* 0x4e:             */ {0,0,},
  /* 0x4f: End         */ {0,0,}, /* "79", */
  /* 0x50: Down Arrow  */ {0,0,}, /* "80", */
  /* 0x51: PgDn        */ {0,0,}, /* "81", */
  /* 0x52: Ins         */ {0,0,}, /* "82", */
  /* 0x53: Del         */ {0,0,}, /* "83", */
  /* 0x54: Shift-F1    */ {0,0,}, /* "84", */
  /* 0x55: Shift-F2    */ {0,0,}, /* "85", */
  /* 0x56: Shift-F3    */ {0,0,}, /* "86", */
  /* 0x57: Shift-F4    */ {0,0,}, /* "87", */
  /* 0x58: Shift-F5    */ {0,0,}, /* "88", */
  /* 0x59: Shift-F6    */ {0,0,}, /* "89", */
  /* 0x5a: Shift-F7    */ {0,0,}, /* "90", */
  /* 0x5b: Shift-F8    */ {0,0,}, /* "91", */
  /* 0x5c: Shift-F9    */ {0,0,}, /* "92", */
  /* 0x5d: Shift-F10   */ {0,0,}, /* "93", */
  /* 0x5e: Ctrl-F1     */ {0,0,}, /* "94", */
  /* 0x5f: Ctrl-F2     */ {0,0,}, /* "95", */
  /* 0x60: Ctrl-F3     */ {0,0,}, /* "96", */
  /* 0x61: Ctrl-F4     */ {0,0,}, /* "97", */
  /* 0x62: Ctrl-F5     */ {0,0,}, /* "98", */
  /* 0x63: Ctrl-F6     */ {0,0,}, /* "99", */
  /* 0x64: Ctrl-F7     */ {0,0,}, /* "100", */
  /* 0x65: Ctrl-F8     */ {0,0,}, /* "101", */
  /* 0x66: Ctrl-F9     */ {0,0,}, /* "102", */
  /* 0x67: Ctrl-F10    */ {0,0,}, /* "103", */
  /* 0x68: Alt-F1      */ {0,0,}, /* "104", */
  /* 0x69: Alt-F2      */ {0,0,}, /* "105", */
  /* 0x6a: Alt-F3      */ {0,0,}, /* "106", */
  /* 0x6b: Alt-F4      */ {0,0,}, /* "107", */
  /* 0x6c: Alt-F5      */ {0,0,}, /* "108", */
  /* 0x6d: Alt-F6      */ {0,0,}, /* "109", */
  /* 0x6e: Alt-F7      */ {0,0,}, /* "110", */
  /* 0x6f: Alt-F8      */ {0,0,}, /* "111", */
  /* 0x70: Alt-F9      */ {0,0,}, /* "112", */
  /* 0x71: Alt-F10     */ {0,0,}, /* "113", */
  /* 0x72: Ctrl-PtrSc  */ {0,0,}, /* "114", */
  /* 0x73: Ctrl-LA     */ {0,0,}, /* "115", */
  /* 0x74: Ctrl-RA     */ {0,0,}, /* "116", */
  /* 0x75: Ctrl-End    */ {0,0,}, /* "117", */
  /* 0x76: Ctrl-PgDn   */ {0,0,}, /* "118", */
  /* 0x77:             */ {0,0,},
  /* 0x78: 1 !         */ {'1','!',},
  /* 0x79: 2 @         */ {'2','@',},
  /* 0x7a: 3 #         */ {'3','#',},
  /* 0x7b: 4 $         */ {'4','$',},
  /* 0x7c: 5 %         */ {'5','%',},
  /* 0x7d: 6 ^         */ {'6','^',},
  /* 0x7e: 7 &         */ {'7','&',},
  /* 0x7f: 8 *         */ {'8','*',},
  /* 0x80: 9 (         */ {'9','(',},
  /* 0x81: 0 )         */ {'0',')',},
  /* 0x82: - _         */ {'-','_',},
  /* 0x83: = +         */ {'=','+',},
  /* 0x84: Ctrl-PgUp   */ {0,0,}, /* "119", */
};
#endif /* J3100 or IBMPC */

#define M_Shift_L    0x01
#define M_Shift_R    0x02
#define M_Control    0x04
#define M_Alt	     0x08
#define M_ScrollLock 0x10
#define M_NumLock    0x20
#define M_CapsLock   0x40
#define M_Ins        0x80

static unsigned char
get_modifiers()
{
#if defined(J3100) || defined(IBMPC)
  if (EQ (Vdos_machine_type, Qj3100) || 
      EQ (Vdos_machine_type, Qibmpc))
    {
      union REGS regs;
      regs.h.ah = 0x02; /* get shift status */
      int86 (0x16, &regs, &regs);
      return (unsigned char) regs.h.al;
    }
  else
#endif
    return 0;
}

static char kbd_buf[6] = {
  -1, -1, -1, -1, -1, -1,
};

static char *kbd_bufp = kbd_buf;

static int
rawgetc ()
{
  union REGS regs;
  unsigned char ascii_code, scan_code;
  unsigned char modifiers;
  extern int ibmpc_enhanced_keyboard;
  extern int meta_prefix_char;

  if (*kbd_bufp != -1)
    {
      register short temp = *kbd_bufp;
      *kbd_bufp++ = -1;
      if (*kbd_bufp == -1) {
	kbd_bufp = kbd_buf;
      }
      return (int) temp;
    }

#if defined(J3100) || defined(IBMPC)
  if (EQ (Vdos_machine_type, Qj3100) ||
      EQ (Vdos_machine_type, Qibmpc))
    {
      regs.h.ah = ibmpc_enhanced_keyboard ? 0x11 : 0x01;
      int86 (0x16, &regs, &regs);

      if (regs.x.flags & 0x40) return (-1);

      regs.h.ah = ibmpc_enhanced_keyboard ? 0x10 : 0x00;
      int86 (0x16, &regs, &regs);
    }
  else
#endif
    {
      regs.h.ah = 0x06;
      regs.h.dl = 0xff;
      intdos (&regs, &regs);

      if (regs.x.flags & 0x40) return (-1);
    }

  ascii_code = ((unsigned short) regs.x.ax) & 0xff;
  scan_code  = ((unsigned short) regs.x.ax) >> 8;
  modifiers = get_modifiers ();

#if defined(J3100) || defined(IBMPC)
  if (EQ (Vdos_machine_type, Qj3100) ||
      EQ (Vdos_machine_type, Qibmpc))
    {
      if ((modifiers & M_Alt) && (!ascii_code && scan_code <= 0x84))
	{
	  register int shift = (modifiers & (M_Shift_L | M_Shift_R) ? 1 : 0);
	  ascii_code = ibmpc_remap_extended_key_code[scan_code][shift];
	  if ((modifiers & M_Control) && isalpha (ascii_code))
	    ascii_code = (toupper (ascii_code) - 'A') + 1;
	}

      if (scan_code == 0x53) /* "Del"	*/
	return 0x7f; /* DEL */
      
      switch (scan_code)
	{
	case 0x03:
	  if (!ascii_code) /* C-@	    */
	    return 0x0;
	  else 
	    break;
#if 0
	case 0x48:     /* "Up Arrow"    */
	  return 0x10; /* ^P */
	case 0x50:     /* "Down Arrow"  */
	  return 0x0e; /* ^N */
	case 0x4b:     /* "Left Arrow"  */
	  return 0x02; /* ^B */
	case 0x4d:     /* "Right Arrow" */
	  return 0x06; /* ^F */
	case 0x47:         /* "Home"    */
	  *kbd_buf = 0x3c; /* "<" */
	  return meta_prefix_char;
	case 0x4f:         /* "End"     */
	  *kbd_buf = 0x3e; /* "<" */
	  return meta_prefix_char;
	case 0x49:         /* "PgUp"        */
	  *kbd_buf = 0x76; /* "<" */
	  return meta_prefix_char;
	case 0x51:     /* "PgDn"    */
	  return 0x16; /* ^V */
#endif 0
	}

      if (!ascii_code)
	{
          char *p = kbd_buf;
	    *p++ = 'O';
	  
	  *p++ = (scan_code & 0177);
	  return meta_prefix_char;
	}
    }
#endif /* J3100 or IBMPC */

  if (ascii_code == ' ')
    return (modifiers & M_Control) ? 0 : ' ';

#ifdef IBMPC
  if (EQ (Vdos_machine_type, Qibmpc) && ibmpc_enhanced_keyboard)
    {
      switch (ascii_code)
	{
	case 0x5c: /* "\" */
	case 0x7c: /* "|" */
	case 0x40: /* "@" */
	case 0x23: /* "#" */
	case 0x5b: /* "[" */
	case 0x5d: /* "]" */
	case 0x7b: /* "{" */
	case 0x7d: /* "}" */
	  return ascii_code;
	}
    }
#endif /* IBMPC */

  if (modifiers & M_Alt)
    if (meta_key)
      return (ascii_code | 0200);
    else
      {
	kbd_buf[0] = ascii_code;
	return meta_prefix_char;
      }

  return  ascii_code;
}
