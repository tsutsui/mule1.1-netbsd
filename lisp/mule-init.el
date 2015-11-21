;; Mule default configuration file

;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).

;; Mule is free software distributed in the forms of patches to GNU Emacs.
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

;;; 87.6.9   created by K.handa
;;; 87.6.15  modified by K.Handa
;;; 88.1.15  modified for Nemacs Ver.2.0 by K.Handa
;;; 88.5.26  modified for Nemacs Ver.2.1 by K.handa
;;; 88.3.23  modified for Nemacs Ver.3.0 by K.handa
;;; 89.11.21 modified for Nemacs Ver.3.2 by K.Handa and S.Tomura
;;; 89.12.15 modified for Nemacs Ver.3.2.1 by S.Tomura
;;; 90.2.28  copied from site-init.el for Nemacs Ver.3.3.0 by K.Handa
;;; 91.3.22  modified for Egg Ver.3.0 by S.Tomura
;;; 92.2.14  modified for Nemacs Ver.4.0.0 by K.Handa
;;; 92.3.5   modified for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;; 92.3.23  modified for Mule Ver.0.9.1 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	coding-system for "nntp" is set to *junet*
;;; 92.4.27  modified for Mule Ver.0.9.4
;;;	by K.Nozoe <nozoe@mtc.telcom.oki.co.jp> and A.Furuta <furuta@sra.co.jp>
;;;	Setting coding-system for MH.
;;; 92.5.15  modified for Mule Ver.0.9.4
;;;	by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;;	set-keyboard-coding-system is called after (load keyboard).
;;; 92.5.20  modified for Mule Ver.0.9.4
;;;	by A.Tanaka <aries@ecs.isl.melco.co.jp>
;;;	Setting for MH is changed.
;;; 92.5.29  modified for Mule Ver.0.9.3 by T.Ito <toshi@his.cpl.melco.co.jp>
;;;	Setting for MH is changed again.
;;; 92.7.6   modified for Mule Ver.0.9.5
;;;		by M.Kuwada <kuwada@soliton.ee.uec.ac.jp>
;;;	Setting coding-system for VM.
;;; 92.7.9   modified for Mule Ver.0.9.5 by K.Sakaeda <saka@pfu.fujitsu.co.jp>
;;;	Setting for MH is changed again.
;;; 92.8.6   modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	mule-util should be loaded at first.
;;; 92.10.11 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;	Setting default fonts and private character sets.
;;; 92.11.27 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	New comment added.
;;; 92.12.16 modified for Mule Ver.0.9.7 by K.Handa <handa@etl.go.jp>
;;;	term-setup-hook is set in this file.
;;; 93.2.10  modified for Mule Ver.0.9.7.1
;;;				by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	Used purebytes is shown in loadup.el.
;;; 93.4.10  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Font for new char-set lc-ascr2l is defined.
;;; 93.4.29  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	CNS11643 support.
;;; 93.6.17  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	Don't specify coding-system for shell.
;;; 93.7.23  modified for Mule Ver.0.9.8 by N.Demizu<nori-d@is.aist-nara.ac.jp>
;;;	For "anno" called by mh-e, *junet* is set.

;;; IMPORTANT NOTICE!!!
;;;   Keep this file unmodified for further patches being applied successfully.
;;;   If you are not satisfied with the following default setting,
;;;   overwrite any of them in site-init.el.
;;;   You should also load language specific files in site-init.el because
;;;   they are not loaded here.

;;; Setting default font names and encodings
(if (not (fboundp 'x-set-font))		; 92.10.19 patch by T.Atsushiba
    ;; You don't have X window.
    nil
  ;; You have X window.
  (let ((fonts
	 '["-*-fixed-medium-r-*--14-*-iso8859-1" 0 ; ASCII
	   "-*-fixed-medium-r-*--14-*-iso8859-1" 1 ; Latin-1
	   "-*-fixed-medium-r-*--14-*-iso8859-2" 1 ; Latin-2
	   "-*-fixed-medium-r-*--14-*-iso8859-3" 1 ; Latin-3
	   "-*-fixed-medium-r-*--14-*-iso8859-4" 1 ; Latin-4
	   nil 0			; not used
	   "-*-fixed-medium-r-*--14-*-iso8859-7" 1 ; Greek
	   nil 0			; Arabic
	   "-*-fixed-medium-r-*--14-*-iso8859-8" 1 ; Hebrew
	   "-*-fixed-medium-r-*--14-*-jisx0201.1976-*" 1 ; Kana
	   "-*-fixed-medium-r-*--14-*-jisx0201.1976-*" 0 ; Roman
	   nil 0			; not used
	   "-*-fixed-medium-r-*--14-*-iso8859-5" 1 ; Cyrillic
	   "-*-fixed-medium-r-*--14-*-iso8859-9" 1 ; Latin-5
	   nil 0			; not used
	   nil 0			; not used
	   "-*-fixed-medium-r-*--14-*-jisx0208.1983-*" 0 ; old JIS
	   "-*-song-medium-r-*--14-*-gb2312.1980-*" 0 ; Chinese
	   "-*-fixed-medium-r-*--14-*-jisx0208.1983-*" 0 ; Japanese
	   "-*-mincho-medium-r-*--14-*-ksc5601.1987-*" 0 ; Korean
	   "-*-fixed-medium-r-*--14-*-jisx0212.1990-*" 0 ; Japanese supplement
	   nil 0			; CNS 11643 Set 1
	   nil 0			; CNS 11643 Set 2
	   nil 0			; CNS 11643 Set 14
	   "-*-fixed-medium-r-*--14-*-big5*-*" 0 ; Big5
	   "-*-fixed-medium-r-*--14-*-big5*-*" 0 ; Big5
	   ])
	i)
    (setq i (/ (length fonts) 2))
    (while (> i 0)
      (setq i (1- i))
      (aset x-default-fonts i (aref fonts (* i 2)))
      (aset x-default-encoding i (aref fonts (1+ (* i 2))))))
  (set-x-default-font
   lc-sisheng "-*-fixed-medium-r-*--14-*-*-*-*-*-sisheng_cwnn-0" 0)
  (set-x-default-font
   lc-thai "-*-fixed-medium-r-*--14-*-*-*-*-*-tis620.2529-1" 1)
  (set-x-default-font
   lc-ascr2l "-*-fixed-medium-r-*--14-*-*-*-*-*-iso8859-1" 0)
  )

;; If you want to load multiple files, you'ld better load a file of main
;; language at the end to override other default settings.
;; Notice!  You may have to increase PURESIZE in src/puresize.h
;; if you load many files.
;(load "european")
;(load "thai")
;(load "viet")
;(load "chinese")
;(load "korean")
;(load "japanese")

;;; Change coding-system according to your environment
;; For RMAIL and NEWS
;; Notice!  In Korea for mail, use *iso-2022-kr* instead of *junet*.
(define-program-coding-system nil ".*mail.*" *junet*)
(define-program-coding-system nil ".*inews.*" *junet*)
;; For GNUS
;; 92.3.23 by T.Enami - set to *junet*
(define-service-coding-system "nntp" nil *junet*)
;; For MH
;; 92.4.27 by K.Nozoe
(define-program-coding-system nil ".*scan.*" *junet*)
(define-program-coding-system nil ".*inc.*" *junet*)
(define-program-coding-system nil ".*mhl.*" *junet*)
;; 93.7.23 by N.Demizu -- for MIME
(define-program-coding-system nil ".*anno.*" *junet*)
;; 92.7.9 by K.Sakaeda
(define-program-coding-system nil ".*rcvstore.*" *junet*)
;; 92.4.27 by A.Furuta, 92.5.20 by A.Tanaka, 92.5.28 by T.Ito
(setq mh-before-send-letter-hook
      '(lambda () (set-file-coding-system *junet*)))
;; For VM
;; 92.7.6 by M.Kuwada
(setq vm-mode-hooks
      '(lambda ()
	(set-file-coding-system *junet*)))
;; For Wnn and cWnn
(define-service-coding-system "wnn" nil *noconv*)

;; For shells -- 93.6.17 by K.Handa -- commented out
;;(define-program-coding-system nil ".*sh.*" '(nil . nil))

;;; For gnus user only
;(setq gnus-your-domain "your.domain.address"
;      gnus-your-organization "Your site name"
;      gnus-use-generic-from t)

;;; For rnews user only
(setq news-inews-program "/usr/lib/news/inews")

;;; For terminal setup
(setq term-setup-hook
      (function (lambda ()
		  (if window-system nil
		    (set-display-coding-system display-coding-system)
		    (set-keyboard-coding-system keyboard-coding-system)))))
