;; Quail -- Simple inputing method
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

;;; 92.2.12  created for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.3.21  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;;;	"\C-p" is maped to quail-prev-candidate.
;;; 92.4.1   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
;;;	Attribute changed from inverse to underline.
;;; 92.4.5   modified for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
;;;	The facility to show candidates improved gracefully.
;;;	You can select candidates by directly supplying index number.
;;; 92.4.15  modified for Mule Ver.0.9.3 by Y.Niibe <gniibe@mri.co.jp>
;;;	Fix mistype -- handing => handling.
;;; 92.4.30  modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;;	Some "defconst"s are changed to "defvar".
;;; 92.5.5   modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;;	In quail-indexed-candidate, numeric key is regarded as a
;;;	quail-self-insert-command until reaching the leaf of map.
;;; 92.7.2   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Almost full rewrite of codes.
;;; 92.7.29  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	In quail-mode, quail-related variables are declared as buffer-local.
;;; 92.8.7   modified for Mule Ver.0.9.6 by D.Jacobson <danj1@ihspa.att.com>
;;;	Spell mistakes corrected.
;;; 92.8.7   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	quail-init-state should work even if a buffer is read-only.
;;; 92.10.8  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	(message ...) should show '%' character correctly.
;;; 92.10.26 modified for Mule Ver.0.9.6
;;;			by T.Saneto <sanewo@pdp.crl.sony.co.jp>
;;;	Typo fixed.	
;;; 92.10.26 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	Default key binding for quail-mode and quail-exit-mode -> C-].
;;; 92.12.16 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	quail-non-quail-command should set this-command.
;;; 93.1.8   modified for Mule Ver.0.9.7.1 by Takahashi N. <ntakahas@etl.go.jp>
;;;     *quail-keyboard-translate-table* is introduced.
;;;	quail-help shows virtual keyboard layout.
;;; 93.1.21  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Function specified in quail-map is handled correctly.
;;; 93.4.13  modified for Mule Ver.0.9.7.1 by Takahashi N. <ntakahas@etl.go.jp>
;;;	Space is added to *quail-keyboard-transrate-table*
;;; 93.4.29  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Avoid entering quail-mode recursively.
;;; 93.4.30  modified for Mule Ver.0.9.8 by Takahashi N. <ntakahas@etl.go.jp>
;;;	Visual motion command included.
;;; 93.5.12  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Big change for more convenient user interface.
;;; 94.3.8   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	*quail-mode-tit-map* is created for etzy and zozy packages.

;; Although, EGG is the major inputing method supported by Mule,
;; it's, for the moment, not convenient for inputing Chinese letters.
;; So, I wrote this program as an alternative to EGG to be used
;; until revision of EGG.
;; I modified all translation tables of cxterm/dict/tit of X.V11R5
;; to be used with this system, those are named as quail-*.el.
;; Please load only necessary tables.

;; Quail serves as a front end processor for inputing
;; multilingual text from normal ASCII keyboard.  By defining a
;; translation table which maps ASCII string to multilingual
;; string, you can input any text from ASCII keyboard.

(provide 'quail)

(global-set-key "\C-]" 'quail-mode)
(define-key mule-keymap "M" 'quail-select-package)

(defvar *quail-help-buf* nil)
(defvar *quail-dynamic-buf* nil)
(defmacro quail-buffer-alive-p (buf)
  (list 'and (list 'bufferp buf) (list 'buffer-name buf)))

(defvar *quail-last-index* nil)

;; Quail package 

(defvar *quail-package-alist* nil "Alist of quail-packages.")
(defvar *quail-current-package* nil "Current quail-pacakge.")
(defvar *quail-alternative-package* nil "Alternative quail-pacakge.")

(defmacro quail-package (name)
  "Return quail-package named NAME."
  (list 'assoc name '*quail-package-alist*))

(defun quail-use-package (name)
  "Set current quail package to NAME."
  (setq *quail-current-package* (quail-package name))
  (setq-default *quail-current-package* (quail-package name)))

(defmacro quail-prompt () '(nth 1 *quail-current-package*))
(defmacro quail-map () '(nth 2 *quail-current-package*))
(defmacro quail-showkey () '(nth 3 *quail-current-package*))
(defmacro quail-document () '(nth 4 *quail-current-package*))
(defmacro quail-mode-map () '(nth 5 *quail-current-package*))
(defmacro quail-nolearn () '(nth 6 *quail-current-package*))
(defmacro quail-deterministic () '(nth 7 *quail-current-package*))
(defmacro quail-translate () '(nth 8 *quail-current-package*))
(defmacro quail-layout () '(nth 9 *quail-current-package*))
(defmacro quail-dynamic-list () '(nth 10 *quail-current-package*))
(defmacro quail-decode-map () '(nth 11 *quail-current-package*))
(defmacro quail-visually () '(nth 12 *quail-current-package*))

(defun quail-init-map ()
  "Return initial quail-map, which holds translation rule."
  (make-sparse-keymap))

(defun quail-define-package (name prompt &optional showkey doc map
				  nolearn deterministic translate layout
				  dynamic-list decode-map visually)
  "Define NAME as a quail-package with initial quail map.
The second argument PROMPT is a string to be displayed as a name of
 minor mode when NAME is selected as current package of quail-mode.
Optional third arg SHOWKEY is an alist of key and correspoing string
 to be shown in echo area.
Optional fourth arg DOC is a document shown by quail-help command.
Optional fifth arg MAP is a keymap for control in quail-mode,
 defaults to *quail-mode-default-map*.
Optional sixth arg NOLEARN non-nil means not remembering a candidate
 seleceted last time.
Optional seventh arg DETERMINISTIC non-nil means translation is deterministic,
 and NOLEARN is automatically set to t.
Optional eighth arg TRANSLATE non-nil means input characters are mapped to
 vt100 layout with *quail-keyboard-translate-table*.
Optional ninth arg LAYOUT non-nil means translated keyboard layout will be
 displayed in quail-help.
Optional tenth arg DYNAMIC-LIST non-nil means show candidates dynamically.
Optional eleventh arg DECODE-MAP non-nil means create decoding map.
Optional twelfth arg VISUALLY non-nil means editing is done visually.
The current quail-package is set to this package and following quail-defrule
 defines translation rules in it."
  (if quail-mode (quail-exit-mode))
  (if deterministic (setq nolearn t))	;92.10.26 by T.Saneto
  (let ((package (quail-package name))
	(args (list prompt (quail-init-map) showkey doc
		    (or map *quail-mode-default-map*) nolearn deterministic
		    translate layout dynamic-list (if decode-map '(0) nil)
		    visually)))
    (if package	(rplacd package args)
      (setq *quail-package-alist*
	    (cons (cons name args) *quail-package-alist*))))
  (quail-use-package name))

(defun quail-terminal-map (candidate)
  (let ((map (make-sparse-keymap)))
    (define-key map "\377" candidate t)
    map))

(defconst *quail-keyboard-standard-table*
  '("\
1234567890-=`\
qwertyuiop[]\
asdfghjkl;'\\\
zxcvbnm,./\
!@#$%^&*()_+~\
QWERTYUIOP{}\
ASDFGHJKL:\"|\
ZXCVBNM<>?\
 "
    nil))

(defvar *quail-keyboard-translate-table*
	*quail-keyboard-standard-table*
"List of QUAIL-TRANSLATE-TABLE (first element) and QUAIL-ASSOC-TABLE
(second element).
 QUAIL-TRANSLATE-TABLE is a string which represents the 'normalised'
layout of a particular keyboard.
 QUAIL-ASSOC-TABLE is an a-list which describes 'unordinary' key
locations.  A key location is given by a vector of the form
[x-position y-position shift-or-not].  For example, the '1' (one)
key's location is [0 0 0], and 'W' (capital letter W) is [1 1 1].  The
third element being 0 means unshifted, 1 means shifted.  If
QUAIL-ASSOC-TABLE is NIL, the first argument given to quail-defrule
will not be translated.")

(defconst *quail-keyboard-translate-table-sun-type3*
  '("\
1234567890-=\\\
qwertyuiop[]\
asdfghjkl;'`\
zxcvbnm,./\
!@#$%^&*()_+|\
QWERTYUIOP{}\
ASDFGHJKL:\"~\
ZXCVBNM<>?\
 "
    ((?` [13 0 0]) (?~ [13 0 1]))))

(defconst *quail-keyboard-translate-table-sun-type4*
  '("\
1234567890-=\\\
qwertyuiop[]\
asdfghjkl;'`\
zxcvbnm,./\
!@#$%^&*()_+|\
QWERTYUIOP{}\
ASDFGHJKL:\"~\
ZXCVBNM<>?\
 "
    ((?\\ [11 -1 0]) (?| [11 -1 1]))))

(defconst *quail-keyboard-translate-table-sony-nwp-411a*
  '("\
1234567890-=\\\
qwertyuiop[]\
asdfghjkl;'`\
zxcvbnm,./\
!@#$%^&*()_+|\
QWERTYUIOP{}\
ASDFGHJKL:\"~\
ZXCVBNM<>?\
 "
    nil))

(defconst *quail-keyboard-translate-table-jis*
  '("\
1234567890-^\\\
qwertyuiop@[\
asdfghjkl;:]\
zxcvbnm,./\
!\"#$%&'()_=`|\
QWERTYUIOP~{\
ASDFGHJKL+*}\
ZXCVBNM<>?\
 "
    ((?_ [10 3 1]))))

(defconst *quail-keyboard-translate-table-fujitsu-sigma-230*
  '("\
1234567890-^\\\
qwertyuiop@[\
asdfghjkl;:]\
zxcvbnm,./\
!\"#$%&'()_=~|\
QWERTYUIOP`{\
ASDFGHJKL+*}\
ZXCVBNM<>?\
 "
    ((?_ [10 3 1]))))

(defconst *quail-keyboard-translate-table-ibm-at*
  '("\
1234567890-=\\\
qwertyuiop[]\
asdfghjkl;'`\
zxcvbnm,./\
!@#$%^&*()_+|\
QWERTYUIOP{}\
ASDFGHJKL:\"~\
ZXCVBNM<>?\
 "
    ((?` [-1 0 0]) (?~ [-1 0 1]))))

(defconst *quail-keyboard-translate-table-ibm-rt/pc*
  '("\
1234567890-=`\
qwertyuiop[]\
asdfghjkl;'\\\
zxcvbnm,./\
!@#$%^&*()_+~\
QWERTYUIOP{}\
ASDFGHJKL:\"|\
ZXCVBNM<>?\
 "
    ((?` [-1 0 0]) (?~ [-1 0 1]) (?\\ [12 1 0]) (?| [12 1 1]))))

(defconst *quail-keyboard-translate-table-decstation*
  '("\
1234567890-=`\
qwertyuiop[]\
asdfghjkl;'\\\
zxcvbnm,./\
!@#$%^&*()_+~\
QWERTYUIOP{}\
ASDFGHJKL:\"|\
ZXCVBNM<>?\
 "
    ((?` [-1 3 0]) (?~ [-1 3 1]))))

(defconst *quail-keyboard-translate-table-dynabook*
  '("\
1234567890-=`\
qwertyuiop[]\
asdfghjkl;'\\\
zxcvbnm,./\
!@#$%^&*()_+~\
QWERTYUIOP{}\
ASDFGHJKL:\"|\
ZXCVBNM<>?\
 "
    ((?` [7 4 0]) (?~ [7 4 1]) (?\\ [1 4 0]) (?| [1 4 1]))))

(defconst *quail-keyboard-translate-table-mac-mo110*
  '("\
1234567890-=`\
qwertyuiop[]\
asdfghjkl;'\\\
zxcvbnm,./\
!@#$%^&*()_+~\
QWERTYUIOP{}\
ASDFGHJKL:\"|\
ZXCVBNM<>?\
 "
    ((?` [-1 0 0]) (?~ [-1 0 1]) (?\\ [8 4 0]) (?| [8 4 1]))))

(defconst *quail-keyboard-translate-table-mac-mo116*
  '("\
1234567890-=`\
qwertyuiop[]\
asdfghjkl;'\\\
zxcvbnm,./\
!@#$%^&*()_+~\
QWERTYUIOP{}\
ASDFGHJKL:\"|\
ZXCVBNM<>?\
 "
    ((?` [1 4 0]) (?~ [1 4 1]) (?\\ [7 4 0]) (?| [7 4 1]))))

(defun quail-defrule (key candidate &optional name)
  "Define KEY (string) to produce CANDIDATE in the current quail-map.
CANDIDATE is a string, a list of strings, a quail-map, a command, or a symbol.
 If the string contains only one character, the character code (integer) is
 also acceptable.
 The command should be a lisp function suitable for interactive
 calling (and called with no argument).
 The symbol's function definition should be a quail-map.
Optional arg PACKAGE indicates the package name to be used."
  (let* ((*quail-current-package*
	  (if name (quail-package name) *quail-current-package*))
	 (map (quail-map)))
    (if (not (keymapp map))
	(error "QUAIL: Invalid quail-map: %s" map)
      (if (or (keymapp candidate)	; another quail-map
	      (symbolp candidate))	; command or symbol
	  (define-key map key candidate)
	(if (quail-deterministic)
	    (if (listp candidate)
		(setq candidate (cons 0 candidate)))
	  (if (not (listp candidate))
	      (setq candidate (list candidate)))
	  (if (string-memq key candidate)
	      (setq candidate (cons 0 candidate))
	    (setq candidate (nconc (cons 0 candidate) (list key)))))
	(let ((def (lookup-key map key)))
	  (if (keymapp def)
	      (define-key def "\377" candidate t)
	    (define-key map key (quail-terminal-map candidate)))))
      (let ((decode-map (quail-decode-map))
	    tbl)
	(if decode-map
	    (if (setq tbl (assoc candidate decode-map))
		(setcdr tbl key)
	      (setcar (nthcdr 11 *quail-current-package*)
		      (cons (cons candidate key) decode-map)))))
      )))

(defun quail-select-package (name)
  "Select quail-package."
  (interactive
   (let* ((completion-ignore-case t)
	  (default (if *quail-alternative-package*
		       (car *quail-alternative-package*)))
	  (package-name (completing-read
			 (format "Quail Package (%s): " default)
			 *quail-package-alist* nil t nil)))
     (if (> (length package-name) 0) (list package-name) (list default))))
  (if (quail-package name)
      (progn
	(setq *quail-alternative-package* *quail-current-package*)
	(quail-use-package name)
	(if quail-mode
	    (progn (quail-exit-mode) (quail-mode))))))

(defun quail-initial-mode-map ()
  (let ((map (make-keymap))
	(esc-map (make-vector 256 'quail-non-quail-command))
	(i 0))
    (while (< i ? )
      (aset map i 'quail-non-quail-command)
      (setq i (1+ i)))
    (while (<= i 127)
      (aset map i 'quail-self-insert-command)
      (setq i (1+ i)))
    (while (< i 256)
      (aset map i 'quail-non-quail-command)
      (setq i (1+ i)))
    (aset map ?\e esc-map)
    map))

(defconst *quail-mode-default-map* nil)
(progn
  (setq *quail-mode-default-map* (quail-initial-mode-map))
  (define-key *quail-mode-default-map* "\en" 'quail-next-candidate)
  (define-key *quail-mode-default-map* "\ep" 'quail-prev-candidate)
  (define-key *quail-mode-default-map* "\eN" 'quail-next-candidate-block)
  (define-key *quail-mode-default-map* "\eP" 'quail-prev-candidate-block)
  (define-key *quail-mode-default-map* "\ei" 'quail-completion)
  (define-key *quail-mode-default-map* "\es" 'quail-select-package)
  (define-key *quail-mode-default-map* "\C-]" 'quail-exit-mode)
  (define-key *quail-mode-default-map* "\177" 'quail-backward-delete-char)
  (define-key *quail-mode-default-map* "\ez" 'quail-help)
  ; 93.4.30 Takahashi N.
  (define-key *quail-mode-default-map* "\C-d" 'quail-delete-char)
  (define-key *quail-mode-default-map* "\C-f" 'quail-forward-char)
  (define-key *quail-mode-default-map* "\C-b" 'quail-backward-char)
  (define-key *quail-mode-default-map* "\C-a" 'quail-beginning-of-line)
  (define-key *quail-mode-default-map* "\C-j" 'reverse-direction-word))

(defconst *quail-mode-tit-map* nil)
(progn
  (setq *quail-mode-tit-map* (copy-keymap *quail-mode-default-map*))
  (let ((i ?0))
    (while (<= i ?9)
      (aset *quail-mode-tit-map* i 'quail-select-by-index)
      (setq i (1+ i))))
  (define-key *quail-mode-tit-map* ">" 'quail-next-candidate-block)
  (define-key *quail-mode-tit-map* "<" 'quail-prev-candidate-block))

(defconst *quail-mode-rich-map* nil)
(progn
  (setq *quail-mode-rich-map* (copy-keymap *quail-mode-default-map*))
  (let ((i ?0))
    (while (<= i ?9)
      (aset *quail-mode-rich-map* i 'quail-select-by-index)
      (setq i (1+ i))))
  (define-key *quail-mode-rich-map* "." 'quail-next-candidate-block)
  (define-key *quail-mode-rich-map* ">" 'quail-next-candidate)
  (define-key *quail-mode-rich-map* "," 'quail-prev-candidate-block)
  (define-key *quail-mode-rich-map* "<" 'quail-prev-candidate)
  (define-key *quail-mode-rich-map* " " 'quail-select-or-insert-space))

(defconst *quail-mode-map* nil)

(defvar quail-mode nil)
(defvar *quail-mode-string* nil)
(defvar *quail-mode-initialized* nil)
(defvar *quail-previous-local-map* nil
  "A local map used before entering quail-mode.")
(defvar *quail-start* (make-marker)
  "A marker pointing start of quail zone.")
(defvar *quail-end* (make-marker)
  "A marker pointing end of quail zone.")
(defvar *quail-current-key* ""
  "A key string typed so far.")
(defvar *quail-current-str* nil
  "A string currently translated from *quail-current-key*.")
(defvar *quail-last-char* nil
  "A character typed last time.")
(defvar *quail-previous-read-char* nil
  "isearch-read-char function used before entering quail-mode.")

(defun quail-mode ()
  "Enter Quail minor-mode.
The command key you can use in this mode depends on a quail package.
Try \\[describe-bindings] in quail-mode.
The description about the current quail package is shown by \\[quail-help]."
  (interactive "*")
  (if quail-mode
      (message "You are already in quail-mode!")
    (if (not *quail-package-alist*)
	(error "QUAIL: no quail-package defined.")
      (if (not *quail-mode-initialized*)
	  (progn
	    (if (not (assq 'quail-mode minor-mode-alist))
		(setq minor-mode-alist
		      (cons '(quail-mode *quail-mode-string*)
			    minor-mode-alist)))
	    (mapcar 'make-variable-buffer-local
		    '(*quail-current-package* *quail-alternative-package*
		      *quail-mode-map*
		      quail-mode *quail-mode-initialized* *quail-mode-string*
		      *quail-previous-local-map*
		      *quail-start* *quail-end*
		      *quail-current-key* *quail-current-str* *quail-last-char*
		      *quail-current-idx*
		      *quail-previous-read-char* isearch-read-char
		      ))
	    (setq *quail-mode-initialized* t)
	    (setq *quail-current-package*
		  (or *quail-current-package* (car *quail-package-alist*)))))
      (setq *quail-mode-string* (concat " Q-" (quail-prompt)))
      (setq *quail-previous-local-map* (current-local-map))
      (setq *quail-previous-read-char* isearch-read-char)
      (setq isearch-read-char 'read-char)
      (setq quail-mode t)
      (quail-init-state)
      (use-local-map (quail-mode-map))
      ;; substitute-command-keys is slow...
      ;;(message (substitute-command-keys "\\[quail-help] for help."))
      (message "M-z for help.")
      (update-mode-lines)
      (run-hooks 'quail-mode-hook)
      )))

(defun quail-init-state ()
  (let ((pos (point))
	buffer-read-only)		; 92.8.7 by K.Handa
    (attribute-off-region 'underline)
    (set-marker *quail-start* pos)
    (set-marker *quail-end* pos)
    (setq *quail-current-key* nil)
    (setq *quail-current-str* nil)
    (if *quail-dynamic-buf*
	(save-excursion
	  (set-buffer *quail-dynamic-buf*)
	  (erase-buffer)))
    (if (quail-buffer-alive-p *quail-help-buf*)
	(save-excursion
	  (set-buffer *quail-help-buf*)
	  (attribute-off-region 'inverse)))))

(defun quail-check-state ()
  (if (= (point) *quail-end*)
      *quail-current-key*
    (quail-init-state)
    nil))

(defun quail-exit-mode ()
  "Exit from quail-mode."
  (interactive)
  (unwind-protect
      (progn
	(quail-init-state)
	(if (quail-buffer-alive-p *quail-help-buf*)
	    (save-excursion
	      (set-buffer *quail-help-buf*)
	      (attribute-off-region 'inverse))))
    (use-local-map *quail-previous-local-map*)
    (setq isearch-read-char *quail-previous-read-char*)
    (setq quail-mode nil)
    (update-mode-lines)))

(defun quail-non-quail-command ()
  "The corresponding command in *quail-previous-local-map*,
or \(current-global-map\) is executed."
  (interactive)
  (quail-init-state)
  (let* ((firstkey (aref (this-command-keys) 0))
	 (esc-command (or (= firstkey ?\e)
			  (and meta-flag (> firstkey 128))))
	 command)
    (setq unread-command-char
	  (if esc-command
	      (logior last-command-char 128)
	    last-command-char))
    (unwind-protect
	(let ((meta-flag esc-command)
	      (parity-flag nil))
	  (use-local-map *quail-previous-local-map*)
	  (setq command (key-binding (read-key-sequence nil))))
      (use-local-map (quail-mode-map)))
    (if (commandp command)
	(progn				;92.12.16 by K.Handa
	  (setq this-command command)
	  (call-interactively command))
      (beep))))

(defun quail-delete-region ()
  (delete-region *quail-start* *quail-end*))

(defun quail-insert (str)
  (delete-region *quail-start* *quail-end*)
  (if (quail-visually)
      (if (stringp str)
	  (let ((l (string-to-char-list str))) ;93.4.30 by Takahashi N.
	    (while l
	      (visually-insert-1-char (car l))
	      (setq l (cdr l))))
	(visually-insert-1-char str))
    (insert str))
  (if (and auto-fill-hook (> (current-column) fill-column))
      (run-hooks 'auto-fill-hook))
  (set-marker *quail-end* (point))
  (quail-show-key))

(defun quail-get-candidates (def)
  (lookup-key def "\377"))

(defun quail-get-candidate (def &optional nolearn)
  (let ((candidates (quail-get-candidates def)))
    (if candidates
	(if (not (listp candidates))	;93.1.17 by K.Handa
	    (if (integerp candidates)
		candidates
	      (if (and (symbolp candidates) (fboundp candidates))
		  (funcall candidates)
		candidates))
	  (if nolearn
	      (rplaca candidates 0))
	  (nth (car candidates) (cdr candidates)))))) ;93.1.17 by K.Handa

(defun quail-show-key ()
  ;; At first, show dynamic list or current keyin string in echo area.
  (if (quail-dynamic-list)
      (quail-list-dynamically)
    (let ((showkey (quail-showkey)))
      (if (not showkey)
	  (message "%s" *quail-current-key*)
	(let ((i 0) (str "") show ch
	      (len (length *quail-current-key*)))
	  (while (< i len)
	    (setq ch (aref *quail-current-key* i))
	    (setq show (cdr (assoc ch showkey)))
	    (setq str (concat str (if show show (char-to-string ch))))
	    (setq i (1+ i)))
	  (message "%s" str)))))
  ;; Then highlight current candidate string in *Help* buffer if any.
  (if (and *quail-current-str*
	   (quail-buffer-alive-p *quail-help-buf*)
	   (get-buffer-window *quail-help-buf*))
      (let ((str (if (stringp *quail-current-str*)
		     *quail-current-str*
		   (char-to-string *quail-current-str*)))
	    (key *quail-current-key*))
	(save-excursion
	  (set-buffer *quail-help-buf*)
	  (attribute-off-region 'inverse)
	  (goto-char (point-min))
	  (if (and (search-forward (concat key ":") nil t)
		   (search-forward (concat "." str) nil t))
	      (attribute-on-region 'inverse
				   (1+ (match-beginning 0))
				   (match-end 0)))
	  ))))

(defun quail-translate-char (ch)
  (let* ((str (car *quail-keyboard-translate-table*))
	 (len (length str))
	 (i 0))
    (while (and (< i len) (/= ch (aref str i)))
      (setq i (1+ i)))
    (if (= i len)
        (error "'%c' not found in *quail-keyboard-translate-table*" ch))
    (aref (car *quail-keyboard-standard-table*) i)))

(defun quail-select-by-index ()
  "Select a character from the current 10 candidates by digit."
  (interactive)
  (quail-self-insert-command t))

(defun quail-self-insert-command (&optional digit)
  (interactive)
  (quail-check-state)
  (setq *quail-last-char* last-command-char)
  (let* ((ch (if (quail-translate)
		 (quail-translate-char *quail-last-char*)
	       *quail-last-char*))
	 (key (if *quail-current-key*
		  (format "%s%c" *quail-current-key* ch)
		(char-to-string ch)))
	 (def (lookup-key (quail-map) key)))
    (cond ((keymapp def)
	   (or *quail-current-key*
	       (attribute-on-region 'underline (point) (point)))
	   (setq *quail-current-key* key)
	   (setq *quail-current-str* (quail-get-candidate def (quail-nolearn)))
	   (quail-insert (or *quail-current-str* *quail-current-key*))
	   (if (and *quail-current-str*
		    (= (length def) 2)
		    (not (listp (cdr (car (cdr def))))))
	       (quail-init-state)))
	  ((commandp def)
	   (setq *quail-current-key* key)
	   (if (keymapp (symbol-function def))
	       (progn
		 (setq *quail-current-str* nil)
		 (quail-insert *quail-current-key*))
	     (call-interactively def)))
	  ((and digit *quail-current-str*)
	   (quail-indexed-candidate))
	  (*quail-current-key*
	   (quail-init-state)
	   (quail-self-insert-command))
	  (t
	   (quail-init-state)
	   (quail-non-quail-command))
	  )))

(defun quail-select-or-insert-space ()
  "Select the current candidate or insert space."
  (interactive)
  (if (quail-check-state)
      (quail-init-state)
    (quail-self-insert-command 1)))

(defun quail-next-candidate ()
  "Select next candidate."
  (interactive)
  (if (and (quail-check-state) *quail-current-str*)
      (quail-select-candidate 1 t)
    (beep)))

(defun quail-prev-candidate ()
  "Select previous candidate."
  (interactive)
  (if (and (quail-check-state) *quail-current-str*)
      (quail-select-candidate -1 t)
    (beep)))

(defun quail-indexed-candidate ()
  (let ((idx (- last-command-char ?0)))
    (setq idx (if (= idx 0) 9 (1- idx)))
    (quail-select-candidate idx nil t)
    (quail-init-state)))

(defun quail-next-candidate-block ()
  "Select candidate in next 10 alternatives."
  (interactive)
  (if (and (quail-check-state) *quail-current-str*)
      (quail-select-candidate 10 t t)
    (beep)))

(defun quail-prev-candidate-block ()
  "Select candidate in previous 10 alternatives."
  (interactive)
  (if (and (quail-check-state) *quail-current-str*)
      (quail-select-candidate -10 t t)
    (beep)))

(defun quail-select-candidate (idx &optional relative block)
  (let* ((def (lookup-key (quail-map) *quail-current-key*))
	 (candidates (quail-get-candidates def)))
    (if (listp candidates)
	(let ((maxidx (- (length candidates) 2))
	      (current-idx (car candidates)))
	  (if relative
	      (setq idx (+ current-idx idx))
	    (if block
		(setq idx (+ (* (/ current-idx 10) 10) idx))))
	  (if block
	      (if (> idx maxidx)
		  (if (/= (/ maxidx 10) (/ current-idx 10))
		      (setq idx maxidx)
		    (beep)
		    (setq idx current-idx))
		(if (< idx 0) (progn (beep) (setq idx (+ idx 10)))))
	    (if (> idx maxidx) (setq idx 0)
	      (if (< idx 0) (setq idx maxidx))))
	  (rplaca candidates idx)
	  (setq *quail-current-str* (nth (car candidates) (cdr candidates)))
	  (quail-insert *quail-current-str*)))))

(defun quail-backward-delete-char (arg)
  "Delete characters backward in quail-mode."
  (interactive "p")
  (if (not (quail-check-state))
      (if (quail-visually)
	  (visually-backward-delete-char arg) ;93.4.30 Takahashi N.
	(delete-backward-char arg))
    (if (= (length *quail-current-key*) 1)
	(progn
	  (quail-delete-region)
	  (quail-init-state))
      (setq *quail-current-key* (substring *quail-current-key* 0 -1))
      (let ((def (lookup-key (quail-map) *quail-current-key*)))
	(setq *quail-last-char*
	      (aref *quail-current-key* (1- (length *quail-current-key*))))
	(setq *quail-current-str*
	      (quail-get-candidate def (quail-nolearn))) ;93.1.17 by K.Handa
	(quail-insert (or *quail-current-str* *quail-current-key*))))))

(defun quail-delete-char (arg)
  "Delete ARG characters in quail-mode."
  (interactive "p")
  (if (quail-visually)
      (visually-delete-char arg)
    (delete-char arg)))

(defun quail-forward-char (arg)
  "Move point right ARG characters in quail-mode."
  (interactive "p")
  (if (quail-visually)
      (visually-forward-char arg)
    (forward-char arg)))

(defun quail-backward-char (arg)
  "Move point left ARG characters in quail-mode."
  (interactive "p")
  (if (quail-visually)
      (visually-backward-char arg)
    (backward-char arg)))

(defun quail-beginning-of-line (arg)
  "Move cursor to the visually beginning of line in quail mode.
With ARG not nil, move forward ARG - 1 lines first.
If scan reaches end of buffer, stop there without error."
  (interactive "P")
  (if (quail-visually)
      (visually-beginning-of-line arg)
    (beginning-of-line arg)))

(defun quail-list-dynamically ()
  "Show list of candidates dynamically on echo area."
  (interactive)
  (if (not *quail-dynamic-buf*)
      (setq *quail-dynamic-buf* (get-buffer " *Minibuf-0*")))
  (if (quail-check-state)
      (let* ((def (lookup-key (quail-map) *quail-current-key*))
	     (candidates (quail-get-candidates def))
	     (key *quail-current-key*))
	(if (consp candidates)
	    (let ((idx (car candidates))
		  (maxidx (1+ (/ (1- (length (cdr candidates))) 10)))
		  (num 0)
		  p p1 p2 str)
	      (save-excursion
		(set-buffer *quail-dynamic-buf*)
		(erase-buffer)
		(attribute-off-region 'inverse)
		(insert key ":") (indent-to-column 6 1)
		(insert (format "(%d/%d)" (1+ (/ idx 10)) maxidx))
		(setq candidates (nthcdr (* (/ idx 10) 10) (cdr candidates)))
		(while (and candidates (< num 10))
		  (setq num (1+ num))
		  (insert (format " %d." (if (< num 10) num 0)))
		  (setq p (point))
		  (insert (car candidates))
		  (if (= num (1+ (% idx 10)))
		      (setq p1 p p2 (point)))
		  (setq candidates (cdr candidates)))
		(attribute-on-region 'inverse p1 p2)))
	  (save-excursion
	    (set-buffer *quail-dynamic-buf*)
	    (erase-buffer)
	    (attribute-off-region 'inverse)
	    (insert key "- [")
	    (let ((i 0))
	      (while (< i 127)
		(if (assq i (cdr def)) (insert i))
		(setq i (1+ i))))
	    (insert "]"))
	  ))))

(defun quail-completion ()
  "Show list of candidates."
  (interactive)
  (if (quail-check-state)
      (let ((def (lookup-key (quail-map) *quail-current-key*))
	    (key *quail-current-key*))
	(if (not (keymapp def))
	    (message "No macth.")
	  (save-excursion
	    (if (not (quail-buffer-alive-p *quail-help-buf*))
		(setq *quail-help-buf* (get-buffer-create "*Help*")))
	    (set-buffer *quail-help-buf*)
	    (erase-buffer)
	    (insert "Current candidates:\n")
	    (quail-completion-list key def 0)
	    (display-buffer (current-buffer)))
	  (quail-show-key)))))

(defun quail-completion-list (key def indent)
  (let ((candidates (quail-get-candidates def)))
    (indent-to indent)
    (insert key ":")
    (if candidates
	(quail-candidate-with-indent
	 (if (consp candidates) (cdr candidates) candidates)
	 key)
      (insert " none\n"))
    (setq indent (+ indent 2))
    (setq def (cdr def))
    (while def
      (if (/= (car (car def)) ?\377)
	  (quail-completion-list (format "%s%c" key (car (car def)))
				 (cdr (car def)) indent))
      (setq def (cdr def)))))

(defun quail-candidate-with-indent (candidates key)
  (if (consp candidates)
      (let ((clm (current-column))
	    (i 0)
	    num)
	(while candidates
	  (if (= (% i 10) 0) (insert (format "(%d)" (1+ (/ i 10)))))
	  (insert " " (if (= (% i 10) 9) "0" (+ ?1 (% i 10))) ".")
	  (insert (if (stringp (car candidates))
		      (car candidates)
		    (char-to-string (car candidates))))
	  (setq i (1+ i))
	  (setq candidates (cdr candidates))
	  (if (and candidates (= (% i 10) 0))
	      (progn
		(insert ?\n)
		(indent-to clm)))))
    (if (and (symbolp candidates) (fboundp candidates))
	(insert " (1) 0."
		(let ((*quail-current-key* key)) (funcall candidates)))
      (insert " (1) 0." candidates)))
  (insert ?\n))

(defun quail-help ()
  "Show brief description of the current quail-pacakge."
  (interactive)
  (quail-init-state)
  (let ((doc (quail-document))
	(map (current-local-map))
	(i 0)
	cmd)
    (save-excursion
      (if (not (quail-buffer-alive-p *quail-help-buf*))
	  (setq *quail-help-buf* (get-buffer-create "*Help*")))
      (set-buffer *quail-help-buf*)
      (erase-buffer)
      (if doc (insert doc))
      (if (quail-layout) (quail-show-layout))
      (insert "\n--- Key bindinds ---\n")
      (while (< i 256)
	(quail-describe-binding map i)
	(setq i (1+ i)))
      (setq map (aref map ?\e) i 0)
      (while (< i 256)
	(quail-describe-binding map i 'meta)
	(setq i (1+ i)))
      (goto-char (point-min))
      (display-buffer (current-buffer)))
    ))

(defun quail-show-layout ()
  (let* ((xoff 10)
	 (yoff 3)
	 (space 4)
	 (p (point))
	 (i 0)
	 (str (car *quail-keyboard-translate-table*))
	 (len (length str))
	 (alist (car (cdr *quail-keyboard-translate-table*)))
	 pos x y ch ch1 kmp)
    (insert "
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
")
    (save-excursion
      (while (< i len)
	(goto-char p)
	(setq ch (aref str i))
	(if (setq pos (car (cdr (assoc ch alist))))
	    (progn (forward-line (+ yoff (aref pos 1)))
		   (forward-char (+ xoff (* space (aref pos 0))
				    (aref pos 1) (aref pos 2))))
	  (cond
	   ((< i 13) (setq x i y 0)) ; unshifted, 1st row
	   ((< i 25) (setq x (- i 13) y 1)) ; unshifted, 2nd row
	   ((< i 37) (setq x (- i 25) y 2)) ; unshifted, 3rd row
	   ((< i 47) (setq x (- i 37) y 3)) ; unshifted, 4th row
	   ((< i 60) (setq x (- i 47) y 0)) ; shifted, 1st row
	   ((< i 72) (setq x (- i 60) y 1)) ; shifted, 2nd row
	   ((< i 84) (setq x (- i 72) y 2)) ; shifted, 3rd row
	   ((< i 94) (setq x (- i 84) y 3)) ; shifted, 4th row
	   (t (setq x (- i 90) y 4))) ; space, bottom row
	  (forward-line (+ yoff y))
	  (forward-char (+ xoff (* space x) y (if (< i 47) 0 1))))
	(delete-char 1)
	(if (quail-translate)
	    (setq ch (quail-translate-char ch)))
	(setq ch1
	  (and (setq kmp (lookup-key (quail-map) (char-to-string ch)))
	       (quail-get-candidate kmp (quail-nolearn))))
	(insert (if ch1 ch1 ch))
	(setq i (1+ i))))))
	  

(defun quail-describe-binding (map i &optional meta)
  (let ((cmd (aref map i)))
    (if (and (symbolp cmd) (fboundp cmd)
	     (not (memq cmd '(quail-self-insert-command
			      quail-non-quail-command
			      quail-indexed-candidate))))
	(progn
	  (insert (single-key-description (if meta (logior i 128) i)) ":")
	  (indent-to-column 8)
	  (insert (documentation cmd) "\n")))))

;;; Quail <-> EGG interface

(if (not (boundp 'EGG)) nil

(defconst *quail-mode-egg-map* nil)
(progn
  (setq *quail-mode-egg-map* (copy-keymap *quail-mode-default-map*))
  (define-key *quail-mode-egg-map* " " 'quail-henkan-region))

(defvar *quail-henkan-start* nil)
(make-variable-buffer-local '*quail-henkan-start*)

(defvar *quail-henkan-start-char* ?◇)

(defconst *quail-henkan-mode-map* nil)
(if *quail-henkan-mode-map* nil
  (setq *quail-henkan-mode-map* (copy-keymap henkan-mode-map))
  (let ((i 33))
    (while (< i 127)
      (aset *quail-henkan-mode-map* i 'quail-henkan-kakutei-and-self-insert)
      (setq i (1+ i))))
  (define-key *quail-henkan-mode-map* "\C-k" 'quail-henkan-kakutei)
  (define-key *quail-henkan-mode-map* "\C-l" 'quail-henkan-kakutei)
  (define-key *quail-henkan-mode-map* "\C-m" 'quail-henkan-kakutei)
  (define-key *quail-henkan-mode-map* "\C-c" 'quail-henkan-quit)
  (define-key *quail-henkan-mode-map* "\C-g" 'quail-henkan-quit)
  (define-key *quail-henkan-mode-map* "\177" 'quail-henkan-quit)
  (define-key *quail-henkan-mode-map* "\eg" 'quail-henkan-quit))

(defun quail-henkan-mark ()
  "Set mark at the current position to indicate starting point of henkan."
  (interactive)
  (quail-delete-region)
  (quail-init-state)
  (setq *quail-henkan-start* (point-marker))
  (insert *quail-henkan-start-char*))

(defun quail-henkan-region ()
  (interactive)
  (quail-delete-region)
  (quail-init-state)
  (if *quail-henkan-start*
      (let ((pos (point-marker)))
	(goto-char *quail-henkan-start*)
	(if (and (= (following-char) *quail-henkan-start-char*)
		 (progn (delete-char 1)
			(< *quail-henkan-start* pos)))
	    (let ((henkan-mode-map *quail-henkan-mode-map*))
	      (henkan-region *quail-henkan-start* pos))
	  (goto-char pos))
	(setq *quail-henkan-start* nil))
    (quail-non-quail-command)))

(defun quail-henkan-kakutei-and-self-insert ()
  (interactive)
  (setq unread-command-char last-command-char)
  (quail-henkan-kakutei))

(defun quail-henkan-reset ()
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (goto-char egg:*region-start*)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 (+ egg:*region-end* (length egg:*henkan-close*)))
  (set-marker egg:*region-start* nil) 
  (set-marker egg:*region-end* nil) 
  (setq *quail-henkan-start* nil)
  (quail-init-state)
  (use-local-map (quail-mode-map))
  (egg:mode-line-display))

(defun quail-henkan-kakutei ()
  (interactive)
  (quail-henkan-reset)
  (let ((i 0) (max (wnn-server-bunsetu-suu)))
    (while (< i max)
      (insert (car (wnn-server-bunsetu-kanji i )))
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (wnn-server-hindo-update)
  (egg:mode-line-display))

(defun quail-henkan-quit ()
  (interactive)
  (quail-henkan-reset)
  (insert egg:*kanji-kanabuff*)
  (wnn-server-henkan-quit)
  (egg:mode-line-display))

)

;; visual motions
;; 93.4.30    created by Takahashi N. <ntakahas@etl.go.jp>

(defun char-direction-after-point nil
  "Return the direction of after-point-char.
0: left-to-right, 1: right-to-left"
  (let ((ch (char-after (point))))
    (cond
     ((null ch) nil)
     ((= ch ?\n) (if display-direction 1 0))
     (t (char-direction ch)))))

(defun char-direction-after-after-point nil
  "Return the direction of after-after-point-char.
0: left-to-right, 1: right-to-left"
  (if (= (point) (point-max))
      nil
    (save-excursion
      (forward-char 1)
      (let ((ch (char-after (point))))
	(cond
	 ((null ch) nil)
	 ((= ch ?\n) (if display-direction 1 0))
	 (t (char-direction ch)))))))

(defun char-direction-before-point nil
  "Return the direction of before-point-char.
0: left-to-right, 1: right-to-left"
  (let ((ch (char-before (point))))
    (cond
     ((null ch) nil)
     ((= ch ?\n) (if display-direction 1 0))
     (t (char-direction ch)))))

(defun skip-direction-forward (dir)
  "Move point forward as long as chars of direction DIR continue."
  (while (eq (char-direction-after-point) dir)
    (forward-char 1)))

(defun skip-direction-backward (dir)
  "Move point backward as long as chars of direction DIR continue."
  (while (eq (char-direction-before-point) dir)
    (backward-char 1)))

(defun delete-direction-forward (dir)
  "From current point, delete chars of direction DIR forward.
Return the deleted string."
  (let ((p (point)))
    (skip-direction-forward dir)
    (prog1
      (buffer-substring (point) p)
      (delete-region (point) p))))

(defun delete-direction-backward (dir)
  "From current point, delete chars of direction DIR backward.
Return the deleted string."
  (let ((p (point)))
    (skip-direction-backward dir)
    (prog1
      (buffer-substring (point) p)
      (delete-region (point) p))))

(defun visually-forward-char (arg)
  "Move cursor visually forward by ARG chars."
  (interactive "p")
  (while (> arg 0)
    (visually-forward-1-char)
    (setq arg (1- arg))))

(defun visually-forward-1-char nil
  "Move cursor visually forward."
  (interactive)
  (let ((r-dir (if display-direction 0 1))
	(a-dir (char-direction-after-point))
	(aa-dir (char-direction-after-after-point))
	(b-dir (char-direction-before-point)))
    (cond
     ((null a-dir)
      ; ... nil
      ;    ^
      (error "End of buffer"))

     ((eq a-dir r-dir)
      (if (eq b-dir r-dir)

	  ; ... R R ...
	  ;    ~ ^
	  (backward-char 1)

	; ... !R R R* ...
	;       ^    ~
	(skip-direction-forward r-dir)))

     ((eq aa-dir r-dir)
      ; ... D R* R ...
      ;    ^    ~
      (forward-char 1)
      (skip-direction-forward r-dir)
      (backward-char 1))

     (t
      ; ... D !R ...
      ;    ^ ~
      (forward-char 1)))))

(defun visually-backward-char (arg)
  "Move cursor visually backward by ARG chars."
  (interactive "p")
  (while (> arg 0)
    (visually-backward-1-char)
    (setq arg (1- arg))))

(defun visually-backward-1-char nil
  "Move cursor visually backward."
  (interactive)
  (let ((r-dir (if display-direction 0 1))
	(a-dir (char-direction-after-point))
	(aa-dir (char-direction-after-after-point))
	(b-dir (char-direction-before-point)))
    (cond
     ((eq a-dir r-dir)
      (if (eq aa-dir r-dir)
	  ; ... R R ...
	  ;    ^ ~
	  (forward-char 1)

	; ... !R R* !R ...
	;    ~     ^
	(skip-direction-backward r-dir)
	(if (char-direction-before-point)
	    (backward-char 1)
	  (skip-direction-forward r-dir)
	  (backward-char 1)
	  (error "Beginning of buffer"))))

     ((null b-dir)
      ; nil !R ...
      ;    ^
      (error "Beginning of buffer"))

     ((eq b-dir r-dir)
      ; ... R* R !R
      ;    ~    ^
      (skip-direction-backward r-dir))

     (t
      ; ... D !R ...
      ;    ~ ^
      (backward-char 1)))))

(defun visually-insert-char (ch arg)
  "With argument CH, call VISUALLY-INSERT-CHAR ARG times."
  (while (> arg 0)
    (visually-insert-1-char ch)
    (setq arg (1- arg))))

(defun visually-insert-1-char (ch)
  "Insert character CH visually before cursor.
Cursor moves visually forward."
  (interactive "c")
  (let ((c-dir (char-direction ch))
	(r-dir (if display-direction 0 1))
	(a-dir (char-direction-after-point))
	(tmp))
    (if (eq c-dir r-dir)
	(if (eq a-dir r-dir)
	    
	    ; ... R ...
	    ;    ^R
	    (progn
	      (forward-char 1)
	      (insert ch)
	      (backward-char 2))
	  
	  ; ... !R ...
	  ;    ^R
	  (skip-direction-backward c-dir)
	  (insert ch)
	  (skip-direction-forward c-dir))
      
      (if (or (eq a-dir nil)
	      (eq a-dir c-dir))
	  
	  ; ... !R ...
	  ;    ^D
	  (insert ch)
	
	; ... R ...
	;    ^D
	(forward-char 1)
	(setq tmp (delete-direction-backward r-dir))
	(skip-direction-forward r-dir)
	(insert ch tmp)
	(backward-char 1)))))

(defun visually-backward-delete-char (arg)
  "Delete ARG chars visually before cursor."
  (interactive "p")
  (while (> arg 0)
    (visually-backward-delete-1-char)
    (setq arg (1- arg))))

(defun visually-backward-delete-1-char nil
  "Delete a char visually before cursor.
Cursor moves visually backward."
  (interactive)
  (let ((d-dir (if display-direction 1 0))
	(r-dir (if display-direction 0 1))
	(a-dir (char-direction-after-point))
	(aa-dir (char-direction-after-after-point))
	(b-dir (char-direction-before-point))
	(tmp))

    (if (eq a-dir r-dir)
	(cond
	 ((eq aa-dir r-dir)
	  ; ... R R ...
	  ;    ^
	  (forward-char 1)
	  (delete-char 1)
	  (backward-char 1))

	 ((save-excursion
	    (skip-direction-backward r-dir)
	    (backward-char 1)
	    (and (eq (char-direction-after-point) d-dir)
		 (eq (char-direction-before-point) r-dir)))
	  ; ... R D R* R !R ...
	  ;           ^
	  (forward-char 1)
	  (setq tmp (delete-direction-backward r-dir))
	  (backward-delete-char 1)
	  (skip-direction-backward r-dir)
	  (insert tmp)
	  (backward-char 1))

	 (t
	  ; .....!R D R* R !R ...
	  ;             ^
	  (skip-direction-backward r-dir)
	  (backward-delete-char 1)
	  (skip-direction-forward r-dir)
	  (backward-char 1)))

      (cond
       ((null b-dir)
	; nil !R ...
	;    ^
	(error "Beginning of buffer"))

       ((eq b-dir r-dir)
	; ... R !R ...
	;      ^
	(skip-direction-backward r-dir)
	(delete-char 1)
	(skip-direction-forward r-dir))

       (t
	; ... !R !R ...
	;       ^
	(backward-delete-char 1))))))

(defun visually-delete-char (arg)
  "Delete ARG chars under cursor."
  (interactive "p")
  (message "1")
  (while (> arg 0)
    (visually-delete-1-char)
    (setq arg (1- arg))))

(defun visually-delete-1-char nil
  "Delete a char under cursor.  Cursor stays at the visually same position."
  (interactive)
  (let ((d-dir (if display-direction 1 0))
	(r-dir (if display-direction 0 1))
	(a-dir (char-direction-after-point))
	(aa-dir (char-direction-after-after-point))
	(b-dir (char-direction-before-point))
	(tmp))
    (cond
     ((null a-dir)
      ; ... nil
      ;    ^
      (error "End of buffer"))

     ((eq a-dir r-dir)
      (if (eq b-dir r-dir)

	  ; ... R R ...
	  ;      ^
	  (progn (delete-char 1)
		 (backward-char 1))

	; ... !R R ...
	;       ^
	(delete-char 1)
	(skip-direction-forward r-dir)))

     ((not (eq aa-dir r-dir))
      ; ... D !R ...
      ;    ^
      (delete-char 1))

     ((eq b-dir r-dir)
      ; ... R D R ...
      ;      ^
      (delete-char 1)
      (setq tmp (delete-direction-forward r-dir))
      (skip-direction-backward r-dir)
      (insert tmp)
      (backward-char 1))

     (t
      ; ...!R D R ...
      ;      ^
      (delete-char 1)
      (skip-direction-forward r-dir)
      (backward-char 1)))))

(defun visually-beginning-of-line (arg)
  "Move cursor to the visually beginning of line.
With ARG not nil, move forward ARG - 1 lines first.
If scan reaches end of buffer, stop there without error."
  (interactive "P")
  (beginning-of-line arg)
  (let ((a-dir (char-direction-after-point))
	(d-dir (if display-direction 1 0)))
    (if (and a-dir (/= a-dir d-dir))
	(progn (skip-direction-forward a-dir)
	       (backward-char 1)))))

(defun reverse-region (begin end)
  "Reverse the order of chars between BEGIN and END."
  (interactive "r")
  (apply 'insert
	 (nreverse
	  (string-to-char-list
	   (prog1 (buffer-substring begin end) (delete-region begin end))))))

(defun reverse-direction-word nil
  "Reverse the char order of the word before point."
  (interactive)
  (goto-char
    (prog1
      (point)
      (reverse-region
       (point)
       (progn (skip-direction-backward (char-direction-before-point))
	      (point))))))
