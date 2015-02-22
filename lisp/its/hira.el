;; Basic Roma-to-Kana Translation Table for Egg
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
;; 92.3.23  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;;	defrule -> its-defrule, define-its-mode -> its-define-mode
;; 92.7.6   modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;	New rules added.

(its-define-mode "roma-kana" "あ" t)

(its-defrule-select-mode-temporally "q" "downcase")
(its-defrule-select-mode-temporally "Q" "zenkaku-downcase")

;;; 「っ」の入力

(dolist (aa '("k" "s" "t" "h" "y" "r" "w" "g" "z" "d" "b"
		 "p" "c" "f" "j" "v"))
  (its-defrule (concat aa aa) "っ" aa))

(its-defrule "tch"  "っ" "ch")

;;; 「ん」の入力

(dolist (q1 '("b" "m" "p"))
  (its-defrule (concat "m" q1) "ん" q1))

(its-defrule "N" "ん")

(its-defrule "n" "ん")

(its-defrule "n'" "ん")

(defvar enable-double-n-syntax nil "*""nn""を""ん""に変換する")

(if (not (featurep 'tamago))
    (its-defrule-conditional "nn" 
			     (enable-double-n-syntax "ん")
			     (t nil))

  (its-defrule-conditional* "nn" "ん" nil
			    (enable-double-n-syntax "ん")
			    (t nil))
  )
;; 92.7.6 by Y.Kawabe
;;(dolist (aa '("k" "s" "t" "c" "h" "f" "m" "y" "r" "l"
;;	      "w" "g" "z" "j" "d" "b" "v" "p" "x"))
;;  (its-defrule (concat "n" aa) "ん" aa))
;; end of patch

(let ((small '"x" ))
  (its-defrule (concat small "a") "ぁ")
  (its-defrule (concat small "i") "ぃ")
  (its-defrule (concat small "u") "ぅ")
  (its-defrule (concat small "e") "ぇ")
  (its-defrule (concat small "o") "ぉ")
  (its-defrule (concat small "ya") "ゃ")
  (its-defrule (concat small "yu") "ゅ")
  (its-defrule (concat small "yo") "ょ")
  (its-defrule (concat small "tu") "っ")
  (its-defrule (concat small "tsu") "っ")
  (its-defrule (concat small "wa") "ゎ")
  )

(its-defrule   "a"    "あ")
(its-defrule   "i"    "い")
(its-defrule   "u"    "う")
(its-defrule   "e"    "え")
(its-defrule   "o"    "お")
(its-defrule   "ka"   "か")
(its-defrule   "ki"   "き")
(its-defrule   "ku"   "く")
(its-defrule   "ke"   "け")
(its-defrule   "ko"   "こ")
(its-defrule   "kya"  "きゃ")
(its-defrule   "kyu"  "きゅ")
(its-defrule   "kye"  "きぇ")
(its-defrule   "kyo"  "きょ")
(its-defrule   "sa"   "さ")
(its-defrule   "si"   "し")
(its-defrule   "su"   "す")
(its-defrule   "se"   "せ")
(its-defrule   "so"   "そ")
(its-defrule   "sya"  "しゃ")
(its-defrule   "syu"  "しゅ")
(its-defrule   "sye"  "しぇ")
(its-defrule   "syo"  "しょ")
(its-defrule   "sha"  "しゃ")
(its-defrule   "shi"  "し")
(its-defrule   "shu"  "しゅ")
(its-defrule   "she"  "しぇ")
(its-defrule   "sho"  "しょ")
(its-defrule   "ta"   "た")
(its-defrule   "ti"   "ち")
(its-defrule   "tu"   "つ")
(its-defrule   "te"   "て")
(its-defrule   "to"   "と")
(its-defrule   "tya"  "ちゃ")
(its-defrule   "tyi"  "てぃ")
(its-defrule   "tyu"  "ちゅ")
(its-defrule   "tye"  "ちぇ")
(its-defrule   "tyo"  "ちょ")
(its-defrule   "tsu"  "つ")
(its-defrule   "cha"  "ちゃ")
(its-defrule   "chi"  "ち")
(its-defrule   "chu"  "ちゅ")
(its-defrule   "che"  "ちぇ")
(its-defrule   "cho"  "ちょ")
(its-defrule   "na"   "な")
(its-defrule   "ni"   "に")
(its-defrule   "nu"   "ぬ")
(its-defrule   "ne"   "ね")
(its-defrule   "no"   "の")
(its-defrule   "nya"  "にゃ")
(its-defrule   "nyu"  "にゅ")
(its-defrule   "nye"  "にぇ")
(its-defrule   "nyo"  "にょ")
(its-defrule   "ha"   "は")
(its-defrule   "hi"   "ひ")
(its-defrule   "hu"   "ふ")
(its-defrule   "he"   "へ")
(its-defrule   "ho"   "ほ")
(its-defrule   "hya"  "ひゃ")
(its-defrule   "hyu"  "ひゅ")
(its-defrule   "hye"  "ひぇ")
(its-defrule   "hyo"  "ひょ")
(its-defrule   "fa"   "ふぁ")
(its-defrule   "fi"   "ふぃ")
(its-defrule   "fu"   "ふ")
(its-defrule   "fe"   "ふぇ")
(its-defrule   "fo"   "ふぉ")
(its-defrule   "ma"   "ま")
(its-defrule   "mi"   "み")
(its-defrule   "mu"   "む")
(its-defrule   "me"   "め")
(its-defrule   "mo"   "も")
(its-defrule   "mya"  "みゃ")
(its-defrule   "myu"  "みゅ")
(its-defrule   "mye"  "みぇ")
(its-defrule   "myo"  "みょ")
(its-defrule   "ya"   "や")
(its-defrule   "yi"   "い")
(its-defrule   "yu"   "ゆ")
(its-defrule   "ye"   "いぇ")
(its-defrule   "yo"   "よ")
(its-defrule   "ra"   "ら")
(its-defrule   "ri"   "り")
(its-defrule   "ru"   "る")
(its-defrule   "re"   "れ")
(its-defrule   "ro"   "ろ")
(its-defrule   "la"   "ら")
(its-defrule   "li"   "り")
(its-defrule   "lu"   "る")
(its-defrule   "le"   "れ")
(its-defrule   "lo"   "ろ")
(its-defrule   "rya"  "りゃ")
(its-defrule   "ryu"  "りゅ")
(its-defrule   "rye"  "りぇ")
(its-defrule   "ryo"  "りょ")
(its-defrule   "lya"  "りゃ")
(its-defrule   "lyu"  "りゅ")
(its-defrule   "lye"  "りぇ")
(its-defrule   "lyo"  "りょ")
(its-defrule   "wa"   "わ")
(its-defrule   "wi"   "ゐ")
(its-defrule   "wu"   "う")
(its-defrule   "we"   "ゑ")
(its-defrule   "wo"   "を")
(its-defrule   "ga"   "が")
(its-defrule   "gi"   "ぎ")
(its-defrule   "gu"   "ぐ")
(its-defrule   "ge"   "げ")
(its-defrule   "go"   "ご")
(its-defrule   "gya"  "ぎゃ")
(its-defrule   "gyu"  "ぎゅ")
(its-defrule   "gye"  "ぎぇ")
(its-defrule   "gyo"  "ぎょ")
(its-defrule   "za"   "ざ")
(its-defrule   "zi"   "じ")
(its-defrule   "zu"   "ず")
(its-defrule   "ze"   "ぜ")
(its-defrule   "zo"   "ぞ")
(its-defrule   "zya"  "じゃ")
(its-defrule   "zyu"  "じゅ")
(its-defrule   "zye"  "じぇ")
(its-defrule   "zyo"  "じょ")
(its-defrule   "ja"   "じゃ")
(its-defrule   "ji"   "じ")
(its-defrule   "ju"   "じゅ")
(its-defrule   "je"   "じぇ")
(its-defrule   "jo"   "じょ")
;; 92.7.6 by Y.Kawabe
(its-defrule   "jya"   "じゃ")
(its-defrule   "jyu"   "じゅ")
(its-defrule   "jye"   "じぇ")
(its-defrule   "jyo"   "じょ")
;; end of patch
(its-defrule   "da"   "だ")
(its-defrule   "di"   "ぢ")
(its-defrule   "du"   "づ")
(its-defrule   "de"   "で")
(its-defrule   "do"   "ど")
(its-defrule   "dya"  "ぢゃ")
(its-defrule   "dyi"  "でぃ")
(its-defrule   "dyu"  "ぢゅ")
(its-defrule   "dye"  "ぢぇ")
(its-defrule   "dyo"  "ぢょ")
(its-defrule   "ba"   "ば")
(its-defrule   "bi"   "び")
(its-defrule   "bu"   "ぶ")
(its-defrule   "be"   "べ")
(its-defrule   "bo"   "ぼ")
(its-defrule   "va"   "ヴぁ")
(its-defrule   "vi"   "ヴぃ")
(its-defrule   "vu"   "ヴ")
(its-defrule   "ve"   "ヴぇ")
(its-defrule   "vo"   "ヴぉ")
(its-defrule   "bya"  "びゃ")
(its-defrule   "byu"  "びゅ")
(its-defrule   "bye"  "びぇ")
(its-defrule   "byo"  "びょ")
(its-defrule   "pa"   "ぱ")
(its-defrule   "pi"   "ぴ")
(its-defrule   "pu"   "ぷ")
(its-defrule   "pe"   "ぺ")
(its-defrule   "po"   "ぽ")
(its-defrule   "pya"  "ぴゃ")
(its-defrule   "pyu"  "ぴゅ")
(its-defrule   "pye"  "ぴぇ")
(its-defrule   "pyo"  "ぴょ")
(its-defrule   "kwa"  "くゎ")
(its-defrule   "kwi"  "くぃ")
(its-defrule   "kwu"  "く")
(its-defrule   "kwe"  "くぇ")
(its-defrule   "kwo"  "くぉ")
(its-defrule   "gwa"  "ぐゎ")
(its-defrule   "gwi"  "ぐぃ")
(its-defrule   "gwu"  "ぐ")
(its-defrule   "gwe"  "ぐぇ")
(its-defrule   "gwo"  "ぐぉ")
(its-defrule   "tsa"  "つぁ")
(its-defrule   "tsi"  "つぃ")
(its-defrule   "tse"  "つぇ")
(its-defrule   "tso"  "つぉ")
(its-defrule   "xka"  "ヵ")
(its-defrule   "xke"  "ヶ")
(its-defrule   "xti"  "てぃ")
(its-defrule   "xdi"  "でぃ")
(its-defrule   "xdu"  "どぅ")
(its-defrule   "xde"  "でぇ")
(its-defrule   "xdo"  "どぉ")
(its-defrule   "xwi"  "うぃ")
(its-defrule   "xwe"  "うぇ")
(its-defrule   "xwo"  "うぉ")

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

;;(its-defrule   " "   "　")
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


