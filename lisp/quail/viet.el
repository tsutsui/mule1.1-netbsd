;; Quail packages for inputting Vietnamese characters.
;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).

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

;;; 93.5.19  created for Mule Ver.0.9.8
;;;			by Cuong T. Nguyen <cuong@haydn.stanford.edu>
;;; 93.5.26  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>

(require 'quail)

(quail-define-package "viqr" "VIQR" nil "Vietnamese VIQR inputting method.

    effect   | postfix | examples
 ------------+---------+----------
    breve    |    (    | a( -> ,1e(B
  circumflex |    ^    | a^ -> ,1b(B
    horn     |    +    | o+ -> ,1=(B
 ------------+---------+----------
    acute    |    '    | a' -> ,1a(B
    grave    |    `    | a` -> ,1`(B
  hook above |    ?    | a? -> ,1d(B
    tilde    |    ~    | a~ -> ,1c(B
   dot below |    .    | a. -> ,1U(B
 ------------+---------+----------
    d bar    |   dd    | dd -> ,1p(B
 ------------+---------+----------
  no compose |    \    | a\. -> a.
 ------------+---------+----------
  combination|   (~    | a(~ -> ,1G(B

" nil t t nil nil nil t)

;;; lower-case
(quail-defrule "a('"   ?,1!(B)	; 161
(quail-defrule "a(`"   ?,1"(B)	; 162
(quail-defrule "a(."   ?,1#(B)	; 163
(quail-defrule "a^'"   ?,1$(B)	; 164
(quail-defrule "a^`"   ?,1%(B)	; 165
(quail-defrule "a^?"   ?,1&(B)	; 166
(quail-defrule "a^."   ?,1'(B)	; 167
(quail-defrule "e~"   ?,1((B)	; 168
(quail-defrule "e."   ?,1)(B)	; 169
(quail-defrule "e^'"   ?,1*(B)	; 170
(quail-defrule "e^`"   ?,1+(B)	; 171
(quail-defrule "e^?"   ?,1,(B)	; 172
(quail-defrule "e^~"   ?,1-(B)	; 173
(quail-defrule "e^."   ?,1.(B)	; 174
(quail-defrule "o^'"   ?,1/(B)	; 175
(quail-defrule "o^`"   ?,10(B)	; 176
(quail-defrule "o^?"   ?,11(B)	; 177
(quail-defrule "o^~"   ?,12(B)	; 178
(quail-defrule "o^."   ?,15(B)	; 181
(quail-defrule "o+`"   ?,16(B)	; 182
(quail-defrule "o+?"   ?,17(B)	; 183
(quail-defrule "i."   ?,18(B)	; 184
(quail-defrule "o+"   ?,1=(B)	; 189
(quail-defrule "o+'"   ?,1>(B)	; 190
(quail-defrule "a(?"   ?,1F(B)	; 198
(quail-defrule "a(~"   ?,1G(B)	; 199
(quail-defrule "y`"   ?,1O(B)	; 207
(quail-defrule "u+'"   ?,1Q(B)	; 209
(quail-defrule "a."   ?,1U(B)	; 213
(quail-defrule "y?"   ?,1V(B)	; 214
(quail-defrule "u+`"   ?,1W(B)	; 215
(quail-defrule "u+?"   ?,1X(B)	; 216
(quail-defrule "y~"   ?,1[(B)	; 219
(quail-defrule "y."   ?,1\(B)	; 220
(quail-defrule "o+~"   ?,1^(B)	; 222
(quail-defrule "u+"   ?,1_(B)	; 223
(quail-defrule "a`"   ?,1`(B)	; 224
(quail-defrule "a'"   ?,1a(B)	; 225
(quail-defrule "a^"   ?,1b(B)	; 226
(quail-defrule "a~"   ?,1c(B)	; 227
(quail-defrule "a?"   ?,1d(B)	; 228
(quail-defrule "a("   ?,1e(B)	; 229
(quail-defrule "u+~"   ?,1f(B)	; 230
(quail-defrule "a^~"   ?,1g(B)	; 231
(quail-defrule "e`"   ?,1h(B)	; 232
(quail-defrule "e'"   ?,1i(B)	; 233
(quail-defrule "e^"   ?,1j(B)	; 234
(quail-defrule "e?"   ?,1k(B)	; 235
(quail-defrule "i`"   ?,1l(B)	; 236
(quail-defrule "i'"   ?,1m(B)	; 237
(quail-defrule "i~"   ?,1n(B)	; 238
(quail-defrule "i?"   ?,1o(B)	; 239
(quail-defrule "dd"   ?,1p(B)	; 240
(quail-defrule "u+."   ?,1q(B)	; 241
(quail-defrule "o`"   ?,1r(B)	; 242
(quail-defrule "o'"   ?,1s(B)	; 243
(quail-defrule "o^"   ?,1t(B)	; 244
(quail-defrule "o~"   ?,1u(B)	; 245
(quail-defrule "o?"   ?,1v(B)	; 246
(quail-defrule "o."   ?,1w(B)	; 247
(quail-defrule "u."   ?,1x(B)	; 248
(quail-defrule "u`"   ?,1y(B)	; 249
(quail-defrule "u'"   ?,1z(B)	; 250
(quail-defrule "u~"   ?,1{(B)	; 251
(quail-defrule "u?"   ?,1|(B)	; 252
(quail-defrule "y'"   ?,1}(B)	; 253
(quail-defrule "o+."   ?,1~(B)	; 254

;;; upper-case
(quail-defrule "A('"   ?,2!(B)	; 161
(quail-defrule "A(`"   ?,2"(B)	; 162
(quail-defrule "A(."   ?,2#(B)	; 163
(quail-defrule "A^'"   ?,2$(B)	; 164
(quail-defrule "A^`"   ?,2%(B)	; 165
(quail-defrule "A^?"   ?,2&(B)	; 166
(quail-defrule "A^."   ?,2'(B)	; 167
(quail-defrule "E~"   ?,2((B)	; 168
(quail-defrule "E."   ?,2)(B)	; 169
(quail-defrule "E^'"   ?,2*(B)	; 170
(quail-defrule "E^`"   ?,2+(B)	; 171
(quail-defrule "E^?"   ?,2,(B)	; 172
(quail-defrule "E^~"   ?,2-(B)	; 173
(quail-defrule "E^."   ?,2.(B)	; 174
(quail-defrule "O^'"   ?,2/(B)	; 175
(quail-defrule "O^`"   ?,20(B)	; 176
(quail-defrule "O^?"   ?,21(B)	; 177
(quail-defrule "O^~"   ?,22(B)	; 178
(quail-defrule "O^."   ?,25(B)	; 181
(quail-defrule "O+`"   ?,26(B)	; 182
(quail-defrule "O+?"   ?,27(B)	; 183
(quail-defrule "I."   ?,28(B)	; 184
(quail-defrule "O+"   ?,2=(B)	; 189
(quail-defrule "O+'"   ?,2>(B)	; 190
(quail-defrule "A(?"   ?,2F(B)	; 198
(quail-defrule "A(~"   ?,2G(B)	; 199
(quail-defrule "Y`"   ?,2O(B)	; 207
(quail-defrule "U+'"   ?,2Q(B)	; 209
(quail-defrule "A."   ?,2U(B)	; 213
(quail-defrule "Y?"   ?,2V(B)	; 214
(quail-defrule "U+`"   ?,2W(B)	; 215
(quail-defrule "U+?"   ?,2X(B)	; 216
(quail-defrule "Y~"   ?,2[(B)	; 219
(quail-defrule "Y."   ?,2\(B)	; 220
(quail-defrule "O+~"   ?,2^(B)	; 222
(quail-defrule "U+"   ?,2_(B)	; 223
(quail-defrule "A`"   ?,2`(B)	; 224
(quail-defrule "A'"   ?,2a(B)	; 225
(quail-defrule "A^"   ?,2b(B)	; 226
(quail-defrule "A~"   ?,2c(B)	; 227
(quail-defrule "A?"   ?,2d(B)	; 228
(quail-defrule "A("   ?,2e(B)	; 229
(quail-defrule "U+~"   ?,2f(B)	; 230
(quail-defrule "A^~"   ?,2g(B)	; 231
(quail-defrule "E`"   ?,2h(B)	; 232
(quail-defrule "E'"   ?,2i(B)	; 233
(quail-defrule "E^"   ?,2j(B)	; 234
(quail-defrule "E?"   ?,2k(B)	; 235
(quail-defrule "I`"   ?,2l(B)	; 236
(quail-defrule "I'"   ?,2m(B)	; 237
(quail-defrule "I~"   ?,2n(B)	; 238
(quail-defrule "I?"   ?,2o(B)	; 239
(quail-defrule "DD"   ?,2p(B)	; 240
(quail-defrule "dD"   ?,2p(B)	; 240
(quail-defrule "Dd"   ?,2p(B)	; 240
(quail-defrule "U+."   ?,2q(B)	; 241
(quail-defrule "O`"   ?,2r(B)	; 242
(quail-defrule "O'"   ?,2s(B)	; 243
(quail-defrule "O^"   ?,2t(B)	; 244
(quail-defrule "O~"   ?,2u(B)	; 245
(quail-defrule "O?"   ?,2v(B)	; 246
(quail-defrule "O."   ?,2w(B)	; 247
(quail-defrule "U."   ?,2x(B)	; 248
(quail-defrule "U`"   ?,2y(B)	; 249
(quail-defrule "U'"   ?,2z(B)	; 250
(quail-defrule "U~"   ?,2{(B)	; 251
(quail-defrule "U?"   ?,2|(B)	; 252
(quail-defrule "Y'"   ?,2}(B)	; 253
(quail-defrule "O+."   ?,2~(B)	; 254

;;; Escape from composition
(quail-defrule "\\("   ?()	; breve (left parenthesis)
(quail-defrule "\\^"   ?^)	; circumflex (caret)
(quail-defrule "\\+"   ?+)	; horn (plus sign)
(quail-defrule "\\'"   ?')	; acute (apostrophe)
(quail-defrule "\\`"   ?`)	; grave (backquote)
(quail-defrule "\\?"   ??)	; hook above (question mark)
(quail-defrule "\\~"   ?~)	; tilde (tilde)
(quail-defrule "\\."   ?.)	; dot below (period)
(quail-defrule "\\d"   ?d)	; d-bar (d)
(quail-defrule "\\\\"  ?\\)	; literal backslash

(quail-use-package "viqr")

