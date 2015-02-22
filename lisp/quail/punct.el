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
;;	Original table is from cxterm/dict/tit/Punct.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	YES
;; PROMPT:	汉字输入∷标点符号∷ 
;; #
;; COMMENT	Copyright 1991 by Yongguang Zhang.
;; COMMENT Permission to use/modify/copy for any purpose is hereby granted.
;; COMMENT Absolutely no fee and no warranties.
;; COMMENT
;; COMMENT	use <CTRL-f> to move to the right
;; COMMENT	use <CTRL-b> to move to the left
;; # define keys
;; VALIDINPUTKEY:	"\043$%&'()*+,-./0123456789:;<=>?@[\134]^_`abcdefghijklm
;; VALIDINPUTKEY:	nopqrstuvwxyz|~
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
 "punct" "标点符号" nil
 "汉字输入∷标点符号∷ 

	Copyright 1991 by Yongguang Zhang.
 Permission to use/modify/copy for any purpose is hereby granted.
 Absolutely no fee and no warranties."
 *quail-mode-rich-map* nil nil nil nil t)

(quail-defrule "\""
	       '(?＂ ?“ ?” ?″))
(quail-defrule "#"
	       '(?＃))
(quail-defrule "$"
	       '(?￥ ?＄ ?￠ ?￡))
(quail-defrule "%"
	       '(?％ ?‰))
(quail-defrule "'"
	       '(?＇ ?‘ ?’ ?′))
(quail-defrule "("
	       '(?（ ?「 ?『))
(quail-defrule ")"
	       '(?） ?」 ?』))
(quail-defrule "*"
	       '(?＊ ?× ?∏ ?∧ ?∩))
(quail-defrule "+"
	       '(?＋ ?± ?∑ ?∨ ?∪))
(quail-defrule ","
	       '(?， ?、))
(quail-defrule "-"
	       '(?－ ?ˉ ?― ?～))
(quail-defrule "."
	       '(?． ?。 ?・ ?¨ ?… ?∵ ?∴ ?° ?⊙))
(quail-defrule "/"
	       '(?／ ?÷ ?√ ?＼))
(quail-defrule "0"
	       '(?０ ?⒑ ?⒛ ?⑽ ?⒇ ?⑩ ?㈩ ?Ⅹ))
(quail-defrule "1"
	       '(?１ ?⒈ ?⒒ ?⑴ ?⑾ ?① ?㈠ ?Ⅰ))
(quail-defrule "2"
	       '(?２ ?⒉ ?⒓ ?⑵ ?⑿ ?② ?㈡ ?Ⅱ))
(quail-defrule "3"
	       '(?３ ?⒊ ?⒔ ?⑶ ?⒀ ?③ ?㈢ ?Ⅲ))
(quail-defrule "4"
	       '(?４ ?⒋ ?⒕ ?⑷ ?⒁ ?④ ?㈣ ?Ⅳ))
(quail-defrule "5"
	       '(?５ ?⒌ ?⒖ ?⑸ ?⒂ ?⑤ ?㈤ ?Ⅴ))
(quail-defrule "6"
	       '(?６ ?⒍ ?⒗ ?⑹ ?⒃ ?⑥ ?㈥ ?Ⅵ))
(quail-defrule "7"
	       '(?７ ?⒎ ?⒘ ?⑺ ?⒄ ?⑦ ?㈦ ?Ⅶ))
(quail-defrule "8"
	       '(?８ ?⒏ ?⒙ ?⑻ ?⒅ ?⑧ ?㈧ ?Ⅷ))
(quail-defrule "9"
	       '(?９ ?⒐ ?⒚ ?⑼ ?⒆ ?⑨ ?㈨ ?Ⅸ))
(quail-defrule ":"
	       '(?： ?∷))
(quail-defrule "<"
	       '(?＜ ?〈 ?《 ?≮ ?≤))
(quail-defrule "="
	       '(?＝ ?≠ ?≈ ?≡ ?≌))
(quail-defrule ">"
	       '(?＞ ?〉 ?》 ?≯ ?≥))
(quail-defrule "@"
	       '(?＠ ?⊙))
(quail-defrule "["
	       '(?［ ?〔 ?〖 ?【 ?｛))
(quail-defrule "\\"
	       '(?＼ ?／))
(quail-defrule "]"
	       '(?］ ?〕 ?〗 ?】 ?｝))
(quail-defrule "^"
	       '(?＾ ?ˇ ?⌒))
(quail-defrule "_"
	       '(?＿ ?⊥))
(quail-defrule "`"
	       '(?｀ ?‘ ?’))
(quail-defrule "logo"
	       '(?☆ ?★ ?○ ?● ?◎ ?◇ ?◆ ?□ ?■ ?△
		 ?▲ ?※ ?→ ?← ?↑ ?↓ ?〓))
(quail-defrule "math"
	       '(?± ?× ?÷ ?∶ ?∧ ?∨ ?∑ ?∏ ?∪ ?∩
		 ?∈ ?∷ ?√ ?⊥ ?∥ ?∠ ?⌒ ?⊙ ?∫ ?∮
		 ?≡ ?≌ ?≈ ?∽ ?∝ ?≠ ?≮ ?≯ ?≤ ?≥
		 ?∞ ?∵ ?∴))
(quail-defrule "punct"
	       '(?　 ?、 ?。 ?・ ?ˉ ?ˇ ?¨ ?〃 ?々 ?―
		 ?～ ?‖ ?… ?‘ ?’ ?“ ?” ?〔 ?〕 ?〈
		 ?〉 ?《 ?》 ?「 ?」 ?『 ?』 ?〖 ?〗 ?【
		 ?】))
(quail-defrule "symbol"
	       '(?♂ ?♀ ?° ?′ ?″ ?℃ ?＄ ?¤ ?￠ ?￡
		 ?‰ ?§ ?№))
(quail-defrule "|"
	       '(?｜ ?‖ ?∥))
(quail-defrule "~"
	       '(?￣ ?～ ?∽ ?∝ ?∞))
