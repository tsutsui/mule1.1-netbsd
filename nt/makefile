!include <ntwin32.mak> 

CFLAGS = -DUNICODEDISPLAY -Demacs -I../nt $(INCLUDE_DIR)
LDFLAGS = $(linkdebug) -heap:32000000 -stack:8000000

.c.obj:
    $(cc) $(debug) $(cflags) $(CFLAGS) $(cvarsdll) $<


# gettimeo.c <- gettimeofday.c

OBJS	= pwd.obj dir.obj gettimeo.obj pipe.obj \
    util.obj \
    open.obj creat.obj access.obj unlink.obj \
    stat.obj fstat.obj

all: support.lib

support.lib : $(OBJS)
    $(LIB) -OUT:$*.lib $(OBJS) 
