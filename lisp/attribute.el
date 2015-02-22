;; Character attribute handling
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

;; written by K. HANDA, Electrotechnical Lab., JAPAN, 1989.

;;; Change Log
;;; 89.11.28 Created by K.Handa
;;; 89.12.10 Update screen after attributes are changed.  by K.Handa
;;; 92.1.20  Completely re-written for Mule 0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.6.24  modified for Mule Ver.0.9.5 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	attribute-on-off-region signals error if buffer-read-only is t.
;;; 92.7.7  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Support for reading/writing files with attribute information.
;;; 92.8.5  modified for Mule Ver.0.9.5.1 by K.Shibata <shibata@sgi.co.jp>
;;;	attribute-record-region-modified should not alter buffer-modified-p.
;;; 92.8.5  modified for Mule Ver.0.9.5.1 by Y.Kawabe <kawabe@sra.co.jp>
;;;	In attribute-reduce, variable 'attr' should be local.
;;; 93.8.30 modified by S.Tomura <tomura@etl.go.jp>
;;;     attribute-get-attribute is re-written and attribute-get-attribute-mask is added.
;;; 93.8.31 mofified by S.Tomura <tomura@etl.go.jp>
;;;     attribute-cursor-attribute, attribute-make-cursor-invisible-if-possible and attribute-make-cursor-visible is added.

(provide 'attribute)

(defvar attribute-underline 1 "Mask bit for underline attribute.")
(defvar attribute-inverse 2 "Mask bit for inverse attribute.")
(defvar attribute-bold 4 "Mask bit for bold attribute.")

(defconst attribute-mask-bit-alist
  (list (cons 'underline attribute-underline)
	(cons 'inverse   attribute-inverse)
	(cons 'bold      attribute-bold)
	))

(defun attribute-get-attribute-mask-bit (attr)
  (cdr (assq attr attribute-mask-bit-alist)))

(defun attribute-on-region (attr &optional from to)
  "Turn on ATTR for the characters within the region.
Currently supported attributes are 'underline', 'inverse', and 'bold'.
Called from program, takes two optional arguments FROM and TO.
If FROM or TO is NIL, (point-min) or (point-max) is used instead.
Information of attribute is stored in a buffer local variable
attributed-region, but manipulating this variabel directly may cause
serious problems."
  (interactive
   (list (attribute-symbol-read) (mark) (point)))
  (attribute-on-off-region attr from to 'on))

(defun attribute-off-region (attr &optional from to)
  "Turn off ATTR for the characters within the region.
See the function attribute-on-region for the detail."
  (interactive
   (list (attribute-symbol-read) (mark) (point)))
  (attribute-on-off-region attr from to nil))

(defun attribute-symbol-read ()
  (intern (completing-read
	   "Attribute: " '(("inverse") ("underline") ("bold")) nil t)))

(defun attribute-get-attribute (&optional pos)
  "Return a list of attributes at POS.
POS is optional argument and the default is the current point."
  (if (not pos) (setq pos (point)))
  (let ((mask (attribute-get-attribute-mask pos))
	(result nil))
    (if (< 0 (logand mask attribute-underline))
	(setq result (cons 'underline result)))
    (if (< 0 (logand mask attribute-inverse))
	(setq result (cons 'inverse result)))
    (if (< 0 (logand mask attribute-bold))
	(setq result (cons 'bold result)))
    result))

(defun attribute-get-attribute-mask (&optional pos)
  "Return a attribute mask at POS.
POS is optional argument and the default is the current point."
  (if (not pos) (setq pos (point)))
  (let ((attrs attributed-region))
    (while (and (cdr attrs)
		(not (< pos (car (car (cdr attrs))))))
      (setq attrs (cdr attrs)))
    (if attrs (cdr (car attrs)) 0)))

(defun attribute-on-off-region (attr &optional from to on)
  (barf-if-buffer-read-only)		; 92.6.24 by T.Enami
  (let ((min (point-min)) (max (point-max)))
    (if (or (not from) (< from min)) (setq from min)
      (if (> from max) (setq from max)))
    (if (or (not to) (> to max)) (setq to max)
      (if (< to min) (setq to min))))
  (if (> from to) (let ((temp from)) (setq from to) (setq to temp)))
  (attribute-record-region-modified from to)
  (let* ((attribute (attribute-get-attribute-mask-bit attr)))
    (if attribute
	(attribute-modify-attribute attribute from to on)
      (error "Invalid attribute:%s" attr))))

(defun attribute-reduce ()
  (let ((old-attr 0)
	(prev attributed-region)
	(now (cdr attributed-region))
	attr)				; 92.8.5 by Y.Kawabe
    (while now
      (setq attr (cdr (car now)))
      (if (= old-attr attr)
	  (progn
	    (set-marker (car (car now)) nil)
	    (rplacd prev (cdr now)))
	(setq old-attr attr)
	(if (and (= (car (car prev)) (car (car now)))
		 (eq (marker-point-type (car (car prev)))
		     (marker-point-type (car (car now)))))
	    (progn
	      (rplaca prev (cons (car (car prev)) old-attr))
	      (set-marker (car (car now)) nil)
	      (rplacd prev (cdr now)))
	  (setq prev now)))
      (setq now (cdr now))))
  attributed-region)

(defun attribute-modify-attribute (attr from to on)
  (let ((m1 (make-marker))
	(m2 (make-marker)))
    (set-marker m1 from)
    (set-marker m2 to)
    (set-marker-type m2 'point-type)
    (if attributed-region
	(let ((prev attributed-region)
	      (now (cdr attributed-region))
	      old-attr new-attr)
	  ;; prev -> ((0 . 0)  (m1 . a1) ... (mi . ai) ... (mj . aj))
	  ;; now  -> ((m1 . a1) ... (mi . ai) ... (mj . aj) ... (mn . an))
	  ;; where mi-1 < from <= mi && mj-1 < to <= mj
	  (while (and now
		      (< (car (car now)) from))
	    (setq prev now)
	    (setq now (cdr now)))
	  ;; prev -> ((mi-1 . ai-1) (mi . ai) ... (mj . aj) ... (mn . an))
	  ;; now  -> ((mi . ai) ... (mj . aj) ... (mn . an))
	  (setq old-attr (cdr (car prev)))
	  (setq new-attr (if on (logior old-attr attr)
			   (logand old-attr (lognot attr))))
	  (rplacd prev (cons (cons m1 new-attr) now))
	  ;; prev -> ((mi-1 . ai-1) (from . ai-1^attr) (mi . ai) ...)
	  (setq prev (cdr prev))
	  ;; prev -> ((from ai-1^attr) (mi . ai) ... (mj . aj) ...)
	  ;; now  -> ((mi . ai) ... (mj . aj) ... (mn . an))
	  (while (and now
		      (<= (car (car now)) to))
	    (setq old-attr (cdr (car now)))
	    (setq new-attr (if on (logior old-attr attr)
			     (logand old-attr (lognot attr))))
	    (rplaca now (cons (car (car now)) new-attr))
	    (setq prev now)
	    (setq now (cdr now)))
	  ;; prev -> ((mj-1 . aj-1^attr) (mj . aj) ...)
	  ;; now  -> ((mj . aj) ...)
	  (rplacd prev (cons (cons m2 old-attr) now))
	  ;; prev -> ((mj-1 . aj-1^attr) (to . aj-1^attr) (mj . aj) ...)
	  (attribute-reduce)
	  )
      (if on
	  (setq attributed-region
		(list (cons 0 0)
		      (cons m1 attr)
		      (cons m2 0)))))))

;; There should be a better way! :-(
(defun attribute-record-region-modified (from to)
  (let ((save (buffer-modified-p)))	; 92.8.5 by K.Shibata
    ;(subst-char-in-region from to 0 0 'noundo)
    (redisplay-region from to)
    (set-buffer-modified-p save)))

;; 92.7.7 by K.Handa
;; Support for reading/writing files with attribute information.

(defvar attribute-esc-sequence-hook nil
  "A hook function to be exectuted instead of attribute-esc-sequence.
The function should return string of escape sequence by refering to
a varialble *attribute-current-attr*.")

(defvar attribute-ANSI
  [ "\e[0m" "\e[4m" "\e[7m" "\e[1m" ]
  "Array of ANSI escape sequence for each attribute.")

(defun attribute-esc-sequence (attr)
  "Generate escape sequence for attribute on/off."
  (if (fboundp 'attribute-esc-sequence-hook)
      (let ((*attribute-current-attr* attr))
	(attribute-esc-sequence-hook))
    (let ((esc-seq ""))
      (if (> (logand attr attribute-underline) 0)
	  (setq esc-seq (concat (aref attribute-ANSI 1)	esc-seq)))
      (if (> (logand attr attribute-inverse) 0)
	  (setq esc-seq (concat (aref attribute-ANSI 2)	esc-seq)))
      (if (> (logand attr attribute-bold) 0)
	  (setq esc-seq (concat (aref attribute-ANSI 3)	esc-seq)))
      (setq esc-seq (concat (aref attribute-ANSI 0) esc-seq))
      esc-seq)))

(defun attribute-to-esc-sequence ()
  "The current buffer's attribute information is converted to escape sequence
inserted at attributing point."
  (interactive "*")
  (save-excursion
    (let (attr m)
      (while attributed-region
	(setq m (car (car attributed-region))
	      attr (cdr (car attributed-region)))
	(if (and (= m 0) (= attr 0)) nil
	  (goto-char m)
	  (insert (attribute-esc-sequence attr)))
	(setq attributed-region (cdr attributed-region))))
    (attribute-record-region-modified (point-min) (1- (point-max)))))

(defun attribute-from-esc-sequence ()
  "The escape sequence for attribute in the current buffer is conveted
to the real attribute information 'attributed-region'."
  (interactive)
  (save-excursion
    (let* ((reset (regexp-quote (aref attribute-ANSI 0)))
	   (underline (regexp-quote (aref attribute-ANSI 1)))
	   (inverse (regexp-quote (aref attribute-ANSI 2)))
	   (bold (regexp-quote (aref attribute-ANSI 3)))
	   (target (format "\\(%s\\|%s\\|%s\\|%s\\)+"
			   reset underline inverse bold))
	   marker attr attr-start attr-end
	   buffer-read-only)
      (goto-char (point-min))
      (setq attributed-region nil)
      (while (re-search-forward target nil t)
	(setq attr 0)
	(setq attr-start (match-beginning 0) attr-end (match-end 0))
	(goto-char attr-start)
	(if (re-search-forward underline attr-end t)
	    (setq attr (logior attr attribute-underline)))
	(goto-char attr-start)
	(if (re-search-forward inverse attr-end t)
	    (setq attr (logior attr attribute-inverse)))
	(goto-char attr-start)
	(if (re-search-forward bold attr-end t)
	    (setq attr (logior attr attribute-bold)))
	(delete-region attr-start attr-end)
	(setq marker (make-marker))
	(set-marker marker (point))
	(setq attributed-region (cons (cons marker attr) attributed-region)))
      (setq attributed-region (cons '(0 . 0) (nreverse attributed-region))))))

(defun attribute-write-file ()
  "Write current buffer with attribute information."
  (interactive)
  (let ((current-buf (current-buffer))
	(current-attr attributed-region)
	(current-file-coding-system file-coding-system)
	(buf (generate-new-buffer " *temp*"))
	attr marker)
    (unwind-protect
	(progn
	  (set-buffer buf)
	  (insert-buffer current-buf)
	  (setq attributed-region nil)
	  (while current-attr
	    (setq attr (car current-attr))
	    (setq marker (make-marker))
	    (set-marker marker (car attr))
	    (setq attributed-region
		  (cons (cons marker (cdr attr)) attributed-region))
	    (setq current-attr (cdr current-attr)))
	  (attribute-to-esc-sequence)
	  (setq file-coding-system current-file-coding-system)
	  (call-interactively 'write-file))
      (kill-buffer buf))))

(defun attribute-find-file ()
  "Edit file FILENAME.  Attribute is set automatically."
  (interactive)
  (call-interactively 'find-file)
  (let ((buffer-modified-flag (buffer-modified-p)))
    (attribute-from-esc-sequence)
    (set-buffer-modified-p buffer-modified-flag)))

(defvar attribute-cursor-attribute nil
  "*A cursor attribute")

(defvar attribute-cursor-attribute-invisible nil)

(defun attribute-make-cursor-invisible-if-possible ()
  "\
Make the cursor invisible if the character attributes at point include the
cursor attribute.\n\
See the variable attribute-cursor-attribute.\n\
CAUTION: Before the cursor moves, the function
attribute-make-cursor-visible must be called."
  (let ((p-mask (attribute-get-attribute-mask))
	(c-mask (attribute-get-attribute-mask-bit attribute-cursor-attribute))
	(from (point))
	(to   (+ (point)
		 (char-width (following-char)))))
    (cond((not (= (logand p-mask c-mask) 0))
	  (setq attribute-cursor-attribute-erased t)
	  (attribute-on-off-region attribute-cursor-attribute from to nil)))))

(defun attribute-make-cursor-visible ()
  "Restore the character attribute which the function
attribute-erase-if-possible has gotten off."
  (if attribute-cursor-attribute-erased
      (let ((from (point))
	    (to   (+ (point)
		     (char-width (following-char)))))
	(attribute-on-off-region attribute-cursor-attribute from to t))))
 
