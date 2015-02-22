;; Korean specific setup for Mule
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

;;; 92.3.5   Created for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.5.1   modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;;	Modification of standard-syntax-table is done in mule-config.el.
;;; 92.7.10  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Now quail is used as default.
;;; 93.7.22  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;; 94.2.8   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>

(provide 'korean)			;93.7.22 by K.Handa

(set-coding-priority
 '(*coding-category-iso-8-2*
   *coding-category-iso-8-1*))
(setq *coding-category-iso-8-2* *euc-korea*)

;; (modify-syntax-entry lc-kr "w")

(require 'quail)
(load "quail/hangul")

;; EGG specific setup
;(if (boundp 'EGG)
;    (progn
;      (load "its-hangul")
;      (setq its:*standard-modes*
;	    (cons (its:get-mode-map "hangul") its:*standard-modes*))
;      (setq-default its:*current-map* (its:get-mode-map "hangul"))))
