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

SRCS =	getdisk.c sigsetmask.c random.c \
	getwd.c chdir.c

OBJS =	getdisk.o sigsetmask.o random.o \
	getwd.o chdir.o

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
