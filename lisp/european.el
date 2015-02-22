;; European language specific setup for Mule
;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).
;; This file contains European characters.

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
;;; 92.5.12  modified for Mule Ver.0.9.4 by N.Takahashi <ntakahas@etl.go.jp>
;;;	ltn-attribute-list is augmented.
;;; 92.5.28  modified for Mule Ver.0.9.4 by K.Handa <handa@etl.go.jp>
;;;	Big change for introducing Latin mode (minor mode).
;;; 92.7.10  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Since Latin input is supported by quail now, latin-mode is deleted.
;;; 93.1.24  modified for Mule Ver.0.9.7.1
;;;				by S.Yasutome <yasutome@ics.osaka-u.ac.jp>
;;;	Cope with new spec of make-coding-system.
;;; 93.7.22  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>

(require 'quail)
(provide 'european)
(load "quail/latin")

;; 92.8.2 Y.Niibe
(make-coding-system
 '*ctext-hebrew* 2
 ?H "Coding-system of Hebrew."
 nil
 (list lc-ascii lc-hbw nil nil
	 nil 'ascii-eol 'ascii-cntl nil nil nil nil))

;; 93.8.12 by K.Handa
(make-coding-system
 '*iso-8859-2* 2 ?2 "MIME ISO-8859-2" nil
 (list lc-ascii lc-ltn2 nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil))

(make-coding-system
 '*iso-8859-3* 2 ?3 "MIME ISO-8859-3" nil
 (list lc-ascii lc-ltn3 nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil))

(make-coding-system
 '*iso-8859-4* 2 ?4 "MIME ISO-8859-4" nil
 (list lc-ascii lc-ltn4 nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil))

(make-coding-system
 '*iso-8859-5* 2 ?5 "MIME ISO-8859-5" nil
 (list lc-ascii lc-crl nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil))

(make-coding-system
 '*iso-8859-7* 2 ?7 "MIME ISO-8859-7" nil
 (list lc-ascii lc-grk nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil))

(make-coding-system
 '*iso-8859-8* 2 ?8 "MIME ISO-8859-8" nil
 (list lc-ascii lc-hbw nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil t))

(make-coding-system
 '*iso-8859-9* 2 ?9 "MIME ISO-8859-9" nil
 (list lc-ascii lc-ltn5 nil nil nil 'ascii-eol 'ascii-cntl nil nil nil nil))
