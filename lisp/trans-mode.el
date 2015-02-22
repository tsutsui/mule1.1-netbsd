;; File translation mode support staff.
;;
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

;;; 92.11.2  created for Mule Ver.0.9.6 with DOS support
;;; 		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>

(setq-default mode-line-format
  (list (purecopy "")
   '(mc-verbose-code "%C" "%c")
   '(mc-flag ":" "-")
   'mode-line-modified
   'mode-line-buffer-identification
   (purecopy "   ")
   'global-mode-string
   (purecopy "  %[(")
   'mode-name "%t" 'minor-mode-alist "%n" 'mode-line-process
   (purecopy ")%]--")
   (purecopy '(-3 . "%p"))
   (purecopy "-%-")))

(defconst *protected-local-variables* 
  (append 
   '(file-translation-mode)
   *protected-local-variables*)
  "List of buffer local variables protected from `kill-all-local-variables'."
  )

;; utilities

(defconst *file-translation-mode-obarray* (make-vector 10 0))

;;; nil		: Do Nothing (ex. MS-DOS Binary)
;;; *dos-text*	: MS-DOS Text
(intern "nil" *file-translation-mode-obarray*)
(intern "*dos-text*" *file-translation-mode-obarray*)

(defun check-file-translation-mode (mode)
  (let (found)
    (mapatoms '(lambda (atom)
		 (if (string= (symbol-name atom) (symbol-name mode))
		     (setq found t)))
	      *file-translation-mode-obarray*)
    (if (null found) (error "Invalid file-translation-mode: %s" mode))))

(defmacro read-file-translation-mode (prompt)
  (list 'intern
	(list 'completing-read prompt '*file-translation-mode-obarray*
	      nil t)))

(defun set-file-translation-mode (mode &optional buffer)
  (interactive (list (read-file-translation-mode "file-translation-mode: ")))
  (check-file-translation-mode mode)
  (save-excursion
    (set-buffer (or buffer (current-buffer)))
    (setq file-translation-mode mode))
  (update-mode-lines))

(defun set-default-file-translation-mode (mode)
  (interactive (list (read-file-translation-mode "file-translation-mode: ")))
  (check-file-translation-mode mode)
  (setq-default file-translation-mode mode))

;;;

(defun dos-text ()
  (interactive)
  (let* ((old (default-value 'file-translation-mode))
	 (prefix-arg current-prefix-arg)
	 (key (read-key-sequence "DOS-Text: "))
	 (cmd (key-binding key)))
    (message "")
    (if (null cmd)
	(beep)
      (let ((last-command-char (string-to-char key)))
	(unwind-protect
	    (progn
	      (setq-default file-translation-mode *dos-text*)
	      (command-execute cmd))
	  (setq-default file-translation-mode old))))))

;;; override `insert-file-contents'

(defun insert-file-contents (filename &optional visit)
  "Insert contents of file FILENAME after point.
Returns list of absolute pathname and length of data inserted.
If second argument VISIT is non-nil, the buffer's visited filename
and last save file modtime are set, and it is marked unmodified.
If visiting and the file does not exist, visiting is completed
before the error is signaled.
The coding-system for reading is file-coding-system-for-read.
If current buffer's file-coding-system is nil,
 it is set to the coding-system which actually used for reading.
See also insert-file-contents-pre-hook, insert-file-contents-error-hook,
 insert-file-contents-post-hook, and si:insert-file-contents."
  (let (coding-system return-val)
    (condition-case err
	(progn
	  (setq coding-system
		(cond (insert-file-contents-pre-hook
		       (funcall insert-file-contents-pre-hook filename visit))
		      ((eq file-coding-system-for-read 'query)
		       (read-coding-system "Coding-system: "))
		      (t file-coding-system-for-read)))
	  (if (consp coding-system) nil
	    ;;; 92.11.2 by M.Higashida
	    (set-file-translation-mode file-translation-mode)
	    ;;; end of patch
	    (setq return-val
		  (si:insert-file-contents filename visit coding-system))))
      (file-error
       (if insert-file-contents-error-hook
	   (set-file-coding-system
	    (funcall insert-file-contents-error-hook filename visit)))
       (signal (car err) (cdr err))))
    (if (consp coding-system)
	coding-system
      (if insert-file-contents-post-hook
	  (set-file-coding-system
	   (funcall insert-file-contents-post-hook filename visit return-val))
	(if (and (car return-val)
		 (not (and file-coding-system
			   (local-file-coding-system-p))))
	    (set-file-coding-system (car return-val))))
      (cdr return-val))))

;;; override `write-region'

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
 If CODING-SYSTEM is 'query or a prefix argument is supplied,
 user can specify the coding-system interactively.
If called interactively with prefix arg, user is asked conding-system.
See also write-region-pre-hook, write-region-post-hook,
 and si:write-region."
  (interactive
   ;; 92.3.17 by K.Handa,
   (let ((s (mark)) (e (point)) f c)
     (if (not s) (error "The mark is not set now"))
     (if (> s e) (setq e s s (point)))
     (setq f (read-file-name "Write region to file: " nil nil nil))
     (setq c (if current-prefix-arg 'query file-coding-system))
     (list s e f nil nil c)))
  (setq coding-system
	(cond (write-region-pre-hook
	       (funcall write-region-pre-hook
			start end filename append visit coding-system))
	      ((eq coding-system 'query)
	       (read-coding-system "Coding-system: "))
	      (coding-system coding-system)
	      (t file-coding-system)))
  (if (consp coding-system)
      coding-system
    ;;; 92.11.2 by M.Higashida
    (set-file-translation-mode file-translation-mode)
    ;;; end of patch
    (si:write-region start end filename append visit coding-system)
    (set-file-coding-system coding-system)
    (if write-region-post-hook
	(funcall write-region-post-hook
		 start end filename append visit coding-system))))
