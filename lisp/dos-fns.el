;; dos-fns.el: DOS function call support libraries.
;;
;; Edition History:
;; 1.1 91/12/07 Manabu Higashida Creation.
;;
 
;; Copyright (C) 1991 Free Software Foundation, Inc.

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

(defconst register-name-by-word-alist
  '((ax . 0) (bx . 1) (cx . 2) (dx .3)
    (si . 4) (di . 5)
    (cflag . 6) (flags . 7)))

(defconst register-name-by-byte-alist
  '((al . (0 . 0)) (ah . (0 . 1)) 
    (bl . (1 . 0)) (bh . (1 . 1)) 
    (cl . (2 . 0)) (ch . (2 . 1)) 
    (dl . (3 . 0)) (dh . (3 . 1))))

(defun make-register ()
  (make-vector 8 0))

(defun register-value (regs name)
  (let ((where (or (cdr (assoc name register-name-by-word-alist))
		   (cdr (assoc name register-name-by-byte-alist)))))
    (cond ((consp where)
	   (let ((tem (aref regs (car where))))
	     (if (zerop (cdr where))
		 (% tem 256)
	       (/ tem 256))))
	  ((numberp where)
	   (aref regs where))
	  (t nil))))

(defun set-register-value (regs name value)
  (and (numberp value)
       (> value 0)
       (let ((where (or (cdr (assoc name register-name-by-word-alist))
			(cdr (assoc name register-name-by-byte-alist)))))
	 (cond ((consp where)
		(setq value (% value 256))	; 0x100
		(let* ((tem (aref regs (car where)))
		       (l (% tem 256))
		       (h (/ tem 256)))
		  (if (zerop (cdr where))
		      (aset regs (car where) (+ (* h 256) value))
		    (aset regs (car where) (+ (* value 256) h)))))
	       ((numberp where)
		(setq value (% value 65536))	; 0x10000
		(aset regs where value)))))
  regs)

;;;

(defun intdos (regs)
  (int86 33 regs))	; int86 (0x21 /* 33 */,...)

;;;
;;; sorry, bdos doesn't work well...
;;;

(defun bdos (func dx al)
  (and (numberp func)
       (numberp dx)
       (numberp al)
       (let ((regs (make-register))
	     result)
	 (set-register-value regs 'ah func)
	 (set-register-value regs 'al al)
	 (set-register-value regs 'dx dx)
	 (intdos regs)
	 (if (not (zerop (register-value regs 'cflag)))
	     (setq result -1)
	   (setq result (register-value regs 'ax)))
	 result)))

;;;

(defun disk-free-space (&optional drive)
  "Return a list of free space information of current drive.\n\
List elements are:\n\
 0. Number of unused sectors.\n\
 1. Number of bytes per sector.\n\
 2. Number of sectors per cluster."
  (let ((regs (make-register)))		; union REGS regs
    (set-register-value regs 'ah 54)	; regs.h.ah = 0x36 /*  54 */
    (set-register-value regs 'dl (or (numberp drive) 0))
    (intdos regs)
    (list (register-value regs 'bx)
	  (register-value regs 'cx)
	  (register-value regs 'ax))))

(defun disk-total-space (&optional drive)
  "Return a list of free space information of current drive.\n\
List elements are:\n\
 0. Number of total sectors.\n\
 1. Number of bytes per sector.\n\
 2. Number of sectors per cluster."
  (let ((regs (make-register)))		; union REGS regs
    (set-register-value regs 'ah 54)	; regs.h.ah = 0x36 /*  54 */
    (set-register-value regs 'dl (or (numberp drive) 0))
    (intdos regs)
    (list (register-value regs 'dx)
	  (register-value regs 'cx)
	  (register-value regs 'ax))))

;;;

(defun set-keyclick (mode)
  "Set/Reset key click sound.\n\
If first arg non-nil turn key click sound on, and nil turn off."
  (cond ((eq dos-machine-type 'j3100)
	 (let ((regs (make-register)))		; union REGS regs
	   (set-register-value regs 'ah 242)	; regs.h.ah = 0xf2 /* 242 */
	   (set-register-value regs 'al (if mode 1 0))
	   (int86 22 regs))			; int86 (0x16 /* 22 */,...)
	 nil)
	))

(defun get-cursor-mode ()
  "Return a list of current cursor mode information.\n\
List elements are:\n\
 0. Start line.\n\
 1. End Line.\n\
 2. Blink mode.\n\
\n\
If this function can't get the info, returns nil."
  (let (blink-mode start-line end-line)
    (cond ((eq dos-machine-type 'j3100)
	   (let ((regs (make-register)))	; union REGS regs
	     (set-register-value regs 'ah 130)	; regs.h.ah = 0x82 /* 130 */
	     (set-register-value regs 'al 4)	; regs.h.al = 0x04
	     (set-register-value regs 'bl 255)	; regs.h.bl = -1   /* 255 */
	     (int86 16 regs)			; int86 (0x10 /* 16 */,...)
	     (setq blink-mode (zerop (register-value regs 'al))))
	   (let ((regs (make-register)))	; union REGS regs
	     (set-register-value regs 'ah 3)	; regs.h.ah = 0x03
	     (set-register-value regs 'bh 0)	; regs.h.bh = 0
	     (int86 16 regs)			; int86 (0x10 /* 16 */,...)
	     (setq start-line (register-value regs 'ch))
	     (setq end-line   (register-value regs 'cl)))
	   (list start-line end-line blink-mode))
	  )))

(defun set-cursor-mode (start-line end-line &optional blink-mode)
  "Set cursor shape for DOS Machine, specified from STARTPOS to ENDPOS.\n\
Optional third arg non-nil means cursor blinks."
  (and (numberp start-line)
       (numberp end-line)
       (cond ((eq dos-machine-type 'j3100)
	      (let ((regs (make-register)))	  ; union REGS regs
		(set-register-value regs 'ah 130) ; regs.h.ah = 0x82 /* 130 */
		(set-register-value regs 'al 4)	  ; regs.h.al = 0x04
		(set-register-value regs 'bl (if blink-mode 0 1))
		(int86 16 regs))		  ; int86 (0x10 /* 16 */,...)
	      (let ((regs (make-register)))	  ; union REGS regs
		(set-register-value regs 'ah 1)	  ; regs.h.ah = 0x01
		(set-register-value regs 'ch start-line)
		(set-register-value regs 'cl end-line)
		(int86 16 regs))		  ; int86 (0x10 /* 16 */,...)
	      nil)
	     )))
 
(defun set-screen-mode (rows)
  (and (numberp rows)
       (cond ((eq dos-machine-type 'j3100)
	      (cond ((= rows 25)
		     (send-string-to-terminal "\e[=116h"))
		    ((= rows 20)
		     (send-string-to-terminal "\e[=100h")))
	      nil)
	     )))

(defun get-screen-mode ()
  (cond ((eq dos-machine-type 'j3100)
	 (let (screen-mode)
	   (let ((regs (make-register)))	; union REGS regs
	     (set-register-value regs 'ah 15)	; regs.h.ah = 0x0f /*  15 */
	     (int86 16 regs)			; int86 (0x10 /* 16 */,...)
	     (setq screen-mode (register-value regs 'al)))
	   (cond ((= screen-mode 116) 25)	; /* 0x74 : 25 rows */
		 ((= screen-mode 100) 20))))	; /* 0x64 : 20 rows */
	))
