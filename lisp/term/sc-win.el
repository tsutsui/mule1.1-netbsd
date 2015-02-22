;; Parse switches controlling how Emacs interfaces with Sun console window.
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

;;; 92.3.31  created for Mule Ver.0.9.2 by K.Handa <handa@etl.go.jp>
;;; 92.10.16  modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>

(setq command-switch-alist
      (append '(("-sun" . ignore)
		("-r" . ignore)
		("-fb" . sc-ignore-arg)
		("-fp" . sc-ignore-arg)
		("-cs" . sc-ignore-arg))
	      command-switch-alist))

(defun sc-ignore-arg (&rest ignore)
  (setq command-line-args-left (cdr command-line-args-left)))
