;; Direct input of multilingual code from keyboard
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

;;; 92.3.5   created for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.3.19  modified for Mule Ver.0.9.1 by Y.Kawabe <kawabe@sramhc.sra.co.jp>
;;;	set-keyboard-coding-system can be called interactively.
;;; 92.3.24  modified for Mule Ver.0.9.2 by Y.Kawabe <kawabe@sramhc.sra.co.jp>
;;;	self-insert-sjis-japanese changes global-map to global-map-sjis.
;;; 92.4.13  modified for Mule Ver.0.9.3 by M.Ishisone <ishisone@sra.co.jp>
;;;	Change global-map-iso and global-map-sjis to local map.
;;; 92.4.13  modified for Mule Ver.0.9.3 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	Argument to define-key is fixed.
;;; 92.4.13   modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>
;;;	set-keyboard-coding-system calls check-coding-system to check code.
;;;	Big change for handling more ISO2022.
;;;	Macro current-g? is changed variables _current-g?_.
;;; 92.6.24  modified for Mule Ver.0.9.5 by K.Sakaeda <saka@pfu.fujitsu.co.jp>
;;;	define-key is called with NONMETA arg t.
;;; 92.6.30  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Check auto-fill-hook after each insert.
;;; 92.7.2   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	set-keyboard-coding-system accepts *noconv* and nil.
;;; 92.8.5   modified for Mule Ver.0.9.5.1
;;;		by K.Shimozono <simozono@csce.kyushu-u.ac.jp>
;;;	In set-keyboard-coding-system, simple mis-type corrected.
;;; 92.8.7   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	In esc-dol-map ',' should be assigned to esc-dol-comma-prefix.
;;; 92.9.8   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	ESC , ? and ESC - ? are used only when keyboard-allow-latin-input is t.
;;; 92.12.31 modified for Mule Ver.0.9.7.1 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	Bug in set-keyboard-coding-system-iso2022 fixed.
;;; 93.1.13  modified for Mule Ver.0.9.7.1
;;;			by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	In keyboard-designate-94-GL and keyboard-designate-94n-GL,
;;;	code changed for new coding-system format.
;;; 93.2.16  modified for Mule Ver.0.9.7.1
;;;			by Y.Kawabe <kawabe@sramhc.sra.co.jp>
;;;	Bug fix in set-keyboard-coding-system-iso2022.
;;; 93.3.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	In self-insert-iso and self-insert-sjis-japanese2,
;;;	self-insert-internal is used to concern overwrite-mode.
;;; 93.7.23  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Alternative key definitions are done in mule.el.
;;; 93.11.15 modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Support for Big5 direct inputting.

;; 92.9.8 by K.Handa
(defvar keyboard-allow-latin-input nil
  "If non-nil, "ESC , Fe" and "ESC - Fe" are used for inputting
Latin characters.")

;; common global variables of internal use
(defvar _keyboard-first-byte_ 0
  "Character buffer for the first byte of two-byte character.")
(defvar _keyboard-SS2_ nil
  "Flag to indicate Single Shift SS2.")
(defvar _keyboard-SS3_ nil
  "Flag to indicate Single Shift SS3.")
(defvar _keyboard-saved-local-map_ nil
  "Saved local keymap.")		; 92.4.13 by M.Ishisone

;; 92.4.13 by K.Handa
(defvar _current-g0_ 0)
(defvar _current-g1_ nil)
(defvar _current-g2_ nil)
(defvar _current-g3_ nil)
;; end of patch

;; 92.4.13 by M.Ishisone
(defconst local-map-iso nil
  "Local keymap used while inputing ISO2022 code directly.")
(defconst local-map-sjis nil
  "Local keymap used while inputing Shift-JIS code directly.")
(defconst local-map-big5 nil
  "Local keymap used while inputting Big5 code directly.")

;; end of patch
;; 92.4.14 by K.Handa
(defconst esc-dol-map nil "Keys to designate 94n or 96n charset.")
(defconst esc-openpar-map nil "Keys to designate 94 charset to GL.")
(defconst esc-closepar-map nil "Keys to designate 94 charset to GR.")
(defconst esc-comma-map nil "Keys to designate 96 charset to GL.")
(defconst esc-minus-map nil "Keys to designate 96 charset to GR.")
(defconst esc-dol-openpar-map nil "Keys to designate 94n charset to GL.")
(defconst esc-dol-closepar-map nil "Keys to designate 94n charset to GR.")
(defconst esc-dol-comman-map nil "Keys to designate 96n charset to GL.")
(defconst esc-dol-minus-map nil "Keys to designate 96n charset to GR.")
;; end of patch

(defun set-keyboard-coding-system (code)
  "Set variable keyboard-coding-system to CODE and modify keymap for it."
  ;; 92.3.19 by Y.Kawabe, 92.8.5 by K.Shimozono
  (interactive "zKeyboard-coding-system: ")
  ;; 92.4.13 by K.Handa
  (if (check-coding-system code)	; 92.7.2 by K.Handa
      (let ((type (get-code-type code)))
	(if type
	    (cond ((eq type 1)
		   (set-keyboard-coding-system-sjis))
		  ((eq type 2)
		   (set-keyboard-coding-system-iso2022 code))
		  ((eq type 3)
		   (set-keyboard-coding-system-big5))
		  (t
		   (error "Direct input of code %s is not supported." code)))
	  (setq keyboard-coding-system nil)))
    (setq keyboard-coding-system nil)))

(defun set-keyboard-coding-system-iso2022 (code)
  (let ((flags (get-code-flags code)))	;92.12.31 by T.Shingu
    (setq _current-g0_ (aref flags 0))
    (setq _current-g1_ (aref flags 1))
    (setq _current-g2_ (aref flags 2))
    (setq _current-g3_ (aref flags 3)))
  (or (eq _current-g1_ lc-invalid)	;93.2.16 by Y.Kawabe
      (setq meta-flag nil parity-flag nil))
  (let (i)
    (setq i 160)
    (while (< i 256)
      (aset global-map i 'self-insert-iso)
      (setq i (1+ i))))
  (if local-map-iso nil
    (setq local-map-iso (make-keymap))
    (let (i map)
      (setq i 33)
      (while (< i 127)
	(aset local-map-iso i 'self-insert-iso)
	(setq i (1+ i)))
      (setq map (current-global-map))
      (setq i 161)
      (while (< i 255)
	(aset map i 'self-insert-iso)
	(setq i (1+ i))))
    (define-key local-map-iso "\C-g" 'mule-keyboard-quit))
  (if esc-dol-map nil
    ;; 92.4.13 by K.Handa
    (setq esc-dol-map (make-keymap)
	  esc-openpar-map (make-keymap)
	  esc-closepar-map (make-keymap)
	  esc-comma-map (make-keymap)
	  esc-minus-map (make-keymap)
	  esc-dol-openpar-map (make-keymap)
	  esc-dol-closepar-map (make-keymap)
	  esc-dol-comma-map (make-keymap)
	  esc-dol-minus-map (make-keymap))
    (fset 'esc-dol-prefix esc-dol-map)
    (fset 'esc-openpar-prefix esc-openpar-map)
    (fset 'esc-closepar-prefix esc-closepar-map)
    (fset 'esc-comma-prefix esc-comma-map)
    (fset 'esc-minus-prefix esc-minus-map)
    (fset 'esc-dol-openpar-prefix esc-dol-openpar-map)
    (fset 'esc-dol-closepar-prefix esc-dol-closepar-map)
    (fset 'esc-dol-comma-prefix esc-dol-comma-map)
    (fset 'esc-dol-minus-prefix esc-dol-minus-map)
    (define-key esc-dol-map "(" 'esc-dol-openpar-prefix)
    (define-key esc-dol-map ")" 'esc-dol-closepar-prefix)
    (define-key esc-dol-map "," 'esc-dol-comma-prefix) ; 92.8.7 by K.Handa
    (define-key esc-dol-map "-" 'esc-dol-minus-prefix)
    ;; end of patch
    (let (i)
      (setq i ?0)
      (while (< i ?`)
	(aset esc-openpar-map i 'keyboard-designate-94-GL)
	(aset esc-closepar-map i 'keyboard-designate-94-GR)
	(aset esc-comma-map i 'keyboard-designate-96-GL)
	(aset esc-minus-map i 'keyboard-designate-96-GR)
	(aset esc-dol-map i 'keyboard-designate-94n-GL)
	(aset esc-dol-openpar-map i 'keyboard-designate-94n-GL)
	(aset esc-dol-closepar-map i 'keyboard-designate-94n-GR)
	(aset esc-dol-comma-map i 'keyboard-designate-96n-GL)
	(aset esc-dol-minus-map i 'keyboard-designate-96n-GR)
	(setq i (1+ i)))))
  (define-key global-map "\216" 'keyboard-SS2 t) ; 92.6.24 by K.Sakaeda
  (define-key global-map "\217" 'keyboard-SS3 t) ; 92.6.24 by K.Sakaeda
  ;; 92.4.13 by T.Enami
  (define-key esc-map "(" 'esc-openpar-prefix)
  (define-key esc-map ")" 'esc-closepar-prefix)
  (if keyboard-allow-latin-input	; 92.9.8 by K.Handa
      (progn
	(define-key esc-map "," 'esc-comma-prefix)
	(define-key esc-map "-" 'esc-minus-prefix)))
  (define-key esc-map "$" 'esc-dol-prefix)
  ;; end of patch
  (setq _keyboard-first-byte_ nil
	_keyboard-SS2_ nil
	_keyboard-SS3_ nil)
  (setq keyboard-coding-system code)
  )

(defun mule-keyboard-quit ()
  (interactive)
  (setq _keyboard-first-byte_ nil
	_keyboard-SS2_ nil
	_keyboard-SS3_ nil)
  (if _keyboard-saved-local-map_
      (use-local-map _keyboard-saved-local-map_))
  (keyboard-quit))

(defun keyboard-change-local-map-for-iso ()
  (if (eq (current-local-map) local-map-iso)
      nil
    (setq _keyboard-saved-local-map_ (current-local-map))
    (use-local-map local-map-iso)))

(defun keyboard-designate-94-GL ()
  (interactive)
  ;; 93.1.13 by T.Enami
  (if (and (aref (get-code-flags keyboard-coding-system) 9)
	   (= lc-roman (leading-char 0 last-command-char)))
      (setq _current-g0_ lc-ascii)
    (setq _current-g0_ (leading-char 0 last-command-char)))
  (if (= _current-g0_ lc-ascii)
      (use-local-map _keyboard-saved-local-map_)
    (keyboard-change-local-map-for-iso)))

(defun keyboard-designate-94-GR ()
  (interactive)
  (setq _current-g1_ (leading-char 0 last-command-char)))

(defun keyboard-designate-96-GL ()
  (interactive)
  (setq _current-g0_ (leading-char 1 last-command-char))
  (keyboard-change-local-map-for-iso))

(defun keyboard-designate-96-GR ()
  (interactive)
  (setq _current-g1_ (leading-char 1 last-command-char)))

(defun keyboard-designate-94n-GL ()
  (interactive)
  ;; 93.1.13 by T.Enami
  (if (and (aref (get-code-flags keyboard-coding-system) 10)
	   (= lc-jpold (leading-char 2 last-command-char)))
      (setq _current-g0_ lc-jp)
    (setq _current-g0_ (leading-char 2 last-command-char)))
  (keyboard-change-local-map-for-iso))

(defun keyboard-designate-94n-GR ()
  (interactive)
  (setq _current-g1_ (leading-char 2 last-command-char)))

(defun keyboard-designate-96n-GL ()
  (interactive)
  (setq _current-g0_ (leading-char 3 last-command-char))
  (keyboard-change-local-map-for-iso))

(defun keyboard-designate-96n-GR ()
  (interactive)
  (setq _current-g1_ (leading-char 3 last-command-char)))

(defun keyboard-SS2 ()
  (interactive)
  (setq _keyboard-SS2_ t)
  (setq _saved-local-map-single-shift_ (current-local-map))
  (keyboard-change-local-map-for-iso))

(defun keyboard-SS3 ()
  (interactive)
  (setq _keyboard-SS3_ t)
  (setq _saved-local-map-single-shift_ (current-local-map))
  (keyboard-change-local-map-for-iso))

(defun self-insert-iso ()
  (interactive)
  (let ((lc (cond (_keyboard-SS2_ _current-g2_)
		  (_keyboard-SS3_ _current-g3_)
		  ((< last-command-char 128) _current-g0_)
		  (t _current-g1_))))
    (if (not lc) (mule-keyboard-quit))
    (if (<= (char-bytes lc) 2)
	(progn
	  (self-insert-internal		;93.3.10 by K.Handa
	   (make-character lc (logior last-command-char 128)))
	  (check-auto-fill)
	  (if (or _keyboard-SS2_ _keyboard-SS3_)
	      (use-local-map _saved-local-map-single-shift_))
	  (setq _keyboard-SS2_ nil _keyboard-SS3_ nil
		_keyboard-first-byte_ nil))
      (if _keyboard-first-byte_
	  (progn
	    (self-insert-internal	;93.3.10 by K.Handa
	     (make-character lc _keyboard-first-byte_
			     (logior last-command-char 128)))
	    (check-auto-fill)
	    (if (or _keyboard-SS2_ _keyboard-SS3_)
		(use-local-map _saved-local-map-single-shift_))
	    (setq _keyboard-SS2_ nil _keyboard-SS3_ nil
		  _keyboard-first-byte_ nil))
	(setq _keyboard-first-byte_ (logior last-command-char 128))))))


(defun set-keyboard-coding-system-sjis ()
  (setq meta-flag nil parity-flag nil)
  (let (i)
    (setq i 128)
    (while (< i 160)
      (aset global-map i 'self-insert-sjis-japanese)
      (setq i (1+ i)))
    (while (< i 224)
      (aset global-map i 'self-insert-sjis-kana)
      (setq i (1+ i)))
    (while (< i 256)
      (aset global-map i 'self-insert-sjis-japanese)
      (setq i (1+ i)))
    (if local-map-sjis nil
      (setq local-map-sjis (make-keymap))
      (setq i 64)
      (while (< i 256)
	(aset local-map-sjis i 'self-insert-sjis-japanese2)
	(setq i (1+ i)))
      (define-key local-map-sjis "\C-g" 'mule-keyboard-quit)))
  (setq _keyboard-first-byte_ 0)
  (setq keyboard-coding-system *sjis*))

(defun self-insert-sjis-japanese ()
  (interactive)
  (setq _keyboard-first-byte_ last-command-char)
  ;; 92.3.24 by Y.Kawabe
  (setq _saved-local-map_ (current-local-map))
  (use-local-map local-map-sjis))

(defun self-insert-sjis-japanese2 ()
  (interactive)
  (if _keyboard-first-byte_
      (let ((bytes (s2e _keyboard-first-byte_ last-command-char)))
	(self-insert-internal		;93.3.10 by K.Handa
	 (make-character lc-jp (car bytes) (cdr bytes)))
	(check-auto-fill)
	(setq _keyboard-first-byte_ nil)))
  (use-local-map _saved-local-map_))

(defun self-insert-sjis-kana ()
  (interactive)
  (insert lc-kana last-command-char)
  (check-auto-fill))

;; 93.11.15 by K.Handa
(defun set-keyboard-coding-system-big5 ()
  (setq meta-flag nil parity-flag nil)
  (let ((i 161))
    (while (< i 255)
      (aset global-map i 'self-insert-big5)
      (setq i (1+ i)))
    (if local-map-big5 nil
      (setq local-map-big5 (make-keymap))
      (setq i 64)
      (while (< i 127)
	(aset local-map-big5 i 'self-insert-big5-2)
	(setq i (1+ i)))
      (setq i 161)
      (while (< i 255)
	(aset local-map-big5 i 'self-insert-big5-2)
	(setq i (1+ i)))))
  (setq keyboard-coding-system *big5-eten*))

(defun self-insert-big5 ()
  (interactive)
  (setq _keyboard-first-byte_ last-command-char)
  (setq _saved-local-map_ (current-local-map))
  (use-local-map local-map-big5))

(defun self-insert-big5-2 ()
  (interactive)
  (self-insert-internal
   (b2m (+ (* _keyboard-first-byte_ 256) last-command-char) t))
  (use-local-map _saved-local-map_))

;; 92.6.30 by K.Handa
(defun check-auto-fill ()
  (if (and auto-fill-hook (> (current-column) fill-column))
      (run-hooks 'auto-fill-hook)))
