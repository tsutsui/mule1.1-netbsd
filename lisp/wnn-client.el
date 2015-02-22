;; Wnn3 server interface for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

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
;;; Nemacs - Wnn V3 server interface in elisp
;;;

;;; 93.4.6   modified for Mule Ver.0.9.7.1
;;;			by T.Saneto <sanewo@pdp.crl.sony.co.jp>
;;;	Bug in wnn-bunsetu-yomi-equal fixed.

(provide 'wnn-client)

;;;
;;;  Wnn deamon command constants
;;;

(defconst JD_OPEN_IN    9  "変換") ;;; V3.0
(defconst JD_OPEN       1  "利用者登録")
(defconst JD_CLOSE      2  "利用者削除")
(defconst JD_BEGIN      3  "変換開始")
(defconst JD_END        4  "頻度更新")
;;;
(defconst JD_NEXT       17 "次候補") ;;; 0x11
(defconst JD_RECONV     18 "再変換（文字列変更）") ;;; 0x12
(defconst JD_TANCONV    19 "再変換（文節伸縮）") ;;; 0x13
;;;
(defconst JD_UDP        33 "") ;;; 0x21
(defconst JD_UDCHG      34 "利用者辞書変更") ;;; 0x22
(defconst JD_FREQSV     35 "辞書退避") ;;; 0x23
(defconst JD_DICADD     36 "辞書追加") ;;; 0x24
(defconst JD_DICDEL     37 "辞書削除") ;;; 0x25
(defconst JD_DICINFO    38 "辞書情報") ;;; 0x26
(defconst JD_DICSTAT    39 "") ;;; 0x27 V3.0

(defconst JD_WDEL       49 "単語削除") ;;; 0x31
(defconst JD_WSCH       50 "単語検索") ;;; 0x32
(defconst JD_WREG       51 "単語登録") ;;; 0x33
(defconst JD_WHDEL      52 "") ;;; 0x34

(defconst JD_SETEVF     65 "変換方式変更") ;;; 0x41
(defconst JD_GETEVF     66 "変換方式情報") ;;; 0x42

(defconst JD_MKDIR      81 "") ;;;  0x51 V3.0
(defconst JD_ACCESS     82 "") ;;;  0x52 V3.0
(defconst JD_WHO        83 "利用者一覧") ;;;  0x53 V3.0
(defconst JD_VERSION    84 "") ;;;  0x54 V3.0


(defvar wnn-server-buffer nil  "Buffer associated with Wnn server process.")

(defvar wnn-server-process nil  "Wnn Kana Kanji hankan process.")

(defvar wnn-command-tail-position nil)
(defvar wnn-command-buffer nil)

(defvar wnn-result-buffer nil)
(defvar wnn-henkan-string nil)
(defvar wnn-bunsetu-suu   nil)

(defvar wnn-return-code nil)
(defvar wnn-error-code nil)

;;;
;;;  Put data into buffer 
;;;

(defun wnn-put-4byte (integer)
  (insert (if (<= 0 integer) 0 255)
	  (logand 255 (lsh integer -16))
	  (logand 255 (lsh integer -8))
	  (logand 255 integer)))

(defun wnn-put-string (str)
  (insert str 0))

(defun wnn-put-string* (str)
  (let ((size (length str))
	(i 0))
    (while (< i size)
      (if (<= 128 (aref str i))
	(progn (insert (aref str i) (aref str (1+ i)))
	       (setq i (+ i 2)))
	(progn (insert 0 (aref str i))
	       (setq i (1+ i))))))
  (insert 0 0))

(defun wnn-put-bit-position  (pos)
  (if (< pos  24) (wnn-put-4byte (lsh 1 pos))
    (insert (lsh 1 (- pos 24)) 0 0 0)))

;;;
;;; Get data from buffer
;;;

(defun wnn-get-4byte ()

  (let ((c 0) (point (point)))
    ;;;(goto-char (point-min))
    (while (< (point-max) (+ point 4))
      (accept-process-output)
      (if (= c 10) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char point))

  (let ((point (point)))
    (if (not (or (and (= (char-after point) 0)
		      (< (char-after (+ point 1)) 128))
		 (and (= (char-after point) 255)
		      (<= 128 (char-after (+ point 1))))))
	(error "wnn-get-4byte: integer range overflow."))
    (prog1
	(logior 
	 (lsh (char-after point)       24)
	 (lsh (char-after (+ point 1)) 16)
	 (lsh (char-after (+ point 2))  8)
	 (lsh (char-after (+ point 3))  0))
      (goto-char (+ (point) 4)))))

(defun wnn-peek-4byte ()

  (let ((c 0) (point (point)))
    ;;;(goto-char (point-min))
    (while (< (point-max) (+ point 4))
      (accept-process-output)
      (if (= c 10) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char point))

  (let ((point (point)))
    (if (not (or (and (= (char-after point) 0)
		      (< (char-after (+ point 1)) 128))
		 (and (= (char-after point) 255)
		      (<= 128 (char-after (+ point 1))))))
	(error "wnn-get-4byte: integer range overflow."))
    (prog1
	(logior 
	 (lsh (char-after point)       24)
	 (lsh (char-after (+ point 1)) 16)
	 (lsh (char-after (+ point 2))  8)
	 (lsh (char-after (+ point 3))  0)))))


(defun wnn-get-bit-positions ()

  (let ((c 0) (point (point)))
    ;;;(goto-char (point-min))
    (while (< (point-max) (+ point 4))
      (accept-process-output)
      (if (= c 10) (error "Count exceed."))
      (setq c (1+ c)))
    (goto-char point))

  (let* ((point (point))
	 (left (+ (lsh (char-after point) 8)
		  (char-after (+ point 1))))
	 (right (+ (lsh (char-after (+ point 2)) 8)
		   (char-after (+ point 3))))
	 (result))
    (forward-char 4)
    (let ((i 0))
      (while (< 0 right)
	(if (zerop (logand 1 right)) nil
	  (setq result (cons i result)))
	(setq right (lsh right -1))
	(setq i (1+ i)))
      (setq i 16)
      (while (< 0 left)
	(if (zerop (logand 1 left)) nil
	  (setq result (cons i result)))
	(setq left (lsh left -1))
	(setq i (1+ i))))
    (if (= (length result) 1)
	(car result)
      (nreverse result))))

(defun wnn-get-string ()
  (let ((point (point)))
    (skip-chars-forward "^\0")
    (let ((c 0))
      (while (not (= (following-char) 0))
	(forward-char -1)
	(accept-process-output)
	(if (= c 10) (error "Count exceed"))
	(setq c (1+ c))
	(skip-chars-forward "^\0")))
    (prog1 
	(buffer-substring point (point))
      (forward-char 1))))

(defun wnn-get-string* ()
  (let ((point (point)))
    (let ((c 0))
      (while (not (search-forward "\0\0" nil t))
	(accept-process-output)
	(goto-char point)
	(if (= c 10) (error "Count exceed"))
	(setq c (1+ c))))
    (goto-char point)
    (if (= (following-char) 0) (delete-char 1)
      (forward-char 1))
    (while (< 0 (following-char))
      (forward-char 1)
      (if (= (following-char) 0) (delete-char 1)
	(forward-char 1)))
    (prog1 
	(buffer-substring point (point))
      (forward-char 1))))

;;;
;;; Wnn Server Command Primitives
;;;

(defun wnn-command-start (command)
  (set-buffer wnn-command-buffer)
  (goto-char (point-min))
  (if (not (= (point-max) (+ wnn-command-tail-position 1024)))
      (error "wnn command start error"))
  (delete-region (point-min) wnn-command-tail-position)
  (wnn-put-4byte command))

(defun wnn-command-reset ()
  (save-excursion
    (progn  
      ;;; for Nemacs 3.0 and later
      (if (fboundp 'set-process-kanji-code)
	  (set-process-kanji-code wnn-server-process 0))
      (set-buffer wnn-command-buffer)
      (setq kanji-flag nil)
      (setq kanji-fileio-code 0)   ;;; for Nemacs 2.1
      (buffer-flush-undo wnn-command-buffer)
      (erase-buffer)
      (setq wnn-command-tail-position (point-min))
      (let ((max 1024) (i 0))
	(while (< i max)
	  (insert 0)
	  (setq i (1+ i)))))))

(defun wnn-command-end ()
  (set-buffer wnn-server-buffer)
  (erase-buffer)
  (set-buffer wnn-command-buffer)
  (setq wnn-command-tail-position (point))
  (process-send-region wnn-server-process (point-min)
	       (+ (point-min) (lsh (1+ (lsh (- (point) (point-min)) -10)) 10)))
  )

;;;
;;; Wnn Server Reply primitives
;;;

(defun wnn-get-result ()
  (set-buffer wnn-server-buffer)
  (condition-case ()
      (accept-process-output wnn-server-process)
    (error nil))
  (goto-char (point-min)))

(defun wnn-get-return-code ()
  (setq wnn-return-code (wnn-get-4byte))
  (setq wnn-error-code  (if (= wnn-return-code -1)
			    (wnn-error-symbol (wnn-get-4byte))
			  nil))
  (if wnn-error-code nil
    wnn-return-code))

;;;
;;; Wnn Server Interface:  wnn-server-open
;;;

(defvar *wnn-server-max-kana-string-length* 1000)
(defvar *wnn-server-max-bunsetu-suu* 1000)

(defvar *wnn-service-name* "wnn")

(defun wnn-server-open (server-host-name login-name)
  (if (wnn-server-active-p) t
    (let ((kana_len  *wnn-server-max-kana-string-length*)
	  (klist_len *wnn-server-max-bunsetu-suu*)
	  (jserver_name 
	   (if (or (null  server-host-name)
		   (equal server-host-name "")
		   (equal server-host-name "unix"))
	       (system-name)
	     server-host-name))
	  (user_name
	   (if (or (null login-name) (equal login-name ""))
	       (user-login-name)
	     login-name))
	  (host_name (system-name)))
      (setq wnn-server-process 
	    (condition-case var
		(open-network-stream "Wnn V3" " [Wnn V3 Output Buffer] "
				     jserver_name *wnn-service-name* )
	      (error 
	        (cond((string-match "Unknown host" (car (cdr var)))
		      (setq wnn-error-code (list ':WNN_UNKNOWN_HOST
						 jserver_name)))
		     ((string-match "Unknown service" (car (cdr var)))
		      (setq wnn-error-code (list ':WNN_UNKNOWN_SERVICE
						 *wnn-service-name*)))
		     (t ;;; "Host ... not respoding"
		      (setq wnn-error-code ':WNN_SOCK_OPEN_FAIL)))
		     nil)))
      (if (null wnn-server-process) nil
	(setq wnn-server-buffer (get-buffer " [Wnn V3 Output Buffer] "))
	(setq wnn-command-buffer (get-buffer-create " [Wnn V3 Command Buffer] "))
	(setq wnn-result-buffer (get-buffer-create " [Wnn V3 Result Buffer] "))

	(save-excursion 
	  ;;; for Nemacs 3.0 
	  (if (fboundp 'set-process-kanji-code)
	      (set-process-kanji-code wnn-server-process 0))
	  (progn
	    (set-buffer wnn-server-buffer)
	    (setq kanji-flag nil)
	    ;;; for Nemacs 2.1
	    (setq kanji-fileio-code 0) 
	    (buffer-flush-undo wnn-server-buffer)
	    )
	  (progn
	    (set-buffer wnn-result-buffer)
	    (setq kanji-flag nil)
	    ;;; for Nemacs 2.1 
	    (setq kanji-fileio-code 0)
	    (buffer-flush-undo wnn-result-buffer))
	  (progn  
	    (set-buffer wnn-command-buffer)
	    (setq kanji-flag nil)
	    ;;; for Nemacs 2.1
	    (setq kanji-fileio-code 0)
	    (buffer-flush-undo wnn-command-buffer)
	    (erase-buffer)
	    (setq wnn-command-tail-position (point-min))
	    (let ((max 1024) (i 0))
	      (while (< i max)
		(insert 0)
		(setq i (1+ i)))))
	  (wnn-command-start JD_OPEN_IN)
	  (wnn-put-4byte kana_len)
	  (wnn-put-4byte klist_len)
	  (wnn-put-string user_name)
	  (wnn-put-string host_name)
	  (wnn-command-end)
	  (wnn-get-result)
	  (wnn-get-return-code))))))

(defun wnn-server-active-p ()
  (and wnn-server-process
       (eq (process-status wnn-server-process) 'open)))

(defun wnn-connection-error ()
  (setq wnn-error-code ':wnn-no-connection)
  (setq wnn-return-code -1)
  nil)

(defun wnn-zero-arg-command (op)
  (if (wnn-server-active-p)
      (save-excursion
	(wnn-command-start op)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code))
    (wnn-connection-error)))

(defun wnn-server-close ()
  (wnn-zero-arg-command JD_CLOSE))

(or (fboundp 'si:kill-emacs)
    (fset 'si:kill-emacs (symbol-function 'kill-emacs)))

(defun kill-emacs (&optional arg)
  (interactive "P")
  (if (wnn-server-active-p)
      (progn
	(wnn-server-dict-save)
	(message "Wnnの頻度情報・辞書情報を退避しました。") (sit-for 0)
	(wnn-server-close)))
  (si:kill-emacs arg))

(or (fboundp 'si:do-auto-save)
    (fset 'si:do-auto-save (symbol-function 'do-auto-save)))

(defvar *wnn-do-auto-save-dict* nil)

(defun do-auto-save (&optional nomsg)
  (interactive)
  (if (and *wnn-do-auto-save-dict*
	   (wnn-server-dict-save))
      (progn
	(wnn-serve-dict-save)
	(message "Wnnの頻度情報・辞書情報を退避しました。")
	(sit-for 1)))
  (si:do-auto-save nomsg))

;;; Wnn Result Buffer's layout:
;;;
;;; { length:4  kana 0 kouhoSuu:4 kouhoNo:4 
;;;   {jihoNo:4 serialNo:4 jirituGo 0 fuzokuGo 0 } ...
;;; }
;;;   0 0 0 0

(defun wnn-skip-length ()
  (goto-char (+ (point) 4)))

(defun wnn-skip-4byte ()
  (goto-char (+ (point) 4)))

(defun wnn-skip-yomi ()
  (skip-chars-forward "^\0") (forward-char 1))

(defun wnn-skip-kouho ()
  (goto-char (+ (point) 8))
  (skip-chars-forward "^\0") (forward-char 1)
  (skip-chars-forward "^\0") (forward-char 1)
  )

(defun wnn-forward-char (n)
  (let ((i 1))
    (while (<= i n)
      (if (<= 128 (following-char))
	  (forward-char 2)
	(forward-char 1))
      (setq i (1+ i)))))

;;;
;;; entry function
;;;
(defun wnn-server-henkan-begin (henkan-string)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(setq wnn-henkan-string henkan-string)
	(set-buffer wnn-result-buffer)
	(erase-buffer)
	(setq wnn-bunsetu-suu 0)
	(goto-char (point-min))
	(wnn-command-start JD_BEGIN)
	(wnn-put-string* henkan-string)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-henkan-recieve)))))

;;;
;;; entry function
;;;
(defun wnn-server-henkan-quit () t)

;;;
;;; entry function
;;;
(defun wnn-server-henkan-end (bunsetu-no)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(let (length jisho-no serial-no  kouho-no p0)
	  (wnn-command-start JD_END)
	  (set-buffer wnn-result-buffer)
	  (goto-char (point-min))
	  (let ((max (if (and (integerp bunsetu-no)
			      (<= 0 bunsetu-no)
			      (<= bunsetu-no wnn-bunsetu-suu))
			 bunsetu-no
		       wnn-bunsetu-suu))
		(i 0))
	    (while (< i max)
	      (setq length (wnn-get-4byte))
	      (setq p0 (point))
	      (wnn-skip-yomi)
	      (wnn-skip-4byte) ;;; kouho suu
	      (setq kouho-no (wnn-get-4byte))
	      (let ((j 0))
		(while (< j kouho-no)
		  (wnn-skip-kouho) 
		  (setq j (1+ j))))
	      (setq jisho-no (wnn-get-4byte))
	      (setq serial-no (wnn-get-4byte))
	      (goto-char (+ p0 length))
	      (set-buffer wnn-command-buffer)
	      (insert 0 )
	      (wnn-put-4byte jisho-no)
	      (wnn-put-4byte serial-no)
	      (set-buffer wnn-result-buffer)
	      (setq i (1+ i)))))
	(set-buffer wnn-command-buffer)
	(insert 255)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun wnn-result-goto-bunsetu (bunsetu-no)
    (goto-char (point-min))
    (let (length (i 0))
      (while (< i bunsetu-no)
	(setq length (wnn-get-4byte))
	(goto-char (+ (point) length))
	(setq i (1+ i)))))
	      
;;;
;;; entry function
;;;
(defun wnn-server-henkan-kakutei (bunsetu-no jikouho-no)
  (cond((not (wnn-server-active-p)) (wnn-connection-error))
       ((or (< bunsetu-no 0) (<= wnn-bunsetu-suu bunsetu-no))
	nil)
       (t 
	(let ((inhibit-quit t))
	  (save-excursion
	    (set-buffer wnn-result-buffer)
	    (let (kouho-suu)
	      (wnn-result-goto-bunsetu bunsetu-no)
	      (wnn-skip-length)
	      (wnn-skip-yomi)
	      (setq kouho-suu (wnn-get-4byte))
	      (if (or (< jikouho-no 0) (<= kouho-suu jikouho-no)) nil
		(delete-char 4) (wnn-put-4byte jikouho-no)
		t)))))))

;;;
;;; entry function
;;;
(defun wnn-server-henkan-next (bunsetu-no)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(let (p0 p1 kouho-suu length yomi0 yomi1)
	  (set-buffer wnn-result-buffer)
	  (wnn-result-goto-bunsetu bunsetu-no)
	  (setq length (wnn-get-4byte))
	  (setq p0 (point))
	  (setq p1 (+ p0 length))
	  (setq yomi0 (point))
	  (wnn-skip-yomi)
	  (setq yomi1 (point))
	  (setq kouho-suu (wnn-peek-4byte))
	  (cond((< 1 kouho-suu) t)
	       (t
		(wnn-command-start JD_NEXT)
		(wnn-put-4byte bunsetu-no)
		(wnn-command-end)
		(wnn-get-result)
		(wnn-get-return-code)
		(if (= wnn-return-code -1) wnn-return-code
		  (let (jl jisho-no serial-no kanji)
		    (set-buffer wnn-result-buffer)
		    (delete-region (point) p1)
		    (wnn-put-4byte wnn-return-code)
		    (wnn-put-4byte 0) ;;; current jikouho number
		    (set-buffer wnn-server-buffer)
		    (while (not (= (setq jl (wnn-get-4byte)) -1))
		      (setq jisho-no (wnn-get-4byte)
			    serial-no (wnn-get-4byte)
			    kanji  (wnn-get-string*))
		      (set-buffer wnn-result-buffer)
		      (wnn-put-4byte jisho-no)
		      (wnn-put-4byte serial-no)
		      (insert kanji 0)
		      (let ((p1 (point)) fuzoku)
			(goto-char yomi0)
			(wnn-forward-char jl)
			(setq fuzoku (point))
			(goto-char p1)
			(insert-buffer-substring wnn-result-buffer fuzoku yomi1))
		      (set-buffer wnn-server-buffer))
		    (set-buffer wnn-result-buffer)
		    (setq length (- (point) p0))
		    (goto-char p0) (delete-char -4)
		    (wnn-put-4byte length))
		  t))))))))

(defun jd_reconv (bunsetu-no new-kana)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (if (= bunsetu-no 0) (jd_begin kana)
      (let ((inhibit-quit t))
	(save-excursion
	  (wnn-command-start JD_RECONV)
	  (wnn-put-4byte bunsetu-no)
	  (wnn-put-string* new-kana)
	  (wnn-command-end)
	  (wnn-get-result)
	  (wnn-henkan-recieve bunsetu-no))))))

;;;
;;; entry function
;;;
(defun wnn-server-bunsetu-henkou (bunsetu-no bunsetu-length)
  (cond((not (wnn-server-active-p)) (wnn-connection-error))
       ((or (< bunsetu-no 0) (<= wnn-bunsetu-suu bunsetu-no))
	nil)
       (t
	(let ((inhibit-quit t))
	  (save-excursion
	    (set-buffer wnn-result-buffer)
	    (wnn-result-goto-bunsetu bunsetu-no)
	    (wnn-command-start JD_TANCONV)
	    (wnn-put-4byte bunsetu-no)
	    (wnn-put-4byte bunsetu-length)
	    (wnn-command-end)
	    (wnn-get-result)
	    (setq wnn-bunsetu-suu bunsetu-no)
	    (wnn-henkan-recieve))))))

(defun wnn-henkan-recieve ()
  (wnn-get-return-code)
  (if (= wnn-return-code -1) nil
    (let (p0 p1 length s-ichi jl fl jisho-no serial-no kanji fuzokugo)
      (setq wnn-bunsetu-suu (+ wnn-bunsetu-suu wnn-return-code))
      (if (zerop wnn-return-code) nil
	(setq s-ichi (wnn-peek-4byte))
	(set-buffer wnn-result-buffer)
	(delete-region (point) (point-max))
	(setq p0 (point))
	(insert wnn-henkan-string 0 0 0 0)
	(goto-char p0)
	(wnn-forward-char s-ichi)
	(delete-region p0 (point))
	(set-buffer wnn-server-buffer)
	(while (not (= (setq s-ichi (wnn-get-4byte)) -1))
	  (setq jl (wnn-get-4byte)
		fl (wnn-get-4byte)
		jisho-no (wnn-get-4byte)
		serial-no (wnn-get-4byte)
		kanji (wnn-get-string*))
	  (set-buffer wnn-result-buffer)
	  (setq p0 (point))
	  (wnn-forward-char jl)
	  (setq p1 (point))
	  (wnn-forward-char fl)
	  (setq fuzokugo (buffer-substring p1 (point)))
	  (insert 0) ;;; yomi
	  (wnn-put-4byte 1)	;;; kouho suu
	  (wnn-put-4byte 0)	;;; current kouho number
	  (wnn-put-4byte jisho-no) 
	  (wnn-put-4byte serial-no)
	  (insert kanji 0 fuzokugo 0)
	  (setq length (- (point) p0))
	  (goto-char p0) (wnn-put-4byte length)
	  (goto-char (+ (point) length))
	  (set-buffer wnn-server-buffer)))))
  wnn-return-code)

(defun wnn-bunsetu-suu () wnn-bunsetu-suu)

(defun wnn-bunsetu-kanji (bunsetu-no &optional buffer)
  (let ((savebuffer (current-buffer)))
    (unwind-protect 
	(progn
	  (set-buffer wnn-result-buffer)
	  (if (or (< bunsetu-no 0)
		  (<= wnn-bunsetu-suu bunsetu-no))
	      nil
	    (wnn-result-goto-bunsetu bunsetu-no)
	    (wnn-skip-length)
	    (wnn-skip-yomi)

	    (wnn-skip-4byte) ;;; kouho-suu
	    (let ((i 0) (max (wnn-get-4byte)))
	      (while (< i max)
		(wnn-skip-kouho)
		(setq i (1+ i))))
	    
	    (let ( p1 p2 p3 )
	      (goto-char (+ (point) 4 4))
	      (setq p1 (point))
	      (skip-chars-forward "^\0") (setq p2 (point))
	      (forward-char 1) (skip-chars-forward "^\0")
	      (setq p3 (point))
	      (if (null buffer)
		  (concat (buffer-substring p1 p2) (buffer-substring (1+ p2) p3))
		(set-buffer buffer)
		(insert-buffer-substring wnn-result-buffer p1 p2)
		(insert-buffer-substring wnn-result-buffer (1+ p2) p3)
		nil))))
      (set-buffer savebuffer))))

(defun wnn-bunsetu-kanji-length (bunsetu-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (< bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length)
      (wnn-skip-yomi)

      (wnn-skip-4byte) ;;; kouho-suu
      (let ((i 0) (max (wnn-get-4byte)))
	(while (< i max)
	  (wnn-skip-kouho)
	  (setq i (1+ i))))

      (let ( p1 p3 )
	(goto-char (+ (point) 4 4))
	(setq p1 (point))
	(skip-chars-forward "^\0")(forward-char 1) (skip-chars-forward "^\0")
	(setq p3 (point))
	(- p3 p1 1)))))

(defun wnn-bunsetu-yomi-moji-suu (bunsetu-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length)
      (let ((c 0) ch)
	(while (not (zerop (setq ch (following-char))))
	  (if (<= 128 ch) (forward-char 2)
	    (forward-char 1))
	  (setq c (1+ c)))
	c))))

(defun wnn-bunsetu-yomi (bunsetu-no &optional buffer)
  (let ((savebuff (current-buffer)))
    (unwind-protect 
	(progn
	  (set-buffer wnn-result-buffer)
	  (if (or (<  bunsetu-no 0)
		  (<= wnn-bunsetu-suu bunsetu-no))
	      nil
	    (wnn-result-goto-bunsetu bunsetu-no)
	    (wnn-skip-length)
	    (let (p1 p2 )
	      (setq p1 (point))
	      (skip-chars-forward "^\0")
	      (if (null buffer ) (buffer-substring p1 (point))
		(setq p2 (point))
		(set-buffer buffer)
		(insert-buffer-substring wnn-result-buffer p1 p2)
		t))))
      (set-buffer savebuff))))

(defun wnn-bunsetu-yomi-equal (bunsetu-no yomi)
  (save-excursion
    (set-buffer wnn-result-buffer)
      (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length)
      (looking-at yomi))))		; 93.4.6 by T.Saneto

(defun wnn-bunsetu-kouho-suu (bunsetu-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length)
      (wnn-skip-yomi)
      (wnn-get-4byte))))

(defun wnn-bunsetu-kouho-list (bunsetu-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length)
      (wnn-skip-yomi)
      (let ((max (wnn-get-4byte)) (i 0) (result nil) p0 p1)
	(wnn-skip-4byte) ;;; current kouhou number
	(while (< i max)
	  (wnn-skip-4byte) (wnn-skip-4byte)
	  (setq p0 (point))
	  (skip-chars-forward "^\0")
	  (setq p1 (point))
	  (forward-char 1)
	  (skip-chars-forward "^\0")
	  (setq result
		(cons (concat (buffer-substring p0 p1)
			      (buffer-substring (1+ p1) (point)))
		      result))
	  (forward-char 1)
	  (setq i (1+ i)))
	(nreverse result)))))

(defun wnn-bunsetu-kouho-number (bunsetu-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length)
      (wnn-skip-yomi)
      (wnn-skip-4byte)
      (wnn-get-4byte)))
  )

(defun wnn-bunsetu-kouho-kanji (bunsetu-no kouho-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (wnn-result-goto-bunsetu bunsetu-no)
      (wnn-skip-length) (wnn-skip-yomi)
      (let ((kouho-suu (wnn-get-4byte)))
	(if (or (< kouho-no 0) (<= kouho-suu kouho-no))
	    nil
	  (wnn-skip-4byte) ;;; current kouho number
	  (let ((i 0))
	    (while (< i kouho-no)
	      (wnn-skip-kouho)
	      (setq i (1+ i))))
	  (let ( p1 p2 p3 )
	    (goto-char (+ (point) 4 4))
	    (setq p1 (point))
	    (skip-chars-forward "^\0") (setq p2 (point))
	    (forward-char 1) (skip-chars-forward "^\0")
	    (setq p3 (point))
	    (concat (buffer-substring p1 p2) (buffer-substring (1+ p2) p3))))))))

(defun wnn-bunsetu-kouho-inspect (bunsetu-no kouho-no)
  (save-excursion
    (set-buffer wnn-result-buffer)
    (if (or (<  bunsetu-no 0)
	    (<= wnn-bunsetu-suu bunsetu-no))
	nil
      (let  (p0  p1 kouho-suu jiritugo fuzokugo yomi jishono serial )
	(wnn-result-goto-bunsetu bunsetu-no)
	(wnn-skip-length) 
	(setq p0 (point))
	(wnn-skip-yomi)
	(setq p1 (1- (point)))
	(setq kouho-suu (wnn-get-4byte))
	(if (or (< kouho-no 0) (<= kouho-suu kouho-no))
	    nil
	  (wnn-skip-4byte) ;;; current kouho number
	  (let ((i 0))
	    (while (< i kouho-no)
	      (wnn-skip-kouho)
	      (setq i (1+ i))))
	  (setq jishono (wnn-get-4byte))
	  (setq serial  (wnn-get-4byte))
	  (setq jiritugo (wnn-get-string))
	  (setq fuzokugo (wnn-get-string))
	  (goto-char p1)
	  (if (not (equal "" fuzokugo)) (search-backward fuzokugo p0))
	  (setq yomi (buffer-substring p0 (point)))
	  (list jiritugo fuzokugo yomi jishono serial))))))

(defun wnn-simple-command (op arg)
  (if (wnn-server-active-p)
      (let ((inhibit-quit t))
	(save-excursion
	  (wnn-command-start op)
	  (wnn-put-4byte arg)
	  (wnn-command-end)
	  (wnn-get-result)
	  (wnn-get-return-code)))
    (wnn-connection-error)))

(defun jd_udp (dict-no)
  (wnn-simpale-command JD_UDP dict-no))

(defun wnn-server-set-current-dict (dict-no)
  (wnn-simple-command JD_UDCHG dict-no))

(defun wnn-server-dict-save ()
  (wnn-zero-arg-command JD_FREQSV))

(defun wnn-server-use-dict (dict-file-name hindo-file-name priority readonly-flag)
  (if (not (wnn-server-active-p))(wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_DICADD)
	(wnn-put-string dict-file-name)
	(wnn-put-string hindo-file-name)
	(wnn-put-4byte priority)
	(wnn-put-4byte (if readonly-flag 1 0))
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun jd_dicdel (dict-no)
  (wnn-simple-command JD_DICDEL dict-no))

(defun jd_dicinfo ()
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_DICINFO)
	(wnn-command-end)
	(wnn-get-result)
	(let ((dic-no 0) (result nil))
	  (while (not (= (setq dic-no (wnn-get-4byte)) -1))
	    (setq result
		  (cons (list
			 dic-no
			 (wnn-get-4byte) ;;; ttl_hindo
			 (wnn-get-4byte) ;;; dic_type
			 (wnn-get-4byte) ;;; udp
			 (wnn-get-4byte) ;;; dic_size
			 (wnn-get-4byte) ;;; prioritry
			 (wnn-get-4byte) ;;; readonly no:0 yes:1
			 (wnn-get-string)	;;; dic_name
			 (wnn-get-string)	;;; hindo_name
			 )
			result))
	    (nreverse result)))))))

(defun jd_dicstat (file-name)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_DICSTAT)
	(wnn-put-string file-name)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun wnn-server-dict-delete (serial-no yomi)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_WDEL)
	(wnn-put-4byte serial-no)
	(wnn-put-string* yomi)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun wnn-server-dict-info (yomi)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_WSCH)
	(wnn-put-string* yomi)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)
	(if (= wnn-return-code -1) nil
	  (let ((hindo 0) bunpo jisho serial kanji (result nil))
	    (while (not (= (setq hindo (wnn-get-4byte)) -1))
	      (setq bunpo (wnn-get-bit-positions))
	      (setq jisho (wnn-get-4byte))
	      (setq serial (wnn-get-4byte))
	      (setq kanji (wnn-get-string*))
	      (setq result 
		    (if (integerp bunpo)
			(cons (list kanji bunpo hindo jisho serial)
			      result)
		      (append 
		       (mapcar (function (lambda (x)
					   (list kanji x hindo jisho serial)))
			       bunpo)
		       result))))
	    (nreverse result)))))))

(defun wnn-server-dict-add (kanji yomi bunpo)
  (if (not (wnn-server-active-p))(wnn-connection-error) 
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_WREG)
	(wnn-put-bit-position bunpo)
	(wnn-put-4byte 129) ;;; 0x81 hindo always 1 with imatukattayo bit.(jl.c)
	(wnn-put-string* kanji)
	(wnn-put-string* yomi)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun jd_whdel (serial-no yomi bunpo)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_WHDEL)
	(wnn-put-4byte serial-no)
	(wnn-put-string* yomi)
	(wnn-put-4byte bunpo)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun jd_setevf (bunsetu-su p1 p2 p3 p4 p5)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
       (wnn-command-start JD_SETEVF)
       (wnn-put-4byte bunsetu-su)
       (wnn-put-4byte p1)
       (wnn-put-4byte p2)
       (wnn-put-4byte p3)
       (wnn-put-4byte p4)
       (wnn-put-4byte p5)
       (wnn-put-4byte 0);; p6
       (wnn-put-4byte 0);; p7
       (wnn-put-4byte 0);; p8
       (wnn-put-4byte 0);; p9
       (wnn-put-4byte 0);; p10
       (wnn-command-end)
       (wnn-get-result)
       (wnn-get-return-code)))))

(defun jd_getevf ()
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_GETEVF)
	(wnn-command-end)
	(wnn-get-result)
	(prog1
	    (list
	     (wnn-get-4byte) ;;; bunsetu-su
	     (wnn-get-4byte) ;;; p1
	     (wnn-get-4byte) ;;; p2
	     (wnn-get-4byte) ;;; p3
	     (wnn-get-4byte) ;;; p4
	     (wnn-get-4byte) ;;; p5
	     )
	  (wnn-get-4byte);; p6
	  (wnn-get-4byte);; p7
	  (wnn-get-4byte);; p8
	  (wnn-get-4byte);; p9
	  (wnn-get-4byte);; p10
	  )))))

(defun wnn-server-make-directory (dir-name)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_MKDIR)
	(wnn-put-string dir-name)
	(wnn-command-end)
	(wnn-get-result)
	(wnn-get-return-code)))))

(defun wnn-server-file-access (file-name access-mode)
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_ACCESS)
	(wnn-put-4byte access-mode)
	(wnn-put-string file-name)
	(wnn-command-end)
	(wnn-get-result)
	(setq wnn-return-code (wnn-get-4byte))
	(setq wnn-error-code nil)
	wnn-return-code))))

(defun jd_who ()
  (if (not (wnn-server-active-p)) (wnn-connection-error)
    (let ((inhibit-quit t))
      (save-excursion
	(wnn-command-start JD_WHO)
	(wnn-command-end)
	(wnn-get-result)
	(let ( number user host result)
	  (while (not (= (setq number (wnn-get-4byte)) -1))
	    (setq result
		  (cons 
		   (list number (wnn-get-string) (wnn-get-string))
		   result)))
	  (nreverse result))))))

(defun jd_version ()
  (wnn-zero-arg-command JD_VERSION))

(defconst *wnn-error-alist*
  '(
    (1 :WNN_NO_EXIST     
       "ファイルが存在しません。")
    (2 :WNN_NOT_USERDICT
       "正しいユーザー辞書ではありません。")
    (3 :WNN_MALLOC_ERR
       "メモリallocで失敗しました。")
    (4 :WNN_NOT_SYSTEM
       "正しいシステム辞書ではありません。")
    (5 :WNN_NOT_A_DICT
       "正しい辞書ではありません。")
    (6 :WNN_FILE_NO_SPECIFIED
       "ファイル名が指定されていません。")
    (8 :WNN_HINDO_FILE_NOT_SPECIFIED
       "システム辞書に対して、頻度ファイルの指定がありません。")
    (9 :WNN_JISHOTABLE_FULL
       "辞書テーブルが一杯です。")
    (10 :WNN_HINDO_NO_MATCH
	"頻度ファイルが、指定された辞書の頻度ファイルではありません。")
    (11 :WNN_PARAMR
	"ファイルの読み込み権限がありません。")
    (12 :WNN_HJT_FULL
	"グローバル頻度テーブルが一杯です。")
    (13 :WNN_JT_FULL
	"グローバル辞書テーブルが一杯です。")
    (15 :WNN_PARAMW
	"ファイルに対する書き込み権限がありません。")
    (16 :WNN_OPENF_ERR
	"ファイルがオープンできません。")
;;; 辞書削除関係のエラー 
    (20 :WNN_DICT_NOT_USED
	"その番号の辞書は、使われていません。")
;;; ユーザー辞書変更関係のエラー 
;;;
;;;WNN_DICT_NOT_USED
;;;
    (21 :WNN_NOT_A_USERDICT
	"指定されて辞書は、ユーザー辞書ではありません。")
    (22 :WNN_READONLY
	"リードオンリーの辞書は、カレントユーザー辞書にはできません。")
;;; 辞書セーブ関係のエラー 
;;;
;;; WNN_PARAMW
;;; WNN_OPENF_ERR
;;; 変換時のエラー 
;;; jishobiki.c 
    (30 :WNN_JMT_FULL
	"辞書テーブルがあふれています。 ")

    (31 :WNN_LONG_MOJIRETSU
	"変換しようとする文字列が長過ぎます。")
    (32 :WNN_WKAREA_FULL
	"付属語解析領域が不足しています。")
    (33 :WNN_KAREA_FULL
	"解析領域が不足しています。")

;;; 単語登録時のエラー 
    (40 :WNN_YOMI_LONG
	"読みが長過ぎます。")
    (41 :WNN_KANJI_LONG
	"漢字が長過ぎます。")
    (42 :WNN_BAD_YOMI
	"読みに不適当な文字が含まれています。")
    (43  :WNN_NO_YOMI
	 "読みの長さが0です。")
    (44 :WNN_NO_CURRENT
	"カレント辞書が存在しません。")
    (45 :WNN_RDONLY
	"リードオンリーの辞書に登録しようとしました。")

;;; 単語削除時、品詞削除時のエラー 
;;;
;;;WNN_NO_CURRENT
;;;WNN_RDONLY
;;;
    (50 :WNN_WORD_NO_EXIST
	"指定された単語が存在しません。")

;;; 次候補時のエラー 
    (55 :WNN_JIKOUHO_TOO_MANY
	"次候補のエントリーの個数がおお過ぎます。")

;;; 初期化の時のエラー 
    (60 :WNN_MALLOC_INITIALIZE
	"メモリallocで失敗しました。")

;;; 単語検索時のエラー 
;;;
;;;WNN_BAD_YOMI
;;;WNN_JMT_FULL
;;;

    (68 :WNN_SOME_ERROR
	" 何かのエラーが起こりました。")
    (69 :WNN_SONOTA
	"バグが発生している模様です。")
    (70 :WNN_JSERVER_DEAD
	"サーバが死んでいます。")
    (71 :WNN_ALLOC_FAIL
	"jd_beginでallocに失敗")
    (72 :WNN_SOCK_OPEN_FAIL
	"jd_beginでsocketのopenに失敗")

    (73 :WNN_RCV_SPACE_OVER
	"受信スペースからデータがはみだした")
    (74  :WNN_MINUS_MOJIRETSU
	 "文字列の長さの指定が負である")
;;;	V3.0	
    (80 :WNN_MKDIR_FAIL
	" ディレクトリを作り損なった ")
    (81 :WNN_BAD_USER
	" ユーザ名がない ")
    (82 :WNN_BAD_HOST
	" ホスト名がない ")
    ))

(defun wnn-error-symbol (code)
  (let ((pair (assoc code *wnn-error-alist*)))
    (if (null pair)
	(list ':wnn-unknown-error-code code)
      (car (cdr pair)))))
