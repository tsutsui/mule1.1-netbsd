/* CCL -- Code Conversion Language Interpreter
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

/* 93.5.14  created for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp> */
/* 93.7.26  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
	enum ccl_code is changed from xxx to CCLxxx. */
/* 93.11.22 modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
	Bug in interpreting CCLexch fixed. */

#include <stdio.h>
#include <string.h>

#ifdef emacs
#include "config.h"
#include "lisp.h"
#endif /* emacs */

#include "codeconv.h"

#define STACKHEAD 4
#define STACKTAIL 4
#define STACKSIZE (CONV_BUF_EXTRA - STACKTAIL)
int ccl_stack[STACKSIZE + STACKTAIL];
static int stack_idx;
#define REGCOUNT 10
int ccl_reg[REGCOUNT];

static clock_t elapsed_time;

enum ccl_code {
  CCLrestart,
  CCLjump, CCLsjump, CCLtjump, CCLfjump, CCLsfjump,
  CCLclear, CCLpop, CCLdup, CCLexch,
  CCLread,
  CCLwstr,
  CCLend,
  CCLinc, CCLdec, CCLtwice, CCLhalf,
  CCLadd, CCLsub, CCLmul, CCLdiv, CCLmod, CCLand, CCLor,
  CCLlshift, CCLrshift,
  CCLnot, CCLlt, CCLgt, CCLeq, CCLle, CCLge, CCLne,
  CCLr0, CCLr1, CCLr2, CCLr3, CCLr4, CCLr5, CCLr6, CCLr7, CCLr8, CCLr9, 
  CCLs0, CCLs1, CCLs2, CCLs3, CCLs4, CCLs5, CCLs6, CCLs7, CCLs8, CCLs9,
  CCLbyte1, CCLbyte2,
  CCLmax_ccl_code
  };

enum ccl_error_code {
  success,
  invalid_program_type,
  invalid_register_type,
  invalid_command_type,
  invalid_command,
  stack_overflow,
  stack_underflow,
  buffer_limit
  };

static enum ccl_error_code ccl_error;

#define CCL_ERROR(err,val) (ccl_error = err, ccl_reg[0] = val)

#if 0  /* We choose dangerous but effective way. :-) */
#define PUSH(val) ( \
  sp < sptail ? *sp++ = val : CCL_ERROR (stack_overflow, 0))
#define POP (sp > sphead ? *--sp : CCL_ERROR (stack_underflow, 0))
#define POPPUSH(op) \
     (sp > sphead ? sp[-1] = op sp[-1] : CCL_ERROR (stack_underflow, 0))
#define POPPOPPUSH1(op) \
     (sp > sphead + 1 ? sp--, sp[-1] op= *sp : CCL_ERROR (stack_underflow, 0))
#define POPPOPPUSH2(op) \
     (sp > sphead + 1 ? sp--, sp[-1] = sp[-1] op *sp : CCL_ERROR (stack_underflow, 0))
#else
#define PUSH(val) (*sp++ = val)
#define POP (*--sp)
#define POPPUSH(op) (sp[-1] = op sp[-1])
#define POPPOPPUSH1(op) (sp--, sp[-1] op *sp)
#define POPPOPPUSH2(op) (sp--, sp[-1] = sp[-1] op *sp)
#endif

#ifdef SWITCH_ENUM_BUG
#define SWITCH_VAL(val) (int)(val)
#else
#define SWITCH_VAL(val) val
#endif

int
ccl_interpreter(src, dst, nsrc, ndst, cmds, ip, endflag)
     unsigned char *src, *dst;
     int nsrc, ndst, *ip;
     unsigned char *cmds;
     register int endflag;
{
  register int i;
  int *sphead = ccl_stack + STACKHEAD, *sptail = ccl_stack + STACKSIZE;
  register int *p, *sp = ccl_stack + stack_idx;
  register unsigned char c, *cmd = cmds + *ip, *s = src, *d = dst;
  register unsigned char *send = src + nsrc;
  int j;
  unsigned char *dend = dst + ndst - CONV_BUF_EXTRA;

  if (s >= send)
    return 0;
  while (1) {
    if ((enum ccl_code)(c = *cmd++) == CCLrestart) {
      if (sp > (p = sphead)) {
	while (p < sp) *d++ = *p++;
	if (d > dend) {
	  ccl_error = buffer_limit;
	  d -= (sp - sphead);
	  goto ccl_interpreter_end;
	}
	sp = sphead;
      }
      if (s < send) {
	PUSH (*s++);
	cmd = cmds + 25;
	c = *cmd++;
      } else if (!endflag) {
	cmd = cmds + 24;
	break;
      } else {
	cmd = cmds + ((unsigned int)cmds[2] << 8) + cmds[3];
	c = *cmd++;
      }
    }

    switch (SWITCH_VAL((enum ccl_code)c)) {
    case CCLrestart:
      cmd--;
      continue;
    case CCLjump:
      cmd += ((unsigned int)*cmd << 8) + cmd[1];
      continue;
    case CCLsjump:
      cmd += *cmd;
      continue;
    case CCLtjump:
      i = POP; j = *cmd++;
      if (i < 0 || i >= j + 1) i = j;
      i *= 2;
      cmd += (cmd[i] << 8) + cmd[i + 1];
      break;
    case CCLfjump:
      if (POP)
	cmd += 2;
      else
	cmd += ((unsigned int)*cmd << 8) + cmd[1];
      break;
    case CCLsfjump:
      if (POP)
	cmd += 2;
      else
	cmd += *cmd;
      break;
    case CCLclear:		/* cleat stack */
      sp = sphead;
      break;
    case CCLpop:		/* pop one value from stack */
      sp--;
      break;
    case CCLdup:		/* duplicate top value of stack */
      *sp = *(sp - 1);
      sp++;
      break;
    case CCLexch:		/* exchange top two values */
      /* 93.11.22 by K.Handa */
      i = *(--sp); *sp = *(sp - 1); *(sp - 1) = i, sp++;
      continue;
    case CCLread:
      if (s < send)
	PUSH (*s++);
      else if (!endflag) {
	cmd--;
	goto ccl_interpreter_end;
      } else 
	cmd = cmds + ((unsigned int)cmds[2] << 8) + cmds[3];
      break;
    case CCLwstr:
      i = *cmd++ + 1;
      if (d + i >= dend) {
	ccl_error = buffer_limit;
	goto ccl_interpreter_end;
      }
      bcopy(cmd, d, i);
      d += i;
      cmd += i;
      continue;
    case CCLend:
      if (sp > (p = sphead)) {
	while (p < sp) *d++ = *p++;
	if (d > dend) {
	  ccl_error = buffer_limit;
	  d -= (sp - sphead);
	  goto ccl_interpreter_end;
	}
	sp = sphead;
      }
      goto ccl_interpreter_end;
    case CCLinc:
      (*(sp - 1))++;
      break;
    case CCLdec:
      (*(sp - 1))--;
      break;
    case CCLtwice:
      *(sp - 1) *= 2;
      break;
    case CCLhalf:
      *(sp - 1) /= 2;
      break;
    case CCLadd:
      POPPOPPUSH1 (+=);
      break;
    case CCLsub:
      POPPOPPUSH1 (-=);
      break;
    case CCLmul:
      POPPOPPUSH1 (*=);
      break;
    case CCLdiv:
      POPPOPPUSH1 (/=);
      break;
    case CCLmod:
      POPPOPPUSH1 (%=);
      break;
    case CCLand:
      POPPOPPUSH1 (&=);
      break;
    case CCLor:
      POPPOPPUSH1 (|=);
      break;
    case CCLlshift:
      i = POP; j = POP;
      PUSH ((unsigned int)j << i);
      break;
    case CCLrshift:
      i = POP; j = POP;
      PUSH ((unsigned int)j >> i);
      break;
    case CCLnot:
      POPPUSH (!);
      break;
    case CCLlt:
      POPPOPPUSH2 (<);
      break;
    case CCLgt:
      POPPOPPUSH2 (>);
      break;
    case CCLeq:
      POPPOPPUSH2 (==);
      break;
    case CCLle:
      POPPOPPUSH2 (<=);
      break;
    case CCLge:
      POPPOPPUSH2 (>=);
      break;
    case CCLne:
      POPPOPPUSH2 (!=);
      break;
    case CCLr0:
      PUSH (ccl_reg[0]);
      break;
    case CCLr1:
      PUSH (ccl_reg[1]);
      break;
    case CCLr2:
      PUSH (ccl_reg[2]);
      break;
    case CCLr3:
      PUSH (ccl_reg[3]);
      break;
    case CCLr4:
      PUSH (ccl_reg[4]);
      break;
    case CCLr5:
      PUSH (ccl_reg[5]);
      break;
    case CCLr6:
      PUSH (ccl_reg[6]);
      break;
    case CCLr7:
      PUSH (ccl_reg[7]);
      break;
    case CCLr8:
      PUSH (ccl_reg[8]);
      break;
    case CCLr9:
      PUSH (ccl_reg[9]);
      break;
    case CCLs0:
      ccl_reg[0] = POP;
      break;
    case CCLs1:
      ccl_reg[1] = POP;
      break;
    case CCLs2:
      ccl_reg[2] = POP;
      break;
    case CCLs3:
      ccl_reg[3] = POP;
      break;
    case CCLs4:
      ccl_reg[4] = POP;
      break;
    case CCLs5:
      ccl_reg[5] = POP;
      break;
    case CCLs6:
      ccl_reg[6] = POP;
      break;
    case CCLs7:
      ccl_reg[7] = POP;
      break;
    case CCLs8:
      ccl_reg[8] = POP;
      break;
    case CCLs9:
      ccl_reg[9] = POP;
      break;
    case CCLbyte1:
      PUSH (*cmd++);
      break;
    case CCLbyte2:
      i = *cmd++ * 256;
      i += *cmd++;
      PUSH (i);
      break;
    default:
      PUSH (c);
    }
    if (ccl_error != success) break;
  }

 ccl_interpreter_end:
  *ip = cmd - cmds;
  stack_idx = sp - ccl_stack;
  return (d - dst);
}

unsigned char *ccl_buf;

int
ccl_driver(src, dst, nsrc, ndst, mccode, encode)
     unsigned char *src, *dst;
     int nsrc, ndst, encode;
     coding_type *mccode;
{
  Lisp_Object ccl_prog;
  Lisp_Object regs, body;
  clock_t etime;
  int i, ip;
  unsigned char *prog;
     
  if (encode) ccl_prog = CODE_CCL_ENCODE (mccode);
  else ccl_prog = CODE_CCL_DECODE (mccode);

  ccl_error = success;

  prog = XSTRING (ccl_prog)->data;
  if (!(ip = (CODE_CNTL (mccode)) >> 16)) {
    for (i = 0; i < REGCOUNT; i++)
      ccl_reg[i] = (unsigned int)prog[i * 2 + 4] * 256 + prog[i * 2 + 5];
    stack_idx = STACKHEAD;
    ip = 24;
  }

  etime = clock();
  ndst = ccl_interpreter(src, dst, nsrc, ndst, prog, &ip,
			 CODE_CNTL (mccode) & CC_END);
  etime = clock() - etime;
  if (etime < 0) etime += 2147000000l;
  elapsed_time += etime / 1000;

  CODE_CNTL (mccode) = (unsigned int)ip << 16;
  if (ccl_error == success)
    return ndst;

 ccl_error_handler:
  dst += ndst;
  switch (SWITCH_VAL(ccl_error)) {
  case invalid_program_type:
    sprintf(dst, "CCL: Invalid program type (%d).\n", (int)(XTYPE (ccl_prog)));
    break;
  case invalid_register_type:
    sprintf(dst, "CCL: Invalid register type (%d).\n", (int)(XTYPE (regs)));
    break;
  case invalid_command:
    sprintf(dst, "CCL: Invalid command (%d).\n", ccl_reg[0]);
    break;
  case stack_overflow:
    sprintf(dst, "CCL: Stack overflow.\n");
    break;
  case stack_underflow:
    sprintf(dst, "CCL: Stack underflow.\n");
    break;
  case buffer_limit:
    sprintf(dst, "CCL: Conversion buffer too short.\n");
    break;
  default:
    sprintf(dst, "CCL: Unknown error type (%d).\n", ((int)ccl_error));
  }
  return (ndst + strlen(dst));
}

#ifdef emacs

DEFUN ("ccl-stack-size", Fccl_stack_size, Sccl_stack_size, 0, 0, 0,
  "Return stack size used in CCL interpreter.")
  ()
{
  Lisp_Object val = XFASTINT (STACKSIZE - STACKHEAD);
  return val;
}

DEFUN ("ccl-register-count", Fccl_reg_count, Sccl_reg_count, 0, 0, 0,
  "Return count of registers used in CCL interpreter.")
  ()
{
  Lisp_Object val = XFASTINT (REGCOUNT);
  return val;
}

DEFUN ("ccl-register", Fccl_register, Sccl_register, 0, 0, 0,
  "Return the current contents of ccl register as a vector.")
  ()
{
  Lisp_Object val1 = XFASTINT (REGCOUNT), val2 = XFASTINT (0);
  int i;

  val1 = Fmake_vector (val1, val2);
  for (i = 0; i < REGCOUNT; i++)
    XVECTOR (val1)->contents[i] = make_number (ccl_reg[i]);

  return val1;
}

DEFUN ("ccl-stack", Fccl_stack, Sccl_stack, 0, 0, 0,
  "Return the current contents of ccl stack as a vector.")
  ()
{
  Lisp_Object val1 = make_number (stack_idx - STACKHEAD), val2 = XFASTINT (0);
  int i;

  val1 = Fmake_vector (val1, val2);
  for (i = STACKHEAD; i < stack_idx; i++)
    XVECTOR (val1)->contents[i] = make_number (ccl_stack[i]);

  return val1;
}

DEFUN ("ccl-reset-elapsed-time", Fccl_reset_etime, Sccl_reset_etime, 0, 0, 0,
  "Reset the internal value which holds a time elapsed by ccl interpreter.")
  ()
{
  int i;

  elapsed_time = 0;
  return Qnil;
}

DEFUN ("ccl-elapsed-time", Fccl_etime, Sccl_etime, 0, 0, 0,
  "Return a time elapsed by ccl interpreter as cons of sec and msec.")
  ()
{
  return Fcons (make_number ((int)(elapsed_time / 1000)),
		make_number ((int)(elapsed_time % 1000)));
}

void
syms_of_ccl ()
{
  defsubr (&Sccl_stack_size);
  defsubr (&Sccl_reg_count);
  defsubr (&Sccl_register);
  defsubr (&Sccl_stack);
  defsubr (&Sccl_reset_etime);
  defsubr (&Sccl_etime);
}

#endif /* emacs */
