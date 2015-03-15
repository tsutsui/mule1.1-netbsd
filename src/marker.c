/* Markers: examining, setting and killing.
   Copyright (C) 1985 Free Software Foundation, Inc.

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

/* 89.11.30 modified for point_type_marker K.Handa (handa@etl.go.jp) */
/* 90.7.10  bug fixed in copy-marker by masukawa@sevax1.cse.canon.co.jp */
/* 91.10.28 modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp> */
/* 92.3.6   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp> */

#include "config.h"
#include "lisp.h"
#include "buffer.h"

/* Operations on markers. */

DEFUN ("marker-buffer", Fmarker_buffer, Smarker_buffer, 1, 1, 0,
  "Return the buffer that MARKER points into, or nil if none.\n\
Returns nil if MARKER points into a dead buffer.")
  (marker)
     register Lisp_Object marker;
{
  register Lisp_Object buf;
  CHECK_MARKER (marker, 0);
  if (XMARKER (marker)->buffer)
    {
      XSET (buf, Lisp_Buffer, XMARKER (marker)->buffer);
      /* Return marker's buffer only if it is not dead.  */
      if (!NULL (XBUFFER (buf)->name))
	return buf;
    }
  return Qnil;
}

DEFUN ("marker-position", Fmarker_position, Smarker_position, 1, 1, 0,
  "Return the position MARKER points at, as a character number.")
  (marker)
     Lisp_Object marker;
{
  register Lisp_Object pos;
  register int i;
  register struct buffer *buf;

  CHECK_MARKER (marker, 0);
  if (XMARKER (marker)->buffer)
    {
      buf = XMARKER (marker)->buffer;
      i = XMARKER (marker)->bufpos;

      if (i > BUF_GPT (buf) + BUF_GAP_SIZE (buf))
	i -= BUF_GAP_SIZE (buf);
      else if (i > BUF_GPT (buf))
	i = BUF_GPT (buf);

      if (i < BUF_BEG (buf) || i > BUF_Z (buf))
	abort ();

      XFASTINT (pos) = i;
      return pos;
    }
  return Qnil;
}

DEFUN ("set-marker", Fset_marker, Sset_marker, 2, 3, 0,
  "Position MARKER before character number NUMBER in BUFFER.\n\
BUFFER defaults to the current buffer.\n\
If NUMBER is nil, makes marker point nowhere.\n\
Then it no longer slows down editing in any buffer.\n\
Returns MARKER.")
  (marker, pos, buffer)
     Lisp_Object marker, pos, buffer;
{
  register int charno;
  register struct buffer *b;
  register struct Lisp_Marker *m;

  CHECK_MARKER (marker, 0);
  /* If position is nil or a marker that points nowhere,
     make this marker point nowhere.  */
  if (NULL (pos) ||
      (XTYPE (pos) == Lisp_Marker && !XMARKER (pos)->buffer))
    {
      if (XMARKER (marker)->buffer)
	unchain_marker (marker);
      return marker;
    }

  CHECK_NUMBER_COERCE_MARKER (pos, 1);
  if (NULL (buffer))
    b = current_buffer;
  else
    {
      CHECK_BUFFER (buffer, 1);
      b = XBUFFER (buffer);
      /* If buffer is dead, set marker to point nowhere.  */
      if (EQ (b->name, Qnil))
	{
	  if (XMARKER (marker)->buffer)
	    unchain_marker (marker);
	  return marker;
	}
    }

  charno = XINT (pos);
  m = XMARKER (marker);

  if (charno < BUF_BEG (b))
    charno = BUF_BEG (b);
  if (charno > BUF_Z (b))
    charno = BUF_Z (b);
  if (charno > BUF_GPT (b)) charno += BUF_GAP_SIZE (b);
  m->bufpos = charno;

  if (m->buffer != b)
    {
      if (m->buffer != 0)
	unchain_marker (marker);
      m->chain = b->markers;
      b->markers = marker;
      m->buffer = b;
    }
  
  return marker;
}

/* This version of Fset_marker won't let the position be outside the visible part.  */
Lisp_Object 
set_marker_restricted (marker, pos, buffer)
     Lisp_Object marker, pos, buffer;
{
  register int charno;
  register struct buffer *b;
  register struct Lisp_Marker *m;

  CHECK_MARKER (marker, 0);
  /* If position is nil or a marker that points nowhere,
     make this marker point nowhere.  */
  if (NULL (pos) ||
      (XTYPE (pos) == Lisp_Marker && !XMARKER (pos)->buffer))
    {
      if (XMARKER (marker)->buffer)
	unchain_marker (marker);
      return marker;
    }

  CHECK_NUMBER_COERCE_MARKER (pos, 1);
  if (NULL (buffer))
    b = current_buffer;
  else
    {
      CHECK_BUFFER (buffer, 1);
      b = XBUFFER (buffer);
      /* If buffer is dead, set marker to point nowhere.  */
      if (EQ (b->name, Qnil))
	{
	  if (XMARKER (marker)->buffer)
	    unchain_marker (marker);
	  return marker;
	}
    }

  charno = XINT (pos);
  m = XMARKER (marker);

  if (charno < BUF_BEGV (b))
    charno = BUF_BEGV (b);
  if (charno > BUF_ZV (b))
    charno = BUF_ZV (b);
  if (charno > BUF_GPT (b))
    charno += BUF_GAP_SIZE (b);
  m->bufpos = charno;

  if (m->buffer != b)
    {
      if (m->buffer != 0)
	unchain_marker (marker);
      m->chain = b->markers;
      b->markers = marker;
      m->buffer = b;
    }
  
  return marker;
}

/* 89.11.30 by K.Handa */
DEFUN ("set-marker-type", Fset_marker_type, Sset_marker_type, 2, 2, 0,
  "Set type of MARKER to point_type if POINT_TYPE is not nil.\n\
Otherwise set to conventional type.  Returns MARKER.\n\
'point_type' means that 'insert' at that type of marker moves\n\
the marker forward (i.e. to the tail of text) just like 'point'.")
  (marker, type)
     Lisp_Object marker, type;
{
  CHECK_MARKER (marker, 0);
  XMARKER (marker)->type = (NULL(type)) ? MARKER_OLD_TYPE : MARKER_POINT_TYPE;
  return marker;
}

DEFUN ("marker-point-type", Fmarker_point_type, Smarker_point_type, 1, 1, 0,
  "T if type of marker MARKER is point_type, otherwize NIL.")
  (marker)
     Lisp_Object marker;
{
  CHECK_MARKER (marker, 0);
  if (XMARKER (marker)->type == MARKER_POINT_TYPE) return Qt;
  else return Qnil;
}
/* end of patch */

/* This is called during garbage collection,
 so we must be careful to ignore and preserve mark bits,
 including those in chain fields of markers.  */

unchain_marker (marker)
     register Lisp_Object marker;
{
  register Lisp_Object tail, prev, next;
  register Lisp_Object_Int omark;
  register struct buffer *b;

  b = XMARKER (marker)->buffer;

  if (EQ (b->name, Qnil))
    abort ();

  tail = b->markers;
  prev = Qnil;
  while (XSYMBOL (tail) != XSYMBOL (Qnil))
    {
      next = XMARKER (tail)->chain;
      XUNMARK (next);

      if (XMARKER (marker) == XMARKER (tail))
	{
	  if (NULL (prev))
	    {
	      b->markers = next;
	      /* Deleting first marker from the buffer's chain.
		 Crash if new first marker in chain does not say
		 it belongs to this buffer.  */
	      if (!EQ (next, Qnil) && b != XMARKER (next)->buffer)
		abort ();
	    }
	  else
	    {
	      omark = XMARKBIT (XMARKER (prev)->chain);
	      XMARKER (prev)->chain = next;
	      XSETMARKBIT (XMARKER (prev)->chain, omark);
	    }
	  break;
	}
      else
	prev = tail;
      tail = next;
    }
  XMARKER (marker)->buffer = 0;
}

int
marker_position (marker)
     Lisp_Object marker;
{
  register struct Lisp_Marker *m = XMARKER (marker);
  register struct buffer *buf = m->buffer;
  register int i = m->bufpos;

  if (!buf)
    error ("Marker does not point anywhere");

  if (i > BUF_GPT (buf) + BUF_GAP_SIZE (buf))
    i -= BUF_GAP_SIZE (buf);
  else if (i > BUF_GPT (buf))
    i = BUF_GPT (buf);

  if (i < BUF_BEG (buf) || i > BUF_Z (buf))
    abort ();

  return i;
}

DEFUN ("copy-marker", Fcopy_marker, Scopy_marker, 1, 1, 0,
  "Return a new marker pointing at the same place as MARKER.\n\
If argument is a number, makes a new marker pointing\n\
at that position in the current buffer.")
  (marker)
     register Lisp_Object marker;
{
  register Lisp_Object new;

  while (1)
    {
      if (XTYPE (marker) == Lisp_Int ||
	  XTYPE (marker) == Lisp_Marker)
	{
	  new = Fmake_marker ();
	  Fset_marker (new, marker,
		       ((XTYPE (marker) == Lisp_Marker)
			? Fmarker_buffer (marker)
			: Qnil));
/* 89.11.30 by K.Handa  */
	  if (XTYPE (marker) == Lisp_Marker) /* 90.7.10 by masukawa  */
	    XMARKER (new)->type = XMARKER (marker)->type;
/* end of patch */
	  return new;
	}
      else
	marker = wrong_type_argument (Qinteger_or_marker_p, marker);
    }
}

syms_of_marker ()
{
  defsubr (&Smarker_position);
  defsubr (&Smarker_buffer);
  defsubr (&Sset_marker);
  defsubr (&Sset_marker_type);	/* 91.10.28 by K.Handa */
  defsubr (&Smarker_point_type); /* 91.10.28 by K.Handa */
  defsubr (&Scopy_marker);
}
