;; Loaded while creating/installing Mule.
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

;;; 92.3.16  created for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.4.6   modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
;;;	Files to be byte-compiled are supplied by command line args.
;;;	Load .el file instead of .elc file if it is patched.
;;; 92.7.27  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	purify-flag is set to nil.
;;; 92.11.22 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	Original mule-bytecomp.el and dump-charsets (in mult-util.el)
;;;	is merged into this file.
;;; 93.2.11  modified for Mule Ver.0.9.7.1 by S.Tatsukawa <tatsu_s@ch.hp.com>
;;;	version.el is loaded for bytecompe 2.05.

(defun load-necessary-files ()
  (message "Loading necessary files for byte-compile...")
  (load "version" nil t)		;93.2.11 by S.Tatsukawa
  (garbage-collect)
  (load "subr" nil t)
  (garbage-collect)
  (load "loaddefs.el" nil t)
  (garbage-collect)
  (load "mule.el" nil t)
  (garbage-collect)
  (load "simple.el" nil t)
  (garbage-collect)
  (load "files.el" nil t)
  (garbage-collect)
  (load "replace.el" nil t)
  (garbage-collect)
  (load "lisp" nil t)
  (garbage-collect)
  (load "lisp-mode" nil t)
  (garbage-collect)
  (load "bytecomp.el" nil t)
  (garbage-collect)
  )

(defun mule-byte-compile ()
  "Byte compile all files which are patched or created for Mule."
  ;; 92.7.27 by K.Handa - Not to use pure lisp storage.
  (setq purify-flag nil)

  (let ((args command-line-args)
	bytecomp-loaded dir files el elc)
    (while (and args (null (string-match "mule-inst" (car args))))
      (setq args (cdr args)))
    (setq args (cdr args))
    (setq dir (car args))
    (setq files (cdr args))
    (if (and dir (file-readable-p dir))
	(while files
	  (setq elc (concat dir (car files)))
	  (setq el (substring elc 0 -1))
	  (if (and (file-readable-p el)
		   (file-newer-than-file-p el elc))
	      (progn
		(if (null bytecomp-loaded)
		    (progn
		      (load-necessary-files)
		      (setq bytecomp-loaded t)))
		(byte-compile-file el)))
	  (setq files (cdr files)))
      (message "No directory: %s" dir)))
  (kill-emacs))

(defun dump-charsets ()
  "Write out a list of existing character sets."
  (let ((args command-line-args))
    (while (and args (null (string-match "mule-inst" (car args))))
      (setq args (cdr args)))
    (setq args (cdr args))
    (if args
	(progn
	  (list-character-sets)
	  (set-buffer "*Help*")
	  (write-file (car args)))))
  (kill-emacs))

(if (string-match "temacs" (car command-line-args))
    (mule-byte-compile)
  (dump-charsets))
