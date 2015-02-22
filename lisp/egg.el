;; Japanese Character Input Package for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;; This file is part of Egg on Mule (Multilingal Environment)

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

;;;==================================================================
;;;
;;; 日本語環境 「たまご」 第３版    
;;;
;;;=================================================================== 

;;;
;;;「たまご」はネットワークかな漢字変換サーバを利用し、Nemacs での日本
;;; 語環境を提供するシステムです。「たまご」第２版では Wnn V3 および 
;;; Wnn V4 のかな漢字変換サーバを使用しています。
;;;

;;; 名前は 「沢山/待たせて/ごめんなさい」の各文節の先頭１音である「た」
;;; と「ま」と「ご」を取って、「たまご」と言います。電子技術総合研究所
;;; の錦見 美貴子氏の命名に依るものです。egg は「たまご」の英訳です。

;;;
;;; 使用法は etc/NEMACS.egg を見て下さい。
;;;

;;;
;;; 「たまご」に関する提案、虫情報は tomura@etl.go.jp にお送り下さい。
;;;

;;;
;;;                      〒 305 茨城県つくば市梅園1-1-4
;;;                      通産省工業技術院電子技術総合研究所
;;;                      情報アーキテクチャ部言語システム研究室
;;;
;;;                                                     戸村 哲  

;;;
;;; (注意)このファイルは漢字コードを含んでいます。 
;;;
;;;   第３版  １９９１年２月  ４日
;;;   第２版  １９８９年６月  １日
;;;   第１版  １９８８年７月１４日
;;;   暫定版  １９８８年６月２４日

;;;=================================================================== 
;;;
;;; (eval-when (load) (require 'wnn-client))
;;;
(provide 'egg)

(defvar egg-version "3.09" "Version number of this version of Egg. ")
;;; Last modified date: Fri Sep 25 12:59:00 1992

;;;;  修正要求リスト

;;;;  read-hiragana-string, read-kanji-string で使用する平仮名入力マップを roma-kana に固定しないで欲しい．

;;;;  修正メモ

;;; 93.6.19  modified by T.Shingu <shingu@cpr.canon.co.jp>
;;; egg:*in-fence-mode* should be buffer local.

;;; 93.6.4   modified by T.Shingu <shingu@cpr.canon.co.jp>
;;; In its-defrule**, length is called instead of chars-in-string.

;;; 93.3.15  modified by T.Enami <enami@sys.ptg.sony.co.jp>
;;; egg-self-insert-command simulates the original more perfectly.

;;; 92.12.20 modified by S.Tomura <tomura@etl.go.jp>
;;; In its:simulate-input, sref is called instead of aref.

;;; 92.12.20 modified by T.Enami <enami@sys.ptg.sony.co.jp>
;;; egg-self-insert-command calls cancel-undo-boundary to simulate original.

;;; 92.11.4 modified by M.Higashida <manabu@sigmath.osaka-u.ac.jp>
;;; read-hiragana-string sets minibuffer-preprompt correctly.

;;; 92.10.26, 92.10.30 modified by T.Saneto sanewo@pdp.crl.sony.co.jp
;;; typo fixed.

;;; 92.10.18 modified by K. Handa <handa@etl.go.jp>
;;; special-symbol-input 用のテーブルを autoload に。
;;; busyu.el の autoload の指定を mule-init.el から egg.el に移す。

;;;  92.9.20 modified by S. Tomura
;;;; hiragana-region の虫の修正

;;;; 92.9.19 modified by Y. Kawabe
;;;; some typos

;;;; 92.9.19 modified by Y. Kawabe<kawabe@sramhc.sra.co.jp>
;;;; menu の表示関係の lenght を string-width に置き換える．

;;; 92.8.19 modified for Mule Ver.0.9.6 by K.Handa <handa@etl.go.jp>
;;;; menu:select-from-menu calls string-width instead of length.

;;;; 92.8.1 modified by S. Tomura
;;;; internal mode を追加．its:*internal-mode-alist* 追加．

;;;; 92.7.31 modified by S. Tomura
;;;; its-mode-map が super mode map を持つように変更した．これにより 
;;;; mode map が共有できる． its-define-mode, get-next-map などを変更． 
;;;; get-next-map-locally を追加．its-defrule** を変更．

;;;; 92.7.31 modified by S. Tomura
;;;; its:make-kanji-buffer , its:*kanji* 関連コードを削除した．

;;;; 92.7.31 modified by S. Tomura
;;;;  egg:select-window-hook を修正し，minibuffer から exit するときに， 
;;;; 各種変数を default-value に戻すようにした．これによって 
;;;; minibufffer に入る前に各種設定が可能となる．

;;; 92.7.14  modified for Mule Ver.0.9.5 by T.Ito <toshi@his.cpl.melco.co.jp>
;;;	Attribute bold can be used.
;;;	Unnecessary '*' in comments of variables deleted.
;;; 92.7.8   modified for Mule Ver.0.9.5 by Y.Kawabe <kawabe@sra.co.jp>
;;;	special-symbol-input keeps the position selected last.
;;; 92.7.8   modified for Mule Ver.0.9.5 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	busyu-input and kakusuu-input are added in *symbol-input-menu*.
;;; 92.7.7   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	In egg:quit-mode, overwrite-mode is supported correctly.
;;;	egg:*overwrite-mode-deleted-chars* is not used now.
;;; 92.6.26  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;;	Funtion dump-its-mode-map gets obsolete.
;;; 92.6.26  modified for Mule Ver.0.9.5 by M.Shikida <shikida@cs.titech.ac.jp>
;;;	Backquote ` is registered in *hankaku-alist* and *zenkaku-alist*.
;;; 92.6.17  modified for Mule Ver.0.9.5 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	Bug in make-jis-second-level-code-alist fixed.
;;; 92.6.14  modified for Mule Ver.0.9.5 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;	menu:select-from-menu is replaced with new version.
;;; 92.5.18  modified for Mule Ver.0.9.4 by T.Shingu <shingu@cpr.canon.co.jp>
;;;	lisp/wnn-egg.el is devided into two parts: this file and wnn*-egg.el.

;;;;
;;;; Mule Ver.0.9.3 以前
;;;;

;;;; April-15-92 for Mule Ver.0.9.3
;;;;	by T.Enami <enami@sys.ptg.sony.co.jp> and K.Handa <handa@etl.go.jp>
;;;;	notify-internal calls 'message' with correct argument.

;;;; April-11-92 for Mule Ver.0.9.3
;;;;	by T.Enami <enami@sys.ptg.sony.co.jp> and K.Handa <handa@etl.go.jp>
;;;;	minibuffer から抜ける時 egg:select-window-hook で egg:*input-mode* を
;;;;	t にする。hook の形を大幅修正。

;;;; April-3-92 for Mule Ver.0.9.2 by T.Enami <enami@sys.ptg.sony.co.jp>
;;;; minibuffer から抜ける時 egg:select-window-hook が new-buffer の
;;;; egg:*mode-on* などを nil にしているのを修正。

;;;; Mar-22-92 by K.Handa
;;;; etags が作る TAGS に不必要なものを入れないようにするため関数名変更
;;;; define-its-mode -> its-define-mode, defrule -> its-defrule

;;;; Mar-16-92 by K.Handa
;;;; global-map への define-key を mule-keymap に変更。

;;;; Mar-13-92 by K.Handa
;;;; Language specific part を japanese.el,... に移した。

;;;; Feb-*-92 by K. Handa
;;;; nemacs 4 では minibuffer-window-selected が廃止になり，関連するコードを削除した．

;;;; Jan-13-92 by S. Tomura
;;;; mc-emacs or nemacs 4 対応作業開始．

;;;; Aug-9-91 by S. Tomura
;;;; ?\^ を ?^ に修正．

;;;;  menu を key map を見るようにする．

;;;;  Jul-6-91 by S. Tomura
;;;;  setsysdict の error メッセージを変更．

;;;;  Jun-11-91 by S. Tomura
;;;;  its:*defrule-verbose* を追加．
;;;;

;;;;  Mar-25-91 by S. Tomura
;;;;  reset-its-mode を廃止

;;;;  Mar-23-91 by S. Tomura
;;;;  read-hiragana-string を修正， read-kanji-string を追加，
;;;;  isearch:read-kanji-string を設定．

;;;;  Mar-22-91 by S. Tomura
;;;;  defrule-conditional, defrule-select-mode-temporally を追加。
;;;;  for-each の簡易版として dolist を追加。
;;;;  enable-double-n-syntax を活用．ほかに use-kuten-for-comma, use-touten-for-period を追加

;;;;  Mar-5-91 by S. Tomura
;;;;  roma-kana-word, henkan-word, roma-kanji-word を追加した．

;;;;  Jan-14-91 by S. Tomura
;;;;  入力文字変換系 ITS(Input character Translation System) を改造する．
;;;;  変換は最左最長変換を行ない，変換のないものはもとのままとなる．
;;;;  改造の動機は立木＠慶応さんのハングル文字の入力要求である．
;;;;  its:* を追加した．また従来 fence-self-insert-command と roma-kana-region 
;;;;  二箇所にわかれていたコードを its:translate-region によって一本化した．

;;;;  July-30-90 by S. Tomura
;;;;  henkan-region をoverwrite-mode に対応させる．変数 
;;;;  egg:*henkan-fence-mode*, egg:*overwrite-mode-deleted-chars*
;;;;  を追加し，henkan-fence-region, henkan-region-internal, 
;;;;  quit-egg-mode を変更する．

;;;;  Mar-4-90 by K.Handa
;;;;  New variable alphabet-mode-indicator, transparent-mode-indicator,
;;;;  and henkan-mode-indicator.

;;;;  Feb-27-90 by enami@ptgd.sony.co.jp
;;;;  menu:select-from-menu で２箇所ある ((and (<= ?0 ch) (<= ch ?9)...
;;;;  の一方を ((and (<= ?0 ch) (<= ch ?9)... に修正

;;;;  Feb-07-89
;;;;  bunsetu-length-henko の中の egg:*attribute-off の位置を KKCP を呼ぶ前に
;;;;  変更する。 wnn-client では KKCP を呼ぶと文節情報が変化する。

;;;;  Feb-01-89
;;;;  henkan-goto-kouho の egg:set-bunsetu-attribute の引数
;;;;  の順番が間違っていたのを修正した。（toshi@isvax.isl.melco.co.jp
;;;;  (Toshiyuki Ito)の指摘による。）

;;;;  Dec-25-89
;;;;  meta-flag t の場合の対応を再修正する。
;;;;  overwrite-mode での undo を改善する。

;;;;  Dec-21-89
;;;;  bug fixed by enami@ptdg.sony.co.jp
;;;;     (fboundp 'minibuffer-window-selected )
;;;;  -->(boundp  'minibuffer-window-selected )
;;;;  self-insert-after-hook を buffer local にして定義を kanji.el へ移動。

;;;;  Dec-15-89
;;;;  kill-all-local-variables の定義を kanji.el へ移動する。

;;;;  Dec-14-89
;;;;  meta-flag t の場合の処理を修正する
;;;;  overwrite-mode に対応する。

;;;;  Dec-12-89
;;;;  egg:*henkan-open*, egg:*henkan-close* を追加。
;;;;  egg:*henkan-attribute* を追加
;;;;  set-egg-fence-mode-format, set-egg-henkan-mode-format を追加

;;;;  Dec-12-89
;;;;  *bunpo-code* に 1000: "その他" を追加

;;;;  Dec-11-89
;;;;  egg:*fence-attribute* を新設
;;;;  egg:*bunsetu-attribute* を新設

;;;;  Dec-11-89
;;;;  attribute-*-region を利用するように変更する。
;;;;  menu:make-selection-list は width が小さい時にloop する。これを修正した。

;;;;  Dec-10-89
;;;;  set-marker-type を利用する方式に変更。

;;;;  Dec-07-89
;;;;  egg:search-path を追加。
;;;;  egg-default-startup-file を追加する。

;;;;  Nov-22-89
;;;;  egg-startup-file を追加する。
;;;;  eggrc-search-path を egg-startup-file-search-path に名前変更。

;;;;  Nov-21-89
;;;;  Nemacs 3.2 に対応する。kanji-load* を廃止する。
;;;;  wnnfns.c に対応した修正を加える。
;;;;  *Notification* buffer を見えなくする。

;;;;  Oct-2-89
;;;;  *zenkaku-alist* の 文字定数の書き方が間違っていた。

;;;;  Sep-19-89
;;;;  toggle-egg-mode の修正（kanji-flag）
;;;;  egg-self-insert-command の修正 （kanji-flag）

;;;;  Sep-18-89
;;;;  self-insert-after-hook の追加

;;;;  Sep-15-89
;;;;  EGG:open-wnn bug fix
;;;;  provide wnn-egg feature

;;;;  Sep-13-89
;;;;  henkan-kakutei-before-point を修正した。
;;;;  enter-fence-mode の追加。
;;;;  egg-exit-hook の追加。
;;;;  henkan-region-internal の追加。henkan-regionは point をmark する。
;;;;  eggrc-search-path の追加。

;;;;  Aug-30-89
;;;;  kanji-kanji-1st を訂正した。

;;;;  May-30-89
;;;;  EGG:open-wnn は get-wnn-host-name が nil の場合、(system-name) を使用する。

;;;;  May-9-89
;;;;  KKCP:make-directory added.
;;;;  KKCP:file-access bug fixed.
;;;;  set-default-usr-dic-directory modified.

;;;;  Mar-16-89
;;;;  minibuffer-window-selected を使って minibuffer の egg-mode表示機能追加

;;;;  Mar-13-89
;;;;   mode-line-format changed. 

;;;;  Feb-27-89
;;;;  henkan-saishou-bunsetu added
;;;;  henkan-saichou-bunsetu added
;;;;  M-<    henkan-saishou-bunsetu
;;;;  M->    henkan-saichou-bunsetu

;;;;  Feb-14-89
;;;;   C-h in henkan mode: help-command added

;;;;  Feb-7-89
;;;;   egg-insert-after-hook is added.

;;;;   M-h   fence-hiragana
;;;;   M-k   fence-katakana
;;;;   M->   fence-zenkaku
;;;;   M-<   fence-hankaku

;;;;  Dec-19-88 henkan-hiragana, henkan-katakaraを追加：
;;;;    M-h     henkan-hiragana
;;;;    M-k     henkan-katakana

;;;;  Ver. 2.00 kana2kanji.c を使わず wnn-client.el を使用するように変更。
;;;;            関連して一部関数を変更

;;;;  Dec-2-88 special-symbol-input を追加；
;;;;    C-^   special-symbol-input

;;;;  Nov-18-88 henkan-mode-map 一部変更；
;;;;    M-i  henkan-inspect-bunsetu
;;;;    M-s  henkan-select-kouho
;;;;    C-g  henkan-quit

;;;;  Nov-18-88 jserver-henkan-kakutei の仕様変更に伴い、kakutei のコー
;;;;  ドを変更した。

;;;;  Nov-17-88 kakutei-before-point で point 以降の間違った部分の変換
;;;;  が頻度情報に登録されないように修正した。これにはKKCC:henkan-end 
;;;;  の一部仕様と対応するkana2kanji.cも変更した。

;;;;  Nov-17-88 henkan-inspect-bunsetu を追加した。

;;;;  Nov-17-88 新しい kana2kanji.c に変更する。

;;;;  Sep-28-88 defruleが値としてnilを返すように変更した。

;;;;  Aug-25-88 変換学習を正しく行なうように変更した。
;;;;  KKCP:henkan-kakuteiはKKCP:jikouho-listを呼んだ文節に対してのみ適
;;;;  用でき、それ以外の場合の結果は保証されない。この条件を満たすよう
;;;;  にKKCP:jikouho-listを呼んでいない文節に対しては
;;;;  KKCP:henkan-kakuteiを呼ばないようにした。

;;;;  Aug-25-88 egg:do-auto-fill を修正し、複数行にわたるauto-fillを正
;;;;  しく行なうように修正した。

;;;;  Aug-25-88 menu commandに\C-l: redraw を追加した。

;;;;  Aug-25-88 toroku-regionで登録する文字列からno graphic characterを
;;;;  自動的に除くことにした。

;;;----------------------------------------------------------------------
;;;
;;; Version control routine
;;;
;;;----------------------------------------------------------------------

(and (equal (user-full-name) "Satoru Tomura")
     (defun egg-version-update (arg)
       (interactive "P")
       (if (equal (buffer-name (current-buffer)) "wnn-egg.el")
	   (save-excursion
	    (goto-char (point-min))
	    (re-search-forward "(defvar egg-version \"[0-9]+\\.")
	    (let ((point (point))
		  (minor))
	      (search-forward "\"")
	      (backward-char 1)
	      (setq minor (string-to-int (buffer-substring point (point))))
	      (delete-region point (point))
	      (if (<= minor 8) (insert "0"))
	      (insert  (int-to-string (1+ minor)))
	      (search-forward "Egg last modified date: ")
	      (kill-line)
	      (insert (current-time-string)))
	    (save-buffer)
	    (if arg (byte-compile-file (buffer-file-name)))
	 )))
     )
;;;
;;;----------------------------------------------------------------------
;;;
;;; Utilities
;;;
;;;----------------------------------------------------------------------

;;; 
;;;;

(defun characterp (form)
  (numberp form))

(defun coerce-string (form)
  (cond((stringp form) form)
       ((characterp form) (char-to-string form))))

(defun coerce-internal-string (form)
  (cond((stringp form)
	(if (= (chars-in-string form) 1) 
	    (string-to-char form)
	  form))
       ((characterp form) form)))

;;; kill-all-local-variables から保護する local variables を指定できる
;;; ように変更する。

(defconst *protected-local-variables* 
  (append 
   '(egg:*input-mode* 
     egg:*mode-on*
     its:*current-map*
     mode-line-egg-mode)
   *protected-local-variables*)
  "List of buffer local variables protected from ""kill-all-local-variables"" ."
  )

;;;----------------------------------------------------------------------
;;;
;;; 16進表現のJIS 漢字コードを minibuffer から読み込む
;;;
;;;----------------------------------------------------------------------

;;;
;;; User entry:  jis-code-input
;;;

(defun jis-code-input ()
  (interactive)
  (insert-jis-code-from-minibuffer "JIS 漢字コード(16進数表現): "))

(defun insert-jis-code-from-minibuffer (prompt)
  (let ((str (read-from-minibuffer prompt)) val)
    (while (null (setq val (read-jis-code-from-string str)))
      (beep)
      (setq str (read-from-minibuffer prompt str)))
    (insert (make-character lc-jp (car val) (cdr val)))))

(defun hexadigit-value (ch)
  (cond((and (<= ?0 ch) (<= ch ?9))
	(- ch ?0))
       ((and (<= ?a ch) (<= ch ?f))
	(+ (- ch ?a) 10))
       ((and (<= ?A ch) (<= ch ?F))
	(+ (- ch ?A) 10))))

(defun read-jis-code-from-string (str)
  (if (and (= (length str) 4)
	   (<= 2 (hexadigit-value (aref str 0)))
	   (hexadigit-value (aref str 1))
	   (<= 2 (hexadigit-value (aref str 2)))
	   (hexadigit-value (aref str 3)))
  (cons (+ (* 16 (hexadigit-value (aref str 0)))
	       (hexadigit-value (aref str 1)))
	(+ (* 16 (hexadigit-value (aref str 2)))
	   (hexadigit-value (aref str 3))))))

;;;----------------------------------------------------------------------	
;;;
;;; 「たまご」 Notification System
;;;
;;;----------------------------------------------------------------------

(defconst *notification-window* " *Notification* ")

;;;(defmacro notify (str &rest args)
;;;  (list 'notify-internal
;;;	(cons 'format (cons str args))))

(defun notify (str &rest args)
  (notify-internal (apply 'format (cons str args))))

(defun notify-internal (message &optional noerase)
  (save-excursion
    (let ((notify-buff (get-buffer-create *notification-window*)))
      (set-buffer notify-buff)
      (goto-char (point-max))
      (setq buffer-read-only nil)
      (insert (substring (current-time-string) 4 19) ":: " message ?\n )
      (setq buffer-read-only t)
      (bury-buffer notify-buff)
      (message "%s" message)		; 92.4.15 by T.Enami
      (if noerase nil
	(sleep-for 1) (message "")))))

;;;(defmacro notify-yes-or-no-p (str &rest args)
;;;  (list 'notify-yes-or-no-p-internal 
;;;	(cons 'format (cons str args))))

(defun notify-yes-or-no-p (str &rest args)
  (notify-yes-or-no-p-internal (apply 'format (cons str args))))

(defun notify-yes-or-no-p-internal (message)
  (save-window-excursion
    (pop-to-buffer *notification-window*)
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (yes-or-no-p "いいですか？")))

(defun notify-y-or-n-p (str &rest args)
  (notify-y-or-n-p-internal (apply 'format (cons str args))))

(defun notify-y-or-n-p-internal (message)
  (save-window-excursion
    (pop-to-buffer *notification-window*)
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (substring (current-time-string) 4 19) ":: " message ?\n )
    (setq buffer-read-only t)
    (y-or-n-p "いいですか？")))

(defun select-notification ()
  (interactive)
  (pop-to-buffer *notification-window*)
  (setq buffer-read-only t))

;;;----------------------------------------------------------------------
;;;
;;; 「たまご」 Menu System
;;;
;;;----------------------------------------------------------------------

;;;
;;;  minibuffer に menu を表示・選択する
;;;

;;;
;;; menu の指定方法：
;;;
;;; <menu item> ::= ( menu <prompt string>  <menu-list> )
;;; <menu list> ::= ( <menu element> ... )
;;; <menu element> ::= ( <string> . <value> ) | <string>
;;;                    ( <char>   . <value> ) | <char>

;;; select-menu-in-minibuffer

(defvar menu:*select-items* nil)
(defvar menu:*select-menus* nil)
(defvar menu:*select-item-no* nil)
(defvar menu:*select-menu-no* nil)
(defvar menu:*select-menu-stack* nil)
(defvar menu:*select-start* nil)
(defvar menu:*select-positions* nil)

(defvar menu-mode-map (make-keymap))

(define-key menu-mode-map "\C-a" 'menu:begining-of-menu)
(define-key menu-mode-map "\C-e" 'menu:end-of-menu)
(define-key menu-mode-map "\C-f" 'menu:next-item)
(define-key menu-mode-map "\C-b" 'menu:previous-item)
(define-key menu-mode-map "\C-n" 'menu:next-item-old)
(define-key menu-mode-map "\C-g" 'menu:quit)
(define-key menu-mode-map "\C-p" 'menu:previous-item-old)
(define-key menu-mode-map "\C-l" 'menu:refresh)
;;; 0 .. 9 a .. z A .. z
(define-key menu-mode-map "\C-m" 'menu:select)

;; 92.6.14 by T.Enami -- This function was completely modified.
(defun menu:select-from-menu (menu &optional initial position)
  (let ((echo-keystrokes 0)
	(inhibit-quit t)
	(menubuffer (get-buffer-create " *menu*"))
	(minibuffer (window-buffer (minibuffer-window)))
	value)
    (save-window-excursion
      (set-window-buffer (minibuffer-window) menubuffer)
      (select-window (minibuffer-window))
      (set-buffer menubuffer)
      (delete-region (point-min) (point-max))
      (insert (nth 1 menu))
      (let* ((window-width (window-width (selected-window)))
	     (finished nil))
	(setq menu:*select-menu-stack* nil
	      menu:*select-positions* nil
	      menu:*select-start* (point)
	      menu:*select-menus*
	      (menu:make-selection-list (nth 2 menu)
					(- window-width  
					   ;;; 92.8.19 by K.Handa
					   (string-width (nth 1 menu)))))
	;; 92.7.8 by Y.Kawabe
	(cond
	 ((and (numberp initial)
	       (<= 0 initial)
	       (< initial (length (nth 2 menu))))
	  (menu:select-goto-item-position initial))
	 ((and (listp initial) (car initial)
	       (<= 0 (car initial))
	       (< (car initial) (length (nth 2 menu))))
	  (menu:select-goto-item-position (car initial))
	  (while (and (setq initial (cdr initial))
		      (setq value (menu:item-value (nth menu:*select-item-no* 
							menu:*select-items*)))
		      (listp value) (eq (car value) 'menu))
	    (setq menu:*select-positions*
		  (cons (menu:select-item-position) menu:*select-positions*))
	    (setq menu:*select-menu-stack*
		  (cons (list menu:*select-items* menu:*select-menus*
			      menu:*select-item-no* menu:*select-menu-no*
			      menu)
			menu:*select-menu-stack*))
	    (setq menu value)
	    (delete-region (point-min) (point-max)) (insert (nth 1 menu))
	    (setq menu:*select-start* (point))
	    (setq menu:*select-menus*
		  (menu:make-selection-list
		   ;;; 92.9.19 by Y. Kawabe
		   (nth 2 menu) (- window-width (string-width (nth 1 menu)))))
	    (if (and (numberp (car initial))
		     (<= 0 (car initial))
		     (< (car initial) (length (nth 2 menu))))
		(menu:select-goto-item-position (car initial))
	      (setq menu:*select-item-no* 0)
	      (menu:select-goto-menu 0)))
	  (setq value nil))
	 (t
	  (setq menu:*select-item-no* 0)
	  (menu:select-goto-menu 0))
	 )
	;; end of patch
	(while (not finished)
	  (let ((ch (read-char)))
	    (setq quit-flag nil)
	    (cond
	     ((= ch ?\C-a)
	      (menu:select-goto-item 0))
	     ((= ch ?\C-e)
	      (menu:select-goto-item (1- (length menu:*select-items*))))
	     ((= ch ?\C-f)
	      ;;(menu:select-goto-item (1+ menu:*select-item-no*))
	      (menu:select-next-item)
	      )
	     ((= ch ?\C-b)
	      ;;(menu:select-goto-item (1- menu:*select-item-no*))
	      (menu:select-previous-item)
	      )
	     ((= ch ?\C-n)
	      (menu:select-goto-menu (1+ menu:*select-menu-no*)))
	     ((= ch ?\C-g)
	      (if menu:*select-menu-stack*
		  (let ((save (car menu:*select-menu-stack*)))
		    (setq menu:*select-menu-stack*
			  (cdr menu:*select-menu-stack*))
		    (setq menu:*select-items* (nth 0 save);92.10.26 by T.Saneto
			  menu:*select-menus*    (nth 1 save)
			  menu:*select-item-no*  (nth 2 save)
			  menu:*select-menu-no*  (nth 3 save)
			  menu                   (nth 4 save))
		    (setq menu:*select-positions*
			  (cdr menu:*select-positions*))
		    (delete-region (point-min) (point-max))
		    (insert (nth 1 menu))
		    (setq menu:*select-start* (point))
		    (menu:select-goto-menu menu:*select-menu-no*)
		    (menu:select-goto-item menu:*select-item-no*)
		    )
		(setq finished t
		      value nil)))
	     ((= ch ?\C-p)
	      (menu:select-goto-menu (1- menu:*select-menu-no*)))
	     ((= ch ?\C-l)  ;;; redraw menu
	      (menu:select-goto-menu menu:*select-menu-no*))
	     ((and (<= ?0 ch) (<= ch ?9)
		   (<= ch (+ ?0 (1- (length menu:*select-items*)))))
	      (menu:select-goto-item (- ch ?0)))
	     ((and (<= ?a ch) (<= ch ?z)
		   (<= (+ 10 ch) (+ ?a (1- (length menu:*select-items*)))))
	      (menu:select-goto-item (+ 10 (- ch ?a))))
	     ((and (<= ?A ch) (<= ch ?Z) ; patch by enami@ptgd.sony.co.jp
		   (<= (+ 10 ch) (+ ?A (1- (length menu:*select-items*)))))
	      (menu:select-goto-item (+ 10 (- ch ?A))))
	     ((= ch ?\C-m)
	      (setq value (menu:item-value (nth menu:*select-item-no* 
						menu:*select-items*)))
	      (setq menu:*select-positions* 
		    (cons (menu:select-item-position)
			  menu:*select-positions*))
	      (if (and (listp value)
		       (eq (car value) 'menu))
		  (progn
		    (setq menu:*select-menu-stack*
			  (cons
			   (list menu:*select-items* menu:*select-menus*
				 menu:*select-item-no* menu:*select-menu-no*
				 menu)
			   menu:*select-menu-stack*))
		    (setq menu value)
		    (delete-region (point-min) (point-max))
		    (insert (nth 1 menu))
		    (setq menu:*select-start* (point))
		    (setq menu:*select-menus*
			  ;;; 92.9.19 by Y. Kawabe
			  (menu:make-selection-list
			   (nth 2 menu)
			   (- window-width
			      (string-width (nth 1 menu)))))
		    (setq menu:*select-item-no* 0)
		    (menu:select-goto-menu 0)
		    (setq value nil)
		    )
		(setq finished t)))
	     (t (beep))))))
      (delete-region (point-min) (point-max))
      (setq menu:*select-positions*
	    (nreverse menu:*select-positions*))
      (set-window-buffer (minibuffer-window) minibuffer)
      (if (null value)
	  (setq quit-flag t)
	(if position
	    (cons value menu:*select-positions*)
	  value)))))

(defun menu:select-item-position ()
  (let ((p 0) (m 0))
    (while (< m menu:*select-menu-no*)
      (setq p (+ p (length (nth m menu:*select-menus*))))
      (setq m (1+ m)))
    (+ p menu:*select-item-no*)))
    
(defun menu:select-goto-item-position (pos)
  (let ((m 0) (i 0) (p 0))
    (while (<= (+ p (length (nth m menu:*select-menus*))) pos)
      (setq p (+ p (length (nth m menu:*select-menus*))))
      (setq m (1+ m)))
    (setq menu:*select-item-no* (- pos p))
    (menu:select-goto-menu m)))

(defun menu:select-goto-menu (no)
  (setq menu:*select-menu-no*
	(check-number-range no 0 (1- (length menu:*select-menus*))))
  (setq menu:*select-items* (nth menu:*select-menu-no* menu:*select-menus*))
  (delete-region menu:*select-start* (point-max))
  (if (<= (length menu:*select-items*) menu:*select-item-no*)
      (setq menu:*select-item-no* (1- (length menu:*select-items*))))
  (goto-char menu:*select-start*)
  (let ((l menu:*select-items*) (i 0))
    (while l
      (insert (if (<= i 9) (format "  %d." i)
		(format "  %c." (+ (- i 10) ?a)))
	      (menu:item-string (car l)))
      (setq l (cdr l)
	    i (1+ i))))
  (menu:select-goto-item menu:*select-item-no*))

(defun menu:select-goto-item (no)
  (setq menu:*select-item-no* 
	(check-number-range no 0
			    (1- (length menu:*select-items*))))
  (let ((p (+ 2 menu:*select-start*)) (i 0))
    (while (< i menu:*select-item-no*)
      (setq p (+ p (length (menu:item-string (nth i menu:*select-items*))) 4))
      (setq i (1+ i)))
    (goto-char p)))
    
(defun menu:select-next-item ()
  (if (< menu:*select-item-no* (1- (length menu:*select-items*)))
      (menu:select-goto-item (1+ menu:*select-item-no*))
    (progn
      (setq menu:*select-item-no* 0)
      (menu:select-goto-menu (1+ menu:*select-menu-no*)))))

(defun menu:select-previous-item ()
  (if (< 0 menu:*select-item-no*)
      (menu:select-goto-item (1- menu:*select-item-no*))
    (progn 
      (setq menu:*select-item-no* 1000)
      (menu:select-goto-menu (1- menu:*select-menu-no*)))))

(defvar menu:*display-item-value* nil)

(defun menu:item-string (item)
  (cond((stringp item) item)
       ((numberp item) (char-to-string item))
       ((consp item)
	(if menu:*display-item-value*
	    (format "%s [%s]"
		    (cond ((stringp (car item)) (car item))
			  ((numberp (car item)) (char-to-string (car item)))
			  (t ""))
		    (cdr item))
	  (cond ((stringp (car item))
		 (car item))
		((numberp (car item))
		 (char-to-string (car item)))
		(t ""))))
       (t "")))

(defun menu:item-value (item)
  (cond((stringp item) item)
       (t (cdr item))))

(defun menu:make-selection-list (items width)
  (let ((whole nil) (line nil) (size 0))
    (while items
      ;;; 92.9.19 by Y. Kawabe
      (if (<= width (+ size 4 (string-width (menu:item-string(car items)))))
	  (if line
	      (setq whole (cons (reverse line) whole)
		    line nil
		    size 0)
	    (setq whole (cons (list (car items)) whole)
		  size 0
		  items (cdr items)))
	;;; 92.9.19 by Y. Kawabe
	(setq line (cons (car items) line)
	      size (+ size 4 (string-width(menu:item-string (car items))))
	      items (cdr items))))
    (if line
	(reverse (cons (reverse line) whole))
      (reverse whole))))


;;;----------------------------------------------------------------------
;;;
;;;  一括型変換機能
;;;
;;;----------------------------------------------------------------------

(defvar ascii-char "[\40-\176]")

(defvar ascii-space "[ \t]")
(defvar ascii-symbols "[\40-\57\72-\100\133-\140\173-\176]")
(defvar ascii-numeric "[\60-\71]")
(defvar ascii-English-Upper "[\101-\132]")
(defvar ascii-English-Lower "[\141-\172]")

(defvar ascii-alphanumeric "[\60-\71\101-\132\141-\172]")

(defvar kanji-char "\\cj")
(defvar kanji-space "　")
(defvar kanji-symbols "\\cS")
(defvar kanji-numeric "[０-９]")
(defvar kanji-English-Upper "[Ａ-Ｚ]")
(defvar kanji-English-Lower  "[ａ-ｚ]")
;;; Bug fixed by Yoshida@CSK on 88-AUG-24
(defvar kanji-hiragana "\\cH")
(defvar kanji-katakana "\\cK")
;;;
(defvar kanji-Greek-Upper "[Α-Ω]")
(defvar kanji-Greek-Lower "[α-ω]")
(defvar kanji-Russian-Upper "[А-Я]")
(defvar kanji-Russian-Lower "[а-я]")
(defvar kanji-Kanji-1st-Level  "[亜-腕]")
(defvar kanji-Kanji-2nd-Level  "[弌-瑤]")

(defvar kanji-kanji-char "\\(\\cH\\|\\cK\\|\\cC\\)")

(defvar aletter (concat "\\(" ascii-char "\\|" kanji-char "\\)"))

;;;
;;; ひらがな変換
;;;

(defun hiragana-region (start end)
  (interactive "r")
    (goto-char start)
    (while (re-search-forward kanji-katakana end end)
      (let ((ch (preceding-char)))
	(cond( (<= ch ?ン)
	       (delete-char -1)
	       (insert (make-character lc-jp ?\244 (char-component ch 2))))))))

(defun hiragana-paragraph ()
  "hiragana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (hiragana-region (point) end ))))

(defun hiragana-sentence ()
  "hiragana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (hiragana-region (point) end ))))

;;;
;;; カタカナ変換
;;;

(defun katakana-region (start end)
  (interactive "r")
  (let ((point (point)))
    (goto-char start)
    (while (re-search-forward kanji-hiragana end end)
      (let ((ch (char-component (preceding-char) 2)))
	(delete-char -1)
	(insert (make-character lc-jp ?\245 ch))))))

(defun katakana-paragraph ()
  "katakana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (katakana-region (point) end ))))

(defun katakana-sentence ()
  "katakana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (katakana-region (point) end ))))

;;;
;;; 半角変換
;;; 

(defun hankaku-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "\\cS\\|\\cA" (point-max) (point-max))
      (let* ((ch (preceding-char))
	     (ch1 (char-component ch 1))
	     (ch2 (char-component ch 2)))
	(cond ((= ?\241 ch1)
	       (let ((val (cdr (assq ch2 *hankaku-alist*))))
		 (if val (progn
			   (delete-char -1)
			   (insert val)))))
	      ((= ?\243 ch1)
	       (delete-char -1)
	       (insert (- ch2 ?\200 ))))))))

(defun hankaku-paragraph ()
  "hankaku  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (hankaku-region (point) end ))))

(defun hankaku-sentence ()
  "hankaku  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (hankaku-region (point) end ))))

(defun hankaku-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (hankaku-region start (point))))

(defvar *hankaku-alist*
  '(( 161 . ?\  ) 
    ( 170 . ?\! )
    ( 201 . ?\" )
    ( 244 . ?\# )
    ( 240 . ?\$ )
    ( 243 . ?\% )
    ( 245 . ?\& )
    ( 199 . ?\' )
    ( 202 . ?\( )
    ( 203 . ?\) )
    ( 246 . ?\* )
    ( 220 . ?\+ )
    ( 164 . ?\, )
    ( 221 . ?\- )
    ( 165 . ?\. )
    ( 191 . ?\/ )
    ( 167 . ?\: )
    ( 168 . ?\; )
    ( 227 . ?\< )
    ( 225 . ?\= )
    ( 228 . ?\> )
    ( 169 . ?\? )
    ( 247 . ?\@ )
    ( 206 . ?\[ )
    ( 239 . ?\\ )
    ( 207 . ?\] )
    ( 176 . ?^ )
    ( 178 . ?\_ )
    ( 208 . ?\{ )
    ( 195 . ?\| )
    ( 209 . ?\} )
    ( 177 . ?\~ )
    ( 198 . ?` )			; 92.6.26 by M.Shikida
    ))

;;;
;;; 全角変換
;;;

(defun zenkaku-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "[ -~]" (point-max) (point-max))
      (let ((ch (preceding-char)))
	(if (and (<= ?  ch) (<= ch ?~))
	    (progn
	      (delete-char -1)
	      (let ((zen (cdr (assq ch *zenkaku-alist*))))
		(if zen (insert zen)
		  (insert (make-character lc-jp ?\243 (+ ?\200 ch)))))))))))

(defun zenkaku-paragraph ()
  "zenkaku  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (zenkaku-region (point) end ))))

(defun zenkaku-sentence ()
  "zenkaku  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (zenkaku-region (point) end ))))

(defun zenkaku-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (zenkaku-region start (point))))

(defvar *zenkaku-alist*
  '((?  . "　") 
    (?! . "！")
    (?\" . "”")
    (?# . "＃")
    (?$ . "＄")
    (?% . "％")
    (?& . "＆")
    (?' . "’")
    (?( . "（")
    (?) . "）")
    (?* . "＊")
    (?+ . "＋")
    (?, . "，")
    (?- . "−")
    (?. . "．")
    (?/ . "／")
    (?: . "：")
    (?; . "；")
    (?< . "＜")
    (?= . "＝")
    (?> . "＞")
    (?? . "？")
    (?@ . "＠")
    (?[ . "［")
    (?\\ . "￥")
    (?] . "］")
    (?^ . "＾")
    (?_ . "＿")
    (?{ . "｛")
    (?| . "｜")
    (?} . "｝")
    (?~ . "￣")
    (?` . "‘")))			; 92.6.26 by M.Shikida

;;;
;;; ローマ字かな変換
;;;

(defun roma-kana-region (start end )
  (interactive "r")
  (its:translate-region start end nil (its:get-mode-map "roma-kana")))

(defun roma-kana-paragraph ()
  "roma-kana  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (roma-kana-region (point) end ))))

(defun roma-kana-sentence ()
  "roma-kana  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (roma-kana-region (point) end ))))

(defun roma-kana-word ()
  "roma-kana word at or after point."
  (interactive)
  (save-excursion
    (re-search-backward "\\b\\w" nil t)
    (let ((start (point)))
      (re-search-forward "\\w\\b" nil t)
      (roma-kana-region start (point)))))

;;;
;;; ローマ字漢字変換
;;;

(defun roma-kanji-region (start end)
  (interactive "r")
  (roma-kana-region start end)
  (save-restriction
    (narrow-to-region start (point))
    (goto-char (point-min))
    (replace-regexp "\\(　\\| \\)" "")
    (goto-char (point-max)))
  (henkan-region-internal start (point)))

(defun roma-kanji-paragraph ()
  "roma-kanji  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (roma-kanji-region (point) end ))))

(defun roma-kanji-sentence ()
  "roma-kanji  sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (roma-kanji-region (point) end ))))

(defun roma-kanji-word ()
  "roma-kanji word at or after point."
  (interactive)
  (save-excursion
    (re-search-backward "\\b\\w" nil t)
    (let ((start (point)))
      (re-search-forward "\\w\\b" nil t)
      (roma-kanji-region start (point)))))


;;;----------------------------------------------------------------------
;;;
;;; 「たまご」入力文字変換系 ITS
;;; 
;;;----------------------------------------------------------------------

(defun egg:member (elt list)
  (while (not (or (null list) (equal elt (car list))))
    (setq list (cdr list)))
  list)

;;;
;;; Mode name --> map
;;;
;;; ITS mode name: string

(defvar its:*mode-alist* nil)
(defvar its:*internal-mode-alist* nil)

(defun its:get-mode-map (name)
  (or (cdr (assoc name its:*mode-alist*))
      (cdr (assoc name its:*internal-mode-alist*))))

(defun its:set-mode-map (name map &optional internalp)
  (let ((place (assoc name 
		      (if internalp its:*internal-mode-alist*
			its:*mode-alist*))))
    (if place (let ((mapplace (cdr place)))
		(setcar mapplace (car map))
		(setcdr mapplace (cdr map)))
      (progn (setq place (cons name map))
	     (if internalp
		 (setq its:*internal-mode-alist*
		       (append its:*internal-mode-alist* (list place)))
	       (setq its:*mode-alist* 
		     (append its:*mode-alist* (list place))))))))

;;;
;;; ITS mode indicators
;;; Mode name --> indicator
;;;

(defun its:get-mode-indicator (name)
  (let ((map (its:get-mode-map name)))
    (if map (map-indicator map)
      name)))

(defun its:set-mode-indicator (name indicator)
  (let ((map (its:get-mode-map name)))
    (if map
	(map-set-indicator map indicator)
      (its-define-mode name indicator))))

;;;
;;; ITS mode declaration
;;;

(defvar its:*processing-map* nil)

(defun its-define-mode (name &optional indicator reset supers internalp) 
  "its-mode NAME を定義選択する．他の its-mode が選択されるまでは 
its-defrule などは NAME に対して規則を追加する．INDICATOR が non-nil 
の時には its-mode NAME を選択すると mode-line に表示される．RESET が 
non-nil の時には its-mode の定義が空になる．SUPERS は上位の its-mode 
名をリストで指定する．INTERNALP は mode name を内部名とする．
its-defrule, its-defrule-conditional, defule-select-mode-temporally を
参照"

  (if (null(its:get-mode-map name))
      (progn 
	(setq its:*processing-map* 
	      (make-map nil (or indicator name) nil (mapcar 'its:get-mode-map supers)))
	(its:set-mode-map name its:*processing-map* internalp)
	)
    (progn (setq its:*processing-map* (its:get-mode-map name))
	   (if indicator
	       (map-set-indicator its:*processing-map* indicator))
	   (if reset
	       (progn
		 (map-set-state its:*processing-map* nil)
		 (map-set-alist its:*processing-map* nil)
		 ))
	   (if supers
	       (progn
		 (map-set-supers its:*processing-map* (mapcar 'its:get-mode-map supers))))))
  nil)

;;;
;;; defrule related utilities
;;;

(put 'for-each 'lisp-indent-hook 1)

(defmacro for-each (vars &rest body)
  "(for-each ((VAR1 LIST1) ... (VARn LISTn)) . BODY) は変数 VAR1 の値
をリスト LIST1 の要素に束縛し，．．．変数 VARn の値をリスト LISTn の要
素に束縛して BODY を実行する．"

  (for-each* vars (cons 'progn body)))

(defun for-each* (vars body)
  (cond((null vars) body)
       (t (let((tvar (make-symbol "temp"))
	       (var  (car (car vars)))
	       (val  (car (cdr (car vars)))))
	    (list 'let (list (list tvar val)
			     var)
		  (list 'while tvar
			(list 'setq var (list 'car tvar))
			(for-each* (cdr vars) body)
			(list 'setq tvar (list 'cdr tvar))))))))
			     
(put 'dolist 'lisp-indent-hook 1)

(defmacro dolist (pair &rest body)
  "(dolist (VAR LISTFORM) . BODY) はVAR に順次 LISTFORM の要素を束縛し
て BODY を実行する"

  (for-each* (list pair) (cons 'progn body)))

;;;
;;; defrule
;;; 

(defun its:make-standard-action (output next)
  "OUTPUT と NEXT からなる standard-action を作る．"

  (if (and (stringp output) (string-equal output ""))
      (setq output nil))
  (if (and (stringp next)   (string-equal next   ""))
      (setq next nil))
  (cond((null output)
	(cond ((null next) nil)
	      (t (list nil next))))
       ((consp output)
	;;; alternative output
	(list (cons 0 output) next))
       ((null next) output)
       (t
	(list output next))))

(defun its:standard-actionp (action)
  "ACITION が standard-action であるかどうかを判定する．"
  (or (stringp action)
      (and (consp action)
	   (or (stringp (car action))
	       (and (consp (car action))
		    (numberp (car (car action))))
	       (null (car action)))
	   (or (null (car (cdr action)))
	       (stringp (car (cdr action)))))))

(defvar its:make-terminal-state 'its:default-make-terminal-state 
  "終端の状態での表示を作成する関数を指定する. 関数は map input
action state を引数として呼ばれ，状態表示の文字列を返す．")

(defun its:default-make-terminal-state (map input action state)
  (cond(state state)
       (t input)))

(defun its:make-terminal-state-hangul (map input action state)
  (cond((its:standard-actionp action) (action-output action))
       (t nil)))

(defvar its:make-non-terminal-state 'its:default-make-standard-non-terminal-state
  "非終端の状態での表示を作成する関数を指定する．関数は map input を
引数として呼ばれ，状態表示の文字列を返す" )

(defun its:default-make-standard-non-terminal-state (map input)
  " ****"
  (concat
   (map-state-string map)
   (char-to-string (aref input (1- (length input))))))

(defun its-defrule (input output &optional next state map) 

  "INPUT が入力されると OUTPUT に変換する．NEXT が nil でないときは変
換した後に NEXT が入力されたように変換を続ける．INPUTが入力された時点
で変換が確定していない時は STATE をフェンス上に表示する．変換が確定し
ていない時に表示する文字列は変数 its:make-terminal-state および 変数 
its:make-non-terminal-state に指示された関数によって生成される．変換規
則は MAP で指定された変換表に登録される．MAP が nil の場合はもっとも最
近に its-define-mode された変換表に登録される．なお OUTPUT が nil の場
合は INPUT に対する変換規則が削除される．"

  (its-defrule* input
    (its:make-standard-action output next) state 
    (if (stringp map) map
      its:*processing-map*)))

(defmacro its-defrule-conditional (input &rest conds)
  "(its-defrule-conditional INPUT ((COND1 OUTPUT1) ... (CONDn OUTPUTn)))は 
INPUT が入力された時に条件 CONDi を順次調べ，成立した時には OUTPUTi を
出力する．"
  (list 'its-defrule* input (list 'quote (cons 'cond conds))))

(defun its-defrule-select-mode-temporally (input name)
  "INPUT が入力されると temporally-mode として NAME が選択される．"

  (its-defrule* input (list 'quote (list 'its:select-mode-temporally name))))

(defun its-defrule* (input action &optional state map)
  (its:resize (length input))
  (setq map (cond((stringp map) (its:get-mode-map map))
		 ((null map) its:*processing-map*)
		 (t map)))
  (its-defrule** 0 input action state map)
  map)

(defvar its:*defrule-verbose* t "nilの場合, its-defrule の警告を抑制する")

(defun its-defrule** (i input action state map)
  (cond((= (length input) i)		;93.6.4 by T.Shingu
	(map-set-state
	 map 
	 (coerce-internal-string 
	  (funcall its:make-terminal-state map input action state)))
	(if (and its:*defrule-verbose* (map-action map))
	    (if action
		(notify "(its-defrule ""%s"" ""%s"" ) を再定義しました．"
			input action)
	      (notify "(its-defrule ""%s"" ""%s"" )を削除しました．"
		      input (map-action map))))
	(if (and (null action) (map-terminalp map)) nil
	  (progn (map-set-action map action)
		 map)))
       (t
	(let((newmap
	      (or (get-next-map-locally map (sref input i))
		  (make-map (funcall its:make-non-terminal-state
				     map
				     (substring input 0 (+ i (char-bytes (sref input i)))))))))
	  (set-next-map map (sref input i) 
			(its-defrule** (+ i (char-bytes (sref input i))) input action state newmap)))
	(if (and (null (map-action map))
		 (map-terminalp map))
	    nil
	  map))))

;;;
;;; map: 
;;;
;;; <map-alist> ::= ( ( <char> . <map> ) ... )
;;; <topmap> ::= ( nil <indicator> <map-alist>  <supers> )
;;; <supers> ::= ( <topmap> .... )
;;; <map>    ::= ( <state> <action>    <map-alist> )
;;; <action> ::= <output> | ( <output> <next> ) ....

(defun make-map (&optional state action alist supers)
  (list state action alist supers))

(defun map-topmap-p (map)
  (null (map-state map)))

(defun map-supers (map)
  (nth 3 map))

(defun map-set-supers (map val)
  (setcar (nthcdr 3 map) val))

(defun map-terminalp (map)
  (null (map-alist map)))

(defun map-state (map)
  (nth 0 map))

(defun map-state-string (map)
  (coerce-string (map-state map)))

(defun map-set-state (map val)
  (setcar (nthcdr 0 map) val))

(defun map-indicator (map)
  (map-action map))
(defun map-set-indicator (map indicator)
  (map-set-action map indicator))

(defun map-action (map)
  (nth 1 map))
(defun map-set-action (map val)
  (setcar (nthcdr 1 map) val))

(defun map-alist (map)
  (nth 2 map))

(defun map-set-alist (map alist)
  (setcar (nthcdr 2 map) alist))

(defun get-action (map)
  (if (null map) nil
    (let ((action (map-action map)))
      (cond((its:standard-actionp action)
	    action)
	   ((symbolp action) (condition-case nil
				 (funcall action)
			       (error nil)))
	   (t (condition-case nil
		  (eval action)
		(error nil)))))))

(defun action-output (action)
  (cond((stringp action) action)
       (t (car action))))

(defun action-next (action)
  (cond((stringp action) nil)
       (t (car (cdr action)))))

(defun get-next-map (map ch)
  (or (cdr (assq ch (map-alist map)))
      (if (map-topmap-p map)
	  (let ((supers (map-supers map))
		(result nil))
	    (while supers
	      (setq result (get-next-map (car supers) ch))
	      (if result
		  (setq supers nil)
		(setq supers (cdr supers))))
	    result))))

(defun get-next-map-locally (map ch)
  (cdr (assq ch (map-alist map))))
  
(defun set-next-map (map ch val)
  (let ((place (assq ch (map-alist map))))
    (if place
	(if val
	    (setcdr place val)
	  (map-set-alist map (delq place (map-alist map))))
      (if val
	  (map-set-alist map (cons (cons ch val)
				   (map-alist map)))
	val))))

(defun its:simple-actionp (action)
  (stringp action))

(defun collect-simple-action (map)
  (if (map-terminalp map)
      (if (its:simple-actionp (map-action map))
	  (list (map-action map))
	nil)
    (let ((alist (map-alist map))
	  (result nil))
      (while alist
	(setq result 
	      ;;; 92.9.19 by Y. Kawabe
	      (append (collect-simple-action (cdr (car alist)))
		      result))
	(setq alist (cdr alist)))
      result)))

;;;----------------------------------------------------------------------
;;;
;;; Runtime translators
;;;
;;;----------------------------------------------------------------------
      
(defun its:simulate-input (i j  input map)
  (while (<= i j)
    (setq map (get-next-map map (sref input i))) ;92.12.26 by S.Tomura
    (setq i (+ i (char-bytes (sref input i)))))	;92.12.26 by S.Tomura
  map)

;;; meta-flag が on の時には、入力コードに \200 を or したものが入力さ
;;; れる。この部分の指摘は東工大の中川 貴之さんによる。
;;; pointted by nakagawa@titisa.is.titech.ac.jp Dec-11-89
;;;
;;; emacs では 文字コードは 0-127 で扱う。
;;;

(defvar its:*buff-s* (make-marker))
(defvar its:*buff-e* (set-marker-type (make-marker) t))

;;;    STATE     unread
;;; |<-s   p->|<-    e ->|
;;; s  : ch0  state0  map0
;;;  +1: ch1  state1  map1
;;; ....
;;; (point):

;;; longest matching region : [s m]
;;; suspending region:        [m point]
;;; unread region          :  [point e]


(defvar its:*maxlevel* 10)
(defvar its:*maps*   (make-vector its:*maxlevel* nil))
(defvar its:*actions* (make-vector its:*maxlevel* nil))
(defvar its:*inputs* (make-vector its:*maxlevel* 0))
(defvar its:*level* 0)

(defun its:resize (size)
  (if (<= its:*maxlevel* size)
      (setq its:*maxlevel* size
	    its:*maps*    (make-vector size nil)
	    its:*actions* (make-vector size nil)
	    its:*inputs*  (make-vector size 0))))

(defun its:reset-maps (&optional init)
  (setq its:*level* 0)
  (if init
      (aset its:*maps* its:*level* init)))

(defun its:current-map () (aref its:*maps* its:*level*))
(defun its:previous-map () (aref its:*maps* (max 0 (1- its:*level*))))

(defun its:level () its:*level*)

(defun its:enter-newlevel (map ch output)
  (setq its:*level* (1+ its:*level*))
  (aset its:*maps* its:*level* map)
  (aset its:*inputs* its:*level* ch)
  (aset its:*actions* its:*level* output))

(defvar its:*char-from-buff* nil)
(defvar its:*interactive* t)

(defun its:reset-input ()
  (setq its:*char-from-buff* nil))

(defun its:flush-input-before-point (from)
  (save-excursion
    (while (<= from its:*level*)
      (its:insert-char (aref its:*inputs* from))
      (setq from (1+ from)))))

(defun its:peek-char ()
  (if (= (point) its:*buff-e*)
      (if its:*interactive*
	  (setq unread-command-char (read-char))
	nil)
    (following-char)))

(defun its:read-char ()
  (if (= (point) its:*buff-e*)
      (progn 
	(setq its:*char-from-buff* nil)
	(if its:*interactive*
	    (read-char)
	  nil))
    (let ((ch (following-char)))
      (setq its:*char-from-buff* t)
      (delete-char 1)
      ch)))

(defun its:push-char (ch)
  (if its:*char-from-buff*
      (save-excursion
	(its:insert-char ch))
    (if ch (setq unread-command-char ch))))

(defun its:insert-char (ch)
  (insert ch))

(defun its:ordinal-charp (ch)
  (and (numberp ch) (<= ch 127)
       (eq (aref fence-mode-map ch) 'fence-self-insert-command)))

(defun its:delete-charp (ch)
  (and (numberp ch) (<= ch 127)
       (eq (aref fence-mode-map ch) 'fence-backward-delete-char)))
    
(defun fence-self-insert-command ()
  (interactive)
  (cond((or (not egg:*input-mode*)
	    (null (get-next-map its:*current-map* last-command-char)))
	(insert last-command-char))
       (t
	(insert last-command-char)
	(its:translate-region (1- (point)) (point) t))))

;;;
;;; its: completing-read system
;;;

(defun its:all-completions (string alist &optional pred)
  "A variation of all-completions.\n\
Arguments are STRING, ALIST and optional PRED. ALIST must be no obarray."
  (let ((tail alist) (allmatches nil))
    (while tail
      (let* ((elt (car tail))
	     (eltstring (car elt)))
	(setq tail (cdr tail))
	(if (and (stringp eltstring)
		 (<= (length string) (length eltstring))
		 ;;;(not (= (aref eltstring 0) ? ))
		 (string-equal string (substring eltstring 0 (length string))))
	    (if (or (and pred
			 (if (if (eq pred 'commandp)
				 (commandp elt)
			       (funcall pred elt))))
		    (null pred))
		(setq allmatches (cons elt allmatches))))))
    (nreverse allmatches)))

(defun its:temp-echo-area-contents (message)
  (let ((inhibit-quit inhibit-quit)
	(point-max (point-max)))
    (goto-char point-max)
    (insert message)
    (goto-char point-max)
    (setq inhibit-quit t)
    (sit-for 2 nil)
    ;;; 92.9.19 by Y. Kawabe, 92.10.30 by T.Saneto
    (delete-region (point) (point-max))
    (if quit-flag
	(progn
	  (setq quit-flag nil)
	  (setq unread-command-char ?\^G)))))

(defun car-string-lessp (item1 item2)
  (string-lessp (car item1) (car item2)))

(defun its:minibuffer-completion-help ()
    "Display a list of possible completions of the current minibuffer contents."
    (interactive)
    (let ((completions))
      (message "Making completion list...")
      (setq completions (its:all-completions (buffer-string)
					 minibuffer-completion-table
					 minibuffer-completion-predicate))
      (if (null completions)
	  (progn
	    ;;; 92.9.19 by Y. Kawabe
	    (beep)
	    (its:temp-echo-area-contents " [No completions]"))
	(with-output-to-temp-buffer " *Completions*"
	  (display-completion-list
	   (sort completions 'car-string-lessp))))
      nil))

(defconst its:minibuffer-local-completion-map 
  (copy-keymap minibuffer-local-completion-map))
(define-key its:minibuffer-local-completion-map "?" 'its:minibuffer-completion-help)
(define-key its:minibuffer-local-completion-map " " 'its:minibuffer-completion-help)

(defconst its:minibuffer-local-must-match-map
  (copy-keymap minibuffer-local-must-match-map))
(define-key its:minibuffer-local-must-match-map "?" 'its:minibuffer-completion-help)
(define-key its:minibuffer-local-must-match-map " " 'its:minibuffer-completion-help)

(fset 'si:all-completions (symbol-function 'all-completions))
(fset 'si:minibuffer-completion-help (symbol-function 'minibuffer-completion-help))

(defun its:completing-read (prompt table &optional predicate require-match initial-input)
  "See completing-read"
  (let ((minibuffer-local-completion-map its:minibuffer-local-completion-map)
	(minibuffer-local-must-match-map its:minibuffer-local-must-match-map)
	(completion-auto-help nil))
    (completing-read prompt table predicate t initial-input)))

(defvar its:*completing-input-menu* '(menu "Which?" nil)) ;92.10.26 by T.Saneto

(defun its:completing-input (map)
  ;;; 
  (let ((action (get-action map)))
    (cond((and (null action)
	       (= (length (map-alist map)) 1))
	  (its:completing-input (cdr (nth 0 (map-alist map)))))
	 (t
	  (setcar (nthcdr 2 its:*completing-input-menu*)
		  (map-alist map))
	  (let ((values
		 (menu:select-from-menu its:*completing-input-menu*
					0 t)))
	    (cond((consp values)
		  ;;; get input char from menu
		  )
		 (t
		  (its:completing-input map))))))))

(defvar its:*make-menu-from-map-result* nil)

(defun its:make-menu-from-map (map)
  (let ((its:*make-menu-from-map-result* nil))
    (its:make-menu-from-map* map "")
    (list 'menu "Which?"  (reverse its:*make-menu-from-map-result*) )))

(defun its:make-menu-from-map* (map string)
  (let ((action (get-action map)))
    (if action
	(setq its:*make-menu-from-map-result*
	      (cons (format "%s[%s]" string (action-output action))
		    its:*make-menu-from-map-result*)))
    (let ((alist (map-alist map)))
      (while alist
	(its:make-menu-from-map* 
	 (cdr (car alist))
	 (concat string (char-to-string (car (car alist)))))
	(setq alist (cdr alist))))))

(defvar its:*make-alist-from-map-result* nil)

(defun its:make-alist-from-map (map &optional string)
  (let ((its:*make-alist-from-map-result* nil))
    (its:make-alist-from-map* map (or string ""))
    (reverse its:*make-alist-from-map-result*)))

(defun its:make-alist-from-map* (map string)
  (let ((action (get-action map)))
    (if action
	(setq its:*make-alist-from-map-result*
	      (cons (list string 
			  (let ((action-output (action-output action)))
			    (cond((and (consp action-output)
				       (numberp (car action-output)))
				  (format "%s..."
				  (nth (car action-output) (cdr action-output))))
				 ((stringp action-output)
				  action-output)
				 (t
				  (format "%s" action-output)))))
		    its:*make-alist-from-map-result*)))
    (let ((alist (map-alist map)))
      (while alist
	(its:make-alist-from-map* 
	 (cdr (car alist))
	 (concat string (char-to-string (car (car alist)))))
	(setq alist (cdr alist))))))

(defvar its:*select-alternative-output-menu* '(menu "Which?" nil))

(defun its:select-alternative-output (action-output)
  ;;;; action-output : (pos item1 item2 item3 ....)
  (let ((point (point))
	(output (cdr action-output))
	(ch 0))
    (while (not (= ch ?\^L))
      (insert "<" (nth (car action-output)output) ">")
      (setq ch (read-char))
      (cond ((= ch ?\^N)
	     (setcar action-output
		     (mod (1+ (car action-output)) (length output))))
	    ((= ch ?\^P)
	     (setcar action-output
		     (if (= 0 (car action-output))
			 (1- (length output))
		       (1- (car action-output)))))
	    ((= ch ?\^M)
	     (setcar (nthcdr 2 its:*select-alternative-output-menu* )
		     output)
	     (let ((values 
		    (menu:select-from-menu its:*select-alternative-output-menu*
					   (car action-output)
					   t)))
	       (cond((consp values)
		     (setcar action-output (nth 1 values))
		     (setq ch ?\^L)))))
	    ((= ch ?\^L)
	     )
	    (t
	     (beep)
	     ))
      (delete-region point (point)))
    (if its:*insert-output-string*
	(funcall its:*insert-output-string* (nth (car action-output) output))
      (insert (nth (car action-output) output)))))
      
    

;;; translate until 
;;;      interactive --> not ordinal-charp
;;; or
;;;      not interactive  --> end of input

(defvar its:*insert-output-string* nil)
(defvar its:*display-status-string* nil)

(defun its:translate-region (start end its:*interactive* &optional topmap)
  (set-marker its:*buff-s* start)
  (set-marker its:*buff-e* end)
  (its:reset-input)
  (goto-char its:*buff-s*)
  (let ((topmap (or topmap its:*current-map*))
	(map nil)
	(ch nil)
	(action nil)
	(newmap nil)
	(inhibit-quit t)
	(its-quit-flag nil)
	(echo-keystrokes 0))
    (setq map topmap)
    (its:reset-maps topmap)
    (while (not its-quit-flag)
      (setq ch (its:read-char))
      (setq newmap (get-next-map map ch))
      (setq action (get-action newmap))

      (cond
       ((and its:*interactive* (not its:*char-from-buff*) (= ch ?\^@))
	(delete-region its:*buff-s* (point))
	(let ((i 1))
	  (while (<= i its:*level*)
	    (insert (aref its:*inputs* i))
	    (setq i (1+ i))))
	(let ((inputs (its:completing-read "ITS:>" 
					   (its:make-alist-from-map topmap)
					   nil
					   t
					   (buffer-substring its:*buff-s* (point)))))
	  (delete-region its:*buff-s* (point))
	  (save-excursion (insert inputs))
	  (its:reset-maps)
	  (setq map topmap)
	  ))
       ((or (null newmap)
	    (and (map-terminalp newmap)
		 (null action)))

	(cond((and its:*interactive* (its:delete-charp ch))
	      (delete-region its:*buff-s* (point))
	      (cond((= its:*level* 0)
		    (setq its-quit-flag t))
		   ((= its:*level* 1)
		    (its:insert-char (aref its:*inputs* 1))
		    (setq its-quit-flag t))
		   (t
		    (its:flush-input-before-point (1+ its:*level*))
		    (setq its:*level* (1- its:*level*))
		    (setq map (its:current-map))
		    (if (and its:*interactive*
			     its:*display-status-string*)
			(funcall its:*display-status-string* (map-state map))
		      (insert (map-state map)))
		    )))

	     (t
	      (let ((output nil))
		(let ((i its:*level*) (newlevel (1+ its:*level*)))
		  (aset its:*inputs* newlevel ch)
		  (while (and (< 0 i) (null output))
		    (if (and (aref its:*actions* i)
			     (its:simulate-input (1+ i) newlevel its:*inputs* topmap))
			(setq output i))
		    (setq i (1- i)))
		  (if (null output)
		      (let ((i its:*level*))
			(while (and (< 0 i) (null output))
			  (if (aref its:*actions* i)
			      (setq output i))
			  (setq i (1- i)))))

		  (cond(output 
			(delete-region its:*buff-s* (point))
			(cond((its:standard-actionp (aref its:*actions* output))
			      (let ((action-output (action-output (aref its:*actions* output))))
				(if (and (not its:*interactive*)
					 (consp action-output))
				    (setq action-output (nth (car action-output) (cdr action-output))))
				(cond((stringp action-output)
				      (if (and its:*interactive* 
					       its:*insert-output-string*)
					  (funcall its:*insert-output-string* action-output)
					(insert action-output)))
				     ((consp action-output)
				      (its:select-alternative-output action-output)
				      )
				     (t
				      (beep) (beep)
				      )))
			      (set-marker its:*buff-s* (point))
			      (its:push-char ch)
			      (its:flush-input-before-point (1+ output))
			      (if (action-next (aref its:*actions* output))
				  (save-excursion
				    (insert (action-next (aref its:*actions* output)))))
			      )
			     ((symbolp (aref its:*actions* output))
			      (its:push-char ch)
			      (funcall (aref its:*actions* output))
			      (its:reset-maps its:*current-map*)
			      (setq topmap its:*current-map*)
			      (set-marker its:*buff-s* (point)))
			     (t 
			      (its:push-char ch)
					;92.10.26 by T.Saneto
			      (eval (aref its:*actions* output))
			      (its:reset-maps its:*current-map*)
			      (setq topmap its:*current-map*)
			      (set-marker its:*buff-s* (point))
			      ))
			)
		       ((= 0 its:*level*)
			(cond ((or (its:ordinal-charp ch)
				   its:*char-from-buff*)
			       (its:insert-char ch))
			      (t (setq its-quit-flag t))))

		       ((< 0 its:*level*)
			(delete-region its:*buff-s* (point))
			(its:insert-char (aref its:*inputs* 1))
			(set-marker its:*buff-s* (point))
			(its:push-char ch)
			(its:flush-input-before-point 2)))))
		    
	      (cond((null ch)
		    (setq its-quit-flag t))
		   ((not its-quit-flag)
		    (its:reset-maps)
		    (set-marker its:*buff-s* (point))
		    (setq map topmap))))))
	       
       ((map-terminalp newmap)
	(its:enter-newlevel (setq map newmap) ch action)
	(delete-region its:*buff-s* (point))
	(let ((output nil) (m nil) (i (1- its:*level*)))
	  (while (and (< 0 i) (null output))
	    (if (and (aref its:*actions* i)
		     (setq m (its:simulate-input (1+ i) its:*level* its:*inputs* topmap))
		     (not (map-terminalp m)))
		(setq output i))
	    (setq i (1- i)))

	  (cond((null output)
		(cond ((its:standard-actionp action)
		       (let ((action-output (action-output action)))
			 (if (and (not its:*interactive*)
				  (consp action-output))
			     (setq action-output (nth (car action-output) (cdr action-output))))
			 (cond((stringp action-output)
			       (if (and its:*interactive* 
					its:*insert-output-string*)
				   (funcall its:*insert-output-string* action-output)
				 (insert action-output)))
			      ((consp action-output)
			       (its:select-alternative-output action-output)
			       )
			      (t
			       (beep) (beep)
			       )))
		       (cond((null (action-next action))
			     (cond ((and (= (point) its:*buff-e*)
					 its:*interactive*
					 (its:delete-charp (its:peek-char)))
				    nil)
				   (t
				    (set-marker its:*buff-s* (point))
				    (its:reset-maps)
				    (setq map topmap)
				    )))
			    (t
			     (save-excursion (insert (action-next action)))
			     (set-marker its:*buff-s* (point))
			     (its:reset-maps)
			     (setq map topmap))))
		      ((symbolp action)
		       (funcall action)
		       (its:reset-maps its:*current-map*)
		       (setq topmap its:*current-map*)
		       (setq map topmap)
		       (set-marker its:*buff-s* (point)))
		      (t 
		       (eval action)
		       (its:reset-maps its:*current-map*)
		       (setq topmap its:*current-map*)
		       (setq map topmap)
		       (set-marker its:*buff-s* (point)))))
	       (t
		(if (and its:*interactive* 
			 its:*display-status-string*)
		    (funcall its:*display-status-string* (map-state map))
		  (insert (map-state map)))))))

       ((null action)
	(delete-region its:*buff-s* (point))
	(if (and its:*interactive* 
		 its:*display-status-string*)
	    (funcall its:*display-status-string* (map-state newmap))
	  (insert (map-state newmap)))
	(its:enter-newlevel (setq map newmap)
			    ch action))

       (t
	(its:enter-newlevel (setq map newmap) ch action)
	(delete-region its:*buff-s* (point))
	(if (and its:*interactive* 
		 its:*display-status-string*)
	    (funcall its:*display-status-string* (map-state map))
	  (insert (map-state map))))))

    (set-marker its:*buff-s* nil)
    (set-marker its:*buff-e* nil)
    (if (and its:*interactive* ch) (setq unread-command-char ch))
    ))

;;;----------------------------------------------------------------------
;;; 
;;; ITS-map dump routine:
;;;
;;;----------------------------------------------------------------------

;;;;;
;;;;; User entry: dump-its-mode-map
;;;;;

;; 92.6.26 by K.Handa
(defun dump-its-mode-map (name filename)
  "Obsolete."
  (interactive)
  (message "This function is obsolete in the current version of Mule."))
;;;
;;; EGG mode variables
;;;

(defvar egg:*mode-on* nil "T if egg mode is on.")
(make-variable-buffer-local 'egg:*mode-on*)
(set-default 'egg:*mode-on* nil)

(defvar egg:*input-mode* t "T if egg map is active.")
(make-variable-buffer-local 'egg:*input-mode*)
(set-default 'egg:*input-mode* t)

(defvar egg:*in-fence-mode* nil "T if in fence mode.")
(make-variable-buffer-local 'egg:*in-fence-mode*)
(set-default 'egg:*in-fence-mode* nil)

;;(load-library "its-dump/roma-kana")         ;;;(define-its-mode "roma-kana"        " aあ")
;;(load-library "its-dump/roma-kata")         ;;;(define-its-mode "roma-kata"        " aア")
;;(load-library "its-dump/downcase")          ;;;(define-its-mode "downcase"         " a a")
;;(load-library "its-dump/upcase")            ;;;(define-its-mode "upcase"           " a A")
;;(load-library "its-dump/zenkaku-downcase")  ;;;(define-its-mode "zenkaku-downcase" " aａ")
;;(load-library "its-dump/zenkaku-upcase")    ;;;(define-its-mode "zenkaku-upcase"   " aＡ")
;; 92.3.13 by K.Handa
;; (load "its-hira")
;; (load-library "its-kata")
;; (load-library "its-hankaku")
;; (load-library "its-zenkaku")


(defvar its:*current-map* nil)
(make-variable-buffer-local 'its:*current-map*)
;; 92.3.13 by K.Handa
;; moved to each language specific setup files (japanese.el, ...)
;; (setq-default its:*current-map* (its:get-mode-map "roma-kana"))

(defvar its:*previous-map* nil)
(make-variable-buffer-local 'its:*previous-map*)
(setq-default its:*previous-map* nil)

;;;----------------------------------------------------------------------
;;;
;;; Mode line control functions;
;;;
;;;----------------------------------------------------------------------

(defconst mode-line-egg-mode "--")
(make-variable-buffer-local 'mode-line-egg-mode)

(defvar   mode-line-egg-mode-in-minibuffer "--" "global variable")

(defun egg:find-symbol-in-tree (item tree)
  (if (consp tree)
      (or (egg:find-symbol-in-tree item (car tree))
	  (egg:find-symbol-in-tree item (cdr tree)))
    (equal item tree)))

;;;
;;; nemacs Ver. 3.0 では Fselect_window が変更になり、minibuffer-window
;;; 他の window との間で出入りがあると、mode-line の更新を行ない、変数 
;;; minibuffer-window-selected の値が更新される
;;;

;;; nemacs Ver. 4 では Fselect_window が変更になり，select-window-hook 
;;; が定義された．これにともない従来，再定義していた select-window,
;;; other-window, keyborad-quit, abort-recursive-edit, exit-minibuffer 
;;; を削除した．

(defconst display-minibuffer-mode-in-minibuffer t)

(defvar minibuffer-window-selected nil)

(defun egg:select-window-hook (old new)
  (cond((eq old (minibuffer-window))
	(save-excursion
	  (set-buffer (window-buffer (minibuffer-window)))
	  (setq minibuffer-preprompt nil
		egg:*mode-on* (default-value 'egg:*mode-on*)
		egg:*input-mode* (default-value 'egg:*input-mode*)
		egg:*in-fence-mode* (default-value 'egg:*in-fence-mode*)))))
  (if (eq new (minibuffer-window))
      (setq minibuffer-window-selected t)
    (setq minibuffer-window-selected nil)))

(setq select-window-hook 'egg:select-window-hook)

;;;
;;;
;;;

(defvar its:*reset-mode-line-format* nil)

(if its:*reset-mode-line-format*
    (setq-default mode-line-format
		  (cdr mode-line-format)))

(if (not (egg:find-symbol-in-tree 'mode-line-egg-mode mode-line-format))
    (setq-default 
     mode-line-format
     (cons (list 'mc-flag
		 (list 'display-minibuffer-mode-in-minibuffer
		       ;;; minibuffer mode in minibuffer
		       (list 
			(list 'its:*previous-map* "<" "[")
			'mode-line-egg-mode
			(list 'its:*previous-map* ">" "]")
			)
		       ;;;; minibuffer mode in mode line
		       (list 
			(list 'minibuffer-window-selected
			      (list 'display-minibuffer-mode
				    "m"
				    " ")
			      " ")
			(list 'its:*previous-map* "<" "[")
			(list 'minibuffer-window-selected
			      (list 'display-minibuffer-mode
				    'mode-line-egg-mode-in-minibuffer
				    'mode-line-egg-mode)
			      'mode-line-egg-mode)
			(list 'its:*previous-map* ">" "]")
			)))
	   mode-line-format)))

;;;
;;; minibuffer でのモード表示をするために nemacs 4 で定義された 
;;; minibuffer-preprompt を利用する．
;;;

(defconst egg:minibuffer-preprompt '("[" nil "]"))

(defun mode-line-egg-mode-update (str)
  (if (eq (current-buffer) (window-buffer (minibuffer-window)))
      (if display-minibuffer-mode-in-minibuffer
	  (progn
	    (aset (nth 0 egg:minibuffer-preprompt) 0
		  (if its:*previous-map* ?\< ?\[))
	    (setcar (nthcdr 1 egg:minibuffer-preprompt)
		    str)
	    (aset (nth 2 egg:minibuffer-preprompt) 0
		  (if its:*previous-map* ?\> ?\]))
	    (setq minibuffer-preprompt
		  egg:minibuffer-preprompt))
	(setq display-minibuffer-mode t
	      mode-line-egg-mode-in-minibuffer str))
    (setq display-minibuffer-mode nil
	  mode-line-egg-mode str))
  ;;; nemacs 4 only(update-mode-lines)
  (set-buffer-modified-p (buffer-modified-p))
)

(mode-line-egg-mode-update mode-line-egg-mode)

;;;
;;; egg mode line display
;;;

(defvar alphabet-mode-indicator "aA")
(defvar transparent-mode-indicator "--")

(defun egg:mode-line-display ()
  (mode-line-egg-mode-update 
   (cond((and egg:*in-fence-mode* (not egg:*input-mode*))
	 alphabet-mode-indicator)
	((and egg:*mode-on* egg:*input-mode*)
	 (map-indicator its:*current-map*))
	(t transparent-mode-indicator))))

(defun egg:toggle-egg-mode-on-off ()
  (interactive)
  (setq egg:*mode-on* (not egg:*mode-on*))
  (egg:mode-line-display))

(defun its:select-mode (name)
  (interactive (list (completing-read "ITS mode: " its:*mode-alist*)))
  (if (its:get-mode-map name)
      (progn
	(setq its:*current-map* (its:get-mode-map name))
	(egg:mode-line-display))
    (beep))
  )

(defvar its:*select-mode-menu* '(menu "Mode:" nil))

(defun its:select-mode-from-menu ()
  (interactive)
  (setcar (nthcdr 2 its:*select-mode-menu*) its:*mode-alist*)
  (setq its:*current-map* (menu:select-from-menu its:*select-mode-menu*))
  (egg:mode-line-display))

(defvar its:*standard-modes* nil
  "List of standard mode-map of EGG."
  ;; 92.3.13 by K.Handa
  ;; moved to each language specific setup files (japanese.el, ...)
  ;; (list (its:get-mode-map "roma-kana")
  ;;  (its:get-mode-map "roma-kata")
  ;;  (its:get-mode-map "downcase")
  ;;  (its:get-mode-map "upcase")
  ;;  (its:get-mode-map "zenkaku-downcase")
  ;;  (its:get-mode-map "zenkaku-upcase"))
  )

(defun its:find (map list)
  (let ((n 0))
    (while (and list (not (eq map (car list))))
      (setq list (cdr list)
	    n    (1+ n)))
    (if list n nil)))

(defun its:next-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (% (1+ pos) (length its:*standard-modes*))
	       its:*standard-modes*))
    (egg:mode-line-display)))

(defun its:previous-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (1- (if (= pos 0) (length its:*standard-modes*) pos))
	       its:*standard-modes*))
    (egg:mode-line-display)))

(defun its:select-hiragana () (interactive) (its:select-mode "roma-kana"))
(defun its:select-katakana () (interactive) (its:select-mode "roma-kata"))
(defun its:select-downcase () (interactive) (its:select-mode "downcase"))
(defun its:select-upcase   () (interactive) (its:select-mode "upcase"))
(defun its:select-zenkaku-downcase () (interactive) (its:select-mode "zenkaku-downcase"))
(defun its:select-zenkaku-upcase   () (interactive) (its:select-mode "zenkaku-upcase"))

(defun its:select-mode-temporally (name)
  (interactive (list (completing-read "ITS mode: " its:*mode-alist*)))
  (let ((map (its:get-mode-map name)))
    (if map
	(progn
	  (if (null its:*previous-map*)
	      (setq its:*previous-map* its:*current-map*))
	  (setq its:*current-map*  map)
	  (egg:mode-line-display))
      (beep))))

(defun its:select-previous-mode ()
  (interactive)
  (if (null its:*previous-map*)
      (beep)
    (setq its:*current-map* its:*previous-map*
	  its:*previous-map* nil)
    (egg:mode-line-display)))
	  

(defun toggle-egg-mode ()
  (interactive)
  (if mc-flag 
      (if egg:*mode-on* (fence-toggle-egg-mode)
	(progn
	  (setq egg:*mode-on* t)
	  (egg:mode-line-display)))))

(defun fence-toggle-egg-mode ()
  (interactive)
  (if its:*current-map*
      (progn
	(setq egg:*input-mode* (not egg:*input-mode*))
	(egg:mode-line-display))
    (beep)))

;;;
;;; Changes on Global map 
;;;

(defvar si:*global-map* (copy-keymap global-map))

(let ((ch 32))
  (while (< ch 127)
    (aset global-map ch 'egg-self-insert-command)
    (setq ch (1+ ch))))

;;;
;;; Currently entries C-\ and C-^ at global-map are undefined.
;;;

(define-key global-map "\C-\\" 'toggle-egg-mode)
(define-key global-map "\C-x " 'henkan-region)

;; 92.3.16 by K.Handa
;; global-map => mule-keymap
(define-key mule-keymap "m" 'its:select-mode-from-menu)
(define-key mule-keymap ">" 'its:next-mode)
(define-key mule-keymap "<" 'its:previous-mode)
(define-key mule-keymap "h" 'its:select-hiragana)
(define-key mule-keymap "k" 'its:select-katakana)
(define-key mule-keymap "q" 'its:select-downcase)
(define-key mule-keymap "Q" 'its:select-upcase)
(define-key mule-keymap "z" 'its:select-zenkaku-downcase)
(define-key mule-keymap "Z" 'its:select-zenkaku-upcase)

;;;
;;; auto fill controll
;;;

(defun egg:do-auto-fill ()
  (if (and auto-fill-hook (not buffer-read-only)
	   (> (current-column) fill-column))
      (let ((ocolumn (current-column)))
	(run-hooks 'auto-fill-hook)
	(while (and (< fill-column (current-column))
		    (< (current-column) ocolumn))
  	  (setq ocolumn (current-column))
	  (run-hooks 'auto-fill-hook)))))

;;;----------------------------------------------------------------------
;;;
;;;  Egg fence mode
;;;
;;;----------------------------------------------------------------------

(defconst egg:*fence-open*   "|" "*フェンスの始点を示す文字列")
(defconst egg:*fence-close*  "|" "*フェンスの終点を示す文字列")
(defconst egg:*fence-attribute* nil  "*フェンス表示に用いるattribute または nil")

(defvar egg:*attribute-alist*
  '(("nil" . nil)
    ("inverse" . inverse) ("underline" . underline) ("bold" . bold)))

(defun set-egg-fence-mode-format (open close &optional attr)
  "fence mode の表示方法を設定する。OPEN はフェンスの始点を示す文字列または nil。\n\
CLOSEはフェンスの終点を示す文字列または nil。\n\
optional ATTR はフェンス区間を表示する属性 または nil（x11term のみで有効）"
  (interactive (list (read-string "フェンス開始文字列: ")
		     (read-string "フェンス終了文字列: ")
		     (cdr (assoc (completing-read "フェンス表示属性: " egg:*attribute-alist*)
				 egg:*attribute-alist*))))

  (if (and (or (stringp open) (null open))
	   (or (stringp close) (null close))
	   (egg:member attr '(underline inverse bold nil)))
      (progn
	(setq egg:*fence-open* (or open "")
	      egg:*fence-close* (or close "")
	      egg:*fence-attribute* attr)
	(if attr (require 'attribute))
	t)
    (error "Wrong type of argument: %s %s %s" open close attr)))

(defconst egg:*region-start* (make-marker))
(defconst egg:*region-end*   (set-marker-type (make-marker) t))
(defvar egg:*global-map-backup* nil)
(defvar egg:*local-map-backup*  nil)


;;;
;;; (defvar disable-undo nil "*Compatibility for Nemacs")
;;;
;;; Moved to kanji.el
;;; (defvar self-insert-after-hook nil
;;;  "Hook to run when extended self insertion command exits. Should take
;;; two arguments START and END correspoding to character position.")

(defvar egg:*self-insert-non-undo-count* 0
  "counter to hold repetition of egg-self-insert-command.")

(defun egg-self-insert-command (arg)
  (interactive "p")
  (if (and (not buffer-read-only)
	   mc-flag
	   egg:*mode-on* egg:*input-mode* 
	   (not egg:*in-fence-mode*) ;;; inhibit recursive fence mode
	   (not (= last-command-char  ?  )))
      (egg:enter-fence-mode-and-self-insert)
    (progn
      ;; treat continuous 20 self insert as a single undo chunk.
      ;; `20' is a magic number copied from keyboard.c
      (if (or				;92.12.20 by T.Enami
	   (not (eq last-command 'egg-self-insert-command))
	   (>= egg:*self-insert-non-undo-count* 20))
	  (setq egg:*self-insert-non-undo-count* 1)
	(cancel-undo-boundary)
	(setq egg:*self-insert-non-undo-count*
	      (1+ egg:*self-insert-non-undo-count*)))
      (self-insert-command arg)
      (if egg-insert-after-hook
	  (run-hooks 'egg-insert-after-hook))
      (if self-insert-after-hook
	  (if (<= 1 arg)
	      (funcall self-insert-after-hook
		       (- (point) arg) (point)))
	(if (= last-command-char ? ) (egg:do-auto-fill))))))


(defun egg:enter-fence-mode-and-self-insert () 
  (enter-fence-mode)
  (setq unread-command-char last-command-char))

(defun egg:fence-attribute-on ()
  (egg:set-region-attribute egg:*fence-attribute* t))

(defun egg:fence-attribute-off ()
  (egg:set-region-attribute egg:*fence-attribute* nil))

(defun enter-fence-mode ()
  (if overwrite-mode
      (save-excursion
	(let ((p (point)))
	  (end-of-line)
	  (setq egg:*overwrite-mode-previous-string*
		(buffer-substring p (point))))))
  ;;;(buffer-flush-undo (current-buffer))
  (and (boundp 'disable-undo) (setq disable-undo t))
  (setq egg:*in-fence-mode* t)
  (egg:mode-line-display)
  ;;;(setq egg:*global-map-backup* (current-global-map))
  (setq egg:*local-map-backup*  (current-local-map))
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map nil)
  (use-local-map fence-mode-map)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (insert egg:*fence-close*)
  (set-marker egg:*region-end* egg:*region-start*)
  (egg:fence-attribute-on)
  (goto-char egg:*region-start*)
  )

(defun henkan-fence-region-or-single-space ()
  (interactive)
  (if egg:*input-mode*   
      (henkan-fence-region)
    (insert ? )))

(defvar egg:*henkan-fence-mode* nil)

(defun henkan-fence-region ()
  (interactive)
  (setq egg:*henkan-fence-mode* t)
  (henkan-region-internal egg:*region-start* egg:*region-end* ))

(defun fence-katakana  ()
  (interactive)
  (katakana-region egg:*region-start* egg:*region-end* ))

(defun fence-hiragana  ()
  (interactive)
  (hiragana-region egg:*region-start* egg:*region-end*))

(defun fence-hankaku  ()
  (interactive)
  (hankaku-region egg:*region-start* egg:*region-end*))

(defun fence-zenkaku  ()
  (interactive)
  (zenkaku-region egg:*region-start* egg:*region-end*))

(defun fence-backward-char ()
  (interactive)
  (if (< egg:*region-start* (point))
      (backward-char)
    (beep)))

(defun fence-forward-char ()
  (interactive)
  (if (< (point) egg:*region-end*)
      (forward-char)
    (beep)))

(defun fence-beginning-of-line ()
  (interactive)
  (goto-char egg:*region-start*))

(defun fence-end-of-line ()
  (interactive)
  (goto-char egg:*region-end*))

(defun fence-transpose-chars (arg)
  (interactive "P")
  (if (and (< egg:*region-start* (point))
	   (< (point) egg:*region-end*))
      (transpose-chars arg)
    (beep)))

(defun egg:exit-if-empty-region ()
  (if (= egg:*region-start* egg:*region-end*)
      (fence-exit-mode)))

(defun fence-delete-char ()
  (interactive)
  (if (< (point) egg:*region-end*)
      (progn
	(delete-char 1)
	(egg:exit-if-empty-region))
    (beep)))

(defun fence-backward-delete-char ()
  (interactive)
  (if (< egg:*region-start* (point))
      (progn
	(delete-char -1)
	(egg:exit-if-empty-region))
    (beep)))

(defun fence-kill-line ()
  (interactive)
  (delete-region (point) egg:*region-end*)
  (egg:exit-if-empty-region))

(defun fence-exit-mode ()
  (interactive)
  (delete-region (- egg:*region-start* (length egg:*fence-open*)) egg:*region-start*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*fence-close*)))
  (egg:fence-attribute-off)
  (if its:*previous-map*
      (setq its:*current-map* its:*previous-map*
	    its:*previous-map* nil))
  (egg:quit-egg-mode))

(defvar egg-insert-after-hook nil)
(make-variable-buffer-local 'egg-insert-after-hook)

(defvar egg-exit-hook nil
  "Hook to run when egg exits. Should take two arguments START and END
correspoding to character position.")

(defun egg:quit-egg-mode ()
  ;;;(use-global-map egg:*global-map-backup*)
  (use-local-map egg:*local-map-backup*)
  (setq egg:*in-fence-mode* nil)
  (egg:mode-line-display)
  (if overwrite-mode
      (let ((str (buffer-substring egg:*region-end* egg:*region-start*)))
	(delete-text-in-column nil (+ (current-column) (string-width str)))))
  (setq egg:*henkan-fence-mode* nil)
  (if self-insert-after-hook
      (funcall self-insert-after-hook egg:*region-start* egg:*region-end*)
    (if egg-exit-hook
	(funcall egg-exit-hook egg:*region-start* egg:*region-end*)
      (if (not (= egg:*region-start* egg:*region-end*))
	  (egg:do-auto-fill))))
  (set-marker egg:*region-start* nil)
  (set-marker egg:*region-end*   nil)
  ;;;(buffer-enable-undo)
  ;;;(undo-boundary)
  (and (boundp 'disable-undo) (setq disable-undo nil))
  (if egg-insert-after-hook
      (run-hooks 'egg-insert-after-hook))
  )

(defun fence-cancel-input ()
  (interactive)
  (delete-region egg:*region-start* egg:*region-end*)
  (fence-exit-mode))

(defvar fence-mode-map (make-keymap))

(defvar fence-mode-esc-map (make-keymap))

(let ((ch 0))
  (while (<= ch 127)
    (aset fence-mode-map ch 'undefined)
    (aset fence-mode-esc-map ch 'undefined)
    (setq ch (1+ ch))))

(let ((ch 32))
  (while (< ch 127)
    (aset fence-mode-map ch 'fence-self-insert-command)
    (setq ch (1+ ch))))

(define-key fence-mode-map "\e"   fence-mode-esc-map)
(define-key fence-mode-map "\eh"  'fence-hiragana)
(define-key fence-mode-map "\ek"  'fence-katakana)
(define-key fence-mode-map "\e<"  'fence-hankaku)
(define-key fence-mode-map "\e>"  'fence-zenkaku)
(define-key fence-mode-map "\e\C-h" 'its:select-hiragana)
(define-key fence-mode-map "\e\C-k" 'its:select-katakana)
(define-key fence-mode-map "\eq"    'its:select-downcase)
(define-key fence-mode-map "\eQ"    'its:select-upcase)
(define-key fence-mode-map "\ez"    'its:select-zenkaku-downcase)
(define-key fence-mode-map "\eZ"    'its:select-zenkaku-upcase)
(define-key fence-mode-map " "    'henkan-fence-region-or-single-space)
(define-key fence-mode-map "\C-@" 'henkan-fence-region)
(define-key fence-mode-map "\C-a" 'fence-beginning-of-line)
(define-key fence-mode-map "\C-b" 'fence-backward-char)
(define-key fence-mode-map "\C-c" 'fence-cancel-input)
(define-key fence-mode-map "\C-d" 'fence-delete-char)
(define-key fence-mode-map "\C-e" 'fence-end-of-line)
(define-key fence-mode-map "\C-f" 'fence-forward-char)
(define-key fence-mode-map "\C-g" 'fence-cancel-input)
(define-key fence-mode-map "\C-h" 'help-command)
(define-key fence-mode-map "\C-i" 'undefined)  
(define-key fence-mode-map "\C-j" 'undefined)  ;;; LFD
(define-key fence-mode-map "\C-k" 'fence-kill-line)
(define-key fence-mode-map "\C-l" 'fence-exit-mode)
(define-key fence-mode-map "\C-m" 'fence-exit-mode)  ;;; RET
(define-key fence-mode-map "\C-n" 'undefined)
(define-key fence-mode-map "\C-o" 'undefined)
(define-key fence-mode-map "\C-p" 'undefined)
(define-key fence-mode-map "\C-q" 'its:select-previous-mode)
(define-key fence-mode-map "\C-r" 'undefined)
(define-key fence-mode-map "\C-s" 'undefined)
(define-key fence-mode-map "\C-t" 'fence-transpose-chars)
(define-key fence-mode-map "\C-u" 'undefined)
(define-key fence-mode-map "\C-v" 'undefined)
(define-key fence-mode-map "\C-w" 'henkan-fence-region)
(define-key fence-mode-map "\C-x" 'undefined)
(define-key fence-mode-map "\C-y" 'undefined)
(define-key fence-mode-map "\C-z" 'eval-expression)
(define-key fence-mode-map "\C-|" 'fence-toggle-egg-mode)
(define-key fence-mode-map "\C-_" 'jis-code-input)
(define-key fence-mode-map "\177" 'fence-backward-delete-char)

;;;----------------------------------------------------------------------
;;;
;;; Read hiragana from minibuffer
;;;
;;;----------------------------------------------------------------------

(defvar egg:*minibuffer-local-hiragana-map* (copy-keymap minibuffer-local-map))

(let ((ch 32))
  (while (< ch 127)
    (define-key egg:*minibuffer-local-hiragana-map*
      (make-string 1 ch) 'fence-self-insert-command)
    (setq ch (1+ ch))))

(defun read-hiragana-string (prompt &optional initial-input)
  (save-excursion
    (let ((minibuff (window-buffer (minibuffer-window))))
      (set-buffer minibuff)
      (setq egg:*input-mode* t
	    egg:*mode-on*    t
	    its:*current-map* (its:get-mode-map "roma-kana"))
      (mode-line-egg-mode-update (its:get-mode-indicator its:*current-map*))))
  (read-from-minibuffer prompt initial-input
		       egg:*minibuffer-local-hiragana-map*))

(defun read-kanji-string (prompt &optional initial-input)
  (save-excursion
    (let ((minibuff (window-buffer (minibuffer-window))))
      (set-buffer minibuff)
      (setq egg:*input-mode* t
	    egg:*mode-on*    t
	    its:*current-map* (its:get-mode-map "roma-kana"))
      (mode-line-egg-mode-update (its:get-mode-indicator "roma-kana"))))
  (read-from-minibuffer prompt initial-input))

(defconst isearch:read-kanji-string 'read-kanji-string)

;;; 記号入力

(defvar special-symbol-input-point nil)

(defun special-symbol-input ()
  (interactive)
  (require 'egg-jsymbol)
  ;; 92.7.8 by Y.Kawabe
  (let ((item (menu:select-from-menu
	       *symbol-input-menu* special-symbol-input-point t))
	(code t))
    (and (listp item)
	 (setq code (car item) special-symbol-input-point (cdr item)))
    ;; end of patch
    (cond((stringp code) (insert code))
	 ((consp code) (eval code))
	 )))

(define-key global-map "\C-^"  'special-symbol-input)

(autoload 'busyu-input "busyu" nil t)	;92.10.18 by K.Handa
(autoload 'kakusuu-input "busyu" nil t)	;92.10.18 by K.Handa

;;; End of egg.el
