;; fepctrl.el: Kana-Kanji Translation FEP Control Library.
;;
;; Edition History:
;; 1.1 1991/11/28 Manabu Higashida Creation.
;; 1.2 1993/02/25 Manabu Higashida Modify for FEPCTRL 1.5
 
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

(defconst fep-name-list
  '("(none)"	;  0
    "PC98A"	;  1
    "PC98B"	;  2
    "PC98C"	;  3
    "MSKANJI"	;  4
    "VJE"	;  5
    "ATOK6"	;  6
    "ATOK7"	;  7
    "MTTK86"	;  8
    "MTTK2"	;  9
    "KATANA"	; 10
    "FIXER"	; 11
    "EGB2"	; 12
    "EGB3"	; 13
    "WXP"	; 14
    "WX2"	; 15
    "MGR2"	; 16
    "JJ"	; 17
    "NEC"	; 18
    "DFJ"	; 19
    "DANGO"	; 20
    "OTEMOTO"	; 21
    "OMAC"	; 22
    "AJIP1"	; 23
    "JOKER3"	; 24
    "KAZE"	; 25
    "OAK"	; 26
    "MKK"	; 27
    "B16"	; 28
    "RICOH"	; 29
    "WXPJ"	; 30
    "MIJ"	; 31
    "FEPEX"	; 32
    "AT6AX"	; 33
    "AT6IBM"	; 34
    "AT7IBM"	; 35
    "AT7DOSV"	; 36
    "IBMIAS"	; 37
    ))

(defvar fep-name nil)

(or (fboundp 'si:fep-init)
    (fset 'si:fep-init (symbol-function 'fep-init)))

(defun fep-init ()
  ""
  (let ((fep-id (si:fep-init)))
    (if (or (not (numberp fep-id))
	    (zerop fep-id))
	(setq inhibit-fep-control t)
      (setq fep-name (nth fep-id fep-name-list)))))

(defun fep-sync ()
  (interactive)
  (if fep-mode
      (fep-force-on)
    (fep-force-off)))

;(or (fboundp 'si:fep-get-mode)
;    (fset 'si:fep-get-mode (symbol-function 'fep-get-mode)))
;
;(defun fep-get-mode ()
;  (not (= (si:fep-get-mode) 0)))

(defun toggle-fep-mode ()
  (interactive)
  (if (fep-get-mode)
      (fep-force-off)
    (fep-force-on)))

;;;

(or (fboundp 'si:universal-argument)
    (fset 'si:universal-argument (symbol-function 'universal-argument)))

(defun universal-argument ()
  ""
  (interactive nil)
  (fep-off)
  (unwind-protect
      (si:universal-argument)
    (fep-on)))

;;;

(or (fboundp 'si:quoted-insert)
    (fset 'si:quoted-insert (symbol-function 'quoted-insert)))

(defun quoted-insert (arg)
  ""
  (interactive "*p")
  (fep-off)
  (unwind-protect
      (si:quoted-insert arg)
    (fep-on)))

;;;

(or (fboundp 'si:isearch)
    (fset 'si:isearch (symbol-function 'isearch)))

(defun isearch (forward &optional regexp)
  ""
  (fep-off)
  (unwind-protect
      (si:isearch forward regexp)
    (fep-on)))

;(or (fboundp 'si:read-string)
;    (fset 'si:read-string (symbol-function 'read-string)))
;
;(defun read-string (args &optional arg1)
;  (fep-on)
;  (unwind-protect
;      (funcall 'si:read-string args arg1)
;    (fep-off)))

;;;

;
; This doesn't work correctly to handle C-h.
;
;(or (fboundp 'si:help-for-help)
;    (fset 'si:help-for-help (symbol-function 'help-for-help)))
;
;(defun help-for-help ()
;  (interactive)
;  (fep-off)
;  (unwind-protect
;      (si:help-for-help)
;    (fep-on)))
