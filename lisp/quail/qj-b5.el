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
;;	Original table is from cxterm/dict/tit/QJ-b5.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	BIG5
;; MULTICHOICE:	NO
;; PROMPT:	$(0KH)tTT&,(B::$(0)A-F(B::
;; #
;; COMMENT Copyright 1991 by Yongguang Zhang.      (ygz@cs.purdue.edu)
;; COMMENT Permission to use/modify/copy for any purpose is hereby granted.
;; COMMENT Absolutely no warranties.
;; # define keys
;; VALIDINPUTKEY:	\040!"\043$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMN
;; VALIDINPUTKEY:	OPQRSTUVWXYZ[\134]^_`abcdefghijklmnopqrstuvwxyz{|}~
;; # the following line must not be removed
;; BEGINDICTIONARY
;; #

(require 'quail)

(quail-define-package
 "qj-b5" "$(0)A-F(B" nil
 "$(0KH)tTT&,(B::$(0)A-F(B::

 Copyright 1991 by Yongguang Zhang.      (ygz@cs.purdue.edu)
 Permission to use/modify/copy for any purpose is hereby granted.
 Absolutely no warranties."
 *quail-mode-default-map* t t nil nil t)

(quail-defrule "\C-@" ?$(0!!(B)
(quail-defrule "!" ?$(0!*(B)
(quail-defrule "\"" ?$(0!q(B)
(quail-defrule "#" ?$(0!l(B)
(quail-defrule "$" ?$(0"l(B)
(quail-defrule "%" ?$(0"h(B)
(quail-defrule "&" ?$(0!m(B)
(quail-defrule "'" ?$(0!k(B)
(quail-defrule "(" ?$(0!>(B)
(quail-defrule ")" ?$(0!?(B)
(quail-defrule "*" ?$(0"/(B)
(quail-defrule "+" ?$(0"0(B)
(quail-defrule "," ?$(0!"(B)
(quail-defrule "-" ?$(0"1(B)
(quail-defrule "." ?$(0!%(B)
(quail-defrule "/" ?$(0"_(B)
(quail-defrule "0" ?$(0#O(B)
(quail-defrule "1" ?$(0#P(B)
(quail-defrule "2" ?$(0#Q(B)
(quail-defrule "3" ?$(0#R(B)
(quail-defrule "4" ?$(0#S(B)
(quail-defrule "5" ?$(0#T(B)
(quail-defrule "6" ?$(0#U(B)
(quail-defrule "7" ?$(0#V(B)
(quail-defrule "8" ?$(0#W(B)
(quail-defrule "9" ?$(0#X(B)
(quail-defrule ":" ?$(0!((B)
(quail-defrule ";" ?$(0!'(B)
(quail-defrule "<" ?$(0!R(B)
(quail-defrule "=" ?$(0"8(B)
(quail-defrule ">" ?$(0!S(B)
(quail-defrule "?" ?$(0!)(B)
(quail-defrule "@" ?$(0"i(B)
(quail-defrule "A" ?$(0#o(B)
(quail-defrule "B" ?$(0#p(B)
(quail-defrule "C" ?$(0#q(B)
(quail-defrule "D" ?$(0#r(B)
(quail-defrule "E" ?$(0#s(B)
(quail-defrule "F" ?$(0#t(B)
(quail-defrule "G" ?$(0#u(B)
(quail-defrule "H" ?$(0#v(B)
(quail-defrule "I" ?$(0#w(B)
(quail-defrule "J" ?$(0#x(B)
(quail-defrule "K" ?$(0#y(B)
(quail-defrule "L" ?$(0#z(B)
(quail-defrule "M" ?$(0#{(B)
(quail-defrule "N" ?$(0#|(B)
(quail-defrule "O" ?$(0#}(B)
(quail-defrule "P" ?$(0#~(B)
(quail-defrule "Q" ?$(0$!(B)
(quail-defrule "R" ?$(0$"(B)
(quail-defrule "S" ?$(0$#(B)
(quail-defrule "T" ?$(0$$(B)
(quail-defrule "U" ?$(0$%(B)
(quail-defrule "V" ?$(0$&(B)
(quail-defrule "W" ?$(0$'(B)
(quail-defrule "X" ?$(0$((B)
(quail-defrule "Y" ?$(0$)(B)
(quail-defrule "Z" ?$(0$*(B)
(quail-defrule "[" ?$(0!J(B)
(quail-defrule "\\" ?$(0"`(B)
(quail-defrule "]" ?$(0!K(B)
(quail-defrule "^" ?$(0!T(B)
(quail-defrule "_" ?$(0!;(B)
(quail-defrule "`" ?$(0!j(B)
(quail-defrule "a" ?$(0$+(B)
(quail-defrule "b" ?$(0$,(B)
(quail-defrule "c" ?$(0$-(B)
(quail-defrule "d" ?$(0$.(B)
(quail-defrule "e" ?$(0$/(B)
(quail-defrule "f" ?$(0$0(B)
(quail-defrule "g" ?$(0$1(B)
(quail-defrule "h" ?$(0$2(B)
(quail-defrule "i" ?$(0$3(B)
(quail-defrule "j" ?$(0$4(B)
(quail-defrule "k" ?$(0$5(B)
(quail-defrule "l" ?$(0$6(B)
(quail-defrule "m" ?$(0$7(B)
(quail-defrule "n" ?$(0$8(B)
(quail-defrule "o" ?$(0$9(B)
(quail-defrule "p" ?$(0$:(B)
(quail-defrule "q" ?$(0$;(B)
(quail-defrule "r" ?$(0$<(B)
(quail-defrule "s" ?$(0$=(B)
(quail-defrule "t" ?$(0$>(B)
(quail-defrule "u" ?$(0$?(B)
(quail-defrule "v" ?$(0$@(B)
(quail-defrule "w" ?$(0$A(B)
(quail-defrule "x" ?$(0$B(B)
(quail-defrule "y" ?$(0$C(B)
(quail-defrule "z" ?$(0$D(B)
(quail-defrule "{" ?$(0!B(B)
(quail-defrule "|" ?$(0!6(B)
(quail-defrule "}" ?$(0!C(B)
(quail-defrule "~" ?$(0"D(B)
