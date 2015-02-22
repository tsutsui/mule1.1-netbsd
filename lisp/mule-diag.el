;; Diagnosis of Mule
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

;;; 93.7.28  created for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>

(defun princ-list (&rest args)
  (while args
    (if (car args)
	(progn (princ (car args)) (princ " ")))
    (setq args (cdr args)))
  (princ "\n"))

(defun mule-diag ()
  "Show diagnosis of the current running Mule."
  (interactive)
  (with-output-to-temp-buffer "*Diagnosis*"
    (princ-list "Your Mule's version:"
		mule-version "of" mule-version-date)
    (princ-list "Window-system:"
		(or window-system "none,")
		(or window-system-version "running on terminal"))
    (princ-list "---- Display ------------------------------------")
    (if (eq window-system 'x)
	(let ((lc 0) cs fontinfo)
	  (princ-list "Current font information:") 
	  (while (< lc 256)
	    (if (and (/= lc lc-composite) (/= lc lc-invalid)
		     (or (< lc lc-prv11) (> lc lc-prv22))
		     (nth 2 (setq cs (character-set lc)))
		     (setq fontinfo (x-get-fontinfo lc)))
		(progn
		  (princ-list "For" (nth 6 cs))
		  (princ-list " requested:" (or (car fontinfo) "none"))
		  (princ-list "    opened:"
			      (if (nth 1 fontinfo)
				  (nth 1 fontinfo)
				(if (nth 2 fontinfo)
				    "can't find" "not yet")))))
	    (setq lc (1+ lc))))
      (princ-list "Coding system for output to terminal:"
		  display-coding-system))
    (princ-list "---- Input methods ------------------------------")
    (if (memq 'egg features)
	(let (temp)
	  (princ-list "EGG ( Version" egg-version ")")
	  (apply 'princ-list
		 "  jserver host list:"
		 (if (boundp 'jserver-list) jserver-list
		   (if (setq temp (getenv "JSERVER"))
		       (list temp))))
	  (apply 'princ-list
		 "  cserver host list:"
		 (if (boundp 'cserver-list) cserver-list
		   (if (setq temp (getenv "CSERVER"))
		       (list temp))))
	  (princ-list "  loaded ITS mode:")
	  (apply 'princ-list "\t" (mapcar 'car its:*mode-alist*))
	  (princ-list "  current server:" wnn-server-type)
	  (princ-list "  current ITS mode:"
		      (let ((mode its:*mode-alist*))
			(while (not (eq (cdr (car mode)) its:*current-map*))
			  (setq mode (cdr mode)))
			(car (car mode))))
	  ))
    (if (memq 'quail features)
	(progn
	  (princ-list "QUAIL")
	  (princ-list "  loaded QUAIL packages:")
	  (apply 'princ-list "\t" (mapcar 'car *quail-package-alist*))
	  (princ-list "  current QUAIL package:"
		      (car *quail-current-package*))))
    (if (memq 'canna features)
	(progn
	  (princ-list "CANNA ( Version" canna-rcs-version ")")
	  (princ-list "  server:" (or canna-server "Not specified"))))
    (if (memq 'sj3-egg features)
	(progn
	  (princ-list "SJ3 ( Version" sj3-egg-version ")")
	  (princ-list "  server:" (get-sj3-host-name))))
    (princ-list "---- Coding-systems -----------------------------")
    (princ-list "Keyboard coding-system:"
		keyboard-coding-system)
    (princ-list "Default value of file-coding-system:"
		default-file-coding-system)
    (princ-list "Coding-system used file reading:"
		file-coding-system-for-read)
    (princ-list "Default coding-system for reading from a process:"
		(or (car default-process-coding-system) *noconv*))
    (princ-list "Default coding-system for writing to a process:"
		(or (cdr default-process-coding-system) *noconv*))
    )
  )
