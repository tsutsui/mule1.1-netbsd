;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).
;; This file contains Chinese characters.

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

;; 92.3.6   Written for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;	Original table is from cxterm/dict/tit/Punct-b5.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	BIG5
;; MULTICHOICE:	YES
;; PROMPT:	$(0KH)tTT&,(B::$(0O:X5>KHA(B::
;; #
;; COMMENT Copyright 1991 by Yongguang Zhang.	(ygz@cs.purdue.edu)
;; COMMENT Permission to use/modify/copy for any purpose is hereby granted.
;; COMMENT Absolutely no fee and no warranties.
;; COMMENT
;; COMMENT use <CTRL-f> to move to the right
;; COMMENT use <CTRL-b> to move to the left
;; # define keys
;; VALIDINPUTKEY:	!"\043$%&'()*+,-./0123456789:;<=>?@[\134]^_`abcdefghijkl
;; VALIDINPUTKEY:	mnopqrstuvwxyz{|}~
;; SELECTKEY:	1\040
;; SELECTKEY:	2
;; SELECTKEY:	3
;; SELECTKEY:	4
;; SELECTKEY:	5
;; SELECTKEY:	6
;; SELECTKEY:	7
;; SELECTKEY:	8
;; SELECTKEY:	9
;; SELECTKEY:	0
;; BACKSPACE:	\010\177
;; DELETEALL:	\015\025
;; MOVERIGHT:	\006
;; MOVELEFT:	\002
;; REPEATKEY:	\020\022
;; # the following line must not be removed
;; BEGINDICTIONARY
;; #

(require 'quail)

(quail-define-package
 "punct-b5" "$(0O:X5>KHA(B" nil 
 "$(0KH)tTT&,(B::$(0O:X5>KHA(B::

 Copyright 1991 by Yongguang Zhang.	(ygz@cs.purdue.edu)
 Permission to use/modify/copy for any purpose is hereby granted.
 Absolutely no fee and no warranties."
 *quail-mode-rich-map* nil nil nil nil t)

(quail-defrule "!"
	       '(?$(0!*(B ?$(0!5(B))
(quail-defrule "\""
	       '(?$(0!f(B ?$(0!g(B ?$(0!h(B ?$(0!i(B ?$(0!q(B))
(quail-defrule "#"
	       '(?$(0!l(B ?$(0"-(B))
(quail-defrule "$"
	       '(?$(0"d(B ?$(0"l(B ?$(0"f(B ?$(0"g(B))
(quail-defrule "%"
	       '(?$(0"h(B))
(quail-defrule "&"
	       '(?$(0".(B ?$(0!m(B))
(quail-defrule "'"
	       '(?$(0!d(B ?$(0!e(B ?$(0!j(B ?$(0!k(B))
(quail-defrule "("
	       '(?$(0!>(B ?$(0!F(B ?$(0!^(B ?$(0!@(B ?$(0!H(B ?$(0!V(B ?$(0!Z(B ?$(0!Y(B ?$(0!](B))
(quail-defrule ")"
	       '(?$(0!?(B ?$(0!G(B ?$(0!_(B ?$(0!A(B ?$(0!I(B ?$(0!W(B ?$(0![(B ?$(0!X(B ?$(0!\(B))
(quail-defrule "*"
	       '(?$(0"/(B ?$(0"2(B ?$(0$T(B ?$(0$O(B ?$(0"E(B))
(quail-defrule "+"
	       '(?$(0"0(B ?$(0"?(B ?$(0"4(B ?$(0$V(B ?$(0!U(B ?$(0"F(B))
(quail-defrule ","
	       '(?$(0!"(B ?$(0!.(B ?$(0!#(B ?$(0!/(B))
(quail-defrule "-"
	       '(?$(0"1(B ?$(0"@(B ?$(0"@(B ?$(0!7(B ?$(0"#(B ?$(0#9(B ?$(0"D(B))
(quail-defrule "."
	       '(?$(0!$(B ?$(0!%(B ?$(0!&(B ?$(0!0(B ?$(0!1(B ?$(0!,(B ?$(0!-(B ?$(0"O(B ?$(0"P(B ?$(0"x(B
		 ?$(0"T(B))
(quail-defrule "/"
	       '(?$(0"_(B ?$(0"a(B ?$(0"3(B ?$(0"5(B ?$(0"`(B ?$(0"b(B))
(quail-defrule "0"
	       '(?$(0#O(B ?$(0%M(B ?$(0%W(B ?$(0%a(B ?$(0#b(B ?$(0#l(B))
(quail-defrule "1"
	       '(?$(0#P(B ?$(0%D(B ?$(0%N(B ?$(0%X(B ?$(0#Y(B ?$(0#c(B ?$(0#m(B))
(quail-defrule "2"
	       '(?$(0#Q(B ?$(0%E(B ?$(0%O(B ?$(0%Y(B ?$(0#Z(B ?$(0#d(B ?$(0#n(B))
(quail-defrule "3"
	       '(?$(0#R(B ?$(0%F(B ?$(0%P(B ?$(0%Z(B ?$(0#[(B ?$(0#e(B))
(quail-defrule "4"
	       '(?$(0#S(B ?$(0%G(B ?$(0%Q(B ?$(0%[(B ?$(0#\(B ?$(0#f(B))
(quail-defrule "5"
	       '(?$(0#T(B ?$(0%H(B ?$(0%R(B ?$(0%\(B ?$(0#](B ?$(0#g(B))
(quail-defrule "6"
	       '(?$(0#U(B ?$(0%I(B ?$(0%S(B ?$(0%](B ?$(0#^(B ?$(0#h(B))
(quail-defrule "7"
	       '(?$(0#V(B ?$(0%J(B ?$(0%T(B ?$(0%^(B ?$(0#_(B ?$(0#i(B))
(quail-defrule "8"
	       '(?$(0#W(B ?$(0%K(B ?$(0%U(B ?$(0%_(B ?$(0#`(B ?$(0#j(B))
(quail-defrule "9"
	       '(?$(0#X(B ?$(0%L(B ?$(0%V(B ?$(0%`(B ?$(0#a(B ?$(0#k(B))
(quail-defrule ":"
	       '(?$(0!((B ?$(0!+(B ?$(0!3(B))
(quail-defrule ";"
	       '(?$(0!'(B ?$(0!2(B))
(quail-defrule "<"
	       '(?$(0!R(B ?$(0"A(B ?$(0!N(B ?$(0!P(B ?$(0!T(B ?$(0"9(B))
(quail-defrule "="
	       '(?$(0"8(B ?$(0"C(B ?$(0";(B ?$(0"=(B ?$(0">(B))
(quail-defrule ">"
	       '(?$(0!S(B ?$(0"B(B ?$(0!O(B ?$(0!Q(B ?$(0!U(B ?$(0":(B))
(quail-defrule "?"
	       '(?$(0!)(B ?$(0!4(B))
(quail-defrule "@"
	       '(?$(0"i(B ?$(0"T(B))
(quail-defrule "["
	       '(?$(0!b(B ?$(0!J(B ?$(0!L(B))
(quail-defrule "\\"
	       '(?$(0"`(B ?$(0"b(B ?$(0"_(B ?$(0"a(B))
(quail-defrule "]"
	       '(?$(0!c(B ?$(0!K(B ?$(0!M(B))
(quail-defrule "^"
	       '(?$(0!T(B))
(quail-defrule "_"
	       '(?$(0!;(B ?$(0!=(B))
(quail-defrule "`"
	       '(?$(0!d(B ?$(0!e(B ?$(0!j(B ?$(0!k(B))
(quail-defrule "graph"
	       '(?$(0#$(B ?$(0#%(B ?$(0#&(B ?$(0#'(B ?$(0#((B ?$(0#)(B ?$(0#*(B ?$(0#+(B ?$(0#,(B ?$(0#-(B
		 ?$(0#.(B ?$(0#/(B ?$(0#0(B ?$(0#1(B ?$(0#2(B ?$(0#3(B ?$(0#4(B ?$(0#5(B ?$(0#6(B ?$(0#7(B
		 ?$(0#8(B ?$(0#9(B ?$(0#:(B ?$(0#;(B ?$(0#<(B ?$(0#=(B ?$(0#>(B ?$(0#?(B ?$(0#@(B ?$(0#A(B
		 ?$(0#B(B ?$(0#C(B ?$(0#D(B ?$(0#E(B ?$(0#F(B ?$(0#G(B ?$(0#H(B ?$(0#I(B ?$(0#J(B ?$(0#K(B
		 ?$(0#L(B ?$(0#M(B ?$(0#N(B))
(quail-defrule "logo"
	       '(?$(0!n(B ?$(0!o(B ?$(0!p(B ?$(0!q(B ?$(0!r(B ?$(0!s(B ?$(0!t(B ?$(0!u(B ?$(0!v(B ?$(0!w(B
		 ?$(0!x(B ?$(0!y(B ?$(0!z(B ?$(0!{(B ?$(0!|(B ?$(0!}(B ?$(0!~(B ?$(0"!(B ?$(0""(B ?$(0"#(B
		 ?$(0"$(B ?$(0"%(B ?$(0"&(B ?$(0"'(B ?$(0"((B ?$(0")(B ?$(0"*(B ?$(0"+(B ?$(0",(B))
(quail-defrule "math"
	       '(?$(0"0(B ?$(0"1(B ?$(0"2(B ?$(0"3(B ?$(0"4(B ?$(0"5(B ?$(0"6(B ?$(0"7(B ?$(0"8(B ?$(0"9(B
		 ?$(0":(B ?$(0";(B ?$(0"<(B ?$(0"=(B ?$(0">(B ?$(0"?(B ?$(0"@(B ?$(0"A(B ?$(0"B(B ?$(0"C(B
		 ?$(0"D(B ?$(0"E(B ?$(0"F(B ?$(0"G(B ?$(0"H(B ?$(0"I(B ?$(0"J(B ?$(0"K(B ?$(0"L(B ?$(0"M(B
		 ?$(0"N(B ?$(0"O(B ?$(0"P(B))
(quail-defrule "symbol"
	       '(?$(0"R(B ?$(0"Q(B ?$(0"S(B ?$(0"T(B ?$(0"U(B ?$(0"V(B ?$(0"W(B ?$(0"X(B ?$(0"Y(B ?$(0"Z(B
		 ?$(0"[(B ?$(0"\(B ?$(0"](B ?$(0"^(B ?$(0"_(B ?$(0"`(B ?$(0"a(B ?$(0"b(B))
(quail-defrule "unit"
	       '(?$(0"c(B ?$(0"d(B ?$(0"e(B ?$(0"f(B ?$(0"g(B ?$(0"h(B ?$(0"h(B ?$(0"i(B ?$(0"p(B ?$(0"q(B
		 ?$(0"r(B ?$(0"s(B ?$(0"t(B ?$(0"u(B ?$(0"v(B ?$(0"w(B ?$(0"x(B ?$(0"y(B ?$(0"z(B ?$(0"{(B
		 ?$(0"|(B ?$(0"}(B ?$(0"~(B ?$(0#!(B ?$(0#"(B ?$(0##(B))
(quail-defrule "{"
	       '(?$(0!`(B ?$(0!B(B ?$(0!D(B))
(quail-defrule "|"
	       '(?$(0!6(B ?$(0"^(B ?$(0!:(B ?$(0#:(B ?$(0"](B))
(quail-defrule "}"
	       '(?$(0!a(B ?$(0!C(B ?$(0!E(B))
(quail-defrule "~"
	       '(?$(0!=(B ?$(0"D(B ?$(0"<(B))
