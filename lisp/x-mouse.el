;; Mouse support for X window system.
;; Copyright (C) 1985, 1987 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; 92.5.21  modified for Mule Ver.0.9.4 by Y.Kawabe <kawabe@sra.co.jp>
;;;	x-store-text and x-get-text are added to use selection of X.
;;;	x-paste-text call x-get-text instead of x-get-cut-buffer.
;;; 92.7.27  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	x-cut-text sets attribute just on cut text.
;;; 92.10.19 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	'attribute' is autoloaded.  Use x-cut-text-attribute.
;;; 92.12.24 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	x-set-mouse-point will set point correctly on mule-width char.

(provide 'x-mouse)

(defvar x-cut-text-attribute 'inverse
  "*Charcater attribute to show the region of cut text.") ;92.10.19 by K.Handa

(defconst x-button-right (char-to-string 0))
(defconst x-button-middle (char-to-string 1))
(defconst x-button-left (char-to-string 2))

(defconst x-button-right-up (char-to-string 4))
(defconst x-button-middle-up (char-to-string 5))
(defconst x-button-left-up (char-to-string 6))

(defconst x-button-s-right (char-to-string 16))
(defconst x-button-s-middle (char-to-string 17))
(defconst x-button-s-left (char-to-string 18))

(defconst x-button-s-right-up (char-to-string 20))
(defconst x-button-s-middle-up (char-to-string 21))
(defconst x-button-s-left-up (char-to-string 22))

(defconst x-button-m-right (char-to-string 32))
(defconst x-button-m-middle (char-to-string 33))
(defconst x-button-m-left (char-to-string 34))

(defconst x-button-m-right-up (char-to-string 36))
(defconst x-button-m-middle-up (char-to-string 37))
(defconst x-button-m-left-up (char-to-string 38))

(defconst x-button-c-right (char-to-string 64))
(defconst x-button-c-middle (char-to-string 65))
(defconst x-button-c-left (char-to-string 66))

(defconst x-button-c-right-up (char-to-string 68))
(defconst x-button-c-middle-up (char-to-string 69))
(defconst x-button-c-left-up (char-to-string 70))

(defconst x-button-m-s-right (char-to-string 48))
(defconst x-button-m-s-middle (char-to-string 49))
(defconst x-button-m-s-left (char-to-string 50))

(defconst x-button-m-s-right-up (char-to-string 52))
(defconst x-button-m-s-middle-up (char-to-string 53))
(defconst x-button-m-s-left-up (char-to-string 54))

(defconst x-button-c-s-right (char-to-string 80))
(defconst x-button-c-s-middle (char-to-string 81))
(defconst x-button-c-s-left (char-to-string 82))

(defconst x-button-c-s-right-up (char-to-string 84))
(defconst x-button-c-s-middle-up (char-to-string 85))
(defconst x-button-c-s-left-up (char-to-string 86))

(defconst x-button-c-m-right (char-to-string 96))
(defconst x-button-c-m-middle (char-to-string 97))
(defconst x-button-c-m-left (char-to-string 98))

(defconst x-button-c-m-right-up (char-to-string 100))
(defconst x-button-c-m-middle-up (char-to-string 101))
(defconst x-button-c-m-left-up (char-to-string 102))

(defconst x-button-c-m-s-right (char-to-string 112))
(defconst x-button-c-m-s-middle (char-to-string 113))
(defconst x-button-c-m-s-left (char-to-string 114))

(defconst x-button-c-m-s-right-up (char-to-string 116))
(defconst x-button-c-m-s-middle-up (char-to-string 117))
(defconst x-button-c-m-s-left-up (char-to-string 118))

(defvar x-process-mouse-hook nil
  "Hook to run after each mouse event is processed.  Should take two
arguments; the first being a list (XPOS YPOS) corresponding to character
offset from top left of screen and the second being a specifier for the
buttons/keys.

This will normally be set on a per-buffer basis.")

(if (and (boundp 'MULE)
	 (fboundp 'code-convert-string)
	 (fboundp 'x-store-compound-text))
    (progn
      (defun x-store-text (str)
	(x-store-compound-text
	 (code-convert-string str *internal* *ctext*) 'PRIMARY))
      
      (defun x-get-text ()
	(code-convert-string
	 (x-get-compound-text 'PRIMARY) *ctext* *internal*))
      )
  (fset 'x-store-text (symbol-function 'x-store-cut-buffer))
  (fset 'x-get-text (symbol-function 'x-get-cut-buffer)))

(defun x-flush-mouse-queue () 
  "Process all queued mouse events."
  ;; A mouse event causes a special character sequence to be given
  ;; as keyboard input.  That runs this function, which process all
  ;; queued mouse events and returns.
  (interactive)
  (while (> (x-mouse-events) 0)
    (let ((buffer-read-only nil))	;92.10.19 by K.Handa
      (attribute-off-region x-cut-text-attribute))
    (x-proc-mouse-event)
    (and (boundp 'x-process-mouse-hook)
	 (symbol-value 'x-process-mouse-hook)
	 (funcall x-process-mouse-hook x-mouse-pos x-mouse-item))))

(define-key global-map "\C-c\C-m" 'x-flush-mouse-queue)
(define-key global-map "\C-x\C-@" 'x-flush-mouse-queue)

(defun x-mouse-select (arg)
  "Select Emacs window the mouse is on."
  (let ((start-w (selected-window))
	(done nil)
	(w (selected-window))
	(rel-coordinate nil))
    (while (and (not done)
		(null (setq rel-coordinate
			    (coordinates-in-window-p arg w))))
      (setq w (next-window w))
      (if (eq w start-w)
	  (setq done t)))
    (select-window w)
    rel-coordinate))

(defun x-mouse-keep-one-window (arg)
  "Select Emacs window mouse is on, then kill all other Emacs windows."
  (if (x-mouse-select arg)
      (delete-other-windows)))

(defun x-mouse-select-and-split (arg)
  "Select Emacs window mouse is on, then split it vertically in half."
  (if (x-mouse-select arg)
      (split-window-vertically nil)))

(defun x-mouse-set-point (arg)
  "Select Emacs window mouse is on, and move point to mouse position."
  (let* ((relative-coordinate (x-mouse-select arg))
	 margin-column
	 (rel-x (car relative-coordinate))
	 (rel-y (car (cdr relative-coordinate))))
    (if relative-coordinate
	(let ((prompt-width (if (eq (selected-window) (minibuffer-window))
				minibuffer-prompt-width 0))
	      target-column)		;92.12.24 by K.Handa
	  (move-to-window-line rel-y)
	  (if (eobp)
	      ;; If text ends before the desired line,
	      ;; always position at end of that line.
	      nil
	    (setq margin-column
		  (if (or truncate-lines (> (window-hscroll) 0))
		      (current-column)
		    ;; If we are using line continuation,
		    ;; compensate if first character on a continuation line
		    ;; does not start precisely at the margin.
		    (- (current-column)
		       (% (current-column) (1- (window-width))))))
	    ;; 92.12.24 by K.Handa
	    (setq target-column (+ rel-x (1- (max 1 (window-hscroll)))
				   (if (= (point) 1)
				       (- prompt-width) 0)
				   margin-column))
	    (if (> (move-to-column target-column) target-column)
		(forward-char -1))
	    ;; end of patch
	    )))))

(defun x-mouse-set-mark (arg)
  "Select Emacs window mouse is on, and set mark at mouse position.
Display cursor at that position for a second."
  (if (x-mouse-select arg)
      (let ((point-save (point)))
	(unwind-protect
	    (progn (x-mouse-set-point arg)
		   (push-mark nil t)
		   (sit-for 1))
	  (goto-char point-save)))))

(defun x-cut-text (arg &optional kill)
  "Copy text between point and mouse position into window system cut buffer.
Save in Emacs kill ring also."
  (if (coordinates-in-window-p arg (selected-window))
      (save-excursion
	(let ((opoint (point))		;92.10.19 by K.Handa
	      beg end)
	  (setq end opoint)
	  (x-mouse-set-point arg)
	  (setq beg (point))
	  (if (< end beg)
	      (setq end beg beg opoint))
	  (x-store-text (buffer-substring beg end))
	  (copy-region-as-kill beg end)
	  (if kill (delete-region beg end)
	    (let ((buffer-read-only nil))
	      (goto-char opoint)
	      (or (eobp) (forward-char 1))
	      (if (= beg opoint)
		  (setq beg (point))
		(setq end (point)))
	      (attribute-on-region x-cut-text-attribute beg end))
	    )))
    (message "Mouse not in selected window")))

(defun x-paste-text (arg)
  "Move point to mouse position and insert window system cut buffer contents."
  (x-mouse-set-point arg)
  (insert (x-get-text)))

(defun x-cut-and-wipe-text (arg)
  "Kill text between point and mouse; also copy to window system cut buffer."
  (x-cut-text arg t))

(defun x-mouse-ignore (arg)
  "Don't do anything.")

(defun x-buffer-menu (arg)
  "Pop up a menu of buffers for selection with the mouse."
  (let ((menu
	 (list "Buffer Menu"
	       (cons "Select Buffer"
		     (let ((tail (buffer-list))
			   head)
		       (while tail
			 (let ((elt (car tail)))
			   (if (not (string-match "^ "
						  (buffer-name elt)))
			       (setq head (cons
					   (cons
					    (format
					     "%14s   %s"
					     (buffer-name elt)
					     (or (buffer-file-name elt) ""))
					    elt)
					   head))))
			 (setq tail (cdr tail)))
		       (reverse head))))))
    (switch-to-buffer (or (x-popup-menu arg menu) (current-buffer)))))

(defun x-help (arg)
  "Enter a menu-based help system."
  (let ((selection
	 (x-popup-menu
	  arg
	  '("Help" ("Is there a command that..."
		    ("Command apropos" . command-apropos)
		    ("Apropos" . apropos))
		   ("Key Commands <==> Functions"
		    ("List all keystroke commands" . describe-bindings)
		    ("Describe key briefly" . describe-key-briefly)
		    ("Describe key verbose" . describe-key)
		    ("Describe Lisp function" . describe-function)
		    ("Where is this command" . where-is))
		   ("Manual and tutorial"
		    ("Info system" . info)
		    ("Invoke Emacs tutorial" . help-with-tutorial))
		   ("Odds and ends"
		    ("Last 100 Keystrokes" . view-lossage)
		    ("Describe syntax table" . describe-syntax))
		   ("Modes"
		    ("Describe current major mode" . describe-mode)
		    ("List all keystroke commands" . describe-bindings))
		   ("Administrivia"
		    ("View Emacs news" . view-emacs-news)
		    ("View the GNU Emacs license" . describe-copying)
		    ("Describe distribution" . describe-distribution)
		    ("Describe (non)warranty" . describe-no-warranty))))))
    (and selection (call-interactively selection))))

; Prevent beeps on button-up.  If the button isn't bound to anything, it
; will beep on button-down.
(define-key mouse-map x-button-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-s-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-s-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-s-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-m-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-m-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-m-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-m-s-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-m-s-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-m-s-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-s-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-s-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-s-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-m-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-m-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-m-left-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-m-s-right-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-m-s-middle-up 'x-mouse-ignore)
(define-key mouse-map x-button-c-m-s-left-up 'x-mouse-ignore)

(define-key mouse-map x-button-c-s-left 'x-buffer-menu)
(define-key mouse-map x-button-c-s-middle 'x-help)
(define-key mouse-map x-button-c-s-right 'x-mouse-keep-one-window)
(define-key mouse-map x-button-s-middle 'x-cut-text)
(define-key mouse-map x-button-s-right 'x-paste-text)
(define-key mouse-map x-button-c-middle 'x-cut-and-wipe-text)
(define-key mouse-map x-button-c-right 'x-mouse-select-and-split)

(if (= window-system-version 10)
    (progn
      (define-key mouse-map x-button-right 'x-mouse-select)
      (define-key mouse-map x-button-left 'x-mouse-set-mark)
      (define-key mouse-map x-button-middle 'x-mouse-set-point))
  (define-key mouse-map x-button-right 'x-cut-text)
  (define-key mouse-map x-button-left 'x-mouse-set-point)
  (define-key mouse-map x-button-middle 'x-paste-text))
