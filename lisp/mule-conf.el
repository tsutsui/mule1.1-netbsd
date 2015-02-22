;; Mule configuration file
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

;;; 92.5.1   created for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;; 92.5.18  modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;;	Character syntaxs are defined for Latin-1 characters.
;;; 92.7.16  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Syntax of Japanese characters is Sextword.
;;; 93.4.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	New character set lc-ascr2l is introduced.
;;; 93.5.24  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Change syntax from "_" (part of symbol) to "." (punctuation).
;;;	Vietnamese support.
;;; 93.7.16  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Set syntax 'word' for JISX0201 (lc-kana).
;;; 93.7.26  modified for Mule Ver.0.9.8 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	Add syntax for Japanese parenthesis.
;;; 93.7.29  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Renamed to mule-conf.el.
;;; 93.8.3   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Syntax setting for lc-kana ('w') and lc-jp2 ('e').
;;; 94.1.18  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Modified for Laint-7 (Greek).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EDIT THIS FILE FOR YOUR OWN CONFIGURATION.
;; PLEASE NOTE THAT MOST OF CONFIGURATION CAN BE DONE IN mule-init.el,
;; OR IN SUCH LANGUAGE SPECIFIC FILES AS japanese.el, chinese.el, etc.
;; THIS FILE IS FOR SUCH CODE THAT SHOULD BE LOADED JUST AFTER mule.el.
;; FOR THE MOMENT, I THINK, ONLY THE FOLLOWING CODES SHOULD BE HERE:
;;   - MODIFICATION OF standard-syntax-table
;;   - REGISTRATION OF PRIVATE CHARACTER SETS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; MODIFICATION OF standard-syntax-table.

(let (c)
  ;; For syntax of Japanese characters.
  (setq c 161)
  (while (< c 256)
    (modify-syntax-entry (make-character lc-jp 161 c) ".")
    (setq c (1+ c)))
  (let ((chars '(?ー ?゛ ?゜ ?ヽ ?ヾ ?ゝ ?ゞ ?〃 ?仝 ?々 ?〆 ?〇)))
    (while chars
      (modify-syntax-entry (car chars) "e")
      (setq chars (cdr chars))))
  (modify-syntax-entry (make-character lc-jp 162) ".")
  (setq c 163)
  (while (< c 168)
    (modify-syntax-entry (make-character lc-jp c) "e")
    (setq c (1+ c)))
  (modify-syntax-entry (make-character lc-jp c) ".")
  (setq c 176)
  (while (< c 256)
    (modify-syntax-entry (make-character lc-jp c) "e")
    (setq c (1+ c)))
  ;; 93.7.26 by T.Enami
  (modify-syntax-entry ?（ "(）")
  (modify-syntax-entry ?［ "(］")
  (modify-syntax-entry ?｛ "(｝")
  (modify-syntax-entry ?「 "(」")
  (modify-syntax-entry ?『 "(』")
  (modify-syntax-entry ?） ")（")
  (modify-syntax-entry ?］ ")［")
  (modify-syntax-entry ?｝ ")｛")
  (modify-syntax-entry ?」 ")「")
  (modify-syntax-entry ?』 ")『")

  (modify-syntax-entry lc-kana "w")	;93.8.3 by K.Handa

  (modify-syntax-entry lc-jp2 "e")	;93.8.3 by K.Handa

  ;; For syntax of Korean characters.
  (setq c 161)
  (while (< c 163)
    (modify-syntax-entry (make-character lc-kr c) ".")
    (setq c (1+ c)))
  (while (< c 166)
    (modify-syntax-entry (make-character lc-kr c) "w")
    (setq c (1+ c)))
  (while (< c 170)
    (modify-syntax-entry (make-character lc-kr c) ".")
    (setq c (1+ c)))
  (while (< c 256)
    (modify-syntax-entry (make-character lc-kr c) "w")
    (setq c (1+ c)))

  ;; For syntax of Chinese characters.
  (setq c 161)
  (while (< c 163)
    (modify-syntax-entry (make-character lc-cn c) ".")
    (setq c (1+ c)))
  (while (< c 169)
    (modify-syntax-entry (make-character lc-cn c) "w")
    (setq c (1+ c)))
  (modify-syntax-entry (make-character lc-cn 169) ".")
  (setq c 170)
  (while (< c 256)
    (modify-syntax-entry (make-character lc-cn c) "w")
    (setq c (1+ c)))

  ;; For syntax of Latin-1 characters.
  (setq c 192)				; from ',A@' to ',A'
  (while (< c 256)
    (modify-syntax-entry (make-character lc-ltn1 c) "w")
    (setq c (1+ c)))
  (modify-syntax-entry ?,AW ".")
  (modify-syntax-entry ?,Aw ".")
  )

;; REGISTRATION OF PRIVATE CHARACTER SETS

;; PinYin-ZhuYin
(setq lc-sisheng (new-private-character-set 1 1 0 0 ?0 0 "PinYin-ZhuYin"))

;; Thai TSCII
(setq lc-thai (new-private-character-set 1 1 0 0 ?1 0 "Thai TSCII"))

;; 93.4.10 by K.Handa
(setq lc-ascr2l
      (new-private-character-set 1 1 0 0 ?B 1 "Right-to-Left ASCII")) 

;; 93.5.24 by K.Handa
;; Vietnamese VISCII with two tables.
(setq lc-vn-1 (new-private-character-set 1 1 1 1 ?1 0 "VISCII lower"))
(setq lc-vn-2 (new-private-character-set 1 1 1 1 ?2 0 "VISCII upper"))
(modify-syntax-entry (make-character lc-vn-1) "w")
(modify-syntax-entry (make-character lc-vn-2) "w")

;; 94.1.18 by K.Handa
;; For syntax of Latin-7 (Greek) characters.
(setq c 182)				; from ',F6' to ',F~'
(while (< c 256)
  (modify-syntax-entry (make-character lc-grk c) "w")
  (setq c (1+ c)))
