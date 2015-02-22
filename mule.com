$	goto := goto
$	if := if
$	define := define
$	exit := exit
$!
$	currentDirectory = f$parse(f$env("procedure"),,,,"no_conceal")
$	currentDirectory = f$parse(currentDirectory,,,"device") -
			 + f$parse(currentDirectory,,,"directory")
$	len = f$length(currentDirectory)
$loopOne:
$	locate = f$locate("<",currentDirectory)
$	if locate .eq. len then goto exitLoopOne
$	currentDirectory[locate,1] := "["
$	currentDirectory[f$locate(">",currentDirectory),1] := "]"
$	goto loopOne
$exitLoopOne:
$	currentDirectory = currentDirectory - "]["
$	len = f$length (currentDirectory)
$loopTwo:
$	locate = f$locate("000000.", currentDirectory)
$	if locate .eq. len then goto exitLoopTwo
$	currentDirectory = currentDirectory - "000000."
$	len = f$length (currentDirectory)
$	goto LoopTwo
$exitLoopTwo:
$	locate = f$locate (".000000", currentDirectory)
$	if locate .eq. len then goto exitLoopThree
$	currentDirectory = currentDirectory - ".000000"
$	len = f$length (currentDirectory)
$	goto exitLoopTwo
$exitLoopThree:
$	emacsRoot = currentDirectory - "]" + ".]"
$       qual = p1
$	define 'qual' /trans=(conc,term) emacs_library 'emacsRoot'
$	define 'qual' termcap emacs_library:[etc]termcap.dat
$	define 'qual' emacs_term "vt100"
$	emacs :== @ emacs_library:[000000]kepteditor emacs
$	runemacs :== $ emacs_library:[000000]mule -
		       -map emacs_library:[000000]mule.dump
$	! For Mule
$	mule == emacs
$	exit
