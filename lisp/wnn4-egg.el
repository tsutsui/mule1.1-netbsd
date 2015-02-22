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

;;;
;;;  wnn4-egg.el
;;;

;;;  Written by Toshiaki Shingu (shingu@cpr.canon.co.jp)
;;;  Modified for Wnn V4 library on wnn4v3-egg.el

;;; たまご「たかな」バージョン
;;; 「たかな」とは漬け物のたかなではありません。
;;; 「たまごよ／かしこく／なーーれ」の略をとって命名しました。
;;; Wnn V4 の jl ライブラリを使います。
;;; ライブラリとのインターフェースは wnn4fns.c で定義されています。

;;;  修正メモ

;;;  94/2/3   kWnn support by H.Kuribayashi
;;;  93/11/24 henkan-select-kouho: bug fixed
;;;  93/7/22  hinsi-from-menu updated
;;;  93/5/12  remove-regexp-in-string 
;;;		fixed by Shuji NARAZAKI <narazaki@csce.kyushu-u.ac.jp>
;;;  93/4/22  set-wnn-host-name, set-cwnn-host-name
;;;  93/4/5   EGG:open-wnn, close-wnn modified by tsuiki.
;;;  93/4/2   wnn-param-set
;;;  93/4/2   modified along with wnn4fns.c
;;;  93/3/3   edit-dict-item: bug fixed
;;;  93/1/8   henkan-help-command modified.
;;;  92/12/1  buffer local 'wnn-server-type' and 'cwnn-zhuyin'
;;;	 so as to support individual its mode with multiple buffers.
;;;  92/11/26 set-cserver-host-name fixed.
;;;  92/11/26 its:{previous,next}-mode by <yasutome@ics.osaka-u.ac.jp>
;;;  92/11/25 set-wnn-host-name was changed to set-{j,c}server-host-name.
;;;  92/11/25 redefined its:select-mode and its:select-mode-from-menu 
;;;	defined in egg.el to run hook with its mode selection.
;;;  92/11/20 bug fixed related to henkan mode attribute.
;;;  92/11/12 get-wnn-host-name and set-wnn-host-name were changed.
;;;  92/11/10 (set-dict-comment) bug fixed
;;;  92/10/27 (henkan-region-internal) display message if error occurs.
;;;  92/9/28 completely modified for chinese trandlation.
;;;  92/9/28 diced-{use,hindo-set} bug fixed <tetsuya@rabbit.is.s.u-tokyo.ac.jp>
;;;  92/9/22 touroku-henkan-mode by <tsuiki@sfc.keio.ac.jp>
;;;  92/9/18 rewrite wnn-dict-add to support password files.
;;;  92/9/8  henkan-region-internal was modified.
;;;  92/9/8  henkan-mode-map " "  'henkan-next-kouho-dai -> 'henkan-next-kouho
;;;  92/9/7  henkan-mode-map "\C-h" 'help-command -> 'henkan-help-command (Shuji Narazaki)
;;;  92/9/3  wnn-server-get-msg without wnn-error-code.
;;;  92/9/3  get-wnn-lang-name was modified.
;;;  92/8/19 get-wnn-lang-name の変更 (by T.Matsuzawa)
;;;  92/8/5  Bug in henkan-kakutei-first-char fixed. (by Y.Kasai)
;;;  92/7/17 set-egg-henkan-format の変更
;;;  92/7/17 egg:error の引数を format &rest args に変更
;;;  92/7/17 henkan/gyaku-henkan-word の修正
;;;  92/7/17 henkan/gyaku-henkan-paragraph/sentence/word で、
;;;	     表示が乱れるのを修正（save-excursion をはずす）
;;;  92.7.14 Unnecessary '*' in comments of variables deleted. (by T.Ito)
;;;  92/7/10 henkan-kakutei-first-char を追加、C-@ に割り当て。(by K.Handa)
;;;  92/7/8  overwrite-mode のサポート(by K. Handa)
;;;  92/6/30 startup file 周りの変更
;;;  92/6/30 変換モードのアトリビュートに bold を追加
;;;	     (by ITO Toshiyuki <toshi@his.cpl.melco.co.jp>)
;;;  92/6/22 空文字列を変換すると落ちるバグを修正
;;;  92/5/20 set-egg-henkan-mode-format の bug fix
;;;  92/5/20 egg:set-bunsetu-attribute が大文節で正しく動くように変更
;;;  92/5/19 version 0

;;; ----------------------------------------------------------------

(make-variable-buffer-local 'wnn-server-type)
(make-variable-buffer-local 'cwnn-zhuyin)

;;; ----------------------------------------------------------------
;;;	以下の its mode 関係の関数は、egg.el で定義されているが、
;;; たかなでは its mode の切替えに同期して、jserver/cserver,
;;; pinyin/zhuyin の切替えも行ないたいので、再定義している。
;;; 従って、egg.el, wnn4-egg.el の順にロードしなければならない。

(defun its:select-mode (name)
  (interactive (list (completing-read "ITS mode: " its:*mode-alist*)))
  (if (its:get-mode-map name)
      (progn
	(setq its:*current-map* (its:get-mode-map name))
	(egg:mode-line-display)
	(run-hooks 'its:select-mode-hook))
    (beep))
  )

(defun its:select-mode-from-menu ()
  (interactive)
  (setcar (nthcdr 2 its:*select-mode-menu*) its:*mode-alist*)
  (setq its:*current-map* (menu:select-from-menu its:*select-mode-menu*))
  (egg:mode-line-display)
  (run-hooks 'its:select-mode-hook))

(defvar its:select-mode-hook
  '(lambda ()
     (cond ((eq its:*current-map* (its:get-mode-map "roma-kana"))
	    (setq wnn-server-type 'jserver))
	   ((eq its:*current-map* (its:get-mode-map "PinYin"))
	    (setq wnn-server-type 'cserver)
	    (setq cwnn-zhuyin nil))
	   ((eq its:*current-map* (its:get-mode-map "zhuyin"))
	    (setq wnn-server-type 'cserver)
	    (setq cwnn-zhuyin t))
	   ((eq its:*current-map* (its:get-mode-map "hangul"))
	    (setq wnn-server-type 'kserver))
	   )))

(defun its:next-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (% (1+ pos) (length its:*standard-modes*))
	       its:*standard-modes*))
    (egg:mode-line-display)
    (run-hooks 'its:select-mode-hook)))

(defun its:previous-mode ()
  (interactive)
  (let ((pos (its:find its:*current-map* its:*standard-modes*)))
    (setq its:*current-map*
	  (nth (1- (if (= pos 0) (length its:*standard-modes*) pos))
	       its:*standard-modes*))
    (egg:mode-line-display)
    (run-hooks 'its:select-mode-hook)))

(defun read-current-its-string (prompt &optional initial-input henkan)
  (save-excursion
    (let ((old-its-map its:*current-map*)
	  (minibuff (window-buffer (minibuffer-window))))
      (set-buffer minibuff)
      (setq egg:*input-mode* t
	    egg:*mode-on*    t
	    its:*current-map* old-its-map)
      (mode-line-egg-mode-update
       (nth 1 (its:get-mode-indicator its:*current-map*)))
      (read-from-minibuffer prompt initial-input
			    (if henkan nil
			      egg:*minibuffer-local-hiragana-map*)))))

;;;----------------------------------------------------------------------
;;;
;;; Kana Kanji Henkan 
;;;
;;;----------------------------------------------------------------------

(or (fboundp 'wnn4-egg:kill-emacs)
    (fset 'wnn4-egg:kill-emacs (symbol-function 'kill-emacs)))

(defun kill-emacs (&optional arg)
  (interactive "P")
  (let ((wnn-server-type))
    (setq wnn-server-type 'jserver)
    (close-wnn)
    (setq wnn-server-type 'cserver)
    (close-wnn)
    (setq wnn-server-type 'kserver)
    (close-wnn))
  (wnn4-egg:kill-emacs arg))


(defun egg:error (form &rest mesg)
  (apply 'notify (or form "%s") mesg)
  (apply 'error (or form "%s") mesg))

(defun egg:msg-get (message)
  (or
   (nth 1 (assoc message (nth 1 (assoc wnn-server-type *egg-message-alist*))))
   (format "No message. Check *egg-message-alist* %s %s"
	   wnn-server-type message)))

(defvar *egg-message-alist*
  '((jserver
     ((open-wnn "ホスト %s の Wnn を起動しました")
      (no-rcfile "%s 上に egg-startup-file がありません。")
      (file-saved "Wnnの頻度情報・辞書情報を退避しました。")
      (henkan-mode-indicator "漢")
      (begin-henkan "変換開始文字列: ")
      (end-henkan "変換終了文字列: ")
      (kugiri-dai "大文節区切り文字列: ")
      (kugiri-sho "小文節区切り文字列: ")
      (attr-henkan "変換区間表示属性: ")
      (attr-dai "大文節区間表示属性: ")
      (attr-sho "小文節区間表示属性: ")
      (jikouho "次候補:")
      (off-msg "%s %s(%s:%s)を off しました。")
      (henkan-help "漢字変換モード:
文節移動
  \\[henkan-first-bunsetu]\t先頭文節\t\\[henkan-last-bunsetu]\t後尾文節  
  \\[henkan-backward-bunsetu]\t直前文節\t\\[henkan-forward-bunsetu]\t直後文節
変換変更
  大文節次候補    \\[henkan-next-kouho-dai]\t小文節次候補    \\[henkan-next-kouho-sho]
  前候補    \\[henkan-previous-kouho]  \t次候補    \\[henkan-next-kouho]
  大文節伸し  \\[henkan-bunsetu-nobasi-dai]  \t大文節縮め  \\[henkan-bunsetu-chijime-dai]
  小文節伸し  \\[henkan-bunsetu-nobasi-sho]  \t小文節縮め  \\[henkan-bunsetu-chijime-sho]
  大文節変換候補選択  \\[henkan-select-kouho-dai]  \t小文節変換候補選択  \\[henkan-select-kouho-sho]
変換確定
  全文節確定  \\[henkan-kakutei]  \t直前文節まで確定  \\[henkan-kakutei-before-point]
変換中止    \\[henkan-quit]
")
      (hinsimei "品詞名:")
      (jishotouroku-yomi "辞書登録『%s』  読み :")
      (touroku-jishomei "登録辞書名:" )
      (registerd "辞書項目『%s』(%s: %s)を%sに登録しました。" )
      (yomi "よみ：")
;      (no-yomi "『%s』の辞書項目はありません。")
      (no-yomi "辞書項目『%s』はありません。")
      (jisho "辞書：")
      (hindo " 頻度：")
      (kanji "漢字：")
      (register-notify "辞書項目『%s』(%s: %s)を%sに登録します。")
      (cannot-remove "システム辞書項目は削除できません。")
      (enter-hindo "頻度を入れて下さい: ")
      (remove-notify "辞書項目%s(%s)を%sから削除します。")
      (removed "辞書項目%s(%s)を%sから削除しました。")
      (jishomei "辞書名:" )
      (comment "コメント: ")
      (jisho-comment "辞書:%s: コメント:%s")
      (param ("Ｎ ( 大 ) 文節解析のＮ"
	      "大文節中の小文節の最大数"
	      "幹語の頻度のパラメータ"
	      "小文節長のパラメータ"
	      "幹語長のパラメータ"
	      "今使ったよビットのパラメータ"
	      "辞書のパラメータ"
	      "小文節の評価値のパラメータ"
	      "大文節長のパラメータ"
	      "小文節数のパラメータ"
	      "疑似品詞 数字の頻度"
	      "疑似品詞 カナの頻度"
	      "疑似品詞 英数の頻度"
	      "疑似品詞 記号の頻度"
	      "疑似品詞 閉括弧の頻度"
	      "疑似品詞 付属語の頻度"
	      "疑似品詞 開括弧の頻度"))
      ))
    (cserver
     ((open-wnn "Host %s 上的 cWnn 已经起动了")
      (no-rcfile "在%s 上没有 egg-startup-file")
      (file-saved "Wnn的频度文件和辞典信息已经退出了")
      (henkan-mode-indicator "汉")
      (begin-henkan "变换开始字符列: ")
      (end-henkan "变换结束字符列: ")
      (kugiri-dai "词组分割字符列: ")
      (kugiri-sho "单词分割字符列: ")
      (attr-henkan "变换区间表示属性: ")
      (attr-dai "词组区间表示属性: ")
      (attr-sho "单词区间表示属性: ")
      (jikouho "次侯选:")
      (off-msg "%s %s(%s:%s)已被 off 掉了")
      (henkan-help "汉字变换模式:
词组移动
  \\[henkan-first-bunsetu]\t先头词组\t\\[henkan-last-bunsetu]\t结尾词组
  \\[henkan-backward-bunsetu]\t前一个词组\t\\[henkan-forward-bunsetu]\t下一个词组
变换变更
  词组次侯选    \\[henkan-next-kouho-dai]\t单词次侯选    \\[henkan-next-kouho-sho]
  前侯选    \\[henkan-previous-kouho]  \t次侯选    \\[henkan-next-kouho]
  词组扩展  \\[henkan-bunsetu-nobasi-dai]  \t词组收缩  \\[henkan-bunsetu-chijime-dai]
  单词扩展  \\[henkan-bunsetu-nobasi-sho]  \t单词收缩   \\[henkan-bunsetu-chijime-sho]
  词组变换候补的选择  \\[henkan-select-kouho-dai]  \t单词变换候补的选择  \\[henkan-select-kouho-sho]
  变换候补的选择  \\[henkan-select-kouho-dai]
变换确定
  全文确定  \\[henkan-kakutei]  \t上一词组为止的确定  \\[henkan-kakutei-before-point]
停止变换    \\[henkan-quit]
")
      (hinsimei "词性名:")
      (jishotouroku-yomi "辞典登录『%s』拼法 :")
      (touroku-jishomei "登录辞典名:" )
      (registerd "辞典项目『%s』(%s: %s)已被登录到 %s 中了" )
      (yomi "拼法：")
;      (no-yomi "『%s』的辞典项目不存在")
      (no-yomi "辞典项目『%s』不存在")
      (jisho "辞典:")
      (hindo " 频度：")
      (kanji "汉字：")
      (register-notify "辞典项目『%s』(%s: %s)将要被登录到 %s 中")
      (cannot-remove "系统辞典项不能消除")
      (enter-hindo "请输入频度: ")
      (remove-notify "辞典项目%s(%s)将要从 %s 中消除")
      (removed "辞典项目%s(%s)已经从%s中消除了")
      (jishomei "辞典名:" )
      (comment "注释: ")
      (jisho-comment "辞典:%s: 注释:%s")
      (param ("解析词组个数"
	      "词组中词的最大个数"
	      "频度权值"
	      "词长度权值"
	      "四声正确度权值"
	      "刚才用过权值"
	      "字典优先级权值"
	      "词评价均值权值"
	      "词组长权值"
	      "词组中词数权值"
	      "数字的频度"
	      "英文字母的频度"
	      "记号的频度"
	      "开括弧的频度"
	      "闭括弧的频度"
	      "最大候补个数"
	      "备用"
	      ))
      ))
    (kserver
     ((open-wnn "호스트 %s 의 kWnn 를 機動 했읍니다.")
      (no-rcfile "%s 에 egg-startup-file 이 없읍니다.")
      (file-saved "kWnn 의 頻度情報·辭典情報를 옮겼읍니다.")
      (henkan-mode-indicator "漢")
      (begin-henkan "變換 開始 文字列: ")
      (end-henkan "變換 終了 文字列: ")
      (kugiri-dai "大文節 區別 文字列: ")
      (kugiri-sho "小文節 區別 文字列: ")
      (attr-henkan "變換 區間 標示 屬性: ")
      (attr-dai "大文節 區間 標示 屬性: ")
      (attr-sho "小文節 區間 標示 屬性: ")
      (jikouho "다음 候補:")
      (off-msg "%s %s(%s:%s)을 off 했읍니다.")
      (henkan-help "漢字 變換 모드:
文節 移動
  \\[henkan-first-bunsetu]\t先頭 文節\t\\[henkan-last-bunsetu]\t後尾 文節  
  \\[henkan-backward-bunsetu]\t直前 文節\t\\[henkan-forward-bunsetu]\t直後 文節
變換 變更
  大文節 다음 候補    \\[henkan-next-kouho-dai]\t小文節 다음 候補    \\[henkan-next-kouho-sho]
  前 候補    \\[henkan-previous-kouho]  \t다음 候補    \\[henkan-next-kouho]
  大文節 擴大  \\[henkan-bunsetu-nobasi-dai]  \t大文節 縮小  \\[henkan-bunsetu-chijime-dai]
  小文節 擴大  \\[henkan-bunsetu-nobasi-sho]  \t小文節 縮小  \\[henkan-bunsetu-chijime-sho]
  大文節 變換 다음 候補  \\[henkan-select-kouho-dai]  \t小文節 變換 다음 候補  \\[henkan-select-kouho-sho]
變換 確定
  全文節 確定  \\[henkan-kakutei]  \t直前 文節까지 確定  \\[henkan-kakutei-before-point]
變換 中止    \\[henkan-quit]
")
      (hinsimei "品詞名: ")
      (jishotouroku-yomi "辭典登錄『%s』 한글: ")
      (touroku-jishomei "登錄 辭典名: " )
      (registerd "辭典項目 『%s』(%s: %s)을 %s에 登錄 했읍니다." )
      (yomi "한글: ")
;      (no-yomi "『%s』의 辭典項目이 없읍니다.")
      (no-yomi "辭典項目 『%s』이 없읍니다.")
      (jisho "辭典: ")
      (hindo " 頻度: ")
      (kanji "漢字: ")
      (register-notify "辭典項目 『%s』(%s: %s)을 %s에 登錄 하겠습니다.")
      (cannot-remove "시스템 辭典項目은 消去 할수 없읍니다.")
      (enter-hindo "頻度를 入力 하십시오: ")
      (remove-notify "辭典項目 %s(%s)을 %s부터 消去 하겠습니다.")
      (removed "辭典項目 %s(%s)을 %s부터 消去 했읍니다.")
      (jishomei "辭典名: " )
      (comment "코멘트: ")
      (jisho-comment "辭典:%s: 코멘트:%s")
      (param ("N (大)文節 解析의 N"
	      "大文節안의 小文節수의 最大數"
	      "幹語의 頻度 패러미터"
	      "小文節길이 패러미터"
	      "幹語의 길이 패러미터"
	      "只今 使用 했읍니다 비트 패러미터"
	      "辭典의 패러미터"
	      "小文節의 評價値 패러미터"
	      "大文節길이 패러미터"
	      "小文節數 패러미터"
	      "假想 品詞: 數字의 頻度"
	      "假想 品詞: 한글의 頻度"
	      "假想 品詞: 英數字의 頻度"
	      "假想 品詞: 記號의 頻度"
	      "假想 品詞: 閉括弧의 頻度"
	      "假想 品詞: 附屬語의 頻度"
	      "假想 品詞: 開括弧의 頻度"))
      ))
    ))


;;;
;;; Entry functions for egg-startup-file
;;;

;(defvar wnn-lang-name nil)
;(defvar default-wnn-lang-name "ja_JP")	; 92.8.19 by T.Matsuzawa

(defvar skip-wnn-setenv-if-env-exist nil
  "skip wnn environment setting when the same name environment exists")

(defmacro push-end (val loc)
  (list 'push-end-internal val (list 'quote loc)))

(defun push-end-internal (val loc)
  (set loc
       (if (eval loc)
	   (nconc (eval loc) (cons val nil))
	 (cons val nil))))

(defun add-wnn-dict (dfile hfile priority dmode hmode &optional dpaswd hpaswd)
;  (open-wnn-if-disconnected)
  (if (null (wnn-server-dict-add
	     (substitute-in-file-name dfile)
	     (substitute-in-file-name hfile)
	     priority dmode hmode dpaswd hpaswd))
      (egg:error (wnn-server-get-msg))))

(defun set-wnn-fuzokugo (ffile)
;  (open-wnn-if-disconnected)
  (if (null (wnn-server-fuzokugo-set (substitute-in-file-name ffile)))
      (egg:error (wnn-server-get-msg))))

(defun set-wnn-param (&rest param)
  (interactive)
;  (open-wnn-if-disconnected)
  (let ((current-param (wnn-server-get-param))
	(new-param)
	(message (egg:msg-get 'param)))
    (while current-param
      (setq new-param
	    (cons
	     (if (or (null param) (null (car param)))
		 (string-to-int
		  (read-from-minibuffer (concat (car message) ": ")
					(int-to-string (car current-param))))
	       (car param))
	     new-param))
      (setq current-param (cdr current-param)
	    message (cdr message)
	    param (if param (cdr param) nil)))
    (apply 'wnn-server-set-param (nreverse new-param))))

;;;
;;; WNN interface
;;;

(defun make-host-list (name list)
  (let ((old-list list)
	(new-list (list name)))
    (while (consp old-list)
      (if (equal name (car old-list)) nil
	(nconc new-list (list (car old-list))))
      (setq old-list (cdr old-list)))
    new-list))

(defun set-wnn-host-name (name)
  (interactive "sHost name: ")
  (let ((wnn-server-type 'jserver)) (close-wnn))
  (if (null (boundp 'jserver-list))
      (setq jserver-list
	    (list
	     (if (boundp 'wnn-host-name)
		 wnn-host-name
	       (getenv "JSERVER")))))
  (setq jserver-list (make-host-list name jserver-list)))

(fset 'set-jserver-host-name (symbol-function 'set-wnn-host-name))

(defun set-cwnn-host-name (name)
  (interactive "sHost name: ")
  (let ((wnn-server-type 'cserver)) (close-wnn))
  (if (null (boundp 'cserver-list))
      (setq cserver-list
	    (list
	     (if (boundp 'cwnn-host-name)
		 cwnn-host-name
	       (getenv "CSERVER")))))
  (setq cserver-list (make-host-list name cserver-list)))

(fset 'set-cserver-host-name (symbol-function 'set-cwnn-host-name))

(defun set-kwnn-host-name (name)
  (interactive "sHost name: ")
  (let ((wnn-server-type 'kserver)) (close-wnn))
  (if (null (boundp 'kserver-list))
      (setq kserver-list
	    (list
	     (if (boundp 'kwnn-host-name)
		 kwnn-host-name
	       (getenv "KSERVER")))))
  (setq kserver-list (make-host-list name kserver-list)))

(fset 'set-kserver-host-name (symbol-function 'set-kwnn-host-name))

(defun open-wnn-if-disconnected ()
  (if (null (wnn-server-isconnect))
      (let ((hostlist
	     (if (eq wnn-server-type 'jserver)
		 (if (boundp 'jserver-list)
		     jserver-list
		   (list
		    (if (boundp 'wnn-host-name)
			wnn-host-name
		      (getenv "JSERVER"))))
	       (if (eq wnn-server-type 'cserver)
		   (if (boundp 'cserver-list)
		       cserver-list
		     (list
		      (if (boundp 'cwnn-host-name)
			  cwnn-host-name
			(getenv "CSERVER"))))
	       (if (eq wnn-server-type 'kserver)
		   (if (boundp 'kserver-list)
		       kserver-list
		     (list
		      (if (boundp 'kwnn-host-name)
			  kwnn-host-name
			(getenv "KSERVER"))))))))
	    (loginname (user-login-name))
	    (hostname)
	    (result))
	(while (and (consp hostlist) (null result))
	  (setq hostname (car hostlist))
	  (setq result (wnn-server-open hostname loginname))
	  (setq hostlist (cdr hostlist)))
	(if (null result)
	    (egg:error (wnn-server-get-msg))
	  (cond ((eq wnn-server-type 'jserver)
		 (setq wnn-host-name hostname))
		((eq wnn-server-type 'cserver)
		 (setq cwnn-host-name hostname))
		((eq wnn-server-type 'kserver)
		 (setq kwnn-host-name hostname)))))))

(defvar egg-default-startup-file "eggrc"
  "*Egg startup file name (system default)")

(defvar egg-startup-file ".eggrc"
  "*Egg startup file name.")

;;;  92/6/30, by K.Handa
(defvar egg-startup-file-search-path '("~" ".")
  "*List of directories to search for egg-startup-file
whose name defaults to .eggrc.")

(defun egg:search-file (filename searchpath)
  (let ((result nil))
    (if (null (file-name-directory filename))
	(let ((path searchpath))
	  (while (and path (null result ))
	    (let ((file (substitute-in-file-name
			 (expand-file-name filename (if (stringp (car path)) (car path) nil)))))
	      (if (file-exists-p file) (setq result file)
		(setq path (cdr path))))))
      (let((file (substitute-in-file-name (expand-file-name filename))))
	(if (file-exists-p file) (setq result file))))
    result))

(defun EGG:open-wnn ()
  (let ((host (open-wnn-if-disconnected)))
    (notify (egg:msg-get 'open-wnn)
	    (or host "local"))
    (let* ((path (append egg-startup-file-search-path load-path))
	   (eggrc (or (egg:search-file egg-startup-file path)
		      (egg:search-file egg-default-startup-file load-path))))
      (if (or (null skip-wnn-setenv-if-env-exist)
	      (null (wnn-server-dict-list)))
	  (if eggrc (load-file eggrc)
	    (let ((wnnenv-sticky nil)) (wnn-server-close))
	    (egg:error (egg:msg-get 'no-rcfile) path)))
      (run-hooks 'egg:open-wnn-hook))))

(defun disconnect-wnn ()
  (interactive)
  (if (wnn-server-isconnect) (wnn-server-close)))

(defun close-wnn ()
  (interactive)
  (if (wnn-server-isconnect)
      (progn
	(wnn-server-set-rev nil)
	(if (wnn-server-dict-save)
	    (progn
	      (message (egg:msg-get 'file-saved))
	      (sit-for 0))
	  (message  (wnn-server-get-msg))
	  (sit-for 0))
	(wnn-server-set-rev t)
	(if (wnn-server-dict-save)
	    (progn
	      (message (egg:msg-get 'file-saved))
	      (sit-for 0))
	  (message (wnn-server-get-msg))
	  (sit-for 0))
	(wnn-server-close)
	(run-hooks 'egg:close-wnn-hook))))

(defun set-wnn-reverse (arg)
;  (open-wnn-if-disconnected)
  (wnn-server-set-rev arg))

;;;
;;; Kanji henkan
;;;

(defvar egg:*kanji-kanabuff* nil)
(defvar egg:*dai* t)
(defvar *bunsetu-number* nil)
(defvar *zenkouho-suu* nil)
(defvar *zenkouho-offset* nil)

(defun bunsetu-length-sho (number)
  (cdr (wnn-server-bunsetu-yomi number)))
  
(defun bunsetu-length (number)
  (let ((max (wnn-server-dai-end number))
	(i (1+ number))
	(l (bunsetu-length-sho number)))
    (while (< i max)
      (setq l (+ l (bunsetu-length-sho i)))
      (setq i (1+ i)))
    l))

(defun bunsetu-position (number)
  (let ((pos egg:*region-start*) (i 0))
    (while (< i number)
      (setq pos (+ pos (length (bunsetu-kanji  i))
		   (if (wnn-server-dai-top (1+ i))
		       (length egg:*bunsetu-kugiri-dai*)
		     (length egg:*bunsetu-kugiri-sho*))))
      (setq i (1+ i)))
    pos))
  
(defun bunsetu-kanji (number) (car (wnn-server-bunsetu-kanji number)))
  
(defun bunsetu-yomi  (number) (car (wnn-server-bunsetu-yomi number)))

(defun kanji-moji-suu (str)
  (let ((max (length str)) (count 0) (i 0))
    (while (< i max)
      (setq count (1+ count))
      (if (< (aref str i) 128) (setq i (1+ i)) (setq i (+ i 2))))
    count))

(defun bunsetu-kouho-suu (number init)
  (if (or init (/= (wnn-server-zenkouho-bun) number))
      (setq *zenkouho-offset* (wnn-server-zenkouho number egg:*dai*)))
  (setq *zenkouho-suu* (wnn-server-zenkouho-suu)))

(defun bunsetu-kouho-list (number init)
  (if (or init (/= (wnn-server-zenkouho-bun) number))
      (setq *zenkouho-offset* (wnn-server-zenkouho number egg:*dai*)))
  (let ((i (1- (setq *zenkouho-suu* (wnn-server-zenkouho-suu))))
	(val nil))
    (while (<= 0 i)
      (setq val (cons (wnn-server-get-zenkouho i) val))
      (setq i (1- i)))
    val))

(defun bunsetu-kouho-number (number init)
  (if (or init (/= (wnn-server-zenkouho-bun) number))
      (setq *zenkouho-offset* (wnn-server-zenkouho number egg:*dai*)))
  *zenkouho-offset*)

;;;;
;;;; User entry : henkan-region, henkan-paragraph, henkan-sentence
;;;;

(defun egg:henkan-attribute-on ()
  (egg:set-region-attribute egg:*henkan-attribute* t))

(defun egg:henkan-attribute-off ()
  (egg:set-region-attribute egg:*henkan-attribute* nil))

(defun henkan-region (start end)
  (interactive "r")
  (if (interactive-p) (set-mark (point))) ;;; to be fixed
  (henkan-region-internal start end))

(defun gyaku-henkan-region (start end)
  (interactive "r")
  (if (interactive-p) (set-mark (point))) ;;; to be fixed
  (henkan-region-internal start end t))

;(defvar henkan-mode-indicator "漢")

(defun henkan-region-internal (start end &optional rev)
  "regionをかな漢字変換する。"
  (if (null (wnn-server-isconnect)) (EGG:open-wnn))
  (setq egg:*kanji-kanabuff* (buffer-substring start end))
; 8 Jul 92, by K.Handa
;  (if overwrite-mode
;      (setq egg:*overwrite-mode-deleted-chars* 
;	    (if egg:*henkan-fence-mode* 0
;	      (length egg:*kanji-kanabuff*))))
  (setq *bunsetu-number* 0)
  (setq egg:*dai* t)	; 92.9.8 by T.shingu
  (wnn-server-set-rev rev)
  (let ((result (wnn-server-henkan-begin egg:*kanji-kanabuff*)))
    (if (null result)
	(egg:error (wnn-server-get-msg))
      (if  (> result 0)
	  (progn
;	    (mode-line-egg-mode-update henkan-mode-indicator)
	    (mode-line-egg-mode-update (egg:msg-get 'henkan-mode-indicator))
	    (goto-char start)
	    (if (null (marker-position egg:*region-start*))
		(progn
		;;;(setq egg:*global-map-backup* (current-global-map))
		  (setq egg:*local-map-backup* (current-local-map))
		  (and (boundp 'disable-undo) (setq disable-undo t))
		  (delete-region start end)
		  (goto-char start)
		  (insert egg:*henkan-open*)
		  (set-marker egg:*region-start* (point))
		  (insert egg:*henkan-close*)
		  (set-marker egg:*region-end* egg:*region-start*)
		  (egg:henkan-attribute-on)
		  (goto-char egg:*region-start*)
		  )
	      (progn
		(egg:fence-attribute-off)
		(delete-region (- egg:*region-start* (length egg:*fence-open*)) 
			       egg:*region-start*)
		(delete-region egg:*region-end*
			       (+ egg:*region-end* (length egg:*fence-close*)))
		(goto-char egg:*region-start*)
		(insert egg:*henkan-open*)
		(set-marker egg:*region-start* (point))
		(goto-char egg:*region-end*)
		(let ((point (point)))
		  (insert egg:*henkan-close*)
		  (set-marker egg:*region-end* point))
		(goto-char start)
		(delete-region start end)
		(egg:henkan-attribute-on))
	      )
	    (henkan-insert-kouho 0 result)
	    (henkan-goto-bunsetu 0)
	    ;;;(use-global-map henkan-mode-map)
	    ;;;(use-local-map nil)
	    (use-local-map henkan-mode-map))))
    (run-hooks 'egg:henkan-start-hook)))


(defun henkan-paragraph ()
  "Kana-kanji henkan  paragraph at or after point."
  (interactive )
  (forward-paragraph)
  (let ((end (point)))
    (backward-paragraph)
    (henkan-region-internal (point) end)))

(defun gyaku-henkan-paragraph ()
  "Kana-kanji henkan  paragraph at or after point."
  (interactive )
  (forward-paragraph)
  (let ((end (point)))
    (backward-paragraph)
    (henkan-region-internal (point) end t)))

(defun henkan-sentence ()
  "Kana-kanji henkan sentence at or after point."
  (interactive )
  (forward-sentence)
  (let ((end (point)))
    (backward-sentence)
    (henkan-region-internal (point) end)))

(defun gyaku-henkan-sentence ()
  "Kana-kanji henkan sentence at or after point."
  (interactive )
  (forward-sentence)
  (let ((end (point)))
    (backward-sentence)
    (henkan-region-internal (point) end t)))

(defun henkan-word ()
  "Kana-kanji henkan word at or after point."
  (interactive)
  (re-search-backward "\\<" nil t)
  (let ((start (point)))
    (re-search-forward "\\>" nil t)
    (henkan-region-internal start (point))))

(defun gyaku-henkan-word ()
  "Kana-kanji henkan word at or after point."
  (interactive)
  (re-search-backward "\\<" nil t)
  (let ((start (point)))
    (re-search-forward "\\>" nil t)
    (henkan-region-internal start (point) t)))

;;;
;;; Kana Kanji Henkan Henshuu mode
;;;

(defconst egg:*bunsetu-kugiri-sho* "-" "*小文節の区切りを示す文字列")
(defconst egg:*bunsetu-kugiri-dai* " " "*大文節の区切りを示す文字列")
(defconst egg:*bunsetu-attribute-dai* nil "*大文節表示に用いるattribute または nil")
(defconst egg:*bunsetu-attribute-sho* nil "*小文節表示に用いるattribute または nil")

(defconst egg:*henkan-attribute* nil "*変換領域を表示するattribute または nil")
(defconst egg:*henkan-open*  "|" "*変換の始点を示す文字列")
(defconst egg:*henkan-close* "|" "*変換の終点を示す文字列")

(defun set-egg-henkan-mode-format (open close kugiri-dai kugiri-sho
					&optional attr1 attr2 attr3)
   "変換 mode の表示方法を設定する。OPEN は変換の始点を示す文字列または nil。
CLOSEは変換の終点を示す文字列または nil。
KUGIRI-DAIは大文節の区切りを表示する文字列または nil。
KUGIRI-SHOは小文節の区切りを表示する文字列または nil。
optional ATTR1 は変換区間を表示する属性 または nil（x11term のみで有効）
optional ATTR2 は大文節区間を表示する属性 または nil（x11term のみで有効）
optional ATTR3 は小文節区間を表示する属性 または nil（x11term のみで有効）"

  (interactive (list (read-string (egg:msg-get 'begin-henkan))
		     (read-string (egg:msg-get 'end-henkan))
		     (read-string (egg:msg-get 'kugiri-dai))
		     (read-string (egg:msg-get 'kugiri-sho))
		     (cdr (assoc (completing-read (egg:msg-get 'attr-henkan)
						  egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     (cdr (assoc (completing-read (egg:msg-get 'attr-dai)
						  egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     (cdr (assoc (completing-read (egg:msg-get 'attr-sho)
						  egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     ))
  (cond ((null (or (stringp open)  (null open)))
	 (egg:error "Wrong type of arguments(open): %s" open))
	((null (or (stringp close) (null close)))
	 (egg:error "Wrong type of arguments(close): %s" close))
	((null (or (stringp kugiri-dai) (null kugiri-dai)))
	 (egg:error "Wrong type of arguments(kugiri-dai): %s" kugiri-dai))
	((null (or (stringp kugiri-sho) (null kugiri-sho)))
	 (egg:error "Wrong type of arguments(kugiri-sho): %s" kugiri-sho))
	((null (egg:member attr1 '(underline inverse bold nil)))
	 (egg:error "Wrong type of arguments(attr1): %s" attr1))
	((null (egg:member attr2 '(underline inverse bold nil)))
	 (egg:error "Wrong type of arguments(attr2): %s" attr2))
	((null (egg:member attr3 '(underline inverse bold nil)))
	 (egg:error "Wrong type of arguments(attr3): %s" attr3))
	(t
	 (setq egg:*henkan-open* open
	       egg:*henkan-close* close
	       egg:*bunsetu-kugiri-dai* (or kugiri-dai "")
	       egg:*bunsetu-kugiri-sho* (or kugiri-sho "")
	       egg:*henkan-attribute* attr1
	       egg:*bunsetu-attribute-dai* attr2
	       egg:*bunsetu-attribute-sho* attr3)
	 (if (or attr1 attr2 attr3) (require 'attribute))
	 nil)))


(defun henkan-insert-kouho (start number)
  (let ((i start))
    (while (< i number)
      (insert (car (wnn-server-bunsetu-kanji i))
	      (if (= (1+ i) number)
		  ""
		  (if (wnn-server-dai-top (1+ i))
		      egg:*bunsetu-kugiri-dai*
		      egg:*bunsetu-kugiri-sho*)))
      (setq i (1+ i)))))
  
(defun henkan-kakutei ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (setq egg:*sai-henkan-start* (point))
  (let ((i 0) (max (wnn-server-bunsetu-suu)))
    (setq egg:*old-bunsetu-suu* max)
    (while (< i max)
      (insert (car (wnn-server-bunsetu-kanji i )))
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (setq egg:*sai-henkan-end* (point))
  (wnn-server-hindo-update)
  (egg:quit-egg-mode)
  (run-hooks 'egg:henkan-end-hook)
  )

;; 92.7.10 by K.Handa
(defun henkan-kakutei-first-char ()
  "確定文字列の最初の一文字だけ挿入する。"
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end*
				     ;; 92.8.5  by Y.Kasai
				     (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (insert (car (wnn-server-bunsetu-kanji 0)))
  (if (not overwrite-mode)
      (undo-boundary))
  (goto-char egg:*region-start*)
  (forward-char 1)
  (delete-region (point) egg:*region-end*)
  (wnn-server-hindo-update)
  (egg:quit-egg-mode)
  )
;; end of patch

(defun henkan-kakutei-before-point ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region egg:*region-start* egg:*region-end*)
  (goto-char egg:*region-start*)
  (let ((i 0) (max *bunsetu-number*))
    (while (< i max)
      (insert (car (wnn-server-bunsetu-kanji i )))
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (wnn-server-hindo-update *bunsetu-number*)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-end*)
  (let ((point (point)))
    (insert egg:*fence-close*)
    (set-marker egg:*region-end* point))
  (goto-char egg:*region-start*)
  (egg:fence-attribute-on)
  (let ((point (point))
	(i *bunsetu-number*) (max (wnn-server-bunsetu-suu)))
    (while (< i max)
      (insert (car (wnn-server-bunsetu-yomi i)))
      (setq i (1+ i)))
    ;;;(insert "|")
    ;;;(insert egg:*fence-close*)
    ;;;(set-marker egg:*region-end* (point))
    (goto-char point))
  (setq egg:*mode-on* t)
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map  nil)
  (use-local-map fence-mode-map)
  (egg:mode-line-display))

(defun sai-henkan ()
  (interactive)
  (mode-line-egg-mode-update (egg:msg-get 'henkan-mode-indicator))
  (goto-char egg:*sai-henkan-start*)
  (if (null (marker-position egg:*region-start*))
      (progn
	(setq egg:*local-map-backup* (current-local-map))
	(and (boundp 'disable-undo) (setq disable-undo t))
	(delete-region egg:*sai-henkan-start* egg:*sai-henkan-end*)
	(goto-char egg:*sai-henkan-start*)
	(insert egg:*henkan-open*)
	(set-marker egg:*region-start* (point))
	(insert egg:*henkan-close*)
	(set-marker egg:*region-end* egg:*region-start*)
	(egg:henkan-attribute-on)
	(goto-char egg:*region-start*)
	)
    (progn
      (egg:fence-attribute-off)
      (delete-region (- egg:*region-start* (length egg:*fence-open*)) 
		     egg:*region-start*)
      (delete-region egg:*region-end*
		     (+ egg:*region-end* (length egg:*fence-close*)))
      (goto-char egg:*region-start*)
      (insert egg:*henkan-open*)
      (set-marker egg:*region-start* (point))
      (goto-char egg:*region-end*)
      (let ((point (point)))
	(insert egg:*henkan-close*)
	(set-marker egg:*region-end* point))
	(goto-char egg:*sai-henkan-start*)
	(delete-region egg:*sai-henkan-start* egg:*sai-henkan-end*)
      (egg:henkan-attribute-on))
    )
  (henkan-insert-kouho 0 egg:*old-bunsetu-suu*)
  (henkan-goto-bunsetu 0)
  (use-local-map henkan-mode-map)
  )

(defun egg:set-region-attribute (attr on)
  (if attr 
      (attribute-on-off-region attr egg:*region-start* egg:*region-end* on)))

(defun egg:set-bunsetu-attribute (no attr switch &optional dai)
  (let ((next (if dai (wnn-server-dai-end no)
		(1+ no)))
	(bunsetu-suu (wnn-server-bunsetu-suu))
	(start no))
    (if dai (while (null (wnn-server-dai-top start))
	      (setq start (1- start))))
    (if (and start attr)
	(attribute-on-off-region
	 attr
	 (if (and (eq attr 'inverse) (null dai))
	     (let ((p (bunsetu-position start)))
	       (save-excursion
		 (goto-char p)
		 (forward-char)
		 (setq p (point)))
	       p)
	   (bunsetu-position start))
	 (if (= next bunsetu-suu)
	     egg:*region-end*
	   (- (bunsetu-position next)
	      (if (wnn-server-dai-top next)
		  (length egg:*bunsetu-kugiri-dai*)
		(length egg:*bunsetu-kugiri-sho*))))
	 switch))))

(defun egg:bunsetu-attribute-on (no)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute-dai* t t)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute-sho* t nil))

(defun egg:bunsetu-attribute-off (no)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute-dai* nil t)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute-sho* nil nil))

(defun henkan-goto-bunsetu (number)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (setq *bunsetu-number*
	(check-number-range number 0 (1- (wnn-server-bunsetu-suu))))
  (goto-char (bunsetu-position *bunsetu-number*))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil t)
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil nil)
  (egg:bunsetu-attribute-on *bunsetu-number*)
  (egg:henkan-attribute-on)
  )

(defun henkan-forward-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu (1+ *bunsetu-number*))
  )

(defun henkan-backward-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu (1- *bunsetu-number*))
  )

(defun henkan-first-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu 0))

(defun henkan-last-bunsetu ()
  (interactive)
  (henkan-goto-bunsetu (1- (wnn-server-bunsetu-suu)))
  )
 
(defun check-number-range (i min max)
  (cond((< i min) max)
       ((< max i) min)
       (t i)))

(defun henkan-hiragana ()
  (interactive)
  (henkan-goto-kouho (- (bunsetu-kouho-suu *bunsetu-number* nil) 1)))

(defun henkan-katakana ()
  (interactive)
  (henkan-goto-kouho (- (bunsetu-kouho-suu *bunsetu-number* nil) 2)))

(defun henkan-next-kouho ()
  (interactive)
  (henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number* nil))))

(defun henkan-next-kouho-dai ()
  (interactive)
  (if egg:*dai*
      (henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number* nil)))
    (progn
      (setq egg:*dai* t)
      (henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number* t))))))

(defun henkan-next-kouho-sho ()
  (interactive)
  (if egg:*dai*
      (progn
	(setq egg:*dai* nil)
	(henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number* t))))
    (henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number* nil)))))
  
(defun henkan-previous-kouho ()
  (interactive)
  (henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number* nil))))

(defun henkan-previous-kouho-dai ()
  (interactive)
  (if egg:*dai*
      (henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number* nil)))
    (progn
      (setq egg:*dai* t)
      (henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number* t))))))

(defun henkan-previous-kouho-sho ()
  (interactive)
  (if egg:*dai*
      (progn
	(setq egg:*dai* nil)
	(henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number* t))))
    (henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number* nil)))))
  
(defun henkan-goto-kouho (kouho-number)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (let ((point (point))
	(yomi  (bunsetu-yomi *bunsetu-number*))
	(max)
	(min))
    (setq kouho-number 
	  (check-number-range kouho-number 
			      0
			      (1- (length (bunsetu-kouho-list
					   *bunsetu-number* nil)))))
    (setq *zenkouho-offset* kouho-number)
    (wnn-server-henkan-kakutei kouho-number egg:*dai*)
    (setq max (wnn-server-bunsetu-suu))
    (setq min (max 0 (1- *bunsetu-number*)))
    (delete-region 
     (bunsetu-position min) egg:*region-end*)
    (goto-char (bunsetu-position min))
    (henkan-insert-kouho min max)
    (goto-char point))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil t)
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil nil)
  (egg:bunsetu-attribute-on *bunsetu-number*)
  (egg:henkan-attribute-on))
  
(defun henkan-bunsetu-chijime-dai ()
  (interactive)
  (setq egg:*dai* t)
  (or (= (bunsetu-length *bunsetu-number*) 1)
      (bunsetu-length-henko (1-  (bunsetu-length *bunsetu-number*)))))

(defun henkan-bunsetu-chijime-sho ()
  (interactive)
  (setq egg:*dai* nil)
  (or (= (bunsetu-length-sho *bunsetu-number*) 1)
      (bunsetu-length-henko (1-  (bunsetu-length-sho *bunsetu-number*)))))

(defun henkan-bunsetu-nobasi-dai ()
  (interactive)
  (setq egg:*dai* t)
  (let ((i *bunsetu-number*)
	(max (wnn-server-bunsetu-suu))
	(len (bunsetu-length *bunsetu-number*))
	(maxlen 0))
    (while (< i max)
      (setq maxlen (+ maxlen (cdr (wnn-server-bunsetu-yomi i))))
      (setq i (1+ i)))
    (if (not (= len maxlen))
	(bunsetu-length-henko (1+ len)))))

(defun henkan-bunsetu-nobasi-sho ()
  (interactive)
  (setq egg:*dai* nil)
  (let ((i *bunsetu-number*)
	(max (wnn-server-bunsetu-suu))
	(len (bunsetu-length-sho *bunsetu-number*))
	(maxlen 0))
    (while (< i max)
      (setq maxlen (+ maxlen (cdr (wnn-server-bunsetu-yomi i))))
      (setq i (1+ i)))
    (if (not (= len maxlen))
	(bunsetu-length-henko (1+ len)))))

;  (if (not (= (1+ *bunsetu-number*) (wnn-server-bunsetu-suu)))
;      (bunsetu-length-henko (1+ (bunsetu-length *bunsetu-number*)))))


(defun henkan-saishou-bunsetu ()
  (interactive)
  (bunsetu-length-henko 1))

(defun henkan-saichou-bunsetu ()
  (interactive)
  (let ((max (wnn-server-bunsetu-suu)) (i *bunsetu-number*)
	(l 0))
    (while (< i max)
      (setq l (+ l (bunsetu-length-sho i)))
      (setq i (1+ i)))
    (bunsetu-length-henko l)))

(defun bunsetu-length-henko (length)
  (let ((i 0)
	(r (wnn-server-bunsetu-henkou *bunsetu-number* length egg:*dai*))
	(start (max 0 (1- *bunsetu-number*))))
    (cond((null r)
	  (egg:error (wnn-server-get-msg)))
	 ((> r 0)
	  (egg:henkan-attribute-off)
	  (egg:bunsetu-attribute-off *bunsetu-number*)
	  (delete-region 
	   (bunsetu-position start) egg:*region-end*)
	  (goto-char (bunsetu-position start))
	  (henkan-insert-kouho start r)
	  (henkan-goto-bunsetu *bunsetu-number*)))))

(defun henkan-quit ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (insert egg:*fence-open*)
  (set-marker egg:*region-start* (point))
  (insert egg:*kanji-kanabuff*)
  (let ((point (point)))
    (insert egg:*fence-close*)
    (set-marker egg:*region-end* point)
    )
  (goto-char egg:*region-end*)
  (egg:fence-attribute-on)
  (wnn-server-henkan-quit)
  (setq egg:*mode-on* t)
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map  nil)
  (use-local-map fence-mode-map)
  (egg:mode-line-display)
  )

(defun henkan-select-kouho (init)
  (if (not (eq (selected-window) (minibuffer-window)))
      (let ((kouho-list (bunsetu-kouho-list *bunsetu-number* init))
	    menu)
	(setq menu
	      (list 'menu (egg:msg-get 'jikouho)
		    (let ((l kouho-list) (r nil) (i 0))
		      (while l
			(setq r (cons (cons (car l) i) r))
			(setq i (1+ i))
			(setq l (cdr l)))
		      (reverse r))))
	(henkan-goto-kouho 
	 (menu:select-from-menu menu 
				(bunsetu-kouho-number *bunsetu-number* nil))))
    (beep)))

(defun henkan-select-kouho-dai ()
  (interactive)
  (if egg:*dai*
      (henkan-select-kouho nil)
    (progn
      (setq egg:*dai* t)
      (henkan-select-kouho t))))

(defun henkan-select-kouho-sho ()
  (interactive)
  (if egg:*dai*
      (progn
	(setq egg:*dai* nil)
	(henkan-select-kouho t))
    (henkan-select-kouho nil)))


(defun henkan-word-off ()
  (interactive)
  (let ((info (wnn-server-inspect *bunsetu-number*)))
    (if (null info)
	(notify (wnn-server-get-msg))
      (progn
	(let ((dic-list (wnn-server-dict-list)))
	  (if (null dic-list)
	      (notify (wnn-server-get-msg))
	    (progn
	      (let* ((kanji (nth 0 info))
		     (yomi (nth 1 info))
		     (serial   (nth 3 info))
		     (jisho-no (nth 2 info))
		     (jisho-name (nth 2 (assoc jisho-no dic-list))))
		(if (wnn-server-word-use jisho-no serial)
		    (notify (egg:msg-get 'off-msg)
			    kanji yomi jisho-name serial)
		  (egg:error (wnn-server-get-msg)))))))))))

(defun henkan-kakutei-and-self-insert ()
  (interactive)
  (setq unread-command-char last-command-char)
  (henkan-kakutei))


(defvar henkan-mode-map (make-keymap))

(defvar henkan-mode-esc-map (make-keymap))

(let ((ch 0))
  (while (<= ch 127)
    (aset henkan-mode-map ch 'undefined)
    (aset henkan-mode-esc-map ch 'undefined)
    (setq ch (1+ ch))))

(let ((ch 32))
  (while (< ch 127)
    (aset henkan-mode-map ch 'henkan-kakutei-and-self-insert)
    (setq ch (1+ ch))))
	
(define-key henkan-mode-map "\e"   henkan-mode-esc-map)
;(define-key henkan-mode-map "\ei"  'henkan-inspect-bunsetu)
(define-key henkan-mode-map "\ei"  'henkan-bunsetu-chijime-sho)
(define-key henkan-mode-map "\eo"  'henkan-bunsetu-nobasi-sho)
(define-key henkan-mode-map "\es"  'henkan-select-kouho-dai)
(define-key henkan-mode-map "\eh"  'henkan-hiragana)
(define-key henkan-mode-map "\ek"  'henkan-katakana)
(define-key henkan-mode-map "\ez"  'henkan-select-kouho-sho)
(define-key henkan-mode-map "\e<"  'henkan-saishou-bunsetu)
(define-key henkan-mode-map "\e>"  'henkan-saichou-bunsetu)
;(define-key henkan-mode-map " "    'henkan-next-kouho-dai)
					; 92.9.8 by T.Shingu
(define-key henkan-mode-map " "    'henkan-next-kouho)
					; 92.7.10 by K.Handa
(define-key henkan-mode-map "\C-@" 'henkan-kakutei-first-char)
(define-key henkan-mode-map "\C-a" 'henkan-first-bunsetu)
(define-key henkan-mode-map "\C-b" 'henkan-backward-bunsetu)
(define-key henkan-mode-map "\C-c" 'henkan-quit)
(define-key henkan-mode-map "\C-d" 'undefined)
(define-key henkan-mode-map "\C-e" 'henkan-last-bunsetu)
(define-key henkan-mode-map "\C-f" 'henkan-forward-bunsetu)
(define-key henkan-mode-map "\C-g" 'henkan-quit)
(define-key henkan-mode-map "\C-h" 'henkan-help-command)
(define-key henkan-mode-map "\C-i" 'henkan-bunsetu-chijime-dai)
(define-key henkan-mode-map "\C-j" 'undefined)
(define-key henkan-mode-map "\C-k" 'henkan-kakutei-before-point)
(define-key henkan-mode-map "\C-l" 'henkan-kakutei)
(define-key henkan-mode-map "\C-m" 'henkan-kakutei)
(define-key henkan-mode-map "\C-n" 'henkan-next-kouho)
(define-key henkan-mode-map "\C-o" 'henkan-bunsetu-nobasi-dai)
(define-key henkan-mode-map "\C-p" 'henkan-previous-kouho)
(define-key henkan-mode-map "\C-q" 'undefined)
(define-key henkan-mode-map "\C-r" 'undefined)
(define-key henkan-mode-map "\C-s" 'undefined)
;(define-key henkan-mode-map "\C-t" 'undefined)
(define-key henkan-mode-map "\C-t"  'toroku-henkan-mode)
(define-key henkan-mode-map "\C-u" 'undefined)
(define-key henkan-mode-map "\C-v" 'henkan-inspect-bunsetu)
(define-key henkan-mode-map "\C-w" 'henkan-next-kouho-dai)
(define-key henkan-mode-map "\C-x" 'undefined)
(define-key henkan-mode-map "\C-y" 'undefined)
(define-key henkan-mode-map "\C-z" 'henkan-next-kouho-sho)
(define-key henkan-mode-map "\177" 'henkan-quit)

(defun henkan-help-command ()
  "Display documentation fo henkan-mode."
  (interactive)
  (if (eq (get-buffer "*Help*") (current-buffer))
      (henkan-quit)
    (with-output-to-temp-buffer (buffer-name buf)
;       (princ (substitute-command-keys henkan-mode-document-string))
	(princ (substitute-command-keys (egg:msg-get 'henkan-help)))
	(print-help-return-message))))

;;;----------------------------------------------------------------------
;;;
;;; Dictionary management Facility
;;;
;;;----------------------------------------------------------------------

;;;
;;; 辞書登録 
;;;

;;;;
;;;; User entry: toroku-region
;;;;

(defun remove-regexp-in-string (regexp string)
  (cond((not(string-match regexp string))
	string)
       (t(let ((str nil)
	     (ostart 0)
	     (oend   (match-beginning 0))
	     (nstart (match-end 0)))
	 (setq str (concat str (substring string ostart oend)))
	 (while (string-match regexp string nstart)
	   (setq ostart nstart)
	   (setq oend   (match-beginning 0))
	   (setq nstart (match-end 0))
	   (setq str (concat str (substring string ostart oend))))
	 (concat str (substring string nstart))))))

(defun hinsi-from-menu (dict-no name)
  (let ((result (wnn-server-hinsi-list dict-no name))
;	(hinsi-pair)
	(menu))
    (if (null result)
	(egg:error (wnn-server-get-msg))
      (if (eq result 0)
	  name
	(progn
;	  (setq hinsi-pair (mapcar '(lambda (x) (cons x x)) result))
;	  (if (null (string= name "/"))
;	      (setq hinsi-pair (cons (cons "/" "/") hinsi-pair)))
;	  (setq menu (list 'menu (egg:msg-get 'hinsimei) hinsi-pair))
	  (setq menu (list 'menu (egg:msg-get 'hinsimei)
			   (if (string= name "/")
			       result
			     (cons "/" result))))
	  (hinsi-from-menu dict-no 
			   (menu:select-from-menu menu)))))))

(defun wnn-dict-name (dict-no dict-list)
  (let* ((dict-info (assoc dict-no dict-list))
	 (dict-comment (nth 2 dict-info)))
    (if (string= dict-comment "")
	(file-name-nondirectory (nth 1 dict-info))
      dict-comment)))

(defun toroku-region (start end)
  (interactive "r")
  (if (null (wnn-server-isconnect)) (EGG:open-wnn))
  (wnn-server-set-rev nil)
  (let*((kanji
	 (remove-regexp-in-string "[\0-\37]" (buffer-substring start end)))
	(yomi (read-current-its-string
	       (format (egg:msg-get 'jishotouroku-yomi) kanji)))
	(dic-list (wnn-server-dict-list))
	(writable-dic-list (wnn-server-hinsi-dicts -1))
	(dict-no
	 (menu:select-from-menu
	  (list 'menu (egg:msg-get 'touroku-jishomei)
		(mapcar '(lambda (x)
			   (let ((y (car (assoc x dic-list))))
			     (cons (wnn-dict-name y dic-list) y)))
			writable-dic-list))))
	(hinsi-name (hinsi-from-menu dict-no "/"))
	(hinsi-no (wnn-server-hinsi-number hinsi-name)))
    (if (wnn-server-word-add dict-no kanji yomi "" hinsi-no)
	(notify (egg:msg-get 'registerd)
	    kanji yomi hinsi-name (wnn-dict-name dict-no dic-list))
      (egg:error (wnn-server-get-msg)))))


(defun delete-space (string)
  (let ((len (length string)))
    (if (eq len 0) ""
      (if (or (char-equal (aref string 0) ? ) (char-equal (aref string 0) ?-)) 
	  (delete-space (substring string 1))
	(concat (substring string 0 1) (delete-space (substring string 1)))))))


(defun toroku-henkan-mode ()
  (interactive)
  (let*((kanji 	 
	 (read-current-its-string (egg:msg-get 'kanji)
			       (delete-space 
				(buffer-substring (point) egg:*region-end* ))))
	(yomi (read-current-its-string
	       (format (egg:msg-get 'jishotouroku-yomi) kanji)
	       (let ((str "")
		     (i *bunsetu-number*) 
		     (max (wnn-server-bunsetu-suu)))
		 (while (< i max)
		   (setq str (concat str (car (wnn-server-bunsetu-yomi i)) ))
		   (setq i (1+ i)))
		 str)))
	(dic-list (wnn-server-dict-list))
	(writable-dic-list (wnn-server-hinsi-dicts -1))
	(dict-no
	 (menu:select-from-menu
	  (list 'menu (egg:msg-get 'touroku-jishomei)
		(mapcar '(lambda (x)
			   (let ((y (car (assoc x dic-list))))
			     (cons (wnn-dict-name y dic-list) y)))
			writable-dic-list))))
	(hinsi-name (hinsi-from-menu dict-no "/"))
	(hinsi-no (wnn-server-hinsi-number hinsi-name)))
    (if (wnn-server-word-add dict-no kanji yomi "" hinsi-no)
	(notify (egg:msg-get 'registerd)
	    kanji yomi hinsi-name (wnn-dict-name dict-no dic-list))
      (egg:error (wnn-server-get-msg)))))

;;;
;;; 辞書編集系 DicEd
;;;

(defvar *diced-window-configuration* nil)

(defvar *diced-dict-info* nil)

(defvar *diced-yomi* nil)

;;;;;
;;;;; User entry : edit-dict-item
;;;;;

(defun edit-dict-item (yomi)
  (interactive (list (read-current-its-string (egg:msg-get 'yomi))))
  (if (null (wnn-server-isconnect)) (EGG:open-wnn))
  (wnn-server-set-rev nil)
  (let ((dict-info (wnn-server-word-search yomi)))
    (if (null dict-info)
	(message (egg:msg-get 'no-yomi) yomi)
      (progn
	(setq current-wnn-server-type wnn-server-type)
	(setq *diced-yomi* yomi)
	(setq *diced-window-configuration* (current-window-configuration))
	(pop-to-buffer "*Nihongo Dictionary Information*")
	(setq wnn-server-type current-wnn-server-type)
	(setq major-mode 'diced-mode)
	(setq mode-name "Diced")
	(setq mode-line-buffer-identification 
	      (concat "DictEd: " yomi
		      (make-string  (max 0 (- 17 (string-width yomi))) ?  )))
	(sit-for 0) ;; will redislay.
	;;;(use-global-map diced-mode-map)
	(use-local-map diced-mode-map)
	(diced-display dict-info)
	))))

(defun diced-redisplay ()
  (wnn-server-set-rev nil)
  (let ((dict-info (wnn-server-word-search *diced-yomi*)))
    (if (null dict-info)
	(progn
	  (message (egg:msg-get 'no-yomi) *diced-yomi*)
	  (diced-quit))
      (diced-display dict-info))))

(defun diced-display (dict-info)
	;;; (values (list (record kanji bunpo hindo dict-no serial-no)))
	;;;                         0     1     2      3       4
  (setq dict-info
	(sort dict-info
	      (function (lambda (x y)
			  (or (< (nth 1 x) (nth 1 y))
			      (if (= (nth 1 x) (nth 1 y))
				  (or (> (nth 2 x) (nth 2 y))
				      (if (= (nth 2 x) (nth 2 y))
					  (< (nth 3 x) (nth 3 y))))))))))
  (setq *diced-dict-info* dict-info)
  (setq buffer-read-only nil)
  (erase-buffer)
  (let ((l-kanji 
	 (apply 'max
		(mapcar (function (lambda (l) (string-width (nth 0 l))))
			dict-info)))
	(l-bunpo
	 (apply 'max
		(mapcar (function(lambda (l)
				   (string-width (wnn-server-hinsi-name (nth 1 l)))))
			dict-info)))
	(dict-list (wnn-server-dict-list))
	(writable-dict-list (wnn-server-hinsi-dicts -1)))
    (while dict-info
      (let*((kanji (nth 0 (car dict-info)))
	    (bunpo (nth 1 (car dict-info)))
	    (hinshi (wnn-server-hinsi-name bunpo))
	    (hindo (nth 2 (car dict-info)))
	    (dict-no (nth 3 (car dict-info)))
	    (dict-name (wnn-dict-name dict-no dict-list))
	    (sys-dict-p (null (memq dict-no writable-dict-list)))
	    (serial-no (nth 4 (car dict-info))))
	(insert (if sys-dict-p " *" "  "))
	(insert kanji)
	(insert-char ?  
		     (- (+ l-kanji 10) (string-width kanji)))
	(insert hinshi)
	(insert-char ?  (- (+ l-bunpo 2) (string-width hinshi)))
	(insert (egg:msg-get 'jisho) (file-name-nondirectory dict-name)
		"/" (int-to-string serial-no)
		(egg:msg-get 'hindo) (int-to-string hindo) ?\n )
	(setq dict-info (cdr dict-info))))
    (goto-char (point-min)))
  (setq buffer-read-only t))

(defun diced-add ()
  (interactive)
  (diced-execute t)
  (let*((kanji  (read-from-minibuffer (egg:msg-get 'kanji)))
	(dic-list (wnn-server-dict-list))
	(writable-dic-list (wnn-server-hinsi-dicts -1))
	(dict-no
	 (menu:select-from-menu
	  (list 'menu (egg:msg-get 'touroku-jishomei)
		(mapcar '(lambda (x)
			   (let ((y (car (assoc x dic-list))))
			     (cons (wnn-dict-name y dic-list) y)))
			writable-dic-list))))
	(hinsi-name (hinsi-from-menu dict-no "/"))
	(hinsi-no (wnn-server-hinsi-number hinsi-name))

	(dict-name (wnn-dict-name dict-no dic-list))
	)
    (if (notify-yes-or-no-p (egg:msg-get 'register-notify)
			    kanji *diced-yomi* hinsi-name dict-name)
	(progn
	  (if (wnn-server-word-add dict-no kanji *diced-yomi* "" hinsi-no)
	      (notify (egg:msg-get 'registerd)
		      kanji *diced-yomi* hinsi-name dict-name)
	    (egg:error (wnn-server-get-msg)))
	  (diced-redisplay)))))
	      
(defun diced-delete ()
  (interactive)
  (beginning-of-line)
  (if (= (char-after (1+ (point))) ?* )
      (progn (message (egg:msg-get 'cannot-remove)) (beep))
    (if (= (following-char) ?  )
	(let ((buffer-read-only nil))
	  (delete-char 1) (insert "D") (backward-char 1))
      )))

    
(defun diced-undelete ()
  (interactive)
  (beginning-of-line)
  (if (= (following-char) ?D)
      (let ((buffer-read-only nil))
	(delete-char 1) (insert " ") (backward-char 1))
    (beep)))

(defun diced-use ()
  (interactive)
  (let* ((dict-item (nth 
		     (+ (count-lines (point-min) (point))
			(if (= (current-column) 0) 1 0)
			-1)
		    *diced-dict-info*))
	 (hindo (nth 2 dict-item))
	 (dict-no (nth 3 dict-item))
	 (serial-no (nth 4 dict-item))
	 )
    (if (null (wnn-server-word-use dict-no serial-no))
	(egg:error (wnn-server-get-msg)))
    (setq buffer-read-only nil)
    (beginning-of-line)
    (re-search-forward "\\([0-9\-]+\\)\\(\n\\)")
    (delete-region (match-beginning 1) (match-end 1))
    (setq hindo (nth 3 (wnn-server-word-info dict-no serial-no)))
    (goto-char (match-beginning 1))
    (insert (int-to-string hindo))
    (beginning-of-line)
    (setq buffer-read-only t)))

(defun diced-hindo-set (&optional newhindo)
  (interactive)
  (if (null newhindo)
      (setq newhindo (read-minibuffer (egg:msg-get 'enter-hindo))))
  (let* ((dict-item (nth 
		     (+ (count-lines (point-min) (point))
			(if (= (current-column) 0) 1 0)
			-1)
		    *diced-dict-info*))
	 (hindo (nth 2 dict-item))
	 (dict-no (nth 3 dict-item))
	 (serial-no (nth 4 dict-item))
	 )
    (if (null (wnn-server-word-hindo-set dict-no serial-no newhindo))
	(egg:error (wnn-server-get-msg)))
    (setq buffer-read-only nil)
    (beginning-of-line)
    (re-search-forward "\\([0-9\-]+\\)\\(\n\\)")
    (delete-region (match-beginning 1) (match-end 1))
    (setq hindo (nth 3 (wnn-server-word-info dict-no serial-no)))
    (goto-char (match-beginning 1))
    (insert (int-to-string hindo))
    (beginning-of-line)
    (setq buffer-read-only t)))


(defun diced-quit ()
  (interactive)
  (setq buffer-read-only nil)
  (erase-buffer)
  (setq buffer-read-only t)
  (bury-buffer (get-buffer "*Nihongo Dictionary Information*"))
  (set-window-configuration *diced-window-configuration*)
  )

(defun diced-execute (&optional display)
  (interactive)
  (goto-char (point-min))
  (let ((no  0))
    (while (not (eobp))
      (if (= (following-char) ?D)
	  (let* ((dict-item (nth no *diced-dict-info*))
		 (kanji (nth 0 dict-item))
		 (bunpo (nth 1 dict-item))
		 (hinshi (wnn-server-hinsi-name bunpo))
		 (hindo (nth 2 dict-item))
		 (dict-no (nth 3 dict-item))
		 (dict-name (wnn-dict-name dict-no (wnn-server-dict-list)))
		 (sys-dict-p (null (memq dict-no (wnn-server-hinsi-dicts -1))))
		 (serial-no (nth 4 dict-item))
		 )
	    (if (notify-yes-or-no-p (egg:msg-get 'remove-notify)
				kanji hinshi dict-name)
		(progn
		  (if (wnn-server-word-delete dict-no serial-no)
		      (notify (egg:msg-get 'removed)
			      kanji hinshi dict-name)
		    (egg:error (wnn-server-get-msg)))
		  ))))
      (setq no (1+ no))
      (forward-line 1)))
  (forward-line -1)
  (if (not display) (diced-redisplay)))

(defun diced-next-line ()
  (interactive)
  (beginning-of-line)
  (forward-line 1)
  (if (eobp) (progn (beep) (forward-line -1))))

(defun diced-end-of-buffer ()
  (interactive)
  (end-of-buffer)
  (forward-line -1))

(defun diced-scroll-down ()
  (interactive)
  (scroll-down)
  (if (eobp) (forward-line -1)))

(defun diced-mode ()
  "Mode for \"editing\" dictionaries.
In diced, you are \"editing\" a list of the entries in dictionaries.
You can move using the usual cursor motion commands.
Letters no longer insert themselves. Instead, 

Type  a to Add new entry.
Type  d to flag an entry for Deletion.
Type  n to move cursor to Next entry.
Type  p to move cursor to Previous entry.
Type  q to Quit from DicEd.
Type  C-u to Toggle the word to use/unuse.
Type  u to Unflag an entry (remove its D flag).
Type  x to eXecute the deletions requested.
"
 )

(defvar diced-mode-map (let ((map (make-keymap))) (suppress-keymap map) map))

(define-key diced-mode-map "a"    'diced-add)
(define-key diced-mode-map "d"    'diced-delete)
(define-key diced-mode-map "n"    'diced-next-line)
(define-key diced-mode-map "p"    'previous-line)
(define-key diced-mode-map "q"    'diced-quit)
;(define-key diced-mode-map "t"    'diced-use)
(define-key diced-mode-map "u"    'diced-undelete)
(define-key diced-mode-map "x"    'diced-execute)

(define-key diced-mode-map "\C-h" 'help-command)
(define-key diced-mode-map "\C-n" 'diced-next-line)
(define-key diced-mode-map "\C-p" 'previous-line)
(define-key diced-mode-map "\C-u" 'diced-use)
(define-key diced-mode-map "\C-v" 'scroll-up)
(define-key diced-mode-map "\eh"  'diced-hindo-set)
(define-key diced-mode-map "\e<"  'beginning-of-buffer)
(define-key diced-mode-map "\e>"  'diced-end-of-buffer)
(define-key diced-mode-map "\ev"  'diced-scroll-down)


;;;
;;; set comment on dictionary
;;;

(defun set-dict-comment ()
  (interactive)
  (if (null (wnn-server-isconnect)) (EGG:open-wnn))
  (wnn-server-set-rev nil)
  (let*((dic-list (wnn-server-dict-list))
	(writable-dic-list (wnn-server-hinsi-dicts -1))
	(dict-no
	 (menu:select-from-menu
	  (list 'menu (egg:msg-get 'jishomei)
		(mapcar '(lambda (x)
			   (let ((y (assoc x dic-list)))
			     (cons (nth 1 y) (nth 0 y))))
			writable-dic-list))))
	(comment (read-from-minibuffer (egg:msg-get 'comment)
				       (wnn-dict-name dict-no dic-list))))
    (if (wnn-server-dict-comment dict-no comment)
	(notify (egg:msg-get 'jisho-comment)
		(wnn-dict-name dict-no dic-list) comment)
      (egg:error (wnn-server-get-msg)))))


;;;
;;; Pure inspect facility
;;;

(defun henkan-inspect-bunsetu ()
  (interactive)
  (let ((info (wnn-server-inspect *bunsetu-number*)))
    (if (null info)
	(notify (wnn-server-get-msg))
      (progn
	(let ((dic-list (wnn-server-dict-list)))
	  (if (null dic-list)
	      (notify (wnn-server-get-msg))
	    (progn
	      (let ((hinsi (wnn-server-hinsi-name (nth 4 info)))
		    (kanji (nth 0 info))
		    (yomi (nth 1 info))
		    (serial   (nth 3 info))
		    (hindo    (nth 5 info))
		    (jisho (wnn-dict-name (nth 2 info) dic-list))
		    (ima (nth 6 info))
		    (hyoka (nth 7 info))
		    (daihyoka (nth 8 info))
		    (kangovect (nth 9 info)))
		(notify-internal
		 (format "%s %s(%s %s:%s Freq:%s%s) S:%s D:%s V:%s "
			 kanji yomi hinsi jisho serial 
			 (if (= ima 1) "*" " ")
			 hindo hyoka daihyoka kangovect)
		 t)))))))))


