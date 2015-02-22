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
;;	Original table is from cxterm/dict/tit/CTCPS3.tit.
;; 92.6.24  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	To cope with new version of quail.

;; # HANZI input table for cxterm
;; # To be used by cxterm, convert me to .cit format first
;; # .cit version 1
;; ENCODE:	GB
;; MULTICHOICE:	YES
;; PROMPT:	$A::WVJdHk!KTASoW"Rt!K(B 
;; #
;; COMMENT $ATASoW"Rt(B CPS3 $A7=08(B
;; COMMENT		By Fung-Fung Lee ($A@n7c7e(B) <lee@milo.stanford.edu>,
;; COMMENT
;; COMMENT	Permission for the use and redistribution is granted by the author
;; COMMENT	as long as it is freely distributed for non-commerical purposes.
;; # define keys
;; VALIDINPUTKEY:	abcdefghijklmnopqrstuvwxyz
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
;; # the following line must not be removed
;; BEGINDICTIONARY
;; #

(require 'quail)

(quail-define-package 
 "ctcps3" "$ATASoW"Rt(B" nil
 "$ATASoW"Rt(B CPS3 $A7=08(B   By Fung-Fung Lee ($A@n7c7e(B) <lee@milo.stanford.edu>"
 *quail-mode-rich-map* nil nil nil nil t)

(defmacro qdl (key str)
  (list 'quail-defrule key (list 'string-to-char-list str)))

(qdl "a" "\
$A0"0!Q;Q=Q>QFQG_9k2o9(B")
(qdl "aai" "\
$A0#0$`I0%0&0/`H(B")
(qdl "aan" "\
$AjL03(B")
(qdl "aang" "\
$As?(B")
(qdl "aap" "\
$AQ<(B")
(qdl "aat" "\
$AQ9Q:(B")
(qdl "aau" "\
$A^V(B")
(qdl "ak" "\
$ANU6s6rv;(B")
(qdl "am" "\
$A05ZOwv(B")
(qdl "ang" "\
$A]:(B")
(qdl "au" "\
$AE7E8E9E;E=(B")
(qdl "ba" "\
$A0Q0M0E0H0I0J0L0P0S0T(B\
$A0U0V]bnYtN(B")
(qdl "baai" "\
$AEH0Z0\0]0^_B(B")
(qdl "baak" "\
$A0W0Y2.0[2/FH27(B")
(qdl "baan" "\
$A0l0`0_0d0e0f0gZf[`c](B\
$At2y"(B")
(qdl "baang" "\
$A1A1D(B")
(qdl "baat" "\
$A0K0F(B")
(qdl "baau" "\
$A0|0z0{1%1+1,v5(B")
(qdl "bai" "\
$A1R1U1M1N1P1V1W1](B")
(qdl "bak" "\
$A11(B")
(qdl "bam" "\
$A1CER(B")
(qdl "ban" "\
$A1v1?1r1s1u1w1<F7YwYO(B\
$AfIikkwo<oY(B")
(qdl "bang" "\
$A1@`T(B")
(qdl "bat" "\
$A2;1O1J0N0O_YevnP(B")
(qdl "be" "\
$AF!(B")
(qdl "bei" "\
$A1;1/181H1Gn/F"1.1019(B\
$A1K1Q1S1T1[1\CXCZE~X0(B\
$AYB`N_Ae~(B")
(qdl "beng" "\
$A1z1}2!(B")
(qdl "bik" "\
$A1F1L1ZtE(B")
(qdl "bin" "\
$AXR1b1c1d1_1a1e1f1g1h(B\
$A1^cjq9(B")
(qdl "bing" "\
$A2"1x1y1{1|1~1E(B")
(qdl "bit" "\
$A1p1n1o1q1Xni(B")
(qdl "biu" "\
$A1m1j1kf;opoZ(B")
(qdl "bo" "\
$A2#2$2%2(FB[6`#(B")
(qdl "bok" "\
$A252+2)2,2-2022241]1"(B\
$A8?(B")
(qdl "bong" "\
$A0n0o0p0q0s0u0w(B")
(qdl "bou" "\
$A281#2?2<1(292=1)0}26(B\
$A2>2@1$1&FRFXlRp1(B")
(qdl "bui" "\
$A131-121415171:(B")
(qdl "buk" "\
$A27FY_2nGFM(B")
(qdl "bun" "\
$A0k1>0cEO0a0i0m1=EQEV(B")
(qdl "bung" "\
$A1B(B")
(qdl "but" "\
$A2'c#212&2*23XC(B")
(qdl "cha" "\
$Aoo2i2n2f2g2h2k2m2oNN(B\
$AT{w~(B")
(qdl "chaai" "\
$A2B2H2q2rY-nN(B")
(qdl "chaak" "\
$A2b2_2a2pTtb|(B")
(qdl "chaam" "\
$A2N2O2Q2R2s2t2v2wI<wu(B")
(qdl "chaan" "\
$A2y2z2M2P2StS(B")
(qdl "chaang" "\
$A3E3H(B")
(qdl "chaap" "\
$A2e(B")
(qdl "chaat" "\
$A2l2AL!K"`'`j(B")
(qdl "chaau" "\
$A3-3.323334qi(B")
(qdl "chai" "\
$AF`FkF\F^FvYQ]B_b(B")
(qdl "cham" "\
$AQ03AGVG^G_Z__Dd1v`(B")
(qdl "chan" "\
$A3B3>3C3DGWUnUo_Sv3(B")
(qdl "chang" "\
$A2cTx(B")
(qdl "chap" "\
$A<)<-(B")
(qdl "chat" "\
$AF_FaFb(B")
(qdl "chau" "\
$AGo3i3j3k3l3m3o3q3r3s(B\
$A3t4UGtGvGBPaY1t\(B")
(qdl "che" "\
$A35GR366_I]P0P1(B")
(qdl "chek" "\
$A3_(B")
(qdl "cheng" "\
$AGk(B")
(qdl "cheuk" "\
$A4A4BIVIWW?W@WFY>ey(B")
(qdl "cheung" "\
$AG=Oj403$3!Oi2}2~3&3)(B\
$A3*3+G9G:G>G@Ohc^f=(B")
(qdl "chi" "\
$A3U3X4J4L4NKFJ<2^4K3Y(B\
$AJA3a3]3c4C4D4E4F4G4H(B\
$A4I4M3V3W3Z3[3\3^FjJ8(B\
$AJQVD_j`4`M_Zekf&ltr?(B\
$AtYuX(B")
(qdl "chik" "\
$AF]3`3b`R_3k7(B")
(qdl "chim" "\
$AG)G1G5YTe_o7(B")
(qdl "chin" "\
$AG'G.OK=&G0G32x2{2|<_(B\
$AG$G%G(G*Zd(B")
(qdl "ching" "\
$A3N3FGi3LGk3J3M3Q3S5I(B\
$AG`GeGgGhU|r_(B")
(qdl "chip" "\
$Af*(B")
(qdl "chit" "\
$AGP37393:FcIhU^(B")
(qdl "chiu" "\
$A3/3,31=8GDGFGMGNLvP$(B\
$AUQnH(B")
(qdl "cho" "\
$Ao14l3u3z3{3~4!4h4j4m(B\
$A[;(B")
(qdl "choi" "\
$A2G2J2E2F2C2D2I2K2LH|(B\
$ATTH{(B")
(qdl "chong" "\
$A42442X2V2T2U2W4/433'(B\
$A3(Xw(B")
(qdl "chou" "\
$A2]2Y2Z2[2\4V4W4kThTj(B\
$ATkTo`Pa^ick}t=(B")
(qdl "chu" "\
$A4&3w3x3y4"JoJpVyV|Xy(B\
$Aui(B")
(qdl "chuen" "\
$A4e4f4+H+4'4(4)4-4.4Z(B\
$A4\4gH)H*H,K(K)MD\uk0(B\
$AnKn}oi(B")
(qdl "chui" "\
$AH!45KeKf3}3|4647484](B\
$A4^4_4`4d4iGwH"H$Pl_}(B")
(qdl "chuk" "\
$A4Y4#4$JxKYPnPsX!v:(B")
(qdl "chun" "\
$A4:4;4@GXQ-Q.Q2(B")
(qdl "chung" "\
$AVX3d4S3e3f3h4O4P4Q4R(B\
$A4TKIVTZ#o%(B")
(qdl "chut" "\
$A3vwmwq(B")
(qdl "da" "\
$A4r(B")
(qdl "daai" "\
$A4s4x4u4w4t(B")
(qdl "daam" "\
$A`"5"5#5(5*5-YYqu(B")
(qdl "daan" "\
$A5+5%5$5&5'5)5,5.5/50(B\
$Ancw0(B")
(qdl "daap" "\
$A4pL$4n4qm3(B")
(qdl "daat" "\
$A4oL"`*sNw2(B")
(qdl "dai" "\
$A5]5ZA%5W4~5M5V5[5\X5(B\
$AtF(B")
(qdl "dak" "\
$A5B5CLXo=(B")
(qdl "dang" "\
$A5H5E5F5G5J5K`bj-ok(B")
(qdl "dat" "\
$AM9M;(B")
(qdl "dau" "\
$A69676665686:6;>@nWr=(B\
$Aq<(B")
(qdl "de" "\
$A5y`G(B")
(qdl "dei" "\
$A5X(B")
(qdl "dek" "\
$A5Q(B")
(qdl "deng" "\
$A6"6$p[(B")
(qdl "deuk" "\
$AWAWD(B")
(qdl "der" "\
$A6d(B")
(qdl "dik" "\
$A5D5N5O5P5R5S5U`Voa(B")
(qdl "dim" "\
$A5c5`5j(B")
(qdl "din" "\
$A5g5d5b5e5f5i5l5m5n5_(B\
$Aa[ndq2(B")
(qdl "ding" "\
$A6&6(6)6!6#6%6'M]Xjqt(B\
$Atz(B")
(qdl "dip" "\
$A5z5{5}5~`)k:(B")
(qdl "dit" "\
$A5x5|VHis(B")
(qdl "diu" "\
$A5u5q5t5w5o5p5r5s5v6*(B\
$Anvn{uu(B")
(qdl "do" "\
$A6`6b6c6d6e6g6h6i_a(B")
(qdl "doi" "\
$A4z4}4|a7wl(B")
(qdl "dok" "\
$Anlub(B")
(qdl "dong" "\
$A5451525355nu(B")
(qdl "dou" "\
$A565@5=6H6<6B6C6D6E6F(B\
$A6I6J57595:5<5>5?5A`=(B\
$Ak.(B")
(qdl "duen" "\
$A6L6M6N6O6K6P(B")
(qdl "duet" "\
$A6a(B")
(qdl "dui" "\
$A6T6Q6R6S(B")
(qdl "duk" "\
$A6@6=6>6?6Ak9sFwr(B")
(qdl "dun" "\
$A6X6Y6U6V6[6](B")
(qdl "dung" "\
$A6/6+6.416,6-60616263(B\
$A64_Kk1(B")
(qdl "fa" "\
$A;(;/(B")
(qdl "faai" "\
$A?l?i?j?~_`(B")
(qdl "faan" "\
$A7:7174hs7672787*0j7+(B\
$A7,7-7.7/7073757779^,(B")
(qdl "faat" "\
$A7"7(7)(B")
(qdl "fai" "\
$A;S;U7Q7M7N7O7P;TjMoP(B")
(qdl "fan" "\
$A7]7V7\7`7R7S7T7U7W7X(B\
$A7Y7Z7[7^7_;g;h;iQ,Q5(B\
$AYG^9ww(B")
(qdl "fat" "\
$A7p:v7w7z8%7#7$7%7&7'(B\
$A_|eu(B")
(qdl "fau" "\
$A7q2:8!8"87FJs>(B")
(qdl "fe" "\
$A7H(B")
(qdl "fei" "\
$A7I7Gkh7F7J7K7LdGezl3(B\
$Arctdv-(B")
(qdl "fo" "\
$A?F;u;p;o?NnXrr(B")
(qdl "fok" "\
$A;t>p(B")
(qdl "fong" "\
$A7B?v7=7E7;7<7>7?7@7A(B\
$A7C7D;D;E;N;O;P;Qa]hJ(B\
$AkAnUt3(B")
(qdl "fu" "\
$A7r:tfZ888;8(7{8*7t81(B\
$A7s7u7v7}8&8'8)8+8-8.(B\
$A8/808385868:8<8=8>8@(B\
$A:u;";#?`?b?c?]XZ\=\^(B\
$A_;fbw<(B")
(qdl "fui" "\
$A;Z;e;R;V;^?|?}Z6`-`9(B")
(qdl "fuk" "\
$A847~8#7x7y7|8$8289Yk(B\
$Ap%rp(B")
(qdl "fun" "\
$A;6?m?n(B")
(qdl "fung" "\
$A7g7l7a7b7c7d7e7f7h7i(B\
$A7j7k7m7n7oY:_t(B")
(qdl "fut" "\
$A@+(B")
(qdl "ga" "\
$A<\<Y<[<S<^8A8B<N<O<R(B\
$A<V<Z<]oXtB(B")
(qdl "gaai" "\
$A=b=i=W=g=V<Q=d=f=j=k(B\
$A=l=T=UYI^N`.(B")
(qdl "gaak" "\
$A8o8q8l8tX*`CkuoSw@(B")
(qdl "gaam" "\
$A<u<`<x^OvN(B")
(qdl "gaan" "\
$A<i<d<r<h<k<m<n<o<p<q(B\
$A='ZIo5(B")
(qdl "gaang" "\
$A8{(B")
(qdl "gaap" "\
$A<W<P<T<U<XkNnr(B")
(qdl "gaau" "\
$A=L=O=;8c=:=<=A=B=F=H(B\
$A=J=QY.p(rTuS(B")
(qdl "gai" "\
$A<F<L<&<;YJ(B")
(qdl "gam" "\
$A=p=q8P8J8L8R<j=u={`d(B")
(qdl "gan" "\
$A=|=t8z8y=m=n=o=v=w=y(B\
$A]@_gt^(B")
(qdl "gang" "\
$A9#8|8}8~9]9">,_l(B")
(qdl "gap" "\
$A8k8r<1(B")
(qdl "gat" "\
$A8m<*=[Y%(B")
(qdl "gau" "\
$A>?>I>E9;969798>A>B>C(B\
$A>D>G>H>L>N?Yw|(B")
(qdl "gei" "\
$Ay:<8<G;z;y<H<M<<;~<!(B\
$A<"<%<'<:<?<D<I<KX^_4(B\
$Ah=g\wd(B")
(qdl "geng" "\
$A>5>1(B")
(qdl "geuk" "\
$A=E(B")
(qdl "geung" "\
$A=)=*=.G<t](B")
(qdl "gik" "\
$A<,<$<+;wX=ijj*(B")
(qdl "gim" "\
$A=#<l<f<s(B")
(qdl "gin" "\
$A=!<{<~=(<a<g<|=]kl(B")
(qdl "ging" "\
$A>6>9>#>->)>3>0>">$>%(B\
$A>*>/>4>7>:XYYSqf(B")
(qdl "gip" "\
$A=Y(B")
(qdl "git" "\
$A=a=`=\hn(B")
(qdl "giu" "\
$A=>=P=?=C=Ik8(B")
(qdl "go" "\
$A8h8v8g(B")
(qdl "goi" "\
$A8C8D(B")
(qdl "gok" "\
$A>u8w8i8s=Gge(B")
(qdl "gon" "\
$A8I8K8M8N8O8QG,(B")
(qdl "gong" "\
$A=-8[8T8U8V8W8X8Y8Z8\(B\
$A=2=5?8qp(B")
(qdl "got" "\
$A8n8p:V(B")
(qdl "gou" "\
$A8_8e8f8]8^8`8a8b8dR$(B\
$AX:Z>(B")
(qdl "gu" "\
$A9E9A9L9I9B9J9<9=9>9@(B\
$A9C9D9F9K9Mn\p3o@(B")
(qdl "guen" "\
$A>h>i>j>k>l>m>nH/Q+d8(B")
(qdl "gui" "\
$A>_>]>d>Y>e>S>X>^>a>b(B\
$A>fYFe}l+q@(B")
(qdl "guk" "\
$A>V>U9H>O`7o8(B")
(qdl "gun" "\
$A9\9Z9[9Y9`9a9W9]9^NS(B\
$AYD]8pY(B")
(qdl "gung" "\
$A9&9$9+929'8S9%9(9)9*(B\
$A9,9-9.9091r<(B")
(qdl "gwa" "\
$A9O9R9P9QXT_I(B")
(qdl "gwaai" "\
$A9T9U9V(B")
(qdl "gwaan" "\
$A9X9_(B")
(qdl "gwaang" "\
$A9d(B")
(qdl "gwaat" "\
$A9N@((B")
(qdl "gwai" "\
$A9q<>9e9g9h9i9j9k9l9m(B\
$A9n9p9r9s<B?y@!XPXQX[(B\
$Ap'(B")
(qdl "gwan" "\
$A>}>|>y9v9w>{?$Yrs^(B")
(qdl "gwang" "\
$A:d(B")
(qdl "gwat" "\
$A9G>r?_w;(B")
(qdl "gwing" "\
$A><(B")
(qdl "gwo" "\
$A9}9{8j9|?C?Eo>(B")
(qdl "gwok" "\
$A9y9z@*(B")
(qdl "gwong" "\
$A9c9b(B")
(qdl "ha" "\
$AODOB9~O:O<O>OCeZh&n~(B")
(qdl "haai" "\
$AP3:!:"?+P,P5P7P8eb(B")
(qdl "haak" "\
$A?MOE(B")
(qdl "haam" "\
$AONOL:-:/:0OZ(B")
(qdl "haan" "\
$AO^OPf5(B")
(qdl "haang" "\
$A:;?SPP(B")
(qdl "haap" "\
$AF~O?OA`>_H(B")
(qdl "haau" "\
$AP'GCP#?<:p=M?=?>GIOx(B\
$AP"f/(B")
(qdl "hai" "\
$AO5Yb^Ilyw{(B")
(qdl "hak" "\
$A?L:U:Z?&?Kk4(B")
(qdl "ham" "\
$A:6:,:(:):3?0?1?2?3G6(B\
$AO]r%(B")
(qdl "han" "\
$A:\:[:]:^?Q?R(B")
(qdl "hang" "\
$APRPP:_:`:b:c?O?PPSo,(B")
(qdl "hap" "\
$AO@:O:PG]G"O;qkr"(B")
(qdl "hat" "\
$A:KFrO9O=[@(B")
(qdl "hau" "\
$A?Z:saa:r:m:n:o:qeKtW(B\
$AvW(B")
(qdl "hei" "\
$AFxFp_qO#O2F{:YF[FqFw(B\
$AFzNuN{N~O]O)O7YRfRjX(B\
$Aldl{tK(B")
(qdl "hek" "\
$A3T(B")
(qdl "her" "\
$AQ%(B")
(qdl "heung" "\
$AOrOlOmOcINOgbC(B")
(qdl "him" "\
$AOUG+G7(B")
(qdl "hin" "\
$AG#OWOTG2G4PyOFOGO\Q\(B\
$Allr9OK(B")
(qdl "hing" "\
$APKGaGbGdGlPV\0s@(B")
(qdl "hip" "\
$AG8GSP-P.P2(B")
(qdl "hit" "\
$AP*(B")
(qdl "hiu" "\
$A===DGAGOOyO~_Xfg(B")
(qdl "ho" "\
$A:N:I?I:S:G:J:X?@`@t4(B")
(qdl "hoi" "\
$A:&?*:#:$:%:'?-X\`Knx(B\
$Ao4r$(B")
(qdl "hok" "\
$AQ':W?G(B")
(qdl "hon" "\
$A:.::?4:9?/:*:+:1:2:4(B\
$A:5:7:8Y)e+q|w}(B")
(qdl "hong" "\
$A?5:=PP:<?o?p?t?6?7?T(B\
$AG;OnOo_Qq~(B")
(qdl "hot" "\
$A?J:H(B")
(qdl "hou" "\
$A:E:F:C:>:?:@:A:D`F`c(B\
$Aj;p)r+wR(B")
(qdl "huen" "\
$APzH&H.H0Q$]f(B")
(qdl "huet" "\
$AQ*(B")
(qdl "hui" "\
$APiPmH%PjPfZ<hrlcq4(B")
(qdl "huk" "\
$A?a?^(B")
(qdl "hung" "\
$APZ:lP[?U?V:e:f:g:h:i(B\
$A9/?W?XPWPXPYP\PoYE(B")
(qdl "ja" "\
$A2jT[T|U%U&U'U(U)^j_e(B\
$A_8rF(B")
(qdl "jaai" "\
$AU+U.U/(B")
(qdl "jaak" "\
$ATpU,5TTqTsV@U*U-ZX_u(B\
$At7(B")
(qdl "jaam" "\
$AU>T]U6U8U:U?tX(B")
(qdl "jaan" "\
$AT^U5U;U@WkW+W,(B")
(qdl "jaang" "\
$AUuUvUxUy(B")
(qdl "jaap" "\
$AO0TS</O.U"U#_Fl*(B")
(qdl "jaat" "\
$ATzT}T~_n(B")
(qdl "jaau" "\
$AUR30VbVhUVW%W&(B")
(qdl "jai" "\
$AVF<C<7<@<A<JVMWPv+38(B")
(qdl "jak" "\
$ATr2`XF(B")
(qdl "jam" "\
$AUm=~TuUeUkZZp2(B")
(qdl "jan" "\
$AUrUfUqUdUpUs[Z`Ajb(B")
(qdl "jang" "\
$ATv2dI.TwTxTy`aa?o#o-(B\
$As](B")
(qdl "jap" "\
$AV-V4(B")
(qdl "jat" "\
$A<2<5V6VJVO(B")
(qdl "jau" "\
$AV^>FVg>MV[V]W_>>PdV\(B\
$AV_VcVdVeVfW`WaW^YV_z(B\
$A`1f{kP(B")
(qdl "je" "\
$AUbU_=h=cP;U`UaUZ`5i?(B\
$ApQ(B")
(qdl "jek" "\
$AV;<9VK_s(B")
(qdl "jeng" "\
$A>.>;V#Ze(B")
(qdl "jeuk" "\
$AWCWEH8>t=@H5lz(B")
(qdl "jeung" "\
$AUEOs=+=/UF3$=,=0=1=3(B\
$A=4OpOqUAUBUCUDUGUHUI(B\
$AUJUKULUMUNUOXvbjoOs/(B")
(qdl "ji" "\
$AWSWTWOWVV*VGV>V.WKWM(B\
$AWJVNV9V;V=VAKBKCKEKG(B\
$AKHV%V&V'V(V)V+V,V7V8(B\
$AV:V<V?VBVCVIVLWHWIWL(B\
$AWNWQZQY9\Ff"lklmlsoE(B\
$AqhqjtRv7(B")
(qdl "jik" "\
$A<(V0V/V1<.<4;}<#<E=e(B\
$ANyO&O+O/V2V3V5WUq6vj(B\
$AU](B")
(qdl "jim" "\
$A<b=%IDUhU0U2U3U4U<Z^(B")
(qdl "jin" "\
$AU9=&<c<e<t<v<y<z<}=$(B\
$ADhDkL:U1U7U=j'te(B")
(qdl "jing" "\
$AagU}>2V$U~U{>&>'>+>8(B\
$AUjUlUtUwUzV!V"lun[(B")
(qdl "jip" "\
$A=S`?_](B")
(qdl "jit" "\
$A=ZU[=X=]=^UcU\U](B")
(qdl "jiu" "\
$A=6=7=9=KUPUSUTUUUYXd(B\
$AZ/YU`]3/(B")
(qdl "jo" "\
$AWxVzWhWsWtWyY^_r(B")
(qdl "joi" "\
$ATZTYTUTVTWTXWRg^(B")
(qdl "jok" "\
$AWwTdWrWu(B")
(qdl "jong" "\
$AW42XT_T`TaW.W/W0W1W2(B\
$AW3j0(B")
(qdl "jou" "\
$ATgWiTlWvWfTbTcTeTfTi(B\
$ATmTnWb_plq(B")
(qdl "ju" "\
$AVwW!W"VxVnVmVjViVkVl(B\
$AVoVsVtV{V}W]W$Y*\of-(B\
$Anywf(B")
(qdl "juen" "\
$A4+W(W*6WT\WjWpWqW)_y(B\
$Ar'(B")
(qdl "juet" "\
$A>xW>6^W:WB`(`\_M(B")
(qdl "jui" "\
$AWnWmPr>W>Q>R>Z>[GyPp(B\
$AWgWlWoW5W6W7W8W9v4vB(B\
$ASl(B")
(qdl "juk" "\
$AWcWePxKW4%4XV`VaVpVq(B\
$AVrVuVvV~W#W=WG`Uf(om(B\
$Ao_t6sC(B")
(qdl "jun" "\
$A=x>!W<=r=z=}>~?]?"?#(B\
$A?%UiiWoTq8(B")
(qdl "jung" "\
$AVPVVVZW]WZW\VUKLKOKP(B\
$AVQVRVSVWVYWWWXWYW[YL(B\
$Aoqt)t1tU(B")
(qdl "jut" "\
$AWd(B")
(qdl "ka" "\
$A?(?'X{_G(B")
(qdl "kaai" "\
$A?,(B")
(qdl "kaat" "\
$A_R(B")
(qdl "kaau" "\
$A??nm(B")
(qdl "kai" "\
$AFu;|FtF}O*(B")
(qdl "kam" "\
$At@=sGYG\G]`_f!(B")
(qdl "kan" "\
$AGZG[(B")
(qdl "kap" "\
$A<0N|8x<3<6sE(B")
(qdl "kat" "\
$A?H(B")
(qdl "kau" "\
$A?[tC99Gs959:>J>K?\Gr(B\
$AY4_5fEp/r0(B")
(qdl "ke" "\
$AFoH3GQY$(B")
(qdl "kei" "\
$AFeFdFZFmFlFs;{<=FfFg(B\
$AFiFna*gwlwq}whw"(B")
(qdl "kek" "\
$A>g(B")
(qdl "keuk" "\
$AH4`e(B")
(qdl "keung" "\
$AG?ojtG(B")
(qdl "kim" "\
$AG-G/(B")
(qdl "kin" "\
$Ar/(B")
(qdl "king" "\
$AGc>(GfGjGmwt(B")
(qdl "kit" "\
$Ar!>o=R=_P+f]tIwo(B")
(qdl "kiu" "\
$A=NGEGGGHGKGLO-(B")
(qdl "ko" "\
$An](B")
(qdl "koi" "\
$A8E8G8F8H?.?DX$n'(B")
(qdl "kok" "\
$AH7:B:TH6[V(B")
(qdl "kong" "\
$A?9@)?q?s?:?;XxnV?u(B")
(qdl "ku" "\
$A9?(B")
(qdl "kuen" "\
$AH(;?H'H-(B")
(qdl "kuet" "\
$A>w>v>qH1H2XJXcZ\`Yf^(B\
$Aoc(B")
(qdl "kui" "\
$AGx>P>T>\>`>cG{G}G~X~(B\
$Aaia+lnvD(B")
(qdl "kuii" "\
$A9t;b;f;_?k@#kZqy(B")
(qdl "kuk" "\
$AGz(B")
(qdl "kung" "\
$AGnq7(B")
(qdl "kut" "\
$A@(;mqx(B")
(qdl "kwa" "\
$A?d9S?e?f?g?hY((B")
(qdl "kwaang" "\
$A?r(B")
(qdl "kwai" "\
$A9f9o?w?x?z?{@"P/X8aM(B\
$AeS(B")
(qdl "kwan" "\
$A@'9u>=>z@$@%@&H9H:o?(B")
(qdl "kwik" "\
$AO6k=(B")
(qdl "kwong" "\
$A?s?u(B")
(qdl "la" "\
$AsA@.@2X](B")
(qdl "laai" "\
$A@-@5(B")
(qdl "laam" "\
$A@6<w="@7@:@?@@@B@Dq\(B")
(qdl "laan" "\
$A@<@8@9@;@=@>@A@Cog(B")
(qdl "laang" "\
$A@d(B")
(qdl "laap" "\
$A@0@,@/(B")
(qdl "laat" "\
$A@1eepx(B")
(qdl "lai" "\
$A@}@v@g@h@q@s@w@xY3fj(B\
$AtOws(B")
(qdl "lak" "\
$A@U@_Xl`O(B")
(qdl "lam" "\
$AA]AUAVAXAYA\_x(B")
(qdl "lap" "\
$AA"0<A#sR(B")
(qdl "lat" "\
$AK&(B")
(qdl "lau" "\
$AB)B%AtAwAoApAqArAsAu(B\
$AAvAxB&B'B(B*YM`6froN(B\
$AoVqowC(B")
(qdl "le" "\
$A_V(B")
(qdl "lei" "\
$A@n@{@mA'@~@e@f@i@j@k(B\
$A@l@o@p@r@tBDA]A(Y5`,(B\
$Af2o.(B")
(qdl "lek" "\
$A_7(B")
(qdl "leng" "\
$Av&vl(B")
(qdl "leuk" "\
$ABTBS(B")
(qdl "leung" "\
$AA:A=A?A)A8A9A;A<A>AA(B\
$AAB(B")
(qdl "lik" "\
$AA&@zA$_?(B")
(qdl "lim" "\
$AA-A.A1A2A3ig(B")
(qdl "lin" "\
$AA,A/A6A7A+A0A4Dl(B")
(qdl "ling" "\
$AAbAlAmAiAc@b@cA`AaAd(B\
$AAeAfAgAhAjAkAn_Jqv(B")
(qdl "lip" "\
$AAT^[(B")
(qdl "lit" "\
$AAPAQARY}(B")
(qdl "liu" "\
$AAHAKACADAEAFAGAIALAM(B\
$AANAO`ZnI(B")
(qdl "lo" "\
$AB^?)B\B]B_B`BaBcAJY@(B\
$Ao](B")
(qdl "loi" "\
$A@4@3abqg(B")
(qdl "lok" "\
$A@VBd8u:Q@R@SBeBfBgK8(B\
$A@V(B")
(qdl "long" "\
$A@E@F@G@H@I@J@KA@`%rk(B")
(qdl "lou" "\
$AB7B6B,@O@L@M@N@P@Q@T(B\
$AB+B-B.B/B0B1B2B3B8B:(B\
$AB?_k``a@iVnnoepXplo)(B\
$Aqlt5vT(B")
(qdl "luen" "\
$AA*BMBNBOBPBRA5f.(B")
(qdl "luet" "\
$AAS(B")
(qdl "lui" "\
$ABB@o@`@[@a@Z@W@X@Y@\(B\
$A@]@^B@BABCBEBFBGBKBb(B\
$AYz`&le(B")
(qdl "luk" "\
$AB<B9AyB=B4B5B;B>BHBL(B")
(qdl "lun" "\
$ABXBQBUBVBWBYBZB[AWAZ(B\
$AA[A_j%wk(B")
(qdl "lung" "\
$AkJAzA{A|A}A~B!B"B#B$(B\
$AE*gg(B")
(qdl "lut" "\
$A@uBI@|BJm2(B")
(qdl "m" "\
$A_m(B")
(qdl "ma" "\
$ABiBhBmBkBjBlBnBoBp(B")
(qdl "maai" "\
$ABtBqBrBu(B")
(qdl "maan" "\
$AMrB}MmBxByB{B|B~C]w)(B")
(qdl "maang" "\
$AC$CLCMCOrlt;(B")
(qdl "maau" "\
$AD5C(C)C,C-C.C2(B")
(qdl "mai" "\
$ACPCQCTCUCW_d(B")
(qdl "mak" "\
$ABsBvD+D,D0]k_i(B")
(qdl "man" "\
$ANDNECqNJCrCtCuCvC%NC(B\
$ANFNGNIXXc}v)(B")
(qdl "mang" "\
$ACHCK(B")
(qdl "mat" "\
$ANoC[C\M`NpX?ZW(B")
(qdl "mau" "\
$AD3C3C}D1D2D6C/Y0(B")
(qdl "me" "\
$A_c(B")
(qdl "mei" "\
$AC@N4N2C<C>CBCDCRCSN"(B\
$AN6^1aRetf8pLoQt:tMv2(B\
$Awcwg(B")
(qdl "mi" "\
$A_d(B")
(qdl "mik" "\
$ACYci(B")
(qdl "min" "\
$ACfCbC`CaCcCdCeC^C_(B")
(qdl "ming" "\
$AC{CwC|CsCxCyCzZ$\xu$(B")
(qdl "mit" "\
$ACoCpsz(B")
(qdl "miu" "\
$ACnChCgCiCjCkClCmC*_w(B\
$AechCm5q:(B")
(qdl "mo" "\
$AC4waC~D"D%D&D'fVqrwb(B")
(qdl "mok" "\
$AD*0~D$D.D/D;C](B")
(qdl "mong" "\
$AC#M|MvC"C&C'MxM{M}Xh(B")
(qdl "mou" "\
$ANdN^D8NqD!D#D4D7D9D:(B\
$AD<D=C+C0C1NWN\N_NcNh(B\
$ANjNlNm_h_<e|pD(B")
(qdl "mui" "\
$AC6C5C7C8C9C:C=C?CACC(B\
$AwH(B")
(qdl "muk" "\
$AD>D?D@DADBXo\Ycenb(B")
(qdl "mun" "\
$ABzCGCEBwCFnMr)ug(B")
(qdl "mung" "\
$ACICJCNcBk|t?(B")
(qdl "mut" "\
$AD)C;D(D-\Tib(B")
(qdl "na" "\
$ADCDGDDDHE2oU(B")
(qdl "naai" "\
$ADJDKDL(B")
(qdl "naam" "\
$ADODP`+a0kn(B")
(qdl "naan" "\
$ADQ(B")
(qdl "naap" "\
$ADEDFDIZ+(B")
(qdl "naau" "\
$ADSDVDW_Nns(B")
(qdl "nai" "\
$AD`(B")
(qdl "nam" "\
$AZE(B")
(qdl "nang" "\
$AD\(B")
(qdl "nau" "\
$AE$E%E&P`f$fUqqt[(B")
(qdl "ne" "\
$ADX(B")
(qdl "nei" "\
$ADcDa6|6}D]DeDzCVl;lr(B\
$Anj(B")
(qdl "neung" "\
$ADo(B")
(qdl "ng" "\
$ANeNsN`NaNbNfNgNiNnNr(B\
$AXu`ErZwy(B")
(qdl "nga" "\
$AM_Q?Q@QAQCQEQHXsXt(B")
(qdl "ngaai" "\
$A0,QBQDXW^_(B")
(qdl "ngaak" "\
$A6n(B")
(qdl "ngaam" "\
$A0)QR(B")
(qdl "ngaan" "\
$AQcQUQ[(B")
(qdl "ngaang" "\
$AS2(B")
(qdl "ngaau" "\
$AO}R'X3kH(B")
(qdl "ngai" "\
$AN#0+D^D_N!N1N:RORURc(B\
$ARh_=t/t`(B")
(qdl "ngak" "\
$A_@(B")
(qdl "ngam" "\
$AbVpF(B")
(qdl "ngan" "\
$AHMRxv8(B")
(qdl "ngat" "\
$AFyRYX#Xn(B")
(qdl "ngau" "\
$AE#9394E:E<qn(B")
(qdl "ngit" "\
$ADv(B")
(qdl "ngo" "\
$ANRNT6j6k6l6m6o6p6vE6(B\
$Ao0(B")
(qdl "ngoi" "\
$A4tMb0-:R(B")
(qdl "ngok" "\
$A6uT@ZLoIr&@V(B")
(qdl "ngon" "\
$A06(B")
(qdl "ngong" "\
$A0:(B")
(qdl "ngou" "\
$A0A0=0>0?qz(B")
(qdl "ngung" "\
$ANM(B")
(qdl "ni" "\
$ADX(B")
(qdl "nik" "\
$A@yDdDg(B")
(qdl "nim" "\
$ADnDi(B")
(qdl "nin" "\
$ADj(B")
(qdl "ning" "\
$AD{D|D~E]E"Xz_Lqw(B")
(qdl "nip" "\
$ADmDsDtDwDxDyr((B")
(qdl "niu" "\
$ADqDrtA(B")
(qdl "no" "\
$AE3E4YP_v(B")
(qdl "noi" "\
$ADNDZDMDYhM(B")
(qdl "nok" "\
$AE5o;(B")
(qdl "nong" "\
$ADRH?`l(B")
(qdl "nou" "\
$AE,DTDUE+E-es(B")
(qdl "nuen" "\
$AD[E/(B")
(qdl "nui" "\
$AE.nO(B")
(qdl "nuk" "\
$At,(B")
(qdl "nung" "\
$AE'E(E)Y/_f(B")
(qdl "o" "\
$A?A?B`8`^f9ippb(B")
(qdl "oi" "\
$A0.0'0(0*fHoMv0(B")
(qdl "ok" "\
$A6qX,[Qc5(B")
(qdl "on" "\
$A020800010407o'(B")
(qdl "ong" "\
$A090;(B")
(qdl "ou" "\
$A0D0@0B0CNk(B")
(qdl "pa" "\
$AEB0G0RE?E@EChK(B")
(qdl "paai" "\
$AEEEFEIY=(B")
(qdl "paak" "\
$A0XFGFIE>EAEDgj(B")
(qdl "paan" "\
$A0bEJEN(B")
(qdl "paang" "\
$AEl0tEkEmEoEpErEt`X(B")
(qdl "paau" "\
$AEZEY1*EWEXE\E](B")
(qdl "pai" "\
$AEz(B")
(qdl "pan" "\
$A1tEgF5F6(B")
(qdl "pang" "\
$AF>Es(B")
(qdl "pat" "\
$AF%qb(B")
(qdl "pei" "\
$AF)F$1IExE{E}F#F&F(E^(B\
$AX'Xrf>hAnk(B")
(qdl "pek" "\
$AE|(B")
(qdl "pik" "\
$A1YEyF'q1(B")
(qdl "pin" "\
$A1i1`F*F+F,F-ry(B")
(qdl "ping" "\
$AF4F=EjF;3REiF8F9F:F<(B\
$AF?F@FAY7f0f3fi(B")
(qdl "pit" "\
$AF2F3X/k-(B")
(qdl "piu" "\
$AF11lF.F/F0Xb`QfNih(B")
(qdl "po" "\
$AFFFEFDXOn^p+uK(B")
(qdl "pok" "\
$AFKFS`[od(B")
(qdl "pong" "\
$AET0r0v0x0yESEUdhs&(B")
(qdl "pou" "\
$AFWFU1'8,FLFNFOFQFTFV(B\
$AE[Yid_oh(B")
(qdl "ppmm" "\
$AFEFEBhBh(B")
(qdl "pui" "\
$A16EdE`EaEbEcEeEfEwFP(B\
$AEGE_oBv,(B")
(qdl "puk" "\
$AFM(B")
(qdl "pun" "\
$AELEKEP0hEhEM(B")
(qdl "pung" "\
$AEnEqEuEv(B")
(qdl "put" "\
$AFCn`(B")
(qdl "sa" "\
$AHwI/I0I3I4K#X&Xm`DtD(B\
$Avh(B")
(qdl "saai" "\
$AI9acgtsB(B")
(qdl "saam" "\
$AH}H~I@nL(B")
(qdl "saan" "\
$AI=I"4[I]I:I>IGU$d}cE(B\
$Af)t.uG(B")
(qdl "saang" "\
$AJ!Iz(B")
(qdl "saap" "\
$A;xTQTRv.(B")
(qdl "saat" "\
$AHvHxI1I2I7o](B")
(qdl "saau" "\
$AGJIRISITIZt9(B")
(qdl "sai" "\
$AO8NwJFJ@JDJEJII8NxPv(B\
$AO,O4tQ(B")
(qdl "sak" "\
$AH{`g(B")
(qdl "sam" "\
$APDIuIrIs3;3@InItIxJ2(B\
$AI-a/(B")
(qdl "san" "\
$AIqPBIm3?Ij3<3=IiIkIl(B\
$AIoIpIvIwP=P?PA(B")
(qdl "sang" "\
$AIzI{I|(B")
(qdl "sap" "\
$AJ.J*J0I,(B")
(qdl "sat" "\
$AJ'J5J-JRI*O%(B")
(qdl "sau" "\
$APbPeJV3p3nJUP^JWJXJ[(B\
$AJ\JYJZJ]J^J~KQKRKTP_(B\
$APc[E],`2awoKt<(B")
(qdl "se" "\
$AP4IgIdP)IaIbI6I^I_P6(B\
$AP:Y\wj(B")
(qdl "sei" "\
$AKDK@(B")
(qdl "sek" "\
$AJ/K6N}(B")
(qdl "seng" "\
$APHIy(B")
(qdl "seuk" "\
$AOwne(B")
(qdl "seung" "\
$AK+K*O`IOILOk3#3"3%IJ(B\
$AIKIMIPIQOaObOdOeOfad(B\
$AfOfWidlX(B")
(qdl "sfo" "\
$AH}7*JP(B")
(qdl "si" "\
$AKAJBJGJPJ1J9J>J+J7K<(B\
$AJ?J&JSJ(J)J,J:J;JHJK(B\
$AJLJOJTK9K:K;K=K>K?VE(B\
$AXKZV_1_PnfoHty3Wm'(B")
(qdl "sik" "\
$AI+O'NvJ=O"JNJMJJJ3J4(B\
$AJ6JCNtNzN}O$O(O1ixp*(B\
$Ao$rat*s,(B")
(qdl "sim" "\
$AIA2uI;IBf?iilx(B")
(qdl "sin" "\
$AOHO_I?ICIEIFIHIIO3OI(B\
$AOJOYO[Q"Y~Y;k/tLs5v1(B")
(qdl "sing" "\
$A3GIyJ$PJPTI}3P3I3K3O(B\
$AJ%J"I~J#PGPIPQPUX)nq(B\
$APH(B")
(qdl "sip" "\
$AIcIeIf(B")
(qdl "sit" "\
$AGTI`P(P9P<Q&oF(B")
(qdl "siu" "\
$AP!P&P%OzIYUWO{IUIXI[(B\
$AI\OtOuOvO|UXso(B")
(qdl "so" "\
$AKyJ_JaJhI5KrKsKtKvKx(B\
$A_o`Bf6tH(B")
(qdl "soi" "\
$AHyHz(B")
(qdl "sok" "\
$AKwK7`;`J(B")
(qdl "song" "\
$AI#I$I%K,r*(B")
(qdl "sou" "\
$AKUKXJ}I&I'I(I)KSKVK\(B\
$AK]K_`<vUPk(B")
(qdl "su" "\
$AJiJbJdJsJ`JcJfJmJnJr(B\
$AJwJyJzJ|K](B")
(qdl "suen" "\
$AKcKaW-Ko4,KbKpK1P{P}(B\
$AQ!h/(B")
(qdl "suet" "\
$AK5Q)(B")
(qdl "sui" "\
$APkK.K0KdPh494a4b4cHp(B\
$AJ{KgKhKiKjKkKlKmKnK%(B\
$AK'K-K/PuPw]Medegqc(B")
(qdl "suk" "\
$AJeK`JtJgJjJkJlJqKuKZ(B\
$AK[K^YmY?[S^#(B")
(qdl "sun" "\
$APEQ84<4=4>4?KqK2K3K4(B\
$AQ/Q1Q3Q4Q6Q7W;\wa_(B")
(qdl "sung" "\
$AKI3gKJKKKMKNZ!aTq5(B")
(qdl "sut" "\
$APtJuJvK$Pgs0(B")
(qdl "ta" "\
$AK{K|K}nh(B")
(qdl "taai" "\
$AL+L,4v4{L)L*L-_>nQ(B")
(qdl "taam" "\
$AL8L0L5L6L7L=q{(B")
(qdl "taan" "\
$AL>L/L1L2L3L4L9L;L<L?(B\
$Af'l~(B")
(qdl "taap" "\
$AKzK~L#L.e](B")
(qdl "tai" "\
$ALeLaLbm{5L5Y5^L]L`Lc(B\
$ALdLfLgLiLjLkZPf7(B")
(qdl "tan" "\
$AML(B")
(qdl "tang" "\
$ALZLYkx(B")
(qdl "tau" "\
$AM7M5M6M8(B")
(qdl "tek" "\
$AL_(B")
(qdl "teng" "\
$AL|M'(B")
(qdl "teun" "\
$A6\(B")
(qdl "tik" "\
$AL^LhYCl}o+(B")
(qdl "tim" "\
$A5kLmLpLqLriem,wQ(B")
(qdl "tin" "\
$ALl5a5hLnLoLs(B")
(qdl "ting" "\
$AM"M#L}L~M$M%M&QQfCnz(B\
$ArQv*(B")
(qdl "tip" "\
$ALyL{(B")
(qdl "tit" "\
$ALz(B")
(qdl "tiu" "\
$ALu5wLtLwLxY,lvo"q;tP(B\
$Av6(B")
(qdl "to" "\
$A6fMOMRMSMTMUMVMWMYY"(B\
$Ac{(B")
(qdl "toi" "\
$AL%L(4y5]L&L'(B")
(qdl "tok" "\
$AMPMXuE(B")
(qdl "tong" "\
$ALALFL@LBLCLDLELGLHLI(B\
$ALJLKLLYNlYqmtJs+u1(B")
(qdl "tou" "\
$ALU_{LMM@M>MBMALWM<MC(B\
$A6G585;LNLOLPLQLRLSLT(B\
$ALVM=M?]1_6h:lbnJ(B")
(qdl "tuen" "\
$AME6ZMMMN(B")
(qdl "tuet" "\
$AMQ(B")
(qdl "tui" "\
$AMHMFMGMIMJMK(B")
(qdl "tuk" "\
$AM:(B")
(qdl "tung" "\
$AM(M,M4M3L[L\M)M*M+M-(B\
$AM.M/M0M1M2Y]YWYZ`LkX(B\
$At>(B")
(qdl "uk" "\
$AN]dW(B")
(qdl "wa" "\
$AM[;);-;*;0FhM\M]M^n|(B")
(qdl "waai" "\
$A;5;3;4Ma(B")
(qdl "waak" "\
$A;r;-;s;.(B")
(qdl "waan" "\
$AMe;9;7;<;B;CMdMgMlvi(B\
$AMf(B")
(qdl "waang" "\
$A:a(B")
(qdl "waat" "\
$A;+;,MZ(B")
(qdl "wai" "\
$A;YN*REN=N;N'N(N,;`;d(B\
$A;1;[;\;]M~N$N%N&N)N+(B\
$AN-N.N/N0N3N5N7N8N9N<(B\
$AN>N?N@YK`0(B")
(qdl "wan" "\
$ATFTKTONBTH;j;k;lNANH(B\
$AR|TETGTITJTLTMTNZ;\?(B\
$Aifk5(B")
(qdl "wang" "\
$A:j:k(B")
(qdl "wat" "\
$AG|>s(B")
(qdl "wik" "\
$ASr(B")
(qdl "wing" "\
$AS@HSHYS1S=S>aIr#(B")
(qdl "wo" "\
$A:M9x:L;vNONPNQYAf4q=(B")
(qdl "wok" "\
$A;qXeol(B")
(qdl "wong" "\
$AaeMy;F;G;H;I;J;K;L;M(B\
$AMtMuMwMz(B")
(qdl "wu" "\
$ANZN[:~:|:z:w:x:y:{:}(B\
$A;];$;%;&;'NXNYSsY|b)(B\
$Ad0lhlo(B")
(qdl "wui" "\
$A;X;a;c;2;W(B")
(qdl "wun" "\
$AMf;;;:;8;=;>;@;AMcMk(B\
$AMnMsT+T.X(X`(B")
(qdl "wut" "\
$A;n(B")
(qdl "ya" "\
$AR2(B")
(qdl "yai" "\
$AR7W'(B")
(qdl "yam" "\
$ARtHNR{GUA^HIHQRqRuRw(B\
$ARy`3l'q?v/(B")
(qdl "yan" "\
$AP@HK6wHLR}S!RrPFHJHP(B\
$AHRPCRpRsRvRzR~TPS]Ug(B\
$AX7Xp_Ek3nwr>(B")
(qdl "yap" "\
$AHkF|R>RX]0(B")
(qdl "yat" "\
$AR;HUR<R]RgX}Y+oW(B")
(qdl "yau" "\
$AGpGqSPSISHSVGuH`HaP](B\
$ASDSESFSGSJSKSLSMSNSO(B\
$ASQSRSSSTSUSWY'_O_]i`(B\
$Ak;nprGvOwnwx(B")
(qdl "ye" "\
$AR9HGR,R.R/R0R1Y<(B")
(qdl "yeuk" "\
$AT>ZJT<T;HuE0E1HtR)T?(B\
$AY_(B")
(qdl "yeung" "\
$AQlQyQkHAQsDpH@HBHCQj(B\
$AQmQnQoQpQqQrQtQuQvQw(B\
$AQxQza`l|m&w1(B")
(qdl "yi" "\
$AR=RP6{6y6~RTRFRb6xRe(B\
$ARWRlRiRIRKRjbyRQ6zDb(B\
$AR?R@RARBRCRDRGRHRJRL(B\
$ARMRNRSR^XfY&\2`f_W_^(B\
$Adtg2ill=noonwp(B")
(qdl "yik" "\
$ARZRVRmDfR4R8R:R[R\R_(B\
$AR`RdRfRkRnRo^D^Hfdrf(B\
$ARW(B")
(qdl "yim" "\
$AQOQWH=H>OSQaQfQiQKQM(B\
$AQNQVQYQZQ^X_Y2(B")
(qdl "yin" "\
$AOROVQTQ`H;QPQLH<OMOO(B\
$AOQQbQdQeQgQhQIQJQSQ](B\
$AQ_YpZ]dNe{fLkYs[wz(B")
(qdl "ying" "\
$AS"S0PNPMHOD}HTS&PLPO(B\
$AS#S$S%S'S(S)S*S+S,S-(B\
$AS.S/S3XMYx`Se-pP(B")
(qdl "yip" "\
$AR6R5R3Du(B")
(qdl "yit" "\
$AHHR-ZKt+(B")
(qdl "yiu" "\
$AHFQ|R*R+HEQ{Q}Q~R!R"(B\
$AR#R%R&R(X2_:afahf,(B")
(qdl "yo" "\
$AS4`!(B")
(qdl "yu" "\
$ASkl6SjSoSZHgShH#HcHd(B\
$AHeHfHiHjS`SaSbScSdSe(B\
$ASfSgSiSlSmSnSpSuSvSw(B\
$ASxSySzS~T"T#T$T%T&SX(B\
$ASYS[S\S]S^S_X.XqZM`i(B\
$Af%pvo(r,q>qAt't(sDv'(B\
$Av9(B")
(qdl "yuen" "\
$AT'T6T1MjT-T*QX4*HmHn(B\
$AG&MhMiMoMpMqP|P~OXQ#(B\
$AT(T)T,T/T0T2T3T4T5T7(B\
$AT8T9T:\>k<ngp0(B")
(qdl "yui" "\
$AHoHqP>Ra(B")
(qdl "yuk" "\
$ASqS}HbHhHlNVPqStS{S|(B\
$AT!X9ewgojEnZ(B")
(qdl "yun" "\
$AHrHs(B")
(qdl "yung" "\
$AS?S9o^SCSBHZH]HVHWHX(B\
$AH[H\H^H_NKNLS5S6S7S8(B\
$AS:S;S<SAY8`/g_iEp.(B")
