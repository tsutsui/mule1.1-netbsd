;; Multilingual Utility commands for Nemacs
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
;;      and K.Handa, Electrotechnical Lab. (handa@etl.go.jp)

;;; 92.6.26 modified for Mule Ver.0.9.5 by M.Shikida <shikida@cs.titech.ac.jp>
;;;	Spell in comment of list-coding-system corrected.
;;; 92.7.2  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Function string-width created.
;;;	Function string-to-char-list is moved here from mule.el.
;;;	In delete-text-in-column, nil of FROM or TO means the current column.
;;; 92.7.15  modified for Mule Ver.0.9.5 by T.Enami
;;;	find-process-coding-system is called by 'apply'.
;;;	In find-process-coding-system, BUFFER arg 0 is handled correctly.
;;; 92.7.29  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	In find-file-coding-system-from-filename, check of code is fixed.
;;;	Correct initial value is set to file-coding-system-alist.
;;; 92.7.31  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	New function string-memq is added.
;;; 92.8.5   modified for Mule Ver.0.9.5.1 by K.Handa <handa@etl.go.jp>
;;;	string-memq accepts list of characters.
;;; 92.8.5   modified for Mule Ver.0.9.5.1 by S.Tomura <tomura@etl.go.jp>
;;;	string-width is modified so as not to consume cons cells.
;;; 92.9.13  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	undefined-private-character-set and new-private-character-set created.
;;; 92.9.23  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	In write-file and append-to-file, file-coding-system
;;;	is set after writing.
;;; 92.9.29  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	what-coding-system is modified accoding to the suggestion by T.Enami.
;;; 92.9.30  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	In list-coding-system, file-coding-system-for-read-not-found deleted.
;;; 92.10.12 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	Staffs of private character set are moved to mule.el.
;;;	New function set-x-default-font.
;;; 92.10.25 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	define-xxx-coding-system accepts single code.
;;; 92.11.22 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	dump-charsets is moved to mule-inst.el.
;;; 92.12.20 modified for Mule Ver.0.9.7 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	cancel-undo-boundary is created.
;;; 92.12.25 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	Utility functions for composite character added.
;;; 92.12.25 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	Now, coding-system is a symbol.
;;; 92.12.31 modified for Mule Ver.0.9.7.1 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	Bug in charset-doc fixed.
;;; 93.1.5   modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Bugs caused by the change of type of coding-system fixed.
;;; 93.1.17  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	compose-string handles partially pre-composed string.
;;; 93.2.15  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Bug fix in decompose-region, new function decompose-string.
;;; 93.2.28  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	describe-coding-system shows info about initial designation.
;;; 93.5.7   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Output format of list-character-set changed (direction added).
;;; 93.5.31  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	describe-coding-system cope with type-4 (private) coding-system.
;;; 93.6.9   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Add toggle-display-direction to mule-keymap ("r").
;;; 93.6.17  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	string-width is now in mule.c.
;;; 93.6.20  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	New function code-convert-string.
;;; 93.7.16  modified for Mule Ver.0.9.8
;;;				by K.Wakamiya <wkenji@flab.fujitsu.co.jp>
;;;	find-charset-region and find-charset-string is added.
;;; 93.7.17  modified for Mule Ver.0.9.8 by K.Hirokawa <hirokawa@rics.co.jp>
;;;	find-process-coding-system-rsh and find-process-coding-system-env
;;;	should call find-process-coding-system by 'apply'.
;;; 94.2.23  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Big change of coding-system handling.

;;;####### Here's the history before Ver.0.9.5
;;; Ver.2.05 92.4.30 modified for Mule Ver.0.9.4
;;;	by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;;	      Non-subprocess systems are concerned.
;;;	     92.5.18 by K.Handa
;;;	      Bug in convert-mbox-coding-system is fixed.
;;; Ver.2.04 92.4.30 modified for Mule Ver.0.9.4
;;;	by K.Handa <handa@etl.go.jp> and T.Enami <enami@sys.ptg.sony.co.jp>
;;;	      default-call-process-hook returns cons.
;;;	      default-call-process-region-hook is deleted.
;;;	by M.Kuwada <kuwada@soliton.ee.uec.ac.jp>
;;;	      find-process-coding-system accepts buffer as BUFFER arg.
;;; Ver.2.03a 92.4.17 modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
;;;	      Cope with new coding-system form.
;;; Ver.2.03  92.4.3   by K.Handa <handa@etl.go.jp>
;;;	      Function what-coding-system added.
;;; Ver.2.02  92.3.24  modified for Mule Ver.0.9.2
;;;		by D.Sekita <sekita@asdsb.sra.co.jp>
;;;	      In default-open-network-stream-hook, argument order fixed.
;;;	      92.3.24  modified for Mule Ver.0.9.2 by K.Handa
;;;	      Added function 'code-convert'.
;;;	      92.3.25  modified for Mule ver.0.9.2
;;;		by M.Kuwada <kuwada@soliton.ee.uec.ac.jp>
;;;	      Document of view-mule-news fixed.
;;; Ver.2.01  92.3.17  modified for Mule Ver.0.9.1 by K.Handa
;;;	      Move definition of mule-keymap to mule.el.
;;; Ver.2.00  92.3.5   modified for Mule Ver.0.9.0 by K.Handa
;;; Ver.1.19  modified by S.Tomura 91-Feb-28
;;;           kanji-normal-form-string added
;;; Ver.1.18  modified by K.Handa 90-Feb-27
;;;	      list-kanji-code-briefly shows FIDP in this order
;;; Ver.1.17  modified by S.Tomura 90-Jan-13
;;;           *-kanji-code-match uses strict-string-match
;;; Ver.1.16  modified by yosikawa@spls8.ccs.mt.nec.co.jp 90-Jan-12
;;;	      Now list-kanji-coded-briefly sees kanji-expected-code
;;;	      change-kanji-expected-code added
;;; Ver.1.15  modified by S.Tomura 90-Jan-9
;;;           (1) in completing-read for kanji-code input, 
;;;           change REQUIRE-MATCH from nil to t
;;;           (2) several *-kanji-code-alist are added.
;;; Ver.1.14  modified by S.Tomura 89-Dec-16
;;;           Bugs in server-kanji-code-match and
;;;           program-kanji-code-match are fixed
;;; Ver.1.13  modified by S.Tomura 89-Dec-15
;;;           server-kanji-code-match and 
;;;           program-kanji-code-match changed 
;;; Ver. 1.12 modified by T. Nakagawa 89-Dec-14
;;;           find-kanji-process-code-env modified
;;; Ver. 1.11 modified by S. Tomura 89-Dec-12
;;;           find-file-read-only modified
;;;           find-file-other-window modified
;;; Ver. 1.10 modified by S. Tomura 89-Dec-11
;;;           find-kanji-file-input-code changed
;;; Ver. 1.9  modified by S. Tomura 89-Dec-11
;;;           find-alternate-file modified
;;; Ver. 1.8  modified by S. Tomura 89-Sep-18
;;;           kanji-file-output-code-query-flag added
;;; Ver. 1.7  modified by S. Tomura 89-Sep-4
;;;           invoke-find-* are added.
;;; Ver. 1.6  modified by S. Tomura 89-Aug-29
;;;           function find-kanji-file-input-code
;;;           function find-kanji-file-output-code added
;;; Ver. 1.5  modified by S. Tomura 89-Aug-21
;;;           function find-kanji-fileio-code added
;;; Ver. 1.4  modified by S. Tomura 89-Aug-18
;;;           functions "get-*" are renamed to "find-*"
;;; Ver. 1.3  modified by S. Tomura 89-Jun-30
;;;           name set-default-kanji-fileio-code fixed.
;;; Ver. 1.2  modified by S. Tomura 89-Apr-20
;;;;          service-kanji-code-match modified.
;;;;          SERIVCE of open-network-stream may be an integer.
;;; Ver. 1.1  modified by S. Tomura 89-Apr-19
;;;;          kanji-code-internal added
;;; Nemacs 3.0 created by S. Tomura 89-Mar-16
;;; Nemacs 2.1 created by S. Tomura 88-Jun-14

(defvar mv-util-version "2.00")
;;; Last modified date: Thu Feb 20 11:03:36 JST 1992

(define-key mule-keymap "t" 'toggle-mc-flag)
(define-key mule-keymap "f" 'set-file-coding-system)
(define-key mule-keymap "i" 'set-keyboard-coding-system)
(define-key mule-keymap "d" 'set-display-coding-system)
(define-key mule-keymap "p" 'set-current-process-coding-system)
(define-key mule-keymap "T" 'toggle-default-mc-flag)
(define-key mule-keymap "F" 'set-default-file-coding-system)
(define-key mule-keymap "P" 'set-default-process-coding-system)
(define-key mule-keymap "c" 'list-coding-system-briefly)
(define-key mule-keymap "C" 'list-coding-system)
(define-key mule-keymap "r" 'toggle-display-direction)

(defun toggle-mc-flag ()
  "Toggle mc-flag."
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq mc-flag (not mc-flag))
  (if mc-flag
      (goto-char (point)))
  (if (interactive-p) (redraw-display)))

(defun toggle-default-mc-flag ()
  "Toggle default-mc-flag."
  (interactive)		;;; patch by H.Nakahara 87.6.24
  (setq-default mc-flag (not (default-value 'mc-flag)))
  (if mc-flag
      (goto-char (point)))
  (if (interactive-p) (redraw-display)))

(defun set-default-file-coding-system (coding-system)
  "Set default-file-coding-system to CODING-SYSTEM,
which should be a lisp object created by make-coding-system."
  (interactive "zDefault file-coding-system: ")
  (setq-default file-coding-system coding-system)
  (update-mode-lines))

(defun set-default-process-coding-system (input output)
  "Set default values of input and output coding-system for process to
INPUT and OUTPUT, which should be lisp objects created by make-coding-system."
  (interactive
   "zDefault coding-system for process input: \nzDefault coding-system for process output: ")
  (setq default-process-coding-system (cons input output))
  (update-mode-lines))

(defun charset-doc (lc)
  (if lc (nth 6 (character-set lc)) "none" )) ;92.12.31 by T.Shingu

;; 93.2.28 by K.Handa
(defun describe-designation (flags graphic)
  (let ((lc (aref flags graphic))
	lc1)
    (if (integerp lc) (setq lc1 (if (> lc 0) lc (- lc))))
    (princ (format "  G%d -- %s"
		   graphic
		   (or (and lc1 (charset-doc lc1))
		       (and (eq lc lc-invalid) "never used")
		       "none")))
    (princ (if (and lc1 (< lc 0))
	       " (explicit designation required)\n"
	     "\n"))))
;; end of patch

(defun describe-coding-system (code)
  "Display documentation of the coding-system CODE."
  (interactive "zCoding-system: ")
  (check-coding-system code)
  (with-output-to-temp-buffer "*Help*"
    (princ "Coding-system ")
    (princ code)
    (princ " [")
    (princ (char-to-string (get-code-mnemonic code)))
    (princ "]: \n")
    (if (not code) nil
      (princ "  ")
      (princ (get-code-document code))
      (princ "\nType: ")
      (let ((type (get-code-type code)) flags)
	(princ type)
	(princ " [")
	(cond ((eq type t)
	       (princ "AUTOCONV]\n"))
	      ((eq type 0)
	       (princ "INTERNAL]\n"))
	      ((eq type 1)
	       (princ "Shift-JIS]\n"))
	      ((eq type 2)
	       (princ "ISO-2022]\n")
	       (setq flags (get-code-flags code))
	       (princ "Initial designations:\n")
	       ;; 93.2.28 by K.Handa
	       (describe-designation flags 0)
	       (describe-designation flags 1)
	       (describe-designation flags 2)
	       (describe-designation flags 3)
	       ;; end of patch
	       (princ "Other Form: \n")
	       (princ (if (aref flags 4) "ShortForm" "LongForm"))
	       (if (aref flags 5) (princ ", ASCII@EOL"))
	       (if (aref flags 6) (princ ", ASCII@CNTL"))
	       (princ (if (aref flags 7) ", 7bit" ", 8bit"))
	       (if (aref flags 8) (princ ", UseLockingShift"))
	       (if (aref flags 9) (princ ", UseRoman"))
	       (if (aref flags 10) (princ ", UseOldJIS"))
	       (if (aref flags 11) (princ ", No ISO6429")) ;93.8.12 by K.Handa
	       (princ ".\n"))
	      ((eq type 3)
	       (princ "Big5]\n  ")
	       (princ (if flags "Big-ETen\n" "Big-HKU\n")))
	      ((eq type 4)
	       (princ "private]\n  Conversion routine written in CCL."))
	      (t (princ "unknown\]\n"))))
      (princ "\nEOL-Type: ")
      (let ((eol-type (get-code-eol code)))
	(cond ((null eol-type)
	       (princ "null (= LF)\n"))
	      ((vectorp eol-type)
	       (princ "Automatic selection from ")
	       (princ eol-type)
	       (princ "\n"))
	      ((eq eol-type 1) (princ "LF\n"))
	      ((eq eol-type 2) (princ "CRLF\n"))
	      ((eq eol-type 3) (princ "CR\n"))
	      (t (princ "invalid\n"))))
      )))

(defun list-coding-system-briefly ()
  "Display coding-systems currently used with a brief format in mini-buffer."
  (interactive)
					; 92.5.18 by M.Higashida
  (let ((cs (and (fboundp 'process-coding-system) (process-coding-system)))
	eol-type)
    (message
     "current: [FKDPp=%c%c%c%c%c%c%c%c] default: [FPp=%c%c%c%c%c%c]"
     (get-code-mnemonic file-coding-system)
     (get-eol-mnemonic file-coding-system)
     (get-code-mnemonic keyboard-coding-system)
     (get-code-mnemonic display-coding-system)
     (get-code-mnemonic (car cs))
     (get-eol-mnemonic (car cs))
     (get-code-mnemonic (cdr cs))
     (get-eol-mnemonic (cdr cs))
     (get-code-mnemonic (default-value 'file-coding-system))
     (get-eol-mnemonic (default-value 'file-coding-system))
     (get-code-mnemonic (car default-process-coding-system))
     (get-eol-mnemonic (car default-process-coding-system))
     (get-code-mnemonic (cdr default-process-coding-system))
     (get-eol-mnemonic (cdr default-process-coding-system))
     )))

(defun princ-coding-system (code)
  (princ ": ")
  (princ code)
  (princ " [")
  (princ (char-to-string (get-code-mnemonic code)))
  (princ (char-to-string (get-eol-mnemonic code)))
  (princ "]\n"))

;; 92.6.26 by M.Shikida -- Spell in comment corrected.
(defun list-coding-system ()
  "Describe coding-systems currently used with a detail format"
  (interactive)
					; 92.5.18 by M.Higashida
  (let ((cs (and (fboundp 'process-coding-system) (process-coding-system))))
    (with-output-to-temp-buffer "*Help*"
      (princ "Current:\n  file-coding-system")
      (princ-coding-system file-coding-system)
      (princ "  keyboard-coding-system")
      (princ-coding-system keyboard-coding-system)
      (princ "  display-coding-system")
      (princ-coding-system display-coding-system)
      (if cs
	  (progn (princ "  process-coding-system (input)")
		 (princ-coding-system (car cs))
		 (princ "  process-coding-system (output)")
		 (princ-coding-system (cdr cs))))
      (princ "Default:\n  file-coding-system")
      (princ-coding-system (default-value 'file-coding-system))
      (princ "  process-coding-system (input)")
      (princ-coding-system (car default-process-coding-system))
      (princ "  process-coding-system (output)")
      (princ-coding-system (cdr default-process-coding-system))
      (princ "Others:\n  file-coding-system-for-read")
      (princ-coding-system file-coding-system-for-read)
      )))

;; 93.6.9 by K.Handa
(defun toggle-display-direction ()
  (interactive)
  (setq display-direction (not display-direction))
  (if (interactive-p) (redraw-display)))

;; 92.4.3, 92.9.29 by K.Handa
(defun detect-code-category (start end &optional highest)
  "Obsolete function."
  (error "detect-code-category is an obsolete function."))

(defun what-coding-system (start end &optional arg)
  "Show coding-system of text in the region.
With prefix arg, show all possible coding systems.
From program, use code-detect-region instead."
  (interactive "r\nP")
  (let ((codings (code-detect-region start end)))
    (message "%s" (if arg codings (car codings)))))
;; end of patch

;; 92.10.12 by K.Handa
(defun set-x-default-font (lc font encoding)
  "Set FONTNAME (2nd arg) ane ENCODING (3rd arg) as a default
for the character set LEADING-CHAR (1st arg)."
  (if (boundp 'x-default-fonts)
      (progn
	(setq lc (logand lc 127))
	(aset x-default-fonts lc font)
	(aset x-default-encoding lc encoding))))

(defun list-character-sets ()
  "Display a list of existing character sets."
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ "## LIST OF CHARACTER SETS\n")
    (princ "## LC:BYTES:COLUMNS:TYPE:GRAPHIC:FINAL-CHAR:DIRECTION:DOC\n")
    (let (lc charset)
      (setq lc 0)
      (while (< lc 256)
	(setq charset (character-set lc))
	(if charset
	    ;; 93.5.7 by K.Handa
	    (princ (format "%03d:%d:%d:%d:%d:%d:%d:%s\n" lc
			   (nth 0 charset) (nth 1 charset) (nth 2 charset)
			   (nth 3 charset) (nth 4 charset) (nth 5 charset)
			   (nth 6 charset))))
	(setq lc (logior (1+ lc) 128))))))
;; end of patch

(define-key help-map "T" 'help-with-tutorial-for-mule)
(define-key help-map "N" 'view-mule-news)

(defun help-with-tutorial-for-mule ()
  "Select the Mule learn-by-doing tutorial."
  (interactive)
  (let ((file (expand-file-name "~/TUTORIAL.jp")))
    (delete-other-windows)
    (if (get-file-buffer file)
	(switch-to-buffer (get-file-buffer file))
      (switch-to-buffer (create-file-buffer "~/TUTORIAL.jp"))
      (setq buffer-file-name file)
      (setq default-directory (expand-file-name "~/"))
      (setq auto-save-file-name nil)
      (insert-file-contents (expand-file-name "TUTORIAL.jp" exec-directory))
      (goto-char (point-min))
      (search-forward "\n<<")
      (beginning-of-line)
      (delete-region (point) (progn (end-of-line) (point)))
      (newline (- (window-height (selected-window))
		  (count-lines (point-min) (point))
		  4))
      (goto-char (point-min))
      (set-buffer-modified-p nil))))

(defun view-mule-news ()
  "Display info on recent changes to Mule." ;; 92.3.25 by M.Kuwada
  (interactive)
  (find-file-read-only (expand-file-name "MULE.nws" exec-directory)))

;;;
;;; Utility functions for Mule
;;;

;; 92.7.2 by K.Handa
(defun string-to-char-list (str)
  (let ((len (length str))
	(idx 0)
	c l)
    (while (< idx len)
      (setq c (sref str idx))
      (setq idx (+ idx (char-bytes c)))
      (setq l (cons c l)))
    (nreverse l)))

;; 92.7.2 by K.Handa
(defun delete-text-in-column (from to)
  "Delete the text between column FROM and TO (exclusive) of the current line.
Nil of FORM or TO means the current column.
If there's a charcter across the borders, the character is replaced with
the same width of spaces before deleting."
  (save-excursion
    (let (p1 p2)
      (if from
	  (progn
	    (setq p1 (move-to-column from))
	    (if (> p1 from)
		(progn
		  (delete-char -1)
		  (insert-char ?  (- p1 (current-column)))
		  (forward-char (- from p1))))))
      (setq p1 (point))
      (if to
	  (progn
	    (setq p2 (move-to-column to))
	    (if (> p2 to)
		(progn
		  (delete-char -1)
		  (insert-char ?  (- p2 (current-column)))
		  (forward-char (- to p2))))))
      (setq p2 (point))
      (delete-region p1 p2))))

;;;
;;; Standard Coding-system Decision Procedure
;;; 

;;;
;;; For file-coding-system (read)
;;;

(or (fboundp 'si:find-file)
    (fset 'si:find-file (symbol-function 'find-file)))

(defun find-file (filename &optional user-coding-system)
  "Edit file FILENAME.
Switch to a buffer visiting file FILENAME,
creating one if none already exists.
A prefix argument enables user to specify the coding-system interactively."
  (interactive "FFind file: \nZCoding-system: ")
  (if user-coding-system
      (let ((file-coding-system-for-read
	     (check-coding-system user-coding-system)))
	(si:find-file filename))
    (si:find-file filename)))

(or (fboundp 'si:find-alternate-file)
    (fset 'si:find-alternate-file (symbol-function 'find-alternate-file)))

(defun find-alternate-file (filename &optional user-coding-system)
  "Find file FILENAME, select its buffer, kill previous buffer.
If the current buffer now contains an empty file that you just visited
\(presumably by mistake), use this command to visit the file you really want.
A prefix argument enables user to specify the coding-system interactively."
  (interactive "FFind alternate file: \nZCoding-system: ")
  (if user-coding-system
      (let ((file-coding-system-for-read
	     (check-coding-system user-coding-system)))
	(si:find-alternate-file filename))
    (si:find-alternate-file filename)))

(or (fboundp 'si:find-file-read-only)
    (fset 'si:find-file-read-only (symbol-function 'find-file-read-only)))

(defun find-file-read-only (filename &optional user-coding-system)
  "Edit file FILENAME but don't save without confirmation.\n\
Like find-file but marks buffer as read-only.\n\
A prefix argument enables user to specify the coding-system interactively."
  (interactive "FFind file read-only: \nZCoding-system: ")
  (if user-coding-system
      (let ((file-coding-system-for-read
	     (check-coding-system user-coding-system)))
	(si:find-file-read-only filename))
    (si:find-file-read-only filename)))

(or (fboundp 'si:find-file-other-window)
    (fset 'si:find-file-other-window
	  (symbol-function 'find-file-other-window)))

(defun find-file-other-window (filename &optional user-coding-system)
  "Edit file FILENAME, in another window.
May create a new window, or reuse an existing one;
see the function display-buffer.
A prefix argument enables user to specify the coding-system interactively."
  (interactive "FFind file in other window: \nZCoding-system: ")
  (if user-coding-system
      (let ((file-coding-system-for-read
	     (check-coding-system user-coding-system)))
	(si:find-file-other-window filename))
    (si:find-file-other-window filename)))

(or (fboundp 'si:insert-file)
    (fset 'si:insert-file (symbol-function 'insert-file)))

(defun insert-file (filename &optional user-coding-system)
  "Insert contents of file FILENAME into buffer after point.
Set mark after the inserted text.
A prefix argument enables user to specify the coding-system interactively."
  (interactive "fInsert file: \nZCoding-system: ")
  (if user-coding-system
      (let ((file-coding-system-for-read
	     (check-coding-system user-coding-system)))
	(si:insert-file filename))
    (si:insert-file filename)))

(defvar file-coding-system-alist
  '( ("\\.el$" . *euc-japan*)		; 92.7.29 by K.Handa
     ("/spool/mail/.*$" . convert-mbox-coding-system )))

(defun find-file-coding-system-from-filename (filename visit start end)
  (let ((alist file-coding-system-alist)
	(found nil)
	(code nil))
    (let ((case-fold-search (eq system-type 'vax-vms)))
      (setq filename (file-name-sans-versions filename))
      (while (and (not found) alist)
	(if (string-match (car (car alist)) filename)
	    (setq code (cdr (car alist))
		  found t))
	(setq alist (cdr alist))))
    (if code				; 92.7.29 by K.Handa
	(cond( (and (symbolp code) (fboundp code))
	       (funcall code filename visit start end))
	     ( (vectorp code)
	       code)))))

(defun convert-mbox-coding-system (filename visit start end)
  (let ((buffer-read-only nil))
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (while (not (eobp))
	(let ((start (point))
	      code
	      end)
	  (forward-char 1)
	  (if (re-search-forward "^From" nil 'move)
	      (beginning-of-line))
	  (setq end (point))
	  ;; 92.5.20, 94.2.22 by K.Handa
	  (code-convert-region start end *autoconv* *internal*))))))

;;;
;;; hack from files.el : hack-local-variables
;;;

(defun find-read-file-coding-system-from-file-variables ()
  "Parse, and bind or evaluate as appropriate, any local variables
for current buffer."
  ;; Look for "Local variables:" line in last page.
  (save-excursion
    (goto-char (point-max))
    (search-backward "\n\^L" (max (- (point-max) 3000) (point-min)) 'move)
    (if (let ((case-fold-search t))
	  (search-forward "Local Variables:" nil t))
	(let ((continue t)
	      prefix prefixlen suffix beg)
	  ;; The prefix is what comes before "local variables:" in its line.
	  ;; The suffix is what comes after "local variables:" in its line.
	  (skip-chars-forward " \t")
	  (or (eolp)
	      (setq suffix (buffer-substring (point)
					     (progn (end-of-line) (point)))))
	  (goto-char (match-beginning 0))
	  (or (bolp)
	      (setq prefix
		    (buffer-substring (point)
				      (progn (beginning-of-line) (point)))))
	  (if prefix (setq prefixlen (length prefix)
			   prefix (regexp-quote prefix)))
	  (if suffix (setq suffix (regexp-quote suffix)))
	  (while continue
	    ;; Look at next local variable spec.
	    (if selective-display (re-search-forward "[\n\C-m]")
	      (forward-line 1))
	    ;; Skip the prefix, if any.
	    (if prefix
		(if (looking-at prefix)
		    (forward-char prefixlen)
		  (error "Local variables entry is missing the prefix")))
	    ;; Find the variable name; strip whitespace.
	    (skip-chars-forward " \t")
	    (setq beg (point))
	    (skip-chars-forward "^:\n")
	    (if (eolp) (error "Missing colon in local variables entry"))
	    (skip-chars-backward " \t")
	    (let* ((str (buffer-substring beg (point)))
		   (var (read str))
		  val)
	      ;; Setting variable named "end" means end of list.
	      (if (string-equal (downcase str) "end")
		  (setq continue nil)
		;; Otherwise read the variable value.
		(skip-chars-forward "^:")
		(forward-char 1)
		(setq val (read (current-buffer)))
		(skip-chars-backward "\n")
		(skip-chars-forward " \t")
		(or (if suffix (looking-at suffix) (eolp))
		    (error "Local variables entry is terminated incorrectly"))
		;; Set the variable.  "Variables" mode and eval are funny.
		(if (eq var 'file-coding-system)
		    (setq file-coding-system val)))))))))

;;;
;;; For file-coding-system (write)
;;;

(or (fboundp 'si:write-file)
    (fset 'si:write-file (symbol-function 'write-file)))

(defun write-file (filename &optional user-coding-system)
  "Write current buffer into file FILENAME.
Makes buffer visit that file, and marks it not modified.
A prefix argument enables user to specify the coding-system interactively."
  (interactive "FWrite file: \nZCoding-system: ")
  (if user-coding-system
      (progn
	(let ((file-coding-system (check-coding-system user-coding-system)))
	  (si:write-file filename))
	(set-file-coding-system user-coding-system))
    (si:write-file filename)))

(or (fboundp 'si:append-to-file)
    (fset 'si:append-to-file (symbol-function 'append-to-file)))

(defun append-to-file (start end filename &optional user-coding-system)
  "Append the contents of the region to the end of file FILENAME.
When called from a function, expects three arguments,
START, END and FILENAME.  START and END are buffer positions
saying what text to write.
A prefix argument enables user to specify the coding-system interactively."
  (interactive "r\nFAppend to file: \nZCoding-system: ")
  (if user-coding-system
      (progn
	(let ((file-coding-system (check-coding-system user-coding-system)))
	  (si:append-to-file start end filename))
	(set-file-coding-system user-coding-system))
    (si:append-to-file start end filename)))

;;;
;;; For process-coding-system
;;;

(defun default-start-process-hook (name buf program &rest args)
  ;; 92.7.15 by T.Enami
  (apply 'find-process-coding-system buf program nil args))

(defun default-open-network-stream-hook (name buf host service)
  ;; 92.3.24 by D.Sekita - order of arguments fixed.
  (find-process-coding-system buf service t host))

;; 92.4.28 by K.Handa -- Argument and return value changed.
(defun default-call-process-hook (program buffer start end &rest args)
  ;; 92.7.15 by T.Enami
  (apply 'find-process-coding-system buffer program nil args))

;; 92.4.28 by K.Handa -- default-call-process-region-hook is deleted.

(defun find-process-coding-system (buffer program
					  &optional servicep &rest args)
 "Arguments are BUFFER, PROGRAM, SERVICEP, and ARGS.
BUFFER is output buffer (or its name) of a process or nil.
If SERVICEP is nil, PROGRAM is a path name of a program to be executed
 by start-process and ARGS is a list of the arguments.
If SERVICEP is non-nil, PROGRAM is a name of a service
 for open-network-stream and ARGS is a list of a host.
The return value is a cons of coding-systems
 for input and output for the process.
Please redefine this function as you wish."
 (if (eq buffer t) (setq buffer (buffer-name))
   ;; 92.4.30 by M.Kuwada
   (if (bufferp buffer) (setq buffer (buffer-name buffer))
     ;; 92.7.15 by T.Enami
     (if (not (stringp buffer)) (setq buffer ""))))

  (let ((place (if servicep
		   (find-service-coding-system program (car args))
		 (find-program-coding-system buffer program))))
    (if place
	(cond( (consp (cdr place)) (cdr place))
	     ( (null (cdr place)) '(nil nil)) ;93.1.5 by K.Handa
	     ( t (condition-case ()
		     (apply (cdr place) buffer program servicep args)
		   (error default-process-coding-system))))
      default-process-coding-system)))
	  
(setq start-process-hook 'default-start-process-hook
      open-network-stream-hook 'default-open-network-stream-hook
      call-process-hook 'default-call-process-hook
      call-process-region-hook 'default-call-process-region-hook)

;;;
;;;  program --> coding-system translation
;;;

(defun strict-string-match (regexp string &optional start)
  (and (eq 0 (string-match regexp string (or start 0)))
       (eq (match-end 0) (length string))))

(defvar program-coding-system-alist nil)

(defun define-program-coding-system (buffer program code)
  (let* ((key (cons buffer program))
	 (place (assoc key program-coding-system-alist)))
    (if (coding-system-p code)		;93.1.5 by K.Handa
	(setq code (cons code code)))
    (if place
	(setcdr place code)
      (setq place (cons key code))
      (setq program-coding-system-alist
	    (cons place program-coding-system-alist)))
    place))

(defun find-program-coding-system (buffer program)
  (let ((alist program-coding-system-alist) (place nil))
    (while (and alist (null place))
      (if (program-coding-system-match buffer program (car (car alist)))
	  (setq place (car alist)))
      (setq alist (cdr alist)))
    place))

(defun program-coding-system-match (buffer program patpair)
  (let ((bpat (car patpair)) (ppat (cdr patpair)))
    (if (and (symbolp ppat) (boundp ppat)
	     (stringp (symbol-value ppat)))
	(setq ppat (symbol-value ppat)))
    (and (or (null bpat)
	     (and (stringp bpat) (string-match bpat buffer)))
	 (or (null ppat)
	     (and (stringp ppat)
		  (or
		   (strict-string-match ppat program)
		   (strict-string-match ppat (file-name-nondirectory program))
		   ))))))
  		      
(define-program-coding-system
  nil "rsh" 'find-process-coding-system-rsh)

(defun find-process-coding-system-rsh (buffer rsh &optional servicep host
					      &rest args)
  (if (equal (car args) "-l")
      (setq args (cdr (cdr args))))
  (if (equal (car args) "-n")
      (setq args (cdr args)))
  (apply 'find-process-coding-system buffer (car args) nil (cdr args)))


;;;
;;; 
;;; 
(define-program-coding-system
  nil (concat exec-directory "env") 'find-process-coding-system-env)

;;;(defun find-mc-process-code-env (buffer env &optional servicep &rest args)
;;;  (while (string-match "[-=]" (car args))
;;;    (setq args (cdr args)))
;;;  (find-mc-process-code buffer (car args) nil (cdr args)))

;;;
;;; coded by nakagawa@titisa.is.titech.ac.jp 1989
;;; modified by tomura@etl.go.jp 
;;;
;;; env command syntax:   See etc/env.c
;;; env [ - ]
;;; ;;; GNU env only
;;;     { variable=value 
;;;      | -u     variable
;;;      | -unset variable
;;;      | -s     variable value 
;;;      | -set   variable value }*
;;;     [ - | -- ] 
;;; ;;; end of GNU env only
;;;      <program> <args>
;;;

(defun find-process-coding-system-env (buffer env &optional servicep
					      &rest args)
  (if (string= (car args) "-") (setq args (cdr args)))
  (while (or (string-match "=" (car args))
	     (string= "-s"     (car args))
	     (string= "-set"   (car args))
	     (string= "-u"     (car args))
	     (string= "-unset" (car args)))
    (cond((or (string= "-s" (car args))
	      (string= "-set" (car args)))
	  (setq args (cdr(cdr(cdr args)))))
	 ((or (string= "-u" (car args))
	      (string= "-unset" (car args)))
	  (setq args (cdr(cdr args))))
	 (t 
	  (setq args (cdr args)))))
  (if (or (string= (car args) "-")
	  (string= (car args) "--"))
      (setq args (cdr args)))
  (apply 'find-process-coding-system buffer (car args) nil (cdr args)))

;;;
;;; service --> mc code translation
;;;

(defvar service-coding-system-alist nil)

(defun define-service-coding-system (service host code)
  (let* ((key (cons service host))
	 (place (assoc key service-coding-system-alist)))
    (if (coding-system-p code)		;93.1.5 by K.Handa
	(setq code (cons code code)))
    (if place
	(setcdr place code)
      (setq place (cons key code)
	    service-coding-system-alist (cons place service-coding-system-alist)))
    place))
	
(defun find-service-coding-system (service host)
  (let ((alist service-coding-system-alist) (place nil))
    (while (and alist (null place))
      (if (service-coding-system-match service host (car (car alist)))
	  (setq place (car alist)))
      (setq alist (cdr alist)))
    place))

(defun service-coding-system-match (service host patpair)
  (let ((spat (car patpair)) (hpat (cdr patpair)))
    (and (or (null spat)
	     (eq service spat)
	     (and (stringp spat) (stringp service)
		  (strict-string-match spat service)))
	 (or (null hpat)
	     (strict-string-match hpat host)))))

(defun mc-normal-form-string (str)
  "文字列 STR の漢字標準形文字列を返す．"
  (let ((i 0))
    (while (setq i (string-match "\n" str i))
      (if (and (<= 1 i) (< i (1- (length str)))
	       (< (aref str (1- i)) 128)
	       (< (aref str (1+ i)) 128))
	  (aset str i ? ))
      (setq i (1+ i)))
    (if (string-match "\n" str 0)
	(let ((c 0) (i 0) new)
	  (while (setq i (string-match "\n" str i))
	    (setq i (1+ i))
	    (setq c (1+ c)))
	  (setq new (make-string (- (length str) c) 0))
	  (setq i 0 c 0)
	  (while (< i (length str))
	    (cond((not (= (aref str i) ?\n ))
		  (aset new c (aref str i))
		  (setq c (1+ c))))

	    (setq i (1+ i))
	    )
	  new)
      str)))

;; 93.6.20 by K.Handa
(defun code-convert (start end source target)
  "Convert coding sytem of the text in the current region
from SOURCE to TARGET.
Properties post-read-conversion and pre-write-conversion of
 SOURCE and TARGET are also concerned.
On successful conversion, returns the length of converted text,
 else returns nil."
  (interactive "r\nzSource coding-system: \nzTarget coding-system: ")
  (save-restriction
    (let (prog)
      (narrow-to-region start end)
      (if (and (eq target *internal*)
	       (setq prog (get source 'post-read-conversion)))
	  (funcall prog (point-min) (point-max)))
      (if (code-convert-region (point-min) (point-max) source target)
	  (progn
	    (if (and (eq source *internal*)
		     (setq prog (get target 'pre-write-conversion)))
		(funcall prog (point-min) (point-max)))
	    (- (point-max) (point-min)))))))

(defun code-convert-string (str source target)
  "Convert code in STRING from SOURCE code to TARGET code,
On successful converion, returns the result string,
 else returns nil."
  (let ((curbuf (current-buffer))
	(tempbuf (get-buffer-create " *code-convert-work*"))
	result)
    (unwind-protect
	(progn
	  (set-buffer tempbuf)
	  (erase-buffer)
	  (insert str)
	  (setq result (code-convert (point-min) (point-max) source target)))
      (if result
	  (setq result (buffer-string)))
      (set-buffer curbuf))
    result))

;; 92.7.31, 92.8.5 by K.Handa
(defun string-memq (str list)
  "Returns non-nil if STR is an element of LIST.  Comparison done with string=.
The value is actually the tail of LIST whose car is STR.
If each element of LIST is not a string, it is converted to string
 before compalison."
  (let (find elm)
    (while (and (not find) list)
      (setq elm (car list))
      (if (numberp elm) (setq elm (char-to-string elm)))
      (if (string= str elm)
	  (setq find list)
	(setq list (cdr list))))
    find))
;; end of patch

;; 92.12.20 by T.Enami
(defun cancel-undo-boundary ()
  "Cancel undo boundary."
  (if (and (consp buffer-undo-list)
	   ;; if car is nil.
	   (null (car buffer-undo-list)) )
      (setq buffer-undo-list (cdr buffer-undo-list)) ))

;; Composite character support
;; 92.12.25, 93.1.17, 93.2.15 by K.Handa
(defun compose-string (str)
  "Compose STRING."
  (interactive "sString to be composed: ")
  (if (< (chars-in-string str) 2)
      str
    (let* ((len (length str))
	   (buf (make-string (1+ (* len 2)) 0))
	   (i 0) (j 1)
	   ch mc-flag)
      (aset buf 0 lc-composite)
      (while (< i len)
	(setq ch (aref str i))
	(cond ((or (<= ch 32) (= ch 127) (= ch lc-composite)))
	      ((< ch 128)
	       (aset buf j 160)
	       (aset buf (1+ j) (+ ch 128))
	       (setq j (+ j 2)))
	      ((< ch 160)
	       (aset buf j (+ ch 32))
	       (setq j (1+ j)))
	      (t
	       (aset buf j ch)
	       (setq j (1+ j))))
	(setq i (1+ i)))
      (if (< j 5)
	  str
	(substring buf 0 j)))))

(defun decompose-string (str)
  "Decompose STRING."
  (interactive "sString to be decomposed: ")
  (let* ((len (length str))
	 (buf (make-string len 0))
	 (i 0) (j 0) k
	 ch)
    (while (< i len)
      (while (and (< i len)
		  (/= (setq ch (aref str i)) lc-composite))
	(aset buf j ch)
	(setq i (1+ i) j (1+  j)))
      (setq i (1+ i))
      (while (and (< i len)
		  (>= (setq ch (aref str i)) 160))
	(if (= ch 160)
	    (progn
	      (setq i (1+ i))
	      (setq ch (- (aref str i) ch))
	      (aset buf j ch)
	      (setq i (1+ i) j (1+ j)))
	  (setq ch (- ch 32))
	  (setq k (char-bytes ch))
	  (aset buf j ch)
	  (setq i (1+ i) j (1+ j))
	  (while (> k 1)
	    (aset buf j (aref str i))
	    (setq i (1+ i) j (1+ j) k (1- k))))))
    (substring buf 0 j)))

(defun compose-region (start end)
  "Compose characters in the current region into one composite character."
  (interactive "r")
  ;; This function heavily depends on internal representation of characters.
  (let* ((buf (buffer-substring start end))
	 (len (length buf))
	 (ch (char-after start))
	 i mc-flag)
    (if (= ch lc-composite)
	nil
      (save-excursion
	(goto-char start)
	(delete-region start end)
	(insert lc-composite)
	(setq i 0)
	(while (< i len)
	  (setq ch (aref buf i))
	  (cond ((or (<= ch 32) (= ch 127) (= ch lc-composite))
		 (insert (substring buf i))
		 (setq i len))
		((< ch 128) (insert 160 (+ ch 128)))
		((< ch 160) (insert (+ ch 32)))
		(t (insert ch)))
	  (setq i (1+ i)))))))

(defun decompose-region (start end)
  "De-compose characters in the current region into one composite character."
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (let ((lc-composite-str (char-to-string lc-composite))
	  p ch str)
      (while (search-forward lc-composite-str nil t)
	(goto-char (1- (point)))
	(setq p (point))
	(forward-char 1)
	(setq str (buffer-substring p (point)))
	(delete-region p (point))
	(insert (decompose-string str))))))

;; 93.7.16 by K.Wakamiya
(defun find-charset-region (start end)
  "Return a list of leading-chars in the region between START and END."
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (let ((re-official "[^\000-\177\232-\235\240-\377")
	    (re-private "\\|[\232-\235][^\000-\237")
	    lclist lc mc-flag)
	(while (re-search-forward (concat re-official "]" re-private "]")
				  nil t)
	  (setq lc (preceding-char))
	  (if (< lc ?\240)		;0xA0
	      (setq re-official (concat re-official (char-to-string lc)))
	    (setq re-private (concat re-private (char-to-string lc))))
	  (setq lclist (cons lc lclist)))
	lclist))))

(defun find-charset-string (string)
  "Return a list of leading-chars in the string."
  (let ((re-official "[^\000-\177\232-\235\240-\377")
	(re-private "\\|[\232-\235][^\000-\237")
	(idx 0)
	lclist lc mc-flag)
    (while (string-match (concat re-official "]" re-private "]") string idx)
      (setq idx (match-end 0)
	    lc (aref string (1- idx)))
      (if (< lc ?\240)			;0xA0
	  (setq re-official (concat re-official (char-to-string lc)))
	(setq re-private (concat re-private (char-to-string lc))))
      (setq lclist (cons lc lclist)))
    lclist))
