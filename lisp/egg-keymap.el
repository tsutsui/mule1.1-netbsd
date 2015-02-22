;; Usefull key binding for Sun Function keys 
;; Coded by Yutaka Ishikawa at ETL (yisikawa@etl.junet)

;; This file is part of Egg on Mule (Multilingual Environment)

;; Egg is distributed in the forms of patches to GNU
;; Emacs under the terms of the GNU EMACS GENERAL PUBLIC
;; LICENSE which is distributed along with GNU Emacs by the
;; Free Software Foundation.

;; Egg is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
;; more details.

;; You should have received a copy of the GNU EMACS GENERAL
;; PUBLIC LICENSE along with Nemacs; see the file COPYING.
;; If not, write to the Free Software Foundation, 675 Mass
;; Ave, Cambridge, MA 02139, USA.

;;; 92.4.16  modified for Mule Ver.0.9.3 by K.Handa <handa@etl.go.jp>

;;
;; Table of Function key codes:
;;
;;;		x11term/sun	x11term/others	xterm/all
;;;
;;; XK_L1:	"\e[192z"
;;; XK_L2:	"\e[193z"
;;; XK_L3:	"\e[194z"
;;; XK_L4:	"\e[195z"
;;; XK_L5:	"\e[196z"
;;; XK_L6:	"\e[197z"
;;; XK_L7:	"\e[198z"
;;; XK_L8:	"\e[199z"
;;; XK_L9:	"\e[200z"
;;; XK_L10:	"\e[201z"
;;; XK_R1:	"\e[208z"
;;; XK_R2:	"\e[209z"
;;; XK_R3:	"\e[210z"
;;; XK_R4:	"\e[211z"
;;; XK_R5:	"\e[212z"
;;; XK_R6:	"\e[213z"
;;; XK_R7:	"\e[214z"
;;; XK_R8:	"\e[215z"
;;; XK_R9:	"\e[216z"
;;; XK_R10:	"\e[217z"
;;; XK_R11:	"\e[218z"
;;; XK_R12:	"\e[219z"
;;; XK_R13:	"\e[220z"
;;; XK_R14:	"\e[221z"
;;; XK_R15:	"\e[222z"
;;;
;;; XK_Break:	"\e[223z" /* Sun3 "Alternate" key */
;;;
;;; XK_F1:	"\e[224z"	"\e[11~"	"\e[11~"
;;; XK_F2:	"\e[225z"	"\e[12~"	"\e[12~"
;;; XK_F3:	"\e[226z"	"\e[13~"	"\e[13~"
;;; XK_F4:	"\e[227z"	"\e[14~"	"\e[14~"
;;; XK_F5:	"\e[228z"	"\e[15~"	"\e[15~"
;;; XK_F6:	"\e[229z"	"\e[17~"	"\e[17~"
;;; XK_F7:	"\e[230z"	"\e[18~"	"\e[18~"
;;; XK_F8:	"\e[231z"	"\e[19~"	"\e[19~"
;;; XK_F9:	"\e[232z"	"\e[20~"	"\e[20~"
;;;
;;; XK_F10:			"\e[21~"	"\e[21~"
;;; XK_F11:			"\e[23~"	"\e[23~"
;;; XK_F12:			"\e[24~"	"\e[24~"
;;; XK_F13:			"\e[25~"	"\e[25~"
;;; XK_F14:			"\e[26~"	"\e[26~"
;;; XK_F15:			"\e[28~"	"\e[28~"
;;; XK_Help:			"\e[28~"	"\e[28~"
;;; XK_F16:			"\e[29~"	"\e[29~"
;;; XK_Menu:			"\e[29~"	"\e[29~"
;;; XK_F17:			"\e[31~"	"\e[31~"
;;; XK_F18:			"\e[32~"	"\e[32~"
;;; XK_F19:			"\e[33~"	"\e[33~"
;;; XK_F20:			"\e[34~"	"\e[34~"
;;;	
;;; XK_Find :			"\e[1~"		"\e[1~"
;;; XK_Insert:			"\e[2~"		"\e[2~"
;;; XK_Delete:			"\e[3~"		"\e[3~"
;;; XK_Select:			"\e[4~"		"\e[4~"
;;; XK_Prior:			"\e[5~"		"\e[5~"
;;; XK_Next:			"\e[6~"		"\e[6~"
;;; default:	"\e[-1z"	"\e[-1~"
;;;
;;; XK_Left:	"\C-b"		"\C-b"		"\eOC"(XK_R12)
;;; XK_Right:	"\C-f"		"\C-f"		"\eOD"(XK_R10)
;;; XK_Up:	"\C-p"		"\C-p"		"\eOA"(XK_R8)
;;; XK_Down:	"\C-n"		"\C-n"		"\eOB"(XK_R10)
;;;
;;;


(defvar sun-rkeymap (make-keymap))
(fset 'sun-rprefix sun-rkeymap)

;;;
;;; Key bindings for X11 terminals(x11term)
;;;

(define-key global-map "\eO" 'sun-rprefix)
(define-key sun-rkeymap "A" 'previous-line)
(define-key sun-rkeymap "B" 'next-line)
(define-key sun-rkeymap "C" 'forward-char)
(define-key sun-rkeymap "D" 'backward-char)

(defvar sun-fkeymap (make-keymap))
(fset 'sun-fprefix sun-fkeymap)
;;;
;;; Key bindings for non Sun X11 terminal(x11term and [kx]term)
;;;
(define-key global-map "\e[" 'sun-fprefix)
(define-key sun-fkeymap "["   'backward-paragraph) ; old "\e[" assignment
(define-key sun-fkeymap "11~" 'set-file-coding-system)	; F1 92.4.16 by K.Handa
(define-key sun-fkeymap "12~" 'edit-dict-item)	        ; F2
(define-key sun-fkeymap "13~" 'jis-code-input)   	; F3
(define-key sun-fkeymap "14~" 'toroku-region)		; F4
(define-key sun-fkeymap "15~" 'zenkaku-region)		; F5
(define-key sun-fkeymap "17~" 'hankaku-region)		; F6
(define-key sun-fkeymap "18~" 'katakana-region)		; F7
(define-key sun-fkeymap "19~" 'hiragana-region)		; F8
(define-key sun-fkeymap "20~" 'henkan-region)		; F9

(define-key sun-fkeymap "23~" 'insert-buffer)		; F11 or         L1
(define-key sun-fkeymap "24~" 'insert-file)		; F12 or         L2
(define-key sun-fkeymap "25~" 'eval-region)		; F13 or         L3
(define-key sun-fkeymap "26~" 'eval-current-buffer)	; F14 or         L4
(define-key sun-fkeymap "28~" 'enlarge-window)		; F15 or Help or L5
(define-key sun-fkeymap "29~" 'shrink-window)		; F16 or Menu or L6
(define-key sun-fkeymap "31~" 'revert-buffer)		; F17 or         L7
(define-key sun-fkeymap "32~" 'revert-buffer)		; F18 or         L8
(define-key sun-fkeymap "33~" 'beginning-of-buffer)	; F19 or         L9
(define-key sun-fkeymap "34~" 'end-of-buffer)		; F20 or         L10

;;;
;;; Key bindings for Sun X11 terminals(x11term)
;;;

(define-key sun-fkeymap "192z" 'insert-buffer)		; L1
(define-key sun-fkeymap "193z" 'insert-file)		; L2
(define-key sun-fkeymap "194z" 'eval-region)		; L3
(define-key sun-fkeymap "195z" 'eval-current-buffer)	; L4
(define-key sun-fkeymap "196z" 'enlarge-window)		; L5
(define-key sun-fkeymap "197z" 'shrink-window)		; L6
(define-key sun-fkeymap "198z" 'revert-buffer)		; L7
(define-key sun-fkeymap "199z" 'revert-buffer)		; L8
(define-key sun-fkeymap "200z" 'beginning-of-buffer)	; L9
(define-key sun-fkeymap "201z" 'end-of-buffer)		; L10

(define-key sun-fkeymap "224z" 'set-file-coding-system)	; F1 92.4.16 by K.Handa
(define-key sun-fkeymap "225z" 'edit-dict-item)	        ; F2
(define-key sun-fkeymap "226z" 'jis-code-input)   	; F3
(define-key sun-fkeymap "227z" 'toroku-region)		; F4
(define-key sun-fkeymap "228z" 'zenkaku-region)		; F5
(define-key sun-fkeymap "229z" 'hankaku-region)		; F6
(define-key sun-fkeymap "230z" 'katakana-region)	; F7
(define-key sun-fkeymap "231z" 'hiragana-region)	; F8
(define-key sun-fkeymap "232z" 'henkan-region)		; F9
