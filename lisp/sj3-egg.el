;; Kana Kanji Conversion Protocol Package for Egg
;; Coded by K.Ishii, Sony Corp. (kiyoji@sm.sony.co.jp)

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


;;;
;;; sj3-egg.el 
;;;
;;; 「たまご」の sj3 バージョン
;;; かな漢字変換サーバに sj3serv を使います。
;;;
;;; sj3-egg に関する提案、虫情報は kiyoji@sm.sony.co.jp にお送り下さい。
;;;
;;;                      〒 141 東京都品川区東五反田1-22-1 五反田 AN ビル
;;;                      ソニー株式会社パーソナルインフォメーション事業本部
;;;
;;;                                                石井 清次

(provide 'sj3-egg)
(if (not (boundp 'SJ3))
    (require 'sj3-client))

;;;;  修正メモ；；
;;;; Jul-20-93 by age@softlab.is.tsukuba.ac.jp (Eiji FURUKAWA)
;;;;  Bug fixed in diced-add, *sj3-bunpo-menu* and
;;;;  set-egg-henkan-mode-format.

;;;; Mar-19-93 by K.Ishii
;;;;  DicEd is changed, edit-dict-item -> edit-dict

;;;; Aug-6-92 by K.Ishii
;;;;  length を string-width に変更

;;;; Jul-30-92 by K.Ishii
;;;;  set-default-usr-dic-directory で作る辞書ディレクトリ名の修正
;;;;  jserver-host-name, 環境変数 JSERVER の削除
;;;;  

;;;; Jul-7-92 by Y.Kawabe
;;;;  jserver-host-name をセットする際に環境変数 SJ3SERV も調べる。
;;;;  sj3fns.el のロードをやめる。

;;;; Jun-2-92 by K.Ishii
;;;;  sj3-egg.el を wnn-egg.el と同様に分割

;;;; May-14-92 by K.Ishii
;;;;  Mule の wnn-egg.el を sj3serv との通信用に修正

;;;----------------------------------------------------------------------
;;;
;;; Version control routine
;;;
;;;----------------------------------------------------------------------

(defvar sj3-egg-version "2.04" "Version number of this version of Egg. ")
;;; Last modified date: Wed Jul 21 17:54:20 1993

(and (equal (user-full-name) "Kiyoji Ishii")
     (defun sj3-egg-version-update (arg)
       (interactive "P")
       (if (equal (buffer-name (current-buffer)) "sj3-egg.el")
	   (save-excursion
	    (goto-char (point-min))
	    (re-search-forward "(defvar sj3-egg-version \"[0-9]+\\.")
	    (let ((point (point))
		  (minor))
	      (search-forward "\"")
	      (backward-char 1)
	      (setq minor (string-to-int (buffer-substring point (point))))
	      (delete-region point (point))
	      (if (<= minor 8) (insert "0"))
	      (insert  (int-to-string (1+ minor)))
	      (re-search-forward "Last modified date: ")
	      (kill-line)
	      (insert (current-time-string)))
	    (save-buffer)
	    (if arg (byte-compile-file (buffer-file-name)))
	 )))
     )

;;;----------------------------------------------------------------------
;;;
;;; KKCP package: Kana Kanji Conversion Protocol
;;;
;;; KKCP to SJ3SERV interface; 
;;;
;;;----------------------------------------------------------------------

(defvar *KKCP:error-flag* t)

(defun KKCP:error (errorCode &rest form)
  (cond((eq errorCode ':SJ3_SOCK_OPEN_FAIL)
	(notify "EGG: %s 上に SJ3SERV がありません。" (or (get-sj3-host-name) "local"))
	(if debug-on-error
	    (error "EGG: No SJ3SERV on %s is running." (or (get-sj3-host-name) "local"))
	  (error  "EGG: %s 上に SJ3SERV がありません。" (or (get-sj3-host-name) "local"))))
       ((eq errorCode ':SJ3_SERVER_DEAD)
	(notify "EGG: %s 上のSJ3SERV が死んでいます。" (or (get-sj3-host-name) "local"))
	(if debug-on-error
	    (error "EGG: SJ3SERV on %s is dead." (or (get-sj3-host-name) "local"))
	  (error  "EGG: %s 上の SJ3SERV が死んでいます。" (or (get-sj3-host-name) "local"))))
       ((and (consp errorCode)
	     (eq (car errorCode) ':SJ3_UNKNOWN_HOST))
	(notify "EGG: ホスト %s がみつかりません。" (car(cdr errorCode)))
	(if debug-on-error
	    (error "EGG: Host %s is unknown." (car(cdr errorCode)))
	  (error "EGG: ホスト %s がみつかりません。" (car(cdr errorCode)))))
       ((and (consp errorCode)
	     (eq (car errorCode) ':SJ3_UNKNOWN_SERVICE))
	(notify "EGG: Network service %s がみつかりません。" (car(cdr errorCode)))
	(if debug-on-error
	    (error "EGG: Service %s is unknown." (car(cdr errorCode)))
	  (error "EGG: Network service %s がみつかりません。" (cdr errorCode))))
       (t
	(notify "KKCP: 原因 %s で %s に失敗しました。" errorCode form)
	(if debug-on-error
	    (error "KKCP: %s failed because of %s." form errorCode)
	  (error  "KKCP: 原因 %s で %s に失敗しました。" errorCode form)))))

(defun KKCP:server-open (hostname loginname)
  (let ((result (sj3-server-open hostname loginname)))
    (cond((null sj3-error-code) result)
	 (t (KKCP:error sj3-error-code 'KKCP:server-open hostname loginname)))))

(defun KKCP:use-dict (dict &optional passwd)
  (let ((result (sj3-server-open-dict dict passwd)))
    (cond((null sj3-error-code) result)
	 ((eq sj3-error-code ':sj3-no-connection)
	  (EGG:open-sj3)
	  (KKCP:use-dict dict passwd))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error sj3-error-code 
			'kkcp:use-dict dict)))))

(defun KKCP:make-dict (dict)
  (let ((result (sj3-server-make-dict dict)))
    (cond((null sj3-error-code) result)
	 ((eq sj3-error-code ':sj3-no-connection)
	  (EGG:open-sj3)
	  (KKCP:make-dict dict))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error sj3-error-code 
			'kkcp:make-dict dict)))))

(defun KKCP:use-stdy (stdy)
  (let ((result (sj3-server-open-stdy stdy)))
    (cond((null sj3-error-code) result)
	 ((eq sj3-error-code ':sj3-no-connection)
	  (EGG:open-sj3)
	  (KKCP:use-stdy stdy))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error sj3-error-code 
			'kkcp:use-stdy stdy)))))

(defun KKCP:make-stdy (stdy)
  (let ((result (sj3-server-make-stdy stdy)))
    (cond((null sj3-error-code) result)
	 ((eq sj3-error-code ':sj3-no-connection)
	  (EGG:open-sj3)
	  (KKCP:make-stdy stdy))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error sj3-error-code 
			'kkcp:make-stdy stdy)))))

(defun KKCP:henkan-begin (henkan-string)
  (let ((result (sj3-server-henkan-begin henkan-string)))
    (cond((null sj3-error-code) result)
	 ((eq sj3-error-code ':sj3-no-connection)
	  (EGG:open-sj3)
	  (KKCP:henkan-begin henkan-string))
	 ((null *KKCP:error-flag*) result)
	 (t (KKCP:error sj3-error-code 'KKCP:henkan-begin henkan-string)))))

(defun KKCP:henkan-next (bunsetu-no)
  (let ((result (sj3-server-henkan-next bunsetu-no)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:henkan-next bunsetu-no))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:henkan-next bunsetu-no)))))

(defun KKCP:henkan-kakutei (bunsetu-no jikouho-no)
  ;;; NOTE: 次候補リストが設定されていることを確認して使用すること。
  (let ((result (sj3-server-henkan-kakutei bunsetu-no jikouho-no)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:henkan-kakutei bunsetu-no jikouho-no))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:henkan-kakutei bunsetu-no jikouho-no)))))

(defun KKCP:bunsetu-henkou (bunsetu-no bunsetu-length)
  (let ((result (sj3-server-bunsetu-henkou bunsetu-no bunsetu-length)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:bunsetu-henkou bunsetu-no bunsetu-length))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'kkcp:bunsetu-henkou bunsetu-no bunsetu-length)))))


(defun KKCP:henkan-quit ()
  (let ((result (sj3-server-henkan-quit)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:henkan-quit))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:henkan-quit)))))

(defun KKCP:henkan-end (&optional bunsetuno)
  (let ((result (sj3-server-henkan-end bunsetuno)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:henkan-end bunsetuno))	  
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:henkan-end)))))

(defun KKCP:dict-add (dictno kanji yomi bunpo)
  (let ((result (sj3-server-dict-add dictno kanji yomi bunpo)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:dict-add dictno kanji yomi bunpo))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:dict-add dictno kanji yomi bunpo)))))

(defun KKCP:dict-delete (dictno kanji yomi bunpo)
  (let ((result (sj3-server-dict-delete dictno kanji yomi bunpo)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:dict-delete dictno kanji yomi bunpo))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:dict-delete dictno kanji yomi bunpo)))))

(defun KKCP:dict-info (dictno)
  (let ((result (sj3-server-dict-info dictno)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:dict-info dictno))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:dict-info dictno)))))

(defun KKCP:make-directory (pathname)
  (let ((result (sj3-server-make-directory pathname)))
    (cond ((null sj3-error-code) result)
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:make-directory pathname))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'kkcp:make-directory pathname)))))

(defun KKCP:file-access (pathname mode)
  (let ((result (sj3-server-file-access pathname mode)))
    (cond ((null sj3-error-code)
	   (if (= result 0) t nil))
	  ((eq sj3-error-code ':sj3-no-connection)
	   (EGG:open-sj3)
	   (KKCP:file-access pathname mode))
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'kkcp:file-access pathname mode)))))

(defun KKCP:server-close ()
  (let ((result (sj3-server-close)))
    (cond ((null sj3-error-code) result)
	  ((null *KKCP:error-flag*) result)
	  (t (KKCP:error sj3-error-code 'KKCP:server-close)))))

;;;----------------------------------------------------------------------
;;;
;;; Kana Kanji Henkan 
;;;
;;;----------------------------------------------------------------------

;;;
;;; Entry functions for egg-startup-file
;;;

(defvar *default-sys-dic-directory* "/usr/sony/dict/sj3")

(defun set-default-sys-dic-directory (pathname)
  "システム辞書の標準directory PATHNAMEを指定する。
PATHNAMEは環境変数を含んでよい。"

  (setq pathname (substitute-in-file-name pathname))

  (if (not (file-name-absolute-p pathname))
      (error "Default directory must be absolute pathname")
    (if (null (KKCP:file-access pathname 0))
	(error 
	 (format "System Default directory(%s) がありません。" pathname))
      (setq *default-sys-dic-directory* (file-name-as-directory pathname)))))

(defvar *default-usr-dic-directory* "/usr/sony/dict/sj3/user/$USER")

(defun set-default-usr-dic-directory (pathname)
  "利用者辞書の標準directory PATHNAMEを指定する。
PATHNAMEは環境変数を含んでよい。"

  (setq pathname (file-name-as-directory (substitute-in-file-name pathname)))

  (if (not (file-name-absolute-p pathname))
      (error "Default directory must be absolute pathname")
    (if (null (KKCP:file-access  pathname 0))
	(let ((updir (file-name-directory (substring pathname 0 -1))))
	  (if (null (KKCP:file-access updir 0))
	      (error 
	       (format "User Default directory(%s) がありません。" pathname))
	    (if (yes-or-no-p (format "User Default directory(%s) を作りますか？" pathname))
		(progn
		  (KKCP:make-directory (directory-file-name pathname))
		  (notify "User Default directory(%s) を作りました。" pathname))
	      nil ;;; do nothing
	      ))))
      (setq *default-usr-dic-directory* pathname)))

(defun setsysdic (dict)
  (let ((dictfile
	 (concat (if (not (file-name-absolute-p dict)) 
		     *default-sys-dic-directory*
		   "")
		 dict)))
    (egg:setsysdict (expand-file-name dictfile))))

(defun setusrdic (dict)
  (let ((dictfile
	 (concat (if (not (file-name-absolute-p dict))
		     *default-usr-dic-directory*
		   "")
		 dict)))
  (egg:setusrdict (expand-file-name dictfile))))

(defvar egg:*dict-list* nil)

(defun setusrstdy (stdy)
  (let ((stdyfile
	 (concat (if (not (file-name-absolute-p stdy))
		     *default-usr-dic-directory*
		   "")
		 stdy)))
  (egg:setusrstdy (expand-file-name stdyfile))))

(defun egg:setsysdict (dict)
  (cond((assoc (file-name-nondirectory dict) egg:*dict-list*)
	(beep)
	(notify "既に同名のシステム辞書 %s が登録されています。"
		(file-name-nondirectory dict))
	)
       ((null (KKCP:file-access dict 0))
	(beep)
	(notify "システム辞書 %s がありません。" dict))
       (t(let* ((*KKCP:error-flag* nil)
		(rc (KKCP:use-dict dict)))
	   (if (null rc)
	       (error "EGG: setsysdict failed. :%s" dict)
	       (setq egg:*dict-list*
		     (cons (cons (file-name-nondirectory dict) dict)
			   egg:*dict-list*)))))))

;;; dict-no --> dict-name
(defvar egg:*usr-dict* nil)

;;; dict-name --> dict-no
(defvar egg:*dict-menu* nil)

(defmacro push-end (val loc)
  (list 'push-end-internal val (list 'quote loc)))

(defun push-end-internal (val loc)
  (set loc
       (if (eval loc)
	   (nconc (eval loc) (cons val nil))
	 (cons val nil))))

(defun egg:setusrdict (dict)
  (cond((assoc (file-name-nondirectory dict) egg:*dict-list*)
	(beep)
	(notify "既に同名の利用者辞書 %s が登録されています。"
		(file-name-nondirectory dict))
	)
       ((null (KKCP:file-access dict 0))
	(notify "利用者辞書 %s がありません。" dict)
	(if (yes-or-no-p (format "利用者辞書 %s を作りますか？" dict))
	    (let ((*KKCP:error-flag* nil))
	      (if (KKCP:make-dict dict)
		  (progn
		    (notify "利用者辞書 %s を作りました。" dict)
		    (let* ((*KKCP:error-flag* nil)
			   (dict-no (KKCP:use-dict dict "")))
		      (cond((numberp dict-no)
			    (setq egg:*usr-dict* 
				  (cons (cons dict-no dict) egg:*usr-dict*))
			    (push-end (cons (file-name-nondirectory dict)
					    dict-no) egg:*dict-menu*))
			   (t (error "EGG: setusrdict failed. :%s" dict)))))
		(error "EGG: setusrdict failed. : %s" dict)))))
       (t (let* ((*KKCP:error-flag* nil)
		 (dict-no (KKCP:use-dict dict "")))
	    (cond((numberp dict-no)
		  (setq egg:*usr-dict* (cons(cons dict-no dict) 
					    egg:*usr-dict*))
		  (push-end (cons (file-name-nondirectory dict) dict-no)
			    egg:*dict-menu*)
		  (setq egg:*dict-list*
			(cons (cons (file-name-nondirectory dict) dict)
			      egg:*dict-list*)))
		 (t (error "EGG: setusrdict failed. : %s" dict)))))))

(defun egg:setusrstdy (stdy)
  (cond((null (KKCP:file-access stdy 0))
	(notify "学習ファイル %s がありません。" stdy)
	(if (yes-or-no-p (format "学習ファイル %s を作りますか？" stdy))
	    (if (null (KKCP:make-stdy stdy))
		(error "EGG: setusrstdy failed. : %s" stdy)
	      (notify "学習ファイル %s を作りました。" stdy)
	      (if (null (KKCP:use-stdy stdy))
		  (error "EGG: setusrstdy failed. : %s" stdy))
	      )))
	(t (if (null (KKCP:use-stdy stdy))
	       (error "EGG: setusrstdy failed. : %s" stdy)))))


;;;
;;; SJ3 interface
;;;

(defun get-sj3-host-name ()
  (cond((and (boundp 'sj3-host-name) (stringp sj3-host-name))
	sj3-host-name)
       ((and (boundp 'sj3serv-host-name) (stringp sj3serv-host-name))
	sj3serv-host-name)
       (t(getenv "SJ3SERV"))))				; 92.7.7 by Y.Kawabe

(fset 'get-sj3serv-host-name (symbol-function 'get-sj3-host-name))

(defun set-sj3-host-name (name)
  (interactive "sHost name: ")
  (let ((*KKCP:error-flag* nil))
    (disconnect-sj3))
  (setq sj3-host-name name)
  )

(defvar egg-default-startup-file "eggrc-sj3"
  "*Egg startup file name (system default)")

(defvar egg-startup-file ".eggrc-sj3"
  "*Egg startup file name.")

(defvar egg-startup-file-search-path (append '("~" ".") load-path)
  "*List of directories to search for start up file to load.")

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

(defun EGG:open-sj3 ()
  (KKCP:server-open (or (get-sj3-host-name) (system-name))
  		    (user-login-name))
  (setq egg:*usr-dict* nil
	egg:*dict-list* nil
	egg:*dict-menu* nil)
  (notify "ホスト %s の SJ3 を起動しました。" (or (get-sj3-host-name) "local"))
  (let ((eggrc (or (egg:search-file egg-startup-file egg-startup-file-search-path)
		   (egg:search-file egg-default-startup-file load-path))))
    (if eggrc (load-file eggrc)
      (progn
	(KKCP:server-close)
	(error "eggrc-search-path 上に egg-startup-file がありません。")))))

(defun disconnect-sj3 ()
  (interactive)
  (KKCP:server-close))

(defun close-sj3 ()
  (interactive)
  (KKCP:server-close))

;;;
;;; Kanji henkan
;;;

(defvar egg:*kanji-kanabuff* nil)

(defvar *bunsetu-number* nil)

(defun bunsetu-su ()
  (sj3-bunsetu-suu))

(defun bunsetu-length (number)
  (sj3-bunsetu-yomi-moji-suu number))

(defun kanji-moji-suu (str)
  (let ((max (length str)) (count 0) (i 0))
    (while (< i max)
      (setq count (1+ count))
      (if (< (aref str i) 128) (setq i (1+ i)) (setq i (+ i 3))))
    count))

(defun bunsetu-position (number)
  (let ((pos egg:*region-start*) (i 0))
    (while (< i number)
      (setq pos (+ pos (bunsetu-kanji-length  i) (length egg:*bunsetu-kugiri*)))
      (setq i (1+ i)))
    pos))

(defun bunsetu-kanji-length (bunsetu-no)
  (sj3-bunsetu-kanji-length bunsetu-no))

(defun bunsetu-kanji (number)
  (sj3-bunsetu-kanji number))

(defun bunsetu-kanji-insert (bunsetu-no)
  (sj3-bunsetu-kanji bunsetu-no (current-buffer)))

(defun bunsetu-set-kanji (bunsetu-no kouho-no) 
  (sj3-server-henkan-kakutei bunsetu-no kouho-no))

(defun bunsetu-yomi  (number) 
  (sj3-bunsetu-yomi number))

(defun bunsetu-yomi-insert (bunsetu-no)
  (sj3-bunsetu-yomi bunsetu-no (current-buffer)))

(defun bunsetu-yomi-equal (number yomi)
  (sj3-bunsetu-yomi-equal number yomi))

(defun bunsetu-kouho-suu (bunsetu-no)
  (let ((no (sj3-bunsetu-kouho-suu bunsetu-no)))
    (if (< 1 no) no
      (KKCP:henkan-next bunsetu-no)
      (sj3-bunsetu-kouho-suu bunsetu-no))))

(defun bunsetu-kouho-list (number) 
  (let ((no (bunsetu-kouho-suu number)))
    (if (= no 1)
	(KKCP:henkan-next number))
    (sj3-bunsetu-kouho-list number)))

(defun bunsetu-kouho-number (bunsetu-no)
  (sj3-bunsetu-kouho-number bunsetu-no))

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

(defvar henkan-mode-indicator "漢")

(defun henkan-region-internal (start end)
  "regionをかな漢字変換する。"
  (setq egg:*kanji-kanabuff* (buffer-substring start end))
  (if overwrite-mode
      (setq egg:*overwrite-mode-deleted-chars* 
	    (if egg:*henkan-fence-mode* 0
	      (length egg:*kanji-kanabuff*))))
  (setq *bunsetu-number* nil)
  (let ((result (KKCP:henkan-begin egg:*kanji-kanabuff*)))
    (if  result
	(progn
	  (mode-line-egg-mode-update henkan-mode-indicator)
	  (goto-char start)
	  (if (null (marker-position egg:*region-start*))
	      (progn
		;;;(setq egg:*global-map-backup* (current-global-map))
		(setq egg:*local-map-backup* (current-local-map))
		(and (boundp 'disable-undo) (setq disable-undo t))
		(goto-char start)
		(delete-region start end)
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
	      (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*fence-close*)))
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
	  (henkan-insert-kouho 0)
	  (henkan-goto-bunsetu 0)
	  ;;;(use-global-map henkan-mode-map)
	  ;;;(use-local-map nil)
	  (use-local-map henkan-mode-map)
	  )))
  )

(defun henkan-paragraph ()
  "Kana-kanji henkan  paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (henkan-region-internal (point) end ))))

(defun henkan-sentence ()
  "Kana-kanji henkan sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (henkan-region-internal (point) end ))))

(defun henkan-word ()
  "Kana-kanji henkan word at or after point."
  (interactive)
  (save-excursion
    (re-search-backward "\\b\\w" nil t)
    (let ((start (point)))
      (re-search-forward "\\w\\b" nil t)
      (henkan-region-internal start (point)))))

;;;
;;; Kana Kanji Henkan Henshuu mode
;;;

(defconst egg:*bunsetu-kugiri* " " "*文節の区切りを示す文字列")
(defconst egg:*bunsetu-attribute* nil "*文節表示に用いるattribute または nil")

(defconst egg:*henkan-attribute* nil "*変換領域を表示するattribute または nil")
(defconst egg:*henkan-open*  "|" "*変換の始点を示す文字列")
(defconst egg:*henkan-close* "|" "*変換の終点を示す文字列")

(defun set-egg-henkan-mode-format (open close kugiri &optional attr1 attr2)
   "変換 mode の表示方法を設定する。OPEN は変換の始点を示す文字列または nil。\n\
CLOSEは変換の終点を示す文字列または nil。\n\
KUGIRIは文節の区切りを表示する文字列または nil。\n\
optional ATTR1 は変換区間を表示する属性 または nil（x11term のみで有効）\n\
optional ATTR2 は文節区間を表示する属性 または nil（x11term のみで有効）"

  (interactive (list (read-string "変換開始文字列: ")
		     (read-string "変換終了文字列: ")
		     (read-string "文節区切り文字列: ")
		     (cdr (assoc (completing-read "変換区間表示属性: " egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     (cdr (assoc (completing-read "文節区間表示属性: " egg:*attribute-alist*)
				 egg:*attribute-alist*))
		     ))

  (if (and (or (stringp open)  (null open))
	   (or (stringp close) (null close))
	   (or (stringp kugiri) (null kugiri))
	   (egg:member attr1 '(underline inverse bold nil))
	   (egg:member attr2 '(underline inverse bold nil)))
      (progn
	(setq egg:*henkan-open* open
	      egg:*henkan-close* close
	      egg:*bunsetu-kugiri* (or kugiri "")
	      egg:*henkan-attribute* attr1
	      egg:*bunsetu-attribute* attr2)
	(if (or attr1 attr2) (require 'attribute))
	nil)
    (error "Wrong type of arguments: %1 %2 %3 %4 %5" open close kugiri attr1 attr2)))

(defun henkan-insert-kouho (bunsetu-no)
  (let ((max (bunsetu-su)) (i bunsetu-no))
    (while (< i max)
      (bunsetu-kanji-insert i) 
      (insert  egg:*bunsetu-kugiri* )
      (setq i (1+ i)))
    (if (< bunsetu-no max) (delete-char (- (length egg:*bunsetu-kugiri*))))))

(defun henkan-kakutei ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region (- egg:*region-start* (length egg:*henkan-open*))
		 egg:*region-start*)
  (delete-region egg:*region-start* egg:*region-end*)
  (delete-region egg:*region-end* (+ egg:*region-end* (length egg:*henkan-close*)))
  (goto-char egg:*region-start*)
  (let ((i 0) (max (bunsetu-su)))
    (while (< i max)
      ;;;(KKCP:henkan-kakutei i (bunsetu-kouho-number i))
      (bunsetu-kanji-insert i)
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (KKCP:henkan-end)
  (egg:quit-egg-mode)
  )

(defun henkan-kakutei-before-point ()
  (interactive)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-off)
  (delete-region egg:*region-start* egg:*region-end*)
  (goto-char egg:*region-start*)
  (let ((i 0) (max *bunsetu-number*))
    (while (< i max)
      ;;;(KKCP:henkan-kakutei i (bunsetu-kouho-number i))
      (bunsetu-kanji-insert i)
      (if (not overwrite-mode)
	  (undo-boundary))
      (setq i (1+ i))
      ))
  (KKCP:henkan-end *bunsetu-number*)
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
	(i *bunsetu-number*) (max (bunsetu-su)))
    (while (< i max)
      (bunsetu-yomi-insert i)
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

(defun egg:set-region-attribute (attr on)
  (if attr 
      (attribute-on-off-region attr egg:*region-start* egg:*region-end* on)))

(defun egg:set-bunsetu-attribute (no attr switch)
  (if (and no attr)
      (attribute-on-off-region
       attr
       (if (eq attr 'inverse)
	   (let ((point (bunsetu-position no)))
	     (+ point (1+ (char-boundary-p point))))
	 (bunsetu-position no))

       (if (= no (1- (bunsetu-su)))
	   egg:*region-end*
	 (- (bunsetu-position (1+ no))
	    (length egg:*bunsetu-kugiri*)))
       switch)))

(defun egg:bunsetu-attribute-on (no)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute* t))

(defun egg:bunsetu-attribute-off (no)
  (egg:set-bunsetu-attribute no egg:*bunsetu-attribute* nil))

(defun henkan-goto-bunsetu (number)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-on)
  (setq *bunsetu-number*
	(check-number-range number 0 (1- (bunsetu-su))))
  (goto-char (bunsetu-position *bunsetu-number*))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
  (egg:bunsetu-attribute-on *bunsetu-number*)
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
  (henkan-goto-bunsetu (1- (bunsetu-su)))
  )
 
(defun check-number-range (i min max)
  (cond((< i min) max)
       ((< max i) min)
       (t i)))

(defun henkan-hiragana ()
  (interactive)
  (henkan-goto-kouho (- (bunsetu-kouho-suu *bunsetu-number*) 1)))

(defun henkan-katakana ()
  (interactive)
  (henkan-goto-kouho (- (bunsetu-kouho-suu *bunsetu-number*) 2)))

(defun henkan-next-kouho ()
  (interactive)
  (henkan-goto-kouho (1+ (bunsetu-kouho-number *bunsetu-number*))))

(defun henkan-previous-kouho ()
  (interactive)
  (henkan-goto-kouho (1- (bunsetu-kouho-number *bunsetu-number*))))

(defun henkan-goto-kouho (kouho-number)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (egg:henkan-attribute-on)
  (let ((point (point))
	(yomi  (bunsetu-yomi *bunsetu-number*))
	(i *bunsetu-number*)
	(max (bunsetu-su)))
    (setq kouho-number 
	  (check-number-range kouho-number 
			      0
			      (1- (bunsetu-kouho-suu *bunsetu-number*))))
    (while (< i max)
      (if (bunsetu-yomi-equal i yomi)
	  (let ((p1 (bunsetu-position i)))
	    (delete-region p1
			   (+ p1 (bunsetu-kanji-length i)))
	    (goto-char p1)
	    (bunsetu-set-kanji i kouho-number)
	    (bunsetu-kanji-insert i)))
      (setq i (1+ i)))
    (goto-char point))
  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
  (egg:bunsetu-attribute-on *bunsetu-number*))

(defun henkan-bunsetu-chijime ()
  (interactive)
  (or (= (bunsetu-length *bunsetu-number*) 1)
      (bunsetu-length-henko (1-  (bunsetu-length *bunsetu-number*)))))

(defun henkan-bunsetu-nobasi ()
  (interactive)
  (if (not (= (1+ *bunsetu-number*) (bunsetu-su)))
      (bunsetu-length-henko (1+ (bunsetu-length *bunsetu-number*)))))

(defun henkan-saishou-bunsetu ()
  (interactive)
  (bunsetu-length-henko 1))

(defun henkan-saichou-bunsetu ()
  (interactive)
  (let ((max (bunsetu-su)) (i *bunsetu-number*)
	(l 0))
    (while (< i max)
      (setq l (+ l (bunsetu-length i)))
      (setq i (1+ i)))
    (bunsetu-length-henko l)))

(defun bunsetu-length-henko (length)
  (egg:henkan-attribute-off)
  (egg:bunsetu-attribute-off *bunsetu-number*)
  (let ((r (KKCP:bunsetu-henkou *bunsetu-number* length)))
    (cond(r
	  (delete-region 
	   (bunsetu-position *bunsetu-number*) egg:*region-end*)
	  (goto-char (bunsetu-position *bunsetu-number*))
	  (henkan-insert-kouho *bunsetu-number*)
	  (henkan-goto-bunsetu *bunsetu-number*))
	 (t
	  (egg:henkan-attribute-on)
	  (egg:set-bunsetu-attribute *bunsetu-number* egg:*henkan-attribute* nil)
	  (egg:bunsetu-attribute-on *bunsetu-number*)))))

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
  (KKCP:henkan-quit)
  (setq egg:*mode-on* t)
  ;;;(use-global-map fence-mode-map)
  ;;;(use-local-map  nil)
  (use-local-map fence-mode-map)
  (egg:mode-line-display)
  )

(defun henkan-select-kouho ()
  (interactive)
  (if (not (eq (selected-window) (minibuffer-window)))
      (let ((kouho-list (bunsetu-kouho-list *bunsetu-number*))
	    menu)
	(setq menu
	      (list 'menu "次候補:"
		    (let ((l kouho-list) (r nil) (i 0))
		      (while l
			(setq r (cons (cons (car l) i) r))
			(setq i (1+ i))
			(setq l (cdr l)))
		      (reverse r))))
	(henkan-goto-kouho 
	 (menu:select-from-menu menu 
			       (bunsetu-kouho-number *bunsetu-number*))))
    (beep)))

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
	
(define-key henkan-mode-map "\e"    henkan-mode-esc-map)
(define-key henkan-mode-map "\ei"  'undefined) ;; henkan-inspect-bunsetu
					       ;; not support for sj3
(define-key henkan-mode-map "\es"  'henkan-select-kouho)
(define-key henkan-mode-map "\eh"  'henkan-hiragana)
(define-key henkan-mode-map "\ek"  'henkan-katakana)
(define-key henkan-mode-map "\e<"  'henkan-saishou-bunsetu)
(define-key henkan-mode-map "\e>"  'henkan-saichou-bunsetu)
(define-key henkan-mode-map " "    'henkan-next-kouho)
(define-key henkan-mode-map "\C-@" 'henkan-next-kouho)
(define-key henkan-mode-map "\C-a" 'henkan-first-bunsetu)
(define-key henkan-mode-map "\C-b" 'henkan-backward-bunsetu)
(define-key henkan-mode-map "\C-c" 'henkan-quit)
(define-key henkan-mode-map "\C-d" 'undefined)
(define-key henkan-mode-map "\C-e" 'henkan-last-bunsetu)
(define-key henkan-mode-map "\C-f" 'henkan-forward-bunsetu)
(define-key henkan-mode-map "\C-g" 'henkan-quit)
(define-key henkan-mode-map "\C-h" 'help-command)
(define-key henkan-mode-map "\C-i" 'henkan-bunsetu-chijime)
(define-key henkan-mode-map "\C-j" 'undefined)
(define-key henkan-mode-map "\C-k" 'henkan-kakutei-before-point)
(define-key henkan-mode-map "\C-l" 'henkan-kakutei)
(define-key henkan-mode-map "\C-m" 'henkan-kakutei)
(define-key henkan-mode-map "\C-n" 'henkan-next-kouho)
(define-key henkan-mode-map "\C-o" 'henkan-bunsetu-nobasi)
(define-key henkan-mode-map "\C-p" 'henkan-previous-kouho)
(define-key henkan-mode-map "\C-q" 'undefined)
(define-key henkan-mode-map "\C-r" 'undefined)
(define-key henkan-mode-map "\C-s" 'undefined)
(define-key henkan-mode-map "\C-t" 'undefined)
(define-key henkan-mode-map "\C-u" 'undefined)
(define-key henkan-mode-map "\C-v" 'undefined)
(define-key henkan-mode-map "\C-w" 'undefined)
(define-key henkan-mode-map "\C-x" 'undefined)
(define-key henkan-mode-map "\C-y" 'undefined)
(define-key henkan-mode-map "\C-z" 'undefined)
(define-key henkan-mode-map "\177" 'henkan-quit)

(defun henkan-help-command ()
  "Display documentation fo henkan-mode."
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ (substitute-command-keys henkan-mode-document-string))
    (print-help-return-message)))

(defvar henkan-mode-document-string "漢字変換モード:
文節移動
  \\[henkan-first-bunsetu]\t先頭文節\t\\[henkan-last-bunsetu]\t後尾文節  
  \\[henkan-backward-bunsetu]\t直前文節\t\\[henkan-forward-bunsetu]\t直後文節
変換変更
  次候補    \\[henkan-previous-kouho]  \t前候補    \\[henkan-next-kouho]
  文節伸し  \\[henkan-bunsetu-nobasi]  \t文節縮め  \\[henkan-bunsetu-chijime]
  変換候補選択  \\[henkan-select-kouho]
変換確定
  全文節確定  \\[henkan-kakutei]  \t直前文節まで確定  \\[henkan-kakutei-before-point]
変換中止    \\[henkan-quit]
")
  
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
	 str))))

(defun toroku-region (start end)
  (interactive "r")
  (let*((kanji
	 (remove-regexp-in-string "[\0-\37]" (buffer-substring start end)))
	(yomi (read-hiragana-string
	       (format "辞書登録『%s』  読み :" kanji)))
	(type (menu:select-from-menu *sj3-bunpo-menu*))
	(dict-no 
	 (menu:select-from-menu (list 'menu "登録辞書名:" egg:*dict-menu*))))
    ;;;(if (string-match "[\0-\177]" kanji)
    ;;;	(error "Kanji string contains hankaku character. %s" kanji))
    ;;;(if (string-match "[\0-\177]" yomi)
    ;;;	(error "Yomi string contains hankaku character. %s" yomi))
    (KKCP:dict-add dict-no kanji yomi type)
    (let ((hinshi (nth 1 (assq type *sj3-bunpo-code*)))
	  (gobi   (nth 2 (assq type *sj3-bunpo-code*)))
	  (dict-name (cdr (assq dict-no egg:*usr-dict*))))
      (notify "辞書項目『%s』(%s: %s)を%sに登録しました。"
	      (if gobi (concat kanji " " gobi) kanji)
	      (if gobi (concat yomi  " " gobi) yomi)
	      hinshi dict-name))))



;;; (lsh 1 18)
(defvar *sj3-bunpo-menu*
  '(menu "品詞:"
   (("名詞"      . 1)
    ("代名詞"    . 12)
    ("苗字"      . 21)
    ("名前"      . 22)
    ("地名"      . 24)
    ("県/区名"   . 25)
    ("動詞"      .
	  (menu "品詞:動詞:"
		(("サ変語幹"      . 80)
		 ("ザ変語幹"      . 81)
		 ("一段不変化部"  . 90)
		 ("カ行五段語幹"  . 91)
		 ("ガ行五段語幹"  . 92)   
		 ("サ行五段語幹"  . 93)   
		 ("タ行五段語幹"  . 94)   
		 ("ナ行五段語幹"  . 95)   
		 ("バ行五段語幹"  . 96)   
		 ("マ行五段語幹"  . 97)   
		 ("ラ行五段語幹"  . 98)   
		 ("ワ行五段語幹"  . 99))))   
    ("連体詞"         . 26)
    ("接続詞"         . 27)
    ("助数詞"         . 29)
    ("数詞"           . 30)
    ("接頭語"         . 31)
    ("接尾語"         . 36)
    ("副詞"           . 45)
    ("形容詞語幹"     . 60)
    ("形容動詞語幹"   . 71)
    ("単漢字"         . 189))))

(defvar *sj3-bunpo-code*
  '(
    ( 1   "名詞" )
    ( 12  "代名詞" )
    ( 21  "苗字" )
    ( 22  "名前" )
    ( 24  "地名" )
    ( 25  "県/区名" )
    ( 26  "連体詞" )
    ( 27  "接続詞" )
    ( 29  "助数詞" )
    ( 30  "数詞"   )
    ( 31  "接頭語" )
    ( 36  "接尾語" )
    ( 45  "副詞" )
    ( 60  "形容詞語幹"           "い" ("" "" "" "" ""))
    ( 71  "形容動詞語幹"         "に" ("" "" "" "" "") )
    ( 80  "サ変語幹"             "する" ("" "" "" "" ""))
    ( 81  "ザ変語幹"             "ずる" ("" "" "" "" ""))
    ( 90  "一段不変化部"         "る" ("" "" "" "" ""))
    ( 91  "カ行五段語幹"         "く" ("かない" "きます" "く" "くとき" "け"))
    ( 92  "ガ行五段語幹"         "ぐ" ("がない" "ぎます" "" "" ""))
    ( 93  "サ行五段語幹"         "す" ("" "" "" "" ""))
    ( 94  "タ行五段語幹"         "つ" ("" "" "" "" ""))
    ( 95  "ナ行五段語幹"         "ぬ" ("" "" "" "" ""))   
    ( 96  "バ行五段語幹"         "ぶ" ("" "" "" "" ""))   
    ( 97  "マ行五段語幹"         "む" ("" "" "" "" ""))   
    ( 98  "ラ行五段語幹"         "る" ("" "" "" "" ""))   
    ( 99  "ワ行五段語幹"         "う" ("" "" "" "" ""))   
    ( 189  "単漢字"  )
    ( 190  "不定"  )
    ( 1000  "その他"  )
    ))

;;;
;;; 辞書編集系 DicEd
;;;

(defvar *diced-window-configuration* nil)

(defvar *diced-dict-info* nil)

(defvar *diced-dno* nil)

;;;;;
;;;;; User entry : edit-dict
;;;;;

(defun edit-dict ()
  (interactive)
  (let*((dict-no 
	 (menu:select-from-menu (list 'menu "辞書名:" egg:*dict-menu*)))
	(dict-name (file-name-nondirectory 
		    (cdr (assq dict-no egg:*usr-dict*))))
	(dict-info (KKCP:dict-info dict-no)))
    (if (null dict-info)
	(message "辞書: %s に登録されている項目はありません。" dict-name)
      (progn
	(setq *diced-dno* dict-no)
	(setq *diced-window-configuration* (current-window-configuration))
	(pop-to-buffer "*Nihongo Dictionary Information*")
	(setq major-mode 'diced-mode)
	(setq mode-name "Diced")
	(setq mode-line-buffer-identification 
	      (concat "DictEd: " dict-name
		      (make-string  
		       (max 0 (- 17 (string-width dict-name))) ?  )
		      ))
	(sit-for 0) ;; will redislay.
	;;;(use-global-map diced-mode-map)
	(use-local-map diced-mode-map)
	(diced-display dict-info)
	))))

(defun diced-redisplay ()
  (let ((dict-info (KKCP:dict-info *diced-dno*)))
    (if (null dict-info)
	(progn
	  (message "辞書: %s に登録されている項目はありません。"
		   (file-name-nondirectory 
		    (cdr (assq *diced-dno* egg:*usr-dict*))))
	  (diced-quit))
      (diced-display dict-info))))

(defun diced-display (dict-info)
	;;; (values (list (record yomi kanji bunpo)))
	;;;                         0    1     2
  (setq *diced-dict-info* dict-info)
  (setq buffer-read-only nil)
  (erase-buffer)
  (let ((l-yomi
	 (apply 'max
		(mapcar (function (lambda (l) (string-width (nth 0 l))))
			dict-info)))
	(l-kanji 
	 (apply 'max
		(mapcar (function (lambda (l) (string-width (nth 1 l))))
			dict-info))))
    (while dict-info
      (let*((yomi (nth 0 (car dict-info)))
	    (kanji (nth 1 (car dict-info)))
	    (bunpo (nth 2 (car dict-info)))
	    (gobi   (nth 2 (assq bunpo *sj3-bunpo-code*)))
	    (hinshi (nth 1 (assq bunpo *sj3-bunpo-code*))))

	(insert "  " yomi)
	(if gobi (insert " " gobi))
	(insert-char ?  
		     (- (+ l-yomi 10) (string-width yomi)
			(if gobi (+ 1 (string-width gobi)) 0)))
	(insert kanji)
	(if gobi (insert " " gobi))
	(insert-char ?  
		     (- (+ l-kanji 10) (string-width kanji)
			(if gobi (+ 1 (string-width gobi)) 0)))
	(insert hinshi ?\n)
	(setq dict-info (cdr dict-info))))
    (goto-char (point-min)))
  (setq buffer-read-only t))

(defun diced-add ()
  (interactive)
  (diced-execute t)
  (let*((kanji  (read-from-minibuffer "漢字："))
	(yomi  (read-from-minibuffer "読み："))
	(bunpo (menu:select-from-menu *sj3-bunpo-menu*))
	(gobi   (nth 2 (assq bunpo *sj3-bunpo-code*)))
	(hinshi (nth 1 (assq bunpo *sj3-bunpo-code*)))
	(item (if gobi (concat kanji " " gobi) kanji))
	(item-yomi (if gobi (concat yomi " " gobi) yomi))
	(dict-name (cdr (assq *diced-dno* egg:*usr-dict*))))
    (if (notify-yes-or-no-p "辞書項目『%s』(%s: %s)を%sに登録します。" 
	      item item-yomi hinshi (file-name-nondirectory dict-name))
	(progn
	  (KKCP:dict-add *diced-dno* kanji yomi bunpo)
	  (notify "辞書項目『%s』(%s: %s)を%sに登録しました。" 
		  item item-yomi hinshi dict-name)
	  (diced-redisplay)))))
	      
(defun diced-delete ()
  (interactive)
  (beginning-of-line)
  (if (= (following-char) ?  )
      (let ((buffer-read-only nil))
	(delete-char 1) (insert "D") (backward-char 1))))
    
(defun diced-undelete ()
  (interactive)
  (beginning-of-line)
  (if (= (following-char) ?D)
      (let ((buffer-read-only nil))
	(delete-char 1) (insert " ") (backward-char 1))
    (beep)))

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
		 (yomi (nth 0 dict-item))
		 (kanji (nth 1 dict-item))
		 (bunpo (nth 2 dict-item))
		 (gobi   (nth 2 (assq bunpo *sj3-bunpo-code*)))
		 (hinshi (nth 1 (assq bunpo *sj3-bunpo-code*)))
		 (dict-name (cdr (assq *diced-dno* egg:*usr-dict*)))
		 (item (if gobi (concat kanji " " gobi) kanji))
		 (item-yomi (if gobi (concat yomi " " gobi) yomi)))
	    (if (notify-yes-or-no-p "辞書項目『%s』(%s: %s)を%sから削除します。"
				item item-yomi hinshi (file-name-nondirectory 
						       dict-name))
		(progn
		  (KKCP:dict-delete *diced-dno* kanji yomi bunpo)
		  (notify "辞書項目『%s』(%s: %s)を%sから削除しました。"
			  item item-yomi hinshi dict-name)
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
(define-key diced-mode-map "u"    'diced-undelete)
(define-key diced-mode-map "x"    'diced-execute)

(define-key diced-mode-map "\C-h" 'help-command)
(define-key diced-mode-map "\C-n" 'diced-next-line)
(define-key diced-mode-map "\C-p" 'previous-line)
(define-key diced-mode-map "\C-v" 'scroll-up)
(define-key diced-mode-map "\e<"  'beginning-of-buffer)
(define-key diced-mode-map "\e>"  'diced-end-of-buffer)
(define-key diced-mode-map "\ev"  'diced-scroll-down)

;;; End of sj3-egg.el
;; 92.7.7 by Y.Kawabe -- commented out
;; (if (boundp 'SJ3) 
;;    (load-library "sj3fns"))
