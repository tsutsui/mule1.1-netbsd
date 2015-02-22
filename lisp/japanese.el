;; Japanse specific setup for Mule
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

;;; 92.7.8   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	bushu-input and kakusuu-input are declared as autoload function.
;;; 92.7.15  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	A variable japanese-word-regexp introduced.
;;; 92.7.31  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	If using CANNA, canna.el[c] is loaded.
;;; 92.10.19 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	Set display-coding-system and keyboard-coding-system to *junet*.
;;; 92.10.22 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	japanese-word-regexp is not used.
;;; 92.12.16 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	Setting term-setup-hook is done in mule-init.el now.
;;; 93.1.3   modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Bug in setting *euc-code-category* fixed.
;;; 93.5.4   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Set kinsoku-jis t.
;;; 93.6.27  modified for Mule Ver.0.9.8 by N.Kamei <zic@tci.toshiba.co.jp>
;;;	Define sentence/paragraph.
;;; 93.7.14  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	New way for handling word-definition.
;;; 93.7.22  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;; 93.8.3   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Category of lc-jp2 is set to "C".
;;; 94.2.8   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>

(provide 'japanese)			;93.7.22 by K.Handa

(setq *coding-category-iso-8-2* *euc-japan*)

(set-coding-priority
 '(*coding-category-iso-8-2*
   *coding-category-sjis*
   *coding-category-iso-8-1*
   *coding-category-big5*))

(set-keyboard-coding-system *junet*)
(set-display-coding-system *junet*)

(set-default-file-coding-system *junet*)

;; Character category S, A, H, K, G, Y, and C
(define-category ?S (make-character lc-jp 161)
  "Japanese 2-byte symbol character.")
(modify-category-entry (make-character lc-jp 162) ?S)
(modify-category-entry (make-character lc-jp 168) ?S)
(define-category ?A  (make-character lc-jp 163)
  "Japanese 2-byte Alpha numeric character.")
(define-category ?H (make-character lc-jp 164)
  "Japanese 2-byte Hiragana character.")
(define-category ?K (make-character lc-jp 165)
  "Japanese 2-byte Katakana character.")
(define-category ?G (make-character lc-jp 166)
  "Japanese 2-byte Greek character.")
(define-category ?Y (make-character lc-jp 167)
  "Japanese 2-byte Cyrillic character.")
(define-category ?C (make-character lc-jp 176)
  "Japanese 2-byte Kanji characters.")
(let ((c 177))
  (while (< c 256)
    (modify-category-entry (make-character lc-jp c) ?C)
    (setq c (1+ c))))
(let ((chars '(?ー ?゛ ?゜)))
  (while chars
    (modify-category-entry (car chars) ?K)
    (modify-category-entry (car chars) ?H)
    (setq chars (cdr chars))))
(let ((chars '(?ヽ ?ヾ ?ゝ ?ゞ ?〃 ?仝 ?々 ?〆 ?〇)))
  (while chars
    (modify-category-entry (car chars) ?C)
    (setq chars (cdr chars))))
(modify-category-entry (make-character lc-jp2) ?C) ; 93.8.3 by K.Handa

;; EGG specific setup
(if (boundp 'EGG)
    (progn
      (setq wnn-server-type 'jserver)
      (load "its/hira")
      (load "its/kata")
      (load "its/hankaku")
      (load "its/zenkaku")
      (setq its:*standard-modes*
	    (append
	     (list (its:get-mode-map "roma-kana")
		   (its:get-mode-map "roma-kata")
		   (its:get-mode-map "downcase")
		   (its:get-mode-map "upcase")
		   (its:get-mode-map "zenkaku-downcase")
		   (its:get-mode-map "zenkaku-upcase"))
	     its:*standard-modes*))
      (setq-default its:*current-map* (its:get-mode-map "roma-kana"))
      )
  (if (boundp 'CANNA)			; 92.7.31 by K.Handa
      (load "canna")))

;; 93.7.14 by K.Handa
(load "worddef.elc")			; We need byte-compiled file.
(set-word-regexp japanese-word-regexp)
(setq forward-word-regexp "\\w\\>")
(setq backward-word-regexp "\\<\\w")

(setq kinsoku-jis t)

;; Paragraph setting
;; 93.6.27 by N.Kamei
(setq sentence-end
      (concat 
       "\\("
           "\\("
	       "[.?!][]\"')}]*"
	   "\\|"
	       "[．？！][］”’）｝〕〉》」』]*"
	   "\\)"
	   "\\($\\|\t\\|  \\)"
       "\\|"
	   "。"
       "\\)"
       "[ \t\n]*"))
(setq paragraph-start "^[ 　\t\n\f]")
(setq paragraph-separate "^[ 　\t\f]*$")
