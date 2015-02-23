# 92.3.13  Modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
# 92.3.17  Modified for Mule Ver.0.9.1 by
#			Yasunobu Kasai <y-kasai@mypcb1.sag.hitachi-sk.co.jp>
#	In doall:, 'if' command is preceded by '-' to ignore error.
# 92.3.25  Modified for Mule Ver.0.9.2 by T.Nozoe <nozoe@telcom.oki.co.jp>
#	Dependency of mule-config.h is added to xmakefile and zmakefile
# 92.4.7   Modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
#	All modification before 92.3.25 are canceled.
# 92 9.8   Modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
#	CPP is now defined as original.
# 92.10.16 Modified for Mule Ver.0.9.6 with DOS suppoert by 
#			M.Higashida <manabu@sigmath.osaka-u.ac.jp>
# 92.11.30 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
#	Name change mule-config.h -> mconfig.h-dist */
# 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
#	'distclean' should clean all.

CPP = $(CC) -E
MAKE = make  # BSD doesn't have it as a default.
#Note: an alternative is  CPP = /lib/cpp

# Just to avoid uncertainty.
SHELL = /bin/sh

all: xmakefile doall

doall:
	$(MAKE) $(MAKEOVERRIDES) -f xmakefile ${MFLAGS} all

#This is used in making a distribution.
#Do not use it on development directories!
distclean: clean
	-rm -f paths.h config.h emacs-* *~ log* mconfig.h

clean:
	-rm -f temacs xemacs xmakefile core \#* *.o libXMenu11.a

xemacs: xmakefile doxemacs

doxemacs:
	$(MAKE) $(MAKEOVERRIDES) -f xmakefile ${MFLAGS} xemacs

temacs: xmakefile dotemacs

dotemacs:
	$(MAKE) $(MAKEOVERRIDES) -f xmakefile ${MFLAGS} temacs

# If you use `command.com' or its compatible, you should use 
# DOUBLE-quote as quoting character instead of SINGLE-quote.
#quote = "
quote = '

# If you have a problem with cc -E here, changing
# the definition of CPP above may fix it.
xmakefile: ymakefile config.h mconfig.h
	-rm -f xmakefile junk.c
	cp ymakefile junk.c
	$(CPP) -P junk.c | \
	sed -e $(quote)s/^#.*//$(quote) \
	    -e $(quote)s/^[ 	][ 	]*$$//$(quote) \
	    -e $(quote)s/^ /	/$(quote) | \
	sed -n -e $(quote)/^..*$$/p$(quote) > xmakefile
	rm -f junk.c

tags:
	etags [a-z]*.h [a-z]*.c ../lisp/[a-z]*.el
