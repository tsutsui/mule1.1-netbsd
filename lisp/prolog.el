;; Major mode for editing Prolog, and for running Prolog under Emacs
;; Copyright (C) 1986, 1987 Free Software Foundation, Inc.
;; Author Masanobu UMEDA (umerin@flab.flab.fujitsu.junet)

;; Modified for rich indentation in Prolog mode inspired by c-mode.el
;;	Ken'ichi HANDA (handa@etl.go.jp) 1990.6.13, 90.7.25

;; This file is part of GNU Emacs.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY.  No author or distributor
;; accepts responsibility to anyone for the consequences of using it
;; or for whether it serves any particular purpose or works at all,
;; unless he says so in writing.  Refer to the GNU Emacs General Public
;; License for full details.

;; Everyone is granted permission to copy, modify and redistribute
;; GNU Emacs, but only under the conditions described in the
;; GNU Emacs General Public License.   A copy of this license is
;; supposed to have been given to you along with GNU Emacs so you
;; can know your rights and responsibilities.  It should be in a
;; file named COPYING.  Among other things, the copyright notice
;; and this notice must be preserved on all copies.

(defvar prolog-mode-syntax-table nil)
(defvar prolog-mode-abbrev-table nil)
(defvar prolog-mode-map nil)
  
(defvar prolog-consult-string "reconsult(user).\n"
  "*(Re)Consult mode (for C-Prolog and Quintus Prolog). ")

(defvar prolog-compile-string "compile(user).\n"
  "*Compile mode (for Quintus Prolog).")

(defvar prolog-eof-string "end_of_file.\n"
  "*String that represents end of file for prolog.
nil means send actual operating system end of file.")

(defvar inferior-prolog-program "prolog"
  "*Program name for invoking an inferior Prolog with `run-prolog'.")
(defvar inferior-prolog-startfile nil
  "*File to be sent to inferior Prolog process at startup time.")
(defvar inferior-prolog-switches
  "*List of arguments for invoking inferior Prolog process.")

;;; Customizable variables for indentation
(defvar prolog-indent-level 4
  "*Indentation of Prolog statements with respect to containing block.")
(defvar prolog-paren-offset 0
  "*Extra indentation for parens, compared with other text in same context.")
(defvar prolog-then-else-offset 2
  "*Offset of Prolog '->' or ';' lines.")
(defvar prolog-then-else-offset-within-block 2
  "*Offset of Prolog '->' or ';' lines relative to start of current block.")
(defvar prolog-continued-statement-offset 4
  "*Extra indent for lines not starting new statements.")
(defvar prolog-first-argument-offset 4
  "*Extra indent for the first argument relative to a head.")
(defvar prolog-term-separator
  ".*\\(\\.\\|,\\|:-\\|;\\|->\\)\\s *\\($\\|%\\)"
  "*Regexp to test if the last term of current line is terminated.")
(defvar prolog-clause-terminator
  "\\.\\s *\\(%.*\\)*$"
  "*Regexp to search for termination of clause.")
(defvar prolog-tab-always-indent t
  "*Non-nil means TAB in Prolog mode should always reindent the current line,
regardless of where in the line point is when the TAB command is used.")

(if prolog-mode-syntax-table
    ()
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?\\ "\\" table)
    (modify-syntax-entry ?+ "." table)
    (modify-syntax-entry ?- "." table)
    (modify-syntax-entry ?= "." table)
    (modify-syntax-entry ?% "<" table)
    (modify-syntax-entry ?< "." table)
    (modify-syntax-entry ?> "." table)
    (modify-syntax-entry ?\' "\"" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\f ">" table)
    (modify-syntax-entry ?/ ". 14" table)
    (modify-syntax-entry ?* ". 23" table)
    (setq prolog-mode-syntax-table table)))

(define-abbrev-table 'prolog-mode-abbrev-table ())

(defun prolog-mode-variables ()
  (set-syntax-table prolog-mode-syntax-table)
  (setq local-abbrev-table prolog-mode-abbrev-table)
  (make-local-variable 'paragraph-start)
  (setq paragraph-start (concat "^%%\\|^$\\|" page-delimiter)) ;'%%..'
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'prolog-indent-line)
  (make-local-variable 'comment-start)
  (setq comment-start "%")
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "\\(\\)\\(%+ *\\|/\\*+ *\\)") 
  (make-local-variable 'comment-column)
  (setq comment-column 48)
  (make-local-variable 'comment-indent-hook)
  (setq comment-indent-hook 'prolog-comment-indent))

(defun prolog-mode-commands (map)
  (define-key map "\t" 'prolog-indent-line)
  (define-key map "\e\C-x" 'prolog-consult-region)
  (define-key map "(" 'electric-prolog-paren)
  (define-key map ")" 'electric-prolog-paren)
  (define-key map ";" 'electric-prolog-paren)
  (define-key map ":" 'electric-prolog-paren)
  (define-key map ">" 'electric-prolog-gt)
  (define-key map "\e\C-q" 'prolog-indent-current-clause))

(if prolog-mode-map
    nil
  (setq prolog-mode-map (make-sparse-keymap))
  (prolog-mode-commands prolog-mode-map))

(defun prolog-mode ()
  "Major mode for editing Prolog code for Prologs.
Blank lines and `%%...' separate paragraphs.  `%'s start comments.
Commands:
\\{prolog-mode-map}
Entry to this mode calls the value of prolog-mode-hook
if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map prolog-mode-map)
  (setq major-mode 'prolog-mode)
  (setq mode-name "Prolog")
  (prolog-mode-variables)
  (run-hooks 'prolog-mode-hook))

(defun electric-prolog-paren (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (if (and (not arg)
	   (save-excursion
	     (skip-chars-backward " \t")
	     (bolp)))
      (progn
	(insert last-command-char)
	(prolog-indent-line)
	(delete-char -1)))
  (self-insert-command (prefix-numeric-value arg)))

(defun electric-prolog-gt (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (if (and (not arg)
	   (save-excursion
	     (beginning-of-line)
	     (looking-at "^[ \t]*->$")))
      (progn
	(insert last-command-char)
	(prolog-indent-line))
    (self-insert-command (prefix-numeric-value arg))))

(defun prolog-comment-indent ()
  "Compute Prolog comment indentation."
  (cond ((looking-at "%%%") 0)
	((or (looking-at "%%") (looking-at "/\\*"))
	 (let ((indent (calculate-prolog-indent)))
	   (if (consp indent) (car indent) indent)))
	(t
	 (save-excursion
	       (skip-chars-backward " \t")
	       (max (1+ (current-column)) ;Insert one space at least
		    comment-column)))
	))

(defun beginning-of-clause ()
  "Move backward to beginning of clause."
  (interactive)
  (re-search-backward "^[^% \t\n\f]" nil 'mv))

(defun end-of-clause ()
  "Move forward to end of clause."
  (interactive)
  (let (p0 (p1 (point)) state)
    (beginning-of-clause)
    (setq p0 (point))
    (while (or (and (re-search-forward "\\.[ \t\n\f]" nil 'mv)
		    (progn
		      (forward-char -1)
		      (setq state (parse-partial-sexp p0 (point)))
		      (or (nth 4 state) (nth 3 state) (nth 1 state))))
	       (< (point) p1)))
    (if (not (bobp)) (forward-line 1))))

(defun prolog-indent-line ()
  "Indent current line as Prolog code.
Return the amount the indentation changed by."
  (interactive)
  (let ((indent (calculate-prolog-indent nil))
	start-of-block
	beg shift-amt
	(case-fold-search nil)
	(pos (- (point-max) (point))))
    (if (listp indent)
	(progn
	  (setq start-of-block (cdr indent))
	  (setq indent (car indent)))
      (setq start-of-block 0))
    (beginning-of-line)
    (setq beg (point))
    (setq indent
	  (cond ((eq indent nil) (current-indentation))
		((eq indent t) (calculate-prolog-indent-within-comment))
		(t
		 (skip-chars-forward " \t")
		 (cond ((or (looking-at "->") (looking-at ";"))
			(if (= start-of-block 0)
			    prolog-then-else-offset
			  (+ start-of-block
			     prolog-then-else-offset-within-block)))
		       ((looking-at "%%%") 0)
		       ((looking-at "%%") indent)
		       ((= (following-char) ?%) comment-column)
		       ((= (following-char) ?\)) start-of-block)
		       ((= (following-char) ?\()
			(+ indent prolog-paren-offset))
		       (t indent)))))
    (skip-chars-forward " \t")
    (setq shift-amt (- indent (current-column)))
    (if (zerop shift-amt)
	(if (> (- (point-max) pos) (point))
	    (goto-char (- (point-max) pos)))
      (delete-region beg (point))
      (indent-to indent)
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	  (goto-char (- (point-max) pos))))
    shift-amt))

(defun calculate-prolog-indent (&optional parse-start)
  "Return appropriate indentation for current line as Prolog code.
In usual case returns an integer: the column to indent to.
Returns nil if line starts inside a string, t if in a comment,
\(indent . start-of-block\) if line is within a paren block."
  (save-excursion
    (beginning-of-line)
    (if (= (following-char) ?%)
	nil
      (let ((indent-point (point))
	    (case-fold-search nil)
	    state
	    containing-sexp)
	(if parse-start
	    (goto-char parse-start)
	  (beginning-of-clause)
	  (setq parse-start (point)))
	(setq state (parse-partial-sexp parse-start indent-point))
	(setq containing-sexp (car (cdr state)))
	(cond ((or (nth 3 state) (nth 4 state))
	       ;; return nil or t if should not change this line
	       (nth 4 state))
	      ((null containing-sexp)
	       ;; Line is at top level.
	       ;; Look at previous non-comment line to determine whether
	       ;; we are in top-level or within a clause definition.
	       ;; Set basic-indent accordingly.
	       (let (p)
		 (goto-char indent-point)
		 (if (or (bobp)
			 (not (re-search-backward "^[^% \t\n\f]" nil 'mv)))
		     0
		   (setq p (point))
		   (while
		       (and (re-search-forward "\\.[ \t\n\f]" indent-point 'mv)
			    (progn
			      (forward-char -1)
			      (setq state (parse-partial-sexp p (point)))
			      (or (nth 4 state) (nth 3 state) (nth 1 state)))))
		   (if (< (point) indent-point)
		       0
		     (+ prolog-indent-level
			;; Now add a little if this is a continuation line.
			(progn
			  (prolog-backward-to-noncomment parse-start)
			  (beginning-of-line)
			  (if (looking-at prolog-term-separator)
			      0 prolog-continued-statement-offset)))))))
	      ((or (/= (char-after containing-sexp) ?\()
		   (= (char-syntax (char-after (1- containing-sexp))) ?w))
	       ;; line is argument, not statement.  Return a list.
	       (cons
		(if (nth 2 state)
		    ;; If not the start of first argument,
		    ;; indent the same amount as the first argument
		    (progn
		      (goto-char (1+ containing-sexp))
		      (skip-chars-forward " \t\n" indent-point)
		      (+ (current-column)
			 (progn (goto-char indent-point)
				(prolog-backward-to-noncomment containing-sexp)
				(beginning-of-line)
				(if (looking-at prolog-term-separator) 0
				  prolog-continued-statement-offset))))
		  ;; the first argument
		  ;; indent to the start of predicate + alpha
		  (goto-char (1- containing-sexp))
		  (re-search-backward "\\S_\\<" nil 'mv)
		  (forward-char 1)
		  (+ (current-column) prolog-first-argument-offset))
		(save-excursion
		  (goto-char containing-sexp)
		  (current-column))))
	      (t
	       ;; Statement level.  Return a list.
	       (let (current-block-indent block-paren)
		 (goto-char containing-sexp)
		 ;; At first, find indentation of current block
		 (setq block-paren
		       (car (cdr (parse-partial-sexp parse-start (point)))))
		 (setq current-block-indent
		       (save-excursion
			 (if (not block-paren)
			     (current-indentation)
			   (goto-char block-paren)
			   (prolog-forward-to-noncomment containing-sexp)
			   (current-column))))
		 (cons
		  ;; Is line a first statement after an open-paren?
		  (or
		   ;; If no, find that first statement and indent like it.
		   (save-excursion
		     (prolog-forward-to-noncomment indent-point)
		     ;; The first following code counts
		     ;; if it is before the line we want to indent.
		     (and (< (point) indent-point)
			  (+ (current-column)
			     (progn
			       (goto-char indent-point)
			       (prolog-backward-to-noncomment containing-sexp)
			       (beginning-of-line)
			       (if (looking-at prolog-term-separator) 0
				 prolog-continued-statement-offset)))))
		   ;; If no previous statement,
		   ;; indent it relative to line paren is on.
		   (+ current-block-indent prolog-first-argument-offset))
		  current-block-indent))))))))

(defun calculate-prolog-indent-within-comment ()
  "Return the indentation amount for line, assuming that
the current line is to be regarded as part of a block comment."
  (let (end star-start)
    (save-excursion
      (beginning-of-line)
      (skip-chars-forward " \t")
      (setq star-start (= (following-char) ?\*))
      (skip-chars-backward " \t\n")
      (setq end (point))
      (beginning-of-line)
      (skip-chars-forward " \t")
      (and (re-search-forward "/\\*[ \t]*" end t)
	   star-start
	   (goto-char (1+ (match-beginning 0))))
      (current-column))))

(defun prolog-backward-to-noncomment (lim)
  (let (opoint stop)
    (while (not stop)
      (skip-chars-backward " \t\n\f" lim)
      (setq opoint (point))
      (if (and (>= (point) (+ 2 lim))
	       (= (preceding-char) ?/) (= (char-after (- (point) 2)) ?*))
	  (search-backward "/*" lim 'mv)
	(let ((p (max lim (save-excursion (beginning-of-line) (point)))))
	  (if (nth 4 (parse-partial-sexp p (point)))
	      (search-backward "%" p 'mv)
	    (goto-char opoint)
	    (setq stop t)))))))

(defun prolog-forward-to-noncomment (lim)
  (forward-char 1)
  (while (progn
	   (skip-chars-forward " \t\n" lim)
	   (looking-at "%\\|/\\*"))
    ;; Skip over comments and labels following openparen.
    (if (= (following-char) ?\%)
	(forward-line 1)
      (forward-char 2)
      (search-forward "*/" lim 'mv))))

(defun mark-prolog-clause ()
  "Put mark at end of current prolog clause, point at beginning."
  (interactive)
  (push-mark (point))
  (end-of-clause)
  (push-mark (point))
  (beginning-of-clause))

(defun mark-prolog-clauses ()
  "Put mark at end of prolog clause group of the same
predicate, point at beginning."
  (interactive)
  (push-mark (point))
  (if (not (looking-at "^\\(\\sw\\|\\s_\\)+("))
      (re-search-backward "^\\(\\sw\\|\\s_\\)+(" nil t))
  (let ((predicate
	 (concat "^" (buffer-substring (match-beginning 0) (match-end 0)))))
    (while (re-search-forward predicate nil t)
      (end-of-clause))
    (push-mark (point))
    (while (re-search-backward predicate nil t))))

(defun prolog-indent-current-clause ()
  "Indent all lines in a current Prolog clause."
  (interactive)
  (let (p)
    (save-excursion
      (end-of-clause)
      (setq p (point-marker))
      (beginning-of-clause)
      (while (< (point) p)
	(prolog-indent-line)
	(forward-line 1)))))


;;;
;;; Inferior prolog mode
;;;
(defvar inferior-prolog-mode-map nil)

;; Moved into inferior-prolog-mode
;;(if inferior-prolog-mode-map
;;    nil
;;  (setq inferior-prolog-mode-map (copy-alist shell-mode-map))
;;  (prolog-mode-commands inferior-prolog-mode-map))

(defun inferior-prolog-mode ()
  "Major mode for interacting with an inferior Prolog process.

The following commands are available:
\\{inferior-prolog-mode-map}

Entry to this mode calls the value of prolog-mode-hook with no arguments,
if that value is non-nil.  Likewise with the value of shell-mode-hook.
prolog-mode-hook is called after shell-mode-hook.

You can send text to the inferior Prolog from other buffers
using the commands send-region, send-string and \\[prolog-consult-region].

Commands:
Tab indents for Prolog; with argument, shifts rest
 of expression rigidly with the current line.
Paragraphs are separated only by blank lines and '%%'. '%'s start comments.

Return at end of buffer sends line as input.
Return not at end copies rest of line to end and sends it.
\\[shell-send-eof] sends end-of-file as input.
\\[kill-shell-input] and \\[backward-kill-word] are kill commands, imitating normal Unix input editing.
\\[interrupt-shell-subjob] interrupts the shell or its current subjob if any.
\\[stop-shell-subjob] stops, likewise. \\[quit-shell-subjob] sends quit signal, likewise."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'inferior-prolog-mode)
  (setq mode-name "Inferior Prolog")
  (setq mode-line-process '(": %s"))
  (prolog-mode-variables)
  (require 'shell)
  (if inferior-prolog-mode-map
      nil
    (setq inferior-prolog-mode-map (copy-keymap shell-mode-map))
    (prolog-mode-commands inferior-prolog-mode-map))
  (use-local-map inferior-prolog-mode-map)
  (make-local-variable 'last-input-start)
  (setq last-input-start (make-marker))
  (make-local-variable 'last-input-end)
  (setq last-input-end (make-marker))
  (make-variable-buffer-local 'shell-prompt-pattern)
  (setq shell-prompt-pattern "^| [ ?][- ] *") ;Set prolog prompt pattern
  (run-hooks 'shell-mode-hook 'prolog-mode-hook))

(defun run-prolog ()
  "Run an inferior Prolog process, input and output via buffer *prolog*."
  (interactive)
  (require 'shell)
  (switch-to-buffer (make-shell "prolog"
				inferior-prolog-program
				inferior-prolog-startfile
				inferior-prolog-switches))
  (inferior-prolog-mode))

(defun prolog-consult-region (compile beg end)
  "Send the region to the Prolog process made by M-x run-prolog.
 If COMPILE (prefix arg) is not nil,
 use compile mode rather than consult mode."
  (interactive "P\nr")
  (save-excursion
    (if compile
	(send-string "prolog" prolog-compile-string)
      (send-string "prolog" prolog-consult-string))
    (send-region "prolog" beg end)
    (send-string "prolog" "\n")		;May be unnecessary
    (if prolog-eof-string
	(send-string "prolog" prolog-eof-string)
      (process-send-eof "prolog")))) ;Send eof to prolog process.

(defun prolog-consult-region-and-go (compile beg end)
  "Send the region to the inferior Prolog, and switch to *prolog* buffer.
 If COMPILE (prefix arg) is not nil,
 use compile mode rather than consult mode."
  (interactive "P\nr")
  (prolog-consult-region compile beg end)
  (switch-to-buffer "*prolog*"))
