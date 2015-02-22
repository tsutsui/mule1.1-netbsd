;Load up standardly loaded Lisp files for Emacs.
;; This is loaded into a bare Emacs to make a dumpable one.
;; Copyright (C) 1985, 1986 Free Software Foundation, Inc.

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

;;; Disable undo in the *scratch* buffer so it doesn't get dumped.
(buffer-flush-undo (get-buffer "*scratch*"))

;;; 87.7.15  modified for Nemacs Ver.2.0 by K.Handa
;;; 89.3.22  modified for Nemacs Ver.3.0 by K.Handa
;;; 90.2.28  modified for Nemacs Ver.3.3.0 by K.Handa
;;; 91.11.4  modified for Nemacs Ver.4.0.0 by K.Handa <handa@etl.go.jp>
;;; 92.3.5   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.5.1   modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;;	mule-config.el is loaded just after mule.el.
;;; 92.5.18  modified for Mule Ver.0.9.4 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	If WNN4 is defined, load wnn4-egg, else load wnn4v3-egg.
;;; 92.7.8   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Support for WNN3 and WNN4V3 stopped.
;;; 92.7.8   modified for Mule Ver.0.9.5 by Y.Kawabe <kawabe@sramhc.sra.co.jp>
;;;	Support for SJ3 started.
;;; 92.10.16 modified for Mule Ver.0.9.6
;;;			by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;;	DOS specific loadup files.
;;;	DOS does not support Snarf-dcumentation, aliases of filename.
;;; 92.10.18 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	'attribute' and 'kinsoku' is auto loaded.
;;;	'keyboard' and 'mule-util' are loaded here.
;;; 93.2.10  modified for Mule Ver.0.9.7.1
;;;				by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	Used purebytes is shown just before dumping.

(load "subr")
(garbage-collect)
(load "loaddefs.el")  ;Don't get confused if someone compiled loaddefs by mistake.
(garbage-collect)
;; 92.3.5 patch by K.Handa
(load "mule")
(garbage-collect)
;; 92.5.1 by K.Handa
(load "mule-conf.el")
(garbage-collect)
;; end of patch
(load "simple")
(garbage-collect)
(load "help")
(garbage-collect)
(load "files")
(garbage-collect)
(load "indent")
(load "window")
(load "paths.el")  ;Don't get confused if someone compiled paths by mistake.
(garbage-collect)
(load "startup")
(load "lisp")
(garbage-collect)
(load "page")
(load "register")
(garbage-collect)
(load "paragraphs")
(load "lisp-mode")
(garbage-collect)
(load "text-mode")
(load "fill")
(garbage-collect)
(load "c-mode")
(garbage-collect)
(load "isearch")
(garbage-collect)
(load "replace")
(if (eq system-type 'vax-vms)
    (progn
      (garbage-collect)
      (load "vmsproc")))
(garbage-collect)
(load "abbrev")
(garbage-collect)
(load "buff-menu")
(if (eq system-type 'vax-vms)
    (progn
      (garbage-collect)
      (load "vms-patch")))
(load "debug")
(garbage-collect)
;;; 87.7.15, 88.6.20, 89.3.22, 91.11.4, 92.10.19 modified by K.Handa  
(load "keyboard")
(garbage-collect)
(load "mule-util")
(garbage-collect)
(if (boundp 'EGG) ;; For EGG user only
    (progn				; 92.5.19 by T.Shingu
      (load "egg")
      (cond ((boundp 'WNN4)		; 92.7.8 by K.Handa and Y.Kawabe
	     (load "wnn4-egg")
	     (setq egg-default-startup-file "eggrc-v41"))
	    ((boundp 'SJ3)
	     (load "sj3-client")
	     (load "sj3-egg")
	     (setq egg-default-startup-file "eggrc-sj3"))
	    (t (error
		"You should define WNN4 or SJ3 in mconfig.h.")))
      (garbage-collect)))
;;; end of patch

(if (boundp 'CANNA) (load "canna")) ;; 93.9.9 by A.Kon

;; 92.10.16, 93.3.3 by M.Higashida
(if (or (eq system-type 'ms-dos)
	(eq system-type 'win32))
    (progn
      (load "demacs")
      (garbage-collect)
      (if (fboundp 'int86)
          (progn
	    (load "dos-fns")
	    (garbage-collect)))
      (if (fboundp 'fep-init)
          (progn	    
            (load "fepctrl")
            (garbage-collect)))))
;; end of patch

;If you want additional libraries to be preloaded and their
;doc strings kept in the DOC file rather than in core,
;you may load them with a "site-load.el" file.
;But you must also cause them to be scanned when the DOC file
;is generated.  For VMS, you must edit ../etc/makedoc.com.
;For other systems, you must edit ../src/ymakefile.
(if (load "site-load" t)
    (garbage-collect))

(load "version.el")  ;Don't get confused if someone compiled version.el by mistake.

;; Note: all compiled Lisp files loaded above this point
;; must be among the ones parsed by make-docfile
;; to construct DOC.  Any that are not processed
;; for DOC will not have doc strings in the dumped Emacs.

(message "Finding pointers to doc strings...")
(if (and (fboundp 'dump-emacs)		;92.10.16 by M.Higashida
	 (not (eq system-type 'ms-dos)))
    (let ((name emacs-version))
      (while (string-match "[^-+_.a-zA-Z0-9]+" name)
	(setq name (concat (downcase (substring name 0 (match-beginning 0)))
			   "-"
			   (substring name (match-end 0)))))
      (copy-file (expand-file-name "../etc/DOC")
		 (concat (expand-file-name "../etc/DOC-") name)
		 t)
      (Snarf-documentation (concat "DOC-" name)))
    (Snarf-documentation "DOC"))
(message "Finding pointers to doc strings...done")

;;; 90.2.28  patch by K.Handa
;;; Now we load Mule related site configuration file.
(load "mule-init" t)
(garbage-collect)
;;; end of patch

;Note: You can cause additional libraries to be preloaded
;by writing a site-init.el that loads them.
;See also "site-load" above.
(load "site-init" t)
(garbage-collect)

(message "Pure bytes used: %d" pure-bytes-used)	;93.2.10 by T.Enami

;;; Re-enable undo in the *scratch* buffer, so the dumped Emacs will
;;; start up that way.
(buffer-enable-undo (get-buffer "*scratch*"))

(if (or (equal (nth 3 command-line-args) "dump")
	(equal (nth 4 command-line-args) "dump"))
    (if (eq system-type 'vax-vms)
	(progn 
	  (message "Dumping data as file temacs.dump")
	  (dump-emacs "temacs.dump" "temacs")
	  (kill-emacs))
      (if (eq system-type 'ms-dos)	;92.10.16 by M.Higashida
	  (progn
	    (message "Dumping data as file xemacs")
	    (dump-emacs "xemacs" "temacs")
	    (kill-emacs))
	(if (fboundp 'dump-emacs-data)
	    ;; Handle the IBM RS/6000, and perhaps eventually other machines.
	    (progn
	      ;; This strange nesting is so that the variable `name'
	      ;; is not bound when the data is dumped.
	      (message "Dumping data as file ../etc/EMACS-DATA")
	      (dump-emacs-data "../etc/EMACS-DATA")
	      (kill-emacs))
	  (let ((name (concat "emacs-" emacs-version)))
	    (while (string-match "[^-+_.a-zA-Z0-9]+" name)
	      (setq name (concat (downcase (substring name 0 (match-beginning 0)))
				 "-"
				 (substring name (match-end 0)))))
	    (message "Dumping under names xemacs and %s" name))
	  (condition-case ()
	      (delete-file "xemacs")
	    (file-error nil))
	  (dump-emacs "xemacs" "temacs")
	  ;; Recompute NAME now, so that it isn't set when we dump.
	  (let ((name (concat "emacs-" emacs-version)))
	    (while (string-match "[^-+_.a-zA-Z0-9]+" name)
	      (setq name (concat (downcase (substring name 0 (match-beginning 0)))
				 "-"
				 (substring name (match-end 0)))))
	    (add-name-to-file "xemacs" name t))
	  (kill-emacs)))))

;; Avoid error if user loads some more libraries now.
(setq purify-flag nil)

;; For machines with CANNOT_DUMP defined in config.h,
;; this file must be loaded each time Emacs is run.
;; So run the startup code now.

(or (fboundp 'dump-emacs)
    (eval top-level))
