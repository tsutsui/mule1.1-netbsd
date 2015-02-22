;; Chinese specific setup for Mule
;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).

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

;;; 92.3.5   Created for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.4.3   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
;;;	Function set-code-priority is deleted
;;;	and variable code-priority is introduced.
;;; 92.7.10  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	(load "quail") -> (require 'quail)
;;; 92.8.7   modified for Mule Ver.0.9.6 by D.Jacobson <danj1@ihspa.att.com>
;;;	Dont' load "quail-py-b5" twice!
;;; 92.10.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	EGG supports cserver.  Several settting for GB.
;;; 92.12.16 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	Setting term-setup-hook is done in mule-init.el now.
;;; 93.1.24  modified for Mule Ver.0.9.7.1
;;;				by S.Yasutome <yasutome@ics.osaka-u.ac.jp>
;;;	Cope with new spec of make-coding-system.
;;; 93.5.4   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Set kinsoku-gb and kinsoku-big5 t.
;;; 93.7.16  modified for Mule Ver.0.9.8 by T.Hirose <muri@dink.foretune.co.jp>
;;;	Hz code ending with \n without ~} is handled.
;;; 93.7.22  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;; 93.7.29  modified for Mule Ver.0.9.8 by Y.Kawabe <kawabe@sra.co.jp>
;;;	SJ3 can't handle Chinese.
;;; 93.10.18 modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	In hz2gb-region, don't signal error even if text is ill-formated.
;;; 94.2.8   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>

(provide 'chinese)			;93.7.22 by K.Handa

(set-coding-priority
 '(*coding-category-iso-8-2*
   *coding-category-big5*
   *coding-category-iso-8-1*))

;; Re-definition
(make-coding-system
 '*euc-china* 2
 ?C "Coding-system of Chinese EUC (Extended Unix Code)."
 t
 (list lc-ascii lc-cn lc-sisheng nil
	 nil 'ascii-eol 'ascii-cntl nil nil nil nil))

(setq *coding-category-iso-8-2* *euc-china*)

(setq display-coding-system *euc-china*)
(setq keyboard-coding-system *euc-china*)

(set-default-file-coding-system *euc-china*) ; GB encoding

;; Hz/ZW encoding stuffs
(defvar hz2gb-gb-designation "\e$A")
(defvar hz2gb-ascii-designation "\e(B")
(defvar hz2gb-line-continuation nil)	;93.7.16 by T.Hirose

(defun hz2gb-buffer ()
  "Convert whole text in the current buffer
from HZ/ZW encoding to mule internal encoding."
  (interactive) (hz2gb-region (point-min) (point-max)))	

(defun hz2gb-region (beg end)
  "Convert text in the current region from HZ/ZW encoding to *internal*."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      ;; "~\n" -> "\n"
      (goto-char (point-min))
      (while (search-forward "~" nil t)
	(if (= (following-char) ?\n) (delete-char -1))
	(if (not (eobp)) (forward-char 1))) ;93.10.18 by K.Handa
      ;; "^zW...\n" -> Chinese text
      ;; "~{...~}"  -> Chinese Text
      (goto-char (point-min))
      (let (chinese-found)
	(while (re-search-forward "~{\\|^zW" nil t)
	  (if (= (char-after (match-beginning 0)) ?z)
	      ;; ZW -> *junet*
	      (progn
		(delete-char -2)
		(insert hz2gb-gb-designation)
		(end-of-line)
		(insert hz2gb-ascii-designation))
	    ;; Hz -> *junet*
	    (delete-char -2)
	    (insert hz2gb-gb-designation)
	    ;; 93.7.16 by T.Hirose
	    (if (re-search-forward "\\(~}\\)\\|\\(\n\\)" nil t)
		(if (match-beginning 1)
		    (replace-match hz2gb-ascii-designation)
		  (if (not hz2gb-line-continuation)
		      (progn
			(goto-char (match-beginning 2))
			(insert hz2gb-ascii-designation))))))
	  (setq chinese-found t))
	(if chinese-found
	    (code-convert-region (point-min) (point-max) *junet* *internal*)))
      ;; "~~" -> "~"
      (goto-char (point-min))
      (while (search-forward "~~" nil t) (delete-char -1)))))

(defun gb2hz-buffer ()
  "Convert whole text in the current buffer
from mule internal encoding to HZ encoding."
  (interactive) (gb2hz-region (point-min) (point-max)))	

(defun gb2hz-region (beg end)
  "Convert text in the current region
from mule internal encoding to HZ encoding."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      ;; "~" -> "~~"
      (goto-char (point-min))
      (while (search-forward "~" nil t)	(insert ?~))
      ;; Chinese text -> "~{...~}"
      (goto-char (point-min))
      (if (re-search-forward "\\cc" nil t)
	  (let (mc-flag p)
	    (goto-char (match-beginning 0))
	    (setq p (point))
	    (code-convert-region p (point-max) *internal* *junet*)
	    (goto-char p)
	    (while (search-forward hz2gb-gb-designation nil t)
	      (delete-char -3)
	      (insert "~{"))
	    (goto-char p)
	    (while (search-forward hz2gb-ascii-designation nil t)
	      (delete-char -3)
	      (insert "~}"))
	    (goto-char p)))
      )))

(make-coding-system
 '*hz* 0
 ?v "Codins-system of Hz/ZW used for Chinese."
 nil)
(put *hz* 'post-read-conversion 'hz2gb-region)
(put *hz* 'pre-write-conversion 'gb2hz-region)

;; If you prefer QUAIL to EGG, please modify below as you wish.
(if (and (boundp 'EGG) (boundp 'WNN4))	;93.7.29 by Y.Kawabe
    (progn
      (setq wnn-server-type 'cserver)
      (load "its/pinyin")
      (setq its:*standard-modes*
	    (cons (its:get-mode-map "PinYin") its:*standard-modes*))
      (setq-default its:*current-map* (its:get-mode-map "PinYin"))
      )
  ;; For those who don't have cWnn/cserver...
  (require 'quail)			;92.7.10 by K.Handa

  ;; Please load what you want.  I have no idea which you need.

  ;; For GB character input
  ;;(load "quail/tonepy")
  ;;(load "quail/ccdospy")
  ;;(load "quail/ctcps3")
  (load "quail/punct")
  (load "quail/qj")
  (load "quail/py")
  ;;(load "quail/sw")
  ;;(load "quail/etzy")

  ;; For BIG5 character input
  ;;(load "quail/py-b5")
  ;;(load "quail/punct-b5")
  ;;(load "quail/qj-b5")
  ;;(load "quail/zozy")
  )

(setq kinsoku-gb t)
(setq kinsoku-big5 t)
