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
;;	Original table is from cxterm/dict/tit/QJ.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	NO
;; PROMPT:	汉字输入∷全角∷ 
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
 "qj" "全角" nil
 "汉字输入∷全角∷ 

 Copyright 1991 by Yongguang Zhang.      (ygz@cs.purdue.edu)
 Permission to use/modify/copy for any purpose is hereby granted.
 Absolutely no warranties."
 *quail-mode-default-map* t t nil nil t)

(quail-defrule "\C-@" ?　)
(quail-defrule "!" ?！)
(quail-defrule "\"" ?＂)
(quail-defrule "#" ?＃)
(quail-defrule "$" ?￥)
(quail-defrule "%" ?％)
(quail-defrule "&" ?＆)
(quail-defrule "'" ?＇)
(quail-defrule "(" ?（)
(quail-defrule ")" ?）)
(quail-defrule "*" ?＊)
(quail-defrule "+" ?＋)
(quail-defrule "," ?，)
(quail-defrule "-" ?－)
(quail-defrule "." ?．)
(quail-defrule "/" ?／)
(quail-defrule "0" ?０)
(quail-defrule "1" ?１)
(quail-defrule "2" ?２)
(quail-defrule "3" ?３)
(quail-defrule "4" ?４)
(quail-defrule "5" ?５)
(quail-defrule "6" ?６)
(quail-defrule "7" ?７)
(quail-defrule "8" ?８)
(quail-defrule "9" ?９)
(quail-defrule ":" ?：)
(quail-defrule ";" ?；)
(quail-defrule "<" ?＜)
(quail-defrule "=" ?＝)
(quail-defrule ">" ?＞)
(quail-defrule "?" ?？)
(quail-defrule "@" ?＠)
(quail-defrule "A" ?Ａ)
(quail-defrule "B" ?Ｂ)
(quail-defrule "C" ?Ｃ)
(quail-defrule "D" ?Ｄ)
(quail-defrule "E" ?Ｅ)
(quail-defrule "F" ?Ｆ)
(quail-defrule "G" ?Ｇ)
(quail-defrule "H" ?Ｈ)
(quail-defrule "I" ?Ｉ)
(quail-defrule "J" ?Ｊ)
(quail-defrule "K" ?Ｋ)
(quail-defrule "L" ?Ｌ)
(quail-defrule "M" ?Ｍ)
(quail-defrule "N" ?Ｎ)
(quail-defrule "O" ?Ｏ)
(quail-defrule "P" ?Ｐ)
(quail-defrule "Q" ?Ｑ)
(quail-defrule "R" ?Ｒ)
(quail-defrule "S" ?Ｓ)
(quail-defrule "T" ?Ｔ)
(quail-defrule "U" ?Ｕ)
(quail-defrule "V" ?Ｖ)
(quail-defrule "W" ?Ｗ)
(quail-defrule "X" ?Ｘ)
(quail-defrule "Y" ?Ｙ)
(quail-defrule "Z" ?Ｚ)
(quail-defrule "[" ?［)
(quail-defrule "\\" ?＼)
(quail-defrule "]" ?］)
(quail-defrule "^" ?＾)
(quail-defrule "_" ?＿)
(quail-defrule "`" ?｀)
(quail-defrule "a" ?ａ)
(quail-defrule "b" ?ｂ)
(quail-defrule "c" ?ｃ)
(quail-defrule "d" ?ｄ)
(quail-defrule "e" ?ｅ)
(quail-defrule "f" ?ｆ)
(quail-defrule "g" ?ｇ)
(quail-defrule "h" ?ｈ)
(quail-defrule "i" ?ｉ)
(quail-defrule "j" ?ｊ)
(quail-defrule "k" ?ｋ)
(quail-defrule "l" ?ｌ)
(quail-defrule "m" ?ｍ)
(quail-defrule "n" ?ｎ)
(quail-defrule "o" ?ｏ)
(quail-defrule "p" ?ｐ)
(quail-defrule "q" ?ｑ)
(quail-defrule "r" ?ｒ)
(quail-defrule "s" ?ｓ)
(quail-defrule "t" ?ｔ)
(quail-defrule "u" ?ｕ)
(quail-defrule "v" ?ｖ)
(quail-defrule "w" ?ｗ)
(quail-defrule "x" ?ｘ)
(quail-defrule "y" ?ｙ)
(quail-defrule "z" ?ｚ)
(quail-defrule "{" ?｛)
(quail-defrule "|" ?｜)
(quail-defrule "}" ?｝)
(quail-defrule "~" ?￣)
