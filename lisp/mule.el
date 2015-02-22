;; Basic multilingual commands for Mule
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

;;; 87.6.15  created by K.Handa
;;; 87.6.24  modified by K.Handa & H.Nakahara<a32275@tansei.u-tokyo.junet>
;;; 88.1.18  modified for Nemacs Ver.2.0 by K.Handa
;;; 88.6.19  modified for Nemacs Ver.2.1 by K.Handa
;;; 89.3.14  modified for Nemacs Ver.3.0 by K.Handa
;;; 89.11.17 modified for Nemacs Ver.3.2 by K.Handa and S.Tomura
;;; 90.2.28  modified for Nemacs Ver.3.3.1 by K.Handa
;;; 90.6.6   modified for Nemacs Ver.3.3.2 by K.Handa
;;; 92.3.5   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.3.17  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;;;	Move difinition of mule-keymap from mule-util.el to here.
;;;	If write-region is called interactively with prefix arg,
;;;	user is asked coding-system.
;;; 92.3.18  modified for Mule Ver.0.9.1 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	In load, loadablep is called with 'nosuffix' argument.
;;; 92.4.3   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
;;;	The way of handling code-priority changed.
;;; 92.4.7   modified for Mule Ver.0.9.3 by P.Hammarlund <perham@nada.kth.se>
;;;	Document of insert-file-contents-pre-hook revised.
;;; 92.4.17 modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
;;;	Cope with new coding-system form.
;;; 92.4.30  modified for Mule Ver.0.9.4
;;;	by K.Handa <handa@etl.go.jp> and T.Enami <enami@sys.ptg.sony.co.jp>
;;;	call-process-hook returns cons of coding-systems for input and output.
;;;	call-process converts ARGS according to coding-system.
;;;	call-process-region-hook is deleted.
;;; 92.5.18  modified for Mule Ver.0.9.4
;;;		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;;	Non-subprocess systems are concerned.
;;; 92.5.18  modified for Mule Ver.0.9.4 by Y.Niibe <gniibe@mri.co.jp>
;;;	In set-keyboard-coding-system, typemis is fixed.
;;; 92.5.22  modified for Mule Ver.0.9.4
;;;	by Manabu HIGASHIDA <manabu@sigmath.osaka-u.ac.jp>
;;;	read-coding-system call completing-read with REQUIRE-MATCH t.
;;; 92.5.28  modified for Mule Ver.0.9.4
;;;	by T.Maebashi <maebashi@mcs.meitetsu.co.jp>
;;;	set-display-coding-system calls redraw-display.
;;; 92.6.26  modified for Mule Ver.0.9.5 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	Funtion load is modified so that it 'eval's a file contents
;;;	in the current buffer.
;;; 92.7.2  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Function string-to-char-list is moved to mule-util.el.
;;; 92.7.10  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Several definition in *predefined-category* changed.
;;; 92.7.13  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Message of "load" is "LOADING..." when loading a .el file.
;;; 92.7.14  modified for Mule Ver.0.9.5 by T.Ito <toshi@his.cpl.melco.co.jp>
;;;	Unnecessary '*' in comments of variables deleted.
;;; 92.7.20  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	In the mode-list-format, if mc-flag is nil '-' is shown.
;;; 92.9.10  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	make-coding-system accepts extended leading-char.
;;; 92.9.18  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	If code-convert-string in call-process fails, original args are used.
;;; 92.9.30  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	Variable file-coding-system-for-read-not-found is deleted.
;;; 92.10.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	Staffs of private character set are moved from mule-util.el.
;;;	x-default-fonts and x-default-encoding are declared.
;;; 92.11.4  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	regexp-search-forward is deleted.
;;; 92.11.19 modified for Mule Ver.0.9.6 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	write-region does not have to call set-file-coding-system.
;;; 92.12.4  modified for Mule Ver.0.9.7 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	load should signal error on syntax error.
;;; 92.12.16 modified for Mule Ver.0.9.7
;;;			by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;;	In load, temporaly buffer should have fundamental-mode.
;;; 92.12.17 modified for Mule Ver.0.9.7 by Y.Niibe <gniibe@mri.co.jp>
;;;	Preliminary support (92.8.2) for right-to-left languages.
;;; 92.12.25 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	Now, coding-system is a symbol.
;;; 92.12.31 modified for Mule Ver.0.9.7.1 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	Document of make-coding-system fixed.
;;; 93.2.10  modified for Mule Ver.0.9.7.1
;;;				by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	In call-process-region, delete temp file only if necessary.
;;; 93.3.9   modified for Mule Ver.0.9.7.1
;;;				by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	In insert-file-contents, insert-file-contents-error-hook should
;;;	be given error info.
;;;	In insert-file-contents, now it's hook function's responsibility
;;;	to set file-coding-system of the buffer.
;;;	In load, default-major-mode should not be bound while loading.
;;; 93.3.15  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	insert-file-contents accepts optional third arg CODING-SYSTEM.
;;;	In load, call insert-file-contents instead of si:insert-file-contents.
;;; 93.3.23  modified for Mule Ver.0.9.7.1 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	In make-coding-system, document corrected.
;;; 93.4.16  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	get-code-mnemonic returns ?? for invalid coding-system.
;;;	New function set-file-coding-system-for-read.
;;; 93.4.29  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	CNS11643 support.
;;; 93.5.2   modified for Mule Ver.0.9.8 by P.Hammarlund <perham@nada.kth.se>
;;;	Make sure that byte compiled elc files are read up
;;;	without code conversion.
;;; 93.5.14  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	make-coding-system accepts EOL type instead of CRLF flag.
;;;	CCL support.
;;; 93.5.25  modified for Mule Ver.0.9.8
;;;				by T.Atsushiba <toshiki@jit.dec-j.co.jp>
;;;	'load' is modified for case insensitive system.
;;; 93.6.1   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	insert-file-contents handles post-read-conversion,
;;;	write-region handles pre-write-conversion
;;;	call-process-region returns 'status'.
;;; 93.6.15  modified for Mule Ver.0.9.8 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	In write-region, temporary buffer should be killed.
;;; 93.6.25  modified for Mule Ver.0.9.8 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	'mule is provided.
;;; 93.6.30  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	*iso-2022-ss2-7* uses short-form.
;;; 93.7.8   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	write-region udpate modtime when pre-write-conversion exists.
;;; 93.7.8   modified for Mule Ver.0.9.8 by
;;;				N.Demizu <nori-d@is.aist-nara.ac.jp>
;;;	insert-file-contents-access-hook is added.
;;; 93.7.12  modified for Mule Ver.0.9.8 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	save-protected-local-variables modified
;;; 93.7.16  modified for Mule Ver.0.9.8 by S.Tomura <tomura@etl.go.jp>
;;;	byte-compile-special -> byte-hunk-handler for bytecomp-2.0x.
;;; 93.7.17  modified for Mule Ver.0.9.8 by K.Hirokawa <hirokawa@rics.co.jp>
;;;	In call-prcess-region,  DISPLAY argument handled correctly.
;;; 93.7.23  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Alternative key definitions are done (spell-word, insert-parentheses).
;;; 93.7.29  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	*iso-2022-jp* is defined in the same way as *junet*.
;;; 93.12.1  modified for Mule Ver.1.1 by H.Minamino <minamino@sra.co.jp>
;;;	Definition of *iso-2022-lock* corrected.
;;; 93.12.16 modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	*euc-kr* is an alias for *euc-korean*.
;;; 94.2.23  modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Big change of coding-system handling.
;;; 94.3.8   modified for Mule Ver.1.1
;;;				by S.Narazaki <narazaki@csce.kyushu-u.ac.jp>
;;;	Bug in handling post-read-conversion/pre-write-conversion in
;;;	insert-file-contents/write-region are fixed.
;;; 94.3.8   modified for Mule Ver.1.1 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	call-process/start-process convert its argument by
;;;	code-convert-process-arguments.
;;; 94.3.9   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Bug in set-file-coding-system fixed.
;;; 94.3.10  modified for Mule Ver.1.1 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	In write-region, generate-new-buffer is used for pre-write-conversion.

(provide 'mule)				;93.6.25 by T.Enami

(defconst mule-version "1.1 (HAHAKIGI) PL01" "\
Version numbers of this version of Mule.")

(defconst mule-version-date "1994.3.10" "\
Distribution date of this version of Mule.")

(defun mule-version () "\
Return string describing the version of Mule that is running."
  (interactive)
  (if (interactive-p)
      (message "%s" (mule-version))
    (format "Mule Version %s of %s" mule-version mule-version-date)))
  
(defvar mule-keymap (make-sparse-keymap) "Keymap for Mule specific commands.")
(fset 'mule-prefix mule-keymap)

(define-key ctl-x-map "\C-k" 'mule-prefix)

;; 93.7.23 by K.Handa
;; Alternative key definitions
;; Original mapping will be altered by set-keyboard-coding-system.
(define-key esc-map "#" 'spell-word)	;originally "$"
(define-key esc-map "{" 'insert-parentheses) ;originally "("

(defvar mc-verbose-code nil
  "*non nil means display mnemonics of file-coding-system,
keyboard-coding-system, and display-coding-system on mode line.
Nil means display only mnemonics of file-coding-system.")

(setq-default mode-line-buffer-identification '("Mule: %15b"))

(setq-default
 mode-line-format
 (cons (purecopy "")
       (cons '(mc-verbose-code "%C" "%c")
	     (cons '(mc-flag ":" "-") (default-value 'mode-line-format)))))

;; Big change by T.Enami
(defun load (str &optional noerror nomessage nosuffix)
  "Execute a file of Lisp code named FILE.
First tries FILE with .elc appended, then tries with .el,
 then tries FILE unmodified.  Searches directories in load-path.
If optional second arg NOERROR is non-nil,
 report no error if FILE doesn't exist.
Print messages at start and end of loading unless
 optional third arg NOMESSAGE is non-nil.
If optional fourth arg NOSUFFIX is non-nil, don't try adding
 suffixes .elc or .el to the specified name FILE.
Return t if file exists."
  (let ((file (substitute-in-file-name str)))
    (if (or (<= (length file) 0)
	    ;; 92.3.18 by T.Enami
	    ;; (null (setq file (loadablep file)))
	    (null (setq file (loadablep file nosuffix)))
	    )
	(if noerror nil
	  (error "Cannot open load file %s" str))
					; 92.12.16 by H.Manabu
      (let* ((buffer			; 93.3.15 by T.Enami
	      (let ((default-major-mode 'fundamental-mode))
		(generate-new-buffer " *load-temp*")))
	     (load-in-progress t)
	     (elc (string= ".elc" (downcase ; 93.5.24 by T.Atsushiba
				   (substring file -4))))) ; 92.7.13 by K.Handa
	(or nomessage (message (if elc "Loading %s..." "LOADING %s...") str))
	(unwind-protect
	    (eval
	     (save-excursion
	       (set-buffer buffer)
	       (insert "(progn\n\n)")
	       (forward-line -1)
	       ;; 92.7.13, 93.3.15 by K.Handa, 93.5.2 by P.Hammarlund
	       (if elc
		   (let (insert-file-contents-pre-hook
			 insert-file-contents-error-hook
			 insert-file-contents-post-hook)
		     (insert-file-contents file nil *noconv*))
		 (insert-file-contents file nil *autoconv*))
	       (goto-char (point-min))
	       (prog1			;; 92.12.4 by T.Enami
		   (read (current-buffer))
		 (or (eobp)
		     (signal 'invalid-read-syntax '("may be extra `)'")) ))))
	  (kill-buffer buffer) )
	(or nomessage noninteractive	; 92.7.13 by K.Handa
	    (message (if elc "Loading %s...done" "LOADING %s...done") str)))
      t)))

;;;
;;;  Modification of kill-all-local-variables  by S.Tomura  89.12.15
;;;
;;;  protect specified local variables from kill-all-local-variables
;;;

(defconst *protected-local-variables* 
  '(mc-flag
    file-coding-system
    )
  "List of buffer local variables protected from 'kill-all-local-variables' ."
  )

(defun save-protected-local-variables (vlist)
  (let ((vlist vlist)
	(local-values (buffer-local-variables))	;93.7.12 by T.Enami
	(alist nil))
    (while vlist
      (let ((pair (assoc (car vlist) local-values)))
	(if pair
	    (setq alist (cons pair alist))))
      (setq vlist (cdr vlist)))
    alist))

(defun recover-protected-local-variables (alist)
  (let ((alist alist))
    (while alist
      (set (car (car alist)) (cdr (car alist)))
      (setq alist (cdr alist)))))

(if (null (fboundp 'si:kill-all-local-variables))
    (fset 'si:kill-all-local-variables
	  (symbol-function 'kill-all-local-variables)))

(defun kill-all-local-variables ()
  "Eliminate all the buffer-local variable values of the current buffer
except for variables in *protected-local-variables* of the current buffer.
This buffer will then see the default values of such variables."
  (let ((alist (save-protected-local-variables *protected-local-variables*)))
    ;;; We can use "buffer-local-variables". Which is better?
    (unwind-protect
	(si:kill-all-local-variables)
      (recover-protected-local-variables alist))))

(defvar self-insert-after-hook nil
  "Hook to run when extended self insertion command exits.  Should take
two arguments START and END corresponding to character position.")

(make-variable-buffer-local 'self-insert-after-hook)

(defun regexp-dump-all (pat)
  (regexp-dump (car pat))
  (regexp-dump (car (cdr pat)))
  (setq pat (cdr (cdr pat)))
  (while pat
    (regexp-dump (car (car pat)))
    (regexp-dump (cdr (car pat)))
    (setq pat (cdr pat))))

;; regexp-word-compile returns:
;;	((forward . backward)
;;	 (split1-forward . split1-backward)
;;	 ...)
;; define-word-pattern accepts:
;;	(forward backard split1-backward split1-forward ...)
(defun set-word-regexp (pattern)
  "One arg RE should be a compiled pattern created by 'regexp-word-compile."
  (let (l)
    (setq l (list (cdr (car pattern)) (car (car pattern))))
    (setq pattern (cdr pattern))
    (while pattern
      (setq l (cons (cdr (car pattern)) l))
      (setq l (cons (car (car pattern)) l))
      (setq pattern (cdr pattern)))
    (define-word-pattern (nreverse l))))

(defmacro define-word-regexp (name regexp)
  (` (defconst (, name) '(, (regexp-word-compile regexp)))))

(put 'define-word-regexp 'byte-hunk-handler ;93.7.16 by S.Tomura
     'macroexpand)

;; 92.9.13 by K.Handa
;; Private character-set staffs
(defun undefined-private-character-set (bytes column)
  "Return extended leading-char of undefined private character set of
BYTES (1 or 2) length and COLUMN (1 or 2) width."
  (let (lc lcmax)
    (cond ((= bytes 1)
	   (cond ((= column 1) (setq lc 160 lcmax 184))
		 ((= column 2) (setq lc 184 lcmax 192))))
	  ((= bytes 2)
	   (cond ((= column 1) (setq lc 192 lcmax 200))
		 ((= column 2) (setq lc 200 lcmax 224)))))
    (if lc
	(progn
	  (while (and (< lc lcmax) (character-set lc))
	    (setq lc (1+ lc)))
	  (if (< lc lcmax) lc)))))

;; 92.8.2 Y.Niibe add direction
(defun new-private-character-set (bytes column type graphic final dir doc)
  "Register new private character-set of
BYTES/COLUMN/TYPE/GRAPHIC/FINAL/DIRECTION/DOC (see also new-character-set).
The leading-char for the character-set is assigned automatically
not to conflict with another private sets.
It returns the leading-char or nil if no unused leading-char left."
  (let ((lc (undefined-private-character-set bytes column)))
    (if lc
	(progn
	  (new-character-set lc bytes column type graphic final dir doc)
	  lc))))
;; end of patch

;; 92.8.2 Y.Niibe add direction
(defconst *predefined-character-set*
  (list
   ;; (cons lc '(bytes width type graphic final direction doc))
   ;; (cons lc-ascii '(0 1 0 0 ?B 0 "ASCII")) ;; Predefined in C file
   (cons lc-ltn1 '(1 1 1 1 ?A 0 "ISO8859-1 Latin-1"))
   (cons lc-ltn2 '(1 1 1 1 ?B 0 "ISO8859-2 Latin-2"))
   (cons lc-ltn3 '(1 1 1 1 ?C 0 "ISO8859-3 Latin-3"))
   (cons lc-ltn4 '(1 1 1 1 ?D 0 "ISO8859-4 Latin-4"))
   (cons lc-grk '(1 1 1 1 ?F 0 "ISO8859-7 Greek"))
   (cons lc-arb '(1 1 1 1 ?G 1 "ISO8859-6 Arabic"))
   (cons lc-hbw '(1 1 1 1 ?H 1 "ISO8859-8 Hebrew"))
   (cons lc-kana '(1 1 0 1 ?I 0 "JIS X0201 Japanese Katakana"))
   (cons lc-roman '(1 1 0 0 ?J 0 "JIS X0201 Japanese Roman"))
   (cons lc-crl '(1 1 1 1 ?L 0 "ISO8859-5 Cyrillic"))
   (cons lc-ltn5 '(1 1 1 1 ?M 0 "ISO8859-9 Latin-5"))
   (cons lc-jpold '(2 2 2 0 ?@ 0 "JIS X0208-1976 Japanese Old"))
   (cons lc-cn '(2 2 2 0 ?A 0 "GB 2312-1980 Chinese"))
   (cons lc-jp '(2 2 2 0 ?B 0 "JIS X0208 Japanese"))
   (cons lc-kr '(2 2 2 0 ?C 0 "KS C5601-1987 Korean"))
   (cons lc-jp2 '(2 2 2 0 ?D 0 "JIS X0212 Japanese Supplement"))
   (cons lc-cns1 '(2 2 2 0 ?G 0 "CNS 11643 Set 1"))
   (cons lc-cns2 '(2 2 2 0 ?H 0 "CNS 11643 Set 2"))
   (cons lc-big5-1 '(2 2 2 0 ?0 0 "Big5 Level 1"))
   (cons lc-big5-2 '(2 2 2 0 ?1 0 "Big5 Level 2"))
   (cons lc-cns14 '(2 2 2 0 ?2 0 "CNS 11643 Set 14"))))

(let ((c *predefined-character-set*)
      lc data)
  (while c
    (setq lc (car (car c))
	  data (cdr (car c)))
    (apply 'new-character-set lc data)
    (setq c (cdr c))))

(defmacro define-category (mnemonic char doc)
  "Make MNEMONIC as a new category mnemonic with description DOC,
 and modify category of CHAR so that it contains MNEMONIC.
CHAR may be a list of 1-byte codes.
	(define-category mnemonic char doc)
is equal to:
	(progn
	  (define-category-mnemonic mnemonic doc)
	  (modify-category-entry char mnemonic))"
  (list 'progn
	(list 'define-category-mnemonic mnemonic doc)
	(list 'modify-category-entry char mnemonic)))

(defconst *predefined-category*
  ;; 92.7.10 by K.Handa -- several definition changed.
  (list (list lc-ltn1 ?l "Latin character.")
	(list lc-ltn2 ?l "Latin character.")
	(list lc-ltn3 ?l "Latin character.")
	(list lc-ltn4 ?l "Latin character.")
	(list lc-ltn5 ?l "Latin character.")
	(list lc-grk ?g "Greek character.")
	(list lc-arb ?b "Arabic character.")
	(list lc-hbw ?w "Hebrew character.")
	(list lc-kana ?k "Japanese 1-byte Katakana character.")
	(list lc-roman ?r "Japanese 1-byte Roman character.")
	(list lc-crl ?y "Cyrillic character.")
	(list lc-cn ?c "Chinese 2-byte character.")
	(list lc-jp ?j "Japanese 2-byte character.")
	(list lc-kr ?h "Hungul 2-byte character.")
	(list lc-big5-1 ?t "Big5 Level 1.")
	(list lc-big5-2 ?t "Big5 Level 2.")
	)
  "List of predefined categories.
Each element is a list of leading-character, mnemonic, and description")

(let (i l)
  (define-category-mnemonic ?a "Ascii character.")
  (setq i ? )
  (while (< i 127)
    (modify-category-entry i ?a)
    (setq i (1+ i)))
  (setq l *predefined-category*)
  (while l
    (define-category-mnemonic (nth 1 (car l)) (nth 2 (car l)))
    (modify-category-entry (car (car l)) (nth 1 (car l)))
    (setq l (cdr l))))

;;; At the present, I know Japanese and Chinese text can
;;; break line at any point under a ristriction of 'kinsoku'.
(defvar word-across-newline "\\(\\cj\\|\\cc\\)"
  "Regular expression of such characters which can be a word across newline.")

;; Coding-sytem staffs

;; 92.12.18 by K.Handa
;; Coding-system object is a symbol which has "coding-system" property.
;; The value of the property is a vector of
;; [TYPE MNEMONIC DOCUMENT EOLTYPE FLAGS].

(defun get-code (code)
  (while (and code (symbolp code))
    (setq code (get code 'coding-system)))
  code)
(defun get-code-type (code) (aref (get-code code) 0))
(defun get-code-mnemonic (code)
  (cond ((null code) ?-)
	((coding-system-p code) (aref (get-code code) 1))
	(t ??)))
(defun get-code-document (code) (aref (get-code code) 2))
(defun get-code-flags (code) (aref (get-code code) 4))
(defun get-code-eol (code) (get code 'eol-type))
(defun get-eol-mnemonic (code)
  (setq code (get-code-eol code))
  (cond ((null code) ?-)
	((vectorp code) ?_)
	((eq code 1) ?.)
	((eq code 2) ?:)
	((eq code 3) ?')
	(t ??)))
(defun make-coding-system (name type mnemonic doc
				&optional eol-type flags)
  "Register symbol NAME as a coding-system of:
 TYPE, MNEMONIC, DOC, EOL-TYPE, FLAGS.
 TYPE is information for encoding or decoding.  If it is one of below,
	nil: no conversion, t: automatic conversion,
	0:Internal, 1:Shift-JIS, 2:ISO2022, 3:Big5.
  the system provides appropriate code conversion facility.  If TYPE is 4, 
  appropriate code conversion programs (CCL) should be supplied in FLAGS.
 MNEMONIC: a character to be displayed on mode-line for this coding-system,
 DOC: a describing documents for the coding-system,
 EOL-TYPE (option): specify type of end-of-line,
   nil: no-conversion, 1: LF, 2: CRLF, 3: CR,
   t: generate coding-system for each end-of-line type
      by names NAMEunix, NAMEdos, and NAMEmac
 FLAGS (option): more precise information about the coding-system,
If TYPE is 2 (ISO2022), FLAGS should be a list of:
 LC-G0, LC-G1, LC-G2, LC-G3:
	Leading character of charset initially designated to G? graphic set,
	nil means G? is not designated initially,
	lc-invalid means G? can never be designated to,
	if (- leading-char) is specified, it is designated on output,
 SHORT: non-nil - allow such as \"ESC $ B\", nil - always \"ESC $ \( B\",
 ASCII-EOL: non-nil - designate ASCII to g0 at each end of line on output,
 ASCII-CNTL: non-nil - designate ASCII to g0 before TAB and SPACE on output,
 SEVEN: non-nil - use 7-bit environment on output,
 LOCK-SHIFT: non-nil - use locking-shift (SO/SI) instead of single-shift
	or designation by escape sequence,
 USE-ROMAN: non-nil - designate JIS0201-1976-Roman instead of ASCII,
 USE-OLDJIS: non-nil - designate JIS0208-1976 instead of JIS0208-1983,
 NO-ISO6429: non-nil - don't use ISO6429's direction specification,
If TYPE is 3 (Big5), FLAGS T means Big5-ETen, NIL means Big5-HKU,
If TYPE is 4 (private), FLAGS should be a cons of CCL programs,
 for encoding and decoding.  See documentation of CCL for more detail."
  (set name name)
  (let ((code (make-vector 5 nil)))
    (aset code 0 type)
    (aset code 1 (if (and (> mnemonic ? ) (< mnemonic 127)) mnemonic ? ))
    (aset code 2 (if (stringp doc) doc ""))
    (aset code 3 nil)
    (cond ((eq type 2)
	   (let ((i 0)
		 (vec (make-vector 32 nil)))
	     (while (and (< i 32) flags)
	       (aset vec i (car flags))
	       (setq flags (cdr flags) i (1+ i)))
	     (aset code 4 vec)))
	  ((eq type 4)
	   (if (and (consp flags)
		    (stringp (car flags))
		    (stringp (cdr flags)))
	       (aset code 4 flags)
	     (error "Invalid FLAGS argument for TYPE 4 (private)")))
	  (t (aset code 4 flags)))
    (put name 'coding-system code)
    (if (or (null eol-type) (eq eol-type 1) (eq eol-type 2) (eq eol-type 3))
	(put name 'eol-type eol-type)
      (if (eq eol-type t)
	  (let ((codings (vector (intern (format "%sunix" name))
				 (intern (format "%sdos" name))
				 (intern (format "%smac" name))))
		(i 0))
	    (put name 'eol-type codings)
	    (while (< i 3)
	      (set (aref codings i) (aref codings i))
	      (put (aref codings i) 'coding-system name)
	      (put (aref codings i) 'eol-type (+ i 1))
	      (setq i (1+ i))))
	(error "Invalid eol-type %s" eol-type)))
    ))

(defun copy-coding-system (from to)
  "Make the same coding-system as ORIGINAL and name it ALIAS.
If 'eol-type property of ORIGINAL is a vector, coding-systems
ALIASunix, ALIASdos, or ALIASmac are generated, and 'eol-type property
of ALIAS becomes a vector of them."
  (set to to)
  (put to 'coding-system from)
  (let ((eol-type (get from 'eol-type)))
    (if (numberp eol-type)
	(put to 'eol-type eol-type)
      (if (and (vectorp eol-type) (= (length eol-type) 3))
	  (let ((codings (vector (intern (format "%sunix" to))
				 (intern (format "%sdos" to))
				 (intern (format "%smac" to))))
		(i 0))
	    (put to 'eol-type codings)
	    (while (< i 3)
	      (set (aref codings i) (aref codings i))
	      (put (aref codings i) 'coding-system to)
	      (put (aref codings i) 'eol-type (+ i 1))
	      (setq i (1+ i))))
	(error "Invalid eol-type %s in %s" eol-type from)))))

(defun set-file-coding-system (coding-system &optional force)
  (interactive "zFile-coding-system: \nP")
  (check-coding-system coding-system)
  ;; 94.2.10 by K.Handa
  (if (null force)
      (let ((x (get-code-eol file-coding-system))
	    (y (get-code-eol coding-system)))
	(if (and (numberp x) (>= x 1) (<= x 3) y (vectorp y))
	    (setq coding-system (aref y (1- x)))))) ;94.3.9 by K.Handa
  ;; end of patch
  (setq file-coding-system coding-system)
  (update-mode-lines))

(defun set-display-coding-system (coding-system)
  (interactive "zDisplay-coding-system: ")
  (check-coding-system coding-system)
  (setq display-coding-system coding-system)
  (update-mode-lines)
  (if (interactive-p) (redraw-display))) ;; 92.5.28 by T. Maebashi

(defun set-keyboard-coding-system (coding-system)
  (interactive "zKeyboard-coding-system: ")
  (check-coding-system coding-system)
  (setq keyboard-coding-system coding-system)
  (update-mode-lines))

(defun set-current-process-coding-system (input output)
  (interactive
   "zCoding-system for process input: \nzCoding-system for process output: ")
  (let ((proc (get-buffer-process (current-buffer))))
    (if (null proc)
	(error "no process")
      (check-coding-system input)
      (check-coding-system output)
      (set-process-coding-system proc input output)))
  (update-mode-lines))

(defun set-file-coding-system-for-read (coding-system)
  (interactive "zFile-coding-system-for-read: ")
  (check-coding-system coding-system)
  (setq file-coding-system-for-read coding-system))

;; Definitions of predefined coding-systems

(make-coding-system
 '*noconv* nil
 ?= "No conversion.")

(make-coding-system
 '*autoconv* t
 ?+ "Automatic conversion." t)

(make-coding-system
 '*internal* 0
 ?= "Internal coding-system used in a buffer.")

(make-coding-system
 '*sjis* 1
 ?S "Coding-system of Shift-JIS used in Japan." t)

(make-coding-system
 '*iso-2022-jp* 2
 ?J "Coding-system used for communication with mail and news in Japan."
 t
 (list lc-ascii lc-invalid lc-invalid lc-invalid
       'short 'ascii-eol 'ascii-cntl 'seven))
(copy-coding-system '*iso-2022-jp* '*junet*)

(make-coding-system
 '*oldjis* 2
 ?J "Coding-system used for old jis terminal."
 t
 (list lc-ascii lc-invalid lc-invalid lc-invalid
       'short 'ascii-eol 'ascii-cntl 'seven nil 'use-roman 'use-oldjis))

(make-coding-system
 '*ctext* 2
 ?X "Coding-system used in X as Compound Text Encoding."
 1
 (list lc-ascii lc-ltn1 lc-invalid lc-invalid
       nil 'ascii-eol))

(make-coding-system
 '*euc-japan* 2
 ?E "Coding-system of Japanese EUC (Extended Unix Code)."
 t
 (list lc-ascii lc-jp lc-kana lc-jp2
       'short 'ascii-eol 'ascii-cntl))

(make-coding-system
 '*euc-korea* 2
 ?K "Coding-system of Korean EUC (Extended Unix Code)."
 1
 (list lc-ascii lc-kr lc-invalid lc-invalid
       nil 'ascii-eol 'ascii-cntl))
;; 93.12.16 by K.Handa
(copy-coding-system '*euc-korea* '*euc-kr*)

(make-coding-system
 '*iso-2022-kr* 2
 ?k "Coding-System used for communication with mail in Korea."
 1
 (list lc-ascii (- lc-kr) lc-invalid lc-invalid
       nil 'ascii-eol 'ascii-cntl 'seven 'lock-shift))
(copy-coding-system '*iso-2022-kr* '*korean-mail*)

(make-coding-system
 '*euc-china* 2
 ?C "Coding-system of Chinese EUC (Extended Unix Code)."
 1
 (list lc-ascii lc-cn lc-invalid lc-invalid
       nil 'ascii-eol 'ascii-cntl))

(make-coding-system
 '*iso-2022-ss2-8* 2
 ?I "ISO-2022 coding system using SS2 for 96-charset in 8-bit code."
 t
 (list lc-ascii lc-invalid nil lc-invalid
       nil 'ascii-eol 'ascii-cntl))

(make-coding-system
 '*iso-2022-ss2-7* 2
 ?I "ISO-2022 coding system using SS2 for 96-charset in 7-bit code."
 t
 (list lc-ascii lc-invalid nil lc-invalid
       'short 'ascii-eol 'ascii-cntl 'seven))

(make-coding-system
 '*iso-2022-lock* 2
 ?i "ISO-2022 coding system using Locking-Shift for 96-charset."
 t
 (list lc-ascii nil lc-invalid lc-invalid
       nil 'ascii-eol 'ascii-cntl 'seven
       'lock-shift))			;93.12.1 by H.Minamino

(make-coding-system
 '*big5-eten* 3
 ?B "Coding-system of BIG5-ETen."
 t t)

(make-coding-system
 '*big5-hku* 3
 ?B "Coding-system of BIG5-HKU."
 t nil)

(defvar default-process-coding-system (cons *autoconv*unix nil)
  "Cons of default values used to receive from and send to process.")

(defvar file-coding-system-for-read *autoconv*
  "Coding-system used for reading a file.")

;; 94.2.5 by K.Handa
;; Priority of coding-system concerned while detecting coding-system.

(defun coding-priority< (x y)
  (let ((xp (get x 'priority))
	(yp (get y 'priority)))
    (if xp (if yp (< xp yp)) (if yp t))))

(defun set-coding-priority (arg)
  "Set priority of coding-category according to LIST.
LIST is a list of following symbols of coding-category
 ordered according to priority"
  (let ((l (list '*coding-category-internal*
		 '*coding-category-sjis*
		 '*coding-category-iso-7*
		 '*coding-category-iso-8-1*
		 '*coding-category-iso-8-2*
		 '*coding-category-iso-else*
		 '*coding-category-big5*
		 '*coding-category-bin*))
	(i 0))
    (setq l (sort l 'coding-priority<))
    (while arg
      (if (null (memq (car arg) l))
	  (error "Invalid element in argument: %s" (car arg))
	(put (car arg) 'priority i)
	(setcar (memq (car arg) l) nil))
      (setq arg (cdr arg))
      (setq i (1+ i)))
    (while l
      (if (car l)
	  (progn
	    (put (car l) 'priority i)
	    (setq i (1+ i))))
      (setq l (cdr l)))
    (set-coding-priority-internal)
    ))

(set-coding-priority
 '(*coding-category-iso-8-2*
   *coding-category-sjis*
   *coding-category-iso-8-1*
   *coding-category-big5*
   *coding-category-iso-7*
   *coding-category-iso-else*
   *coding-category-bin*
   *coding-category-internal*))

(defvar *coding-category-internal* '*internal*)
(defvar *coding-category-sjis* '*sjis*)
(defvar *coding-category-iso-7* '*junet*)
(defvar *coding-category-iso-8-1* '*ctext*)
(defvar *coding-category-iso-8-2* '*euc-japan*)
(defvar *coding-category-iso-else* '*iso-2022-ss2-7*)
(defvar *coding-category-big5* '*big5-eten*)
(defvar *coding-category-bin* '*noconv*)

;;; FILE I/O

(defun local-file-coding-system-p ()
  "Return t if file-coding-system is set locally in the current buffer."
  (let ((coding-system (default-value 'file-coding-system)))
    (setq-default file-coding-system 'temp-value)
    (prog1 (null (eq (default-value 'file-coding-system) file-coding-system))
      (setq-default file-coding-system coding-system))))

(defvar insert-file-contents-access-hook nil
  "A hook function to make the file accessible before inserting file.")

(defvar insert-file-contents-pre-hook nil
  "A hook function to decide coding-system used for reading.

Before reading the file, the function insert-file-contents evaluates
the hook with arguments FILENAME and VISIT [same as those given to
insert-file-contents].  In this functions, you may refer to the global
variable file-coding-system-for-read (See documentation).

The return value of this function should be a coding-system (*not* one
of the symbols *euc-japan*, ...) used for reading the file or a list.
If the return value is a list, insert-file-contents assumes that the
function has inserted the file for itself and supresses further
reading and just returns this list.  The elements of list should be
abosolute pathname and length of data inserted.")

(defvar insert-file-contents-error-hook nil
  "A hook function to set file-coding-system of the current buffer.

On file-error while reading, insert-file-contents calls it with arguments
 FILENAME, VISIT [same as those given to insert-file-contents],
 and a cons (SIGNALED-CONDITIONS . SIGNAL-DATA).
Usually this is the case of the file not existing.
The error condition propagets to the caller of insert-file-contents.")

;; 93.7.8 by N.Demizu
(defvar insert-file-contents-post-hook nil
  "A hook function to set file-coding-system of the current buffer.

After successful reading, insert-file-contents calls it with arguments
 FILENAME, VISIT [same as those given to insert-file-contents],
 and RETURN-VALUE of si:insert-file-contents, which is a list of:
 coding-system used for reading, absoule pathname, length of data inserted.")

;; 93.3.15 by K.Handa -- add optional third arg CODING-SYSTEM
(defun insert-file-contents (filename &optional visit coding-system)
  "Insert contents of file FILENAME after point.
Returns list of absolute pathname and length of data inserted.
If second argument VISIT is non-nil, the buffer's visited filename
and last save file modtime are set, and it is marked unmodified.
If visiting and the file does not exist, visiting is completed
before the error is signaled.
Optional third argument CODING-SYSTEM specify the coding-system for reading,
 and defaults to the value of file-coding-system-for-read.
If current buffer's file-coding-system is nil,
 it is set to the coding-system which is actually used for reading.
See also insert-file-contents-pre-hook, insert-file-contents-error-hook,
 insert-file-contents-post-hook, and si:insert-file-contents."
  (let (return-val)
    (condition-case err
	(progn
	  (if insert-file-contents-access-hook ; 93.7.8 by N.Demizu
	      (funcall insert-file-contents-access-hook filename visit))
	  (setq coding-system
		(cond (insert-file-contents-pre-hook
		       (funcall insert-file-contents-pre-hook filename visit))
		      (coding-system coding-system)
		      (t file-coding-system-for-read)))
	  (if (consp coding-system) nil
	    (if (null (coding-system-p coding-system))
		(progn
		  (message "Invalid coding-system (%s), use *noconv* instead.")
		  (setq coding-system *noconv*)))
	    (setq return-val
		  (si:insert-file-contents filename visit coding-system))))
      (file-error
       (if insert-file-contents-error-hook
	   ;; 93.3.9 by T.Enami
	   (funcall insert-file-contents-error-hook filename visit err))
       (signal (car err) (cdr err))))
    (if (consp coding-system)
	coding-system
      (if insert-file-contents-post-hook
	  ;; 93.3.9 by T.Enami
	  (funcall insert-file-contents-post-hook filename visit return-val)
	(setq coding-system (car return-val))
	(if (get coding-system 'post-read-conversion)
	    (unwind-protect
		(save-excursion
		  (let (buffer-read-only) ;94.3.8 by S.Narazaki
		    (funcall (get coding-system 'post-read-conversion)
			     (point) (+ (point) (nth 2 return-val)))))
	      (if visit
		  (progn
		    (set-buffer-auto-saved)
		    (set-buffer-modified-p nil)))))
	(if (and coding-system ;; something found
		 (or
		  ;; no coding-system for this buffer
		  (null file-coding-system)
		  ;; still in auto-conversion mode
		  (eq (aref (get-code file-coding-system) 0) t)
		  ;; no local coding-system for this buffer
		  (null (local-file-coding-system-p))))
	    (set-file-coding-system coding-system)))
      (cdr return-val))))

(defvar write-region-pre-hook nil
  "A hook function to decide coding system used for writing to file.

Before writing, write-region calls it with arguments
 START, END, FILENAME, APPEND, VISIT and CODING-SYSTEM [same as those
 given to write-region].
The return value of this function should be a coding-system or a list.
 If list, write-region supresses further writing.  The elements of list
 should be a return value of write-region (i.e. list of an abosolute pathname
 and length of data written).")

(defvar write-region-post-hook nil
  "A hook function called from write-region after writing.

Called with arguments START, END, FILENAME, APPEND, VISIT,
 and CODING-SYSTEM [same as those given to write-region]")

(defun write-region (start end filename &optional append visit coding-system)
  "Write current region into specified file.
When called from a program, takes three arguments:
START, END and FILENAME.  START and END are buffer positions.
Optional fourth argument APPEND if non-nil means
  append to existing file contents (if any).
Optional fifth argument VISIT if t means
  set last-save-file-modtime of buffer to this file's modtime
  and mark buffer not modified.
If VISIT is neither t nor nil, it means do not print
  the \"Wrote file\" message.
Optional sixth argument CODING-SYSTEM specify the coding-system for writing,
 and defaults to file-coding-system of the current buffer.
If called interactively with prefix arg, user is asked conding-system.
See also write-region-pre-hook, write-region-post-hook,
 and si:write-region."
  (interactive "r\nFWrite region to file: \ni\ni\nZCoding-system: ")
  (setq coding-system
	(cond (write-region-pre-hook
	       (funcall write-region-pre-hook
			start end filename append visit coding-system))
	      (coding-system coding-system)
	      (t file-coding-system)))
  (if (consp coding-system)
      coding-system
    (if (get coding-system 'pre-write-conversion)
	(let ((curbuf (current-buffer))
	      ;;94.3.10 by T.Enami
	      (tempbuf (generate-new-buffer " *temp-write-buffer*"))
	      (modif (buffer-modified-p)))
	  (unwind-protect
	      (save-excursion
		(set-buffer tempbuf)
		(erase-buffer)
		(insert-buffer-substring curbuf start end)
		(funcall (get coding-system 'pre-write-conversion)
			 (point-min) (point-max))
		(si:write-region (point-min) (point-max) filename append
				 ;; 94.3.8 by S.Narazaki
				 (if (eq visit t) nil visit)
				 coding-system))
	    ;; 93.6.15 by T.Enami
	    ;; leaving a buffer associated with file cause problem
	    ;; when next visiting.
	    (kill-buffer tempbuf)
	    (if (or visit (null modif))
		(progn
		  (set-buffer-auto-saved)
		  (set-buffer-modified-p nil)
		  ;; 94.3.8 by S.Narazaki
		  (if (buffer-file-name) (update-visited-file-modtime))))))
      (si:write-region start end filename append visit coding-system))
    ;; (set-file-coding-system coding-system) ;92.11.19 by T.Enami
    (if write-region-post-hook
	(funcall write-region-post-hook
		 start end filename append visit coding-system))))

;;; process

;; 94.3.8 by T.Enami
(defun code-convert-process-arguments (arguments coding-systems)
  "Convert the code of ARGUMENTS passed to the process  using
input coding-system of CODINGS-SYSTEMS.  If you never wants to convert
code of arguments, define this function just to return ARGUMENTS."
  (mapcar (function (lambda (arg)	;92.9.18 by K.Handa
		      (or (code-convert-string arg *internal*
					       (cdr coding-systems))
			  arg)))
	  arguments))

;; 92.4.28 by K.Handa and T.Enami
;; This hook should return cons normally.  And, arguments changed.
(defvar call-process-hook nil
  "A hook function to decide coding-systems for calling programs.
Before calling programs, call-process and call-process-region call
 this function with arguments PROGRAM, BUFFER, START, END and ARGS,
 where START and END are nil when called from call-process.
The return value of this function should be a cons of coding-systems
 for input and output of the program.  The input coding-system
 is also used for converting ARGS.
 If the value is not cons object, further calling is supressed.")

(defun call-process (program &optional infile buffer display &rest args)
  "Call PROGRAM in separate process.
Program's input comes from file INFILE (nil means /dev/null).
Insert output in BUFFER before point; t means current buffer;
 nil for BUFFER means discard it; 0 means discard and don't wait.
Fourth arg DISPLAY non-nil means redisplay buffer as output is inserted.
Remaining arguments are strings passed as command arguments to PROGRAM.
This function waits for PROGRAM to terminate;
if you quit, the process is killed.
The coding-system used for converting ARGS and receiving the output
 of PROGRAM default to car and cdr of default-process-coding-system,
 but can be changed by call-process-hook.
See also call-process-hook and si:call-process."
  (let ((coding-systems
	 (if call-process-hook
	     (apply call-process-hook program buffer nil nil args)
	   default-process-coding-system)))
    (if (consp coding-systems)
	(apply 'si:call-process
	       program infile buffer display (car coding-systems)
	       ;; 94.3.8 by T.Enami
	       (code-convert-process-arguments args coding-systems)))))

;; 92.4.28 by K.Handa
;; call-process-region-hook is deleted.
;; call-process-region now calls call-process-hook.

;; 92.7.15 by K.Handa - document modified. 93.6.1 by K.Handa -- for 18.59
;; 93.7.17 by K.Hirokawa - DISPLAY argument handled correctly.
(defun call-process-region (start end program
				  &optional delete buffer display &rest args)
  "Send text from START to END to a process running PROGRAM.
Delete the text if DELETE is non-nil.
Insert output in BUFFER before point; t means current buffer;
 nil for BUFFER means discard it; 0 means discard and don't wait.
Sixth arg DISPLAY non-nil means redisplay buffer as output is inserted.
Remaining args are passed to PROGRAM at startup as command args.
Returns nil if BUFFER is 0; otherwise waits for PROGRAM to terminate
and returns a numeric exit status or a signal description string.
If you quit, the process is killed with SIGKILL.
The coding-system used for receiving from the PROGRAM defaults to
 car of default-process-coding-system.
The coding-system used for sending the region to the PROGRAM and converting
 ARGS default to cdr of default-process-coding-system.
But these can be changed by call-process-hook.
See also call-process-hook and call-process."
  (let ((temp (if (eq system-type 'ms-dos)
		  (let ((tem (or (getenv "TMP") (getenv "TEMP") "/")))
		    (concat (and (eq (aref tem (1- (length tem))) ?/) "/")
			    "demacs."))
		(make-temp-name "/tmp/emacs")))
	(coding-systems (if call-process-hook
			    (apply call-process-hook
				   program buffer start end args)
			  default-process-coding-system))
	status)
    (if (consp coding-systems)
	(unwind-protect
	    (let ((call-process-hook nil)
		  (default-process-coding-system coding-systems))
	      (write-region start end temp nil 'nomessage (cdr coding-systems))
	      (if delete (delete-region start end))
	      (setq status
		    (apply 'call-process program temp buffer display args)))
	  (delete-file temp)))
    status))

(defvar start-process-hook nil
  "A hook function to decide coding-systems of process input and output.
Before starting process, start-process calls it with arguments
 NAME, BUFFER, PROGRAM, and ARGS [same as those given to start-process].
The return value of this function should be a cons of coding-systems
 used while sending and receiving to/from the started process.
 If the value is not cons object, further calling is supressed.")

(defun start-process (name buf program &rest args)
  "Start a program in a subprocess.  Return the process object for it.
Args are NAME BUFFER PROGRAM &rest PROGRAM-ARGS.
NAME is name for process.  It is modified if necessary to make it unique.
BUFFER is the buffer or (buffer-name) to associate with the process.
 Process output goes at end of that buffer, unless you specify
 an output stream or filter function to handle the output.
 BUFFER may be also nil, meaning that this process is not associated
 with any buffer.
Third arg is program file name.  It is searched for as in the shell.
Remaining arguments are strings to give program as arguments.
The coding-system used for sending and receiving to/from the process are
 the value of default-process-coding-system, but can be changed by
 start-process-hook.
See also start-process-hook and si:start-process."
  (let ((coding-systems
	 (if start-process-hook
	     (apply start-process-hook name buf program args)
	   default-process-coding-system)))
    (if (consp coding-systems)
	(apply 'si:start-process name buf
	       (car coding-systems) (cdr coding-systems) program
	       ;; 94.3.8 by T.Enami
	       (code-convert-process-arguments args coding-systems)))))

(defvar open-network-stream-hook nil
  "A hook function to decide coding-systems of input and output for service.
Before starting service, open-network-stream calls this function with arguments
 NAME, BUFFER, PROGRAM, and ARGS [same as those given to open-network-stream].
The return value of this function should be a cons of coding-systems
 used while sending and receiving to/from the network service.
 If the value is not cons object, further calling is supressed.")

(defun open-network-stream (name buf host service)
  "Open a TCP connection for a service to a host.
Returns a subprocess-object to represent the connection.
Input and output work as for subprocesses; `delete-process' closes it.
Args are NAME BUFFER HOST SERVICE.
NAME is name for process.  It is modified if necessary to make it unique.
BUFFER is the buffer (or buffer-name) to associate with the process.
 Process output goes at end of that buffer, unless you specify
 an output stream or filter function to handle the output.
 BUFFER may be also nil, meaning that this process is not associated
 with any buffer
Third arg is name of the host to connect to.
Fourth arg SERVICE is name of the service desired, or an integer
 specifying a port number to connect to.
The coding system used for sending and receiving to/from the SERVICE are
 the value of default-process-coding-system, but can be changed by
 open-network-stream-hook.
See also open-network-stream-hook and si:open-network-stream."
  (let ((coding-systems
	 (if open-network-stream-hook
	     (funcall open-network-stream-hook name buf host service)
	   default-process-coding-system)))
    (if (consp coding-systems)		;; 94.3.8 by T.Enami
	(si:open-network-stream name buf host service
				(car coding-systems) (cdr coding-systems)))))
