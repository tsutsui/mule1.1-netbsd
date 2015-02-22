;; Vietnamese language specific setup for Mule
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

;;; 93.5.25  created for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;; 93.7.22  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>

(define-category-mnemonic ?v "Vietnamese character.")
(modify-category-entry (make-character lc-vn-1) ?v)
(modify-category-entry (make-character lc-vn-2) ?v)

(require 'ccl)
(provide 'viet)				;93.7.22 by K.Handa

(defconst ccl-read-viscii
  (ccl-compile
   '[[]
     ( [ 0 1 ",2F(B" 3 4 ",2G(B" ",2g(B" 7 8 9 10 11 12 13 14 15
	 16 17 18 19 ",2V(B" 21 22 23 24 ",2[(B" 26 27 28 29 ",2\(B" 31
	 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
	 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
	 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79
	 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
	 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111
	 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 
	 ",2U(B" ",2!(B" ",2"(B" ",2#(B" ",2$(B" ",2%(B" ",2&(B" ",2'(B" ",2((B" ",2)(B" ",2*(B" ",2+(B" ",2,(B" ",2-(B" ",2.(B" ",2/(B"
	 ",20(B" ",21(B" ",22(B" ",25(B" ",2~(B" ",2>(B" ",26(B" ",27(B" ",28(B" ",2v(B" ",2w(B" ",2o(B" ",2|(B" ",2{(B" ",2x(B" ",2O(B"
	 ",2u(B" ",1!(B" ",1"(B" ",1#(B" ",1$(B" ",1%(B" ",1&(B" ",1'(B" ",1((B" ",1)(B" ",1*(B" ",1+(B" ",1,(B" ",1-(B" ",1.(B" ",1/(B"
	 ",10(B" ",11(B" ",12(B" ",2^(B" ",2=(B" ",15(B" ",16(B" ",17(B" ",18(B" ",2q(B" ",2Q(B" ",2W(B" ",2X(B" ",1=(B" ",1>(B" ",2_(B"
	 ",2`(B" ",2a(B" ",2b(B" ",2c(B" ",2d(B" ",2e(B" ",1F(B" ",1G(B" ",2h(B" ",2i(B" ",2j(B" ",2k(B" ",2l(B" ",2m(B" ",2n(B" ",1O(B"
	 ",2p(B" ",1Q(B" ",2r(B" ",2s(B" ",2t(B" ",1U(B" ",1V(B" ",1W(B" ",1X(B" ",2y(B" ",2z(B" ",1[(B" ",1\(B" ",2}(B" ",1^(B" ",1_(B"
	 ",1`(B" ",1a(B" ",1b(B" ",1c(B" ",1d(B" ",1e(B" ",1f(B" ",1g(B" ",1h(B" ",1i(B" ",1j(B" ",1k(B" ",1l(B" ",1m(B" ",1n(B" ",1o(B"
	 ",1p(B" ",1q(B" ",1r(B" ",1s(B" ",1t(B" ",1u(B" ",1v(B" ",1w(B" ",1x(B" ",1y(B" ",1z(B" ",1{(B" ",1|(B" ",1}(B" ",1~(B" ",2f(B" ] )
     ()
     ])
  "CCL program to read VISCII 1.1")

(defconst ccl-write-viscii
  (ccl-compile
   '[[]
     ( [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
	16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
	32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
	48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
	64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79
	80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
	96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111
	112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 
	nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	nil nil nil nil nil nil nil nil nil nil 
	( read
	  [ nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil
	    ( read 
	      [ nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175
		176 177 178 nil nil 181 182 183 184 nil nil nil nil 189 190 nil
		nil nil nil nil nil nil 198 199 nil nil nil nil nil nil nil 207
		nil 209 nil nil nil 213 214 215 216 nil nil 219 220 nil 222 223
		224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239
		240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 nil
		]
	      )
	    ( read
	      [ nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil 129 130 131 132 165 134 135 136 137 138 139 140 141 142 143
		144 145 146 nil nil 147 150 151 152 nil nil nil nil 180 149 nil
		nil nil nil nil nil nil   2   5 nil nil nil nil nil nil nil 159
		nil 186 nil nil nil 128  20 187 188 nil nil  25  30 nil 179 191
		192 193 194 195 196 197 255   6 200 201 202 203 204 205 206 155
		208 185 210 211 212 160 153 154 158 217 218 157 156 221 148 nil
		]
	      )
	    nil
	    ]
	  )
	nil
	]
       )
     ( )
     ]
   )
  "CCL program to write VISCII 1.1")

(defconst ccl-x-vn-1-viscii
  (ccl-compile
   '[[]
     ([nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175
       176 177 178 nil nil 181 182 183 184 nil nil nil nil 189 190 nil
       nil nil nil nil nil nil 198 199 nil nil nil nil nil nil nil 207
       nil 209 nil nil nil 213 214 215 216 nil nil 219 220 nil 222 223
       224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239
       240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 nil
       ])
     ()])
  "CCL program to convert chars of lc-vn-1 to VISCII 1.1 font")

(defconst ccl-x-vn-2-viscii
  (ccl-compile
   '[[]
     ([nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143
       144 145 146 nil nil 147 150 151 152 nil nil nil nil 180 149 nil
       nil nil nil nil nil nil   2   5 nil nil nil nil nil nil nil 159
       nil 186 nil nil nil 128  20 187 188 nil nil  25  30 nil 179 191
       192 193 194 195 196 197 255   6 200 201 202 203 204 205 206 155
       208 185 210 211 212 160 153 154 158 217 218 157 156 221 148 nil
       ])
     ()])
  "CCL program to convert chars of lc-vn-2 to VISCII 1.1 font")

(make-coding-system
 '*viscii* 4
 ?V "Coding-system used for VISCII 1.1."
 t
 (cons ccl-read-viscii ccl-write-viscii))

(load "quail/viet")

(defconst viqr-regexp
  "[aeiouyAEIOUY]\\([(^+]?['`?~.]\\|[(^+]\\)\\|[Dd][Dd]")

(defun vn-compose-viqr (from to)
  "Convert 'VIQR' mnemonics of the current region to
pre-composed Vietnamese characaters."
  (interactive "r")
  (let* ((*quail-current-package* (quail-package "viqr"))
	 (map (quail-map))
	 key def)
    (save-restriction
      (narrow-to-region from to)
      (goto-char (point-min))
      (while (re-search-forward viqr-regexp nil t)
	(setq key (buffer-substring (match-beginning 0) (match-end 0)))
	(setq def (lookup-key map key))
	(if (numberp def)
	    (if (> def 2)
		(setq key (substring key 0 (1- def))
		      def (lookup-key map key))))
	(if (keymapp def)
	    (progn
	      (goto-char (match-beginning 0))
	      (delete-region (point) (+ (point) (length key)))
	      (insert (quail-get-candidate def t))))))))

(defun vn-compose-viqr-buffer ()
  (interactive)
  (vn-compose-viqr (point-min) (point-max)))

(defun vn-decompose-viqr (from to)
  "Convert pre-composed Vietnamese characaters of the current region to
'VIQR' mnemonics."
  (interactive "r")
  (let* ((*quail-current-package* (quail-package "viqr"))
	 (decode-map (quail-decode-map))
	 key def)
    (save-restriction
      (narrow-to-region from to)
      (goto-char (point-min))
      (while (re-search-forward "\\cv" nil t)
	(setq def (preceding-char))
	(if (setq key (assq def decode-map))
	    (progn
	      (delete-char -1)
	      (insert (cdr key))))))))

(defun vn-decompose-viqr-buffer ()
  (interactive)
  (vn-decompose-viqr (point-min) (point-max)))

(make-coding-system
 '*viqr* 0
 ?v "Codins-system used for VIQR."
 nil)
(put *viqr* 'post-read-conversion 'vn-compose-viqr)
(put *viqr* 'pre-write-conversion 'vn-decompose-viqr)


(defconst ccl-read-vscii
  (ccl-compile
   '[[]
     ( [ 0 ",2z(B" ",2x(B" 3 ",2W(B" ",2X(B" ",2f(B" 7 8 9 10 11 12 13 14 15
	 16 ",2Q(B" ",2_(B" ",2O(B" ",2V(B" ",2[(B" ",2}(B" ",2\(B" 24 25 26 27 28 29 30 31
	 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
	 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
	 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79
	 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
	 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111
	 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 
	 ",2`(B" ",2d(B" ",2c(B" ",2a(B" ",2U(B" ",2#(B" ",2'(B" ",2h(B" ",2k(B" ",2((B" ",2i(B" ",2)(B" ",2.(B" ",2l(B" ",2o(B" ",2n(B"
	 ",2m(B" ",28(B" ",2r(B" ",2v(B" ",2u(B" ",2s(B" ",2w(B" ",25(B" ",26(B" ",27(B" ",2^(B" ",2>(B" ",2~(B" ",2y(B" ",2|(B" ",2{(B"
	 160 ",2e(B" ",2b(B" ",2j(B" ",2t(B" ",2=(B" ",2_(B" ",2p(B" ",1e(B" ",1b(B" ",1j(B" ",1t(B" ",1>(B" ",1y(B" ",1p(B" ",2"(B"
	 192 193 194 195 196 ",1`(B" ",1d(B" ",1c(B" ",1a(B" ",1U(B" ",2F(B" ",1"(B" ",1F(B" ",1G(B" ",1!(B" ",2G(B"
	 ",2!(B" ",2%(B" ",2&(B" ",2g(B" ",2%(B" ",2+(B" ",1#(B" ",1%(B" ",1&(B" ",1g(B" ",1$(B" ",1'(B" ",1h(B" ",2,(B" ",1k(B" ",1((B"
	 ",1i(B" ",1)(B" ",1+(B" ",1,(B" ",1-(B" ",1*(B" ",1.(B" ",1l(B" ",1o(B" ",2-(B" ",2*(B" ",20(B" ",1n(B" ",1m(B" ",18(B" ",1r(B"
	 ",21(B" ",1v(B" ",1u(B" ",1s(B" ",1w(B" ",10(B" ",11(B" ",12(B" ",1/(B" ",15(B" ",16(B" ",17(B" ",1^(B" ",1>(B" ",1~(B" ",1y(B"
	 ",22(B" ",1|(B" ",1{(B" ",1z(B" ",1x(B" ",1W(B" ",1X(B" ",1f(B" ",1Q(B" ",1q(B" ",1O(B" ",1V(B" ",1[(B" ",1}(B" ",1\(B" ",2/(B" ] )
     ()
     ])
  "CCL program to read VSCII-1.")

(defconst ccl-write-vscii
  (ccl-compile
   '[[]
     ( [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
	16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
	32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
	48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
	64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79
	80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
	96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111
	112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 
	nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	nil nil nil nil nil nil nil nil nil nil 
	( read
	  [ nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
	    nil nil nil
	    ( read 
	      [ nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil 190 187 198 202 199 200 203 207 209 213 210 211 212 214 232
		229 230 231 nil nil 233 234 235 222 nil nil nil nil nil 237 nil
		nil nil nil nil nil nil 188 189 nil nil nil nil nil nil nil 250
		nil 248 nil nil nil 185 251 245 246 nil nil 252 254 nil 236 nil
		181 184 169 183 182 168 247 201 204 208 170 206 215 221 220 216
		174 249 223 227 171 226 225 228 244 239 243 242 241 253 238 nil
		]
	      )
	    ( read
	      [ nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
		nil 192 175 133 nil 196 194 134 137 139 218 197 205 217 140 255
		219 224 240 nil nil 151 152 153 145 nil nil nil nil 165 155 nil
		nil nil nil nil nil nil 186 191 nil nil nil nil nil nil nil  19
		nil  17 nil nil nil 132  20   4   5 nil nil  21  23 nil 154 166
		128 131 162 130 129 161   6 195 135 138 163 136 141 144 143 142
		167 nil 146 149 164 148 147 150   2 157   1 159 158  22 156 nil
		]
	      )
	    nil
	    ]
	  )
	nil
	]
       )
     ( )
     ]
   )
  "CCL program to write VSCII-1.")

(defconst ccl-x-vn-1-vscii
  (ccl-compile
   '[[]
     ([nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil 190 187 198 202 199 200 203 207 209 213 210 211 212 214 232
       229 230 231 nil nil 233 234 235 222 nil nil nil nil nil 237 nil
       nil nil nil nil nil nil 188 189 nil nil nil nil nil nil nil 250
       nil 248 nil nil nil 185 251 245 246 nil nil 252 254 nil 236 nil
       181 184 169 183 182 168 247 201 204 208 170 206 215 221 220 216
       174 249 223 227 171 226 225 228 244 239 243 242 241 253 238 nil
       ])
     ()])
  "CCL program to convert chars of lc-vn-1 to VSCII-1 font.")

(defconst ccl-x-vn-2-vscii
  (ccl-compile
   '[[]
     ([nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil
       nil 192 175 133 nil 196 194 134 137 139 218 197 205 217 140 255
       219 224 240 nil nil 151 152 153 145 nil nil nil nil 165 155 nil
       nil nil nil nil nil nil 186 191 nil nil nil nil nil nil nil  19
       nil  17 nil nil nil 132  20   4   5 nil nil  21  23 nil 154 166
       128 131 162 130 129 161   6 195 135 138 163 136 141 144 143 142
       167 nil 146 149 164 148 147 150   2 157   1 159 158  22 156 nil
       ])
     ()])
  "CCL program to convert chars of lc-vn-2 to VSCII-1 font.")

(make-coding-system
 '*vscii* 4
 ?V "Coding-system used for VSCII-1."
 t
 (cons ccl-read-vscii ccl-write-vscii))

;; The following setup is for VISCII.
;; If you uses VSCII mainly, override them appropriately in site-init.el.

(setq *coding-category-bin* *viscii*)

(if (not (fboundp 'x-set-font))
    ;; You don't have X window.
    nil
  ;; You have X window.
  (x-set-ccl lc-vn-1 ccl-x-vn-1-viscii)
  (x-set-ccl lc-vn-2 ccl-x-vn-2-viscii)
  ;; 93.5.24 by K.Handa
  (set-x-default-font lc-vn-1 "-*-fixed-medium-r-*--*-*-*-*-*-*-viscii1.1-1" 1)
  (set-x-default-font lc-vn-2 "-*-fixed-medium-r-*--*-*-*-*-*-*-viscii1.1-1" 1)
  )
