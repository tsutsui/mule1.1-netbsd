;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).
;; This file contains Chinese characters.

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

;; 92.3.6   Written for Mule Ver.0.9.0 by K.Handa <handa@etl.go.jp>
;;	Original table is from cxterm/dict/tit/PY-b5.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # Generated from p.cit by cit2tit
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	BIG5
;; MULTICHOICE:	YES
;; PROMPT:	$(0KH)tTT&,(B::$(03<5x(B::
;; #
;; COMMENT	$(0KHM$3<5xTT&,'J7{&v>V(B   ($(00D5x>KHAJXFz(B)
;; COMMENT	
;; COMMENT				$(0Vy(a(B (CONSONANT)
;; COMMENT	
;; COMMENT	$(0$u(B $(0$v(B $(0$w(B $(0$x(B  $(0$y(B $(0$z(B $(0${(B $(0$|(B  $(0$}(B $(0$~(B $(0%!(B  $(0%"(B $(0%#(B $(0%$(B  $(0%%(B $(0%&(B $(0%'(B $(0%((B  $(0%)(B $(0%*(B $(0%+(B
;; COMMENT	b  p  m  f   d  t  n  l   g  k  h   j  q  x   zh ch sh r   z  c  s
;; COMMENT	$(04E(B $(0.\(B $(0Jv(B $(0*t(B  $(0<6(B $(08X(B $(0?B(B $(0;-(B  $(06Y(B $(04p(B $(0@C(B  $(0;X(B $(0B#(B $(0,)(B  $(01"(B $(0:+(B $(0H^(B $(0'K(B  $(0Hr(B $(0Md(B $(03)(B
;; COMMENT	
;; COMMENT				$(0[J(a(B (VOWEL)
;; COMMENT	
;; COMMENT		$(0%,(B  $(0%-(B  $(0%.(B  $(0%/(B  $(0%0(B  $(0%1(B  $(0%2(B  $(0%3(B  $(0%4(B  $(0%5(B  $(0%6(B  $(0%7(B  $(0%8(B
;; COMMENT		a   o   e   e   ai  ei  ao  ou  an  en  ang eng er
;; COMMENT		$(0;@(B  $(0@H(B  $(0Z'(B ($(05((B) $(028(B  $(16>(B  $(0O_(B  $(0OD(B  $(0)y(B  $(07J(B  $(0/|(B ($(0*m(B) $(0.$(B
;; COMMENT	
;; COMMENT	    $(0%9(B  $(0%9%,(B $(0%9%-(B $(0%9%.(B $(0%9%/(B $(0%9%0(B $(0%9%1(B $(0%9%2(B $(0%9%3(B $(0%9%4(B $(0%9%5(B $(0%9%6(B $(0%9%7(B
;; COMMENT	C+   i   ia   io   --   ie   --   --   iao  iu   ian  in  iang  ing
;; COMMENT	 +  yi   ya   yo   --   ye   ai   --   yao  you  yan  yin yang ying
;; COMMENT	    $(0*i(B   $(0+U(B   $(06W(B        $(05((B   $(0;{(B        $(0H#(B   $(0Nh(B   $(0Fv(B   $(0)_(B   $(0(B(B   $(05C(B
;; COMMENT	
;; COMMENT	    $(0%:(B  $(0%:%,(B $(0%:%-(B $(0%:%.(B $(0%:%/(B $(0%:%0(B $(0%:%1(B $(0%:%2(B $(0%:%3(B $(0%:%4(B $(0%:%5(B $(0%:%6(B $(0%:%7(B
;; COMMENT	C+  u    ua   uo   --   --   uai  ui   --   --   uan  un  uang  ong
;; COMMENT	 +  wu   wa   wo   --   --   wai  wei  --   --   wan  wen wang weng
;; COMMENT	    $(02q(B   $(0Cs(B   $(0L%(B             $(03r(B   $(02e(B             $(0]`(B   $(0Fl(B   $(0,n(B   $(09S(B
;; COMMENT	
;; COMMENT	    $(0%;(B  $(0%;%,(B $(0%;%-(B $(0%;%.(B $(0%;%/(B $(0%;%0(B $(0%;%1(B $(0%;%2(B $(0%;%3(B $(0%;%4(B $(0%;%5(B $(0%;%6(B $(0%;%7(B
;; COMMENT	j+   u   --   --   --   ue   --   --   --   --   uan  un   --  iong
;; COMMENT	l+  u:   --   --   --  u:e   --   --   --   --  u:an  u:n  --   --
;; COMMENT	 +  yu   --   --   --  yue   --   --   --   --  yuan  yun  --  yong
;; COMMENT	    $(0-S(B                  $(04}(B                       $(06C(B   $(0F@(B        $(0IU(B
;; COMMENT	
;; COMMENT	C+ -> $(02*5t<(*5Vy(a0|7m69(B,       + -> $(02*5t,u*5Vy(a0|7m69(B,
;; COMMENT	j+ -> $(0HzVy(a(B j,q,x $(03<0|7m69(B,   l+ -> $(0HzVy(a(B l,n $(03<0|7m69(B
;; COMMENT
;; # define keys
;; VALIDINPUTKEY:	12345:abcdefghijklmnopqrstuvwxyz
;; SELECTKEY:	1\040
;; SELECTKEY:	2
;; SELECTKEY:	3
;; SELECTKEY:	4
;; SELECTKEY:	5
;; SELECTKEY:	6
;; SELECTKEY:	7
;; SELECTKEY:	8
;; SELECTKEY:	9
;; SELECTKEY:	0
;; BACKSPACE:	\010\177
;; DELETEALL:	\015\025
;; MOVERIGHT:	.>
;; MOVELEFT:	,<
;; REPEATKEY:	\020\022
;; # the following line must not be removed
;; BEGINDICTIONARY
;; #

(require 'quail)

(quail-define-package
 "py-b5" "$(03<5x(B" nil
 "$(0KH)tTT&,(B::$(03<5x(B::

	$(0KHM$3<5xTT&,'J7{&v>V(B   ($(00D5x>KHAJXFz(B)
	
				$(0Vy(a(B (CONSONANT)
	
	$(0$u(B $(0$v(B $(0$w(B $(0$x(B  $(0$y(B $(0$z(B $(0${(B $(0$|(B  $(0$}(B $(0$~(B $(0%!(B  $(0%"(B $(0%#(B $(0%$(B  $(0%%(B $(0%&(B $(0%'(B $(0%((B  $(0%)(B $(0%*(B $(0%+(B
	b  p  m  f   d  t  n  l   g  k  h   j  q  x   zh ch sh r   z  c  s
	$(04E(B $(0.\(B $(0Jv(B $(0*t(B  $(0<6(B $(08X(B $(0?B(B $(0;-(B  $(06Y(B $(04p(B $(0@C(B  $(0;X(B $(0B#(B $(0,)(B  $(01"(B $(0:+(B $(0H^(B $(0'K(B  $(0Hr(B $(0Md(B $(03)(B
	
				$(0[J(a(B (VOWEL)
	
		$(0%,(B  $(0%-(B  $(0%.(B  $(0%/(B  $(0%0(B  $(0%1(B  $(0%2(B  $(0%3(B  $(0%4(B  $(0%5(B  $(0%6(B  $(0%7(B  $(0%8(B
		a   o   e   e   ai  ei  ao  ou  an  en  ang eng er
		$(0;@(B  $(0@H(B  $(0Z'(B ($(05((B) $(028(B  $(16>(B  $(0O_(B  $(0OD(B  $(0)y(B  $(07J(B  $(0/|(B ($(0*m(B) $(0.$(B
	
	    $(0%9(B  $(0%9%,(B $(0%9%-(B $(0%9%.(B $(0%9%/(B $(0%9%0(B $(0%9%1(B $(0%9%2(B $(0%9%3(B $(0%9%4(B $(0%9%5(B $(0%9%6(B $(0%9%7(B
	C+   i   ia   io   --   ie   --   --   iao  iu   ian  in  iang  ing
	 +  yi   ya   yo   --   ye   ai   --   yao  you  yan  yin yang ying
	    $(0*i(B   $(0+U(B   $(06W(B        $(05((B   $(0;{(B        $(0H#(B   $(0Nh(B   $(0Fv(B   $(0)_(B   $(0(B(B   $(05C(B
	
	    $(0%:(B  $(0%:%,(B $(0%:%-(B $(0%:%.(B $(0%:%/(B $(0%:%0(B $(0%:%1(B $(0%:%2(B $(0%:%3(B $(0%:%4(B $(0%:%5(B $(0%:%6(B $(0%:%7(B
	C+  u    ua   uo   --   --   uai  ui   --   --   uan  un  uang  ong
	 +  wu   wa   wo   --   --   wai  wei  --   --   wan  wen wang weng
	    $(02q(B   $(0Cs(B   $(0L%(B             $(03r(B   $(02e(B             $(0]`(B   $(0Fl(B   $(0,n(B   $(09S(B
	
	    $(0%;(B  $(0%;%,(B $(0%;%-(B $(0%;%.(B $(0%;%/(B $(0%;%0(B $(0%;%1(B $(0%;%2(B $(0%;%3(B $(0%;%4(B $(0%;%5(B $(0%;%6(B $(0%;%7(B
	j+   u   --   --   --   ue   --   --   --   --   uan  un   --  iong
	l+  u:   --   --   --  u:e   --   --   --   --  u:an  u:n  --   --
	 +  yu   --   --   --  yue   --   --   --   --  yuan  yun  --  yong
	    $(0-S(B                  $(04}(B                       $(06C(B   $(0F@(B        $(0IU(B
	
	C+ -> $(02*5t<(*5Vy(a0|7m69(B,       + -> $(02*5t,u*5Vy(a0|7m69(B,
	j+ -> $(0HzVy(a(B j,q,x $(03<0|7m69(B,   l+ -> $(0HzVy(a(B l,n $(03<0|7m69(B"
 *quail-mode-rich-map* nil nil nil nil t)

(defmacro qdl (key str)
  (list 'quail-defrule key (list 'string-to-char-list str)))

(qdl "a1" "\
$(01`%,(B")
(qdl "a2" "\
$(0;@1`(B")
(qdl "a4" "\
$(01`(B")
(qdl "ai1" "\
$(07e286n6a2:%0$(1N7(B")
(qdl "ai2" "\
$(0<_Os$(1`pJ]$(0;{$(1EE4-4h(B")
(qdl "ai3" "\
$(0GO\3^s$(16>$I*y#&(B")
(qdl "ai4" "\
$(0EyZU*eUqVAIRRF$(1!!qHOW(B\
$(1:iV_lY_d]Aa+i}N7^u(B")
(qdl "an1" "\
$(0)yQl<.TE88MX%4[[$(1;&%I(B\
$(1Xa*(E2F;F}j[)R(B")
(qdl "an2" "\
$(1H`,0:[(B")
(qdl "an3" "\
$(062$(14!<H:d(B")
(qdl "an4" "\
$(0F=7{/'3;]SCa$(1`<"c3%%Y(B\
$(1/^+`2S[K.24mVD(B")
(qdl "ang1" "\
$(0MsCR%6(B")
(qdl "ang2" "\
$(0/|$(1!8(B")
(qdl "ang3" "\
$(1@h(B")
(qdl "ang4" "\
$(08x$(1_x(B")
(qdl "ao1" "\
$(0'x%2$(1%}+E(B")
(qdl "ao2" "\
$(0O_<sQMSuJ1$(1_5nc$(0^~[<$(1lm(B\
$(1J%R"R3$(0Vx$(1g[KXXlO%PVSB(B\
$(1bXcTex(B")
(qdl "ao3" "\
$(0ZxEf$(1(^:*(B")
(qdl "ao4" "\
$(0E.S/E`R\$(1VX:x$5W9@KVu(B")
(qdl "b" "\
$(0$u(B")
(qdl "ba1" "\
$(0&-7g'<4Q1A9>$(11m$(0(=(W$(19U(B\
$(0+D$(1!5"W(B")
(qdl "ba2" "\
$(0/aDCIB$(1V%-2e3@d!d?U,|(B\
$(1@@(B")
(qdl "ba3" "\
$(0,EI_$(1A2(B")
(qdl "ba4" "\
$(0PH0j]>^_9W$(1#s$(0^a+%$(17,(B")
(qdl "ba5" "\
$(0+DPHBd0-(B")
(qdl "bai1" "\
$(1;y(B")
(qdl "bai2" "\
$(0(v(B")
(qdl "bai3" "\
$(0*LXH-w]*$(1>o5^iH>}(B")
(qdl "bai4" "\
$(0<v39$(1.=Lj<fiH#q(B")
(qdl "ban1" "\
$(08_9pF1AYId,IOr$(1_%CD'#(B\
$(1ZE(B")
(qdl "ban3" "\
$(0030kW~-c9o$(1'($(0Db$(11lMv(B")
(qdl "ban4" "\
$(0(%TW*s,M/X>R.uZO$(1!C&m(B\
$(16IHIO)(B")
(qdl "bang1" "\
$(0UZ-[@+=<$(1dLYG.Z(B")
(qdl "bang3" "\
$(0K'Gr$(1Kn$(0LQ$(1Ws(B")
(qdl "bang4" "\
$(0AtO|WH:,@+YU7k$(1]_B3Ya(B")
(qdl "bao1" "\
$(0'~525HPp$(1+58#Z"&7(B")
(qdl "bao2" "\
$(0I[$(11`(1(B")
(qdl "bao3" "\
$(01r[kIh@`PqH>$(1V5&oOAON(B\
$(1;%(B")
(qdl "bao4" "\
$(0@_/mO3ZG:BU6+6$(13*$(0IG$(1Z%(B\
$(0^N$(1\H?rD[9GaIe}hw(B")
(qdl "bei1" "\
$(05.01A,.9GW6?AT$(13W$(04[L}(B\
$(1?c5x<f!wL|h\fa(B")
(qdl "bei3" "\
$(0("(B")
(qdl "bei4" "\
$(0?8@-5.-KQE6$W"8[RX7S(B\
$(0+yBOLh$(1T3$(01Y$(1>0N9$(0Qb$(1.BY3(B\
$(1607:@~+{3=KpaM(B")
(qdl "ben1" "\
$(0.eD6$(1[3'j6P(B")
(qdl "ben3" "\
$(0(\8h5K(B")
(qdl "ben4" "\
$(0>H$(1"~#L(B")
(qdl "beng1" "\
$(0;~Vi$(1"{52,WAAIF>s(B")
(qdl "beng2" "\
$(04K(B")
(qdl "beng3" "\
$(1?M()>%4BGW(B")
(qdl "beng4" "\
$(0YG$(1C$+Q$(0:T$(1Go(B")
(qdl "bi1" "\
$(0I0$(1&;3QLMTQ(B")
(qdl "bi2" "\
$(0M|(B")
(qdl "bi3" "\
$(0'SC./?MI&2-!$(1,\&;2_$(0+n(B\
$(1$qQi+'"VTR(B")
(qdl "bi4" "\
$(0(S<r>,RJWbXf?qMIW"J](B\
$(0Jc;fUoKy0G6?PS,+J6A8(B\
$(0I)A%L}:e;WL2Sf$(1(4$(0'S$(1Vc(B\
$(0GLD6$(1lC$(0Zy$(1+KSY$(0YJ$(1df&\50(B\
$(1;fCW=70gR!^0-0$(0W.$(1ZJ$(0D/(B\
$(1j)(tHU*~5u,*$(0G=$(1HjO;Up(B\
$(1d,no>=:n$(0IL$(1E5F=U|#OKG(B\
$(1Qq,@&.ganu+*"zG.J(La(B\
$(1MRU#YM\"_De%ixljqo(W(B\
$(11nEcI\R*V|cw^C(B")
(qdl "bian1" "\
$(0[1P>YkPh9'$(1q-ReLQ=~K~(B\
$(1+BCkD\(B")
(qdl "bian3" "\
$(038D;;6Ps$(11ZFv;lL=(B")
(qdl "bian4" "\
$(01n^II6TV]4,z\*$(1#y$(0(P-^(B\
$(1$)RvS6$(0'-$(1<8$[\6HW(B")
(qdl "biao1" "\
$(0O:?*^L[=$(1ld$(0PQ$(1QnV<fJI2(B\
$(0,b$(1KLay=tXXiPO7r>JJ\E(B\
$(1fPAS3McXIMg7SFezfY(B")
(qdl "biao3" "\
$(01QTa;i$(1N"-q_B]3TK(B")
(qdl "biao4" "\
$(0^-(B")
(qdl "bie1" "\
$(1PC$(0^+$(1r.(B")
(qdl "bie2" "\
$(0+2$(1cq%\J*_D_=(B")
(qdl "bie3" "\
$(0ZR$(19&(B")
(qdl "bie4" "\
$(0Jd$(1^C(B")
(qdl "bin1" "\
$(0M4V$<3XNR4$(1<@$(0\+WRZE$(1%-(B\
$(1b.irn8N<!a<|gmf)pc(B")
(qdl "bin4" "\
$(0XX^wR4$(1\t$(0Y-$(1pdk:(B")
(qdl "bing1" "\
$(0+/)D$(15a/\(B")
(qdl "bing3" "\
$(0Mo'`Gc3d1'45$(1*v(u&_`M(B\
$(0MY$(193(}-B1[$(02o$(1*7(B")
(qdl "bing4" "\
$(0-e8k-x*!AR$(1;<a'3V(B")
(qdl "bo1" "\
$(04EO!6NC[>`$(1P21@ES9<cB(B\
$(1ok3u+<g@&K(B")
(qdl "bo2" "\
$(0+%@<3j0]20F2B9MrW,>j(B\
$(0/0>sL.>xP\LTIB$(1Uk$(0II$(1k](B\
$(1d}T_0.l:NMd&[mI%d[ju(B\
$(16*_X$(0Uz$(1[l-'/7DpF[UCaY(B\
$(1bQf/qC3;qlf<(B")
(qdl "bo3" "\
$(0DGZ[$(195(B")
(qdl "bo4" "\
$(0O'UfZ[6"W.$(1g1$(0W,Uz]"$(1fE(B\
$(1*b(B")
(qdl "bu1" "\
$(19h5mUl.od~(B")
(qdl "bu2" "\
$(0&c(B")
(qdl "bu3" "\
$(0HQ7[6l6\&4$(1HsR'(B")
(qdl "bu4" "\
$(0&c?f(M,d/I+*ZZ;VIC$(1S:(B\
$(1^8/M%m(B")
(qdl "c" "\
$(0%*(B")
(qdl "ca1" "\
$(0UiF0$(1\L(B")
(qdl "ca3" "\
$(1iM(B")
(qdl "ca4" "\
$(1kS(B")
(qdl "cai1" "\
$(0=w(B")
(qdl "cai2" "\
$(0&`:C,ZC{^D(B")
(qdl "cai3" "\
$(0<i<41ZGJQ=LC$(1G{4v<b4n(B")
(qdl "cai4" "\
$(0P[Cm$(14N$(01Z$(1^G(B")
(qdl "can1" "\
$(0;7U($(1ll(B")
(qdl "can2" "\
$(0B%^gJn$(1Vf(B")
(qdl "can3" "\
$(0Jo$(1PL<NOgp((B")
(qdl "can4" "\
$(0V5@mVB$(1E{X0(B")
(qdl "cang1" "\
$(0Lj6AFpS~@0$(1m1:GB](B")
(qdl "cang2" "\
$(0Y/$(1qe(B")
(qdl "cao1" "\
$(0RhVb$(1[#A{(B")
(qdl "cao2" "\
$(0=+O;J4KP$(1_+^^Im(B")
(qdl "cao3" "\
$(09x$(1W(ji"j(B")
(qdl "cao4" "\
$(0VbRh$(1(Lg!(B")
(qdl "ce4" "\
$(0'vC-BB;"A"A4$(1Ep1&2A8'(B\
$(1*eEKPQMZ(B")
(qdl "cen1" "\
$(0;7$(1It5z(B")
(qdl "cen2" "\
$(0,%8P$(15}1k.[(B")
(qdl "ceng1" "\
$(1Ob(B")
(qdl "ceng2" "\
$(0AeNR$(1P0U!EX(B")
(qdl "ceng4" "\
$(1g>(B")
(qdl "ch" "\
$(0%&(B")
(qdl "cha1" "\
$(07:AG&G@L$(1YbA~"K$D3\XV(B\
$(1d/(B")
(qdl "cha2" "\
$(03hJW9~F0$(1Ji_|L7-,)S(E(B")
(qdl "cha3" "\
$(1Zl(B")
(qdl "cha4" "\
$(0HZ,&2'7:$(1"]-PMe%3".,n(B")
(qdl "chai1" "\
$(0/q?k7:$(1:A(B")
(qdl "chai2" "\
$(08):AR5$(17fA}(B")
(qdl "chai4" "\
$(1fq2|mG(B")
(qdl "chan1" "\
$(0[q$(1<ef|%'UJ;^Vak_(B")
(qdl "chan2" "\
$(0\}Y9VT_/^kOUZu[lNJ@M(B\
$(0S2$(1P>$(0@m$(1e<$(0V!$(1azi4n/qFXr(B\
$(1o@I!<r=X[;D`Ktf>hnj2(B")
(qdl "chan3" "\
$(0>)[7\PE8$(1YlOlmH%2IuX8(B\
$(0P}$(1nMP:baK=^'o5$>g0(B")
(qdl "chan4" "\
$(0[n]!Z,(B")
(qdl "chang1" "\
$(0/z67=y;e$(1[W?\$(0[U63$(1m@[F(B\
$(16d>.N&(B")
(qdl "chang2" "\
$(01\<'@\J*LwUBH$JH$(1qK$(0<<(B\
$(0UHCn$(1[ELg(B")
(qdl "chang3" "\
$(0@\N^AUS'$(1*m[@(B")
(qdl "chang4" "\
$(0;A67K$<H$(13N`P(B")
(qdl "chao1" "\
$(0,>DZD?E;$(1&R&b9P$(0E7$(1YN(B")
(qdl "chao2" "\
$(0AhOS<&N47t$(1Q'cuN[(B")
(qdl "chao3" "\
$(0+Q0e$(11<(B")
(qdl "chao4" "\
$(12+(B")
(qdl "che1" "\
$(0-P$(1>U8x(B")
(qdl "che3" "\
$(0,K$(1JMo%(B")
(qdl "che4" "\
$(0JfKSYMJuA?._$(1!,-X>T(B")
(qdl "chen1" "\
$(1Ax$(0BgOz$(19pTX<l_[TLC.42(B")
(qdl "chen2" "\
$(0?t,k=(*\J9-R6{,87,TF(B\
$(1DX2UShQ28^;gA9_8e-nk(B\
$(1!nPf(B")
(qdl "chen3" "\
$(15\Xq_}G:IGZjcc(B")
(qdl "chen4" "\
$(0D@L#]s[t^l4S$(1aBe?iqaE(B")
(qdl "cheng1" "\
$(0L#N}SP$(1fl3[]%Zd>+WejN(B\
$(10E4C<v=m^%4zjh(B")
(qdl "cheng2" "\
$(0**C$/V>76!Hc+H2SZ4OK(B\
$(0Rw)#$(1QT<XN].k/WG=-\.O(B\
$(15f=E738zjl248N;|*0Np(B\
$(1B.(B")
(qdl "cheng3" "\
$(0?_X+$(1/05,B8(B")
(qdl "cheng4" "\
$(0L#94$(13[=m(B")
(qdl "chi1" "\
$(0)[:+ZSG?EI@W%&$(13@$(0]K>M(B\
$(1F&\:B?JD>1_(7VkL7g@P(B\
$(1TMXcq[p'nv(B")
(qdl "chi2" "\
$(03>*BT[Ij;3*$N?$(1%|$(0Q>$(1L`(B\
$(12V9-Y-2q->1*$#$Z2E$(081(B\
$(1/}8F@PGjLWPB_M;\(B")
(qdl "chi3" "\
$(0':R07F+C-yT4$(1=$C=2b*L(B\
$(1*`)l:DGVNl!lk,(B")
(qdl "chi4" "\
$(0-L9R(YE%(:S6@>$(1Ae$(0<z$(119(B\
$(1&xjd/aT}!-GsNJnq3ORA(B\
$(1HQ.86OE6aTByPW(B")
(qdl "chong1" "\
$(0'sPm,t>p$(1#}$(0Nm$(1,2-60)ci(B\
$(1,X(B")
(qdl "chong2" "\
$(05n;w*fY:$(1,]2*T+AI2X7E(B")
(qdl "chong3" "\
$(0Z1(B")
(qdl "chong4" "\
$(0Pm$(1H><6(B")
(qdl "chou1" "\
$(0/e$(1X[C8Y1i<4_(B")
(qdl "chou2" "\
$(0E{&s\%LAI<Ga$(18.$(0]0ZP<M(B\
$(0M!R3$(1oQ\g$(0Z$$(1bv\`<y>|?q(B\
$(1\qGM[\b,/q(B")
(qdl "chou3" "\
$(0&aWk$(1L.':'F#>8u(B")
(qdl "chou4" "\
$(09i$(1^2$(0Ft$(1K2PF(B")
(qdl "chu1" "\
$(0'y1P\a$(1c^(B")
(qdl "chu2" "\
$(0:gUDNZQ]Z<Yf9q[)$(1D9n.(B\
$(1Y*F:G8HDMJ$(0I#$(1m-aSc^Gh(B\
$(1Kq(B")
(qdl "chu3" "\
$(0?)FHUDXp07L~A~$(1Wu]4(B")
(qdl "chu4" "\
$(0?)\>8g>X^dX6$(1-v$(0/H$(1C#$(0U}(B\
$(1@CH,\|!)(l'n>(NLD/O[(B\
$(1^Y/P(B")
(qdl "chua1" "\
$(1="(B")
(qdl "chuai2" "\
$(1S/(B")
(qdl "chuai3" "\
$(0AH(B")
(qdl "chuai4" "\
$(0TP$(1Om(B")
(qdl "chuan1" "\
$(04s&V$(1jK$KD~(B")
(qdl "chuan2" "\
$(0E/>t$(1H)CcD!ZZPpZw(B")
(qdl "chuan3" "\
$(0@D*a$(12Y(B")
(qdl "chuan4" "\
$(0*l?n$(1$l"`N?(B")
(qdl "chuang1" "\
$(0C(@7Oq+Z$(1PDJ@JU(B")
(qdl "chuang2" "\
$(0,,NVNz$(1WJ(B")
(qdl "chuang3" "\
$(0Y`F6$(1K\(B")
(qdl "chuang4" "\
$(0@7Y`F$$(1%UDu(B")
(qdl "chui1" "\
$(0+M0f(B")
(qdl "chui2" "\
$(02NY]K6$(1C;$(0A{DqWsAN$(1Ce$(0P4(B\
$(1:b=V3_Fo$(0PC$(1;(FHK}(B")
(qdl "chui4" "\
$(0+M0f$(1ZU(B")
(qdl "chun1" "\
$(03O$(1CV'9Zz=_k$;-CLk9(B")
(qdl "chun2" "\
$(09G6fQT=K$(1SH$(0[X$(1KD[+$(0>k$(1W.(B\
$(1hB(B")
(qdl "chun3" "\
$(0]&$(1BlZh3fG!(B")
(qdl "chuo1" "\
$(0XC(B")
(qdl "chuo4" "\
$(0L9QD^3$(1;#$(0;I$(15@egU)4\E-(B\
$(1@t._#97;Xu?4TZW3kT(B")
(qdl "ci1" "\
$(0>1$(1*:$(0Md%*7:$(1@U[x(B")
(qdl "ci2" "\
$(0D%[0EvKw>'Md9->1:$$(1>m(B\
$(1Ui+=Vd]H)OUj^f(B")
(qdl "ci3" "\
$(0*;$(1%>+X0qGt7J(B")
(qdl "ci4" "\
$(0*:./Q2A"*z$(1%6?y?S"U/r(B\
$(12o>q(B")
(qdl "cong1" "\
$(0(!Vz<8+Z$(1R0R1$(0OA$(1lkSagZ(B\
$(1Qz<~Pm$(0P^$(1Xf_3`&(B")
(qdl "cong2" "\
$(0<8X;=L$(1>"5:KNKTTV[<4a(B\
$(14t54J1(B")
(qdl "cong4" "\
$(1mVbtcS(B")
(qdl "cou4" "\
$(0B2TU$(1F<CU(B")
(qdl "cu1" "\
$(0>P$(1rC9M(B")
(qdl "cu2" "\
$(1+H&W(B")
(qdl "cu4" "\
$(01sQVVW[-$(1S?$(0YE$(17&$(0.6TdQ7(B\
$(0WX[8$(1XWTi$(0OB$(16,O`EiWle1(B")
(qdl "cuan1" "\
$(1k\q@UI(B")
(qdl "cuan2" "\
$(1mSmNkR(B")
(qdl "cuan4" "\
$(0XuSd_G$(1Y+(B")
(qdl "cui1" "\
$(0JzE2<!$(1I:IPXogXJe$(0:/(B")
(qdl "cui2" "\
$(1AkJ9(B")
(qdl "cui3" "\
$(0Oj$(1T\KP(B")
(qdl "cui4" "\
$(0LJ9aL3<CG:CX$(13y$(0=l$(1-k=,(B\
$(0S!$(1=^^&Y[LlYX?8]G(B")
(qdl "cun1" "\
$(0,[By(B")
(qdl "cun2" "\
$(0)u$(1@-(B")
(qdl "cun3" "\
$(0*&$(1!L(B")
(qdl "cun4" "\
$(0&Q)V$(1,i(B")
(qdl "cuo1" "\
$(0F+O&O{WY$(1M>Tyjt(B")
(qdl "cuo2" "\
$(1R9>Jm9>;_w$(0Ek$(1SS(B")
(qdl "cuo3" "\
$(1Kw8QY8>S(B")
(qdl "cuo4" "\
$(0Td<^7dQ`O&$(1)4$(06R$(18p)+.,(B\
$(1p2MM(B")
(qdl "d" "\
$(0$y(B")
(qdl "da1" "\
$(0F/T5C1$(1Pe%_,w(B")
(qdl "da2" "\
$(0C1I/^#MgOm/P$(1fFVI&*7x(B\
$(12R_"ZIlR:H%d7A+pd'(B")
(qdl "da3" "\
$(0(U(B")
(qdl "da4" "\
$(0&L(B")
(qdl "dai1" "\
$(0+E$(1Kr(B")
(qdl "dai3" "\
$(0'QDM(B")
(qdl "dai4" "\
$(0'o<(3"?<Uc3*3tX8D=5g(B\
$(0&L4I/*DM$(1oL48p^83I~"\(B\
$(1"Ai7@rGw^_cm+FBz(B")
(qdl "dan1" "\
$(0@MRk&f9YXz$(1U$,C8H9w,U(B\
$(1b6cCI.fNO_eC(B")
(qdl "dan3" "\
$(0W%8sO,$(1AY1s!~Pa(/2~qU(B\
$(1!EX+(B")
(qdl "dan4" "\
$(0+!(Z=N?1PxRkN_NrB);B(B\
$(0S1$(1W+OX$(0;N$(1Of$(0(|$(1]cEkI"Vw(B\
$(1jWOF?`HBWF+?#lQS'd(&(B\
$(1@<:^M4M}On\1b>WnmZ'm(B")
(qdl "dang1" "\
$(0G6R>]9Zv$(1]Uf8$(0N($(1fmX,fR(B\
$(1BU(B")
(qdl "dang3" "\
$(0Us\^Ra_;$(1o-p<."(B")
(qdl "dang4" "\
$(0G6T%RaVF$(1L8&:?jH(]S;j(B\
$(1E*bKbOl](B")
(qdl "dao1" "\
$(0&/(2$(1!\(R"XBbHr(B")
(qdl "dao3" "\
$(06077RSZVF8$(1\v5W\WE\(B")
(qdl "dao4" "\
$(0.0I-60P*BzW[<JRS$(1q2i_(B\
$(1]0?Xmb(B")
(qdl "de2" "\
$(0<6Na$(16a(B")
(qdl "de5" "\
$(00|<6(B")
(qdl "dei3" "\
$(0<6(B")
(qdl "deng1" "\
$(0BuS:$(1jAbVG[XRP((B")
(qdl "deng3" "\
$(0C,$(1B|(B")
(qdl "deng4" "\
$(0QRVH[+J"NTVP$(1OuZ~jX(B")
(qdl "di1" "\
$(0+&KA(c$(18:dI&Y]x`%9C?d(B\
$(1IJQs(B")
(qdl "di2" "\
$(00|O.5b-*>IKXLL?%JGJ((B\
$(0[6$(1cf$(01BKa$(1mon$^.SfAQ67(B\
$(1Qj-8\UqPb{fX(B")
(qdl "di3" "\
$(0/6/k1WD+4?9&(c$(1%|$(03o$(1&U(B\
$(1@:%o(|M,?J@k$1(B")
(qdl "di4" "\
$(0)c>J,/2uMEH.0|P7T86|(B\
$(1>A$(0Av$(1$B$kLBSK_/ZmCo=S(B\
$(1L5-K9~Ps$<3-696mHnIC(B\
$(1Il71XU(B")
(qdl "dia1" "\
$(1B%(B")
(qdl "dian1" "\
$(0[M]^^cFf$(15N:?R@*i_fK&(B\
$(1qY:K(B")
(qdl "dian3" "\
$(0X5.)GS$(1[I4l>/Yr(B")
(qdl "dian4" "\
$(0IZ/4F\-0@eJ=S)<DT{*|(B\
$(16E$(04CIO$(1bS%v1(b8]w(z*T(B\
$(14bTbVY(B")
(qdl "diao1" "\
$(0Tt6I&0D1$(1hV$(0GU(3<5$(1Xk>*(B\
$(0[W$(1"L9'Ht(jQ?(B")
(qdl "diao3" "\
$(1)z(B")
(qdl "diao4" "\
$(0P~<a?m)S'?$(1X~S^GS!xOJ(B")
(qdl "die1" "\
$(08W(B")
(qdl "die2" "\
$(0DFPcT=Kx]i5dG'@J$(10~$(0CG(B\
$(0CB$(1)@)U:fM`Zkjz@^*t)}(B\
$(1*f-!-=16?,?;@DA@S2T0(B\
$(1;iCXIk(B")
(qdl "ding1" "\
$(0&$:\(0$(1$p$(05m-2&q$(1"e!Y:3(B\
$(1(h(B")
(qdl "ding3" "\
$(0@"Ip5m$(1IxWy^o(B")
(qdl "ding4" "\
$(0.z5V:\T`$(1EL3L.d<q5cL>(B\
$(1`R?F3v(B")
(qdl "diu1" "\
$(0)$$(1O!(B")
(qdl "dong1" "\
$(00*'w.QZ*$(1-FMb4D4|+O+v(B\
$(16M?oh_(B")
(qdl "dong3" "\
$(0U^H;$(1VgOz(B")
(qdl "dong4" "\
$(0;04#6FAo359`$(1*^/2[u`G(B")
(qdl "dou1" "\
$(0?h;($(137(B")
(qdl "dou3" "\
$(0'H,@:d:(09$(1.6<>(B")
(qdl "dou4" "\
$(0:o-I?YBr\#$(18c$(0>n$(1UmU16+(B\
$(101$(0]u(B")
(qdl "du1" "\
$(0?hGGJ3$(1[S[)(B")
(qdl "du2" "\
$(0]uSB3vZI$(1q2$(0X\ZJ^W$(1r9$(0_C(B\
$(0Z=$(1\FETehSon-papbiB(B")
(qdl "du3" "\
$(0Q/;ZGHSb-?$(1[QN)5*(B")
(qdl "du4" "\
$(02zB/-?+kWl,\^h$(17h:N(B")
(qdl "duan1" "\
$(0L'5'$(13i3o;3(B")
(qdl "duan3" "\
$(0B|(B")
(qdl "duan4" "\
$(03uXKPAWv$(1WoFEpHCgG)L;(B\
$(1n3(B")
(qdl "dui1" "\
$(0;U$(1UgE<(B")
(qdl "dui4" "\
$(0JXDj+,GX$(1aUg']Bc!lHb#(B\
$(1erW#(B")
(qdl "dun1" "\
$(0AV[(NE<Q$(1]vnRM^W5j8(B")
(qdl "dun3" "\
$(04^\G(B")
(qdl "dun4" "\
$(0IbRA4bD_I94^S7,r+\$(1T{(B\
$(1'x#M$6!u#nQ^;Rk8FD(B")
(qdl "duo1" "\
$(0)j$(1)I*}2L(B")
(qdl "duo2" "\
$(0JE]:$(15XN*..<;Cy3m5j8o(B\
$(1=+?4dufz(B")
(qdl "duo3" "\
$(0I$*9$(1:j)Yhmh47GGk(B")
(qdl "duo4" "\
$(0A3ND>qH~.3.ITMIk$(1)YOx(B\
$(1P8+2-e-h$(02z$(197@NhR(B")
(qdl "e1" "\
$(01`;d$(1E3$(0%.$(14w*%[5$(0%/(B")
(qdl "e2" "\
$(0Ym?FZ'6~6dHG75$(18r$(01{$(1#G(B\
$(1#:>Q$(0?/$(1U>(s7>0M>>>GV.(B")
(qdl "e3" "\
$(1N7(B")
(qdl "e4" "\
$(0A+Qt1{DS'.I4Wy,F_AYp(B\
$(0+FA2R??T$(1%/k6$(0;T$(1ZR$(0H8$(1)M(B\
$(0;=$(1;DC'$(0Hk$(1[RU`:ip}'D2.(B\
$(1:r#cp\i),Q1B2g@L@mB)(B\
$(1C-MjVs[kih(B")
(qdl "ei1" "\
$(0%1(B")
(qdl "en1" "\
$(07JEJ%5(B")
(qdl "en4" "\
$(1C5(B")
(qdl "eng1" "\
$(1dO$(0%7(B")
(qdl "er1" "\
$(0%8.$(B")
(qdl "er2" "\
$(0.$*U$(1+f,u20H!%K/i-f`y(B\
$(1al?-2W4&a*(B")
(qdl "er3" "\
$(0K`*W4"MpYN$(10o[nc'Nd*+(B\
$(1!U/s(B")
(qdl "er4" "\
$(0&)D4$(1%:%Q)>WM?-0"7P@'(B")
(qdl "f" "\
$(0$x(B")
(qdl "fa1" "\
$(0Bv)2$(1L/(B")
(qdl "fa2" "\
$(0'g)2LIM_C49#$(12N1.b~(B")
(qdl "fa3" "\
$(00OR"(B")
(qdl "fa4" "\
$(00OB^(B")
(qdl "fan1" "\
$(0BmY)T&Y&NX)~$(1afktI(P+(B\
$(1gIom(B")
(qdl "fan2" "\
$(0&<FwVn)~T&\!ZjO>$(1l-XP(B\
$(1(I$(0NF$(1X;YZl5gBgx7~$(0?p$(1i3(B\
$(1jFI-Wg^ebgp%$H+Bev(B")
(qdl "fan3" "\
$(0'11T$(1V/(B")
(qdl "fan4" "\
$(0P/58(h(g*HE"?J0\=2$(1,>(B\
$(17oNY"33.@pK[V`(B")
(qdl "fang1" "\
$(0'J1>+^0($(1%)6fA*!$$L(B")
(qdl "fang2" "\
$(0/S-`+l19+^$(1V'(B")
(qdl "fang3" "\
$(0??,2),9A6%9n$(1'&,:OEm4(B")
(qdl "fang4" "\
$(0/t(B")
(qdl "fei1" "\
$(01g5{ChA>;>)o$(1Lw$(0Tz$(1`dda(B\
$(1hEh(4^N((B")
(qdl "fei2" "\
$(012$(16X$(0CS$(1?_M|(B")
(qdl "fei3" "\
$(06OLKAZ$(1M{$(0Q%$(15C$(0Ch$(1*{<kJq(B\
$(1Y)4Q`X(B")
(qdl "fei4" "\
$(0NYD7110Q+SG</O$(11,$(01L;v(B\
$(1./($1Fb&]b*o,y-w.3WA(B\
$(1a@e[c*j@(B")
(qdl "fen1" "\
$(0'"9N1F0B+KB!$(1(-9yAN'2(B\
$(1A?,R2)2{je64V8(B")
(qdl "fen2" "\
$(0NBBP,y$(1'@<m2jg5e2P9QH(B\
$(1gEaA#W'{2'MTp&#rYilS(B")
(qdl "fen3" "\
$(09@$(1\B(B")
(qdl "fen4" "\
$(0):/DRNNs'"V_$(1H{i,#N,`(B\
$(1V+WNYWbf(B")
(qdl "feng1" "\
$(05zHI2mYCKn76Qa&e=rFS(B\
$(0TC$(1lJFXkbDo/N66#R]73k(B\
$(1;Umvr!r<=|(B")
(qdl "feng2" "\
$(0?bVjE&$(1#P=O:tFNJS(B")
(qdl "feng3" "\
$(13{9J(B")
(qdl "feng4" "\
$(0.aMz6)TCVj$(1Z_=i(B")
(qdl "fiao4" "\
$(1GC(B")
(qdl "fo2" "\
$(0*t$(1%t(B")
(qdl "fong4" "\
$(1,<(B")
(qdl "fou2" "\
$(1,o$(01J$(11uAn(B")
(qdl "fou3" "\
$(0+B*P$(1=(0SV6(B")
(qdl "fu1" "\
$(0'4PPO/JN)0R,$(1@a$(0?S$(1+6,M(B\
$(1NS$(0Da$(1Ld?'2t>^%+'_*O.l(B\
$(18eF/V1&6Y6f%86(B")
(qdl "fu2" "\
$(00%K~,B8G>K)4/>Sl@z1u(B\
$(0/[$(1-?$(0(R+xC}1@TRPd;1$(1G5(B\
$(1,o$(0=k'4$(13?8l$(0/O$(12]6#$(0>W$(12O(B\
$(0Co>_$(1%a+^F#8]$(01L$(1-4FM#.(B\
$(1&O7sF]9<$(03x$(1<wQ[6r+5,8(B\
$(1&H'7)[*o+*7?9"ZiHu!>(B\
$(1'Y1N8AO4ZX\3a=hWk+(B")
(qdl "fu3" "\
$(0/5LPO(M;-./u6&:_>iCM(B\
$(0?'$(1D@Oo&yhdbR$(0Qp$(139&Tdq(B\
$(1CK#-G92h@j$(0'Y(B")
(qdl "fu4" "\
$(0'Y5Y;b'j1b@oA';,@,Y<(B\
$(0PoH).M5ZQ,Q~1^5WYwWW(B\
$(1T#\)1J3bZxj}`'Jn)b-&(B\
$(19,FqT$T/&6*'@$RyY{(B")
(qdl "g" "\
$(0$}(B")
(qdl "ga1" "\
$(0J0$(1"O(B")
(qdl "ga2" "\
$(01RRI$(1-c(B")
(qdl "ga4" "\
$(0+}(B")
(qdl "gai1" "\
$(0H[2U$(1-d$(0Hx$(12:%5){2/>X>r(B\
$(1G]GcH[(B")
(qdl "gai3" "\
$(0,R(B")
(qdl "gai4" "\
$(0FNLe&bD\BG$(1B}<)b5(B")
(qdl "gan1" "\
$(0:r(m&\4u-<UT3e.[$(1'V%^(B\
$(08n$(1$i$(0,`$(1(=-HExMiOL;W(B")
(qdl "gan3" "\
$(0AWEwM9=3R{C#$(1QK(8(;3((B")
(qdl "gan4" "\
$(0Em^n=n$(18,$:Hp@J$(0K7$(1qq6k(B\
$(1f6;W(B")
(qdl "gang1" "\
$(06MTf5!<%L?/&->*,,a$(12!(B\
$(1(7--$(0?o$(1B7EW<`1b4:=q(B")
(qdl "gang3" "\
$(0B,<%(B")
(qdl "gang4" "\
$(0K,(B")
(qdl "gao1" "\
$(0:nSgLRS_9Q8t$(1ea$(0GI$(1m>Jz(B\
$(1L3DDgs(B")
(qdl "gao3" "\
$(0P%^:F-K*Sn0<$(1J`aoEy(B")
(qdl "gao4" "\
$(0+LM+$(13AU<>[Dc(B")
(qdl "ge1" "\
$(06YK;@5X2Uk9c'B$(1$w$(00z$(1=D(B\
$(1+x?DD7OO(B")
(qdl "ge2" "\
$(08,5uISM^H7U2Cw2FLS$(1j-(B\
$(1AvJW$(05k$(1U^B5GH$(0:pM`$(1*_%M(B\
$(1Zva$/Q2K;hXH$(0Y\$(1p/(B")
(qdl "ge3" "\
$(0H7$(1.<8XW0\+h/7q(B")
(qdl "ge4" "\
$(068)WMU$(1-J$(0L1(B")
(qdl "ge5" "\
$(068(B")
(qdl "gei3" "\
$(0C@(B")
(qdl "gen1" "\
$(0Hz7~(B")
(qdl "gen2" "\
$(1)A(B")
(qdl "gen3" "\
$(0*c(B")
(qdl "gen4" "\
$(0)(*c$(12F(B")
(qdl "geng1" "\
$(0,V9V/3GmZgQ4$(102RohI?n(B\
$(1;}(B")
(qdl "geng3" "\
$(0=79Z6g$(1F!dt$(06k$(1`q38/G(B")
(qdl "geng4" "\
$(0,V)($(1:c(B")
(qdl "gong1" "\
$(0&W&}'}-s,S7)7I:F&_:-(B\
$(04y^414$(1GF(7$(0?o$(1Y.B+Bw:I(B\
$(0)B$(1Ba(B")
(qdl "gong3" "\
$(0Qn3B,g)B$(10n$(0[}$(1/e$(0&]$(1/4@"(B\
$(1iQ(B")
(qdl "gong4" "\
$(0)B-s:D$(1,rC)(B")
(qdl "gou1" "\
$(0(<Fe'&IH3i$(1']Y&Rw'=(f(B\
$(1YR(B")
(qdl "gou3" "\
$(00q$(1)C&E$(03i5J$(17z,s2P92(B")
(qdl "gou4" "\
$(0;]WU2RK-Ed$(1Bi$(0F9HiMA$(1_H(B\
$(1.$)n$(0IX$(1:;RHf7gq.4(B")
(qdl "gu1" "\
$(0.k.wDL.E0J*v$(1?h$(0Cd.N?.(B\
$(1E4L]$(0U8$(1@;A&'a2%L_$(0I@$(1\,(B\
$(1!;+7HT@o$(07'$(1O~WQ(B")
(qdl "gu2" "\
$(0:m$(1m,(B")
(qdl "gu3" "\
$(015(-Iq:m-HP'Hs'z^H$(1$T(B\
$(04>Fm9P$(1I5$(0D'W_Z(Xl$(1^WbA(B\
$(12&9/"I$(0I@$(1$G6Q(#.IBSJj(B\
$(1ML]Ea}BrY?^g(B")
(qdl "gu4" "\
$(03K.W]BDwI|Tn+L*v$(1E46%(B\
$(1Jt7%4K5).'<tEb(B")
(qdl "gua1" "\
$(0(k3E.1PfQrCH$(1a-/n31h+(B\
$(1-+FI>gFYI*L(Rta\Gi^[(B")
(qdl "gua3" "\
$(0JQ$(13p(B")
(qdl "gua4" "\
$(0<c.:Lx$(1F187>tGO$(03I$(1[{(B")
(qdl "guai1" "\
$(0-f(B")
(qdl "guai3" "\
$(0/g$(1+A$(03f(B")
(qdl "guai4" "\
$(0/J$(1eX!<V~b;(B")
(qdl "guan1" "\
$(0.{[C_)2&Ai4e]MLD6#>v(B\
$(1R<!Apj(B")
(qdl "guan3" "\
$(0L(U)>vBf$(1Em8JE/[*(B")
(qdl "guan4" "\
$(0Jl?L\u^e$(1JQ$(0SO_J2&_)$(1!D(B\
$(1m]m`E[o<qf6F5;;_d@r;(B")
(qdl "guang1" "\
$(0)=9[4-$(1/l0p'z2GN|)]0`(B")
(qdl "guang3" "\
$(0N]Xd(B")
(qdl "guang4" "\
$(0?d$(1/l^\?9iD(B")
(qdl "gui1" "\
$(0XW?>U@KhM\)e8c4X@/$(1:y(B\
$(1Q-$(0X0$(1Q/-Z7n=3I]JY(B")
(qdl "gui3" "\
$(0:q5^Hf4U$(13s$(0Ad$(1!T^/%B)X(B\
$(1!b)kSn.z7c?~GGI/(B")
(qdl "gui4" "\
$(0D98!XPI!$(1O]DH$(0^Z$(1'-'q>j(B\
$(1+#P6f}Pn(B")
(qdl "gun3" "\
$(0K??6Z%$(1Lu$(0QJ$(15hS=(B")
(qdl "gun4" "\
$(0Ax$(1]X(B")
(qdl "guo1" "\
$(0?gWrW?@a$(1I84x41IKW|(B")
(qdl "guo2" "\
$(0;PJ_$(1Si`b$(0Jy$(1M+S,K^J>^1(B")
(qdl "guo3" "\
$(00+LzO7$(1MkTuLh$(0=z$(16c5BlU(B\
$(1[6(B")
(qdl "guo4" "\
$(0I5(B")
(qdl "h" "\
$(0%!(B")
(qdl "ha1" "\
$(02E(B")
(qdl "ha2" "\
$(0Cw(B")
(qdl "ha3" "\
$(02E(B")
(qdl "hai1" "\
$(02>EA$(1%i(B")
(qdl "hai2" "\
$(0Wd2gU1$(1Ub(B")
(qdl "hai3" "\
$(08B$(1_r6{(B")
(qdl "hai4" "\
$(07&)+U.EA89$(1As>rO9(B")
(qdl "han1" "\
$(0DWX9?-$(1W$AR\-.AE+N:Id(B")
(qdl "han2" "\
$(0@n+W.+=aX'$(1(v$(0*?$(1"r$(0K7$(178(B\
$(16'UL6y(B")
(qdl "han3" "\
$(0@B-9$(1!%S@g3\S(B")
(qdl "han4" "\
$(0.PKH*?,U=qR[StRc7OU$(B\
$(1"E$(0ZC$(1:,$(07f$(1PlQm5l"c>D?Y(B\
$(13%$(0Qd$(19|`l.D086[HlMp$(0Qq(B\
$(1Z,`Sd?eTg)UAm)(B")
(qdl "hang1" "\
$(1!R(B")
(qdl "hang2" "\
$(0*h9m0'+?$(1Hf$(082$(1(m(T(M2\(B\
$(1'%9WH_V&(B")
(qdl "hang3" "\
$(13C(B")
(qdl "hang4" "\
$(0*h,{(B")
(qdl "hao1" "\
$(0L^$(1\O^}(B")
(qdl "hao2" "\
$(0HA=FM1ULV&\:HpUF]O?/(B\
$(0EO$(1iWTE)6l=(B")
(qdl "hao3" "\
$(0)p:W(B")
(qdl "hao4" "\
$(0HA9X8JBxYZ=[0#)p$(1p?QZ(B\
$(1RB$(0]CI;$(1,^6bD-RD.G/1lx(B\
$(1*r^`(B")
(qdl "he1" "\
$(0@C.BD.$(1*-(B")
(qdl "he2" "\
$(0*u)Z.P0I?$7z>6(~Pn.4(B\
$(0Y_M`3X$(1n~$(0=[8w$(1g"$(0LeHpM[(B\
$(04|$(1D6$(0Sv$(1S{$(0EG$(1e9$(05k$(1`]k5HR(B\
$(1\+dJ?D&3D'KjMDY'Z(bH(B\
$(110BdCnQg3+(B")
(qdl "he4" "\
$(0D8.P]O@C?$UJM7:WFD$(1Ap(B\
$(1Kb=zYP%LD_(B")
(qdl "he5" "\
$(0.P(B")
(qdl "hei1" "\
$(0E*N5$(1QR(B")
(qdl "hei3" "\
$(0E*(B")
(qdl "hen2" "\
$(0>0$(1*\U\(B")
(qdl "hen3" "\
$(03!4A(B")
(qdl "hen4" "\
$(030(B")
(qdl "heng1" "\
$(0*m6X$(18UZ[(B")
(qdl "heng2" "\
$(0Rx32T0$(10tio$(082$(1)fn>CzN5(B\
$(1Z[</%=(B")
(qdl "heng4" "\
$(0Rx$(14*Qd?#(B")
(qdl "hong1" "\
$(0]32D8RW4$(1-S#A<5=N)HZy(B\
$(1TP`8=fOK(B")
(qdl "hong2" "\
$(04y3|+|X15N(Q0P:8$(1U.$(0Di(B\
$(0_2$(1,c1w2(0+O,$_Fy2,!G(B\
$(1$S>cA:`F"/$m9R=I??GL(B\
$(1GZRgW!(2-A(B")
(qdl "hong3" "\
$(02D$(1Au(B")
(qdl "hong4" "\
$(0U5,g$(1QI^h`;(B")
(qdl "hou1" "\
$(1hg(B")
(qdl "hou2" "\
$(0B\1m@VP5$(1`)``L)NmS!j~(B\
$(1G((B")
(qdl "hou3" "\
$(0+T(B")
(qdl "hou4" "\
$(03&6925)\:S^y$(1)`$(0@b$(1-aA"(B\
$(1?%+m(B")
(qdl "hu1" "\
$(0/B.L'h<P$(1KK$(0Ub$(1=v="Y\9#(B\
$(1#8"oP;Ih')Q;6v%z'34#(B\
$(1)|6ZcP""6e(B")
(qdl "hu2" "\
$(05/B:@dPbP60r/:H4[SG-(B\
$(1`Z$(0<}Z(+]$(1Y=T,_K[&=vC3(B\
$(1k-Q%;.$.k%6zV(Z:enCt(B\
$(1I;k>(B")
(qdl "hu3" "\
$(01NBb$(1K;$(0;J?C$(1$](B")
(qdl "hu4" "\
$(0]-'C&lKU<T>%$(1&^1M1f!{(B\
$(1&r$(0FX,}$(1&@NTiaoa'CQ9'*(B\
$(1IZ4[IUQr_^F,_RSe(B")
(qdl "hua1" "\
$(01EC_N7$(1p$[H(B")
(qdl "hua2" "\
$(0C_Fm)GG+ZzN7Rv$(1nOjC$(0WP(B\
$(0J#$(14y:&Z/(B")
(qdl "hua4" "\
$(0Hd'(BlJ#RvC_$(1O}JL4yP*(B\
$(1'IGEP}b^QO(B")
(qdl "huai2" "\
$(0Z5=g3#K3Q:$(1%@$&ZDZCi$(B\
$(1et(B")
(qdl "huai4" "\
$(0Z.+f$(1TO.h)GoCoG(B")
(qdl "huan1" "\
$(0]d$(1r3q?kl$bk[lKV:(B")
(qdl "huan2" "\
$(0WdV@7}$(1fBoe$(0Ww$(1lP$(0RR$(1l\$(0=B(B\
$(04+$(1pBG`$(0S5$(12@?b$x/6F5W)(B\
$(1__V^,%AK(B")
(qdl "huan3" "\
$(0PBBw$(1Wv>@NN(B")
(qdl "huan4" "\
$(0AQ@Q2i<>'=G!2ZBHKpHn(B\
$(0=B$(1@sW1KI.Uj.E%N3kUXh(B")
(qdl "huang1" "\
$(09sE~-;$(1-L";aK(B")
(qdl "huang2" "\
$(0E(A)A9XxSCVOPiF~4W;*(B\
$(0BNI7Dp$(1QM$(0P3$(1:ZS5`(X5$(0Yl(B\
$(1k':uc/3a^"p!;4h.;TFt(B\
$(1`_P[R)g;(B")
(qdl "huang3" "\
$(0WK3.7pEl4-$(1&dK+Ked6D;(B\
$(1RC(B")
(qdl "huang4" "\
$(07p$(1@g(B")
(qdl "hui1" "\
$(0*IAMQB31HaF>R-U\ND$(1T.(B\
$(1<!d>DSS$3$T2+eHZnDnb(B\
$(1*g:QLJ(B")
(qdl "hui2" "\
$(0)`:PCu9z$(12m+Z7H*JfU(B")
(qdl "hui3" "\
$(0FE7PM,F[V8Ht5P*f$(10XWp(B\
$(1]+j%(B")
(qdl "hui4" "\
$(0FEA.E?ZcNdEqXsM,Ht=)(B\
$(0<2T;OV(&T"$(1X!$(0V9@X$(1/"^|(B\
$(1fLjUI3Pv^)b`b\c.][P)(B\
$(1PKQcbCg*n,jLWcBfGXOr(B\
$(1SAXG`^lXlg-.bMf}(B")
(qdl "hun1" "\
$(0;g0!H/$(1[Z5DL2='<z6\CC(B\
$(1EG(B")
(qdl "hun2" "\
$(0MwBEU+=\G2$(1CS`Y<udUnz(B\
$(1^Dcv(B")
(qdl "hun3" "\
$(0=\$(1EH(B")
(qdl "hun4" "\
$(0=\BE$(1D<ZL.LJ-$(0QJ$(1-~$(0=B(B")
(qdl "huo1" "\
$(0WP(B")
(qdl "huo2" "\
$(04%$(1%DA,FQ(B")
(qdl "huo3" "\
$(0'W).JB$(1A,(B")
(qdl "huo4" "\
$(0/QZWV>.PA*L!Tx?MWPUN(B\
$(1iw\Pign:f,as$(0V.$(1,TdC7^(B\
$(0Um$(1=Lh-_Q/H$^145SAwb1(B\
$(1bleSemi"koo_p_(B")
(qdl "huo5" "\
$(0.P(B")
(qdl "i" "\
$(0%9%1(B")
(qdl "ie" "\
$(0%/(B")
(qdl "j" "\
$(0%"(B")
(qdl "ji1" "\
$(0S#;XSYVeYIS0Hy6zYg\T(B\
$(0*[P(:k.bG7L)VQ["^f&.(B\
$(1"T$(0)'70]2SD@~N>Ok@xBX(B\
$(1mB$(0.(Ag/#6eE>$(1]{q&$(0Xj$(1ms(B\
$(1oBT<`I?zNv'5!'!=^;(k(B\
$(1jHajE`K4Q.TJhhl`n=n[(B\
$(1p01c.-`Bpwkn(B")
(qdl "ji2" "\
$(0'09JFL+<Dv3+Ue8j\')P(B\
$(0;nTS9f+d6eEb,x1h)[Al(B\
$(0Y3OlFQ,'$(11gm0$(0F*$(1D$_i$(0)<(B\
$(1M9M*(`^pTeA3%9.N)eWz(B\
$(1cAVZQYa(Vt+b$!=Y'GNw(B\
$(1,"jQG22y3h5-8sB/JgK9(B\
$(1M2SCWRYkj/l^#u/<5{7i(B\
$(1U[Z)9L(B")
(qdl "ji3" "\
$(0@~C@&XUg9fA=V%&.Io$(1#m(B\
$(1c8.-5V'`ThnX!1]~"-PY(B")
(qdl "ji4" "\
$(05U:53N4zMc\,.x;m,A+s(B\
$(0V%R9Z_<O>C,5K%R6YxZ#(B\
$(0P)]2Y5_9^!W5U3$(1^Q$(0WF$(1!j(B\
$(041$(1L%NE\M:k;bK`f4$(01K$(1Fd(B\
$(1E;f(Xya!qMhFne!?!}?:(B\
$(1G@LNN6OGXd]-b2e#e8eO(B\
$(1i0k!l*oF(B")
(qdl "jia1" "\
$(07''|J.-p@*5`$(1+($(0?78r$(17v(B\
$(1,,@]$(05=H=TI$(18EkB'k+Md"(B\
$(1\8=xB_DlZ\$(0+i(B")
(qdl "jia2" "\
$(0+i7YU!$(1G/$(0>y8M<S$(13</!@2(B\
$(1EpGAU45vGy8Z.CNn7W$8(B\
$(1O.U]e!(B")
(qdl "jia3" "\
$(0:v(sHsID$(1&C$(050$(1<AJpL']&(B\
$(1;0,5;[C`$(06p(B")
(qdl "jia4" "\
$(0N$:v3_Q|EaHsP&$(1!q(B")
(qdl "jian1" "\
$(0DgKr;S){6B17W*)n2dFu(B\
$(0P;X]KML*\tC\$(1&qdH=lCs(B\
$(0SjB.$(1X6M?m$BeDkmm9T$(0_7(B\
$(1h1A-qEn]lyk^QvYq;~C?(B\
$(1"<?gAOFxV2`af.h&hYi2(B\
$(1pL5?7.a8(B")
(qdl "jian3" "\
$(0X|Ri;+B6UuABZ`N'^|3^(B\
$(0Gk$(1S%_VJ?_kn'9[:p$(0)a$(1k&(B\
$(1/L=W$(0Xo$(1;8bqq:CHE!(B")
(qdl "jian4" "\
$(0-E2{:{KM)6DgKrWo]}P-(B\
$(0N-\1]~Q-Q9T:F^Y7U*H"(B\
$(0X]IwXQDh$(1+W-r+~/hC[0x(B\
$(1i8$(0OX$(1]j$(09w$(1TBK'Rlk#SI[P(B\
$(1_,cGiYqG(B")
(qdl "jiang1" "\
$(0;s*AZQN#OI2[W/$(13#]9$(0^$(B\
$(1_:]228bF(2M)(B")
(qdl "jiang3" "\
$(0WJOdPZO?$(1gtS.(B")
(qdl "jiang4" "\
$(05s)MYR<1;sCC$(1^<+]cZIw(B\
$(0RT$(151@0(B")
(qdl "jiao1" "\
$(0<u))PO^'BQNL5hI"OOCr(B\
$(0T'VRAz$(129$(02^X.$(1I$PR"mo{(B\
$(1X:$(0Hm$(1opjGa&ozI<W,Y]^#(B\
$(1_2m7P3c6(B")
(qdl "jiao2" "\
$(0[f(B")
(qdl "jiao3" "\
$(0H'-FZe^:E;VMC82^$(1%4$(0Mn(B\
$(0>4IuE7I%MP4B$(1b?OY>dc4(B\
$(1J\Pb/Bo6\~KVO\g/Dh(B")
(qdl "jiao4" "\
$(0<u(67yI%\=[/C)$(1me$(0[4$(1W"(B\
$(1VNP4*WJ^0mpYDE1^I9QX(B\
$(1j#(B")
(qdl "jie1" "\
$(0Cz<Z4VDkAL:~E@$(1:TVy$(0C9(B\
$(1=;^z@*3|<Q?HSqk/(B")
(qdl "jie2" "\
$(0GhON@.<[L&+7JqC902Qo(B\
$(0H_8+GD:6$(1)?$(03?PIUw8"&O(B\
$(1b9>z3Y$(0XJ$(1-n%V4TCa$(0K|$(1`w(B\
$(1#fJy"d@*;F/rh/DNHMjR(B\
$(12y354~BWClGgTcW8X#`4(B\
$(1qv'//<LpaQP=(B")
(qdl "jie3" "\
$(0.mHY.q$(1])4g(B")
(qdl "jie4" "\
$(04M6.&v,<Y3/$4R1GM'HY(B\
$(13~:T(.2kKoZG#E#i!q,S(B\
$(1/&1{>XqAfD(B")
(qdl "jin1" "\
$(0&u1[G\3~'I&[C3Zw4e8A(B\
$(05T$(12z>ZK{?e0v.Y1zP55I(B")
(qdl "jin3" "\
$(0L<E0TkY@R2Y=Oi[P$(1P|IA(B\
$(1Q=4?J4?Q*1(B")
(qdl "jin4" "\
$(0DQ1UKqG\7nR28A21Y=Xa(B\
$(1I}$(0R@$(1Hb$(0SpE0$(1b|#UlBBOC/(B\
$(1(PXTZ`\_K'OSSNXZ\N]@(B\
$(1b3!zDI(B")
(qdl "jing1" "\
$(0GoL5-l^RGC>zA_C^J!8?(B\
$(0[T9u=#Gm$(1kCL[hJ#j4e5k(B\
$(1e"hHmApx!o5F(B")
(qdl "jing3" "\
$(0A`\A&kU"-b$(1OT$(0SFNq$(1)3]Z(B\
$(1!E6p\mWEfrXD(B")
(qdl "jing4" "\
$(0F:@![5T|J;=h\$?^7BI](B\
$(021$(1.%8M$(0Bq$(1Ks-jUZEl4U6-(B\
$(1)".(FcW2.|(B")
(qdl "jiong1" "\
$(1*U%xUv(B")
(qdl "jiong3" "\
$(0C'5c$(1Di'['s8-ZB#,Ql#H(B\
$(1RE$(047$(1P<^A(B")
(qdl "jiu1" "\
$(01,AP@UIn$(1ct=MQ!C"!7"S(B\
$(1"b-Q<1?sr5(B")
(qdl "jiu3" "\
$(0&'&=:Y-,5[-&5w1,(B")
(qdl "jiu4" "\
$(0@t-7<tY.H,*_3b0{.V$(1Hx(B\
$(1o|$(0A$$(1/8PSh;ha(B")
(qdl "ju1" "\
$(0/#/nQ}0U8o?00p66-PTb(B\
$(1N%-9@T2$?E4X<^?34}1+(B\
$(1>'H]6_Fm\.hP*k<*MgTg(B\
$(1H&(B")
(qdl "ju2" "\
$(0+~X&CiRy<jM:8"$(1/:dK$(02"(B\
$(1%WTlUBe$k3<c6o6hr&,!(B\
$(15y@|DmH%LeT[hTl'ny:0(B\
$(1`k(B")
(qdl "ju3" "\
$(0W)8}.F>}0U\`$(1k`EsZoM8(B\
$(1<a+#1a9H@_T"(B")
(qdl "ju4" "\
$(0Rd(<.'(IN*LN66/]DBTb(B\
$(0\kIM46$(1@=$(0Wc65XmQ@X)$(1'](B\
$(05:$(1X|j4$(0UU$(11RM]IglO"|5Z(B\
$(18$&0&e81$(0-N$(18D&?4I9%Ur(B\
$(1W}c`j''i=dVV=r(B")
(qdl "juan1" "\
$(07a6wZ&8D]<;O$(1oI5r$(0-O$(18T(B\
$(1GB(B")
(qdl "juan3" "\
$(0<W.;$(143?K^Z(B")
(qdl "juan4" "\
$(06'.;>8GpIV$(1/)$(08];O$(1XI>E(B\
$(1EB?&@x*4[,?1U_[~(B")
(qdl "jue1" "\
$(1Oh$(0E@$(1PZ(B")
(qdl "jue2" "\
$(0,o\=C;V;<][f?A@=Oe[*(B\
$(0T$;z^964,CRE$(1iG9K$(0-F&P(B\
$(00tJ$$(1WSki$(0[!$(1aO$(0]t$(1(,$(0H'$(1^V(B\
$(1Z!qzo,6&QN$(0R+$(1qy9]$(0^Z$(1:8(B\
$(1;FR?q_jBr2o:/E(Y6xA1(B\
$(12c9S9XH~PGc>o)ojo~47(B\
$(16Cmi(B")
(qdl "jue3" "\
$(0[*(B")
(qdl "jue4" "\
$(064(B")
(qdl "jun1" "\
$(05]+J+bD^$(1L+%q\=8idx6.(B\
$(12p2x[e$(0U@$(1ER(B")
(qdl "jun3" "\
$(0C'$(1Mm(B")
(qdl "jun4" "\
$(01wCf:V73C+IVV,X,T#8H(B\
$(179>36q/;UoLbVh5o#Ce+(B\
$(1FuSU(B")
(qdl "k" "\
$(0$~(B")
(qdl "ka1" "\
$(0.C@?2E$(1HO(B")
(qdl "ka3" "\
$(0('2>$(1##(B")
(qdl "ka4" "\
$(0@?$(1h0(B")
(qdl "kai1" "\
$(0DeAC$(17B%5(B")
(qdl "kai3" "\
$(0@4A6FIF(@6:@$(1d)B-d<_~(B\
$(1gyJaG|(B")
(qdl "kai4" "\
$(0A6F#A<2>$(1/x0U3r\Y(B")
(qdl "kan1" "\
$(0'{@[;/F)4a$(1n};B(B")
(qdl "kan3" "\
$(04i-v+c78XQ$(1=#j,D#au4=(B\
$(1!#dV(B")
(qdl "kan4" "\
$(04aVI;/$(1jTq+Xs-MINnUiS(B")
(qdl "kang1" "\
$(0<+JjV]$(1g]K>Ib(B")
(qdl "kang2" "\
$(0*,(B")
(qdl "kang3" "\
$(0Jj(B")
(qdl "kang4" "\
$(0&n,?0c)-$(1"##I$gAB%(A8(B")
(qdl "kao1" "\
$(1!V(B")
(qdl "kao3" "\
$(0*T8S3C$(1/_$9^c+c(B")
(qdl "kao4" "\
$(0QkQ\Ka(B")
(qdl "ke1" "\
$(04p3c.,ApX(5;OxP"?/Pj(B\
$(0DIGdGf$(1,+1?f:^t*&H;Q:(B\
$(1Dn;N(B")
(qdl "ke2" "\
$(02>B'(B")
(qdl "ke3" "\
$(0(,B?$(1.<$(0.Y$(1&G4J<<VjHV(B")
(qdl "ke4" "\
$(02kP{.,+-2,@?Fi36EG$(1Jm(B\
$(0PDYy$(16Dd_C+%Z)5(B")
(qdl "ken3" "\
$(01:;?RKU_]V$(1hjG^[G(B")
(qdl "ken4" "\
$(15[7Z@6(B")
(qdl "keng1" "\
$(0+_$(1>N$(0[A$(17$$(0+?-d$(1EZUK.^/I(B\
$(1`6(B")
(qdl "keng3" "\
$(1/I(B")
(qdl "kong1" "\
$(01);x6($(1LX59$(0GY$(16H[?(B")
(qdl "kong3" "\
$(07G'76((B")
(qdl "kong4" "\
$(01)<V$(1`J(B")
(qdl "kou1" "\
$(1JIJ'(d9AgR(B")
(qdl "kou3" "\
$(0&H(B")
(qdl "kou4" "\
$(0*+;k(1$(1S8$(0?l$(1m&>k$(0+)$(1&jK8(B\
$(1RH^7(B")
(qdl "ku1" "\
$(06_3`GeR!$(1@Y*Z/t%Sgv,~(B\
$(1WQ(B")
(qdl "ku3" "\
$(05<FX(B")
(qdl "ku4" "\
$(07=T2MN$(1ho(@L*3,(B")
(qdl "kua1" "\
$(0H`)l$(1)h2D/X%;(B")
(qdl "kua3" "\
$(02T$(1%;N{(B")
(qdl "kua4" "\
$(0H{9h$(1[y(B")
(qdl "kuai1" "\
$(1)L:a(B")
(qdl "kuai3" "\
$(1MP(B")
(qdl "kuai4" "\
$(0,9E\FEGgUvN.$(1[$X%$(0W'$(1VO(B\
$(1XM$(0N&$(1pkO=of6<(B")
(qdl "kuan1" "\
$(0NO_0$(1fO(B")
(qdl "kuan3" "\
$(0B"$(1^$$(0=B(B")
(qdl "kuang1" "\
$(0)L7|C/$(1GN$(0.5$(1*H+R(B")
(qdl "kuang2" "\
$(0-+M.$(1e*(B")
(qdl "kuang3" "\
$(1)-(B")
(qdl "kuang4" "\
$(00T[}Z:7|>;$(1cx@O$(0X>$(1kv>u(B\
$(1aVewPA(B")
(qdl "kui1" "\
$(0W6S^>5$(1gf%R/*jY`32=b}(B\
$(1:QkXmy(B")
(qdl "kui2" "\
$(0MvKt2YAEH2DN$(1B{$(0\h$(1h'CG(B\
$(1@{[fS(Cuan=@:6Cvq)r/(B")
(qdl "kui3" "\
$(0@/$(1GqHgDacj*#(B")
(qdl "kui4" "\
$(0F%OVJ%$(1jg$(0Yu@NX{$(1BCbjPO(B\
$(1^*Yo]kQ6WWjDOkP`jo7[(B\
$(1SW(B")
(qdl "kun1" "\
$(0/{;}.^BiTmBV$(1T.5ph:?[(B\
$(1d^$(0Im$(15H7)(B")
(qdl "kun3" "\
$(07]Gq$(1/+$(0=5$(1UQB:Eg>PG<n|(B")
(qdl "kun4" "\
$(0+[B{$(10I(B")
(qdl "kuo3" "\
$(1W6(B")
(qdl "kuo4" "\
$(03EXDWzJa$(1jYK<$(0Cy$(1)dgimj(B")
(qdl "l" "\
$(0$|(B")
(qdl "la1" "\
$(0/W;;@I$(1+;`K8=?P(B")
(qdl "la2" "\
$(02+[2$(1"N(B")
(qdl "la3" "\
$(0@I$(1fg(B")
(qdl "la4" "\
$(0Zi]($(1o^$(0M?2+$(1?2$(0H0$(1h3L&C>(B\
$(1Cr(B")
(qdl "la5" "\
$(0;;(B")
(qdl "lai2" "\
$(0-uCc<;$(16Nd]Lf5!9q[1h8(B\
$(1<\5/hO4,(B")
(qdl "lai4" "\
$(0TK\zZB]nGF$(1TWii.b(B")
(qdl "lan2" "\
$(0]#\&Y1\r[p[u\<;c@vW|(B\
$(1oMpR$(0\o^@$(1q%qskhp>g-pV(B")
(qdl "lan3" "\
$(0]+Z6^`_$_:$(1VTq(p@U+eJ(B\
$(1qI0C(B")
(qdl "lan4" "\
$(0\vV)_:$(1qDb(\X(B")
(qdl "lang1" "\
$(1:P(B")
(qdl "lang2" "\
$(05i8YA!PaG,=}FF$(1>\8`G+(B\
$(15sEnU/(~.t/|(B")
(qdl "lang3" "\
$(07x$(1UP>K*./%N86lB9(B")
(qdl "lang4" "\
$(08<$(1.MM5(B")
(qdl "lao1" "\
$(0N|(B")
(qdl "lao2" "\
$(0@9-'VC$(1QG$(0N1$(1d!0,jIbPc)(B\
$(1P.(B")
(qdl "lao3" "\
$(0*S2a-r$(1/`,$gF)NWTNe*F(B\
$(12>(B")
(qdl "lao4" "\
$(0@9C?8TI=$(1IXgDW_Hz(B")
(qdl "le4" "\
$(0O@.X;-*Z$(1'Z.P$(0(>$(1!3/>!^(B\
$(1!i1Gn^!c.E(H(B")
(qdl "le5" "\
$(0&((B")
(qdl "lei1" "\
$(0;-(B")
(qdl "lei2" "\
$(0IY$(1k{$(0RgJL]7ZhVh$(1k|]1R8(B\
$(1e]f&l1n5o#q$(B")
(qdl "lei3" "\
$(0>\X?UCKR*VO~W-$(1GTf`Q5(B\
$(1b=bE>{XnqdR>e]ebiLkg(B\
$(1n(qmUfiKmzq6(B")
(qdl "lei4" "\
$(0[K=b>\Rg$(1kwN^N~o!oEpF(B")
(qdl "leng2" "\
$(0G_$(14{<V_#$(0P`$(1-o$(0FR(B")
(qdl "leng3" "\
$(0+1(B")
(qdl "leng4" "\
$(0A0$(1Tn$(0FR(B")
(qdl "li1" "\
$(06^(B")
(qdl "li2" "\
$(0YcOhR.=@_&YSOcSrM2_H(B\
$(0=vK@$(1mX$(08\$(1fb$(0HL]'$(1r@I^_?(B\
$(1kE6!QE^=YtQC)<oAAl$(0@T(B\
$(1^9c{r?o"mKmOlhIfPtcI(B\
$(1h@h]mP$(0[^$(1?ao]p'1qnv(B")
(qdl "li3" "\
$(0,X-_HT>"Xq6^8EZ"7!1}(B\
$(0S.^J\K]'$(1pg$(0Qc$(1E|G\*"q&(B")
(qdl "li4" "\
$(0&1)"+4[^S&Z0-tRn?"N0(B\
$(0UE[~>OLb^qZD\cX"\")Q(B\
$(09t8%F!1zBnXj>G/T;L]{(B\
$(0>$$(1@GeA$(0Fs]%$(1i%'ckue`n6(B\
$(1f$`t0liCY(-/.H!Wn1$(0:`(B\
$(0:p$(1iA1YK|oX&N"R$(0^<$(1iO-T(B\
$(1\0,Pb!1>5E9.:JEzL}Mx(B\
$(1bDeVf"ill6m*m:mRn&nm(B\
$(1p9qiq|/g0=B6C@SmaFeY(B\
$(1oSpCqj.g(B")
(qdl "lia3" "\
$(06,(B")
(qdl "lian2" "\
$(0?ZV{NnEnPUKOZY]6^,JF(B\
$(1R-$(0/,$(1_@I>d#jxD1fuPz^M(B\
$(1cLN-RL$(0S($(1^R^dckj$mJVe(B")
(qdl "lian3" "\
$(0W&$(1cyYUJZA\fK(B")
(qdl "lian4" "\
$(0P8Wp^7Fy[9U~Un[wFV$(1f~(B\
$(1=6X2l.]8_$F\:m(B")
(qdl "liang2" "\
$(0-A=.DYX}=JGlOC$(1<oM#Tq(B\
$(1`f(B")
(qdl "liang3" "\
$(0.&6,Y}$(1M$N#(B")
(qdl "liang4" "\
$(0DY1jPuQC$(1:M$(0Ac=J$(13}NA=T(B\
$(1/%(B")
(qdl "liao1" "\
$(0O$(B")
(qdl "liao2" "\
$(0>gNNT\VDJRO$IxOMN3Y#(B\
$(1j?P!R%osaPniM3KEJNc\(B\
$(1InJ5P7PhY"YYbUgejblc(B\
$(1j`(B")
(qdl "liao3" "\
$(0&(VL$(1SOPM3F$(0Rs$(1NWc0(B")
(qdl "liao4" "\
$(0Jb7jVLS=$(1"6JO't_0R](B")
(qdl "lie1" "\
$(02K(B")
(qdl "lie4" "\
$(0)E8U)JC|Xe<o.*_1$(1n2$(04!(B\
$(12CEIaaGl)w3/8O?{G7Uh(B\
$(1\I`~a2f!(B")
(qdl "lin2" "\
$(000W(QP=U^Y^\TwVNB`TY(B\
$(1P-$(0S8SE$(1Li$(0[.$(1QF$(0G@$(1]`]g5>(B\
$(1WDF2nIEPL\]\bdI&bhg?(B\
$(1hpj9(B")
(qdl "lin3" "\
$(0N)RY$(1Vz]#?pAWLs(B")
(qdl "lin4" "\
$(0+>_<\5Hv$(1WK[Y=k(B")
(qdl "ling1" "\
$(0/s(B")
(qdl "ling2" "\
$(0I\4F^rIJ\b?s6GC`>h>b(B\
$(05I+'L:$(16K$(0>dU;$(1%r$(0?4$(11"$(00b(B\
$(18\j1@l[C$(0\s$(1+Dr,ED1I@E(B\
$(1Ts`Hh6pX&F$(03W$(1X(%f&#&$(B\
$(1&4((1/%p7<7|N+l$&p4f(B\
$(1Uw_!r-4F(B")
(qdl "ling3" "\
$(0MkUW$(1&X(B")
(qdl "ling4" "\
$(0'p(7$(1+w(B")
(qdl "liu1" "\
$(0Fo(B")
(qdl "liu2" "\
$(0N,3}8i>>8`K2X_OoMH$(1<E(B\
$(1jpgTlem/aZ`*$(04*$(1d-BMaN(B\
$(1B\fd@+a9m.F{m!B^(B")
(qdl "liu3" "\
$(03l$(1LzR{$(0IP$(1Hk,9(B")
(qdl "liu4" "\
$(0&{?uFoYsYh$(1%~8BghBhB0(B\
$(1_h(B")
(qdl "long2" "\
$(0U?Do]m[b]o[z[sVV$(1ek]a(B\
$(1i#kqh~eL$(0\{$(1ifoVoTgdp[(B\
$(1p`n!n#r)aDmEm|(B")
(qdl "long3" "\
$(0[DZ9Z/(B")
(qdl "long4" "\
$(1@(.5eN5t(B")
(qdl "lou1" "\
$(0Jw(B")
(qdl "lou2" "\
$(0O=J/;`W=]I$(1AbSZJ&KH^T(B\
$(1QxcR^]jZnlXe(B")
(qdl "lou3" "\
$(0VXJw$(1IEIo(B")
(qdl "lou4" "\
$(0KF5q]@[@SM(B")
(qdl "lu1" "\
$(0X<(B")
(qdl "lu2" "\
$(0SN\6Z3\0[x_.ZF_B$(1oWeE(B\
$(1r(70mrmu$(0^p$(1mni&eBeUm~(B\
$(1mq(B")
(qdl "lu3" "\
$(0R(H@ReKY@&Z?$(1fSXwlVgb(B\
$(1STadei(B")
(qdl "lu4" "\
$(0H|?uTh@']@HwG[GTB*[_(B\
$(0^{Nv$(1cs@uK?H"$(0E6$(1W{ml]V(B\
$(1"fE_$(0S]$(1^(U*d`6V>)E?Xv(B\
$(1&V?^S>[B)\g_hCJE7YEF(B\
$(1I|QtTd^r_*f9hL6`ILch(B")
(qdl "lu:2" "\
$(0_8QeZ>$(1f_J8QAS-(B")
(qdl "lu:3" "\
$(0+I7lNS1tQ^JYVgWD;`LV(B\
$(1KHiR623>*dF.\G7d(B")
(qdl "lu:4" "\
$(03$L;=|NeX[$(1;OS*oZ?^Fw(B\
$(1\K(B")
(qdl "lu:an2" "\
$(0^8]](B")
(qdl "lu:an3" "\
$(1mL(B")
(qdl "lu:e4" "\
$(0>*<U$(1U:JOa`(B")
(qdl "luan2" "\
$(0]__?_K_3$(1q4q\o2o0pJr=(B")
(qdl "luan3" "\
$(0+=(B")
(qdl "luan4" "\
$(0E+$(1^v(B")
(qdl "lun1" "\
$(0<f(B")
(qdl "lun2" "\
$(06@Q"QG=e<"-|LD<f$(140EY(B\
$(1[O5J:1?fTp<hMw(B")
(qdl "lun3" "\
$(1Eh(B")
(qdl "lun4" "\
$(0Q"$(1DR(B")
(qdl "luo1" "\
$(0]\(B")
(qdl "luo2" "\
$(0ZdW>^G_@^K_']H]\]g\d(B\
$(1g$JPo3SX$(0[>$(1ps%T(B")
(qdl "luo3" "\
$(0L{$(1X_l!fkMU_{(B")
(qdl "luo4" "\
$(0H0U04)C?Me8TI=$(1b%$(0Kb2F(B\
$(08d$(1q3@17\`}a.*,(B")
(qdl "m" "\
$(0$w(B")
(qdl "ma1" "\
$(0EeEDUR(B")
(qdl "ma2" "\
$(0@)G;J)M{W;$(1Q}(B")
(qdl "ma3" "\
$(0:lT-P#Kg$(1DJ$(0ED$(1d%m5I6(B")
(qdl "ma4" "\
$(0PG$(1RV:>K#(B")
(qdl "ma5" "\
$(0J)EDW;(B")
(qdl "mai2" "\
$(06m^"$(1c"(B")
(qdl "mai3" "\
$(0D:$(1Opox(B")
(qdl "mai4" "\
$(0Q1@(We9d$(1O^Sz(B")
(qdl "man2" "\
$(0_([OSQYFKQ$(1j^cQ$(0^.$(1R./.(B\
$(1J3Q#lslr(B")
(qdl "man3" "\
$(0KI7$$(1pD(B")
(qdl "man4" "\
$(0JkKQ;8PXJ`$(1IY$(0[;Vr$(1IDQ|(B\
$(1X.AaKu(B")
(qdl "mang2" "\
$(0*%-B9r0~0A$(1#^>O"q.:#Q(B\
$(0,c$(1(9U8.c7#>9G0`iinp*(B\
$(1,d(B")
(qdl "mang3" "\
$(0>{W:$(1KM"Z.{>M?CIR(B")
(qdl "mao1" "\
$(0TJ(B")
(qdl "mao2" "\
$(0'T59(zMuWn$(1/T_7(\T%V!(B\
$(1;1:l2"9{P'k2'<9a=[(B")
(qdl "mao3" "\
$(0()$(1*x$(00a5L(B")
(qdl "mao4" "\
$(0@{2$M3D<5?G1Ua$(1/T$(05$$(1:}(B\
$(1C\,GL1(\9ED)S3FgU&(B")
(qdl "mei2" "\
$(0,uFx4`08==@i?!Qj0v^](B\
$(0FWBK$(1;C-ELE@y:oE#8VU=(B\
$(1#<F>IH\ihy(B")
(qdl "mei3" "\
$(05",eWm$(10>B>=4;)/CX@(B")
(qdl "mei4" "\
$(0.i@g@q3R$(112$(0R%G10^:2$(1><(B\
$(1O3DYSw(B")
(qdl "men1" "\
$(0A-(B")
(qdl "men2" "\
$(01]61<d$(1P{[7Xz?tr8(B")
(qdl "men3" "\
$(1Pq(B")
(qdl "men4" "\
$(0A-S?XB(B")
(qdl "meng2" "\
$(0LaGBCeZTXMV'XOZ7$(1\h$(0SJ(B\
$(1Xgid$(05O$(1ag(3f2awH^8kVC(B\
$(1Yp["_pnHqQ(B")
(qdl "meng3" "\
$(0=xLpL\TcZ7$(1iv\sE)(B")
(qdl "meng4" "\
$(0JC.v$(1nBdG(B")
(qdl "mi1" "\
$(02BOw(B")
(qdl "mi2" "\
$(0:MU[WG[v[HV^X3$(1^Ji>oD(B\
$(1%NkA_qpWaql#mQmao7a7(B\
$(1qO(B")
(qdl "mi3" "\
$(0*N[H2}7i$(17MNa=>FeSV]>(B\
$(1mY(B")
(qdl "mi4" "\
$(0;pLn9:9+?=0G,sWO$(1&9$(0R7(B\
$(1B*VxV>fIB`K_$(0*O$(1*$K"K7(B\
$(1S7l3I0(B")
(qdl "mian2" "\
$(0A|LB8{$(1:z4qSse_f*iF(B")
(qdl "mian3" "\
$(0+.2/P<;)6}T}BI,~;'$(1,E(B\
$(1F(!.),;r:_dv(B")
(qdl "mian4" "\
$(05t\](B")
(qdl "miao1" "\
$(1:V(B")
(qdl "miao2" "\
$(05BAAKs$(1on(B")
(qdl "miao3" "\
$(04qBAY2YPPE0,4d$(1=.$(00;$(1Rd(B")
(qdl "miao4" "\
$(0+oN[Vf$(1,)(B")
(qdl "mie1" "\
$(02J$(1!"$(01/(B")
(qdl "mie4" "\
$(0FgPY$(1l7$(0VY$(1l2aR@7C0^saX(B\
$(1a~iJqh(B")
(qdl "min2" "\
$(0(b/%0u$(1RrE8-D&Z'+HK''(B\
$(1[N2#[V&`5$CJ(B")
(qdl "min3" "\
$(0<xNoDcM]/Z0_(xBJF&$(1Hw(B\
$(0S4$(17t*j#0OVbXCCQh(B")
(qdl "ming2" "\
$(0/})YMxMST,6DOyK&:!I>(B\
$(1D0M;H-+\JhB;_GGYKc(B")
(qdl "ming3" "\
$(17R)sBv(B")
(qdl "ming4" "\
$(0.UK&(B")
(qdl "miu1" "\
$(1.7(B")
(qdl "miu4" "\
$(0YA(B")
(qdl "mo1" "\
$(0Jv(B")
(qdl "mo2" "\
$(0O<STNwPMV`]JNyY?\4$(1kQ(B\
$(1I[felp(B")
(qdl "mo3" "\
$(0/\(B")
(qdl "mo4" "\
$(0(^>|U=KD,uPMJO5r0@9d(B\
$(00N955@]GR/HoST$(1X\O*'M(B\
$(1g~NXkzdFaH7SXjfePr+"(B\
$(1e{&'!&NygWc_8&@%@,I4(B\
$(1IOJ7c3lq8wGD^BI6(B")
(qdl "mo5" "\
$(0M{(B")
(qdl "mou2" "\
$(0T<><Vf*J$(1%GT%`,@&a:+i(B\
$(1N}a1%n)P(B")
(qdl "mou3" "\
$(03]$(1!/NH(B")
(qdl "mu2" "\
$(0O<$(1Q@(B")
(qdl "mu3" "\
$(0(a8f-(.l/i$(1+}HF$(02a$(1**1H(B")
(qdl "mu4" "\
$(0'N(yJ^0lNgJ<E:S[GEO1(B\
$(0,p5E$(1k<CmUYHC'w%y0%2a(B\
$(1IzdM8v(B")
(qdl "n" "\
$(0${%5(B")
(qdl "na2" "\
$(07W$(1/5*VTN(B")
(qdl "na3" "\
$(0-\6c(B")
(qdl "na4" "\
$(0-\9L+R?BD]<q6v$(1(Q2w9c(B\
$(1#T9VV*7y(B")
(qdl "nai2" "\
$(1\cPc(B")
(qdl "nai3" "\
$(0&&(E:O*=$(1\Z$(0.c$(1'O3G"n(B")
(qdl "nai4" "\
$(05%.c$(1Z>V?+8-tZ;=9[2(B")
(qdl "nan1" "\
$(0)a$(1"'(B")
(qdl "nan2" "\
$(023-/[E@KFJ$(1+,CMZO"0G"(B\
$(18}(B")
(qdl "nan3" "\
$(0?P$(1o*T'=<F?<2(B")
(qdl "nan4" "\
$(0[E$(1;/(B")
(qdl "nang1" "\
$(1p~(B")
(qdl "nang2" "\
$(0][(B")
(qdl "nang3" "\
$(0\p$(1q!q'(B")
(qdl "nang4" "\
$(1rE(B")
(qdl "nao1" "\
$(1.r(B")
(qdl "nao2" "\
$(0O"\NS$.O$(1=w&lg(nSVkb-(B\
$(1fAm_eH(B")
(qdl "nao3" "\
$(0H+A7G3(B")
(qdl "nao4" "\
$(0R$$(16T(B")
(qdl "ne1" "\
$(0.R(B")
(qdl "ne5" "\
$(0.R(B")
(qdl "nei3" "\
$(0Qu6c$(1?5(B")
(qdl "nei4" "\
$(0&z(B")
(qdl "nen4" "\
$(0JI(B")
(qdl "neng2" "\
$(09e$(1bpV@(B")
(qdl "neng4" "\
$(0V#(B")
(qdl "ng1" "\
$(0%7(B")
(qdl "ni2" "\
$(00H(H.j6>Ty/N$(17+MsTx9r(B\
$(1hbdwh<p4q51W'~T>4`6j(B\
$(0.R$(1(%.n@\H?h[(B")
(qdl "ni3" "\
$(0+$.sUj$(1f3VB$(0=$$(1*p%u+)bz(B\
$(1aq&{-3O<`Dl@(B")
(qdl "ni4" "\
$(0:LFk;4Sy0HGMO4$(1;cm%m'(B\
$(1IeY;-V4P(B")
(qdl "nian2" "\
$(0*"X4$(18%)r(B")
(qdl "nian3" "\
$(0<nO)XG/cQFP!8L$(1^:@`lE(B\
$(1h=(B")
(qdl "nian4" "\
$(0/C;G$(16^kK$(0'>$(1kG(B")
(qdl "niang2" "\
$(06u[i(B")
(qdl "niang4" "\
$(0^o(B")
(qdl "niao3" "\
$(0@%HU$(1\\$(0RO$(1B=S]Z@(B")
(qdl "niao4" "\
$(0,"(B")
(qdl "nie1" "\
$(07^$(1Ton?(B")
(qdl "nie2" "\
$(1-@(B")
(qdl "nie4" "\
$(0[jYX_*Y+_68N\e$(1p5$(09j$(1!"(B\
$(1aLY`d=AG$(0]W$(1<=q}mp$(0]"$(1(6(B\
$(1BXNBY#i(n"r1mM(B")
(qdl "nin2" "\
$(0<A(B")
(qdl "nin3" "\
$(1*h(B")
(qdl "ning2" "\
$(0JPR8V=UGXR$(1>2$(0Uh$(1qNn<;7(B\
$(1i`\](B")
(qdl "ning3" "\
$(0Uh(B")
(qdl "ning4" "\
$(0V#*r(B")
(qdl "niu1" "\
$(0+m(B")
(qdl "niu2" "\
$(0'](B")
(qdl "niu3" "\
$(09H,DD[,:$(1$d'v8u(B")
(qdl "niu4" "\
$(0/p(B")
(qdl "nong2" "\
$(0I*S+W$N%RDXt$(1fyj5r*od(B")
(qdl "nong4" "\
$(0,.(B")
(qdl "nou2" "\
$(1i^]P(B")
(qdl "nou4" "\
$(0Sw$(1d$B!j!(B")
(qdl "nu2" "\
$(0(DQ{$(1&87}MS(B")
(qdl "nu3" "\
$(0+9/;$(11C(B")
(qdl "nu4" "\
$(03((B")
(qdl "nu:3" "\
$(0&M$(1,h:$(B")
(qdl "nu:4" "\
$(0,:$(1/#2s/Z(B")
(qdl "nu:e4" "\
$(05MKl$(1ZQ(B")
(qdl "nuan3" "\
$(0FA$(1`[$(0G%$(1==(B")
(qdl "nuo2" "\
$(07c6v$(1kO5`6/(B")
(qdl "nuo3" "\
$(1Wa(B")
(qdl "nuo4" "\
$(0T@U`\($(1C2/@H+\nY7(B")
(qdl "o1" "\
$(0@H%-(B")
(qdl "o2" "\
$(06d(B")
(qdl "ou1" "\
$(0ODSIOHJ,$(1cK$(0^0%3$(1J<$(0;5$(1Qo(B\
$(1SJe^(B")
(qdl "ou2" "\
$(1#A(B")
(qdl "ou3" "\
$(0:|ZmJ,PK$(1#@=HFAYe(B")
(qdl "ou4" "\
$(0J,$(1KB$(0RH(B")
(qdl "p" "\
$(0$v(B")
(qdl "pa1" "\
$(05\H<;:$(12d27(B")
(qdl "pa2" "\
$(00h(WBd9W0-$(19_(B")
(qdl "pa4" "\
$(0/K//$(1#k9B(B")
(qdl "pai1" "\
$(0/j;:(B")
(qdl "pai2" "\
$(0<kBW<96;$(1bZ<x(B")
(qdl "pai3" "\
$(1iH).(B")
(qdl "pai4" "\
$(04'BC$(1_zF|(B")
(qdl "pan1" "\
$(0OYZ8$(1,F(B")
(qdl "pan2" "\
$(0OuP$Y;9p5)K8YF$(1]s$(0Q8$(1gp(B\
$(1BcYE+!b'M[BEJB@W(B")
(qdl "pan3" "\
$(1&!(B")
(qdl "pan4" "\
$(0+3264c8e/l$(19:'Sq<@I:4(B\
$(1DL$Y+yO5(B")
(qdl "pang1" "\
$(0)&O|Fc(B")
(qdl "pang2" "\
$(07kZ2LQT+Er$(1M7):#^AM34(B\
$(1.{Y$?@(B")
(qdl "pang3" "\
$(1B'YQ(B")
(qdl "pang4" "\
$(05)(B")
(qdl "pao1" "\
$(0/b$(18P(B")
(qdl "pao2" "\
$(0?;.K+6;2/7$(1V<+skMO0$(04:(B\
$(11!(B")
(qdl "pao3" "\
$(0DE(B")
(qdl "pao4" "\
$(00[9*4:8u$(1&%\?V#(B")
(qdl "pei1" "\
$(05+.D+f$(1U'+%&A.Q2r(B")
(qdl "pei2" "\
$(0;\Q*?rLy$(1(wEM=*:/2>(B")
(qdl "pei3" "\
$(1>,*s(B")
(qdl "pei4" "\
$(0:Z-z,m8a$(1UX&P/R07$(0]z$(1)t(B\
$(18A!t(B")
(qdl "pen1" "\
$(0N;$(1Wi(B")
(qdl "pen2" "\
$(04Z$(1=QG*(B")
(qdl "pen3" "\
$(1%lbi8C(B")
(qdl "peng1" "\
$(08~=o/d$(1&]KO$(0OT$(1#3HX*D@c(B\
$(1UqXp(B")
(qdl "peng2" "\
$(00&A&OTP]SzGVA}[\VZ$(1c,(B\
$(1%#6WdjE:[L-xTvAc[d`u(B\
$(1PIQ4o\(B")
(qdl "peng3" "\
$(0<\$(17I(B")
(qdl "peng4" "\
$(0GQ$(14<5P<S(B")
(qdl "pi1" "\
$(0,H/_')N+]?$(1,O$(0?8'b$(1%s$(0+f(B\
$(1#"("$(09I$(11S$(0IN$(1V;&n8>A5\l(B\
$(1NfUsU}(B")
(qdl "pi2" "\
$(0(w8mCQBc0.L};F3w;W-!(B\
$(1_c$(01c$(1fJ$(0PH9I$(19t$(0?w]TIN$(1M1(B\
$(1+L%.94Mt(+1dA.[:\%_4(B\
$(1e~'N7,fao((B")
(qdl "pi3" "\
$(0+B')(uBs$(1e@-C$(0)9$(1!Z")5#(B\
$(1TI(B")
(qdl "pi4" "\
$(0\@]=N"Ei,!I)Xi$(1b7W/Wx(B\
$(1]D6R<#K@puV"bG(B")
(qdl "pian1" "\
$(0P2;$38PJ$(1Fv;$@SUdk:(B")
(qdl "pian2" "\
$(01n9gU/$(1ZVZpCh[w(B")
(qdl "pian4" "\
$(0'[[RI6(B")
(qdl "piao1" "\
$(0\RKG$(1J2_-c%A^\}^Slv(B")
(qdl "piao2" "\
$(0SHJK$(16e(B")
(qdl "piao3" "\
$(0KG$(18l$(0VpSR$(16Ai@JJc|e|m*(B")
(qdl "piao4" "\
$(0>BKGE9]F$(1J)^,j]SF(B")
(qdl "pie1" "\
$(0SSJr$(1!_(B")
(qdl "pie3" "\
$(0Jr(B")
(qdl "pin1" "\
$(03<2\$(1f10G(B")
(qdl "pin2" "\
$(0?OZEU#^uUQ$(1eDf)(B")
(qdl "pin3" "\
$(02C(B")
(qdl "pin4" "\
$(0G}*K(B")
(qdl "ping1" "\
$(0)%7"$(11AUc_I(B")
(qdl "ping2" "\
$(0(N>&RVD$2o\7CZ.Z3m$(1'T(B\
$(1*2+Q?$G})(,/$o-1-Y%j(B\
$(1LV?B?w$(0E&$(12TFP+q(B")
(qdl "ping3" "\
$(1>s(B")
(qdl "po1" "\
$(00MOL.\1c$(1jJ,A8>(B")
(qdl "po2" "\
$(0;hQS$(1]ear(B")
(qdl "po3" "\
$(0Mj6J(5$(18!(B")
(qdl "po4" "\
$(09$5eR&4H0]*7>Q[3$(1&L0W(B\
$(1MC(B")
(qdl "pou1" "\
$(06J$(1#?(B")
(qdl "pou2" "\
$(15M$(0HW$(1$-/?(B")
(qdl "pou3" "\
$(06J$(1E(<P4d(B")
(qdl "pu1" "\
$(0N{&rQ[N:(X$(1>7gN&w]n(B")
(qdl "pu2" "\
$(0IyRuH:LcCW*7['>iV0SG(B\
$(022?'$(1MEcDN\$(0:`$(1jEgHi]Ow(B")
(qdl "pu3" "\
$(0A\8@6lZ{6iFh$(16tWsj:Q`(B\
$(0M0(B")
(qdl "pu4" "\
$(0O3Q[X^Z;$(1S0(B")
(qdl "q" "\
$(0%#(B")
(qdl "qi1" "\
$(0&%.gB#<RKKAu<E=_3qC](B\
$(0NiFr$(1$QT@9n4WplI7j_56(B\
$(1JvRO-p)J/d$(0WQ$(1.&4+536((B\
$(1H}LqXm[]dnhK<9(B")
(qdl "qi2" "\
$(0.(AgM}.bK"Yx4lAwGZ1&(B\
$(0;yBh,$0?B_[]]L>+Y,4m(B\
$(09T=T$(19\$(00/$(1L~d\$(0:4$(1im$(0+gTl(B\
$(1/U?TMd4GIBisHh\oie2q(B\
$(19bbygLhDjv2`[D5g#hEQ(B\
$(1?+:)!22fE`OHTf`xhMhN(B\
$(1o8qT]F(B")
(qdl "qi3" "\
$(0:E<w:@&@L@,^P($(1M!"8<n(B\
$(1<:$~4i"u(]#F(B")
(qdl "qi4" "\
$(0);86RC,v=:2W4h0C-V:=(B\
$(1"^$(0RWP=1h$(1Fi$(0SW$(1/p$(0A<.g$(1ft(B\
$(1gS(<2`"B=/!BZY=0R6p+(B")
(qdl "qia1" "\
$(15Y(B")
(qdl "qia3" "\
$(0('$(1A)(B")
(qdl "qia4" "\
$(03/4&$(1*3;p6B(B")
(qdl "qian1" "\
$(0&FIFQOZ\=uWI^?@u($*k(B\
$(0^t\VF'$(1AhJ0$(0J{$(1Z?,k#`$M(B\
$(0Vo$(1%";w"HaplZ4rF6eQh|(B\
$(1j"nE"2"C`Va8ed(B")
(qdl "qian2" "\
$(02*Te:rOQU>IA:&L-D`$(15_(B\
$(1;*<(X4&udlkda<$'$7#e(B\
$(1KCFWV7h#lz!o&(2i9fJs(B")
(qdl "qian3" "\
$(0MC=R],$(1i[J~PX"CMy(B")
(qdl "qian4" "\
$(0'OK:6*$(1Bn2B$(0J>$(1(a:9AqQ)(B\
$(0Vo$(1Y2Lo<sMQTr(B")
(qdl "qiang1" "\
$(0K4CKY^1.ENF6[?$(1gUM__j(B\
$(1'$Kz<Oco[.(>Is$(0;s$(1Km_T(B")
(qdl "qiang2" "\
$(0<1V<W0/R$(1V]$(0Ux$(1!CKFl,V{(B\
$(0RT(B")
(qdl "qiang3" "\
$(0<1F6$(1_CXtAjIQ$(0Vq(B")
(qdl "qiang4" "\
$(0EN$(1k}3zKl(B")
(qdl "qiao1" "\
$(0J~WuS!O*[,$(1]qgCOtVvbb(B\
$(1dglTgcB4NZVU[v.x@}Ua(B")
(qdl "qiao2" "\
$(0R~VKI{@SS"Y(Nt$(1Yw]y$(0[$(B\
$(1bYg=XBI+OqP#g:W;(B")
(qdl "qiao3" "\
$(0(J7LA;[Z?{$(1X:Ua(B")
(qdl "qiao4" "\
$(0Y(Xv1q71T~M/O*B'$(1.vW4(B\
$(1j((B")
(qdl "qie1" "\
$(0'#$(1$Q(B")
(qdl "qie2" "\
$(05=*y$(1"g(B")
(qdl "qie3" "\
$(0'c(B")
(qdl "qie4" "\
$(0'#^>.f/GA/7V$(1Ra$(0Wq2W$(1Jb(B\
$(1T`hA?|Lqc#0B(B")
(qdl "qin1" "\
$(0T61lB$$(12}`j$(0NU$(1F%ejU6(B")
(qdl "qin2" "\
$(0E<Be98G^Rj1D$(1],\k$(0R<$(1(b(B\
$(1Z+A<BHPk2-HeX*#p(N2i(B\
$(19fAJ(B")
(qdl "qin3" "\
$(0JU$(1'1;:WB_.#K`U(B")
(qdl "qin4" "\
$(0,iO-$(1.;?R(B")
(qdl "qing1" "\
$(0=S1fM=E16P=HLo@#[V$(14/(B\
$(1=-$h9u(B")
(qdl "qing2" "\
$(0<FA^UdE1U|$(1.16?Q+6C(B")
(qdl "qing3" "\
$(0Py@#$(1J!(B")
(qdl "qing4" "\
$(0NcVuT6$(1.%M!cU$(0SV$(1Q]$Nn;(B\
$(1O(5eEUfH(B")
(qdl "qiong1" "\
$(1$}$(01*$(1Nq(B")
(qdl "qiong2" "\
$(0P,ZN$(1$}$(01*$(1Gz@#;k"tXOfV(B\
$(1RGDZ7pG~fc/c9Z>eW`FZ(B")
(qdl "qiu1" "\
$(04r1X'd?3Yj\[$(1k=Cf%{Fn(B\
$(13^Rp;5SJZf$(0U@$(1*QT(c:l4(B")
(qdl "qiu2" "\
$(0,f>!(@&s5lHR$(1H'$(0=G0W$(1nd(B\
$(19i)!!9R/F$"m(iSlN1N=(B\
$(1>?U3:4\D-R!e"Q$(0=C$(13HD](B\
$(1-:1}8L8a;?AgG-\'dy6@(B")
(qdl "qiu3" "\
$(1Y5(B")
(qdl "qu1" "\
$(0;5/"]EWXYKJ[*3?0Xm$(19;(B\
$(1Pg$(0Cx$(1"}$(09($(1,z&B1K%]!#&v(B\
$(1(yUO\$hQol8+[}(B")
(qdl "qu2" "\
$(0B3+:[`^i$(1c?$(0Xm$(1o=$(0V?$(1mWl)(B\
$(1]uYd*|@i\58@FpG_W&_9(B\
$(1e6hlkemTmtpNqB-%*k6](B\
$(1?la5(B")
(qdl "qu3" "\
$(0.>*3;__"$(1+g8+(B")
(qdl "qu4" "\
$(0(+Q7;_KK$(1g#`?=F\>#/e0(B")
(qdl "quan1" "\
$(0;O$(1/-<T*>?"5<(B")
(qdl "quan2" "\
$(0)A]c3yHh7UMV>2$(1q~$(0Lu$(1>h(B\
$(0.;:%$(1dh0cH#$(0."'^Q?$(1_s*S(B\
$(14S=nGI[tkYmDpM)vE&Gx(B\
$(1Y>qr(B")
(qdl "quan3" "\
$(0'^$(1Ln$(00x4N$(174q7$R$(0;O(B")
(qdl "quan4" "\
$(0[a.-$(10d0]>y(B")
(qdl "que1" "\
$(09OYb$(1MN(B")
(qdl "que2" "\
$(0SL(B")
(qdl "que4" "\
$(024O}[Z?{/GYbK/$(1C%$(036B'(B\
$(0W{$(1J,.R>REORKbI>VE>K3(B\
$(1kp(B")
(qdl "qun1" "\
$(19lNI.q(B")
(qdl "qun2" "\
$(0G{HP$(1.j(B")
(qdl "r" "\
$(0%(%8(B")
(qdl "ran2" "\
$(0BTS@R#$(19(9)9>(B")
(qdl "ran3" "\
$(03Z'uR#5A$(1,6WZ%e&+Id(B")
(qdl "rang2" "\
$(0[o]l$(1mhe=i+$(0]h$(1e:i=l"pT(B\
$(1r'oH(B")
(qdl "rang3" "\
$(0[c[g[o$(1kk(B")
(qdl "rang4" "\
$(0^j$(1hx(B")
(qdl "rao2" "\
$(0\S$(1Yj$(0NMS$Y8$(1c@(B")
(qdl "rao3" "\
$(0XF(B")
(qdl "rao4" "\
$(0Y"$(1Z{UU(B")
(qdl "re3" "\
$(0Ez$(1:U$(05>(B")
(qdl "re4" "\
$(0O`$(1=C(B")
(qdl "ren2" "\
$(0&*)7&o'2$(11t$(0&+$(1(gO#(B")
(qdl "ren3" "\
$(0,7Gb9{$(1?7<g/w8j(B")
(qdl "ren4" "\
$(0)7M&&DE!Hv:H:34{+t$(1/$(B\
$(0'r$(13"$(0Dz$(1$aa3"9$u9e(B")
(qdl "reng1" "\
$(0(V(B")
(qdl "reng2" "\
$(0&t$(1$sAE(B")
(qdl "reng3" "\
$(0(V(B")
(qdl "ri4" "\
$(0'K$(12uO>A;(B")
(qdl "rong2" "\
$(07+K+T/FbC:KZ*'L]YT9v(B\
$(0K)$(1?($(0UY$(1Kv$y0',#eu2;6w(B\
$(1itb+BKK*ZF[o[zlwnf(B")
(qdl "rong3" "\
$(0&~9v$(1Wq:E@j(B")
(qdl "rou2" "\
$(03\AD$(1dR$(0TO$(1ZuC]!gF~`0$(0Yi(B\
$(1h%k1;,Suk"(B")
(qdl "rou3" "\
$(1Ri`/1pDV(B")
(qdl "rou4" "\
$(0*Y(B")
(qdl "ru2" "\
$(0)rR1US9}\;UIV-$(1@3iya4(B\
$(1>ibklM/5c&Noai$(0Xc$(1*6Y|(B")
(qdl "ru3" "\
$(0-g*>:J$(1\u$(0&M$(1%H(B")
(qdl "ru4" "\
$(0&,:JT3US9}$(1+YY<MFD8H.(B\
$(1BGB!(B")
(qdl "ruan2" "\
$(1:g\VP^(B")
(qdl "ruan3" "\
$(0?U-a\;$(1,tStb/Rnf-'4(B")
(qdl "rui2" "\
$(1YmLx4o(B")
(qdl "rui3" "\
$(0T!$(1W[bc;a6"(B")
(qdl "rui4" "\
$(0G0Q_$(1([$(0Ku$(12eVG';$V(B")
(qdl "run1" "\
$(1=o(B")
(qdl "run4" "\
$(0OWDd$(1Wf(B")
(qdl "ruo4" "\
$(05>7@$(1Rc$(0:x$(1eyA!$(0Sc$(1MIC_$(0]Q(B")
(qdl "s" "\
$(0%+(B")
(qdl "sa1" "\
$(0O%$(1!F(B")
(qdl "sa3" "\
$(0]eO%$(1Hd+V(B")
(qdl "sa4" "\
$(0Y0',$(19^$(0Ml$(1acO@O&(B")
(qdl "sai1" "\
$(0\ZH&$(10&<3(B")
(qdl "sai4" "\
$(0WTES$(1OP(B")
(qdl "san1" "\
$(0&6;7$(1QBh{lt(B")
(qdl "san3" "\
$(0AX@1$(1b]$(0Vc$(1j=(B")
(qdl "san4" "\
$(0AX$(1AC(B")
(qdl "sang1" "\
$(0@G8'(B")
(qdl "sang3" "\
$(0EB$(1guCARTd1ZH(B")
(qdl "sang4" "\
$(0@G(B")
(qdl "sao1" "\
$(0S}\XVmF4$(1^XBpD:g{pi(B")
(qdl "sao3" "\
$(0<bEh$(149(B")
(qdl "sao4" "\
$(0<b$(1]:R;(B")
(qdl "se4" "\
$(0*dESG/+dEFV+Xr$(1Wwj+l?(B\
$(1Nk]YF9XFnFX)(B")
(qdl "sen1" "\
$(0Aq$(1ScQ&F2_FI{^5(B")
(qdl "seng1" "\
$(0Is$(1nT(B")
(qdl "sh" "\
$(0%'(B")
(qdl "sha1" "\
$(0=E,h9B4f>uG"Z!HN,_$(1>5(B\
$(1gYV)Q$0e5+JRS\>S(B")
(qdl "sha2" "\
$(14'(B")
(qdl "sha3" "\
$(0E4(B")
(qdl "sha4" "\
$(0G"TuEo$(1AyC~LZM'?N:R(B")
(qdl "shai1" "\
$(0Se(B")
(qdl "shai3" "\
$(0Mt$(1fC(B")
(qdl "shai4" "\
$(0^;7q$(1`A$(0=E(B")
(qdl "shan1" "\
$(0&U7T5R,_+54DZf56K\OR(B\
$(0DD.n1C$(1-7C<$(0J}Vs$(1X{5b=a(B\
$(1,'7wAo(B")
(qdl "shan3" "\
$(0:a$(13IEC<JT9(B")
(qdl "shan4" "\
$(0CD7T*DR_SxY!$(1T~$(0K\:9@M(B\
$(0\F0y^X$(1jqOvV\5QJH_YO{(B\
$(1:#fj3)OQ(B")
(qdl "shang1" "\
$(0;9E3OFY>B>$(1KaS9_'cHlu(B")
(qdl "shang3" "\
$(0Q+7r&9(B")
(qdl "shang4" "\
$(0&9/!$(1kk)u!H(B")
(qdl "shang5" "\
$(0Lw(B")
(qdl "shao1" "\
$(0S9C"=0$(1FL$(07X$(1.}G38{ErCE(B\
$(1`rNPdzYv(B")
(qdl "shao2" "\
$(0,bMi-D&E$(1,3"++z(B")
(qdl "shao3" "\
$(0'8(B")
(qdl "shao4" "\
$(0'8>V6T1V(/$(1#5#19=>BQV(B")
(qdl "she1" "\
$(0;^M6$(1)c]/cN(B")
(qdl "she2" "\
$(0?+*`4J$(1#'$(0&p$(1<'H6(B")
(qdl "she3" "\
$(0<p1=(B")
(qdl "she4" "\
$(01$?D7-8F1=\m?QS%]R$(1);(B\
$(17/kcS<dSdd$(03FH5$(1/Kfv(B")
(qdl "shei2" "\
$(0Q!(B")
(qdl "shen1" "\
$(0-O=f*{(t>Z.G1k;76{>w(B\
$(11$%C,gG'GU[sX<$(09%$(1+@+N(B\
$(1":,-,}"x&2.s15(B")
(qdl "shen2" "\
$(0904J(B")
(qdl "shen3" "\
$(0,jNPX@XZ$(1TGn+,K$(02@$(14v]h(B\
$(1%*n%(B")
(qdl "shen4" "\
$(0E}CNKW4JHJ,i$(1F_CY$(0>o$(1&}(B\
$(1)/UF(B")
(qdl "sheng1" "\
$(0(nVy@:'+4=0$Bj>L:i$(1'o(B\
$(1HPe5#B('=Z=jh^(B")
(qdl "sheng2" "\
$(0ZbS4$(1W'i~phDP(B")
(qdl "sheng3" "\
$(04]$(11:%ORh3j(B")
(qdl "sheng4" "\
$(0@:>7G|@8$(1BV$(06!WV$(1!P@R(B")
(qdl "shi1" "\
$(0(C3M7<H^V/FjG)2p%'Pg(B\
$(0N81O&T$(1MBFTOM-[=U80l~(B\
$(1DQm6R`_Eq9Z8(B")
(qdl "shi2" "\
$(0&3&p(|7mJS5|3FLtK{7-(B\
$(0AI$(1MK=Gl{$(0E^$(11Le4HNJu=:(B\
$(1DKhe;9(B")
(qdl "shi3" "\
$(0-q.o(9Qz({2n-J(B")
(qdl "shi4" "\
$(0(L3S-h'a&JE=Z|2j(}H](B\
$(0D!*#'UQK\LIi-oM(?\EE(B\
$(033'l3Y-qW<EpRG3=?H$(1:~(B\
$(0Gj9lI'$(1ZW@Q$(0NG$(1$(X"ZSl;(B\
$(1H8<0Nu.@S&UN_\_obTj{(B\
$(1kIGu0V;S;\@>ByT4pP(B")
(qdl "shi5" "\
$(0;3(B")
(qdl "shou1" "\
$(0*.$(12J(B")
(qdl "shou2" "\
$(0O^(B")
(qdl "shou3" "\
$(0'D5})w$(1;xS1(B")
(qdl "shou4" "\
$(0.@;HJAZK<gOp4@LH(B")
(qdl "shu1" "\
$(07uTT83CU8$>.PVO9$(11y$(0,J(B\
$(1a_)iPuJF!@'H-iF"$(0Uy$(1,Y(B\
$(19dh`f](B")
(qdl "shu2" "\
$(0.?O^=WJ:]v;jCg$(11Qf{4L(B\
$(16~NKprqt(B")
(qdl "shu3" "\
$(0O0Ir\iAaGxW1HFE)$(1b:Qk(B\
$(0Zp$(1r:4kl9f;nC(B")
(qdl "shu4" "\
$(0?5O0Rz,W5_GxQ(>.7H<-(B\
$(0UpJ?KL;%*)$(1QJF8'WG;H<(B\
$(1;=e;g^k.(B")
(qdl "shua1" "\
$(0..$(14"`z(B")
(qdl "shua3" "\
$(05&(B")
(qdl "shuai1" "\
$(0Jt:/$(1Y:kV(B")
(qdl "shuai3" "\
$(0(p(B")
(qdl "shuai4" "\
$(0=|2vW7$(1)Q^?(B")
(qdl "shuan1" "\
$(0805o3G(B")
(qdl "shuan4" "\
$(0=X(B")
(qdl "shuang1" "\
$(0YeX$[h$(1pKr%nhkWmf(B")
(qdl "shuang3" "\
$(0=tJ@$(1Q1K\J=YH(B")
(qdl "shuang4" "\
$(1i6(B")
(qdl "shui2" "\
$(0Q!$(1?6(B")
(qdl "shui3" "\
$(0'V(B")
(qdl "shui4" "\
$(0M*KvC%HH$(1.w0<G>(B")
(qdl "shun3" "\
$(04b$(1Cj$(0+P$(1<7Zb(B")
(qdl "shun4" "\
$(0D|CVVJ$(1Ysh2Xb(B")
(qdl "shuo1" "\
$(0M*(B")
(qdl "shuo4" "\
$(07vK{ZHO0^M$(1B&$(0=|W72v$(1C&(B\
$(0)s$(1J|RbM@$(0&E$(16;C!R(d0(B")
(qdl "si1" "\
$(0(43)A[C>-4O#N\^[N<%+(B\
$(1QLRu3XM%dXRW2[Cx`$I)(B\
$(1'hZ$HJ)2@9J{LIMzRR_U(B\
$(1c=m2p.(B")
(qdl "si3" "\
$(0*<(B")
(qdl "si4" "\
$(0(?*~Q2EHIf)zG~1%1v*z(B\
$(00V&Z>f$(1\J$(0.t$(17r$(0Qy.%$(10A+1(B\
$(1"[/~Ga^m0-(B")
(qdl "song1" "\
$(005Y{=YEj,;$(1?W)g$(0<$$(1X/-}(B\
$(1EVMf(B")
(qdl "song3" "\
$(0V|Nk7N$(1>bAfBuIp`h(B")
(qdl "song4" "\
$(0:K+{Ie?EM"(B")
(qdl "sou1" "\
$(0F3[N$(1H2$(0Li$(1BgDA$(0Yt$(1Dt_tB#(B\
$(1d+jm(B")
(qdl "sou3" "\
$(06SJ'ZlXI$(1RF_Sks(B")
(qdl "sou4" "\
$(0J+(B")
(qdl "su1" "\
$(0\8BkDXS\^5$(1i*(B")
(qdl "su2" "\
$(01x(B")
(qdl "su4" "\
$(0D,?[9ECI;oET)iC6F`$(1Un(B\
$(1J+$(0P_$(1N2BoM._N$(0EP$(1WV'b04(B\
$(1QP$(0V[$(1SGPxT}nLoiouBI!f(B\
$(1K$+j/f:=D5PNUEYJf[H|(B")
(qdl "suan1" "\
$(0MMBt$(10k(B")
(qdl "suan3" "\
$(1VF(B")
(qdl "suan4" "\
$(0L,Ld$(1Eo(B")
(qdl "sui1" "\
$(0X#Gs$(1X-$(0GN$(18mD*7N0K.F.f(B\
$(18tD,(B")
(qdl "sui2" "\
$(0TrDl$(1dB(B")
(qdl "sui3" "\
$(0^U$(1VreodAp_(B")
(qdl "sui4" "\
$(0FZI.GPVUTq9.V2Q$$(1EAbN(B\
$(1]T]"fxlQ$(0YO$(14ATS]5^EbL(B\
$(1eWf?jS(B")
(qdl "sun1" "\
$(07#D~Lg$(1DrCBK)^kYy(B")
(qdl "sun3" "\
$(0F5C2K1$(1bWd7(B")
(qdl "sun4" "\
$(0O\$(1J;(B")
(qdl "suo1" "\
$(0Vd=;>u6[6tS`EC$(1::5K$(0Lk(B\
$(16)ce8fN@JC(B")
(qdl "suo3" "\
$(0/U9FYVKf$(1R2AzJKd2jO(B")
(qdl "suo4" "\
$(19g(B")
(qdl "t" "\
$(0$z(B")
(qdl "ta1" "\
$(0(G'm)q-)EZ$(1ZI(CRY(B")
(qdl "ta3" "\
$(0EX$(1Jod'(B")
(qdl "ta4" "\
$(0Q<K0WZZL$(1C4$(0MF$(1\Q$(0\J$(1'PA|(B\
$(0RbMG$(1l[d(d;[J`Lgnl|,q(B\
$(16U:@K5TFn@$(0KR$(1(q];rF(B")
(qdl "tai1" "\
$(0515F(B")
(qdl "tai2" "\
$(0(;LX/rMm5F$(1(x$(0DHXUY6$(1+r(B\
$(1Ux\*VA\aiT$=1T(B")
(qdl "tai4" "\
$(0'5Ji8;,q$(1A/]MDF#;:<(B")
(qdl "tan1" "\
$(0?N]f]b^b+a$(1*B&~8WLm$(0<Y(B")
(qdl "tan2" "\
$(0PvN_G9OPZ~UrRLRrY'C~(B\
$(19m[-[hnKj<-mgMg64cPJ(B\
$(1fTWPm<ow(B")
(qdl "tan3" "\
$(0.]B(?9$(1fw#x]z?Lg9I=^U(B\
$(1PT[%N!(B")
(qdl "tan4" "\
$(0<YJ-OEKz48$(1TY4@=KR}(B")
(qdl "tang1" "\
$(0B>[:$(1pycnSy(B")
(qdl "tang2" "\
$(0;YSh6UEUPLW9AkWiF.[:(B\
$(1D.Z*$(0Ki$(1_eJfQ3K]Kid.gg(B\
$(1WdM:RSZn^jm#(B")
(qdl "tang3" "\
$(06:QA]Y=O/1$(15Ar0d5o+p:(B\
$(1pAq*(B")
(qdl "tang4" "\
$(0Q6S>$(1j7J[(B")
(qdl "tao1" "\
$(0<lV(Fq^&[I$(1&S$(0Gt$(1YBC7Bt(B\
$(1JwBbM&BLMo(B")
(qdl "tao2" "\
$(0:Q8-?xCl=dV(;D4/XbXT(B\
$(1%X)DLyO-U,db[8[rE^[M(B")
(qdl "tao3" "\
$(0:7(B")
(qdl "tao4" "\
$(06q(B")
(qdl "te4" "\
$(08XNf$(1#v#wU53'c7(B")
(qdl "teng2" "\
$(08p\WZn\|WNOZ$(1Z3YC(B")
(qdl "ti1" "\
$(0=/Q;6L$(16m(B")
(qdl "ti2" "\
$(0YoAI@A@]TL$(1[(LG>]$(0PF$(12<(B\
$(1h*$(0Dr$(1k4;s)9`.3ZZg_Uk)(B\
$(1;PL-SxYuow(B")
(qdl "ti3" "\
$(0^V$(1"~E~(B")
(qdl "ti4" "\
$(0Af<L8=;u7Q2(QYUK$(1-y^w(B\
$(1Q>N';{iVdi57T-$(0?c$(1d|(B")
(qdl "tian1" "\
$(0'3=Q$(1.!&<A'4p(B")
(qdl "tian2" "\
$(0(q>(EY34Ya4O$(1R^'\,H=2(B\
$(1?uRM(B")
(qdl "tian3" "\
$(0LZ/@$(1+I$(0CPT}$(16SO8TT5G2l(B\
$(1<LE9(B")
(qdl "tian4" "\
$(15RDTKx(B")
(qdl "tiao1" "\
$(03H$(17a*K*;`|(B")
(qdl "tiao2" "\
$(0=?P~$(17u$(0-{5aLv$(1U~&I-5kJ(B\
$(1na[a"ld:Gn1O(B")
(qdl "tiao3" "\
$(03H>F$(1GS)y\[(B")
(qdl "tiao4" "\
$(0H}>=$(1q//[$(0HXQp$(1>~Y!22(B")
(qdl "tie1" "\
$(0D3/.$(1&c(B")
(qdl "tie3" "\
$(0]8/.$(1obI'(B")
(qdl "tie4" "\
$(0/.Yv$(19+(B")
(qdl "ting1" "\
$(0]p_#(f$(15|"k(K(B")
(qdl "ting2" "\
$(0:u7>,-1iHCQh@f$(1=18q"P(B\
$(1EtT&S'FSkHCQK!UR;QF'(B")
(qdl "ting3" "\
$(07`H-$(1$n$(0=9$(1[g768RU;6|!O(B\
$(1)1(B")
(qdl "ting4" "\
$(0]p(B")
(qdl "tong1" "\
$(0?X35$(1SQ7F+vQu,&(B")
(qdl "tong2" "\
$(0)RC*MR8*OJVG,0$(1#%$(0It2s(B\
$(1%?bnW>Y_]|^O7_WJWrR#(B\
$(12I0Y0LHSO:!JH430>p>v(B\
$(1WHXEYf`{e7m\)BGR(B")
(qdl "tong3" "\
$(0>TC0=4$(1/9)VEq)q(B")
(qdl "tong4" "\
$(0Bo$(1@)$(0Jm$(1mx(B")
(qdl "tou1" "\
$(0;#$(1;'(B")
(qdl "tou2" "\
$(0U%,N$(1Dj9x(B")
(qdl "tou3" "\
$(1a;&&1|A7l&(B")
(qdl "tou4" "\
$(0?a$(1W=(B")
(qdl "tou5" "\
$(0U%(B")
(qdl "tu1" "\
$(0-6$(1e,0D5dIk(B")
(qdl "tu2" "\
$(0J8?e4t7AEV;t'z?&$(10@$(0+((B\
$(0MO$(1E0>_FG.uFRe,/O&h`:(B\
$(1NC68=REwM6R5`ok(njnx(B\
$(1BZJ"KJns(B")
(qdl "tu3" "\
$(0&I)T$(1:'${.J(B")
(qdl "tu4" "\
$(0.#)TCp$(1hU4O(B")
(qdl "tuan1" "\
$(0B@$(1DfZ](B")
(qdl "tuan2" "\
$(0J7$(1JG$(0\)$(1KAAmJ/g`oqQ0(B")
(qdl "tuan4" "\
$(1*?T5(B")
(qdl "tui1" "\
$(0<e$(1SLf\(B")
(qdl "tui2" "\
$(0U&$(1f5UTdoW^I#gA"?(B")
(qdl "tui3" "\
$(0LU$(1)0(B")
(qdl "tui4" "\
$(0:NHH$(1`nZ.(B")
(qdl "tun1" "\
$(0+@$(1W?3x0/'0(B")
(qdl "tun2" "\
$(0';+\?IE#W#$(19`V-#|(V#D(B\
$(1*Y(B")
(qdl "tun3" "\
$(1"Y#DL"(B")
(qdl "tun4" "\
$(0T1$(1Z.(B")
(qdl "tuo1" "\
$(0>l/o*-:;$(1:q%J/A"M(A'l(B\
$(1Hm)*@HOI(B")
(qdl "tuo2" "\
$(0Qw1_Ik0F*qU7DA$(1W\&"8)(B\
$(1A%1="w\!&=L@O1nQqVH6(B\
$(197:5(B")
(qdl "tuo3" "\
$(0+uR|$(1Pd5.P"(B")
(qdl "tuo4" "\
$(0/`@O3p$(1mkik@bD&0#(B")
(qdl "u" "\
$(0%3%:%;(B")
(qdl "u:" "\
$(0%;(B")
(qdl "w" "\
$(0%:(B")
(qdl "wa1" "\
$(02?Cs3:L$.N@k$(1+T"hD+1_(B\
$(17nK:(B")
(qdl "wa2" "\
$(02`(B")
(qdl "wa3" "\
$(0(l$(1#!(B")
(qdl "wa4" "\
$(0])$(1B"M/(B")
(qdl "wai1" "\
$(03r(B")
(qdl "wai3" "\
$(09k(B")
(qdl "wai4" "\
$(0(A(B")
(qdl "wan1" "\
$(0_%]`Q'6K>vLm$(1!|Q_(B")
(qdl "wan2" "\
$(0+z0sIa&;*G$(1,m%$6n4R#a(B\
$(1$,(B")
(qdl "wan3" "\
$(0=&GR7b.~;a6}BwM>>v$(10*(B\
$(0Lm$(1E,?G>#[b$(0L7$(1<FM"dp-l(B\
$(18SE@U0>HFr(B")
(qdl "wan4" "\
$(0G]0sCJ<B$(1"$S"#z!yF-!&(B\
$(1_15LT^(B")
(qdl "wang1" "\
$(0,n$(1#_$(0&S(B")
(qdl "wang2" "\
$(0'_&B(B")
(qdl "wang3" "\
$(0/<L>041-<KY~QI$(1ax"i<I(B\
$(1?]?9(B")
(qdl "wang4" "\
$(0,4)m=-/w'_$(1Jd(n8_(B")
(qdl "wei1" "\
$(02e@w:}G$$(1FbAF$(0DR$(10OCb=J(B\
$(1L9;t<4G#ADDBGXSrT;]N(B")
(qdl "wei2" "\
$(044@YEs)O;ELE<NI15vW3(B\
$(0\j8/W}V1<*$(1BY$(0@}$(1!*=?D?(B\
$(1@w`1a#Qf+kizU-l_epb#(B\
$(1b<mU(B")
(qdl "wei3" "\
$(0.h,#:zP9CkP|H3G>B[$(1DU(B\
$(1mFH\$(06y$(1dQ;6$(04,$(1Dybuc$la(B\
$(0X/$(1RQFVUeCI7DHqCw00FK(B\
$(1(X`5)~eF:`;]FBMnORS[(B\
$(15'7[Tmo/(B")
(qdl "wei4" "\
$(044*n(]Y|Pl.A:tTB5,@E(B\
$(0NjX*;qB<4LPT$(1m{S|m^$(0T](B\
$(1mFglRNYL$(0WE$(1^n;"MqffgQ(B\
$(1?ZQ~[jcdn*n4$(0S\$(1\#\j(B")
(qdl "wen1" "\
$(0FlOn$(1_m$(0E[$(1h"L4_`K1(B")
(qdl "wen2" "\
$(0'GLM9C:'0uDx$(1[X'u(S>-(B\
$(1[V`@a?OCV,V0(B")
(qdl "wen3" "\
$(0ZX+N)H$(1%k6:(B")
(qdl "wen4" "\
$(0;CLM9D'G,|,Q+.$(1C6i?#Y(B")
(qdl "weng1" "\
$(09SEL$(1Z<m8[_(B")
(qdl "weng3" "\
$(0Ll$(1DCJ_0JRIYSB1(B")
(qdl "weng4" "\
$(0Xh$(1,;pzfG(B")
(qdl "wo1" "\
$(0L%6=B=H9$(1=yTk(B")
(qdl "wo3" "\
$(0,=$(14Z5i(B")
(qdl "wo4" "\
$(0AJ1;,wB4K!_!$(1;X6G3U]?(B\
$(1=e(B")
(qdl "wu1" "\
$(02q8V*E*@)fM%EK,(YW$(1H1(B\
$(1+UK.$(0%:A+/v$(1$@-g3n7lF@(B\
$(1a)Z5(B")
(qdl "wu2" "\
$(0BS+G+A=6,(T)6]HDM%'R(B\
$(0&B$(17"Y\e.$(0\_$(13:U7U2.p03(B\
$(172)$dr8goy0H]lg.(B")
(qdl "wu3" "\
$(0&m'*0>L[1y)1[YNuNK$(1QU(B\
$(1P@!m#~EN]^C:4($(07\$(1B[(0(B\
$(1-|WhlF(B")
(qdl "wu4" "\
$(0''0m;.A+M)7M='[G(TYW(B\
$(0E]&C[QJV:I$(1$C:|k<$(0;T$(1$X(B\
$(1(rZ}U@"7"FDd)86uAP"v(B\
$(11r(?(_4E9j>8hfih#dOd(B\
$(1SR(B")
(qdl "x" "\
$(0%$(B")
(qdl "xi1" "\
$(0*j,)+O\nN2\wC&<?Fr06(B\
$(0W@K[VSPNAuYSNH&|BYA](B\
$(0Ss>+[rIvLq$(1$/$(0S<6s$(1,Iq=(B\
$(0[#=*$(16=$(0W\$(1WUhs$(0=^$(1E=$(06h=s(B\
$(1:CBj*GX}>nN;c~p-0(0;(B\
$(1Q\]Kmc,?lLBNdA/,>F7X(B\
$(1pOqcJxWki;7=Z2))*@*A(B\
$(1.`.m$(0WQ$(18n?VAdQ*Z7_a_b(B\
$(1e'jkr4-`65;nVEjVN7]r(B")
(qdl "xi2" "\
$(0>e/x7K7;<IEgTg]rK^L_(B\
$(0WBUt$(1N.`CN'IvZ4n`?2P~(B\
$(1=hcMd8/y<[MVR=XK^{gj(B\
$(1jaliSm(B")
(qdl "xi3" "\
$(0@F4$<7ZM\Z$(1IiS`p6+9c+(B\
$(1^Iq0cpqb!$0iZT^4FkKS(B\
$(1W<(B")
(qdl "xi4" "\
$(0>YUb1|-8Z_&K*CMaS%$(1dk(B\
$(0CF$(1(F)@p8F+(OH3c~dZDO(B\
$(1T8lL$(0O]$(1?>$(01#$(1qc!N&g:"d*(B\
$(1:!Ge3BKgT:Yx\A_Oc(&[(B\
$(1*P<)LCn{(B")
(qdl "xia1" "\
$(0OvPe$(1#bHi`#(B")
(qdl "xia2" "\
$(0F?72W]X%1o8Z7Y+;.HI2(B\
$(1>L$(00oG.<|Z)3n$(17e$(04&$(1FJL?(B\
$(1h)C(0^%P8"YF0}$(0:f$(1RJZe(B\
$(1\&^q(B")
(qdl "xia4" "\
$(0&76pUJEoF?$(1^N$z/{gVm"(B")
(qdl "xian1" "\
$(0)@'q<mX-^CRp.n$(1hqW-n0(B\
$(1Nc$(01($(1`Q+>$Jh!Vb!K!X"1(B\
$(1'>$"QQq]$(04j$(1A_I1MY_Ahu(B\
$(1oN0{(B")
(qdl "xian2" "\
$(0Q0DhEc2<\\/9MW>SNI=I(B\
$(0;K>rDf$(1]dZN9$PPp"4jFa(B\
$(1,x?}R|X3iIp#4%(B")
(qdl "xian3" "\
$(0Ts^PX-]k]$MZ$(1b*GvVo$(0HK(B\
$(1)jBReMXL]Qo9>lo`0$0Z(B\
$(1`+C*p,p{9YePLK(B")
(qdl "xian4" "\
$(0Sm>#P@5pRU[yGz?yH*U,(B\
$(0HK?(\Q$(1)'$(0I~79$(15n>C_]lG(B\
$(1UH0FesE}.eP_[9)x(B")
(qdl "xiang1" "\
$(0DU4_5~P.B8WC_,A#$(1r$Rq(B\
$(1Y}$(0\x$(1o?kaF`hv(B")
(qdl "xiang2" "\
$(0H\>A5sCE2y(B")
(qdl "xiang3" "\
$(0Ex]A-kMq]D$(1h?qJ/Y(B")
(qdl "xiang4" "\
$(02t)X4_IzD{D0R}X=$(1WCc<(B\
$(1G&`=c5cEjP$(0DU$(1*RQWoo(B")
(qdl "xiao1" "\
$(08>QZT(ZA7*?W\gXwB}Qg(B\
$(06b^(=A$(1m}+-`v\2OcF)$(0J5(B\
$(1K-QP0RR+2ZG3>6PH"a%c(B\
$(1^!+P05>:FfNGYVbsi'js(B\
$(1o4q8.x4.>albcP(B")
(qdl "xiao2" "\
$(0RQ$(1+P1e9v(B")
(qdl "xiao3" "\
$(0&RRo$(1Eu$(0V\$(1_S(B")
(qdl "xiao4" "\
$(07y9?+v7hMLN=-:@2$(1*CX?(B\
$(1ND(B")
(qdl "xie1" "\
$(0-iFYZs$(1S{=zT8At(B")
(qdl "xie2" "\
$(0.7Qm<|9^T>-Z:~Qo7Y$(1>z(B\
$(0\nXJN/$(1kxl88KBx"!T))^(B\
$(1*],f.]qpBqC9E"Kk]L(B")
(qdl "xie3" "\
$(0NQ*g(B")
(qdl "xie4" "\
$(0WM=84.7.XYR].<0RZtHY(B\
$(0;uWAK52WU.$(1V}=8$(0WfV4FK(B\
$(1>x^i$(0>^$(1:{VnX$eqXJpS$`(B\
$(11-dNOD`g3P])hk#)#V,[(B\
$(1Jr[cP,7!<"mCpU(B")
(qdl "xin1" "\
$(0'AF<-QW+0=QX\U$(1pZ$(0>w$(1'r(B\
$(1C|$(01H0"?G$(1A+,J:FP?$%#[(B\
$(1VQ(B")
(qdl "xin2" "\
$(0@s$(1U"'AW:cF(B")
(qdl "xin3" "\
$(1!r(B")
(qdl "xin4" "\
$(01k_+1H$(1=bicY^"(#[D^"x(B")
(qdl "xing1" "\
$(0S|3TB]H%\UA1$(1`eDbE$-$(B\
$(1.VG1_Jr#(B")
(qdl "xing2" "\
$(0*h,12O)F-Y:h>@$(1Nb`\%7(B\
$(10\+n23UG]=(B")
(qdl "xing3" "\
$(04]T_$(1\x=B(B")
(qdl "xing4" "\
$(0*hS|/M/2.p,Y6+<G$(12Q4V(B\
$(18h6J(B")
(qdl "xiong1" "\
$(0't)>9b'!)K4($(1$$)H*N(B")
(qdl "xiong2" "\
$(0DuK]$(1Gd(B")
(qdl "xiong4" "\
$(1Pi@B(B")
(qdl "xiu1" "\
$(06<)3>a>m2I$(1*<Gb[|g|a/(B\
$(1KRQ8?=2MO"S_`9KU(B")
(qdl "xiu3" "\
$(0*6;o$(1Y4(B")
(qdl "xiu4" "\
$(0-5Y$\O?:EM;o9i$(177$(0Ft/)(B\
$(10w!fK2T7Z6(B")
(qdl "xu1" "\
$(0D}MfCq^*N8N@*(5*:>)U(B\
$(1Wj(:P$iZ0!$;%gC^\^n9(B\
$(1+G-zLORsSvY~nPnW/X;Y(B\
$(1<*Rj(B")
(qdl "xu2" "\
$(07C(B")
(qdl "xu3" "\
$(0?C8#F}2I$(1GP.#&,=AZP['(B\
$(1U%0y:X(B")
(qdl "xu4" "\
$(0,*\~L`LF<yC=*237.=?i(B\
$(0@h8g42$(1"O%EBmKQfZ$(0Ic$(1(Z(B\
$(1bxV$3q$(0=,$(1@?qL0[&a.WEj(B\
$(1]iNx'f*uL,(B")
(qdl "xuan1" "\
$(02h:G@@$(1Dw$(0H1FBUO$(1OU$(0TG$(1B,(B\
$(1V^;zfMZK;o$(07s$(1`-m361$(0G%(B\
$(1Fl;u#+'.U9;+XxSjfniE(B")
(qdl "xuan2" "\
$(0(i="[mKB$(1R,$(0Xg$(1#(&-75,.(B\
$(1IcTA$(0WdSm$(1G6(B")
(qdl "xuan3" "\
$(0TZ$(1)=0N(B")
(qdl "xuan4" "\
$(043CAKB8y$(1'R$(0B0="$(17QCPPi(B\
$(0IK$(196Sg`m[`gP*nCd99^>(B\
$(1n)oU(B")
(qdl "xue1" "\
$(0W2I^RE$(1Vq#=(B")
(qdl "xue2" "\
$(0RQ)!$(1pvi{NJ]O]<V[(B")
(qdl "xue3" "\
$(0?|$(1nZ(B")
(qdl "xue4" "\
$(0*g?|)!2)$(1Gm'Q_L&>98(B")
(qdl "xun1" "\
$(0R;Y4X`$(1Kh$(0]5$(1*!ah6s]Ri\(B\
$(1bmSP$(0@;$(1f+(B")
(qdl "xun2" "\
$(0@s-WHgA(*1IlO[$(10sc1$(040(B\
$(0:"3%$(1*M*!/oX7$(0Xg$(1,l-_oh(B\
$(1K,P]'J)QXSWYYnOi(B")
(qdl "xun4" "\
$(0:::<-UMB84Il3%@y*FT#(B\
$(1Oj%A$(0O\$(1dP32e)(B")
(qdl "ya1" "\
$(0+UUMR*U:/f&:$(1<W$(0G#$(14s(B")
(qdl "ya2" "\
$(0'\1B=VHM:./f$(1'8$chi!v(B\
$(14H(B")
(qdl "ya3" "\
$(0-j;=Dt$(15T"%#oZ#AL$(0(u(B")
(qdl "ya4" "\
$(0-j?@$(1(o,N$(0B+$(14Y<$[/?.$(01R(B\
$(1!:"p(*=uLTrD(B")
(qdl "yan1" "\
$(0Fv=p=Z85QW2A9_.dB;CY(B\
$(0JMS;$(1SD[U$(0J&$(15"ibNUKY=s(B\
$(10z3d\bgK$(0CR(B")
(qdl "yan2" "\
$(04g-GYn[e/80Y0dVE^}/((B\
$(0L+Z]Tp+q$(1Mr$(0U{$(14>:]B~L<(B\
$(1L{9s$(0^6$(1o&Cpq,US.aA67-(B\
$(1Z'`WeGk@o$9!;K(B")
(qdl "yan3" "\
$(0>:K><`5QDV:w2#$(1km$(0]X^x(B\
$(1.**=F3$Wo';v<-=PSpqn(B\
$(1)mPU<UeKjy$(0^1$(1>$)7e>C{(B\
$(1$3kN9z;@;q?IHYN$T1k0(B\
$(1kDp;5=Zs`cm=(B")
(qdl "yan4" "\
$(0^TS;J&7oDs7(=Z_DSA2~(B\
$(0@^C!2AZ-6V^Q4g$(1oP$(0T90Y(B\
$(1qx=c$(0_=]w$(1:OrAi::+m+eK(B\
$(1a%oY$(0BR$(1'|)oo}Cqi!\r4m(B\
$(1A[V9VPjjoO$(0^m$(1qg9!<?(B")
(qdl "yang1" "\
$(0(B963sU9Mh0X$(1%w-*+.#$(B\
$(1&)85HEHa(B")
(qdl "yang2" "\
$(0FODmAS3z*Q-m8QKmWx3'(B\
$(0YrFCF|$(1)T*qLH?vDz0ujM(B\
$(1;Ept7U;!(B")
(qdl "yang3" "\
$(0Qs)887[{Mh$(1!8ab&D+u'!(B\
$(17Ca]Ml(B")
(qdl "yang4" "\
$(0O5Qs7DKC/EF|$(1a{88(B")
(qdl "yao1" "\
$(05SH#'6+pWg&>)]@P$(1:S,Z(B\
$(1F^9Q(B")
(qdl "yao2" "\
$(0F7WL@ZMD2c4/KeIu=iU-(B\
$(1gz:B^FP1Bk=)Ds@e$(0'Z$(1)_(B\
$(0<#$(1Nj0r+:7(l}$(018$(1B@0P$(0P+(B\
$(1B(Bs$(0K9$(1lb(B")
(qdl "yao3" "\
$(0279<9k'6$(1'L$(00,$(11\7mnt#\(B\
$(1&s-G173TD2J}h$#gBLMX(B")
(qdl "yao4" "\
$(05SZo\/XL_-]P/p$(1b)9IO2(B\
$(1boN0,b>fFzR$g<(B")
(qdl "ye1" "\
$(05(N9$(1oJ$(0%/(B")
(qdl "ye2" "\
$(0G&5(FM=~$(1<%\y(B")
(qdl "ye3" "\
$(0&??j+0$(145KZ(B")
(qdl "ye4" "\
$(0FGH55y.`2ATA3@^OT^$(1X9(B\
$(1]m\w$(07-Rq$(1dYDW`2lWX1d4(B\
$(13S=&VpW7(B")
(qdl "yi1" "\
$(0&"@c*i-nYQ)/AKR=KT$(17'(B\
$(02L%9$(1LF^Le/W@N`'^nr=!(B\
$(1@z"*D=LRXC+l:.@!I_XN(B\
$(1akavp)Vi(B")
(qdl "yi2" "\
$(0T]Kk>D.|/L2_N!)kPt9](B\
$(0D5Ig2=$(1@F$(0-"U'XA$(1CR$(0>3)g(B\
$(1\f7{/b!M.i+S^3$(0:?$(13&33(B\
$(1$E+4@43E*)7O?)HH\e%8(B\
$(1,7-ONs)O*E?k'U$(081$(11#9@(B\
$(1?*?xCFGpK/QyR`Z9`TcY(B\
$(1l<po(B")
(qdl "yi3" "\
$(0'i&Y&#6/An-3Zq$(1fQ$(05f$(1-;(B\
$(0;&$(1/3$(0K#$(1Z0"G3EAU-bp3gw(B\
$(1]$HG$(0-T$(1-"bJ5]:.;J<Mj*(B")
(qdl "yi4" "\
$(0EuGy/y\?)*8v>-ZkM~RZ(B\
$(0\B=M,3Vw4POGDP-X,PH!(B\
$(0ZaF_SiDKHb)|++>c5#^S(B\
$(0<X]aHOV}*42VLrCL*i'$(B\
$(0Vv$(1/=$(0Y[]Z2|-}$(1!!$(0&^*e$(1W*(B\
$(0R:$(1VS\z^b/(R:!II,4;Vl(B\
$(02w$(1W@$A+$Wm$(08O$(1QpYcq;jc(B\
$(1V=AX.>]IfWg4\d"yQw#2(B\
$(1]!ArJ$lNdOj6j38<!h">(B\
$(1'?#*+aX&$|XA,1&tl()%(B\
$(1=g]J<K.T9}/F/z448;:2(B\
$(1=%@ZG?IWLvM-O+Q(QeSE(B\
$(1VWXY_\f=i.*5PwgkpmqX(B")
(qdl "yin1" "\
$(0)_5x?v2f859yJg8:$(1L$:L(B\
$(1:e;dLD>w@.`>[qNiM\ZM(B\
$(1)Zj\+h3lC}\R`Ej[m;JV(B")
(qdl "yin2" "\
$(0MQ+X;l=cMK]VU{[F2PJD(B\
$(10faJ5(THc-4]!6(cA4.K(B\
$(10_3l8~Q<S;atotg\(B")
(qdl "yin3" "\
$(0'@E$X!&h]j:)+Y$(1Hc1x$(0Vt(B\
$(1pQT]_&O?A0].]Cl%1o(B")
(qdl "yin4" "\
$(0)NE$X!PW53$(1J#LSW%=].S(B\
$(1>!JcN_(B")
(qdl "ying1" "\
$(0U]5C^zUP]N\qW!G4_F[d(B\
$(0\.^B$(1hz$(0\y$(1BDf'YKDedTR7(B\
$(1`ILAkrCOT*=\ZA3g[^l+(B\
$(1lAoKk?(B")
(qdl "ying2" "\
$(0V31SZrT.\E4YOfSkZ@$(1K6(B\
$(0RPE_K_FT$(1a|elq^i-_WeR(B\
$(1hrhtbr(B")
(qdl "ying3" "\
$(0N`A`SZ$(1QDmd$(0:X$(1i/,L5~0:(B")
(qdl "ying4" "\
$(0U]B~3Q$(1BAa|d9JXN>(B")
(qdl "yo1" "\
$(06W(B")
(qdl "yong1" "\
$(0E,<,IUR`RM$(1o;$(0V~$(1I?gO$(0Jp(B\
$(1nG$(0:U$(1kZdDB$kf$(0MJ$(1VHWt^~(B\
$(1KW[!(B")
(qdl "yong2" "\
$(0E,$(1:WdW:7Q,BFBTIa(B")
(qdl "yong3" "\
$(0(d0ED#2.R`TNB1HB--RM(B\
$(0<=V~1p$(1NF.XB2RX$(08K$(1/'Nt(B")
(qdl "yong4" "\
$(0(o+"$(1_u(B")
(qdl "you1" "\
$(0UANh2x<@$(1%h$(0,T$(1k~Hve\cz(B\
$(1aW&kaGb"ky90(B")
(qdl "you2" "\
$(0(rB-I,'90SDTBZG(IE$(1Zt(B\
$(04T$(19*Yz*lSk9O9kCT$(0R'$(1!k(B\
$(1$P0?3e1X8d(B")
(qdl "you3" "\
$(0*5'/-]?#ObX7$(1,p'pNg&M(B\
$(1.y(e8IPy(B")
(qdl "you4" "\
$(0&5(.(OM-*x3gI?9,*52l(B\
$(0.!2MZ+$(1#4)p'}*/@M\7$2(B\
$(1+|36(B")
(qdl "yu1" "\
$(0=P-SG84~%;$(1D(LY"D(G7K(B")
(qdl "yu2" "\
$(0/vA:@$6xQv&AKV&iEt+((B\
$(04vFUI8H?2!WaG5BDDn1<(B\
$(0CT0}Q&$(1Zq25$(0)hXVT7$(1>4$(0Cj(B\
$(1;GLU$(0+r$(1<.D"$(04o$(1lIAH$(0?}$(1$?(B\
$(1<d$jRxR~$(0PkPr$(1E7FO0j"s(B\
$(1b0>WiX:%;I=HA$FFL0UV(B\
$(1W~Yg_;cJd{e&ijppqR-N(B\
$(14):h:vH_R[h}j|p|(B")
(qdl "yu3" "\
$(0LYM$1e&i*RUV)v4n</^2(B\
$(0RH6j;Q$(1R_A`)&$(0<{$(1VKCiD}(B\
$(1!0FsZ^3]7`<BA#BQ^6ip(B\
$(1aec9(B")
(qdl "yu4" "\
$(0-@I3I`(j=D;R@RE|].Kc(B\
$(0Nl8IHVF{@pSXLY$(1H9$(0TH<:(B\
$(0_I_LTDXk5jE'3VF]-C;q(B\
$(0Oa2!74*XJJ$(1.~ATnV$(0-H$(1ov(B\
$(0V:$(1Mc$(06oM$Ko$(1<Z$(0S3$(1>I$(04o$(1F0(B\
$(1^lZ|[T[[e(<R6LX>R&b_(B\
$(1dm^ynN58\/U?06kF/j1E(B\
$(1f0'Kq{NQ//EeM=OeV3c}(B\
$(1g}r7rBJA9FLtSb[>(B")
(qdl "yuan1" "\
$(06C=]U<My.~$(11;G4hG$v[=(B\
$(1;`<{M<M~m?G$MuN,U{eI(B\
$(1i9(B")
(qdl "yuan2" "\
$(06Q&x6`EQERP?FdAO@j:1(B\
$(0G*2Q,lW`4<$(1VRa>B<ef(U(B\
$(0BL\Y$(11iYOS~%,S}#ZFlZ-(B\
$(12^'6K%DGBJ={DqJlMGd3(B\
$(1j0k7(B")
(qdl "yuan3" "\
$(0M@$(1&5(B")
(qdl "yuan4" "\
$(0:b[L3-5GM@@j$(1D|$(0Jh$(1<+T6(B\
$(1!Q_ZLLVJ(B")
(qdl "yue1" "\
$(04}'L$(1VLRf=e(B")
(qdl "yue4" "\
$(0'MD>O@7RQfGn]1/+UX\/(B\
$(0_-XLZo$(1H=$(0M*)I$(1i5$(0^A$(1WOkj(B\
$(1(DmglD$(0:I$(1qSaC(!$(00w$(1!]'X(B\
$(1A>$42nl/r6(B")
(qdl "yun1" "\
$(0F@K<$(1YAg8ISZ1(B")
(qdl "yun2" "\
$(0Dy&j'%/~9U1I9K$(1Kf$(0Gi$(1DM(B\
$(1Qb,=Y,$OKdUMYh#S!sY@(B\
$(18bH0'E,D(B")
(qdl "yun3" "\
$(0&yIT$(1K0$fdEZ=$+ZaNOA=(B\
$(1%1(B")
(qdl "yun4" "\
$(0I+[J(FOa\9F"Wj$(1;e$(0F@$(1gr(B\
$(1@v^a'BRmk*$(06`(B")
(qdl "z" "\
$(0%)(B")
(qdl "za1" "\
$(0>U(#$(1%`3wI7'"HL(B")
(qdl "za2" "\
$(0Yd2H9":s$(1p]]t(B")
(qdl "zai1" "\
$(0-%8(2;$(1=5Zc(B")
(qdl "zai3" "\
$(0'k7%$(1;L$(0I&$(1Y9(B")
(qdl "zai4" "\
$(0)d)CI&(B")
(qdl "zan1" "\
$(0Xy$(1j>(B")
(qdl "zan2" "\
$(02H:s$(1Rk(B")
(qdl "zan3" "\
$(1*amS4u*wpG:YkP<,pE(B")
(qdl "zan4" "\
$(0[&O2_5[B^=$(1o1n7r"m[mI(B\
$(1q`(B")
(qdl "zang1" "\
$(0^)]/^E$(10a$(0LW(B")
(qdl "zang3" "\
$(1Ut(B")
(qdl "zang4" "\
$(0Y/]qH66r(B")
(qdl "zao1" "\
$(0QNVa$(1clA](B")
(qdl "zao2" "\
$(0_E(B")
(qdl "zao3" "\
$(0*/AmS*\2:*$(1]Wf@(B")
(qdl "zao4" "\
$(0?`-1V6RB$(1J:$(0\C-#\H$(1$rj&(B\
$(1bB(B")
(qdl "ze2" "\
$(02-?KRfS,J29;$(18[$(0.T$(1Iy$(0>N(B\
$(1ca-W;MFhcWfo$(0Hq$(1fs(B")
(qdl "ze3" "\
$(03,(B")
(qdl "ze4" "\
$(0&w;"$(1',![>`(B")
(qdl "zei2" "\
$(0Hq(B")
(qdl "zen3" "\
$(03,(B")
(qdl "zen4" "\
$(1g+(B")
(qdl "zeng1" "\
$(0AeNANp$(1^P$(0Y%$(1]oWL]pnJXQ(B")
(qdl "zeng4" "\
$(0[%$(1]](B")
(qdl "zh" "\
$(0%%(B")
(qdl "zha1" "\
$(0B5'E@L$(1CZ$(03h$(1qW++X`&|*c(B\
$(1Q"cO(B")
(qdl "zha2" "\
$(0'E(_>UIQ49$(1UW`".9Lc91(B\
$(1g2qw(B")
(qdl "zha3" "\
$(08|B5$(1\(#7-<(B")
(qdl "zha4" "\
$(0K(3a49D*'fF,?2.T$(1Me$(0)^(B\
$(1D3$(09)$(1_v\(1*^-(B")
(qdl "zhai1" "\
$(0JsX:M}$(1/J(B")
(qdl "zhai2" "\
$(0)xLL(B")
(qdl "zhai3" "\
$(09;$(1&J(B")
(qdl "zhai4" "\
$(0E-JT>C?K$(1X]7](B")
(qdl "zhan1" "\
$(0Hj0KXnV"Tv$(1/S$(0\D$(1pf@8_n(B\
$(1/mpnoc$(0(($(1%blfHA@A^xi|(B")
(qdl "zhan3" "\
$(07/<~GAW^$(1C1$(0JZ$(1>&peU(O6(B\
$(1WXb@_gP%K(W](B")
(qdl "zhan4" "\
$(0*}R^9=O2((Ar^%B7L6$(1cr(B\
$(0^F$(1Z&gGTt3R(B")
(qdl "zhang1" "\
$(0<0?~JeK=O6OgKd$(1ITPoNR(B\
$(0W8$(1nYJ.AZIIloT|(B")
(qdl "zhang3" "\
$(01\A@KN$(1!4`N(B")
(qdl "zhang4" "\
$(0&8'n<)MbQ.CO,]KNJ\SK(B\
$(1Ij"JXi,j(B")
(qdl "zhao1" "\
$(0Ah/^3P(/CbN4:^$(1UyH@$(07t(B\
$(1,B`7&1(B")
(qdl "zhao2" "\
$(0Cb(B")
(qdl "zhao3" "\
$(0,G0L'X$(1?mKy(B")
(qdl "zhao4" "\
$(0FzM8(/Gv)?LOD(7t$(11h$(0XS(B\
$(04;$(1O',($(0As$(1L^hS)W<DWG(B")
(qdl "zhe1" "\
$(0QLW<$(15qI`(B")
(qdl "zhe2" "\
$(0,L6ZJx\lWBYBM<JsYM$(1J6(B\
$(0HE$(1RP!(oR5qds$t56,Vc[(B\
$(1-Ipqq>f#(B")
(qdl "zhe3" "\
$(010Q5$(1[0(B")
(qdl "zhe4" "\
$(0?V8CPR^/$(1+&$(0)x$(1](0T_)(B")
(qdl "zhe5" "\
$(0CbQL$(15qI`(B")
(qdl "zhen1" "\
$(08z:]4G5X;!K}F;P09!Kj(B\
$(0S{FPK.D-$(1MADvD4L6-)`!(B\
$(1qk;2UzbwRZWbQaDxH*;;(B\
$(1MH_liUm(:w(B")
(qdl "zhen3" "\
$(0D-0)8q$(1@n1%9D$(0So$(1R\82jw(B\
$(118nwgJ&z$*1jF*>YCNYI(B\
$(1\@(B")
(qdl "zhen4" "\
$(0YY:c7ZQiM57w0)R)$(1<&9w(B\
$(17L$(06{$(1)#*X/]G,5wN4Pf(B")
(qdl "zheng1" "\
$(00i/=LfGKNb<hL/(`/F={(B\
$(0Ti;|Q#[|$(1H:0QY/&/+t4M(B\
$(18G$(0&$$(113(B")
(qdl "zheng3" "\
$(0Rm3D$(1!`P\(J(B")
(qdl "zheng4" "\
$(0QQ(`Z}3JD&8l<h@|(B")
(qdl "zhi1" "\
$(0&g1":jX~'F0/(e(8+V1?(B\
$(09\13Ls4m=>92'U$(1+/$(0%%54(B\
$(1\:$(0(*$(1C,,_@[$(00`$(1V4$\1VJk(B\
$(1,{3!<}(B")
(qdl "zhi2" "\
$(01!Y*Q36-Ay;[B&XE2b$(1%<(B\
$(1cg_6$(0]x$(1/k46Ea$(0J|$(1^K+3=p(B\
$(17ka^OBPEWIYTa[c;@5E'(B\
$(1P&mw(B")
(qdl "zhi3" "\
$(0(83A9M'P*0+`Nb4m?R4k(B\
$(02G$(1+/H5*I$U%0$(01M$(1AV@f1)(B\
$(1/V#6#Jfh/u6gD>(B")
(qdl "zhi4" "\
$(0*^.20Z,6L|55GuAb99M#(B\
$(0G`Q32rP:NWKJNx>E0g>/(B\
$(0IWZ|$(1\p$(0BpI($(1jr&Q3J$(01"$(1BP(B\
$(1#{/k$(0]yCt$(1cbnp%[o[%%*8(B\
$(1;Z7*7@L#8/g%-]Nh3cGr(B\
$(1TzUDee9?ln6Y0hiN21S)(B\
$(1_>*[+dN/*9\9-U8??<[p(B\
$(11PGJ\4(B")
(qdl "zhong1" "\
$(0&d\M>]/AWt:0,;4\$(1_<!p(B\
$(1#XSd+CDg#t26'yo>(B")
(qdl "zhong3" "\
$(0L"H(EWTQ6E(B")
(qdl "zhong4" "\
$(0&dL"5n)5>9$(1;>$(0BM$(1$e2v3`(B\
$(1:sRz(B")
(qdl "zhou1" "\
$(0.SDO)}3{*bC7$(1TU$(0;M$(1]fl>(B\
$(1H$:\dea0+_6iNr0|55Tw(B\
$(1%F4_(B")
(qdl "zhou2" "\
$(0DJ.r(B")
(qdl "zhou3" "\
$(0/--=$(1EJh9(B")
(qdl "zhou4" "\
$(0=%Ot.}4xSq2%.J$(1^FL!$(0Z^(B\
$(1)E3DOZ&f$(05-$(1VMUu(B")
(qdl "zhu1" "\
$(08b*8Pz8.Q)Cv:#>?HeMT(B\
$(0-~$(1+[b$-^eceZ7b$(0Zp$(1?!@/(B\
$(1T=a,l0Maa"f^(B")
(qdl "zhu2" "\
$(0*MSa?]V7$(1fp$(0C51+([\I$(18Y(B\
$(0DJ$(11]SM,e@Vn_p=qu2?Y0(B")
(qdl "zhu3" "\
$(0'e\iBU^^D2=`_4Cb$(1\;$(0/Y(B\
$(1E1q"1D:-p7)a1~q#'g11(B")
(qdl "zhu4" "\
$(0*oCb+80D91QxD"3[?,]|(B\
$(1+o$(057*pL00:$(18(M(!S+089(B\
$(1Ho1'8|H78*;V@X@qQ7\<(B\
$(1am+JTD(B")
(qdl "zhua1" "\
$(0,ORl$(1`s]'(B")
(qdl "zhua3" "\
$(0'X(B")
(qdl "zhuai1" "\
$(03@(B")
(qdl "zhuai3" "\
$(1Gu(B")
(qdl "zhuai4" "\
$(03@(B")
(qdl "zhuan1" "\
$(0;rSU5'Yq$(1I@NVn\AmIVR4(B\
$(1^+ngS+c2(B")
(qdl "zhuan3" "\
$(0YL\f(B")
(qdl "zhuan4" "\
$(0E/WSP1N~$(1g,jf$(0I}$(1D{^@FD(B")
(qdl "zhuang1" "\
$(0HS>~O8+j$(1"=63(B")
(qdl "zhuang3" "\
$(06r(B")
(qdl "zhuang4" "\
$(00n+hNz$(1r+6}(B")
(qdl "zhui1" "\
$(0:RTjA{1d$(1dchZFHa6(B")
(qdl "zhui3" "\
$(1'e(B")
(qdl "zhui4" "\
$(0L=NCYD$(1YD$(0A5$(1[iL:M0nA(B")
(qdl "zhun1" "\
$(0Pw';16$(1,a(p#]9N(B")
(qdl "zhun3" "\
$(0Fn6H$(13K41Lk(B")
(qdl "zhun4" "\
$(1Ed(B")
(qdl "zhuo1" "\
$(07_8&=mAs$(1]}(B")
(qdl "zhuo2" "\
$(0.85DS-/hV*:[-$Cb;<];(B\
$(0UlBa$(1TC-uPj<C6$<]=`Mh(B\
$(1Tjnn"@"_$(03L$(1RUY%09<_cV(B\
$(1[44$F4\{iu"+.0i1(B")
(qdl "zi1" "\
$(0Hr9|BF+V2]29+wT?Hu8^(B\
$(0%)QH=j]ULG@l$(1>m$(0U4$(1;A?i(B\
$(1_yk;\C"4X'(5H/h>$(0To$(1Gf(B\
$(1<iO$hXhh/v1v5%7jfi(B")
(qdl "zi2" "\
$(0&N(B")
(qdl "zi3" "\
$(0&N'kC<=14wFa$(1,v$(0Hl$(17{1U(B\
$(1-(2H"&$F%!)K(B:(GQ(B")
(qdl "zi4" "\
$(0*])t7EKE$(17T$(0@l$(1.+?0?/$0(B\
$(1-s0b(B")
(qdl "zong1" "\
$(0.yYHVlL8AjYz$(1c]h,h5S#(B\
$(1Q{-{;m=}LPS4;HT!(B")
(qdl "zong3" "\
$(0Vk$(1JT$(0E5$(1QzFCMW(B")
(qdl "zong4" "\
$(0VlL4L8<8$(1X^*z(B")
(qdl "zou1" "\
$(0I:$(1_P$(0Wh$(1T?$(0;M$(15U?O$(0?z$(1jnh7(B\
$(1<jLr<Y9oBBhcp1qZ(B")
(qdl "zou3" "\
$(0-M(B")
(qdl "zou4" "\
$(02X^vAF(B")
(qdl "zu1" "\
$(097$(1MO(B")
(qdl "zu2" "\
$(0-N=!.6J'$(15O5&Zr.?AiTa(B")
(qdl "zu3" "\
$(0>[9/1a1~D)$(1,4O/(B")
(qdl "zuan1" "\
$(0_>$(1qa(B")
(qdl "zuan3" "\
$(0\-_>$(1q1q.kP(B")
(qdl "zuan4" "\
$(0WS_>$(1o.r"(B")
(qdl "zui1" "\
$(0;U$(13tF7IrpI(B")
(qdl "zui3" "\
$(0N6$(1b4GKIq\T]G(B")
(qdl "zui4" "\
$(0@3GwQU$(1]*$(0T*$(1<G]684E][A(B\
$(1OyVm(B")
(qdl "zun1" "\
$(0@rTXRt$(1Osj;P/b[orO|(B")
(qdl "zun3" "\
$(0O+$(1OaOsHyg&(B")
(qdl "zun4" "\
$(01w)b$(1/DogNzX=(B")
(qdl "zuo2" "\
$(03U+#9)$(1<pEvEfFj(B")
(qdl "zuo3" "\
$(0(K*w$(1be(B")
(qdl "zuo4" "\
$(0:y+#+e7?$(1A($(093_E3k$(1&i-#(B\
$(1({G%.\(B")
