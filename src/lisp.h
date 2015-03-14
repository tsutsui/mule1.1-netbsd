/* Fundamental definitions for GNU Emacs Lisp interpreter.
   Copyright (C) 1985, 1986, 1987 Free Software Foundation, Inc.

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

/* 91.10.21 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */
/* 92.6.24  modified for Mule Ver.0.9.5 by Y.Akiba <akiba@cbs.canon.co.jp>
	Patch for NeXT is applied */
/* 92.9.2  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
	CHECK_CHARACTER supports private character-set. */
/* 92.10.21 modified for Mule Ver.0.9.6
		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>,
		   S.Hirano <hirano@etl.go.jp>
	DOS-Extender GO32 and EMX supported. */
/* 93.1.15  modified for Mule Ver.0.9.7.1 by Y.Akiba <akiba@cbs.canon.co.jp>
	Patch for NeXT is updated. */

/* Define the fundamental Lisp data structures */

/* Define an integer type with the same size as Lisp_Object.
   It's usually `int', but some platforms needs `long'.
   In such case, LONG_LISP_OBJECT should be defined within m-*.h. */

#ifndef Lisp_Object_Int
#ifdef LONG_LISP_OBJECT
#define Lisp_Object_Int long
#else
#define Lisp_Object_Int int
#endif
#endif

/* This is the set of Lisp data types */

enum Lisp_Type
  {
    /* Integer.  object.v.integer is the integer value. */
    Lisp_Int,

    /* Symbol.  object.v.symbol points to a struct Lisp_Symbol. */
    Lisp_Symbol,

    /* Marker (editor pointer).  object.v.marker points to a struct Lisp_Marker. */
    Lisp_Marker,

    /* String.  object.v.string points to a struct Lisp_String.
       The length of the string, and its contents, are stored therein. */
    Lisp_String,

    /* Vector of Lisp objects.  object.v.vector points to a struct Lisp_Vector.
       The length of the vector, and its contents, are stored therein. */
    Lisp_Vector,

    /* Cons.  object.v.cons points to a struct Lisp_Cons. */
    Lisp_Cons,

    /* >>> No longer used */
    Lisp_Object_Unused_1,
#if 0
    was...
    /* Treated like vector in GC, except do not set its mark bit.
       Used for internal data blocks that will be explicitly freed
       but which, while active, are reached by GC mark exactly once
       and should be marked through like a vector.  */
    Lisp_Temp_Vector,
#endif /* 0 */

    /* Editor buffer.  obj.v.buffer points to a struct buffer.
       No buffer is ever truly freed; they can be "killed", but this
       just marks them as dead. */
    Lisp_Buffer,

    /* Built-in function.  obj.v.subr points to a struct Lisp_Subr
       which describes how to call the function, and its documentation,
       as well as pointing to the code. */
    Lisp_Subr,

    /* Internal value return by subroutines of read.
       The user never sees this data type.
       Its value is just a number. */
    Lisp_Internal,

    /* Forwarding pointer to an int variable.
       This is allowed only in the value cell of a symbol,
       and it means that the symbol's value really lives in the
       specified int variable.
       obj.v.intptr points to the int variable. */
    Lisp_Intfwd,

    /* Boolean forwarding pointer to an int variable.
       This is like Lisp_Intfwd except that the ostensible "value" of the symbol
       is t if the int variable is nonzero, nil if it is zero.
       obj.v.intptr points to the int variable. */
    Lisp_Boolfwd,

    /* Object describing a connection to a subprocess.
       It points to storage of type  struct Lisp_Process  */
    Lisp_Process,

    /* Forwarding pointer to a Lisp_Object variable.
       This is allowed only in the value cell of a symbol,
       and it means that the symbol's value really lives in the
       specified variable.
       obj.v.objfwd points to the Lisp_Object variable. */
    Lisp_Objfwd,

      /* was Lisp_Internal */
    Lisp_Object_Unused_2,

    /* Used when a FILE * value needs to be passed
       in an argument of type Lisp_Object.
       You must do (FILE *) obj.v.integer to get the value.
       The user will never see this data type. */
    Lisp_Internal_Stream,

    /* Used in a symbol value cell when the symbol's value is per-buffer.
        The actual contents are a cons cell which starts a list like this:
        (REALVALUE BUFFER CURRENT-ALIST-ELEMENT . DEFAULT-VALUE)).

	BUFFER is the last buffer for which this symbol's value was
	made up to date.

        CURRENT-ALIST-ELEMENT is a pointer to an element of BUFFER's
	b_local_var_alist, that being the element whose car is this variable.
        Or it can be a pointer to the (CURRENT-ALIST-ELEMENT . DEFAULT-VALUE), if BUFFER
	does not have an element in its alist for this variable
	(that is, if BUFFER sees the default value of this variable).

	If we want to examine or set the value and BUFFER is current,
	we just examine or set REALVALUE.
	If BUFFER is not current, we store the current REALVALUE value into
	CURRENT-ALIST-ELEMENT, then find the appropriate alist element for
	the buffer now current and set up CURRENT-ALIST-ELEMENT.
	Then we set REALVALUE out of that element, and store into BUFFER.

	If we are setting the variable and the current buffer does not have
	an alist entry for this variable, an alist entry is created.

	Note that REALVALUE can be a forwarding pointer.
	Each time it is examined or set, forwarding must be done.  */
    Lisp_Buffer_Local_Value,

    /* Like Lisp_Buffer_Local_Value with one difference:
	merely setting the variable while some buffer is current
	does not cause that buffer to have its own local value of this variable.
	Only make-local-variable does that.  */
    Lisp_Some_Buffer_Local_Value,


    /* Like Lisp_Objfwd except that value lives in a slot
       in the current buffer.  Value is byte index of slot within buffer */
    Lisp_Buffer_Objfwd,

    /* In symbol value cell, means var is unbound.
       In symbol function cell, means function name is undefined. */
    Lisp_Void,

    /* Window used for Emacs display.
       Data inside looks like a Lisp_Vector.  */
    Lisp_Window,

    /* Used by save,set,restore-window-configuration */
    Lisp_Window_Configuration
  };

#ifndef NO_UNION_TYPE

#ifndef BIG_ENDIAN

/* Definition of Lisp_Object for little-endian machines.  */

typedef
union Lisp_Object
  {
    /* Used for comparing two Lisp_Objects;
       also, positive integers can be accessed fast this way. */
    int i;

    struct
      {
	int val: 24;
	char type;
      } s;
    struct
      {
	unsigned int val: 24;
	char type;
      } u;
    struct
      {
	unsigned int val: 24;
	enum Lisp_Type type: 7;
	/* The markbit is not really part of the value of a Lisp_Object,
	   and is always zero except during garbage collection.  */
	unsigned int markbit: 1;
      } gu;
  }
Lisp_Object;

#else /* If BIG_ENDIAN */

typedef
union Lisp_Object
  {
    /* Used for comparing two Lisp_Objects;
       also, positive integers can be accessed fast this way. */
    int i;

    struct
      {
	char type;
	int val: 24;
      } s;
    struct
      {
	char type;
	unsigned int val: 24;
      } u;
    struct
      {
	/* The markbit is not really part of the value of a Lisp_Object,
	   and is always zero except during garbage collection.  */
	unsigned int markbit: 1;
	enum Lisp_Type type: 7;
	unsigned int val: 24;
      } gu;
  }
Lisp_Object;

#endif /* BIG_ENDIAN */

#endif /* NO_UNION_TYPE */


/* If union type is not wanted, define Lisp_Object as just a number
   and define the macros below to extract fields by shifting */

#ifdef NO_UNION_TYPE

#define Lisp_Object Lisp_Object_Int

/* These values are overridden by the m- file on some machines.  */

/* LISP_OBJECT_BITS is defined as 32 by puresize.h, which may be
   overridden by the m- file on some machines. */

#ifndef VALBITS
#if LISP_OBJECT_BITS > 32
#define VALBITS 56
#else
#define VALBITS 24
#endif
#endif

#ifndef GCTYPEBITS
#define GCTYPEBITS 7
#endif

#ifdef LONG_LISP_OBJECT
#define LISP_OBJECT_1 1L
#else
#define LISP_OBJECT_1 1
#endif

#ifndef VALMASK
#define VALMASK ((LISP_OBJECT_1 << VALBITS) - 1)
#endif
#ifndef GCTYPEMASK
#define GCTYPEMASK ((LISP_OBJECT_1 << GCTYPEBITS) - 1)
#endif
#ifndef MARKBIT
#define MARKBIT (LISP_OBJECT_1 << (VALBITS + GCTYPEBITS))
#endif

#endif /* NO_UNION_TYPE */

/* These macros extract various sorts of values from a Lisp_Object.
 For example, if tem is a Lisp_Object whose type is Lisp_Cons,
 XCONS (tem) is the struct Lisp_Cons * pointing to the memory for that cons. */

#ifdef NO_UNION_TYPE

/* One need to override this if there must be high bits set in data space
   (doing the result of the below & ((1 << (GCTYPE + 1)) - 1) would work
    on all machines, but would penalise machines which don't need it)
 */
#ifndef XTYPE
#define XTYPE(a) ((enum Lisp_Type) ((a) >> VALBITS))
#endif

#ifndef XSETTYPE
#define XSETTYPE(a, b) ((a)  =  XUINT (a) | ((Lisp_Object_Int)(b) << VALBITS))
#endif

/* Use XFASTINT for fast retrieval and storage of integers known
  to be positive.  This takes advantage of the fact that Lisp_Int is 0.  */
#define XFASTINT(a) (a)

/* Extract the value of a Lisp_Object as a signed integer.  */

#ifndef XINT   /* Some machines need to do this differently.  */
#ifdef LONG_LISP_OBJECT
#define XINT(a)	(((Lisp_Object_Int)(a) << (LONGBITS-VALBITS)) >> (LONGBITS-VALBITS))
#else
#define XINT(a) (((a) << (INTBITS-VALBITS)) >> (INTBITS-VALBITS))
#endif
#endif

/* Extract the value as an unsigned integer.  This is a basis
   for exctacting it as a pointer to a structure in storage.  */

#ifndef XUINT
#define XUINT(a) ((Lisp_Object_Int)(a) & VALMASK)
#endif

#ifdef HAVE_SHM
/* In this representation, data is found in two widely separated segments.  */
#define XPNTR(a) \
  (XUINT (a) | (XUINT (a) > PURESIZE ? DATA_SEG_BITS : PURE_SEG_BITS))
#else /* not HAVE_SHM */
#ifdef DATA_SEG_BITS
/* This case is used for the rt-pc.
   In the diffs I was given, it checked for ptr = 0
   and did not adjust it in that case.
   But I don't think that zero should ever be found
   in a Lisp object whose data type says it points to something.  */
#define XPNTR(a) (XUINT (a) | DATA_SEG_BITS)
#else /* not DATA_SEG_BITS */
#define XPNTR(a) XUINT (a)
#endif
#endif /* not HAVE_SHM */

#ifndef XSETINT
#define XSETINT(a, b)  ((a) = (Lisp_Object_Int)((a) & ~VALMASK) |  (Lisp_Object_Int)((b) & VALMASK))
#endif

#ifndef XSETUINT
#define XSETUINT(a, b) XSETINT (a, b)
#endif

#ifndef XSETPNTR
#define XSETPNTR(a, b) XSETINT (a, b)
#endif

#ifndef XSET
#define XSET(var, type, ptr) \
   ((var) = ((Lisp_Object_Int)(type) << VALBITS) + ((Lisp_Object_Int) (ptr) & VALMASK))
#endif

/* During garbage collection, XGCTYPE must be used for extracting types
 so that the mark bit is ignored.  XMARKBIT access the markbit.
 Markbits are used only in particular slots of particular structure types.
 Other markbits are always zero.
 Outside of garbage collection, all mark bits are always zero.  */

#ifndef XGCTYPE
#define XGCTYPE(a) ((enum Lisp_Type) (((a) >> VALBITS) & GCTYPEMASK))
#endif

/* In version 19, try 
#if VALBITS + GCTYPEBITS == INTBITS - 1
#define XMARKBIT(a) ((a) < 0)
#define XSETMARKBIT(a,b) ((a) = ((a) & ~MARKBIT) | ((b) ? MARKBIT : 0))
#endif
*/

#ifndef XMARKBIT
#define XMARKBIT(a) ((a) & MARKBIT)
#endif

#ifndef XSETMARKBIT
#define XSETMARKBIT(a,b) ((a) = ((a) & ~MARKBIT) | (b))
#endif

#ifndef XMARK
#define XMARK(a) ((a) |= MARKBIT)
#endif

#ifndef XUNMARK
#define XUNMARK(a) ((a) &= ~MARKBIT)
#endif

#endif /* NO_UNION_TYPE */

#ifndef NO_UNION_TYPE

#define XTYPE(a) ((enum Lisp_Type) (a).u.type)
#define XSETTYPE(a, b) ((a).u.type = (char) (b))

/* Use XFASTINT for fast retrieval and storage of integers known
  to be positive.  This takes advantage of the fact that Lisp_Int is 0.  */
#define XFASTINT(a) ((a).i)

#ifdef EXPLICIT_SIGN_EXTEND
/* Make sure we sign-extend; compilers have been known to fail to do so.  */
#define XINT(a) (((a).i << 8) >> 8)
#else
#define XINT(a) ((a).s.val)
#endif /* EXPLICIT_SIGN_EXTEND */

#define XUINT(a) ((a).u.val)
#define XPNTR(a) ((a).u.val)
#define XSETINT(a, b) ((a).s.val = (int) (b))
#define XSETUINT(a, b) ((a).s.val = (int) (b))
#define XSETPNTR(a, b) ((a).s.val = (int) (b))

#define XSET(var, vartype, ptr) \
   (((var).s.type = ((char) (vartype))), ((var).s.val = ((int) (ptr))))

/* During garbage collection, XGCTYPE must be used for extracting types
 so that the mark bit is ignored.  XMARKBIT access the markbit.
 Markbits are used only in particular slots of particular structure types.
 Other markbits are always zero.
 Outside of garbage collection, all mark bits are always zero.  */

#define XGCTYPE(a) ((a).gu.type)
#define XMARKBIT(a) ((a).gu.markbit)
#define XSETMARKBIT(a,b) (XMARKBIT(a) = (b))
#define XMARK(a) (XMARKBIT(a) = 1)
#define XUNMARK(a) (XMARKBIT(a) = 0)

#endif /* NO_UNION_TYPE */


#define XCONS(a) ((struct Lisp_Cons *) XPNTR(a))
#define XBUFFER(a) ((struct buffer *) XPNTR(a))
#define XVECTOR(a) ((struct Lisp_Vector *) XPNTR(a))
#define XSUBR(a) ((struct Lisp_Subr *) XPNTR(a))
#define XSTRING(a) ((struct Lisp_String *) XPNTR(a))
#define XSYMBOL(a) ((struct Lisp_Symbol *) XPNTR(a))
#define XFUNCTION(a) ((Lisp_Object (*)()) XPNTR(a))
#define XMARKER(a) ((struct Lisp_Marker *) XPNTR(a))
#define XOBJFWD(a) ((Lisp_Object *) XPNTR(a))
#define XINTPTR(a) ((int *) XPNTR(a))
#define XWINDOW(a) ((struct window *) XPNTR(a))
#define XPROCESS(a) ((struct Lisp_Process *) XPNTR(a))

#define XSETCONS(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETBUFFER(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETVECTOR(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETSUBR(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETSTRING(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETSYMBOL(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETFUNCTION(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETMARKER(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETOBJFWD(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETINTPTR(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETWINDOW(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))
#define XSETPROCESS(a, b) XSETPNTR(a, (Lisp_Object_Int) (b))

/* In a cons, the markbit of the car is the gc mark bit */

struct Lisp_Cons
  {
    Lisp_Object car, cdr;
  };

/* Like a cons, but records info on where the text lives that it was read from */
/* This is not really in use now */

struct Lisp_Buffer_Cons
  {
    Lisp_Object car, cdr;
    struct buffer *buffer;
    int bufpos;
  };

/* In a string or vector, the sign bit of the `size' is the gc mark bit */

struct Lisp_String
  {
    Lisp_Object_Int size;
    unsigned char data[1];
  };

struct Lisp_Vector
  {
    Lisp_Object_Int size;
    struct Lisp_Vector *next;
    Lisp_Object contents[1];
  };

/* In a symbol, the markbit of the plist is used as the gc mark bit */

struct Lisp_Symbol
  {
    struct Lisp_String *name;
    Lisp_Object value;
    Lisp_Object function;
    Lisp_Object plist;
    struct Lisp_Symbol *next;	/* -> next symbol in this obarray bucket */
  };

struct Lisp_Subr
  {
    Lisp_Object (*function) ();
    short min_args, max_args;
    char *symbol_name;
    char *prompt;
    char *doc;
  };

/* In a marker, the markbit of the chain field is used as the gc mark bit */

/* 89.11.30 patch by K.Handa */
#define MARKER_OLD_TYPE 1
#define MARKER_POINT_TYPE 2
#define MARKER_ALL_TYPE  (MARKER_OLD_TYPE | MARKER_POINT_TYPE)
/*end of patch */

struct Lisp_Marker
  {
    struct buffer *buffer;
    Lisp_Object chain;
    int bufpos;
    int type;			/* 89.11.30 by K.Handa */
  };

/* Data type checking */

#ifdef NULL
#undef NULL
#endif
#define NULL(x)  (XFASTINT (x) == XFASTINT (Qnil))
/* #define LISTP(x) (XTYPE ((x)) == Lisp_Cons)*/
#define CONSP(x) (XTYPE ((x)) == Lisp_Cons)
#define EQ(x, y) (XFASTINT (x) == XFASTINT (y))

#define CHECK_LIST(x, i) \
  { if ((XTYPE ((x)) != Lisp_Cons) && !NULL (x)) x = wrong_type_argument (Qlistp, (x)); }

#define CHECK_STRING(x, i) \
  { if (XTYPE ((x)) != Lisp_String) x = wrong_type_argument (Qstringp, (x)); }

#define CHECK_CONS(x, i) \
  { if (XTYPE ((x)) != Lisp_Cons) x = wrong_type_argument (Qconsp, (x)); }

#define CHECK_SYMBOL(x, i) \
  { if (XTYPE ((x)) != Lisp_Symbol) x = wrong_type_argument (Qsymbolp, (x)); }

#define CHECK_VECTOR(x, i) \
  { if (XTYPE ((x)) != Lisp_Vector) x = wrong_type_argument (Qvectorp, (x)); }

#define CHECK_BUFFER(x, i) \
  { if (XTYPE ((x)) != Lisp_Buffer) x = wrong_type_argument (Qbufferp, (x)); }

#define CHECK_WINDOW(x, i) \
  { if (XTYPE ((x)) != Lisp_Window) x = wrong_type_argument (Qwindowp, (x)); }

#define CHECK_PROCESS(x, i) \
  { if (XTYPE ((x)) != Lisp_Process) x = wrong_type_argument (Qprocessp, (x)); }

#define CHECK_NUMBER(x, i) \
  { if (XTYPE ((x)) != Lisp_Int) x = wrong_type_argument (Qintegerp, (x)); }

/* 91.11.17, 92.9.3 by K.Handa */
/* This is not a complete check, but to save time... */
#define CHECK_CHARACTER(x, i) \
  { if (XTYPE ((x)) != Lisp_Int \
	|| (XFASTINT ((x)) & 0x800000)) \
      x = wrong_type_argument (Qcharacterp, (x)); }
/* end of patch */

#define CHECK_MARKER(x, i) \
  { if (XTYPE ((x)) != Lisp_Marker) x = wrong_type_argument (Qmarkerp, (x)); }

#define CHECK_NUMBER_COERCE_MARKER(x, i) \
  { if (XTYPE ((x)) == Lisp_Marker) XFASTINT (x) = marker_position (x); \
    else if (XTYPE ((x)) != Lisp_Int) x = wrong_type_argument (Qinteger_or_marker_p, (x)); }

#ifdef VIRT_ADDR_VARIES

/* For machines like APOLLO where text and data can go anywhere
   in virtual memory.  */
#define CHECK_IMPURE(obj) \
  { extern int pure[]; \
    if ((PNTR_COMPARISON_TYPE) XPNTR (obj) < (PNTR_COMPARISON_TYPE) ((char *) pure + PURESIZE) \
	&& (PNTR_COMPARISON_TYPE) XPNTR (obj) >= (PNTR_COMPARISON_TYPE) pure) \
      pure_write_error (); }

#else /* not VIRT_ADDR_VARIES */
#ifdef PNTR_COMPARISON_TYPE

/* when PNTR_COMPARISON_TYPE is not the default (unsigned int) */
#define CHECK_IMPURE(obj) \
  { extern int my_edata; \
    if ((PNTR_COMPARISON_TYPE) XPNTR (obj) < (PNTR_COMPARISON_TYPE) &my_edata) \
      pure_write_error (); }

#else /* not VIRT_ADDRESS_VARIES, not PNTR_COMPARISON_TYPE */

#define CHECK_IMPURE(obj) \
  { extern int my_edata; \
    if (XPNTR (obj) < (unsigned int) &my_edata) \
      pure_write_error (); }

#endif /* PNTR_COMPARISON_TYPE */
#endif /* VIRT_ADDRESS_VARIES */

/* Cast pointers to this type to compare them.  Some machines want int.  */
#ifndef PNTR_COMPARISON_TYPE
#define PNTR_COMPARISON_TYPE unsigned int
#endif

/* Define a built-in function for calling from Lisp.
 `lname' should be the name to give the function in Lisp,
    as a null-terminated C string.
 `fnname' should be the name of the function in C.
    By convention, it starts with F.
 `sname' should be the name for the C constant structure
    that records information on this function for internal use.
    By convention, it should be the same as `fnname' but with S instead of F.
    It's too bad that C macros can't compute this from `fnname'.
 `minargs' should be a number, the minimum number of arguments allowed.
 `maxargs' should be a number, the maximum number of arguments allowed,
    or else MANY or UNEVALLED.
    MANY means pass a vector of evaluated arguments,
	 in the form of an integer number-of-arguments
	 followed by the address of a vector of Lisp_Objects
	 which contains the argument values.
    UNEVALLED means pass the list of unevaluated arguments
 `prompt' says how to read arguments for an interactive call.
    This can be zero or a C string.
    Zero means that interactive calls are not allowed.
    A string is interpreted in a hairy way:
     it should contain one line for each argument to be read, terminated by \n.
     The first character of the line controls the type of parsing:
       s  --  read a string.
       S  --  read a symbol.
       k  --  read a key sequence and return it as a string.
       a  --  read a function name (symbol) with completion.
       C  --  read a command name (symbol) with completion.
       v  --  read a variable name (symbol) with completion.
       b  --  read a buffer name (a string) with completion.
       B  --  buffer name, may be existing buffer or may not be.
       f  --  read a file name, file must exist.
       F  --  read a file name, file need not exist.
       n  --  read a number.
       c  --  read a character and return it as a number.
       p  --  use the numeric value of the prefix argument.
       P  --  use raw value of prefix - can be nil, -, (NUMBER) or NUMBER.
       x  --  read a Lisp object from the minibuffer.
       X  --  read a Lisp form from the minibuffer and use its value.
    A null string means call interactively with no arguments.
 `doc' is documentation for the user.
*/

#define DEFUN(lname, fnname, sname, minargs, maxargs, prompt, doc) \
  Lisp_Object fnname (); \
  struct Lisp_Subr sname = {fnname, minargs, maxargs, lname, prompt, 0}; \
  Lisp_Object fnname

/* defsubr (Sname);
 is how we define the symbol for function `name' at start-up time. */
extern void defsubr ();

#define MANY -2
#define UNEVALLED -1

/* Macros we use to define forwarded Lisp variables.
   These are used in the syms_of_FILENAME functions.  */

#define DEFVARLISP(lname, vname, doc) defvar_lisp (lname, vname)
#define DEFVARBOOL(lname, vname, doc) defvar_bool (lname, vname)
#define DEFVARINT(lname, vname, doc) defvar_int (lname, vname)
#define DEFVARPERBUFFER(lname, vname, doc)  \
 defvar_per_buffer (lname, vname, 0)

#define DEFVAR_LISP(lname, vname, doc) defvar_lisp (lname, vname)
#define DEFVAR_LISP_NOPRO(lname, vname, doc) defvar_lisp_nopro (lname, vname)
#define DEFVAR_BOOL(lname, vname, doc) defvar_bool (lname, vname)
#define DEFVAR_INT(lname, vname, doc) defvar_int (lname, vname)
#define DEFVAR_PER_BUFFER(lname, vname, doc)  \
 defvar_per_buffer (lname, vname, 0)

/* Structure for recording Lisp call stack for backtrace purposes */

struct specbinding
  {
    Lisp_Object symbol, old_value;
    Lisp_Object (*func) ();
    Lisp_Object unused;		/* Dividing by 16 is faster than by 12 */
  };

extern struct specbinding *specpdl;
extern struct specbinding *specpdl_ptr;
extern int specpdl_size;

struct handler
  {
    Lisp_Object handler;
    Lisp_Object var;
    int poll_suppress_count;	/* No error should exit a piece of code
				   in which polling is suppressed.  */
    struct catchtag *tag;
    struct handler *next;
  };

extern struct handler *handlerlist;

/* Check quit-flag and quit if it is non-nil. */

#define QUIT \
  if (!NULL (Vquit_flag) && NULL (Vinhibit_quit)) \
    { Vquit_flag = Qnil; Fsignal (Qquit, Qnil); }

/* Nonzero if ought to quit now.  */

#define QUITP (!NULL (Vquit_flag) && NULL (Vinhibit_quit))

/* 1 if CH is upper case.  */

#define UPPERCASEP(CH) (downcase_table[CH] != (CH))

/* 1 if CH is lower case.  */

#define LOWERCASEP(CH)   \
 (downcase_table[CH] == (CH) && downcase_table[0400 + (CH)] != (CH))

/* 1 if CH is neither upper nor lower case.  */

#define NOCASEP(CH) (downcase_table[0400 + (CH)] == (CH))

/* Upcase a character, or make no change if that cannot be done.  */

#define UPCASE(CH) (downcase_table[CH] == (CH) ? UPCASE1 (CH) : (CH))

/* Upcase a character known to be not upper case.  */

#define UPCASE1(CH) downcase_table[0400 + (CH)]

/* Downcase a character, or make no change if that cannot be done. */

#define DOWNCASE(CH) downcase_table[CH]

/* number of bytes of structure consed since last GC */

extern int consing_since_gc;

/* threshold for doing another gc */

extern int gc_cons_threshold;

/* value of consing_since_gc when undos were last truncated.  */

extern int consing_at_last_truncate;

/* Structure for recording stack slots that need marking */

/* This is a chain of structures, each of which points at a Lisp_Object variable
 whose value should be marked in garbage collection.
 Normally every link of the chain is an automatic variable of a function,
 and its `val' points to some argument or local variable of the function.
 On exit to the function, the chain is set back to the value it had on entry.
 This way, no link remains in the chain when the stack frame containing the link disappears.

 Every function that can call Feval must protect in this fashion all
 Lisp_Object variables whose contents will be used again. */

extern struct gcpro *gcprolist;

struct gcpro
  {
    struct gcpro *next;
    Lisp_Object *var;		/* Address of first protected variable */
    int nvars;			/* Number of consecutive protected variables */
  };

#define GCPRO1(varname) \
 {gcpro1.next = gcprolist; gcpro1.var = &varname; gcpro1.nvars = 1; \
  gcprolist = &gcpro1; }

#define GCPRO2(varname1, varname2) \
 {gcpro1.next = gcprolist; gcpro1.var = &varname1; gcpro1.nvars = 1; \
  gcpro2.next = &gcpro1; gcpro2.var = &varname2; gcpro2.nvars = 1; \
  gcprolist = &gcpro2; }

#define GCPRO3(varname1, varname2, varname3) \
 {gcpro1.next = gcprolist; gcpro1.var = &varname1; gcpro1.nvars = 1; \
  gcpro2.next = &gcpro1; gcpro2.var = &varname2; gcpro2.nvars = 1; \
  gcpro3.next = &gcpro2; gcpro3.var = &varname3; gcpro3.nvars = 1; \
  gcprolist = &gcpro3; }

#define GCPRO4(varname1, varname2, varname3, varname4) \
 {gcpro1.next = gcprolist; gcpro1.var = &varname1; gcpro1.nvars = 1; \
  gcpro2.next = &gcpro1; gcpro2.var = &varname2; gcpro2.nvars = 1; \
  gcpro3.next = &gcpro2; gcpro3.var = &varname3; gcpro3.nvars = 1; \
  gcpro4.next = &gcpro3; gcpro4.var = &varname4; gcpro4.nvars = 1; \
  gcprolist = &gcpro4; }

/* Call staticpro (&var) to protect static variable `var'. */

void staticpro();
  
#define UNGCPRO (gcprolist = gcpro1.next)


/* Defined in category.c */
extern Lisp_Object Fcategory_equal ();
extern Lisp_Object Fcategory_table ();
extern Lisp_Object Fcategory_table_p ();
extern Lisp_Object Fchar_category ();
extern Lisp_Object Fcheck_category ();
extern Lisp_Object Fcheck_category_at ();
extern Lisp_Object Fcopy_category_table ();
extern Lisp_Object Fdefine_category_mnemonic ();
extern Lisp_Object Fdescribe_category ();
extern Lisp_Object Fmodify_category_entry ();
extern Lisp_Object Fset_category_table ();
extern Lisp_Object Fstandard_category_table ();
extern Lisp_Object Funused_category_mnemonic ();
extern Lisp_Object Fused_category_mnemonic ();

/* Defined in ccl.c */
extern Lisp_Object Fccl_etime ();
extern Lisp_Object Fccl_reg_count ();
extern Lisp_Object Fccl_register ();
extern Lisp_Object Fccl_reset_etime ();
extern Lisp_Object Fccl_stack ();
extern Lisp_Object Fccl_stack_size ();

/* Defined in cmds.c */
extern Lisp_Object Fbackward_byte ();
extern Lisp_Object Fbackward_char ();
extern Lisp_Object Fbeginning_of_line ();
extern Lisp_Object Fdelete_backward_char ();
extern Lisp_Object Fdelete_char ();
extern Lisp_Object Fend_of_line ();
extern Lisp_Object Fforward_byte ();
extern Lisp_Object Fforward_char ();
extern Lisp_Object Fforward_line ();
extern Lisp_Object Fnewline ();
extern Lisp_Object Fself_insert_command ();
extern Lisp_Object Fself_insert_internal ();

/* Defined in data.c */
extern Lisp_Object Qnil, Qt, Qquote, Qlambda, Qsubr, Qunbound;
extern Lisp_Object Qerror_conditions, Qerror_message, Qtop_level;
extern Lisp_Object Qerror, Qquit, Qwrong_type_argument, Qargs_out_of_range;
extern Lisp_Object Qvoid_variable, Qvoid_function;
extern Lisp_Object Qsetting_constant, Qinvalid_read_syntax;
extern Lisp_Object Qinvalid_function, Qwrong_number_of_arguments, Qno_catch;
extern Lisp_Object Qend_of_file, Qarith_error;
extern Lisp_Object Qbeginning_of_buffer, Qend_of_buffer, Qbuffer_read_only;

extern Lisp_Object Qintegerp, Qnatnump, Qsymbolp, Qlistp, Qconsp;
extern Lisp_Object Qcharacterp, Qmnemonicp; /* 91.11.17 by K.Handa */
extern Lisp_Object Qstringp, Qarrayp, Qsequencep, Qbufferp;
extern Lisp_Object Qchar_or_string_p, Qmarkerp, Qvectorp;
extern Lisp_Object Qinteger_or_marker_p, Qboundp, Qfboundp;
extern Lisp_Object Qcdr;

extern Lisp_Object Fkill_local_variable (Lisp_Object);
extern Lisp_Object Fmake_local_variable (Lisp_Object);
extern Lisp_Object Fmake_variable_buffer_local (Lisp_Object);
extern Lisp_Object Fsetq_default (Lisp_Object);

extern Lisp_Object Feq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fnull (Lisp_Object);
extern Lisp_Object Flistp (Lisp_Object);
extern Lisp_Object Fconsp (Lisp_Object);
extern Lisp_Object Fatom (Lisp_Object);
extern Lisp_Object Fnlistp (Lisp_Object);
extern Lisp_Object Fintegerp (Lisp_Object);
extern Lisp_Object Fnatnump (Lisp_Object);
extern Lisp_Object Fsymbolp (Lisp_Object);
extern Lisp_Object Fvectorp (Lisp_Object);
extern Lisp_Object Fstringp (Lisp_Obejct);
extern Lisp_Object Farrayp (Lisp_Object);
extern Lisp_Object Fsequencep (Lisp_Object);
extern Lisp_Object Fbufferp (Lisp_Object);
extern Lisp_Object Fmarkerp (Lisp_Object);
extern Lisp_Object Fsubrp (Lisp_Object);
extern Lisp_Object Fchar_or_string_p (Lisp_Object);
extern Lisp_Object Finteger_or_marker_p (Lisp_Object);

extern Lisp_Object Fcar (Lisp_Object);
extern Lisp_Object Fcar_safe(Lisp_Object);
extern Lisp_Object Fcdr (Lisp_Object);
extern Lisp_Object Fcdr_safe(Lisp_Object);
extern Lisp_Object Fsetcar (Lisp_Object, Lisp_Object);
extern Lisp_Object Fsetcdr (Lisp_Object, Lisp_Object);
extern Lisp_Object Fboundp (Lisp_Object);
extern Lisp_Object Ffboundp (Lisp_Object);
extern Lisp_Object Fmakunbound (Lisp_Object);
extern Lisp_Object Ffmakunbound (Lisp_Object);
extern Lisp_Object Fsymbol_function (Lisp_Object);
extern Lisp_Object Fsymbol_plist (Lisp_Object);
extern Lisp_Object Fsymbol_name (Lisp_Object);
extern Lisp_Object Ffset (Lisp_Object, Lisp_Object);
extern Lisp_Object Fsetplist (Lisp_Object, Lisp_Object);
extern Lisp_Object Fsymbol_value (Lisp_Object);
extern Lisp_Object Fset (Lisp_Object, Lisp_Object);
extern Lisp_Object Fdefault_value (Lisp_Object);
extern Lisp_Object Fset_default (Lisp_Object, Lisp_Object);

extern Lisp_Object Faref (Lisp_Object, Lisp_Object);
extern Lisp_Object Faset (Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object Farray_length (Lisp_Object);

extern Lisp_Object Fstring_to_int (Lisp_Object);
extern Lisp_Object Fint_to_string (Lisp_Object);
extern Lisp_Object Feqlsign (Lisp_Object, Lisp_Object);
extern Lisp_Object Fgtr (Lisp_Object, Lisp_Object);
extern Lisp_Object Flss (Lisp_Object, Lisp_Object);
extern Lisp_Object Fgeq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fleq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fneq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fzerop (Lisp_Object);
extern Lisp_Object Fplus (int, Lisp_Object *);
extern Lisp_Object Fminus (int, Lisp_Object *);
extern Lisp_Object Ftimes (int, Lisp_Object *);
extern Lisp_Object Fquo (int, Lisp_Object *);
extern Lisp_Object Frem (Lisp_Object, Lisp_Object);
extern Lisp_Object Fmax (int, Lisp_Object *);
extern Lisp_Object Fmin (int, Lisp_Object *);
extern Lisp_Object Flogand (int, Lisp_Object *);
extern Lisp_Object Flogior (int, Lisp_Object *);
extern Lisp_Object Flogxor (int, Lisp_Object *);
extern Lisp_Object Flognot (Lisp_Object);
extern Lisp_Object Flsh (Lisp_Object, Lisp_Object);
extern Lisp_Object Fash (Lisp_Object, Lisp_Object);
extern Lisp_Object Fadd1 (Lisp_Object);
extern Lisp_Object Fsub1 (Lisp_Object);

extern Lisp_Object make_number (int);
extern void args_out_of_range (Lisp_Object, Lisp_Object);
extern void args_out_of_range_3 (Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object wrong_type_argument (Lisp_Object, Lisp_Object);

/* Defined in dispnew.c */
extern Lisp_Object Fbaud_rate ();
extern Lisp_Object Fding ();
extern Lisp_Object Fopen_termscript ();
extern Lisp_Object Fscreen_height ();
extern Lisp_Object Fscreen_width ();
extern Lisp_Object Fsend_string_to_terminal ();
extern Lisp_Object Fset_screen_height ();
extern Lisp_Object Fset_screen_width ();
extern Lisp_Object Fsit_for ();
extern Lisp_Object Fsleep_for ();

/* Defined in fns.c */
extern Lisp_Object Qstring_lessp;
extern Lisp_Object Vfeatures;
extern Lisp_Object Fconcat (int, Lisp_Object *);
extern Lisp_Object Fcopy_alist (Lisp_Object);
extern Lisp_Object Fcopy_sequence (Lisp_Object);
extern Lisp_Object Felt (Lisp_Object, Lisp_Object);
extern Lisp_Object Fload_average (void);
extern Lisp_Object Fidentity (Lisp_Object);
extern Lisp_Object Frandom (Lisp_Object);
extern Lisp_Object Flength (Lisp_Object);
extern Lisp_Object Fnth (Lisp_Object, Lisp_Object);
extern Lisp_Object Fappend (int, Lisp_Object *);
extern Lisp_Object Fconcat (int, Lisp_Object *);
extern Lisp_Object Fvconcat (int, Lisp_Object *);
extern Lisp_Object Fcopy_sequence (Lisp_Object);
extern Lisp_Object Fsubstring (Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object Fnthcdr (Lisp_Object, Lisp_Object);
extern Lisp_Object Fmemq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fassq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fassoc (Lisp_Object, Lisp_Object);
extern Lisp_Object Frassq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fdelq (Lisp_Object, Lisp_Object);
extern Lisp_Object Fsort (Lisp_Object, Lisp_Object);
extern Lisp_Object Freverse (Lisp_Object);
extern Lisp_Object Fnreverse (Lisp_Object);
extern Lisp_Object Fget (Lisp_Object, Lisp_Object);
extern Lisp_Object Fput (Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object Fequal (Lisp_Object, Lisp_Object);
extern Lisp_Object Ffillarray (Lisp_Object, Lisp_Object);
extern Lisp_Object Fnconc (int, Lisp_Object *);
extern Lisp_Object Fmapcar (Lisp_Object, Lisp_Object);
extern Lisp_Object Fy_or_n_p (Lisp_ObjecLisp_Objectt);
extern Lisp_Object Fyes_or_no_p (Lisp_Object);
extern Lisp_Object Ffeaturep (Lisp_Object);
extern Lisp_Object Frequire (Lisp_Object, Lisp_Object);
extern Lisp_Object Fprovide (Lisp_Object);
extern Lisp_Object concat2 (Lisp_Object, Lisp_Object);
extern Lisp_Object nconc2 (Lisp_Object, Lisp_Object);
extern Lisp_Object assq_no_quit (Lisp_Object, Lisp_Object);

/* Defined in alloc.c */
extern Lisp_Object Vpurify_flag;
extern Lisp_Object Fcons (Lisp_Object, Lisp_Object);
extern Lisp_Object Flist(int, Lisp_Object *);
extern Lisp_Object Fmake_list (Lisp_Object, Lisp_Object);
extern Lisp_Object Fmake_vector ();
extern Lisp_Object Fvector (int, Lisp_Object *);
extern Lisp_Object Fmake_symbol ();
extern Lisp_Object Fmake_marker ();
extern Lisp_Object Fmake_string (), build_string (), make_string();
extern Lisp_Object Fpurecopy (), make_pure_string ();
extern Lisp_Object pure_cons (), make_pure_vector ();
extern Lisp_Object Fgarbage_collect ();

/* Defined in print.c */
extern Lisp_Object Vprin1_to_string_buffer;
extern Lisp_Object Fprin1 (), Fprin1_to_string (), Fprinc ();
extern Lisp_Object Fterpri (), Fprint ();
extern Lisp_Object Fwrite_char ();
extern Lisp_Object Vstandard_output, Qstandard_output;
extern void temp_output_buffer_setup (), temp_output_buffer_show ();

/* Defined in lread.c */
extern Lisp_Object Qvariable_documentation, Qstandard_input;
extern Lisp_Object Vobarray, Vstandard_input;
extern Lisp_Object Floadablep ();
extern Lisp_Object Fmapatoms ();
extern Lisp_Object Fread (), Fread_from_string ();
extern Lisp_Object Fintern (), Fintern_soft (), Fload ();
extern Lisp_Object Fget_file_char (), Fread_char ();
extern Lisp_Object Feval_current_buffer (), Feval_region ();
extern Lisp_Object intern (), oblookup ();

/* Defined in eval.c */
extern Lisp_Object Qautoload, Qexit, Qinteractive, Qcommandp, Qdefun, Qmacro;
extern Lisp_Object Qload;	/* 91.11.1 by K.Handa */
extern Lisp_Object Vinhibit_quit, Vquit_flag, Qinhibit_quit;
extern Lisp_Object Vmocklisp_arguments, Qmocklisp, Qmocklisp_arguments;
extern Lisp_Object Vautoload_queue;
extern Lisp_Object Fcommandp (Lisp_Object);
extern Lisp_Object Fcond (Lisp_Object);
extern Lisp_Object Fcondition_case (Lisp_Object);
extern Lisp_Object Fdefconst (Lisp_Object);
extern Lisp_Object Fdefmacro (Lisp_Object);
extern Lisp_Object Fdefvar (Lisp_Object);
extern Lisp_Object Ffunction (Lisp_Object);
extern Lisp_Object Fmacroexpand (Lisp_Object, Lisp_Object);
extern Lisp_Object Fand (Lisp_Object);
extern Lisp_Object For (Lisp_Object);
extern Lisp_Object Fif (Lisp_Object);
extern Lisp_Object Fprogn (Lisp_Object);
extern Lisp_Object Fprog1 (Lisp_Object);
extern Lisp_Object Fprog2 (Lisp_Object);
extern Lisp_Object Fsetq (Lisp_Object);
extern Lisp_Object Fquote (Lisp_Object);
extern Lisp_Object Fuser_variable_p (Lisp_Object);
extern Lisp_Object Finteractive_p (void);
extern Lisp_Object Fdefun (Lisp_Object);
extern Lisp_Object Flet (Lisp_Object);
extern Lisp_Object FletX (Lisp_Object);
extern Lisp_Object Fwhile (Lisp_Object);
extern Lisp_Object Fcatch (Lisp_Object);
extern Lisp_Object Fthrow (Lisp_Object, Lisp_Object);
extern Lisp_Object Funwind_protect (Lisp_Object);
extern Lisp_Object Fcondition_case (Lisp_Object);
extern Lisp_Object Fsignal (Lisp_Object, Lisp_Object);
extern Lisp_Object Fautoload (Lisp_Object, Lisp_Object, Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object Fcommandp (Lisp_Object);
extern Lisp_Object Feval (Lisp_Object);
extern Lisp_Object Fapply (int, Lisp_Object *);
extern Lisp_Object Ffuncall (int, Lisp_Object *);
extern Lisp_Object Fbacktrace (void);
extern Lisp_Object Fbacktrace_debug (Lisp_Object, Lisp_Object);
extern Lisp_Object apply1 (Lisp_Object, Lisp_Object);
extern Lisp_Object call0 (Lisp_Object);
extern Lisp_Object call1 (Lisp_Object, Lisp_Object);
extern Lisp_Object call2 (Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object call3 (Lisp_Object, Lisp_Object, Lisp_Object, Lisp_Object);
extern Lisp_Object apply_lambda (Lisp_Object, Lisp_Object, int);
extern Lisp_Object internal_catch (Lisp_Object, Lisp_Object (*)(Lisp_Object), Lisp_Object);
extern Lisp_Object internal_condition_case (Lisp_Object (*)(), Lisp_Object, Lisp_Object (*)());
extern Lisp_Object unbind_to (int, Lisp_Object);
extern void error ();
extern Lisp_Object un_autoload (Lisp_Object);

/* Defined in editfns.c */
extern Lisp_Object Vprefix_arg, Qminus, Vcurrent_prefix_arg;
extern Lisp_Object Fchar_equal ();
extern Lisp_Object Fchar_width ();
extern Lisp_Object Fdelete_region ();
extern Lisp_Object Fgoto_char ();
extern Lisp_Object Fcurrent_time_string ();
extern Lisp_Object Finsert_after_markers (int, Lisp_Object *);
extern Lisp_Object Finsert_before_markers (int, Lisp_Object *);
extern Lisp_Object Finsert_buffer_substring ();
extern Lisp_Object Finsert_char ();
extern Lisp_Object Fmessage ();
extern Lisp_Object Fnarrow_to_region ();
extern Lisp_Object Fregion_beginning ();
extern Lisp_Object Fregion_end ();
extern Lisp_Object Fsave_excursion ();
extern Lisp_Object Fsave_restriction ();
extern Lisp_Object Fsref ();
extern Lisp_Object Fsset ();
extern Lisp_Object Fstring_to_char ();
extern Lisp_Object Fsubst_char_in_region ();
extern Lisp_Object Fsystem_name ();
extern Lisp_Object Fuser_full_name ();
extern Lisp_Object Fuser_login_name ();
extern Lisp_Object Fuser_real_login_name ();
extern Lisp_Object Fuser_real_uid ();
extern Lisp_Object Fuser_uid ();
extern Lisp_Object Fwiden ();
extern Lisp_Object Fpoint_min_marker (), Fpoint_max_marker ();
extern Lisp_Object Fpoint_min (), Fpoint_max ();
extern Lisp_Object Fpoint (), Fpoint_marker (), Fmark_marker ();
extern Lisp_Object Ffollchar (), Fprevchar (), Fchar_after ();
extern Lisp_Object Finsert (int, Lisp_Object *);
extern Lisp_Object Fchar_before ();
extern Lisp_Object Feolp (), Feobp (), Fbolp (), Fbobp ();
extern Lisp_Object Fformat (), format1 ();
extern Lisp_Object Fbuffer_substring (), Fbuffer_string ();
extern Lisp_Object Fbufsize ();
extern Lisp_Object Fstring_equal (), Fstring_lessp (), Fbuffer_substring_lessp ();
extern Lisp_Object save_excursion_save (), save_restriction_save ();
extern Lisp_Object save_excursion_restore (), save_restriction_restore ();
extern Lisp_Object Fchar_to_string ();

/* defined in buffer.c */
extern Lisp_Object Vbuffer_alist;
extern Lisp_Object Fbuffer_enable_undo ();
extern Lisp_Object Fbuffer_file_name ();
extern Lisp_Object Fbuffer_flush_undo ();
extern Lisp_Object Fbuffer_list ();
extern Lisp_Object Fbuffer_local_variables ();
extern Lisp_Object Fbuffer_modified_p ();
extern Lisp_Object Fbuffer_name ();
extern Lisp_Object Fbury_buffer ();
extern Lisp_Object Ferase_buffer ();
extern Lisp_Object Fgenerate_new_buffer ();
extern Lisp_Object Fget_file_buffer ();
extern Lisp_Object Fkill_all_local_variables ();
extern Lisp_Object Fkill_buffer ();
extern Lisp_Object Flist_buffers ();
extern Lisp_Object Frename_buffer ();
extern Lisp_Object Fset_buffer_modified_p ();
extern Lisp_Object Fget_buffer (), Fget_buffer_create (), Fset_buffer ();
extern Lisp_Object Fbarf_if_buffer_read_only ();
extern Lisp_Object Fcurrent_buffer (), Fswitch_to_buffer (), Fpop_to_buffer ();
extern Lisp_Object Fother_buffer ();
extern struct buffer *all_buffers;

/* defined in marker.c */

extern Lisp_Object Fmarker_point_type ();
extern Lisp_Object Fmarker_position (), Fmarker_buffer ();
extern Lisp_Object Fcopy_marker ();
extern Lisp_Object Fset_marker ();
extern Lisp_Object Fset_marker_type ();

/* Defined in fileio.c */

extern Lisp_Object Qfile_error;
extern Lisp_Object Fadd_name_to_file ();
extern Lisp_Object Fclear_visited_file_modtime ();
extern Lisp_Object Fcopy_file ();
extern Lisp_Object Fdelete_file ();
extern Lisp_Object Fdirectory_file_name ();
extern Lisp_Object Fdo_auto_save ();
extern Lisp_Object Ffile_directory_p ();
extern Lisp_Object Ffile_exists_p ();
extern Lisp_Object Ffile_locked_p ();
extern Lisp_Object Ffile_modes ();
extern Lisp_Object Ffile_name_absolute_p ();
extern Lisp_Object Ffile_name_as_directory ();
extern Lisp_Object Ffile_name_directory ();
extern Lisp_Object Ffile_newer_than_file_p ();
extern Lisp_Object Ffile_readable_p ();
extern Lisp_Object Ffile_writable_p ();
extern Lisp_Object Finsert_file_contents ();
extern Lisp_Object Fmake_symbolic_link ();
extern Lisp_Object Fmake_temp_name ();
extern Lisp_Object Fread_file_name_internal ();
extern Lisp_Object Frecent_auto_save_p ();
extern Lisp_Object Frename_file ();
extern Lisp_Object Fset_buffer_auto_saved ();
extern Lisp_Object Fset_file_modes ();
extern Lisp_Object Fsi_insert_file_contents ();
extern Lisp_Object Fsi_write_region (int, Lisp_Object *);
extern Lisp_Object Fupdate_visited_file_modtime ();
extern Lisp_Object Fverify_visited_file_modtime ();
extern Lisp_Object Fwrite_region ();
extern Lisp_Object Fexpand_file_name (), Ffile_name_nondirectory ();
extern Lisp_Object Fsubstitute_in_file_name ();
extern Lisp_Object Ffile_symlink_p ();

/* Defined in abbrev.c */

extern Lisp_Object Vfundamental_mode_abbrev_table;
extern Lisp_Object Fabbrev_expansion ();
extern Lisp_Object Fabbrev_symbol ();
extern Lisp_Object Fclear_abbrev_table ();
extern Lisp_Object Fdefine_abbrev ();
extern Lisp_Object Fdefine_abbrev_table ();
extern Lisp_Object Fdefine_global_abbrev ();
extern Lisp_Object Fdefine_mode_abbrev ();
extern Lisp_Object Fexpand_abbrev ();
extern Lisp_Object Finsert_abbrev_table_description ();
extern Lisp_Object Fmake_abbrev_table ();
extern Lisp_Object Funexpand_abbrev ();

/* defined in search.c */
extern unsigned char downcase_table[];
extern Lisp_Object Flooking_at ();
extern Lisp_Object Fmatch_beginning ();
extern Lisp_Object Fmatch_data ();
extern Lisp_Object Fmatch_end ();
extern Lisp_Object Fre_search_backward ();
extern Lisp_Object Fre_search_forward ();
extern Lisp_Object Fregexp_compile_pattern ();
extern Lisp_Object Fregexp_quote ();
extern Lisp_Object Freplace_match ();
extern Lisp_Object Fsearch_backward ();
extern Lisp_Object Fsearch_forward ();
extern Lisp_Object Fstring_match ();
extern Lisp_Object Fscan_buffer ();
extern Lisp_Object Fskip_chars_backward ();
extern Lisp_Object Fskip_chars_forward ();
extern Lisp_Object Fstore_match_data ();
extern Lisp_Object Fword_search_backward ();
extern Lisp_Object Fword_search_forward ();

/* defined in minibuf.c */

extern Lisp_Object last_minibuf_string, Vminibuffer_list;
extern Lisp_Object read_minibuf (), Fcompleting_read ();
extern Lisp_Object Fall_completions ();
extern Lisp_Object Fcompleting_read ();
extern Lisp_Object Fdisplay_completion_list ();
extern Lisp_Object Fexit_minibuffer ();
extern Lisp_Object Fminibuffer_complete ();
extern Lisp_Object Fminibuffer_complete_and_exit ();
extern Lisp_Object Fminibuffer_complete_word ();
extern Lisp_Object Fminibuffer_completion_help ();
extern Lisp_Object Fminibuffer_depth ();
extern Lisp_Object Fminibuffer_extend_prompt ();
extern Lisp_Object Fread_buffer ();
extern Lisp_Object Fread_command ();
extern Lisp_Object Fread_from_minibuffer ();
extern Lisp_Object Fread_variable ();
extern Lisp_Object Fread_minibuffer (), Feval_minibuffer ();
extern Lisp_Object Fread_string (), Fread_file_name ();
extern Lisp_Object Fread_no_blanks_input ();
extern Lisp_Object Fself_insert_and_exit ();
extern Lisp_Object Ftry_completion ();

/* Defined in callint.c */

extern Lisp_Object Vcommand_history;
extern Lisp_Object Qcall_interactively;
extern Lisp_Object Fcall_interactively ();
extern Lisp_Object Finteractive ();
extern Lisp_Object Fprefix_numeric_value ();

/* defined in casefiddle.c */

extern Lisp_Object Fdowncase (), Fupcase (), Fcapitalize ();
extern Lisp_Object Fcapitalize_region ();
extern Lisp_Object Fcapitalize_word ();
extern Lisp_Object Fdowncase_region ();
extern Lisp_Object Fdowncase_word ();
extern Lisp_Object Fupcase_region ();
extern Lisp_Object Fupcase_word ();

/* defined in keyboard.c */

extern Lisp_Object Vhelp_form, Vtop_level;
extern Lisp_Object Fabort_recursive_edit ();
extern Lisp_Object Fcommand_execute ();
extern Lisp_Object Fexecute_extended_command ();
extern Lisp_Object Fexit_recursive_edit ();
extern Lisp_Object Fopen_dribble_file ();
extern Lisp_Object Fread_key_sequence ();
extern Lisp_Object Frecent_keys ();
extern Lisp_Object Frecursion_depth ();
extern Lisp_Object Fset_input_mode ();
extern Lisp_Object Fsuspend_emacs ();
extern Lisp_Object Fthis_command_keys ();
extern Lisp_Object Ftop_level ();
extern Lisp_Object Fdiscard_input (), Frecursive_edit ();
extern Lisp_Object Fcommand_execute (), Finput_pending_p ();
extern int poll_suppress_count;

/* defined in keymap.c */

extern Lisp_Object Qkeymap;
extern Lisp_Object Faccessible_keymaps ();
extern Lisp_Object Fapropos ();
extern Lisp_Object Fcopy_keymap ();
extern Lisp_Object Fcurrent_front_map ();
extern Lisp_Object Fcurrent_global_map ();
extern Lisp_Object Fcurrent_local_map ();
extern Lisp_Object Fdefine_key ();
extern Lisp_Object Fdefine_prefix_command ();
extern Lisp_Object Fdescribe_bindings ();
extern Lisp_Object Ffront_key_binding ();
extern Lisp_Object Ffront_set_key ();
extern Lisp_Object Fglobal_key_binding ();
extern Lisp_Object Fglobal_set_key ();
extern Lisp_Object Fglobal_unset_key ();
extern Lisp_Object Fkeymapp ();
extern Lisp_Object Fkey_binding ();
extern Lisp_Object Fkey_description (), Fsingle_key_description ();
extern Lisp_Object Flocal_key_binding ();
extern Lisp_Object Flocal_set_key ();
extern Lisp_Object Flocal_unset_key ();
extern Lisp_Object Flookup_key ();
extern Lisp_Object Fmake_keymap ();
extern Lisp_Object Fmake_sparse_keymap ();
extern Lisp_Object Ftext_char_description ();
extern Lisp_Object Fuse_front_map ();
extern Lisp_Object Fuse_global_map ();
extern Lisp_Object Fuse_local_map ();
extern Lisp_Object Fwhere_is ();
extern Lisp_Object Fwhere_is_internal ();
extern Lisp_Object access_keymap (), store_in_keymap ();
extern Lisp_Object get_keyelt (), get_keymap();

/* defined in indent.c */
extern Lisp_Object Fcurrent_indentation ();
extern Lisp_Object Fmove_to_column ();
extern Lisp_Object Fvertical_motion (), Findent_to (), Fcurrent_column ();

/* defined in window.c */
extern Lisp_Object Qwindowp;
extern Lisp_Object Fcurrent_window_configuration ();
extern Lisp_Object Fdelete_other_windows ();
extern Lisp_Object Fdelete_window ();
extern Lisp_Object Fdelete_windows_on ();
extern Lisp_Object Fdisplay_buffer ();
extern Lisp_Object Fenlarge_window ();
extern Lisp_Object Fget_buffer_window ();
extern Lisp_Object Fget_largest_window ();
extern Lisp_Object Fget_lru_window ();
extern Lisp_Object Fminibuffer_window ();
extern Lisp_Object Fmove_to_window_line ();
extern Lisp_Object Fnext_window ();
extern Lisp_Object Fother_window ();
extern Lisp_Object Fpos_visible_in_window_p ();
extern Lisp_Object Fprevious_window ();
extern Lisp_Object Frecenter ();
extern Lisp_Object Freplace_buffer_in_windows ();
extern Lisp_Object Fsave_window_excursion ();
extern Lisp_Object Fscroll_down ();
extern Lisp_Object Fscroll_left ();
extern Lisp_Object Fscroll_other_window ();
extern Lisp_Object Fscroll_right ();
extern Lisp_Object Fscroll_up ();
extern Lisp_Object Fselect_window ();
extern Lisp_Object Fselected_window ();
extern Lisp_Object Fset_window_buffer ();
extern Lisp_Object Fset_window_hscroll ();
extern Lisp_Object Fset_window_point ();
extern Lisp_Object Fset_window_start ();
extern Lisp_Object Fshrink_window ();
extern Lisp_Object Fsplit_window ();
extern Lisp_Object Fwindow_buffer ();
extern Lisp_Object Fwindow_edges ();
extern Lisp_Object Fwindow_height ();
extern Lisp_Object Fwindow_hscroll ();
extern Lisp_Object Fwindow_point ();
extern Lisp_Object Fwindow_start ();
extern Lisp_Object Fwindow_width ();
extern Lisp_Object Fwindowp ();
extern Lisp_Object Fset_window_configuration (), Fcurrent_window_configuration ();

/* defined in emacs.c */
extern Lisp_Object decode_env_path ();
/* Nonzero means don't do interactive redisplay and don't change tty modes */
extern int noninteractive;
/* Nonzero means don't do use window-system-specific display code */
extern int inhibit_window_system;
extern Lisp_Object Fdump_emacs ();
extern Lisp_Object Fkill_emacs ();

/* defined in process.c */
extern Lisp_Object Faccept_process_output ();
extern Lisp_Object Fcontinue_process ();
extern Lisp_Object Fdelete_process ();
extern Lisp_Object Finterrupt_process ();
extern Lisp_Object Flist_processes ();
extern Lisp_Object Fopen_network_stream (int, Lisp_Object *);
extern Lisp_Object Fprocess_buffer ();
extern Lisp_Object Fprocess_coding_system ();
extern Lisp_Object Fprocess_command ();
extern Lisp_Object Fprocess_exit_status ();
extern Lisp_Object Fprocess_filter ();
extern Lisp_Object Fprocess_id ();
extern Lisp_Object Fprocess_kill_without_query ();
extern Lisp_Object Fprocess_list ();
extern Lisp_Object Fprocess_mark ();
extern Lisp_Object Fprocess_name ();
extern Lisp_Object Fprocess_send_eof ();
extern Lisp_Object Fprocess_send_region ();
extern Lisp_Object Fprocess_send_string ();
extern Lisp_Object Fprocess_sentinel ();
extern Lisp_Object Fprocess_status ();
extern Lisp_Object Fquit_process ();
extern Lisp_Object Fset_process_buffer ();
extern Lisp_Object Fset_process_coding_system ();
extern Lisp_Object Fset_process_filter ();
extern Lisp_Object Fset_process_sentinel ();
extern Lisp_Object Fsi_open_network_stream ();
extern Lisp_Object Fsi_start_process ();
extern Lisp_Object Fstart_process (int, Lisp_Object *);
extern Lisp_Object Fstop_process ();
extern Lisp_Object Fwaiting_for_user_input_p ();
extern Lisp_Object Fget_process (), Fget_buffer_process (), Fprocessp ();
extern Lisp_Object Fprocess_status (), Fkill_process ();

/* defined in callproc.c */
extern Lisp_Object Vexec_path, Vexec_directory;
extern Lisp_Object Fcall_process (int, Lisp_Object *);
extern Lisp_Object Fcall_process_region ();
extern Lisp_Object Fsi_call_process ();

/* defined in dired.c */
extern Lisp_Object Ffile_attributes ();
extern Lisp_Object Ffile_name_all_completions ();
extern Lisp_Object Ffile_name_completion ();

/* defined in dirs.c */
extern Lisp_Object Fdirectory_files ();

/* defined in filelock.c */
extern Lisp_Object Flock_buffer ();
extern Lisp_Object Funlock_buffer ();

#ifdef MAINTAIN_ENVIRONMENT
/* defined in environ.c */
extern int size_of_current_environ ();
extern void get_current_environ ();
/* extern void current_environ (); */
extern Lisp_Object Fgetenv ();
#endif /* MAINTAIN_ENVIRONMENT */

/* defined in doc.c */
extern Lisp_Object Vdoc_file_name;
extern Lisp_Object Fsubstitute_command_keys ();
extern Lisp_Object Fdocumentation (), Fdocumentation_property ();
extern Lisp_Object Fsnarf_documentation ();

/* defined in bytecode.c */
extern Lisp_Object Qbytecode;
extern Lisp_Object Fbyte_code ();

/* defined in macros.c */
extern Lisp_Object Fcall_last_kbd_macro ();
extern Lisp_Object Fend_of_line ();
extern Lisp_Object Fexecute_kbd_macro ();
extern Lisp_Object Fstart_kbd_macro ();

/* defined in mocklisp.c */
extern Lisp_Object Finsert_string (int, Lisp_Object *);
extern Lisp_Object Fml_arg ();
extern Lisp_Object Fml_if ();
extern Lisp_Object Fml_interactive ();
extern Lisp_Object Fml_nargs ();
extern Lisp_Object Fml_prefix_argument_loop ();
extern Lisp_Object Fml_provide_prefix_argument ();

/* defined in syntax.c */
extern Lisp_Object Fbackward_prefix_chars ();
extern Lisp_Object Fchar_syntax ();
extern Lisp_Object Fchar_syntax_at ();
extern Lisp_Object Fchar_syntax_match ();
extern Lisp_Object Fcopy_syntax_table ();
extern Lisp_Object Fdescribe_syntax ();
extern Lisp_Object Fforward_word ();
extern Lisp_Object Fmodify_syntax_entry ();
extern Lisp_Object Fparse_partial_sexp ();
extern Lisp_Object Fscan_lists ();
extern Lisp_Object Fscan_sexps ();
extern Lisp_Object Fset_syntax_table ();
extern Lisp_Object Fstandard_syntax_table ();
extern Lisp_Object Fsyntax_code_spec ();
extern Lisp_Object Fsyntax_spec_code ();
extern Lisp_Object Fsyntax_table ();
extern Lisp_Object Fsyntax_table_p ();

/* defined in undo.c */
extern Lisp_Object Fprimitive_undo ();
extern Lisp_Object Fundo_boundary ();

/* defined in xdisp.c */
extern Lisp_Object Fredraw_display ();
extern Lisp_Object Fupdate_mode_lines ();

/* defined in xfns.c or x11fns.c */
extern Lisp_Object Fx_color_p ();
extern Lisp_Object Fx_debug ();
extern Lisp_Object Fx_flip_color ();
extern Lisp_Object Fx_get_background_color ();
extern Lisp_Object Fx_get_border_color ();
extern Lisp_Object Fx_get_compound_text ();
extern Lisp_Object Fx_get_cursor_color ();
extern Lisp_Object Fx_get_cut_buffer ();
extern Lisp_Object Fx_get_default ();
extern Lisp_Object Fx_get_fontinfo ();
extern Lisp_Object Fx_get_foreground_color ();
extern Lisp_Object Fx_get_mouse_color ();
extern Lisp_Object Fx_get_mouse_event ();
extern Lisp_Object Fx_mouse_events ();
extern Lisp_Object Fx_proc_mouse_event ();
extern Lisp_Object Fx_set_background_color ();
extern Lisp_Object Fx_set_bell ();
extern Lisp_Object Fx_set_border_color ();
extern Lisp_Object Fx_set_border_width ();
extern Lisp_Object Fx_set_ccl ();
extern Lisp_Object Fx_set_cursor_color ();
extern Lisp_Object Fx_set_font ();
extern Lisp_Object Fx_set_foreground_color ();
extern Lisp_Object Fx_set_internal_border_width ();
extern Lisp_Object Fx_set_linespace ();
extern Lisp_Object Fx_set_mouse_color ();
extern Lisp_Object Fx_store_compound_text ();
extern Lisp_Object Fx_store_cut_buffer ();

/* 92.2.28, 92.12.18 by K.Handa */
/* defined in codeconv.c */
extern Lisp_Object Fb2m ();
extern Lisp_Object Fe2s ();
extern Lisp_Object Fcheck_code ();
extern Lisp_Object Fcode_convert_region ();
extern Lisp_Object Fcode_detect_region ();
extern Lisp_Object Fcoding_system_p ();
extern Lisp_Object Fm2b ();
extern Lisp_Object Fnon_nil_coding_system_p ();
extern Lisp_Object Fs2e ();
extern Lisp_Object Fset_code_priority ();
extern Lisp_Object Fread_coding_system (), Fread_non_nil_coding_system ();
/* end of patch */

/* defined in mule.c */
extern Lisp_Object Fchar_boundary_p ();
extern Lisp_Object Fchar_bytes ();
extern Lisp_Object Fchar_component ();
extern Lisp_Object Fchar_direction ();
extern Lisp_Object Fchar_leading_char ();
extern Lisp_Object Fchars_in_string ();
extern Lisp_Object Fdefine_word_pattern ();
extern Lisp_Object Fleading_char ();
extern Lisp_Object Fmake_character ();
extern Lisp_Object Fnew_character_set ();
extern Lisp_Object Fre_compile ();
extern Lisp_Object Fredisplay_region ();
extern Lisp_Object Fstring_width ();

/* Nonzero means Emacs has already been initialized.
   Used during startup to detect startup of dumped Emacs.  */
extern int initialized;

extern int immediate_quit;	    /* Nonzero means ^G can quit instantly */

extern void debugger ();

extern long *xmalloc (), *xrealloc ();

#ifdef MAINTAIN_ENVIRONMENT
extern unsigned char *egetenv ();
#else
#define egetenv getenv
#endif

