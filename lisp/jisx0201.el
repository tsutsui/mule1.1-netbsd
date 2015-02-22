;; Utility for HankakuKana (jisx0201)

;; This file is part of Egg on Mule (Japanese Environment)

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

;;; 92.9.24  created for Mule Ver.0.9.6 by K.Shibata <shibata@sgi.co.jp>
;;; 93.8.3   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Not to define regexp of Japanese word in this file.

(provide 'jisx0201)

(defvar *katakana-alist*
  '(( 161 . "ｧ" )
    ( 162 . "ｱ" )
    ( 163 . "ｨ" )
    ( 164 . "ｲ" )
    ( 165 . "ｩ" )
    ( 166 . "ｳ" )
    ( 167 . "ｪ" )
    ( 168 . "ｴ" )
    ( 169 . "ｫ" )
    ( 170 . "ｵ" )
    ( 171 . "ｶ" )
    ( 172 . "ｶﾞ" )
    ( 173 . "ｷ" )
    ( 174 . "ｷﾞ" )
    ( 175 . "ｸ" )
    ( 176 . "ｸﾞ" )
    ( 177 . "ｹ" )
    ( 178 . "ｹﾞ" )
    ( 179 . "ｺ" )
    ( 180 . "ｺﾞ" )
    ( 181 . "ｻ" )
    ( 182 . "ｻﾞ" )
    ( 183 . "ｼ" )
    ( 184 . "ｼﾞ" )
    ( 185 . "ｽ" )
    ( 186 . "ｽﾞ" )
    ( 187 . "ｾ" )
    ( 188 . "ｾﾞ" )
    ( 189 . "ｿ" )
    ( 190 . "ｿﾞ" )
    ( 191 . "ﾀ" )
    ( 192 . "ﾀﾞ" )
    ( 193 . "ﾁ" )
    ( 194 . "ﾁﾞ" )
    ( 195 . "ｯ" )
    ( 196 . "ﾂ" )
    ( 197 . "ﾂﾞ" )
    ( 198 . "ﾃ" )
    ( 199 . "ﾃﾞ" )
    ( 200 . "ﾄ" )
    ( 201 . "ﾄﾞ" )
    ( 202 . "ﾅ" )
    ( 203 . "ﾆ" )
    ( 204 . "ﾇ" )
    ( 205 . "ﾈ" )
    ( 206 . "ﾉ" )
    ( 207 . "ﾊ" )
    ( 208 . "ﾊﾞ" )
    ( 209 . "ﾊﾟ" )
    ( 210 . "ﾋ" )
    ( 211 . "ﾋﾞ" )
    ( 212 . "ﾋﾟ" )
    ( 213 . "ﾌ" )
    ( 214 . "ﾌﾞ" )
    ( 215 . "ﾌﾟ" )
    ( 216 . "ﾍ" )
    ( 217 . "ﾍﾞ" )
    ( 218 . "ﾍﾟ" )
    ( 219 . "ﾎ" )
    ( 220 . "ﾎﾞ" )
    ( 221 . "ﾎﾟ" )
    ( 222 . "ﾏ" )
    ( 223 . "ﾐ" )
    ( 224 . "ﾑ" )
    ( 225 . "ﾒ" )
    ( 226 . "ﾓ" )
    ( 227 . "ｬ" )
    ( 228 . "ﾔ" )
    ( 229 . "ｭ" )
    ( 230 . "ﾕ" )
    ( 231 . "ｮ" )
    ( 232 . "ﾖ" )
    ( 233 . "ﾗ" )
    ( 234 . "ﾘ" )
    ( 235 . "ﾙ" )
    ( 236 . "ﾚ" )
    ( 237 . "ﾛ" )
    ( 239 . "ﾜ" ) ; ﾜ -> ワ に変換するように
    ( 238 . "ﾜ" ) ; ワとヮの順番が交換してある。
    ( 240 . "ｨ" )
    ( 241 . "ｪ" )
    ( 242 . "ｦ" )
    ( 243 . "ﾝ" )
    ( 244 . "ｳﾞ" )
    ( 245 . "ｶ" )
    ( 246 . "ｹ" )))

(defvar *katakana-kigou-alist*
  '(( 162 . "､" )
    ( 163 . "｡" )
    ( 166 . "･" )
    ( 171 . "ﾞ" )
    ( 172 . "ﾟ" )
    ( 188 . "ｰ" )
    ( 214 . "｢" )
    ( 215 . "｣" )))

(defvar *dakuon-list*
  '( ?カ ?キ ?ク ?ケ ?コ
     ?サ ?シ ?ス ?セ ?ソ
     ?タ ?チ ?ツ ?テ ?ト
     ?ハ ?ヒ ?フ ?ヘ ?ホ))

(defvar *handakuon-list* (memq ?ハ *dakuon-list*))

;;;
;;; 半角変換
;;; 

(defun hankaku-katakana-region (start end &optional arg)
  (interactive "r\nP")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (let ((regexp (if arg "\\cS\\|\\cK\\|\\cH" "\\cS\\|\\cK")))
      (while (re-search-forward regexp (point-max) (point-max))
	(let* ((ch (preceding-char))
	       (ch1 (char-component ch 1))
	       (ch2 (char-component ch 2)))
	  (cond ((= ?\241 ch1)
		 (let ((val (cdr (assq ch2 *katakana-kigou-alist*))))
		   (if val (progn
			     (delete-char -1)
			     (insert val)))))
		((or (= ?\242 ch1) (= ?\250 ch1))
		 nil)
		(t
		 (let ((val (cdr (assq ch2 *katakana-alist*))))
		   (if val (progn
			     (delete-char -1)
			     (insert val)))))))))))

(defun hankaku-katakana-paragraph ()
  "hankaku-katakana paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (hankaku-katakana-region (point) end ))))

(defun hankaku-katakana-sentence ()
  "hankaku-katanaka sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (hankaku-katakana-region (point) end ))))

(defun hankaku-katakana-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (hankaku-katakana-region start (point))))

;;;
;;; 全角変換
;;;
(defun search-henkan-alist (ch list)
  (let ((ptr list)
	(result nil))
    (while ptr
      (if (string= ch (cdr (car ptr)))
	  (progn
	    (setq result (car (car ptr)))
	    (setq ptr nil))
	(setq ptr (cdr ptr))))
    result))

(defun zenkaku-katakana-region (start end)
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "\\ck" (point-max) (point-max))
      (let ((ch (preceding-char))
	    (wk nil))
	(cond
	 ((= ch ?ﾞ)
	  (save-excursion
	    (backward-char 1)
	    (setq wk (preceding-char)))
	  (cond ((= wk ?ウ)
		 (delete-char -2)
		 (insert "ヴ"))
		((setq wk (memq wk *dakuon-list*))
		 (delete-char -2)
		 (insert (1+ (car wk))))
		(t
		 (delete-char -1)
		 (insert "゛"))))
	 ((= ch ?ﾟ)
	  (save-excursion
	    (backward-char 1)
	    (setq wk (preceding-char)))
	  (if (setq wk (memq wk *handakuon-list*))
	      (progn
		(delete-char -2)
		(insert (+ 2 (car wk))))
	    (progn
	      (delete-char -1)
	      (insert "゜"))))
	 ((setq wk (search-henkan-alist
		    (char-to-string ch) *katakana-alist*))
	  (progn
	    (delete-char -1)
	    (insert (make-character lc-jp ?\245 wk))))
	 ((setq wk (search-henkan-alist
		    (char-to-string ch) *katakana-kigou-alist*))
	  (progn
	    (delete-char -1)
	    (insert (make-character lc-jp ?\241 wk)))))))))

(defun zenkaku-katakana-paragraph ()
  "zenkaku-katakana paragraph at or after point."
  (interactive )
  (save-excursion
    (forward-paragraph)
    (let ((end (point)))
      (backward-paragraph)
      (zenkaku-katakana-region (point) end ))))

(defun zenkaku-katakana-sentence ()
  "zenkaku-katakana sentence at or after point."
  (interactive )
  (save-excursion
    (forward-sentence)
    (let ((end (point)))
      (backward-sentence)
      (zenkaku-katakana-region (point) end ))))

(defun zenkaku-katakana-word (arg)
  (interactive "p")
  (let ((start (point)))
    (forward-word arg)
    (zenkaku-katakana-region start (point))))

;;;
;;;  JISX 0201 fence mode
;;;

(defun fence-hankaku-katakana  ()
  (interactive)
  (hankaku-katakana-region egg:*region-start* egg:*region-end* t))

(defun fence-katakana  ()
  (interactive)
  (zenkaku-katakana-region egg:*region-start* egg:*region-end* )
  (katakana-region egg:*region-start* egg:*region-end*))

(defun fence-hiragana  ()
  (interactive)
  (zenkaku-katakana-region egg:*region-start* egg:*region-end*)
  (hiragana-region egg:*region-start* egg:*region-end*))

(define-key fence-mode-map "\ex"  'fence-hankaku-katakana)
