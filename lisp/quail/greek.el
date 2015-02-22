;;; 92.8.8   created for Mule Ver.0.9.5 by T.Matsuzawa <mzw_t@yhp.hp.com>
;;; 92.12.28 modified for Mule ver.0.9.7 by Takahashi N. <ntakahas@etl.go.jp>
;;; 93.4.22  modified by Takahashi N. <ntakahas@etl.go.jp"
;;;          added "jis-greek".
(require 'quail)

(quail-define-package "jis-greek" "$B&%&K&K&G&M&I&J&A(B" nil
		      "JIS X0208.1983 encoding.
The layout is same as greek, but uses JIS characters.
Sorry, accents and terminal sigma are not supported in JIS." nil t t t t)

(quail-defrule "1" ?$B#1(B)
(quail-defrule "2" ?$B#2(B)
(quail-defrule "3" ?$B#3(B)
(quail-defrule "4" ?$B#4(B)
(quail-defrule "5" ?$B#5(B)
(quail-defrule "6" ?$B#6(B)
(quail-defrule "7" ?$B#7(B)
(quail-defrule "8" ?$B#8(B)
(quail-defrule "9" ?$B#9(B)
(quail-defrule "0" ?$B#0(B)
(quail-defrule "-" ?$B!](B)
(quail-defrule "=" ?$B!a(B)
(quail-defrule "`" ?$B!F(B)
(quail-defrule "q" ?$B!&(B)
(quail-defrule "w" ?$B&R(B)
(quail-defrule "e" ?$B&E(B)
(quail-defrule "r" ?$B&Q(B)
(quail-defrule "t" ?$B&S(B)
(quail-defrule "y" ?$B&T(B)
(quail-defrule "u" ?$B&H(B)
(quail-defrule "i" ?$B&I(B)
(quail-defrule "o" ?$B&O(B)
(quail-defrule "p" ?$B&P(B)
(quail-defrule "[" ?$B!N(B)
(quail-defrule "]" ?$B!O(B)
(quail-defrule "a" ?$B&A(B)
(quail-defrule "s" ?$B&R(B)
(quail-defrule "d" ?$B&D(B)
(quail-defrule "f" ?$B&U(B)
(quail-defrule "g" ?$B&C(B)
(quail-defrule "h" ?$B&G(B)
(quail-defrule "j" ?$B&N(B)
(quail-defrule "k" ?$B&J(B)
(quail-defrule "l" ?$B&K(B)
(quail-defrule ";" ?$B!G(B)
(quail-defrule "'" ?$B!G(B)
(quail-defrule "\\" ?$B!@(B)
(quail-defrule "z" ?$B&F(B)
(quail-defrule "x" ?$B&V(B)
(quail-defrule "c" ?$B&W(B)
(quail-defrule "v" ?$B&X(B)
(quail-defrule "b" ?$B&B(B)
(quail-defrule "n" ?$B&M(B)
(quail-defrule "m" ?$B&L(B)
(quail-defrule "," ?, )
(quail-defrule "." ?. )
(quail-defrule "/" ?$B!?(B)

(quail-defrule "!" ?$B!*(B)
(quail-defrule "@" ?$B!w(B)
(quail-defrule "#" ?$B!t(B)
(quail-defrule "$" ?$B!t(B)
(quail-defrule "%" ?$B!s(B)
(quail-defrule "^" ?$B!0(B)
(quail-defrule "&" ?$B!u(B)
(quail-defrule "*" ?$B!v(B)
(quail-defrule "(" ?$B!J(B)
(quail-defrule ")" ?$B!K(B)
(quail-defrule "_" ?$B!2(B)
(quail-defrule "+" ?$B!\(B)
(quail-defrule "~" ?$B!1(B)
(quail-defrule "Q" ?$B!](B)
(quail-defrule "W" ?$B&2(B)
(quail-defrule "E" ?$B&%(B)
(quail-defrule "R" ?$B&1(B)
(quail-defrule "T" ?$B&3(B)
(quail-defrule "Y" ?$B&4(B)
(quail-defrule "U" ?$B&((B)
(quail-defrule "I" ?$B&)(B)
(quail-defrule "O" ?$B&/(B)
(quail-defrule "P" ?$B&1(B)
(quail-defrule "{" ?$B!P(B)
(quail-defrule "}" ?$B!Q(B)
(quail-defrule "A" ?$B&!(B)
(quail-defrule "S" ?$B&2(B)
(quail-defrule "D" ?$B&$(B)
(quail-defrule "F" ?$B&5(B)
(quail-defrule "G" ?$B&#(B)
(quail-defrule "H" ?$B&'(B)
(quail-defrule "J" ?$B&.(B)
(quail-defrule "K" ?$B&*(B)
(quail-defrule "L" ?$B&+(B)
(quail-defrule ":" ?$B!I(B)
(quail-defrule "\"" ?$B!I(B)
(quail-defrule "|" ?$B!C(B)
(quail-defrule "Z" ?$B&&(B)
(quail-defrule "X" ?$B&6(B)
(quail-defrule "C" ?$B&7(B)
(quail-defrule "V" ?$B&8(B)
(quail-defrule "B" ?$B&"(B)
(quail-defrule "N" ?$B&-(B)
(quail-defrule "M" ?$B&,(B)
(quail-defrule "<" ?$B!((B)
(quail-defrule ">" ?$B!'(B)
(quail-defrule "?" ?$B!)(B)

;;;

(quail-define-package "greek" ",FEkkgmij\(B" nil "Greek Keyboard
--------------

In the right of ,Fk(B key is a combination key, where
 ,F4(B acute
 ,F((B diaresis

e.g.
 ,Fa(B + ,F4(B -> ,F\(B
 ,Fi(B + ,F((B -> ,Fz(B
 ,Fi(B + ,F((B + ,F4(B -> ,F@(B
" nil t t t t)

;; 1!  2@  3#  4$  5%  6^  7&  8*  9(  0)  -_  =+  `~
;;  ,F7/(B  ,FrS(B  ,FeE(B  ,FqQ(B  ,FtT(B  ,FuU(B  ,FhH(B  ,FiI(B  ,FoO(B  ,FpP(B  [{  ]}
;;   ,FaA(B  ,FsS(B  ,FdD(B  ,FvV(B  ,FcC(B  ,FgG(B  ,FnN(B  ,FjJ(B  ,FkK(B  ,F4((B  '"  \|
;;    ,FfF(B  ,FwW(B  ,FxX(B  ,FyY(B  ,FbB(B  ,FmM(B  ,FlL(B  ,;  .:  /?  

(quail-defrule "1" ?1)
(quail-defrule "2" ?2)
(quail-defrule "3" ?3)
(quail-defrule "4" ?4)
(quail-defrule "5" ?5)
(quail-defrule "6" ?6)
(quail-defrule "7" ?7)
(quail-defrule "8" ?8)
(quail-defrule "9" ?9)
(quail-defrule "0" ?0)
(quail-defrule "-" ?-)
(quail-defrule "=" ?=)
(quail-defrule "`" ?`)
(quail-defrule "q" ?,F7(B)
(quail-defrule "w" ?,Fr(B)
(quail-defrule "e" ?,Fe(B)
(quail-defrule "r" ?,Fq(B)
(quail-defrule "t" ?,Ft(B)
(quail-defrule "y" ?,Fu(B)
(quail-defrule "u" ?,Fh(B)
(quail-defrule "i" ?,Fi(B)
(quail-defrule "o" ?,Fo(B)
(quail-defrule "p" ?,Fp(B)
(quail-defrule "[" ?[)
(quail-defrule "]" ?])
(quail-defrule "a" ?,Fa(B)
(quail-defrule "s" ?,Fs(B)
(quail-defrule "d" ?,Fd(B)
(quail-defrule "f" ?,Fv(B)
(quail-defrule "g" ?,Fc(B)
(quail-defrule "h" ?,Fg(B)
(quail-defrule "j" ?,Fn(B)
(quail-defrule "k" ?,Fj(B)
(quail-defrule "l" ?,Fk(B)
(quail-defrule ";" ?,F4(B)
(quail-defrule "'" ?')
(quail-defrule "\\" ?\\)
(quail-defrule "z" ?,Ff(B)
(quail-defrule "x" ?,Fw(B)
(quail-defrule "c" ?,Fx(B)
(quail-defrule "v" ?,Fy(B)
(quail-defrule "b" ?,Fb(B)
(quail-defrule "n" ?,Fm(B)
(quail-defrule "m" ?,Fl(B)
(quail-defrule "," ?,)
(quail-defrule "." ?.)
(quail-defrule "/" ?/)

(quail-defrule "!" ?!)
(quail-defrule "@" ?@)
(quail-defrule "#" ?#)
(quail-defrule "$" ?$)
(quail-defrule "%" ?%)
(quail-defrule "^" ?^)
(quail-defrule "&" ?&)
(quail-defrule "*" ?*)
(quail-defrule "(" ?()
(quail-defrule ")" ?))
(quail-defrule "_" ?_)
(quail-defrule "+" ?+)
(quail-defrule "~" ?~)
(quail-defrule "Q" ?,F/(B)
(quail-defrule "W" ?,FS(B)
(quail-defrule "E" ?,FE(B)
(quail-defrule "R" ?,FQ(B)
(quail-defrule "T" ?,FT(B)
(quail-defrule "Y" ?,FU(B)
(quail-defrule "U" ?,FH(B)
(quail-defrule "I" ?,FI(B)
(quail-defrule "O" ?,FO(B)
(quail-defrule "P" ?,FP(B)
(quail-defrule "{" ?{)
(quail-defrule "}" ?})
(quail-defrule "A" ?,FA(B)
(quail-defrule "S" ?,FS(B)
(quail-defrule "D" ?,FD(B)
(quail-defrule "F" ?,FV(B)
(quail-defrule "G" ?,FC(B)
(quail-defrule "H" ?,FG(B)
(quail-defrule "J" ?,FN(B)
(quail-defrule "K" ?,FJ(B)
(quail-defrule "L" ?,FK(B)
(quail-defrule ":" ?,F((B)
(quail-defrule "\"" ?\")
(quail-defrule "|" ?|)
(quail-defrule "Z" ?,FF(B)
(quail-defrule "X" ?,FW(B)
(quail-defrule "C" ?,FX(B)
(quail-defrule "V" ?,FY(B)
(quail-defrule "B" ?,FB(B)
(quail-defrule "N" ?,FM(B)
(quail-defrule "M" ?,FL(B)
(quail-defrule "<" ?;)
(quail-defrule ">" ?:)
(quail-defrule "?" ??)

(quail-defrule "a;" ?,F\(B)
(quail-defrule "e;" ?,F](B)
(quail-defrule "h;" ?,F^(B)
(quail-defrule "i;" ?,F_(B)
(quail-defrule "o;" ?,F|(B)
(quail-defrule "y;" ?,F}(B)
(quail-defrule "v;" ?,F~(B)
(quail-defrule "A;" ?,F6(B)
(quail-defrule "E;" ?,F8(B)
(quail-defrule "H;" ?,F9(B)
(quail-defrule "I;" ?,F:(B)
(quail-defrule "O;" ?,F<(B)
(quail-defrule "Y;" ?,F>(B)
(quail-defrule "V;" ?,F?(B)
(quail-defrule "i:" ?,Fz(B)
(quail-defrule "y:" ?,F{(B)
(quail-defrule "I:" ?,FZ(B)
(quail-defrule "Y:" ?,F[(B)
(quail-defrule "i:;" ?,F@(B)
(quail-defrule "y:;" ?,F`(B)
