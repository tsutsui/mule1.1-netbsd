;; Quail packages for inputting various European characters.
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

;;; 92.7.3   created for Mule Ver.0.9.5 by Takahashi N. <ntakahas@etl.go.jp>
;;;          The supported languages are: danish, esperanto, finnish,
;;;          french, german, italian, norwegian, scandinavian,
;;;          spanish, and swedish.
;;;          Also including "latin-1 package" for general purpose, and
;;;          "scandinavian package" for those who want to use the
;;;          nordic languages simultaneously.
;;; 92.7.10  modified by Takahashi N. <ntakahas@etl.go.jp>
;;;          packages for icelandic and turkish are added.
;;; 92.7.14  modified by Takahashi N. <ntakahas@etl.go.jp>
;;;          latin-2 package added.
;;; 92.10.22 modified by Takahashi N. <ntakahas@etl.go.jp>
;;;          latin-3, latin-4, latin-5 package added.
;;; 92.12.29 modified by Takahashi N. <ntakahas@etl.go.jp>
;;;          british package added.
;;; 93.1.14  modified by Takahashi N. <ntakahas@etl.go.jp>
;;;          esperanto package changed.

(require 'quail)

(quail-define-package "latin-1" "LATIN-1" nil "Latin-1 encoding.

    effect   | postfix | examples
 ------------+---------+----------
    acute    |    '    | a' -> ,Aa(B
    grave    |    `    | a` -> ,A`(B
  circumflex |    ^    | a^ -> ,Ab(B
  diaeresis  |    \"    | a\" -> ,Ad(B
    tilde    |    ~    | a~ -> ,Ac(B
   cedilla   |    ,    | c, -> ,Ag(B
   nordic    |    /    | d/ -> ,Ap(B   t/ -> ,A~(B   a/ -> ,Ae(B   e/ -> ,Af(B   o/ -> ,Ax(B
   special   |   /<>   | s/ -> ,A_(B   ?/ -> ,A?(B   !/ -> ,A!(B   << -> ,A+(B   >> -> ,A;(B
" nil t)

(quail-defrule "A`" ?,A@(B)
(quail-defrule "A'" ?,AA(B)
(quail-defrule "A^" ?,AB(B)
(quail-defrule "A~" ?,AC(B)
(quail-defrule "A\"" ?,AD(B)
(quail-defrule "A/" ?,AE(B)
(quail-defrule "a`" ?,A`(B)
(quail-defrule "a'" ?,Aa(B)
(quail-defrule "a^" ?,Ab(B)
(quail-defrule "a~" ?,Ac(B)
(quail-defrule "a\"" ?,Ad(B)
(quail-defrule "a/" ?,Ae(B)

(quail-defrule "E`" ?,AH(B)
(quail-defrule "E'" ?,AI(B)
(quail-defrule "E^" ?,AJ(B)
(quail-defrule "E\"" ?,AK(B)
(quail-defrule "E/" ?,AF(B)
(quail-defrule "e`" ?,Ah(B)
(quail-defrule "e'" ?,Ai(B)
(quail-defrule "e^" ?,Aj(B)
(quail-defrule "e\"" ?,Ak(B)
(quail-defrule "e/" ?,Af(B)

(quail-defrule "I`" ?,AL(B)
(quail-defrule "I'" ?,AM(B)
(quail-defrule "I^" ?,AN(B)
(quail-defrule "I\"" ?,AO(B)
(quail-defrule "i`" ?,Al(B)
(quail-defrule "i'" ?,Am(B)
(quail-defrule "i^" ?,An(B)
(quail-defrule "i\"" ?,Ao(B)

(quail-defrule "O`" ?,AR(B)
(quail-defrule "O'" ?,AS(B)
(quail-defrule "O^" ?,AT(B)
(quail-defrule "O\"" ?,AV(B)
(quail-defrule "O/" ?,AX(B)
(quail-defrule "o`" ?,Ar(B)
(quail-defrule "o'" ?,As(B)
(quail-defrule "o^" ?,At(B)
(quail-defrule "o\"" ?,Av(B)
(quail-defrule "o/" ?,Ax(B)

(quail-defrule "U`" ?,AY(B)
(quail-defrule "U'" ?,AZ(B)
(quail-defrule "U^" ?,A[(B)
(quail-defrule "U\"" ?,A\(B)
(quail-defrule "u`" ?,Ay(B)
(quail-defrule "u'" ?,Az(B)
(quail-defrule "u^" ?,A{(B)
(quail-defrule "u\"" ?,A|(B)

(quail-defrule "Y'" ?,A](B)
(quail-defrule "y'" ?,A}(B)

(quail-defrule "D/" ?,AP(B)
(quail-defrule "d/" ?,Ap(B)

(quail-defrule "T/" ?,A^(B)
(quail-defrule "t/" ?,A~(B)

(quail-defrule "s/" ?,A_(B)

(quail-defrule "C," ?,AG(B)
(quail-defrule "c," ?,Ag(B)

(quail-defrule "N~" ?,AQ(B)
(quail-defrule "n~" ?,Aq(B)

(quail-defrule "?/" ?,A?(B)
(quail-defrule "!/" ?,A!(B)
(quail-defrule "<<" ?,A+(B)
(quail-defrule ">>" ?,A;(B)


(quail-define-package "latin-2" "LATIN-2" nil "Latin-2 encoding.

    effect   | postfix | examples
 ------------+---------+----------
    acute    |    '    | a' -> ,Ba(B
    ogonek   |    ,    | a, -> ,B1(B
  diaeresis  |    \"    | a\" -> ,Bd(B
  circumflex |    ^    | a^ -> ,Bb(B
    breve    |    ~    | a~ -> ,Bc(B
   cedilla   |    ,    | c, -> ,Bg(B
    caron    |    ~    | c~ -> ,Bh(B
  dbl. acute |    ''   | o'' -> ,Bu(B
     ring    |    .    | u. -> ,By(B
     dot     |    .    | z. -> ,B?(B
    stroke   |    /    | d/ -> ,Bp(B
   special   |    /    | s/ -> ,B_(B
" nil t)

(quail-defrule "A'" ?,BA(B)
(quail-defrule "A," ?,B!(B)
(quail-defrule "A\"" ?,BD(B)
(quail-defrule "A^" ?,BB(B)
(quail-defrule "A~" ?,BC(B)
(quail-defrule "C'" ?,BF(B)
(quail-defrule "C," ?,BG(B)
(quail-defrule "C~" ?,BH(B)
(quail-defrule "D/" ?,BP(B)
(quail-defrule "D~" ?,BO(B)
(quail-defrule "E'" ?,BI(B)
(quail-defrule "E," ?,BJ(B)
(quail-defrule "E\"" ?,BK(B)
(quail-defrule "E~" ?,BL(B)
(quail-defrule "I'" ?,BM(B)
(quail-defrule "I^" ?,BN(B)
(quail-defrule "L'" ?,BE(B)
(quail-defrule "L/" ?,B#(B)
(quail-defrule "L~" ?,B%(B)
(quail-defrule "N'" ?,BQ(B)
(quail-defrule "N~" ?,BR(B)
(quail-defrule "O'" ?,BS(B)
(quail-defrule "O''" '(",BU(B" ",BS(B'"))
(quail-defrule "O\"" ?,BV(B)
(quail-defrule "O^" ?,BT(B)
(quail-defrule "R'" ?,B@(B)
(quail-defrule "R~" ?,BX(B)
(quail-defrule "S'" ?,B&(B)
(quail-defrule "S," ?,B*(B)
(quail-defrule "S~" ?,B)(B)
(quail-defrule "T," ?,B^(B)
(quail-defrule "T~" ?,B+(B)
(quail-defrule "U'" ?,BZ(B)
(quail-defrule "U''" '(",B[(B" ",BZ(B'"))
(quail-defrule "U\"" ?,B\(B)
(quail-defrule "U." ?,BY(B)
(quail-defrule "Y'" ?,B](B)
(quail-defrule "Z'" ?,B,(B)
(quail-defrule "Z." ?,B/(B)
(quail-defrule "Z~" ?,B.(B)
(quail-defrule "a'" ?,Ba(B)
(quail-defrule "a," ?,B1(B)
(quail-defrule "a\"" ?,Bd(B)
(quail-defrule "a^" ?,Bb(B)
(quail-defrule "a~" ?,Bc(B)
(quail-defrule "c'" ?,Bf(B)
(quail-defrule "c," ?,Bg(B)
(quail-defrule "c~" ?,Bh(B)
(quail-defrule "d/" ?,Bp(B)
(quail-defrule "d~" ?,Bo(B)
(quail-defrule "e'" ?,Bi(B)
(quail-defrule "e," ?,Bj(B)
(quail-defrule "e\"" ?,Bk(B)
(quail-defrule "e~" ?,Bl(B)
(quail-defrule "i'" ?,Bm(B)
(quail-defrule "i^" ?,Bn(B)
(quail-defrule "l'" ?,Be(B)
(quail-defrule "l/" ?,B3(B)
(quail-defrule "l~" ?,B5(B)
(quail-defrule "n'" ?,Bq(B)
(quail-defrule "n~" ?,Br(B)
(quail-defrule "o'" ?,Bs(B)
(quail-defrule "o''" '(",Bu(B" ",Bs(B'"))
(quail-defrule "o\"" ?,Bv(B)
(quail-defrule "o^" ?,Bt(B)
(quail-defrule "r'" ?,B`(B)
(quail-defrule "r~" ?,Bx(B)
(quail-defrule "s'" ?,B6(B)
(quail-defrule "s," ?,B:(B)
(quail-defrule "s/" ?,B_(B)
(quail-defrule "s~" ?,B9(B)
(quail-defrule "t," ?,B~(B)
(quail-defrule "t~" ?,B;(B)
(quail-defrule "u'" ?,Bz(B)
(quail-defrule "u''" '(",B{(B" ",Bz(B'"))
(quail-defrule "u\"" ?,B|(B)
(quail-defrule "u." ?,By(B)
(quail-defrule "y'" ?,B}(B)
(quail-defrule "z'" ?,B<(B)
(quail-defrule "z." ?,B?(B)
(quail-defrule "z~" ?,B>(B)


(quail-define-package "latin-3" "LATIN-3" nil "Latin-3 encoding.

    effect   | postfix | examples
 ------------+---------+----------
    acute    |    '    | a' -> ,Ca(B
    grave    |    `    | a` -> ,C`(B
  circumflex |    ^    | a^ -> ,Cb(B
  diaeresis  |    \"    | a\" -> ,Cd(B
     dot     |    .    | c. -> ,Ce(B   i. -> ,C9(B   I. -> ,C)(B
   cedilla   |    ,    | c, -> ,Cg(B
    breve    |    ~    | g~ -> ,C;(B
    tilde    |    ~    | n~ -> ,Cq(B
   stroke    |    /    | h/ -> ,C1(B
   special   |    /    | s/ -> ,C_(B
" nil t)

(quail-defrule "A`" ?,C@(B)
(quail-defrule "A'" ?,CA(B)
(quail-defrule "A^" ?,CB(B)
(quail-defrule "A\"" ?,CD(B)
(quail-defrule "C." ?,CE(B)
(quail-defrule "C^" ?,CF(B)
(quail-defrule "C," ?,CG(B)
(quail-defrule "E`" ?,CH(B)
(quail-defrule "E'" ?,CI(B)
(quail-defrule "E^" ?,CJ(B)
(quail-defrule "E\"" ?,CK(B)
(quail-defrule "G~" ?,C+(B)
(quail-defrule "G." ?,CU(B)
(quail-defrule "G^" ?,CX(B)
(quail-defrule "H/" ?,C!(B)
(quail-defrule "H^" ?,C&(B)
(quail-defrule "I." ?,C)(B)
(quail-defrule "I`" ?,CL(B)
(quail-defrule "I'" ?,CM(B)
(quail-defrule "I^" ?,CN(B)
(quail-defrule "I\"" ?,CO(B)
(quail-defrule "J^" ?,C,(B)
(quail-defrule "N~" ?,CQ(B)
(quail-defrule "O`" ?,CR(B)
(quail-defrule "O'" ?,CS(B)
(quail-defrule "O^" ?,CT(B)
(quail-defrule "O\"" ?,CV(B)
(quail-defrule "S," ?,C*(B)
(quail-defrule "S^" ?,C^(B)
(quail-defrule "U`" ?,CY(B)
(quail-defrule "U'" ?,CZ(B)
(quail-defrule "U^" ?,C[(B)
(quail-defrule "U\"" ?,C\(B)
(quail-defrule "U~" ?,C](B)
(quail-defrule "Z." ?,C/(B)
(quail-defrule "a`" ?,C`(B)
(quail-defrule "a'" ?,Ca(B)
(quail-defrule "a^" ?,Cb(B)
(quail-defrule "a\"" ?,Cd(B)
(quail-defrule "c." ?,Ce(B)
(quail-defrule "c^" ?,Cf(B)
(quail-defrule "c," ?,Cg(B)
(quail-defrule "e`" ?,Ch(B)
(quail-defrule "e'" ?,Ci(B)
(quail-defrule "e^" ?,Cj(B)
(quail-defrule "e\"" ?,Ck(B)
(quail-defrule "g~" ?,C;(B)
(quail-defrule "g." ?,Cu(B)
(quail-defrule "g^" ?,Cx(B)
(quail-defrule "h/" ?,C1(B)
(quail-defrule "h^" ?,C6(B)
(quail-defrule "i." ?,C9(B)
(quail-defrule "i`" ?,Cl(B)
(quail-defrule "i'" ?,Cm(B)
(quail-defrule "i^" ?,Cn(B)
(quail-defrule "i\"" ?,Co(B)
(quail-defrule "j^" ?,C<(B)
(quail-defrule "n~" ?,Cq(B)
(quail-defrule "o`" ?,Cr(B)
(quail-defrule "o'" ?,Cs(B)
(quail-defrule "o^" ?,Ct(B)
(quail-defrule "o\"" ?,Cv(B)
(quail-defrule "s," ?,C:(B)
(quail-defrule "s/" ?,C_(B)
(quail-defrule "s^" ?,C~(B)
(quail-defrule "u`" ?,Cy(B)
(quail-defrule "u'" ?,Cz(B)
(quail-defrule "u^" ?,C{(B)
(quail-defrule "u\"" ?,C|(B)
(quail-defrule "u~" ?,C}(B)
(quail-defrule "z." ?,C?(B)


(quail-define-package "latin-4" "LATIN-4" nil "Latin-4 encoding.

    effect   | postfix | examples
 ------------+---------+----------
    acute    |    '    | a' -> ,Da(B
  circumflex |    ^    | a^ -> ,Db(B
  diaeresis  |    \"    | a\" -> ,Dd(B
    ogonek   |    ,    | a, -> ,D1(B
    macron   |    -    | a- -> ,D`(B
    tilde    |    ~    | a~ -> ,Dc(B
    caron    |    ~    | c^ -> ,Dh(B
     dot     |    .    | e. -> ,Dl(B
   cedilla   |    ,    | k, -> ,Ds(B   g, -> ,D;(B
   stroke    |    /    | d/ -> ,Dp(B
   nordic    |    /    | a/ -> ,De(B   e/ -> ,Df(B   o/ -> ,Dx(B
   special   |    /    | s/ -> ,D_(B   n/ -> ,D?(B   k/ -> ,D"(B
" nil t)

(quail-defrule "A," ?,D!(B)
(quail-defrule "A-" ?,D@(B)
(quail-defrule "A'" ?,DA(B)
(quail-defrule "A^" ?,DB(B)
(quail-defrule "A~" ?,DC(B)
(quail-defrule "A\"" ?,DD(B)
(quail-defrule "A/" ?,DE(B)
(quail-defrule "C~" ?,DH(B)
(quail-defrule "D/" ?,DP(B)
(quail-defrule "E/" ?,DF(B)
(quail-defrule "E-" ?,D*(B)
(quail-defrule "E'" ?,DI(B)
(quail-defrule "E," ?,DJ(B)
(quail-defrule "E\"" ?,DK(B)
(quail-defrule "E." ?,DL(B)
(quail-defrule "G," ?,D+(B)
(quail-defrule "I~" ?,D%(B)
(quail-defrule "I," ?,DG(B)
(quail-defrule "I'" ?,DM(B)
(quail-defrule "I^" ?,DN(B)
(quail-defrule "I-" ?,DO(B)
(quail-defrule "K," ?,DS(B)
(quail-defrule "L," ?,D&(B)
(quail-defrule "N/" ?,D=(B)
(quail-defrule "N," ?,DQ(B)
(quail-defrule "O-" ?,DR(B)
(quail-defrule "O^" ?,DT(B)
(quail-defrule "O~" ?,DU(B)
(quail-defrule "O\"" ?,DV(B)
(quail-defrule "O/" ?,DX(B)
(quail-defrule "R," ?,D#(B)
(quail-defrule "S~" ?,D)(B)
(quail-defrule "T/" ?,D,(B)
(quail-defrule "U," ?,DY(B)
(quail-defrule "U'" ?,DZ(B)
(quail-defrule "U^" ?,D[(B)
(quail-defrule "U\"" ?,D\(B)
(quail-defrule "U~" ?,D](B)
(quail-defrule "U-" ?,D^(B)
(quail-defrule "Z~" ?,D.(B)
(quail-defrule "a," ?,D1(B)
(quail-defrule "a-" ?,D`(B)
(quail-defrule "a'" ?,Da(B)
(quail-defrule "a^" ?,Db(B)
(quail-defrule "a~" ?,Dc(B)
(quail-defrule "a\"" ?,Dd(B)
(quail-defrule "a/" ?,De(B)
(quail-defrule "c~" ?,Dh(B)
(quail-defrule "d/" ?,Dp(B)
(quail-defrule "e/" ?,Df(B)
(quail-defrule "e-" ?,D:(B)
(quail-defrule "e'" ?,Di(B)
(quail-defrule "e," ?,Dj(B)
(quail-defrule "e\"" ?,Dk(B)
(quail-defrule "e." ?,Dl(B)
(quail-defrule "g," ?,D;(B)
(quail-defrule "i~" ?,D5(B)
(quail-defrule "i," ?,Dg(B)
(quail-defrule "i'" ?,Dm(B)
(quail-defrule "i^" ?,Dn(B)
(quail-defrule "i-" ?,Do(B)
(quail-defrule "k/" ?,D"(B)
(quail-defrule "k," ?,Ds(B)
(quail-defrule "l," ?,D6(B)
(quail-defrule "n/" ?,D?(B)
(quail-defrule "n," ?,Dq(B)
(quail-defrule "o-" ?,Dr(B)
(quail-defrule "o^" ?,Dt(B)
(quail-defrule "o~" ?,Du(B)
(quail-defrule "o\"" ?,Dv(B)
(quail-defrule "o/" ?,Dx(B)
(quail-defrule "r," ?,D3(B)
(quail-defrule "s/" ?,D_(B)
(quail-defrule "s~" ?,D9(B)
(quail-defrule "t/" ?,D<(B)
(quail-defrule "u," ?,Dy(B)
(quail-defrule "u'" ?,Dz(B)
(quail-defrule "u^" ?,D{(B)
(quail-defrule "u\"" ?,D|(B)
(quail-defrule "u~" ?,D}(B)
(quail-defrule "u-" ?,D~(B)
(quail-defrule "z~" ?,D>(B)

(quail-define-package "latin-5" "LATIN-5" nil "Latin-5 encoding.

    effect   | postfix | examples
 ------------+---------+----------
    acute    |    '    | a' -> ,Ma(B
    grave    |    `    | a` -> ,M`(B
  circumflex |    ^    | a^ -> ,Mb(B
  diaeresis  |    \"    | a\" -> ,Md(B
    tilde    |    ~    | a~ -> ,Mc(B
    breve    |    ~    | g~ -> ,Mp(B
   cedilla   |    ,    | c, -> ,Mg(B
     dot     |    .    | i. -> ,M}(B   I. -> ,M](B
   nordic    |    /    | a/ -> ,Me(B   e/ -> ,Mf(B   o/ -> ,Mx(B
   special   |    /    | s/ -> ,M_(B
" nil t)

(quail-defrule "A'" ?,MA(B)
(quail-defrule "A/" ?,ME(B)
(quail-defrule "A\"" ?,MD(B)
(quail-defrule "A^" ?,MB(B)
(quail-defrule "A`" ?,M@(B)
(quail-defrule "A~" ?,MC(B)
(quail-defrule "C," ?,MG(B)
(quail-defrule "E'" ?,MI(B)
(quail-defrule "E/" ?,MF(B)
(quail-defrule "E\"" ?,MK(B)
(quail-defrule "E^" ?,MJ(B)
(quail-defrule "E`" ?,MH(B)
(quail-defrule "G~" ?,MP(B)
(quail-defrule "I'" ?,MM(B)
(quail-defrule "I." ?,M](B)
(quail-defrule "I\"" ?,MO(B)
(quail-defrule "I^" ?,MN(B)
(quail-defrule "I`" ?,ML(B)
(quail-defrule "N~" ?,MQ(B)
(quail-defrule "O'" ?,MS(B)
(quail-defrule "O/" ?,MX(B)
(quail-defrule "O\"" ?,MV(B)
(quail-defrule "O^" ?,MT(B)
(quail-defrule "O`" ?,MR(B)
(quail-defrule "O~" ?,MU(B)
(quail-defrule "S," ?,M^(B)
(quail-defrule "U'" ?,MZ(B)
(quail-defrule "U\"" ?,M\(B)
(quail-defrule "U^" ?,M[(B)
(quail-defrule "U`" ?,MY(B)
(quail-defrule "a'" ?,Ma(B)
(quail-defrule "a/" ?,Me(B)
(quail-defrule "a\"" ?,Md(B)
(quail-defrule "a^" ?,Mb(B)
(quail-defrule "a`" ?,M`(B)
(quail-defrule "a~" ?,Mc(B)
(quail-defrule "c," ?,Mg(B)
(quail-defrule "e'" ?,Mi(B)
(quail-defrule "e/" ?,Mf(B)
(quail-defrule "e\"" ?,Mk(B)
(quail-defrule "e^" ?,Mj(B)
(quail-defrule "e`" ?,Mh(B)
(quail-defrule "g~" ?,Mp(B)
(quail-defrule "i'" ?,Mm(B)
(quail-defrule "i." ?,M}(B)
(quail-defrule "i\"" ?,Mo(B)
(quail-defrule "i^" ?,Mn(B)
(quail-defrule "i`" ?,Ml(B)
(quail-defrule "n~" ?,Mq(B)
(quail-defrule "o'" ?,Ms(B)
(quail-defrule "o/" ?,Mx(B)
(quail-defrule "o\"" ?,Mv(B)
(quail-defrule "o^" ?,Mt(B)
(quail-defrule "o`" ?,Mr(B)
(quail-defrule "o~" ?,Mu(B)
(quail-defrule "s," ?,M~(B)
(quail-defrule "s/" ?,M_(B)
(quail-defrule "u'" ?,Mz(B)
(quail-defrule "u\"" ?,M|(B)
(quail-defrule "u^" ?,M{(B)
(quail-defrule "u`" ?,My(B)
(quail-defrule "y\"" ?,M(B)


(quail-define-package "danish" "DANSK" nil "Latin-1 encoding.

AE -> ,AF(B
OE -> ,AX(B
AA -> ,AE(B
E' -> ,AI(B
" nil t)

(quail-defrule "AE" ?,AF(B)
(quail-defrule "ae" ?,Af(B)

(quail-defrule "OE" ?,AX(B)
(quail-defrule "oe" ?,Ax(B)

(quail-defrule "AA" ?,AE(B)
(quail-defrule "aa" ?,Ae(B)

(quail-defrule "E'" ?,AI(B)
(quail-defrule "e'" ?,Ai(B)


(quail-define-package "esperanto" "ESPERANTO" nil "Latin-3 encoding.

Preceding ^ or following x will produce accented characters,
e.g. ^C -> ,CF(B, Gx -> ,CX(B.
" nil t)
(quail-defrule "Cx" ?,CF(B)
(quail-defrule "^C" ?,CF(B)
(quail-defrule "cx" ?,Cf(B)
(quail-defrule "^c" ?,Cf(B)

(quail-defrule "Gx" ?,CX(B)
(quail-defrule "^G" ?,CX(B)
(quail-defrule "gx" ?,Cx(B)
(quail-defrule "^g" ?,Cx(B)

(quail-defrule "Hx" ?,C&(B)
(quail-defrule "^H" ?,C&(B)
(quail-defrule "hx" ?,C6(B)
(quail-defrule "^h" ?,C6(B)

(quail-defrule "Jx" ?,C,(B)
(quail-defrule "^J" ?,C,(B)
(quail-defrule "jx" ?,C<(B)
(quail-defrule "^j" ?,C<(B)

(quail-defrule "Sx" ?,C^(B)
(quail-defrule "^S" ?,C^(B)
(quail-defrule "sx" ?,C~(B)
(quail-defrule "^s" ?,C~(B)

(quail-defrule "Ux" ?,C](B)
(quail-defrule "^U" ?,C](B)
(quail-defrule "~U" ?,C](B)
(quail-defrule "ux" ?,C}(B)
(quail-defrule "^u" ?,C}(B)
(quail-defrule "~u" ?,C}(B)


(quail-define-package "finnish" "SUOMI" nil "Latin-1 encoding.

AE -> ,AD(B
OE -> ,AV(B
" nil t)

(quail-defrule "AE" ?,AD(B)
(quail-defrule "ae" ?,Ad(B)

(quail-defrule "OE" ?,AV(B)
(quail-defrule "oe" ?,Av(B)


(quail-define-package "french" "FRAN,AG(BAIS" nil "Latin-1 encoding.

` pour grave, ' pour aigu, ^ pour circonflexe, et \" pour tr,Ai(Bma.
Par exemple A` -> ,A@(B, E' -> ,AI(B.

,AG(B, ,A+(B, et ,A;(B sont produits par C/, <<, et >>.

<e dans l'o> n'est pas disponible.
" nil t)

(quail-defrule "A`" ?,A@(B)
(quail-defrule "A^" ?,AB(B)
(quail-defrule "a`" ?,A`(B)
(quail-defrule "a^" ?,Ab(B)

(quail-defrule "E`" ?,AH(B)
(quail-defrule "E'" ?,AI(B)
(quail-defrule "E^" ?,AJ(B)
(quail-defrule "E\"" ?,AK(B)
(quail-defrule "e`" ?,Ah(B)
(quail-defrule "e'" ?,Ai(B)
(quail-defrule "e^" ?,Aj(B)
(quail-defrule "e\"" ?,Ak(B)

(quail-defrule "I^" ?,AN(B)
(quail-defrule "I\"" ?,AO(B)
(quail-defrule "i^" ?,An(B)
(quail-defrule "i\"" ?,Ao(B)

(quail-defrule "O^" ?,AT(B)
(quail-defrule "o^" ?,At(B)

(quail-defrule "U`" ?,AY(B)
(quail-defrule "U^" ?,A[(B)
(quail-defrule "U\"" ?,A\(B)
(quail-defrule "u`" ?,Ay(B)
(quail-defrule "u^" ?,A{(B)
(quail-defrule "u\"" ?,A|(B)

(quail-defrule "C/" ?,AG(B)
(quail-defrule "c/" ?,Ag(B)

(quail-defrule "<<" ?,A+(B)
(quail-defrule ">>" ?,A;(B)


(quail-define-package "german" "DEUTSCH" nil "Latin-1 encoding.

AE -> ,AD(B
OE -> ,AV(B
UE -> ,A\(B
sz -> ,A_(B

,A_(B can also be input by 'ss' followed by M-n.
" nil t)

(quail-defrule "AE" ?,AD(B)
(quail-defrule "ae" ?,Ad(B)

(quail-defrule "OE" ?,AV(B)
(quail-defrule "oe" ?,Av(B)

(quail-defrule "UE" ?,A\(B)
(quail-defrule "ue" ?,A|(B)

(quail-defrule "sz" ?,A_(B)
(quail-defrule "ss" '("ss" ?,A_(B))


(quail-define-package "icelandic" ",AM(BSLENSKA" nil "Latin-1 encoding.

A' -> ,AA(B
E' -> ,AI(B
I' -> ,AM(B
O' -> ,AS(B
U' -> ,AZ(B
Y' -> ,A](B
AE -> ,AF(B
OE -> ,AV(B
D/ -> ,AP(B (eth)
T/ -> ,A^(B (thorn)
" nil t)

(quail-defrule "A'" ?,AA(B)
(quail-defrule "a'" ?,Aa(B)

(quail-defrule "E'" ?,AI(B)
(quail-defrule "e'" ?,Ai(B)

(quail-defrule "I'" ?,AM(B)
(quail-defrule "i'" ?,Am(B)

(quail-defrule "O'" ?,AS(B)
(quail-defrule "o'" ?,As(B)

(quail-defrule "U'" ?,AZ(B)
(quail-defrule "u'" ?,Az(B)

(quail-defrule "Y'" ?,A](B)
(quail-defrule "y'" ?,A}(B)

(quail-defrule "AE" ?,AF(B)
(quail-defrule "ae" ?,Af(B)

(quail-defrule "OE" ?,AV(B)
(quail-defrule "oe" ?,Av(B)

(quail-defrule "D/" ?,AP(B)
(quail-defrule "d/" ?,Ap(B)

(quail-defrule "T/" ?,A^(B)
(quail-defrule "t/" ?,A~(B)


(quail-define-package "italian" "ITALIANO" nil "Latin-1 encoding.

A` -> ,A@(B
E` -> ,AH(B
I` -> ,AL(B
O` -> ,AR(B
U` -> ,AY(B
" nil t)

(quail-defrule "A`" ?,A@(B)
(quail-defrule "a`" ?,A`(B)

(quail-defrule "E`" ?,AH(B)
(quail-defrule "e`" ?,Ah(B)

(quail-defrule "I`" ?,AL(B)
(quail-defrule "i`" ?,Al(B)

(quail-defrule "O`" ?,AR(B)
(quail-defrule "o`" ?,Ar(B)

(quail-defrule "U`" ?,AY(B)
(quail-defrule "u`" ?,Ay(B)


(quail-define-package "norwegian" "NORSK" nil "Latin-1 encoding.

AE -> ,AF(B
OE -> ,AX(B
AA -> ,AE(B
E' -> ,AI(B
" nil t)

(quail-defrule "AE" ?,AF(B)
(quail-defrule "ae" ?,Af(B)

(quail-defrule "OE" ?,AX(B)
(quail-defrule "oe" ?,Ax(B)

(quail-defrule "AA" ?,AE(B)
(quail-defrule "aa" ?,Ae(B)

(quail-defrule "E'" ?,AI(B)
(quail-defrule "e'" ?,Ai(B)


(quail-define-package "scandinavian" "SCANDINAVIAN" nil "Latin-1 encoding.

Quail package for scandinavian languages (swidish, norwegian, danish, finnish).

AE -> ,AD(B or ,AF(B
OE -> ,AV(B or ,AX(B
AA -> ,AE(B
E' -> ,AI(B.

You can toggle between ,AD(B and ,AF(B, or between OE and ,AV(B, by typing M-n
when the character is underlined.
" nil)

(quail-defrule "AE" '(?,AD(B ?,AF(B))
(quail-defrule "ae" '(?,Ad(B ?,Af(B))

(quail-defrule "AA" ?,AE(B)
(quail-defrule "aa" ?,Ae(B)

(quail-defrule "OE" '(?,AV(B ?,AX(B))
(quail-defrule "oe" '(?,Av(B ?,Ax(B))

(quail-defrule "E'" ?,AI(B)
(quail-defrule "e'" ?,Ai(B)


(quail-define-package "spanish" "ESPA,AQ(BOL" nil "Latin-1 encoding.

A' -> ,AA(B
E' -> ,AI(B
I' -> ,AM(B
O' -> ,AS(B
U' -> ,AZ(B
N~ -> ,AQ(B
!/ -> ,A!(B
?/ -> ,A?(B
" nil t)

(quail-defrule "A'" ?,AA(B)
(quail-defrule "a'" ?,Aa(B)

(quail-defrule "E'" ?,AI(B)
(quail-defrule "e'" ?,Ai(B)

(quail-defrule "I'" ?,AM(B)
(quail-defrule "i'" ?,Am(B)

(quail-defrule "O'" ?,AS(B)
(quail-defrule "o'" ?,As(B)

(quail-defrule "U'" ?,AZ(B)
(quail-defrule "u'" ?,Az(B)

(quail-defrule "N~" ?,AQ(B)
(quail-defrule "n~" ?,Aq(B)

(quail-defrule "?/" ?,A?(B)
(quail-defrule "!/" ?,A!(B)


(quail-define-package "swedish" "SVENSKA" nil "Latin-1 encoding.

AA -> ,AE(B
AE -> ,AD(B
OE -> ,AV(B
E' -> ,AI(B
" nil t)

(quail-defrule "AA" ?,AE(B)
(quail-defrule "aa" ?,Ae(B)

(quail-defrule "AE" ?,AD(B)
(quail-defrule "ae" ?,Ad(B)

(quail-defrule "OE" ?,AV(B)
(quail-defrule "oe" ?,Av(B)

(quail-defrule "E'" ?,AI(B)
(quail-defrule "e'" ?,Ai(B)


(quail-define-package "turkish" "T,C|(Brk,Cg(Be" nil "Latin-3 encoding.

Note for I, ,C9(B, ,C)(B, i.

A^ -> ,CB(B
C/ -> ,CG(B
G^ -> ,C+(B
I  -> I
i  -> ,C9(B
I' -> ,C)(B
i' -> i
O\" -> ,CV(B
S/ -> ,C*(B
U\" -> ,C\(B
U^ -> ,C[(B
" nil t)

(quail-defrule "A^" ?,CB(B)
(quail-defrule "a^" ?,Cb(B)

(quail-defrule "C/" ?,CG(B)
(quail-defrule "c/" ?,Cg(B)

(quail-defrule "G^" ?,C+(B)
(quail-defrule "g^" ?,C;(B)

(quail-defrule "I'" ?,C)(B)
(quail-defrule "i" ?,C9(B)
(quail-defrule "i'" ?i)

(quail-defrule "O\"" ?,CV(B)
(quail-defrule "o\"" ?,Cv(B)

(quail-defrule "S/" ?,C*(B)
(quail-defrule "s/" ?,C:(B)

(quail-defrule "U\"" ?,C\(B)
(quail-defrule "u\"" ?,C|(B)
(quail-defrule "U^" ?,C[(B)
(quail-defrule "u^" ?,C{(B)


(quail-define-package "british" "BRITISH" nil "Latin-1 encoding.

# is replaced by ,A#(B." nil t)

(quail-defrule "#" '(?,A#(B ?#))


;; Initial package should be the most popular one.
(quail-use-package "latin-1")
