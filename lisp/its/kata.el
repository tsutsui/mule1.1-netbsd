;; Basic Roma-to-KataKana Translation Table for Egg
;; Coded by S.Tomura, Electrotechnical Lab. (tomura@etl.go.jp)

;; This file is part of Egg on Nemacs (Japanese Environment)

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

;; 90.3.2   modified for Nemacs Ver.3.3.1
;;	by jiro@math.keio.ac.jp (TANAKA Jiro)
;;     proposal of keybinding for JIS symbols
;; 92.3.16  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;; 92.3.23  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;;	defrule -> its-defrule, define-its-mode -> its-define-mode

;; 92.3.16 by K.Handa
;;(define-its-mode "roma-kata"  " aア" t)
(its-define-mode "roma-kata"  "ア" t)

(dolist (aa '("k" "s" "t" "h" "y" "r" "w" "g" "z" "d" "b"
		 "p" "c" "f" "j" "v"))
  (its-defrule (concat aa aa) "ッ" aa))

(its-defrule "tch"  "ッ" "ch")

(dolist (q1 '("b" "m" "p"))
  (its-defrule (concat "m" q1) "ン" q1))

(its-defrule "N" "ン")

(defvar enable-double-n-syntax nil "*Enable ""nn"" input for ""ン"" ")

(its-defrule-conditional "n"
  ((not enable-double-n-syntax) "ン")
  (t nil))
(its-defrule-conditional "nn"
  ( enable-double-n-syntax "ン")
  (t nil))

(its-defrule "n'" "ン")

(let ((small '"x" ))
  (its-defrule (concat small "a") "ァ")
  (its-defrule (concat small "i") "ィ")
  (its-defrule (concat small "u") "ゥ")
  (its-defrule (concat small "e") "ェ")
  (its-defrule (concat small "o") "ォ")
  (its-defrule (concat small "ya") "ャ")
  (its-defrule (concat small "yu") "ュ")
  (its-defrule (concat small "yo") "ョ")
  (its-defrule (concat small "tu") "ッ")
  (its-defrule (concat small "tsu") "ッ")
  (its-defrule (concat small "wa") "ヮ")
  )

(its-defrule   "a"    "ア")
(its-defrule   "i"    "イ")
(its-defrule   "u"    "ウ")
(its-defrule   "e"    "エ")
(its-defrule   "o"    "オ")
(its-defrule   "ka"   "カ")
(its-defrule   "ki"   "キ")
(its-defrule   "ku"   "ク")
(its-defrule   "ke"   "ケ")
(its-defrule   "ko"   "コ")
(its-defrule   "kya"  "キャ")
(its-defrule   "kyu"  "キュ")
(its-defrule   "kye"  "キェ")
(its-defrule   "kyo"  "キョ")
(its-defrule   "sa"   "サ")
(its-defrule   "si"   "シ")
(its-defrule   "su"   "ス")
(its-defrule   "se"   "セ")
(its-defrule   "so"   "ソ")
(its-defrule   "sya"  "シャ")
(its-defrule   "syu"  "シュ")
(its-defrule   "sye"  "シェ")
(its-defrule   "syo"  "ショ")
(its-defrule   "sha"  "シャ")
(its-defrule   "shi"  "シ")
(its-defrule   "shu"  "シュ")
(its-defrule   "she"  "シェ")
(its-defrule   "sho"  "ショ")
(its-defrule   "ta"   "タ")
(its-defrule   "ti"   "チ")
(its-defrule   "tu"   "ツ")
(its-defrule   "te"   "テ")
(its-defrule   "to"   "ト")
(its-defrule   "tya"  "チャ")
(its-defrule   "tyi"  "ティ")
(its-defrule   "tyu"  "チュ")
(its-defrule   "tye"  "チェ")
(its-defrule   "tyo"  "チョ")
(its-defrule   "tsu"  "ツ")
(its-defrule   "cha"  "チャ")
(its-defrule   "chi"  "チ")
(its-defrule   "chu"  "チュ")
(its-defrule   "che"  "チェ")
(its-defrule   "cho"  "チョ")
(its-defrule   "na"   "ナ")
(its-defrule   "ni"   "ニ")
(its-defrule   "nu"   "ヌ")
(its-defrule   "ne"   "ネ")
(its-defrule   "no"   "ノ")
(its-defrule   "nya"  "ニャ")
(its-defrule   "nyu"  "ニュ")
(its-defrule   "nye"  "ニェ")
(its-defrule   "nyo"  "ニョ")
(its-defrule   "ha"   "ハ")
(its-defrule   "hi"   "ヒ")
(its-defrule   "hu"   "フ")
(its-defrule   "he"   "ヘ")
(its-defrule   "ho"   "ホ")
(its-defrule   "hya"  "ヒャ")
(its-defrule   "hyu"  "ヒュ")
(its-defrule   "hye"  "ヒェ")
(its-defrule   "hyo"  "ヒョ")
(its-defrule   "fa"   "ファ")
(its-defrule   "fi"   "フィ")
(its-defrule   "fu"   "フ")
(its-defrule   "fe"   "フェ")
(its-defrule   "fo"   "フォ")
(its-defrule   "ma"   "マ")
(its-defrule   "mi"   "ミ")
(its-defrule   "mu"   "ム")
(its-defrule   "me"   "メ")
(its-defrule   "mo"   "モ")
(its-defrule   "mya"  "ミャ")
(its-defrule   "myu"  "ミュ")
(its-defrule   "mye"  "ミェ")
(its-defrule   "myo"  "ミョ")
(its-defrule   "ya"   "ヤ")
(its-defrule   "yi"   "イ")
(its-defrule   "yu"   "ユ")
(its-defrule   "ye"   "イェ")
(its-defrule   "yo"   "ヨ")
(its-defrule   "ra"   "ラ")
(its-defrule   "ri"   "リ")
(its-defrule   "ru"   "ル")
(its-defrule   "re"   "レ")
(its-defrule   "ro"   "ロ")
(its-defrule   "la"   "ラ")
(its-defrule   "li"   "リ")
(its-defrule   "lu"   "ル")
(its-defrule   "le"   "レ")
(its-defrule   "lo"   "ロ")
(its-defrule   "rya"  "リャ")
(its-defrule   "ryu"  "リュ")
(its-defrule   "rye"  "リェ")
(its-defrule   "ryo"  "リョ")
(its-defrule   "lya"  "リャ")
(its-defrule   "lyu"  "リュ")
(its-defrule   "lye"  "リェ")
(its-defrule   "lyo"  "リョ")
(its-defrule   "wa"   "ワ")
(its-defrule   "wi"   "ヰ")
(its-defrule   "wu"   "ウ")
(its-defrule   "we"   "ヱ")
(its-defrule   "wo"   "ヲ")
(its-defrule   "ga"   "ガ")
(its-defrule   "gi"   "ギ")
(its-defrule   "gu"   "グ")
(its-defrule   "ge"   "ゲ")
(its-defrule   "go"   "ゴ")
(its-defrule   "gya"  "ギャ")
(its-defrule   "gyu"  "ギュ")
(its-defrule   "gye"  "ギェ")
(its-defrule   "gyo"  "ギョ")
(its-defrule   "za"   "ザ")
(its-defrule   "zi"   "ジ")
(its-defrule   "zu"   "ズ")
(its-defrule   "ze"   "ゼ")
(its-defrule   "zo"   "ゾ")
(its-defrule   "zya"  "ジャ")
(its-defrule   "zyu"  "ジュ")
(its-defrule   "zye"  "ジェ")
(its-defrule   "zyo"  "ジョ")
(its-defrule   "ja"   "ジャ")
(its-defrule   "ji"   "ジ")
(its-defrule   "ju"   "ジュ")
(its-defrule   "je"   "ジェ")
(its-defrule   "jo"   "ジョ")
(its-defrule   "da"   "ダ")
(its-defrule   "di"   "ヂ")
(its-defrule   "du"   "ヅ")
(its-defrule   "de"   "デ")
(its-defrule   "do"   "ド")
(its-defrule   "dya"  "ヂャ")
(its-defrule   "dyi"  "ディ")
(its-defrule   "dyu"  "ヂュ")
(its-defrule   "dye"  "ヂェ")
(its-defrule   "dyo"  "ヂョ")
(its-defrule   "ba"   "バ")
(its-defrule   "bi"   "ビ")
(its-defrule   "bu"   "ブ")
(its-defrule   "be"   "ベ")
(its-defrule   "bo"   "ボ")
(its-defrule   "va"   "ヴァ")
(its-defrule   "vi"   "ヴィ")
(its-defrule   "vu"   "ヴ")
(its-defrule   "ve"   "ヴェ")
(its-defrule   "vo"   "ヴォ")
(its-defrule   "bya"  "ビャ")
(its-defrule   "byu"  "ビュ")
(its-defrule   "bye"  "ビェ")
(its-defrule   "byo"  "ビョ")
(its-defrule   "pa"   "パ")
(its-defrule   "pi"   "ピ")
(its-defrule   "pu"   "プ")
(its-defrule   "pe"   "ペ")
(its-defrule   "po"   "ポ")
(its-defrule   "pya"  "ピャ")
(its-defrule   "pyu"  "ピュ")
(its-defrule   "pye"  "ピェ")
(its-defrule   "pyo"  "ピョ")
(its-defrule   "kwa"  "クヮ")
(its-defrule   "kwi"  "クィ")
(its-defrule   "kwu"  "ク")
(its-defrule   "kwe"  "クェ")
(its-defrule   "kwo"  "クォ")
(its-defrule   "gwa"  "グヮ")
(its-defrule   "gwi"  "グィ")
(its-defrule   "gwu"  "グ")
(its-defrule   "gwe"  "グェ")
(its-defrule   "gwo"  "グォ")
(its-defrule   "tsa"  "ツァ")
(its-defrule   "tsi"  "ツィ")
(its-defrule   "tse"  "ツェ")
(its-defrule   "tso"  "ツォ")
(its-defrule   "xka"  "ヵ")
(its-defrule   "xke"  "ヶ")
(its-defrule   "xti"  "ティ")
(its-defrule   "xdi"  "ディ")
(its-defrule   "xdu"  "ドゥ")
(its-defrule   "xde"  "デェ")
(its-defrule   "xdo"  "ドォ")
;(its-defrule   "xwa"  "ヮ")
(its-defrule   "xwi"  "ウィ")
(its-defrule   "xwe"  "ウェ")
(its-defrule   "xwo"  "ウォ")

;;; Zenkaku Symbols

(its-defrule   "1"   "１")
(its-defrule   "2"   "２")
(its-defrule   "3"   "３")
(its-defrule   "4"   "４")
(its-defrule   "5"   "５")
(its-defrule   "6"   "６")
(its-defrule   "7"   "７")
(its-defrule   "8"   "８")
(its-defrule   "9"   "９")
(its-defrule   "0"   "０")

;;;(its-defrule   " "   "　")
(its-defrule   "!"   "！")
(its-defrule   "@"   "＠")
(its-defrule   "#"   "＃")
(its-defrule   "$"   "＄")
(its-defrule   "%"   "％")
(its-defrule   "^"   "＾")
(its-defrule   "&"   "＆")
(its-defrule   "*"   "＊")
(its-defrule   "("   "（")
(its-defrule   ")"   "）")
(its-defrule   "-"   "ー") ;;; JIS 213c  ;;;(its-defrule   "-"   "−")
(its-defrule   "="   "＝")
(its-defrule   "`"   "｀")
(its-defrule   "\\"  "￥")
(its-defrule   "|"   "｜")
(its-defrule   "_"   "＿")
(its-defrule   "+"   "＋")
(its-defrule   "~"   "￣")
(its-defrule   "["    "「")  ;;(its-defrule   "["   "［")
(its-defrule   "]"    "」")  ;;(its-defrule   "]"   "］")
(its-defrule   "{"   "｛")
(its-defrule   "}"   "｝")
(its-defrule   ":"   "：")
(its-defrule   ";"   "；")
(its-defrule   "\""  "”")
(its-defrule   "'"   "’")
(its-defrule   "<"   "＜")
(its-defrule   ">"   "＞")
(its-defrule   "?"   "？")
(its-defrule   "/"   "／")

(defvar use-kuten-for-period t "*ピリオドを句点に変換する")
(defvar use-touten-for-comma t "*コンマを読点に変換する")

(its-defrule-conditional "."
  (use-kuten-for-period "。")
  (t "．"))

(its-defrule-conditional ","
  (use-touten-for-comma "、")
  (t "，"))

;;; Escape character to Zenkaku inputs

(defvar zenkaku-escape "Z")

;;; Escape character to Hankaku inputs

(defvar hankaku-escape "~")
;;;
;;; Zenkaku inputs
;;;

(its-defrule (concat zenkaku-escape "0") "０")
(its-defrule (concat zenkaku-escape "1") "１")
(its-defrule (concat zenkaku-escape "2") "２")
(its-defrule (concat zenkaku-escape "3") "３")
(its-defrule (concat zenkaku-escape "4") "４")
(its-defrule (concat zenkaku-escape "5") "５")
(its-defrule (concat zenkaku-escape "6") "６")
(its-defrule (concat zenkaku-escape "7") "７")
(its-defrule (concat zenkaku-escape "8") "８")
(its-defrule (concat zenkaku-escape "9") "９")

(its-defrule (concat zenkaku-escape "A") "Ａ")
(its-defrule (concat zenkaku-escape "B") "Ｂ")
(its-defrule (concat zenkaku-escape "C") "Ｃ")
(its-defrule (concat zenkaku-escape "D") "Ｄ")
(its-defrule (concat zenkaku-escape "E") "Ｅ")
(its-defrule (concat zenkaku-escape "F") "Ｆ")
(its-defrule (concat zenkaku-escape "G") "Ｇ")
(its-defrule (concat zenkaku-escape "H") "Ｈ")
(its-defrule (concat zenkaku-escape "I") "Ｉ")
(its-defrule (concat zenkaku-escape "J") "Ｊ")
(its-defrule (concat zenkaku-escape "K") "Ｋ")
(its-defrule (concat zenkaku-escape "L") "Ｌ")
(its-defrule (concat zenkaku-escape "M") "Ｍ")
(its-defrule (concat zenkaku-escape "N") "Ｎ")
(its-defrule (concat zenkaku-escape "O") "Ｏ")
(its-defrule (concat zenkaku-escape "P") "Ｐ")
(its-defrule (concat zenkaku-escape "Q") "Ｑ")
(its-defrule (concat zenkaku-escape "R") "Ｒ")
(its-defrule (concat zenkaku-escape "S") "Ｓ")
(its-defrule (concat zenkaku-escape "T") "Ｔ")
(its-defrule (concat zenkaku-escape "U") "Ｕ")
(its-defrule (concat zenkaku-escape "V") "Ｖ")
(its-defrule (concat zenkaku-escape "W") "Ｗ")
(its-defrule (concat zenkaku-escape "X") "Ｘ")
(its-defrule (concat zenkaku-escape "Y") "Ｙ")
(its-defrule (concat zenkaku-escape "Z") "Ｚ")

(its-defrule (concat zenkaku-escape "a") "ａ")
(its-defrule (concat zenkaku-escape "b") "ｂ")
(its-defrule (concat zenkaku-escape "c") "ｃ")
(its-defrule (concat zenkaku-escape "d") "ｄ")
(its-defrule (concat zenkaku-escape "e") "ｅ")
(its-defrule (concat zenkaku-escape "f") "ｆ")
(its-defrule (concat zenkaku-escape "g") "ｇ")
(its-defrule (concat zenkaku-escape "h") "ｈ")
(its-defrule (concat zenkaku-escape "i") "ｉ")
(its-defrule (concat zenkaku-escape "j") "ｊ")
(its-defrule (concat zenkaku-escape "k") "ｋ")
(its-defrule (concat zenkaku-escape "l") "ｌ")
(its-defrule (concat zenkaku-escape "m") "ｍ")
(its-defrule (concat zenkaku-escape "n") "ｎ")
(its-defrule (concat zenkaku-escape "o") "ｏ")
(its-defrule (concat zenkaku-escape "p") "ｐ")
(its-defrule (concat zenkaku-escape "q") "ｑ")
(its-defrule (concat zenkaku-escape "r") "ｒ")
(its-defrule (concat zenkaku-escape "s") "ｓ")
(its-defrule (concat zenkaku-escape "t") "ｔ")
(its-defrule (concat zenkaku-escape "u") "ｕ")
(its-defrule (concat zenkaku-escape "v") "ｖ")
(its-defrule (concat zenkaku-escape "w") "ｗ")
(its-defrule (concat zenkaku-escape "x") "ｘ")
(its-defrule (concat zenkaku-escape "y") "ｙ")
(its-defrule (concat zenkaku-escape "z") "ｚ")

(its-defrule (concat zenkaku-escape " ")  "　")
(its-defrule (concat zenkaku-escape "!")  "！")
(its-defrule (concat zenkaku-escape "@")  "＠")
(its-defrule (concat zenkaku-escape "#")  "＃")
(its-defrule (concat zenkaku-escape "$")  "＄")
(its-defrule (concat zenkaku-escape "%")  "％")
(its-defrule (concat zenkaku-escape "^")  "＾")
(its-defrule (concat zenkaku-escape "&")  "＆")
(its-defrule (concat zenkaku-escape "*")  "＊")
(its-defrule (concat zenkaku-escape "(")  "（")
(its-defrule (concat zenkaku-escape ")")  "）")
(its-defrule (concat zenkaku-escape "-")  "−")
(its-defrule (concat zenkaku-escape "=")  "＝")
(its-defrule (concat zenkaku-escape "`")  "｀")
(its-defrule (concat zenkaku-escape "\\") "￥")
(its-defrule (concat zenkaku-escape "|")  "｜")
(its-defrule (concat zenkaku-escape "_")  "＿")
(its-defrule (concat zenkaku-escape "+")  "＋")
(its-defrule (concat zenkaku-escape "~")  "￣")
(its-defrule (concat zenkaku-escape "[")  "［")
(its-defrule (concat zenkaku-escape "]")  "］")
(its-defrule (concat zenkaku-escape "{")  "｛")
(its-defrule (concat zenkaku-escape "}")  "｝")
(its-defrule (concat zenkaku-escape ":")  "：")
(its-defrule (concat zenkaku-escape ";")  "；")
(its-defrule (concat zenkaku-escape "\"") "”")
(its-defrule (concat zenkaku-escape "'")  "’")
(its-defrule (concat zenkaku-escape "<")  "＜")
(its-defrule (concat zenkaku-escape ">")  "＞")
(its-defrule (concat zenkaku-escape "?")  "？")
(its-defrule (concat zenkaku-escape "/")  "／")
(its-defrule (concat zenkaku-escape ",")  "，")
(its-defrule (concat zenkaku-escape ".")  "．")

;;;
;;; Hankaku inputs
;;;

;;(defvar escd '("-" "," "." "/" ";" ":" "[" "\\" "]" "^" "~"))
;;(its-defrule '("x" escd)  '(escd))


(defvar digit-characters 
   '( "1"  "2"  "3"  "4" "5"  "6"  "7"  "8"  "9"  "0" ))

(defvar symbol-characters 
   '( " "  "!"  "@"  "#"  "$"  "%"  "^"  "&"  "*"  "("  ")"
      "-"  "="  "`"  "\\" "|"  "_"  "+"  "~" "["  "]"  "{"  "}"
      ":"  ";"  "\"" "'"  "<"  ">"  "?"  "/"  ","  "." ))

(defvar downcase-alphabets 
   '("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
     "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))

(defvar upcase-alphabets
   '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N"
     "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

(dolist (digit digit-characters)
  (its-defrule (concat hankaku-escape digit)  digit))

(dolist (symbol symbol-characters)
  (its-defrule (concat hankaku-escape symbol) symbol))

(dolist (downcase downcase-alphabets)
  (its-defrule (concat hankaku-escape downcase) downcase))

(dolist (upcase upcase-alphabets)
  (its-defrule (concat hankaku-escape upcase) upcase))

;;; proposal key bindings for JIS symbols
;;; 90.3.2  by jiro@math.keio.ac.jp (TANAKA Jiro)

(its-defrule   "z1"   "○")	(its-defrule   "z!"   "●")
(its-defrule   "z2"   "▽")	(its-defrule   "z@"   "▼")
(its-defrule   "z3"   "△")	(its-defrule   "z#"   "▲")
(its-defrule   "z4"   "□")	(its-defrule   "z$"   "■")
(its-defrule   "z5"   "◇")	(its-defrule   "z%"   "◆")
(its-defrule   "z6"   "☆")	(its-defrule   "z^"   "★")
(its-defrule   "z7"   "◎")	(its-defrule   "z&"   "£")
(its-defrule   "z8"   "¢")	(its-defrule   "z*"   "×")
(its-defrule   "z9"   "♂")	(its-defrule   "z("   "【")
(its-defrule   "z0"   "♀")	(its-defrule   "z)"   "】")
(its-defrule   "z-"   "〜")	(its-defrule   "z_"   "∴")	; z-
(its-defrule   "z="   "≠")	(its-defrule   "z+"   "±")
(its-defrule   "z\\"  "＼")	(its-defrule   "z|"   "‖")
(its-defrule   "z`"   "´")	(its-defrule   "z~"   "¨")

(its-defrule   "zq"   "《")	(its-defrule   "zQ"   "〈")
(its-defrule   "zw"   "》")	(its-defrule   "zW"   "〉")
; e
(its-defrule   "zr"   "々")	(its-defrule   "zR"   "仝")	; zr
(its-defrule   "zt"   "〆")	(its-defrule   "zT"   "§")
; y u i o
(its-defrule   "zp"   "〒")	(its-defrule   "zP"   "↑")	; zp
(its-defrule   "z["   "『")	(its-defrule   "z{"   "〔")	; z[
(its-defrule   "z]"   "』")	(its-defrule   "z}"   "〕")	; z]

; a
(its-defrule   "zs"   "ヽ")	(its-defrule   "zS"   "ヾ")
(its-defrule   "zd"   "ゝ")	(its-defrule   "zD"   "ゞ")
(its-defrule   "zf"   "〃")	(its-defrule   "zF"   "→")
(its-defrule   "zg"   "‐")	(its-defrule   "zG"   "―")
(its-defrule   "zh"   "←")
(its-defrule   "zj"   "↓")
(its-defrule   "zk"   "↑")
(its-defrule   "zl"   "→")
(its-defrule   "z;"   "゛")	(its-defrule   "z:"   "゜")
(its-defrule   "z\'"  "‘")	(its-defrule   "z\""  "“")

; z
(its-defrule   "zx"   ":-")	(its-defrule   "zX"   ":-)")
(its-defrule   "zc"   "〇")	(its-defrule   "zC"   "℃")	; zc
(its-defrule   "zv"   "※")	(its-defrule   "zV"   "÷")
(its-defrule   "zb"   "°")	(its-defrule   "zB"   "←")
(its-defrule   "zn"   "′")	(its-defrule   "zN"   "↓")
(its-defrule   "zm"   "″")	(its-defrule   "zM"   "〓")
(its-defrule   "z,"   "‥")	(its-defrule   "z<"   "≦")
(its-defrule   "z."   "…")	(its-defrule   "z>"   "≧")	; z.
(its-defrule   "z/"   "・")	(its-defrule   "z?"   "∞")	; z/

;;; Commented out by K.Handa.  Already defined in a different way.
;(its-defrule   "va"   "ヴァ")
;(its-defrule   "vi"   "ヴィ")
;(its-defrule   "vu"   "ヴ")
;(its-defrule   "ve"   "ヴェ")
;(its-defrule   "vo"   "ヴォ")
