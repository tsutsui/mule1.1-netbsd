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

;; 92.3.16  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;; 92.3.23  modified for Mule Ver.0.9.1 by K.Handa <handa@etl.go.jp>
;;	defrule -> its-defrule, define-its-mode -> its-define-mode

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

;;;;
;;;;
;;;;

;; 92.3.16 by K.Handa
;;(define-its-mode "downcase"  " a a" t)
(its-define-mode "downcase"  "aa" t)

(dolist  (digit digit-characters)
  (its-defrule digit  digit))

(dolist (symbol symbol-characters)
  (its-defrule symbol symbol))

(dolist (downcase downcase-alphabets)
  (its-defrule downcase downcase))

(dolist (upcase upcase-alphabets)
  (its-defrule upcase upcase))

;;;;
;;;;
;;;;

(defun upcase-character (ch)
  (if (and (<= ?a ch) (<= ch ?z))
      (+ ?A (- ch ?a))
    ch))

;; 92.3.16 by K.Handa
;;(define-its-mode "upcase" " a A" t)
(its-define-mode "upcase" "aA" t);;; 93.7.21 by S.Tomura

(dolist (digit digit-characters)
  (its-defrule digit  digit))

(dolist (symbol symbol-characters)
  (its-defrule symbol symbol))

(dolist (downcase downcase-alphabets)
  (its-defrule downcase (char-to-string (upcase-character (string-to-char downcase)))))

(dolist (upcase upcase-alphabets)
  (its-defrule upcase upcase))

