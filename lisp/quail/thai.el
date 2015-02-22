;; Quail packages for inputting Thai characters.
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

;;; 93.2.15  modified for Mule Ver.0.9.7.1 by K.Handa <handa@etl.go.jp>
;;;	Completely re-written.
;;; 93.8.5   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	Bug in handling '0(1Qi1(B' fixed.

(require 'quail)

(quail-define-package "thai" "Thai" nil "TSCII encoding
	(1E(B# /(1q(B _(1r(B (1@s(B (16t(B (1XY(B (1V0Qi1(B (1$u(B (15v(B (1(w(B (1"x(B (1*y(B (1_o(B (1#%(B
	 (1fp(B (1d(B\" (1S.(B (1>1(B (1P8(B (1Qm(B (1Uj(B (1C3(B (19O(B (1B-(B (1:0(B (1E(B,
	  (1?D(B (1K&(B (1!/(B (14b(B (1`,(B (1ig(B (1hk(B (1RI(B (1JH(B (1G+(B (1'F(B
	   (1<(B( (1;(B) (1a)(B (1MN(B (1TZ(B (1Wl(B (17n(B (1A2(B (1cL(B (1=(B?

The difference from the ordinal Thai keyboard:
    '(1_(B' and '(1o(B' are assigned to '\\' and '|' respectively,
    '(1#(B' and '(1%(B' are assigned to '`' and '~' respectively,
    Don't know where to assign characters '(1z(B' and '(1{(B'." nil t t)

(defun quail-fetch-thai-map (ch)
  (aref quail-thai-map ch))

(defun quail-thai-compose ()
  (interactive)
  (compose-string
   (mapconcat 'quail-fetch-thai-map *quail-current-key* "")))

(defun quail-thai-exact-char ()
  (interactive)
  (aref quail-thai-map *quail-last-char*))

(defconst quail-thai-map (make-vector 256 0))

(defconst quail-thai-C-map (quail-init-map))
(define-key quail-thai-C-map "\377" 'quail-thai-exact-char t)
(defconst quail-thai-CV-map (quail-init-map))
(define-key quail-thai-CV-map "\377" 'quail-thai-compose t)
(defconst quail-thai-T-map (quail-init-map))
(define-key quail-thai-T-map "\377" 'quail-thai-compose t)

(defun quail-defrule-thai (ch str)
  (aset quail-thai-map ch str)
  (let* ((chstr (char-to-string ch))
	 (ch-thai (string-to-char str))
	 (prop (cdr (assq ch-thai *thai-characters*))))	;93.8.5 by K.Handa
    (cond ((eq prop 'consonant)
	   (quail-defrule chstr quail-thai-C-map))
	  ((or (eq prop 'vowel-upper) (eq prop 'vowel-lower))
	   (quail-defrule chstr str)
	   (define-key quail-thai-C-map chstr quail-thai-CV-map))
	  ((eq prop 'tone)
	   (quail-defrule chstr str)
	   (define-key quail-thai-C-map chstr quail-thai-T-map)
	   (define-key quail-thai-CV-map chstr quail-thai-T-map))
	  (t
	   (quail-defrule chstr str)))))

(quail-defrule-thai ?1 "(1E(B")
(quail-defrule-thai ?! "#")
(quail-defrule-thai ?2 "/")
(quail-defrule-thai ?@ "(1q(B")
(quail-defrule-thai ?3 "_")
(quail-defrule-thai ?# "(1r(B")
(quail-defrule-thai ?4 "(1@(B")
(quail-defrule-thai ?$ "(1s(B")
(quail-defrule-thai ?5 "(16(B")
(quail-defrule-thai ?% "(1t(B")
(quail-defrule-thai ?6 "(1X(B")
(quail-defrule-thai ?^ "(1Y(B")
(quail-defrule-thai ?7 "(1V(B")
(quail-defrule-thai ?& "0(1Qi1(B")
(quail-defrule-thai ?8 "(1$(B")
(quail-defrule-thai ?* "(1u(B")
(quail-defrule-thai ?9 "(15(B")
(quail-defrule-thai ?\( "(1v(B")
(quail-defrule-thai ?0 "(1((B")
(quail-defrule-thai ?\) "(1w(B")
(quail-defrule-thai ?- "(1"(B")
(quail-defrule-thai ?_ "(1x(B")
(quail-defrule-thai ?= "(1*(B")
(quail-defrule-thai ?+ "(1y(B")
(quail-defrule-thai ?\\ "(1_(B")
(quail-defrule-thai ?| "(1o(B")
(quail-defrule-thai ?` "(1#(B")
(quail-defrule-thai ?~ "(1%(B")

(quail-defrule-thai ?q "(1f(B")
(quail-defrule-thai ?Q "(1p(B")
(quail-defrule-thai ?w "(1d(B")
(quail-defrule-thai ?W "\"")
(quail-defrule-thai ?e "(1S(B")
(quail-defrule-thai ?E "(1.(B")
(quail-defrule-thai ?r "(1>(B")
(quail-defrule-thai ?R "(11(B")
(quail-defrule-thai ?t "(1P(B")
(quail-defrule-thai ?T "(18(B")
(quail-defrule-thai ?y "(1Q(B")
(quail-defrule-thai ?Y "(1m(B")
(quail-defrule-thai ?u "(1U(B")
(quail-defrule-thai ?U "(1j(B")
(quail-defrule-thai ?i "(1C(B")
(quail-defrule-thai ?I "(13(B")
(quail-defrule-thai ?o "(19(B")
(quail-defrule-thai ?O "(1O(B")
(quail-defrule-thai ?p "(1B(B")
(quail-defrule-thai ?P "(1-(B")
(quail-defrule-thai ?[ "(1:(B")
(quail-defrule-thai ?{ "(10(B")
(quail-defrule-thai ?] "(1E(B")
(quail-defrule-thai ?} ",")

(quail-defrule-thai ?a "(1?(B")
(quail-defrule-thai ?A "(1D(B")
(quail-defrule-thai ?s "(1K(B")
(quail-defrule-thai ?S "(1&(B")
(quail-defrule-thai ?d "(1!(B")
(quail-defrule-thai ?D "(1/(B")
(quail-defrule-thai ?f "(14(B")
(quail-defrule-thai ?F "(1b(B")
(quail-defrule-thai ?g "(1`(B")
(quail-defrule-thai ?G "(1,(B")
(quail-defrule-thai ?h "(1i(B")
(quail-defrule-thai ?H "(1g(B")
(quail-defrule-thai ?j "(1h(B")
(quail-defrule-thai ?J "(1k(B")
(quail-defrule-thai ?k "(1R(B")
(quail-defrule-thai ?K "(1I(B")
(quail-defrule-thai ?l "(1J(B")
(quail-defrule-thai ?L "(1H(B")
(quail-defrule-thai ?; "(1G(B")
(quail-defrule-thai ?: "(1+(B")
(quail-defrule-thai ?' "(1'(B")
(quail-defrule-thai ?\" ".")

(quail-defrule-thai ?z "(1<(B")
(quail-defrule-thai ?Z "(")
(quail-defrule-thai ?x "(1;(B")
(quail-defrule-thai ?X ")")
(quail-defrule-thai ?c "(1a(B")
(quail-defrule-thai ?C "(1)(B")
(quail-defrule-thai ?v "(1M(B")
(quail-defrule-thai ?V "(1N(B")
(quail-defrule-thai ?b "(1T(B")
(quail-defrule-thai ?B "(1Z(B")
(quail-defrule-thai ?n "(1W(B")
(quail-defrule-thai ?N "(1l(B")
(quail-defrule-thai ?m "(17(B")
(quail-defrule-thai ?M "(1n(B")
(quail-defrule-thai ?, "(1A(B")
(quail-defrule-thai ?< "(12(B")
(quail-defrule-thai ?. "(1c(B")
(quail-defrule-thai ?> "(1L(B")
(quail-defrule-thai ?/ "(1=(B")
(quail-defrule-thai ?\" "(1F(B")
