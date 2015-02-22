$! VMS command file to execute 'vms-pp'
$!	for Mule 0.9.7.1	06-MAR-1993	T.Atsushiba
$!	for Mule 0.9.8		29-JUN-1993	T.Atsushiba
$!
$! If you're going to build Mule on VMS and dislike compilation warnings
$! signaled because of length of symbols, execute this command file.
$! This file will change the following files. Other files specified are 
$! only copied.
$!
$!	abbrev.c	alloc.c		buffer.c	callproc.c
$!	canna.c		category.c	editfns.c	emacs.c
$!	eval.c		insdel.c	keyboard.c	keymap.c
$!	minibuf.c	print.c		process.c	regex.c
$!	search.c	syntax.c	vmsmap.c	wnnfns.c
$!	commands.h	m-alliant.h	m-irist.h	m-sequent.h
$!	s-vms.h
$!
$!	fileio.c	mcpath.c	transmode.c	vms-pp.c
$!	transmode.h
$!
$! But, in order to garantee the identities of symbol names, I strongly 
$! recommend all .c .h and .h-dist files are tried at the same time.
$! See also VMSBUILD, vms-pp.c and vms-pp.trans.
$!
$ cc/define=mule vms-pp
$ link vms-pp,sys$input/opt
sys$library:vaxcrtl/share
$ vmspp :== mcr []vms-pp.exe
$ apply :== @[]apply
$!
$! Language C source file (.c).  All .c files should be tried here.
$!
$ apply "vmspp $<!" *.c,*.h,*.h-dist
$ exit
