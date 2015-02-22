;; Kinsoku shori for Egg
;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).
;; This file contains Japanese characters.

;; Mule is free software distributed in the form of patches to GNU Emacs.
;; You can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; Mule is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;;; 93.5.4   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;		   and K.Mugitani <a50350@sakura.kudpc.kyoto-u.ac.jp>
;;;	Kinsoku for GB and BIG5 added.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Change Log before Ver.0.9.7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Modified for Mule 0.9.4 by K.Handa 92-May-2
;;;	Since syntax of multi-byte char is defined now,
;;;	check of English word is modified.
;;; Modified for Mule 0.9.0 by K.Handa 92-Mar-3
;;; Nemacs 3.2 created by S. Tomura 89-Nov-15
;;; Ver. 3.2  3.2 $BBP1~$KJQ99(B
;;; Nemacs 3.0 created by S. Tomura 89-Mar-17
;;; Ver. 2.1a modified by S. Tomura 88-Nov-17
;;;           word$B$NESCf$GJ,3d$7$J$$$h$&$K=$@5$7$?!#(B
;;; Ver. 2.1  modified by S. Tomura 88-Jun-24
;;;           kinsoku-shori moves the point <= fill-column + kinsoku-nobashi
;;; Nemacs V.2.1
;;; Ver. 1.1  modified by S. Tomura 88-Feb-29
;;;           Bug fix:  regexp-quote is used.
;;; Ver. 1.0  Created by S. Tomura
;;;           $B6XB'=hM}5!G=$rDs6!$9$k!#(B
;;;

(defvar japanese-kinsoku-version "3.21")
;;; Last modified date: Wed Nov 15 11:59:00 1989

;;; The followings must be merged into kanji.el
;;; patched by S.Tomura 87-Dec-7
;;;    JIS code$B$NFC<lJ8;z$N0lMwI=$G$9!#!J8MB<!K(B
;;;;     "$B!!!"!#!$!%!&!'!'!(!)!*!+!,!-!.!/(B"
;;;;   "$B!0!1!2!3!4!5!6!7!8!9!:!;!<!=!>!?(B"
;;;;   "$B!@!A!B!C!D!E!F!G!H!I!J!K!L!M!N!O(B"
;;;;   "$B!P!Q!R!S!T!U!V!W!X!Y!Z![!\!]!^!_(B"
;;;;   "$B!`!a!b!c!d!e!f!g!h!i!j!k!l!m!n!o(B"
;;;;   "$B!p!q!r!s!t!u!v!w!x!y!z!{!|!}!~(B"
;;;;     "$B"!"""#"$"%"&"'"(")"*"+","-".(B "
;;;;     "$B&!&"&#&$&%&&&'&(&)&*&+&,&-&.&/(B"
;;;;   "$B&0&1&2&3&4&5&6&7&8(B"
;;;;     "$B&A&B&C&D&E&F&G&H&I&J&K&L&M&N&O(B"
;;;;   "$B&P&Q&R&S&T&U&V&W&X(B"
;;;;     "$B'!'"'#'$'%'&'''(')'*'+','-'.'/(B"
;;;;   "$B'0'1'2'3'4'5'6'7'8'9':';'<'='>'?(B"
;;;;   "$B'@'A(B"
;;;;     "$B'Q'R'S'T'U'V'W'X'Y'Z'['\']'^'_!I(B
;;;;   "$B'`'a'b'c'd'e'f'g'h'i'j'k'l'm'n'o(B"
;;;;   "$B'p'q(B"
;;;;    $B#0#1#2#3#4#5#6#7#8#9#A#B#C#D#E#F(B
;;;;   "$B$!$#$%$'$)$C$c$e$g$n(B"
;;;;   "$B%!%#%%%'%)%C%c%e%g%n%u%v(B"

;;; Special characters for GB
;;;
;;;  $A!!!"!#!$!%!&!'!(!)!*!+!,!-!.!/(B
;;;$A!0!1!2!3!4!5!6!7!8!9!:!;!<!=!>!?(B
;;;$A!@!A!B!C!D!E!F!G!H!I!J!K!L!M!N!O(B
;;;$A!P!Q!R!S!T!U!V!W!X!Y!Z![!\!]!^!_(B
;;;$A!`!a!b!c!d!e!f!g!h!i!j!k!l!m!n!o(B
;;;$A!p!q!r!s!t!u!v!w!x!y!z!{!|!}!~(B
;;;  $A"1"2"3"4"5"6"7"8"9":";"<"=">"?(B
;;;$A"@"A"B"C"D"E"F"G"H"I"J"K"L"M"N"O(B
;;;$A"P"Q"R"S"T"U"V"W"X"Y"Z"["\"]"^"_(B
;;;$A"`"a"b"c"d"e"f"g"h"i"j"k"l"m"n"o(B
;;;$A"p"q"r"s"t"u"v"w"x"y"z"{"|"}"~(B
;;;  $A#!#"###$#%#&#'#(#)#*#+#,#-#.#/(B
;;;$A#0#1#2#3#4#5#6#7#8#9#:#;#<#=#>#?(B
;;;$A#@#A#B#C#D#E#F#G#H#I#J#K#L#M#N#O(B
;;;$A#P#Q#R#S#T#U#V#W#X#Y#Z#[#\#]#^#_(B
;;;$A#`#a#b#c#d#e#f#g#h#i#j#k#l#m#n#o(B
;;;$A#p#q#r#s#t#u#v#w#x#y#z#{#|#}#~(B
;;;  $A$!$"$#$$$%$&$'$($)$*$+$,$-$.$/(B
;;;$A$0$1$2$3$4$5$6$7$8$9$:$;$<$=$>$?(B
;;;$A$@$A$B$C$D$E$F$G$H$I$J$K$L$M$N$O(B
;;;$A$P$Q$R$S$T$U$V$W$X$Y$Z$[$\$]$^$_(B
;;;$A$`$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o(B
;;;$A$p$q$r$s$t$u$v$w$x$y$z${$|$}$~(B
;;;  $A%!%"%#%$%%%&%'%(%)%*%+%,%-%.%/(B
;;;$A%0%1%2%3%4%5%6%7%8%9%:%;%<%=%>%?(B
;;;$A%@%A%B%C%D%E%F%G%H%I%J%K%L%M%N%O(B
;;;$A%P%Q%R%S%T%U%V%W%X%Y%Z%[%\%]%^%_(B
;;;$A%`%a%b%c%d%e%f%g%h%i%j%k%l%m%n%o(B
;;;$A%p%q%r%s%t%u%v%w%x%y%z%{%|%}%~(B
;;;  $A&!&"&#&$&%&&&'&(&)&*&+&,&-&.&/(B
;;;$A&0&1&2&3&4&5&6&7&8&9&:&;&<&=&>&?(B
;;;$A&@&A&B&C&D&E&F&G&H&I&J&K&L&M&N&O(B
;;;$A&P&Q&R&S&T&U&V&W&X&Y&Z&[&\&]&^&_(B
;;;$A&`&a&b&c&d&e&f&g&h&i&j&k&l&m&n&o(B
;;;$A&p&q&r&s&t&u&v&w&x&y&z&{&|&}&~(B
;;;  $A'!'"'#'$'%'&'''(')'*'+','-'.'/(B
;;;$A'0'1'2'3'4'5'6'7'8'9':';'<'='>'?(B
;;;$A'@'A'B'C'D'E'F'G'H'I'J'K'L'M'N'O(B
;;;$A'P'Q'R'S'T'U'V'W'X'Y'Z'['\']'^'_(B
;;;$A'`'a'b'c'd'e'f'g'h'i'j'k'l'm'n'o(B
;;;$A'p'q'r's't'u'v'w'x'y'z'{'|'}'~(B
;;;  $A(!("(#($(%(&('((()(*(+(,(-(.(/(B
;;;$A(0(1(2(3(4(5(6(7(8(9(:(;(<(=(>(?(B
;;;$A(@(A(B(C(D(E(F(G(H(I(J(K(L(M(N(O(B
;;;$A(P(Q(R(S(T(U(V(W(X(Y(Z([(\(](^(_(B
;;;$A(`(a(b(c(d(e(f(g(h(i(j(k(l(m(n(o(B

;;; Special characters for BIG5
;;;
;;;  $(0!!!"!#!$!%!&!'!(!)!*!+!,!-!.!/(B
;;;$(0!0!1!2!3!4!5!6!7!8!9!:!;!<!=!>!?(B
;;;$(0!@!A!B!C!D!E!F!G!H!I!J!K!L!M!N!O(B
;;;$(0!P!Q!R!S!T!U!V!W!X!Y!Z![!\!]!^!_(B
;;;$(0!`!a!b!c!d!e!f!g!h!i!j!k!l!m!n!o(B
;;;$(0!p!q!r!s!t!u!v!w!x!y!z!{!|!}!~(B
;;;  $(0"!"""#"$"%"&"'"(")"*"+","-"."/(B
;;;$(0"0"1"2"3"4"5"6"7"8"9":";"<"=">"?(B
;;;$(0"@"A"B"C"D"E"F"G"H"I"J"K"L"M"N"O(B
;;;$(0"P"Q"R"S"T"U"V"W"X"Y"Z"["\"]"^"_(B
;;;$(0"`"a"b"c"d"e"f"g"h"i"j"k"l"m"n"o(B
;;;$(0"p"q"r"s"t"u"v"w"x"y"z"{"|"}"~(B
;;;  $(0#!#"###$#%#&#'#(#)#*#+#,#-#.#/(B
;;;$(0#0#1#2#3#4#5#6#7#8#9#:#;#<#=#>#?(B
;;;$(0#@#A#B#C#D#E#F#G#H#I#J#K#L#M#N#O(B
;;;$(0#P#Q#R#S#T#U#V#W#X#Y#Z#[#\#]#^#_(B
;;;$(0#`#a#b#c#d#e#f#g#h#i#j#k#l#m#n#o(B
;;;$(0#p#q#r#s#t#u#v#w#x#y#z#{#|#}#~(B
;;;  $(0$!$"$#$$$%$&$'$($)$*$+$,$-$.$/(B
;;;$(0$0$1$2$3$4$5$6$7$8$9$:$;$<$=$>$?(B
;;;$(0$@$A$B$C$D$E$F$G$H$I$J$K$L$M$N$O(B
;;;$(0$P$Q$R$S$T$U$V$W$X$Y$Z$[$\$]$^$_(B
;;;$(0$`$a$b$c$d$e$f$g$h$i$j$k$l$m$n$o(B
;;;$(0$p$q$r$s$t$u$v$w$x$y$z${$|$}$~(B
;;;  $(0%!%"%#%$%%%&%'%(%)%*%+%,%-%.%/(B
;;;$(0%0%1%2%3%4%5%6%7%8%9%:%;%<%=%>%?(B

(defvar kinsoku-ascii t "Do kinsoku-shori for ASCII.")
(defvar kinsoku-jis nil "Do kinsoku-shori for JISX0208.")
(defvar kinsoku-gb nil "Do kinsoku-shori for GB2312.")
(defvar kinsoku-big5 nil "Do kinsoku-shori for Big5..")

(defvar kinsoku-ascii-bol "!)-_~}]:;',.?" "BOL kinsoku for ASCII.")
(defvar kinsoku-ascii-eol "({[" "EOL kinsoku for ASCII.")
(defvar kinsoku-jis-bol
  (concat  "$B!"!#!$!%!&!'!(!)!*!+!,!-!.!/!0!1!2!3!4!5!6!7!8!9!:!;!<!=!>(B"
	   "$B!?!@!A!B!C!D!E!G!I!K!M!O!Q!S!U!W!Y![!k!l!m!n(B"
	   "$B$!$#$%$'$)$C$c$e$g$n%!%#%%%'%)%C%c%e%g%n%u%v(B")
  "BOL kinsoku for JISX0208.")
(defvar kinsoku-jis-eol
  "$B!F!H!J!L!N!P!R!T!V!X!Z!k!l!m!n!w!x(B"
  "EOL kinsoku for JISX0208.")
(defvar kinsoku-gb-bol
  (concat  "$A!"!##.#,!$!%!&!'!(!)!*!+!,!-!/!1#)!3!5!7!9!;!=(B"
	   "$A!?#;#:#?#!!@!A!B!C!c!d!e!f#/#\#"#_#~#|(e(B")
  "BOL kinsoku for GB2312.")
(defvar kinsoku-gb-eol
  (concat "$A!.!0#"#(!2!4!6!8!:!<!>!c!d!e#@!f!l(B"
	  "$A(E(F(G(H(I(J(K(L(M(N(O(P(Q(R(S(T(U(V(W(X(Y(h(B")
  "EOL kinsoku for GB2312.")
(defvar kinsoku-big5-bol
  (concat  "$(0!"!#!$!%!&!'!(!)!*!+!,!-!.!/!0!1!2(B"
 	   "$(0!3!4!5!6!7!8!9!:!;!<!=!?!A!C!E!G!I!K(B"
 	   "$(0!M!O!Q(B	$(0!S!U!W!Y![!]!_!a!c!e!g!i!k!q(B"
 	   "$(0"#"$"%"&"'"(")"*"+","2"3"4"j"k"l"x%7(B")
  "BOL kinsoku for BIG5.")
(defvar kinsoku-big5-eol
  (concat "$(0!>!@!B!D!F!H!J!L!N!P!R!T!V!X!Z!\!^!`!b(B"
 	  "$(0!d!f!h!j!k!q!p"i"j"k"n"x$u$v$w$x$y$z${(B"
 	  "$(0$|$}$~%!%"%#%$%%%&%'%(%)%*%+%:(B")
  "EOL kinsoku for BIG5.")

(defvar kinsoku-bol-chars 
  (concat
   (if kinsoku-ascii kinsoku-ascii-bol "")
   (if kinsoku-jis kinsoku-jis-bol "")
   (if kinsoku-gb kinsoku-gb-bol "")
   (if kinsoku-big5 kinsoku-big5-bol ""))
  "$B9TF,6XB'$r9T$J$&J8;z$r$9$Y$F4^$`J8;zNs$r;XDj$9$k!#(B
A string consisting of such characters that can't be beginning of line.")

(defvar  kinsoku-eol-chars
  (concat
   (if kinsoku-ascii kinsoku-ascii-eol "")
   (if kinsoku-jis kinsoku-jis-eol "")
   (if kinsoku-gb kinsoku-gb-eol "")
   (if kinsoku-big5 kinsoku-big5-eol ""))
  "$B9TKv6XB'$r9T$J$&J8;z$r$9$Y$F4^$`J8;zNs$r;XDj$9$k!#(B
A string consisting of such characters that can't be end of line.")

;;;
;;; Buffers for kinsoku-shori
;;;
(defconst $kinsoku-buff1$ " "   "$B6XB'=hM}$N$?$a$N(B ASCII $BJ8;zMQ:n6HNN0h(B")
(defconst $kinsoku-buff2$ "  "  "$B6XB'=hM}$N$?$a$N(B 1BYTE $BJ8;zMQ:n6HNN0h(B")
(defconst $kinsoku-buff3$ "   " "$B6XB'=hM}$N$?$a$N(B 2BYTE $BJ8;zMQ:n6HNN0h(B")

(defun kinsoku-buff (ch)
  "Set CHAR to appropriate kinsoku-buffer and return the buffer."
  (let ((bytes (char-bytes ch)))
    (cond ((= bytes 1)
	   (aset $kinsoku-buff1$ 0 ch)
	   (regexp-quote $kinsoku-buff1$))
	  ((= bytes 2)
	   (aset $kinsoku-buff2$ 0 (char-component ch 0))
	   (aset $kinsoku-buff2$ 1 (char-component ch 1))
	   $kinsoku-buff2$)
	  (t
	   (aset $kinsoku-buff3$ 0 (char-component ch 0))
	   (aset $kinsoku-buff3$ 1 (char-component ch 1))
	   (aset $kinsoku-buff3$ 2 (char-component ch 2))
	   $kinsoku-buff3$))))
  

(defun kinsoku-bol-p ()
  "point$B$G2~9T$9$k$H9TF,6XB'$K?($l$k$+$I$&$+$r$+$($9!#(B
$B9TF,6XB'J8;z$O(Bkinsoku-bol-chars$B$G;XDj$9$k!#(B"
  (string-match "" "") ;;;$B$3$l$O(Bregex comp$B$N%j%;%C%H$G$9!#(B
  (string-match (kinsoku-buff (following-char))
		kinsoku-bol-chars))

(defun kinsoku-eol-p ()
  "point$B$G2~9T$9$k$H9TKv6XB'$K?($l$k$+$I$&$+$r$+$($9!#(B
$B9TKv6XB'J8;z$O(Bkinsoku-eol-chars$B$G;XDj$9$k!#(B"
  (string-match "" "") ;;;$B$3$l$O(Bregex comp$B$N%j%;%C%H$G$9!#(B
  (let ((ch (preceding-char)))
    (string-match (kinsoku-buff ch)
		  kinsoku-eol-chars)))

(defvar kinsoku-nobashi-limit nil
  "$B6XB'=hM}$G9T$r?-$P$7$FNI$$H>3QJ8;z?t$r;XDj$9$k!#(B
$BHsIi@0?t0J30$N>l9g$OL58BBg$r0UL#$9$k!#(B")

(defun kinsoku-shori ()
  "$B6XB'$K?($l$J$$E@$X0\F0$9$k!#(B
point$B$,9TF,6XB'$K?($l$k>l9g$O9T$r?-$P$7$F!"6XB'$K?($l$J$$E@$rC5$9!#(B
point$B$,9TKv6XB'$K?($l$k>l9g$O9T$r=L$a$F!"6XB'$K?($l$J$$E@$rC5$9!#(B
$B$?$@$7!"9T?-$P$7H>3QJ8;z?t$,(Bkinsoku-nobashi-limit$B$r1[$($k$H!"(B
$B9T$r=L$a$F6XB'$K?($l$J$$E@$rC5$9!#(B"

  (let ((bol-kin nil) (eol-kin nil))
    (if (and (not (bolp))
	     (not (eolp))
	     (or (setq bol-kin (kinsoku-bol-p))
		 (setq eol-kin (kinsoku-eol-p))))
	(cond(bol-kin (kinsoku-shori-nobashi))
	     (eol-kin (kinsoku-shori-chizime))))))

(defun kinsoku-shori-nobashi ()
  "$B9T$r?-$P$7$F6XB'$K?($l$J$$E@$X0\F0$9$k!#(B"
  (let ((max-column (+ fill-column 
		       (if (and (numberp kinsoku-nobashi-limit)
				(>= kinsoku-nobashi-limit 0))
			   kinsoku-nobashi-limit
			 10000)))  ;;; 10000$B$OL58BBg$N$D$b$j$G$9!#(B
	ch1 ch2)			; 92.5.2 by K.Handa
    (while (and (<= (+ (current-column)
		       (char-width (setq ch1 (following-char))))
		    max-column)
		(not (bolp))
		(not (eolp))
		(or (kinsoku-eol-p)
		    (kinsoku-bol-p)
	            ;;; English word $B$NESCf$G$OJ,3d$7$J$$!#(B
		    (and (< ch1 127)	; 92.5.2 by K.Handa
			 (< (setq ch2 (preceding-char)) 127)
			 (= ?w (char-syntax ch2))
			 (= ?w (char-syntax ch1)))))
      (forward-char))
    (if (or (kinsoku-eol-p) (kinsoku-bol-p))
	(kinsoku-shori-chizime))))

(defun kinsoku-shori-chizime ()
  "$B9T$r=L$a$F6XB'$K?($l$J$$E@$X0\F0$9$k!#(B"
			; 92.5.2 by K.Handa
  ;;; 93.8.23  by kawamoto@ics.es.osaka-u.ac.jp 
  (let ((p (point)) ch1 ch2)
    (while (and (not (bolp))
		(not (eolp))
		(or (kinsoku-bol-p)
		    (kinsoku-eol-p)
		;;; English word $B$NESCf$G$OJ,3d$7$J$$!#(B
		    (and		; 92.5.2 by K.Handa
		     (< (setq ch1 (following-char)) 127)
		     (< (setq ch2 (preceding-char)) 127)
		     (= ?w (char-syntax ch2))
		     (= ?w (char-syntax ch1)))))
      (backward-char))
    ;;; 93.8.23  by kawamoto@ics.es.osaka-u.ac.jp 
    (if (bolp) (goto-char p))))


