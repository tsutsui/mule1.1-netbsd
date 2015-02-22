;; Parse switches controlling how Emacs interfaces with VGA adapter.
;; Copyright (C) 1986, 1988 Free Software Foundation, Inc.

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

;;; 92.11.4   created for Mule Ver.0.9.6
;;;		by M.Higashida <manabu@sigmath.osaka-u.ac.jp>

(setq command-switch-alist
      (append '(("-vga" . ignore)
		("-fp" . vga-ignore-arg)
		("-cs" . vga-ignore-arg))
	      command-switch-alist))

(defun vga-ignore-arg (&rest ignore)
  (setq command-line-args-left (cdr command-line-args-left)))
