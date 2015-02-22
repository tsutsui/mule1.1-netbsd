;;
;; demacs.el DOS Emacs specific functions
;;
;; Author: HIRANO Satoshi  hirano@tkl.iis.u-tokyo.ac.jp
;;
;; Copyright (C) 1991 Halca Computer Science Laboratory TM
;;                    University of Tokyo

;; This file is part of Demacs. 

;; Demacs is distributed under the terms of the GNU EMACS GENERAL
;; PUBLIC LICENCE.

;; Everyone is granted permission to copy, modify and redistribute
;; Demacs, but only under the conditions described in the
;; GNU Emacs General Public License. The copyright notice and this
;; notice must be preserved on all copies.

;; Edition History:
;;
;; Demacs Date     By               Nemacs  Emacs
;; ------ -------- ---------------- ------- -------
;; 1.1.1  91/10/16 Halca.Hirano     3.3.2   18.55
;;   creation
;;   Things to do: CTRL-C, fix call-process, parent directory write protect
;;
;; 1.1.2  91/10/23 Manabu Higashida 3.3.2   18.55
;;   slightly modification including bug fix
;;   Things to do: get size of free disk space and set it to core limit size.
;;                 handle unready floppy disk drive.
;;
;; 1.1.3  91/10/29 Manabu Higashida 3.3.2   18.55 (partly 18.57)
;;   bug fix
;;
;; 1.1.4  91/11/22 Manabu Higashida 3.3.2   18.55 (partly 18.57)
;;   bug fix and pc98 specified fetures
;;
;; 1.1.5  91/11/25 Manabu Higashida 3.3.2   18.55 (partly 18.57)
;;   bug fix and addition of pc98 terminal specified fetures
;;
;; 1.1.6  91/11/27 Manabu Higashida 3.3.2   18.55 (partly 18.57)
;;   bug fix thanks to mrs@netcom.com
;;

(defconst demacs-version "1.4.0" "\
Version numbers of this version of Demacs. major.minor.local")

(defconst demacs-version-date "1993.6.3" "\
Distribution date of this version of Demacs.")


(defun demacs-version ()  "\
Return string describing the version of Demacs that is running."
  (interactive)
  (if (interactive-p)
      (message "%s" (demacs-version))
    (format "Demacs version %s of %s" demacs-version demacs-version-date)))

;;
;; Re-definition of variables specific to DOS and Win32
;;
(setq user-init-filename "_emacs")
(setq null-filename "nul")
(setq backup-filename "~/backup.~")
(setq shell-command-option "\/c")
(setq abbrev-file-name "~/abbrev.def")
(setq save-context-predicate
      (function
       (lambda (w)
	 (and (buffer-file-name (window-buffer w))
	      (not (string-match ".:\\(/usr\\)?/tmp/"
				 (buffer-file-name (window-buffer w))))))))
;;
;; Re-definition of function specific to DOS
;;

(defun dos-add-char-to-file-name (file char)
  (let ((fn (file-name-nondirectory file)))
    (concat (file-name-directory file)
	    (if (string-match "\\..*$" fn)
		(let ((ext (substring fn (1+ (match-beginning 0))))
		      (body (substring fn 0 (match-beginning 0))))
		  (if (< (length ext) 3)
		      (concat fn char)
		    (concat body "." (substring ext 0 2) char)))
	      (concat fn "." char)))))

(defun make-backup-file-name (file)
  "Create the non-numeric backup file name for FILE.
This is a separate function so you can redefine it for customization.
On ms-dos system rule, foo -> foo.~, foo.c -> foo.c~, foo.abc -> foo.ab~"
  (dos-add-char-to-file-name file "~"))

(defun make-auto-save-file-name ()
  "Return file name to use for auto-saves of current buffer.
Does not consider auto-save-visited-file-name; that is checked
before calling this function.
You can redefine this for customization.
See also auto-save-file-name-p.
On ms-dos system rule, abcdefgh -> #abcdefg.# or #%abcdef.#, 
foo.c -> #foo.c# and foo.abc -> #foo.ab#."
  (if buffer-file-name
      (concat (file-name-directory buffer-file-name)
              "#"
	      (dos-add-char-to-file-name
	       (file-name-nondirectory buffer-file-name) "#"))
    (expand-file-name (concat "#%"
			      (dos-add-char-to-file-name (buffer-name) "#")))))



;(setq-default mode-line-format
;  (list (purecopy "")
;   '(mc-verbose-code "%C" "%c")
;   '(mc-flag ":" "-")
;   'mode-line-modified
;   'mode-line-buffer-identification
;   (purecopy "   ")
;   'global-mode-string
;   (purecopy "  %[(")
;   'mode-name 'minor-mode-alist "%n"
;   '(file-translation-mode " DOS-Text" " Binary")
;   'mode-line-process
;   (purecopy ")%]--")
;   (purecopy '(-3 . "%p"))
;   (purecopy "-%-")))
;
;;;
;;; The following are ramains for backward compatibility.
;;;   OLD: file-type     NEW: file-translation-mode
;;;   ("text"   . 0) <=> (*dos-text* . 1)
;;;   ("binary" . 1) <=> (nil . 0)
;
;(defun convert-file-type-to-file-translation-mode (code)
;  (if (= code 0) *dos-text*))
;
;;; file-type   (0 "text") (1 "binary")
;(setq-default file-type 0)
;(setq-default file-translation-mode *dos-text*)
;
;;;
;;; utilities
;;;
;(defconst file-type-alist '(("text" . 0) ("binary" . 1)))
;
;(defun file-type-internal (code)
;  (let ((case-fold-search t)
;	(string (cond ((stringp code) code)
;		      ((symbolp code) (symbol-name code))
;		      (t ""))))
;    (cond ((string-match "t.*" string)
;	   0)
;	  ((string-match "b.*" string)
;	   1)
;	  (t 0))))
;
;(defun set-file-type (code &optional buffer)
;  (interactive (list (completing-read "File Type : "
;				      file-type-alist nil t nil)))
;  (or (null code)
;      (if (symbolp code)
;	  (setq code (file-type-internal code))
;	(if (stringp code)
;	    (setq code (cdr (assoc code file-type-alist))))
;	(if (not (file-type-p code))
;	    (setq code (cdr (assoc (completing-read "File Type : "
;						    file-type-alist nil t nil)
;				   file-type-alist))))))
;  (save-excursion
;    (set-buffer (or buffer (current-buffer)))
;    ;; 92.11.2 by M.Higashida
;    (setq file-translation-mode 
;	  (convert-file-type-to-file-translation-mode code)))
;  code)
;
;(defun set-default-file-type (code)
;  (interactive (list (completing-read "File Type : "
;				      file-type-alist nil t nil)))
;  (or (null code)
;      (if (symbolp code)
;	  (setq code (file-type-internal code))
;	(if (stringp code)
;	    (setq code (cdr (assoc code file-type-alist))))
;	(if (not (file-type-p code))
;	    (setq code (cdr (assoc (completing-read "File Type : "
;						    file-type-alist nil t nil)
;				   file-type-alist))))))
;  ;; 92.11.2 by M.Higashida
;  (setq-default file-translation-mode 
;		(convert-file-type-to-file-translation-mode code)))
;
;(defun file-type-p (code)
;  (and (numberp code) (or (eq 0 code) (eq 1 code))))
;
;;; 92.11.2 by M.Higashida
;(defun invoke-find-file-translation-mode (filename)
;  (save-excursion
;    (funcall find-file-translation-mode filename)))
;
;;; 92.11.2 by M.Higashida
;(setq find-file-translation-mode
;      'find-file-type-from-file-name)
;
;(defvar file-name-file-type-alist
;  '(
;    ("\\.elc$" . 1)  ; *.elc binary
;    ("\\.obj$" . 1)  ; *.obj binary
;    ("\\.exe$" . 1)  ; *.exe binary
;    ("\\.com$" . 1)  ; *.com binary
;    ("\\.lib$" . 1)  ; *.lib binary
;    ("[:/].*config.sys" . 0); config.sys text
;    ("\\.sys$" . 1)  ; *.sys binary
;    ("\\.chk$" . 1)  ; *.chk binary ;; chkdsk.exe dumps this.
;    ("\\.o$"   . 1)  ; *.o binary
;    ("\\.a$"   . 1)  ; *.a binary
;    ("\\.out$" . 1)  ; *.out binary
;    ))
;
;(defun find-file-type-from-file-name (filename)
;  (let ((alist file-name-file-type-alist)
;	(found nil)
;	(code nil))
;    (let ((case-fold-search (eq system-type 'ms-dos)))
;      (setq filename (file-name-sans-versions filename))
;      (while (and (not found) alist)
;	(if (string-match (car (car alist)) filename)
;	    (setq code (cdr (car alist))
;		  found t))
;	(setq alist (cdr alist))))
;    (setq code (if code
;		   (cond( (numberp code) code)
;			( (and (symbolp code) (fboundp code))
;			  (funcall code filename visit start end)))
;		 (default-value 'file-type)))
;    ;; 92.11.2 by M.Higashida
;    (convert-file-type-to-file-translation-mode code)))
;
;(defun define-file-name-file-type (filename code)
;  (let* ((place (assoc filename file-name-file-type-alist)))
;    (if place
;	(setcdr place code)
;      (setq place (cons filename code)
;	    file-name-file-type-alist (cons place file-name-file-type-alist)))
;    place))
;
;;;;
;
;(defun find-file-not-found-set-file-translation-mode ()
;  (save-excursion
;    (set-buffer (current-buffer))
;    (setq file-translation-mode
;	  (convert-file-type-to-file-translation-mode
;	   (find-file-type-from-file-name (buffer-file-name)))))
;  nil)
