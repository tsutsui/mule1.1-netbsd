srcdir = ../../src/

# GCCLIBDIR = /usr/local/lib/gcc-lib/i386-bsd/2.2.2/
# CC	= gcc-i386-bsd
# CFLAGS	= -I. -I$(GCCLIBDIR)include -O
CFLAGS	= -I. -O

AS	= $(GCCLIBDIR)as
LD	= $(GCCLIBDIR)ld
AR	= $(GCCLIBDIR)ar clq
RANLIB	= $(GCCLIBDIR)ranlib
RM	= rm -f

SRCS =	chdir.c access.c getwd.c pwd.c dir.c stat.c assist.s \
	getdisk.c setdisk.c \
	getkey.c \
	ttio.c \
	signal.c _signal.s

OBJS =	chdir.o access.o getwd.o pwd.o dir.o stat.o assist.o \
	getdisk.o setdisk.o \
	getkey.o \
	ttio.o \
	signal.o _signal.o

.c.o:
	$(RM) $@
	$(CC) -c $(CFLAGS) $*.c

.s.o:
	$(RM) $@
	$(AS) -o $*.o $*.s

all:: libdos.a

libdos.a: $(OBJS)
	$(RM) $@
	$(AR) $@ $(OBJS)
	-$(RANLIB) $@

clean::
	$(RM) libdos.a *.o *~ \#* a.out core


getkey.c : $(srcdir)config.h $(srcdir)buffer.h
getkey.o : getkey.c
	$(CC) $(CFLAGS) -I$(srcdir) -c getkey.c
