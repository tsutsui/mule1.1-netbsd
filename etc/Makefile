CFLAGS= -g -O -fno-strict-aliasing
# For Solaris2. Needed for emacsclient
#  LOADLIBES= -lsocket -lnsl -lelf
# For Xenix.  Needed for movemail
#  LOADLIBES= -lx
# For Mips.  Needed for who knows what.
#  CFLAGS = -g -systype bsd43

# 92.3.31  modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
#	Sun console feature added.
# 92.6.26  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
#	bdftoscf uses BDF files defined by macro BDF_FILES in this file.
# 92.6.26  modified for Mule Ver.0.9.5
#		by T.Shimokawa <toshi@isl.rdc.toshiba.co.jp>
#	font.scf is created by calling "./bdftoscf".
# 92.8.6   modified for Mule Ver.0.9.6
#		by S.Kobayashi <koba@keisu-s.t.u-tokyo.ac.jp>
#	font.scf is removed under the target clean and distclean.
# 92.10.14 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
#	font.scf is now not used, and bdfstaff and m2ps are added.
# 92.10.30 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
#	Name change --  bdfstaff->bdf
# 92.10.30 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
#	Change of the way to compile bdf.c.
# 93.2.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
#	'distclean' should clean all.
# 93.5.7  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
#	Support HEBREW and BIG5.
#	bdf.o depends on ../src/codeconv.h.
# 93.6.25 modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
#	Name change: charsets -> charset.
# 93.6.27  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
#	m2ps depends on config.h and mule.h, compiled with ${LOADLIBS}
# 93.7.17  modified for Mule Ver.0.9.8
#			by Koaunghi Un <zraun01@hpserv.zdv.uni-tuebingen.de>
#	For Linux, /bin/sed -> sed.
# 93.7.27  modified for Mule Ver.0.9.8 by T.Saneto <sanewo@pdp.crl.sony.co.jp>
#	No need of ${LOADLIBS} for bdf.o.

EXECUTABLES = test-distrib etags ctags wakeup make-docfile \
   digest-doc sorted-doc movemail cvtmail fakemail yow env \
   server emacsclient m2ps

all: ${EXECUTABLES}

clean:
	-rm -f ${EXECUTABLES} core

distclean:
	-rm -f ${EXECUTABLES} *~ \#* DOC* core bdf.o mule.1 m2ps.1 charset CHARSETS

# This justs verifies that the non-ASCII characters
# in the file `testfile' have no been clobbered by
# whatever means were used to copy and distribute Emacs.
# If they were clobbered, all the .elc files were clobbered too.
test-distrib: test-distrib.c
	$(CC) -o test-distrib test-distrib.c
	./test-distrib

etags: etags.c
	$(CC) -o etags ${CFLAGS} ${LDFLAGS} -DETAGS etags.c $(LOADLIBES)

ctags: etags.c
	$(CC) -o ctags ${CFLAGS} ${LDFLAGS} -DCTAGS etags.c $(LOADLIBES)

wakeup: wakeup.c
	$(CC) -o wakeup ${CFLAGS} ${LDFLAGS} wakeup.c $(LOADLIBES)

make-docfile: make-docfile.c
	$(CC) -o make-docfile ${CFLAGS} ${LDFLAGS} make-docfile.c $(LOADLIBES)

digest-doc: digest-doc.c
	$(CC) -o digest-doc ${CFLAGS} ${LDFLAGS} digest-doc.c $(LOADLIBES)

sorted-doc: sorted-doc.c
	$(CC) -o sorted-doc ${CFLAGS} ${LDFLAGS} sorted-doc.c $(LOADLIBES)

#
movemail: movemail.c ../src/config.h
	$(CC) -o movemail ${CFLAGS} ${LDFLAGS} movemail.c $(LOADLIBES)

cvtmail: cvtmail.c
	$(CC) -o cvtmail ${CFLAGS} ${LDFLAGS} cvtmail.c $(LOADLIBES)

fakemail: fakemail.c ../src/config.h
	$(CC) -o fakemail ${CFLAGS} ${LDFLAGS} fakemail.c $(LOADLIBES)

yow: yow.c ../src/paths.h
	$(CC) -o yow ${CFLAGS} ${LDFLAGS} yow.c $(LOADLIBES)

# this is silly -- just use emacs to edit this file!
# (in any case this program doesn't preserve alphabetical ordering,
#  which is why I'm removing it)
#addyow: addyow.c
#	$(CC) -o addyow ${CFLAGS} addyow.c

env: env.c ../src/config.h
	$(CC) -o env -DEMACS ${CFLAGS} ${LDFLAGS} env.c $(LOADLIBES)

server: server.c ../src/config.h
	$(CC) -o server ${CFLAGS} ${LDFLAGS} server.c $(LOADLIBES)

emacsclient: emacsclient.c ../src/config.h
	$(CC) -o emacsclient ${CFLAGS} ${LDFLAGS} emacsclient.c $(LOADLIBES)

# This one is NOT included in EXECUTABLES.
# See ../src/ymakefile.
emacstool: emacstool.c
	$(CC) -o emacstool ${CFLAGS} ${LDFLAGS} emacstool.c -lsuntool -lsunwindow -lpixrect $(LOADLIBES)

nemacstool: emacstool.c
	$(CC) -o nemacstool ${CFLAGS} ${LDFLAGS} -DJLE emacstool.c -lsuntool -lmle -lsunwindow -lpixrect $(LOADLIBES)	# For SUN Japanese Language Environment

xvetool: emacstool.c
	$(CC) -o xvetool ${CFLAGS} ${LDFLAGS} -DXVIEW         emacstool.c -lxview -lolgx -lX -I$(OPENWINHOME)/include -L$(OPENWINHOME)/lib $(LOADLIBES)

xveterm: emacstool.c
	$(CC) -o xveterm ${CFLAGS} ${LDFLAGS} -DXVIEW -DTTERM emacstool.c -lxview -lolgx -lX -I$(OPENWINHOME)/include -L$(OPENWINHOME)/lib $(LOADLIBES)

# 92.6.26, 92.10.14 by K.Handa
XV11R5 = /usr/share/src/X.V11R5
BDF_PATH = -DBDF_PATH=\"${XV11R5}/mit/fonts/bdf/misc,${XV11R5}/contrib/clients/cxterm/fonts,/usr/share/fonts/X11/ETL,/usr/share/fonts/X11/cxterm,/usr/share/fonts/X11/hojo\"
# Each one-byte font may have encoding information as
#	bdf_file_name:encoding
# where encoding is 0 or 1 and defaults to 0.
# You also can specify or override the following definitions
# by manually editing 'CHARSETS'.
ASCII = etl24-latin1.bdf:0
LATIN1 = etl24-latin1.bdf:1
LATIN2 = etl24-latin2.bdf:1
LATIN3 = etl24-latin3.bdf:1
LATIN4 = etl24-latin4.bdf:1
GREEK = etl24-greek.bdf:1
HEBREW = etl24-hebrew.bdf:1
KANA = 12x24rk.bdf:1
ROMAN = 12x24rk.bdf:0
CYRILLIC = etl24-cyrillic.bdf:1
LATIN5 = etl24-latin5.bdf:1
CHINESE = cclib24st.bdf
JAPANESE = jiskan24.bdf
KOREAN = hanglm24.bdf
JP-HOJO = hojo24.bdf
BIG5 = taipei24.bdf:1
SISHENG = etl24-sisheng.bdf:0
THAI = etl24-thai.bdf:1

SED_SCRIPT =\
	-e "/LC:BYTES:/s/\(.*\)/\1[:BDF-FILE[:ENCODING]]/" \
	-e "/ASCII$$/s/\(.*\)/\1:${ASCII}/" \
	-e "/Latin-1$$/s/\(.*\)/\1:${LATIN1}/" \
	-e "/Latin-2$$/s/\(.*\)/\1:${LATIN2}/" \
	-e "/Latin-3$$/s/\(.*\)/\1:${LATIN3}/" \
	-e "/Latin-4$$/s/\(.*\)/\1:${LATIN4}/" \
	-e "/Greek$$/s/\(.*\)/\1:${GREEK}/" \
	-e "/Hebrew$$/s/\(.*\)/\1:${HEBREW}/" \
	-e "/Katakana$$/s/\(.*\)/\1:${KANA}/" \
	-e "/Roman$$/s/\(.*\)/\1:${ROMAN}/" \
	-e "/Cyrillic$$/s/\(.*\)/\1:${CYRILLIC}/" \
	-e "/Latin-5$$/s/\(.*\)/\1:${LATIN5}/" \
	-e "/Chinese$$/s/\(.*\)/\1:${CHINESE}/" \
	-e "/Japanese$$/s/\(.*\)/\1:${JAPANESE}/" \
	-e "/Korean$$/s/\(.*\)/\1:${KOREAN}/" \
	-e "/Japanese Supplement$$/s/\(.*\)/\1:${JP-HOJO}/" \
	-e "/Big5/s/\(.*\)/\1:${BIG5}/" \
	-e "/ZhuYin$$/s/\(.*\)/\1:${SISHENG}/" \
	-e "/TSCII$$/s/\(.*\)/\1:${THAI}/"

CHARSETS: charset
	sed ${SED_SCRIPT} < charset > CHARSETS

bdf.o: bdf.c bdf.h Makefile\
	../src/config.h ../src/mule.h ../src/paths.h ../src/codeconv.h
	$(CC) -c ${CFLAGS} bdf.c ${BDF_PATH}

m2ps: bdf.h m2ps.c bdf.o ../src/config.h ../src/mule.h ../src/paths.h
	-$(CC) -o m2ps ${CFLAGS} m2ps.c bdf.o ${LOADLIBES}

# end of patch
