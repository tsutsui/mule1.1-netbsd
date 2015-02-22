$! VMS command file to run `temacs.exe' and do `mule-bytecomp'
$!      for Mule 0.9.6		30-OCT-1992  T.Atsushiba
$!	for Mule 0.9.7.1	7-JAN-1993   K.Handa
$!	for Mule 0.9.8		16-JUN-1993  T.Atsushiba
$!	for Mule 0.9.8-05	20-JUL-1993  T.Atsushiba
$!
$! Specified files will be `mule-bytecomp'ed. You can add new files if needed.
$! Maximum length for VMS command is restricted so that about 10 files are
$! reasonable to specify for a command execution.
$!
$ temacs :== $emacs_library:[src]temacs -batch
$ temacs -l "mule-inst" emacs_library:[lisp] -
"mule.elc"	-
"mule-util.elc"	-
"attribute.elc"	-
"kinsoku.elc"	-
"quail.elc"	-
"regexp.elc"	-
"keyboard.elc"	-
"ccl.elc"	-
"worddef.elc"	-
"bytecomp.elc"	-
"debug.elc"	-
"files.elc"
$ temacs -l "mule-inst" emacs_library:[lisp] -
"fill.elc"	-
"info.elc"	-
"isearch.elc"	-
"picture.elc"	-
"startup.elc"	-
"replace.elc"	-
"rmail.elc"	-
"simple.elc"	-
"texinfmt.elc"	-
"dired.elc"
$ temacs -l "mule-inst" emacs_library:[lisp] -
"macros.elc"	-
"man.elc"	-
"sendmail.elc"	-
"dabbrev.elc"	-
"prolog.elc"	-
"x-mouse.elc"	-
"compile.elc"
$ exit
