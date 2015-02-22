;; This file is a part of Canna and Egg on Nemacs/Mule.

;; Canna and Egg on Nemacs/Mule is distributed in the forms of
;; patches to Nemacs under the terms of the GNU EMACS GENERAL
;; PUBLIC LICENSE which is distributed along with GNU Emacs by
;; the Free Software Foundation.

;; Canna and Egg on Nemacs/Mule is distributed in the hope that
;; it will be useful, but WITHOUT ANY WARRANTY; without even
;; the implied warranty of MERCHANTABILITY or FITNESS FOR A
;; PARTICULAR PURPOSE.  See the GNU EMACS GENERAL PUBLIC
;; LICENSE for more details.

;; You should have received a copy of the GNU EMACS GENERAL
;; PUBLIC LICENSE along with Nemacs/Mule; see the file
;; COPYING.  If not, write to the Free Software Foundation,
;; 675 Mass Ave, Cambridge, MA 02139, USA.

;; Written by Akira Kon, NEC Corporation.
;; E-Mail:  kon@d1.bs2.mt.nec.co.jp.

;; -*-mode: emacs-lisp-*-

;; $Id: can-n-egg.el,v 1.6 1994/03/09 02:32:35 kon Exp $

;; この機能を使うには、
;; M-x load このファイル
;; M-x can-n-egg
;; を実行します。

(require 'canna)

(if (boundp 'MULE)
    (require 'egg)
  (require 'wnn-egg))

(provide 'can-n-egg)

;;; この関数では、現在のモードが『かんな』の日本語入力モードか
;;; どうかをチェックして、『かんな』の日本語入力モードでないの
;;; であれば、『たまご』の egg-self-insert-command を呼ぶ。『か
;;; んな』の日本語入力モードであれば、『かんな』の 
;;; canna-self-insert-command を呼ぶ。

(defvar canna-exec-hook nil)
(defvar canna-toggle-key nil)
(defvar egg-toggle-key nil)

(defun can-n-egg-self-insert-command (arg)
  "Self insert pressed key and use it to assemble Romaji character."
  (interactive "p")
  (if canna:*japanese-mode*
      (canna-self-insert-command arg)
    (egg-self-insert-command arg)))

(defun can-n-egg ()
  "Start to use both Canna and Egg."
  (interactive)
  (if canna-exec-hook
      (run-hooks canna-exec-hook)
    (canna))
  (let ((ch 32))
    (while (< ch 127)
      (aset global-map ch 'can-n-egg-self-insert-command)
      (setq ch (1+ ch)) ))
  (global-set-key
   (if canna-toggle-key canna-toggle-key "\C-o") 'canna-toggle-japanese-mode)
  (global-set-key
   (if egg-toggle-key egg-toggle-key "\C-\\") 'toggle-egg-mode) )

