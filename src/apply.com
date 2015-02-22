$!
$!	A P P L Y . C O M 
$!
$!	ABSTRUCT:
$!	  "APPLY" a specified command to specified files, which may be
$!	  specified with wildcard.
$!
$!	AUTHOR:
$!	  Noriyuki Kawamoto
$!
$!	CREATION DATE:
$!	  02-SEP-1991
$!
$! on error then goto error
$! on warning then goto error
$ set noon
$ if (p1 .eqs. "") .or. (p2 .eqs. "")
$   then
$	type sys$input:
USAGE:
  $ @APPLY command filespec[,more-filespec..] [optional-parameters..]
  o Strings in optional parameters are converted as following.
    "$*" : filename
    "$<" : filename+filetype
  o Don't use whitespace within `filespec'.

EXAMPLE:
  1.Make DIFFERENCE between X*.TXT,Y*.TXT on current directory and
    X*.TXT_OLD, Y*.TXT_OLD on FOO:[BAR].
  $ @APPLY "DIFF FOO:[BAR]$*.TXT_OLD" T*.TXT,Y*.TXT

  2.Download ZIP files on current directory into drive:B on PC with EFS.
  $ @APPLY "MCR EFS DOWNLOAD" *.ZIP """B:$<"""
$	exit
$ endif
$ filelist := 'p2
$ file_counter = 0
$ file_loop:
$ filespec = f$element(file_counter,",",filelist)
$ if filespec .eqs. "," then exit
$ gosub apply
$ file_counter = file_counter + 1
$ goto file_loop
$!
$!
$!
$ apply:
$ command = "''p1'"
$! filespec := 'p2
$ context = 1
$ prev_file = ""
$!	Loop while pattern matches with file.
$ loop:
$ file = f$search(filespec,context)
$ if file .eqs. "" then goto end
$ if file .eqs. prev_file then goto end
$ prev_file = file
$ filename = f$parse(file,,,"name")
$ filetype = f$parse(file,,,"type")
$!	Translation of P3〜P8.
$ counter = 3
$ target = "''command'"
$ gosub replace
$ exec = target + " " + file
$ co_loop:
$ target = P'counter
$ if target .eqs. "" then goto co_loop_end
$ gosub replace
$ exec = exec + " " + target
$ counter = counter + 1
$ if counter .gt. 9 then goto co_loop_end
$ goto co_loop
$ co_loop_end:
$!	Execute Command.
$! write sys$output "$ " + exec
$ 'exec
$ goto loop
$ end:
$ return
$!
$!	replace "$*" to filename
$!	replace "$<" to filename+filetype
$!
$ REPLACE:
$ REPLACE1:
$ length = f$length(target)
$ loc = f$locate("$*",target)
$ if (loc .ne. length)
$   then
$	target = f$extract(0,loc,target) + filename + -
		 f$extract(loc+2,length,target)
$ else
$	goto replace2
$ endif
$ goto replace1
$!
$ REPLACE2:
$ length = f$length(target)
$ loc = f$locate("$<",target)
$ if (loc .ne. length)
$  then
$ 	target = f$extract(0,loc,target) + filename + filetype + -
		 f$extract(loc+2,length,target)
$ else
$  	return
$ endif
$ goto replace2
$ return
$ exit

