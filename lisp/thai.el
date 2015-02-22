;; Thai language specific setup for Mule
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

;;; 93.1.21  created for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;; 93.2.15  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Completely re-written.
;;; 93.6.2   modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;;	post-read-conversion/pre-write-conversion is set to
;;;	*tis620* and *tis620-dos*.
;;; 93.7.22  modified for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;; 94.2.8   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>

(provide 'thai)				;93.7.22 by K.Handa

(set-coding-priority
 '(*coding-category-iso-8-1*
   *coding-category-iso-8-2*))

(make-coding-system
 '*tis620* 2
 ?T "Coding-system used for ASCII(MSB=0) & TIS620(MSB=1)."
 t
 (list lc-ascii lc-thai lc-invalid lc-invalid
       nil 'ascii-eol))

(setq *coding-category-iso-8-1* *tis620*)

(defconst *thai-characters*
  '((?(1!(B . consonant) ; 0xA1: LETTER KO KAI
    (?(1"(B . consonant) ; 0xA2: LETTER KHO KHAI
    (?(1#(B . consonant) ; 0xA3: LETTER KHO KHUAT (obsolete)
    (?(1$(B . consonant) ; 0xA4: LETTER KHO KHWAI
    (?(1%(B . consonant) ; 0xA5: LETTER KHO KHON (obsolete)
    (?(1&(B . consonant) ; 0xA6: LETTER KHO RAKHANG
    (?(1'(B . consonant) ; 0xA7: LETTER NGO NGU
    (?(1((B . consonant) ; 0xA8: LETTER CHO CHAN
    (?(1)(B . consonant) ; 0xA9: LETTER CHO CHING
    (?(1*(B . consonant) ; 0xAA: LETTER CHO CHANG
    (?(1+(B . consonant) ; 0xAB: LETTER SO SO
    (?(1,(B . consonant) ; 0xAC: LETTER CHO CHOE
    (?(1-(B . consonant) ; 0xAD: LETTER YO YING
    (?(1.(B . consonant) ; 0xAE: LETTER DO CHADA
    (?(1/(B . consonant) ; 0xAF: LETTER TO PATAK
    (?(10(B . consonant) ; 0xB0: LETTER THO THAN
    (?(11(B . consonant) ; 0xB1: LETTER THO NANGMONTHO
    (?(12(B . consonant) ; 0xB2: LETTER THO PHUTHAO
    (?(13(B . consonant) ; 0xB3: LETTER NO NEN
    (?(14(B . consonant) ; 0xB4: LETTER DO DEK
    (?(15(B . consonant) ; 0xB5: LETTER TO TAO
    (?(16(B . consonant) ; 0xB6: LETTER THO THUNG
    (?(17(B . consonant) ; 0xB7: LETTER THO THAHAN
    (?(18(B . consonant) ; 0xB8: LETTER THO THONG
    (?(19(B . consonant) ; 0xB9: LETTER NO NU
    (?(1:(B . consonant) ; 0xBA: LETTER BO BAIMAI
    (?(1;(B . consonant) ; 0xBB: LETTER PO PLA
    (?(1<(B . consonant) ; 0xBC: LETTER PHO PHUNG
    (?(1=(B . consonant) ; 0xBD: LETTER FO FA
    (?(1>(B . consonant) ; 0xBE: LETTER PHO PHAN
    (?(1?(B . consonant) ; 0xBF: LETTER FO FAN
    (?(1@(B . consonant) ; 0xC0: LETTER PHO SAMPHAO
    (?(1A(B . consonant) ; 0xC1: LETTER MO MA
    (?(1B(B . consonant) ; 0xC2: LETTER YO YAK
    (?(1C(B . consonant) ; 0xC3: LETTER RO RUA
    (?(1D(B . vowel-base) ; 0xC4: LETTER RU (vowel letter used to write Pali)
    (?(1E(B . consonant) ; 0xC5: LETTER LO LING
    (?(1F(B . vowel-base) ; 0xC6: LETTER LU (vowel letter used to write Pali)
    (?(1G(B . consonant) ; 0xC7: LETTER WO WAEN
    (?(1H(B . consonant) ; 0xC8: LETTER SO SALA
    (?(1I(B . consonant) ; 0xC9: LETTER SO RUSI
    (?(1J(B . consonant) ; 0xCA: LETTER SO SUA
    (?(1K(B . consonant) ; 0xCB: LETTER HO HIP
    (?(1L(B . consonant) ; 0xCC: LETTER LO CHULA
    (?(1M(B . consonant) ; 0xCD: LETTER O ANG
    (?(1N(B . consonant) ; 0xCE: LETTER HO NOK HUK
    (?(1O(B . special) ; 0xCF: PAI YAN NOI (abbreviation)
    (?(1P(B . vowel-base) ; 0xD0: VOWEL SIGN SARA A
    (?(1Q(B . vowel-upper) ; 0xD1: VOWEL SIGN MAI HAN-AKAT N/S-T
    (?(1R(B . vowel-base) ; 0xD2: VOWEL SIGN SARA AA
    (?(1S(B . vowel-base) ; 0xD3: VOWEL SIGN SARA AM
    (?(1T(B . vowel-upper) ; 0xD4: VOWEL SIGN SARA I N/S-T
    (?(1U(B . vowel-upper) ; 0xD5: VOWEL SIGN SARA II N/S-T
    (?(1V(B . vowel-upper) ; 0xD6: VOWEL SIGN SARA UE N/S-T
    (?(1W(B . vowel-upper) ; 0xD7: VOWEL SIGN SARA UEE N/S-T
    (?(1X(B . vowel-lower) ; 0xD8: VOWEL SIGN SARA U N/S-B
    (?(1Y(B . vowel-lower) ; 0xD9: VOWEL SIGN SARA UU N/S-B
    (?(1Z(B . vowel-lower) ; 0xDA: VOWEL SIGN PHINTHU N/S-B (Pali virama)
    (?(1[(B . not-used) ; 0xDA:
    (?(1\(B . not-used) ; 0xDC:
    (?(1](B . not-used) ; 0xDC:
    (?(1^(B . not-used) ; 0xDC:
    (?(1_(B . special) ; 0xDF: BAHT SIGN (currency symbol)
    (?(1`(B . vowel-base) ; 0xE0: VOWEL SIGN SARA E
    (?(1a(B . vowel-base) ; 0xE1: VOWEL SIGN SARA AE
    (?(1b(B . vowel-base) ; 0xE2: VOWEL SIGN SARA O
    (?(1c(B . vowel-base) ; 0xE3: VOWEL SIGN SARA MAI MUAN
    (?(1d(B . vowel-base) ; 0xE4: VOWEL SIGN SARA MAI MALAI
    (?(1e(B . vowel-base) ; 0xE5: LAK KHANG YAO
    (?(1f(B . special) ; 0xE6: MAI YAMOK (repetion)
    (?(1g(B . vowel-upper) ; 0xE7: VOWEL SIGN MAI TAI KHU N/S-T
    (?(1h(B . tone) ; 0xE8: TONE MAI EK N/S-T
    (?(1i(B . tone) ; 0xE9: TONE MAI THO N/S-T
    (?(1j(B . tone) ; 0xEA: TONE MAI TRI N/S-T
    (?(1k(B . tone) ; 0xEB: TONE MAI CHATTAWA N/S-T
    (?(1l(B . tone) ; 0xEC: THANTHAKHAT N/S-T (cancellation mark)
    (?(1m(B . tone) ; 0xED: NIKKHAHIT N/S-T (final nasal)
    (?(1n(B . vowel-upper) ; 0xEE: YAMAKKAN N/S-T
    (?(1o(B . special) ; 0xEF: FONRMAN
    (?(1p(B . special) ; 0xF0: DIGIT ZERO
    (?(1q(B . special) ; 0xF1: DIGIT ONE
    (?(1r(B . special) ; 0xF2: DIGIT TWO
    (?(1s(B . special) ; 0xF3: DIGIT THREE
    (?(1t(B . special) ; 0xF4: DIGIT FOUR
    (?(1u(B . special) ; 0xF5: DIGIT FIVE
    (?(1v(B . special) ; 0xF6: DIGIT SIX
    (?(1w(B . special) ; 0xF7: DIGIT SEVEN
    (?(1x(B . special) ; 0xF8: DIGIT EIGHT
    (?(1y(B . special) ; 0xF9: DIGIT NINE
    (?(1z(B . special) ; 0xFA: ANGKHANKHU (ellipsis)
    (?(1{(B . special) ; 0xFB: KHOMUT (beginning of religious texts)
    (?(1|(B . not-used) ; 0xFC:
    (?(1}(B . not-used) ; 0xFD:
    (?(1~(B . not-used) ; 0xFE:
    )
  "Association list of thai-character and property.")

(defconst *thai-category-table*
  (copy-category-table (standard-category-table))
  "Category table for Thai.")
(define-category-mnemonic ?0 "Thai consonants"
  *thai-category-table*)
(define-category-mnemonic ?1 "Thai upper/lower vowel or tone mark."
  *thai-category-table*)
(define-category-mnemonic ?2 "Thai base vowel or special characters."
  *thai-category-table*)

(let ((chars *thai-characters*)
      ch prop)
  (while chars
    (setq ch (car (car chars))
	  prop (cdr (car chars)))
    (cond ((eq prop 'consonant)
	   (modify-category-entry ch ?0 *thai-category-table*))
	  ((or (eq prop 'vowel-upper)
	       (eq prop 'vowel-lower)
	       (eq prop 'tone))
	   (modify-category-entry ch ?1 *thai-category-table*))
	  (t
	   (modify-category-entry ch ?2 *thai-category-table*)))
    (setq chars (cdr chars))))

(defun thai-compose-buffer ()
  "Compose Thai characters in the current buffer."
  (interactive)
  (thai-compose-region (point-min) (point-max)))

(defun thai-compose-region (beg end)
  "Compose Thai characters in the region."
  (interactive "r")
  (save-restriction
    (narrow-to-region beg end)
    (decompose-region (point-min) (point-max))
    (goto-char (point-min))
    (let ((ctbl (category-table))
	  str)
      (unwind-protect
	  (progn
	    (set-category-table *thai-category-table*)
	    (while (re-search-forward "\\c0\\c1+" nil t)
	      (compose-region (match-beginning 0) (match-end 0))))
	(set-category-table ctbl)))))

(put *tis620* 'post-read-conversion 'thai-compose-region)
(put *tis620* 'pre-write-conversion 'decompose-region)

(load "quail/thai")
