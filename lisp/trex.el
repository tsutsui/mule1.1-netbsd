;; TREX: Tools for Regluar EXpressions
;;
;; Regular Expression Compiler
;;
;; Coded by S.Tomura <tomura@etl.go.jp>

;; Copyright (C) 1992 Free Software Foundation, Inc.
;; This file is part of Mule (MULtilingual Enhancement of GNU Emacs).
;; This file contains Japanese characters

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


(defvar TREX-version "0.34")
;;; Last modified date: Tue Aug 10 21:25:17 1993

;;;
;;; (1) \(\)*
;;; (2) 枝の順番
;;;

(defmacro TREX-inc (symbol &optional delta)
  (list 'setq symbol (if delta (list '+ symbol delta)
		       (list '1+ symbol))))

(defmacro TREX-dec (symbol &optional delta)
  (list 'setq symbol (if delta (list '- symbol delta)
		       (list '1- symbol))))

(defmacro num (sym)
  (list 'num* (list 'quote sym)))

(defun num* (sym)
  (TREX-read-hexa (substring (symbol-name sym) 2)))

(defun TREX-read-hexa (str)
  (let ((result 0) (i 0) (max (length str)))
    (while (< i max)
      (let ((ch (aref str i)))
	(cond((and (<= ?0 ch) (<= ch ?9))
	      (setq result (+ (* result 16) (- ch ?0))))
	     ((and (<= ?a ch) (<= ch ?f))
	      (setq result (+ (* result 16) (+ (- ch ?a) 10))))
  	     ((and (<= ?A ch) (<= ch ?F))
	      (setq result (+ (* result 16) (+ (- ch ?A) 10)))))
	(TREX-inc i)))
    result))

;;; 1 bytes : 0x00 <= C11 <= 0x7F   
;;; n bytes : 0x80 == LCCMP
;;;           2 bytes 0xA0 <= LC <= 0xAF
;;;           3 bytes 0xB0 <= LC <= 0xBB
;;;           4 bytes 0xBC <= LC <= 0xBE
;;; 2 bytes : 0x81 <= LC  <= 0x8F
;;; 3 bytes : 0x90 <= LC  <= 0x9B
;;; 4 bytes : 0x9C <= LC  <= 0x9E


(defun TREX-char-bytes (str index)
  (let ((max (length str)))
    (if (or (< index 0) (<= max index)) 0
      (let ((ch (aref str index))
	    (bytes))
	(setq bytes
	      (cond ((<= ch (num 0x7f)) 1)
		    ((= ch (num 0x80))
		     (let ((max (length str))
			   (i index))
		       (while (and (< i max)
				   (<= (num 0xa0) (aref str i))
				   (<= (aref str i) (num 0xbe)))
			 (setq ch (aref str i))
			 (cond ((<= ch (num 0xaf)) (TREX-inc i 2))
			       ((<= ch (num 0xbb)) (TREX-inc i 3))
			       ((<= ch (num 0xbe)) (TREX-inc i 4))))
		       (- i index)))
		    ((<= ch (num 0x8f)) 2)
		    ((<= ch (num 0x9b)) 3)
		    ((<= ch (num 0x9e)) 4)
		    (t 1)))
	(if (<= (+ index bytes) max) bytes 1)))))
	
(defun TREX-comp-charp (str index)
  (= (aref str index) (num 0x80)))

;;; 0x00 <= C11 <= 0x7F  : 1 bytes
;;;      Type 1-1 C11
;;; 0x80 == LCCMP        : n bytes
;;;      Type N  LCCMP LCN1 C11 ... LCN2 C21 ...  LCNn Cn1 ...
;;;             0xA0 <= LCN* <= 0xBE
;;;                 LCN* = LC + 0x20
;;;                 LCN* = 0xA0  (ASCII)
;;; 0x81 <= LC1  <= 0x8F : 2 bytes
;;;      Type 1-2 LC1 C11 :
;;;             0xA0 <= C11  <= 0xFF
;;; 0x90 <= LC2 <= 0x99  : 3 bytes
;;;      Type 2-3 LC2 C21 C22
;;;             0xA0 <= C21 <= 0xFF
;;;             0xA0 <= C22 <= 0xFF
;;; 0x9A == LCPRV1       : 3 bytes
;;;      Type 1-3 LCPRV1 LC12 C11
;;;             0xA0 <= LC12 <= 0xB7
;;;             0xA0 <= C11  <= 0xFF
;;; 0x9B == LCPRV1       : 3 bytes
;;;      Type 1-3 LCPRV1 LC12 C11
;;;             0xB8 <= LC12 <= 0xBF
;;;             0xA0 <= C11  <= 0xFF
;;; 0x9C == LCPRV2       : 4 bytes
;;;      Type 2-4 LCPRV2 LC22 C21 C22
;;;             0xC0 <= LC22 <= 0xC7
;;;             0xA0 <= C21  <= 0xFF
;;;             0xA0 <= C22  <= 0xFF
;;; 0x9D == LCPRV2       : 4 bytes
;;;      Type 2-4 LCPRV2 LC22 C21 C22
;;;             0xC8 <= LC22 <= 0xDF
;;;             0xA0 <= C21  <= 0xFF
;;;             0xA0 <= C22  <= 0xFF
;;; 0x9E == LCPRV3       : 4 bytes
;;;      Type 3-4 LCPRV3 C31 C32 C33
;;;             0xA0 <= C31 <= 0xBF
;;;             0xA0 <= C32 <= 0xFF
;;;             0xA0 <= C33 <= 0xFF
;;; char = [0x00-0x7f]\|
;;;        0x80
;;;           \(0xa0[0xa0-0xff]\|
;;;             [0xa1-0xaf][0xa0-0xff]\|
;;;             [0xb0-0xb9][0xa0-0xff][0xa0-0xff]\|
;;;             0xba[0xa0-0xb7][0xa0-0xff]\|
;;;             0xbb[0xb8-0xbf][0xa0-0xff]\|
;;;             0xbc[0xc0-0xc7][0xa0-0xff][0xa0-0xff]\|
;;;             0xbd[0xc8-0xdf][0xa0-0xff][0xa0-0xff]\|
;;;             0xbe[0xa0-0xbf][0xa0-0xff][0xa0-0xff]
;;;           \)*\|
;;;        [0x81-0x8f][0xa0-0xff]\|
;;;        [0x90-0x99][0xa0-0xff][0xa0-0xff]\|
;;;        0x9a[0xa0-0xb7][0xa0-0xff]\|
;;;        0x9b[0xb8-0xbf][0xa0-0xff]\|
;;;        0x9c[0xc0-0xc7][0xa0-0xff][0xa0-0xff]\|
;;;        0x9d[0xc8-0xdf][0xa0-0xff][0xa0-0xff]\|
;;;        0x9e[0xa0-0xbf][0xa0-0xff][0xa0-0xff]

(defun regexp-make-or (&rest body)
  (cons ':or body))

(defun regexp-make-seq (&rest body)
  (cons ':seq body))

(defun regexp-make-star (regexp)
  (list ':star regexp))

(defun regexp-make-range (from to)
  (list 'CHARSET (list ':range from to)))


(defvar regexp-allchar-regexp 
  (regexp-make-or
   (regexp-make-range 0 (num 0x7f))
   (regexp-make-seq 
    (num 0x80)
    (regexp-make-star 
     (regexp-make-or
      (regexp-make-seq
       (num 0xa0)
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (regexp-make-range (num 0xa1) (num 0xaf))
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (regexp-make-range (num 0xb0) (num 0xb9))
       (regexp-make-range (num 0xa0) (num 0xff))
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (num 0xba)
       (regexp-make-range (num 0xa0) (num 0xb7))
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (num 0xbb)
       (regexp-make-range (num 0xb8) (num 0xbf))
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (num 0xbc)
       (regexp-make-range (num 0xc0) (num 0xc7))
       (regexp-make-range (num 0xa0) (num 0xff))
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (num 0xbd)
       (regexp-make-range (num 0xc8) (num 0xdf)) 
       (regexp-make-range (num 0xa0) (num 0xff))
       (regexp-make-range (num 0xa0) (num 0xff)))
      (regexp-make-seq
       (num 0xbe)
       (regexp-make-range (num 0xa0) (num 0xbf))
       (regexp-make-range (num 0xa0) (num 0xff))
       (regexp-make-range (num 0xa0) (num 0xff))))))
   (regexp-make-seq
    (regexp-make-range (num 0x81) (num 0x8f))
    (regexp-make-range (num 0xa0) (num 0xff)))
   (regexp-make-seq
    (regexp-make-range (num 0x90) (num 0x99))
    (regexp-make-range (num 0xa0) (num 0xff))
    (regexp-make-range (num 0xa0) (num 0xff)))
   (regexp-make-seq
    (num 0x9a)
    (regexp-make-range (num 0xa0) (num 0xb7))
    (regexp-make-range (num 0xa0) (num 0xff)))
   (regexp-make-seq
    (num 0x9b)
    (regexp-make-range (num 0xb8) (num 0xbf))
    (regexp-make-range (num 0xa0) (num 0xff)))
   (regexp-make-seq
    (num 0x9c)
    (regexp-make-range (num 0xc0) (num 0xc7))
    (regexp-make-range (num 0xa0) (num 0xff))
    (regexp-make-range (num 0xa0) (num 0xff)))
   (regexp-make-seq
    (num 0x9d)
    (regexp-make-range (num 0xc8) (num 0xdf))
    (regexp-make-range (num 0xa0) (num 0xff))
    (regexp-make-range (num 0xa0) (num 0xff)))
   (regexp-make-seq
    (num 0x9e)
    (regexp-make-range (num 0xa0) (num 0xbf))
    (regexp-make-range (num 0xa0) (num 0xff))
    (regexp-make-range (num 0xa0) (num 0xff)))))
  
;;;;
;;;;
;;;;

(defun TREX-string-reverse (str)
  (if (<= (length str) 1) str
    (let ((result (make-string (length str) 0))
	  (i 0)
	  (j (1- (length str))))
      (while (<= 0 j)
	(aset result i (aref str j))
	(TREX-inc i)
	(TREX-dec j))
      result)))

(defun TREX-string-forward-anychar (str start)
  (and (stringp str) (numberp start)
       (let ((max (length str)))
	 (and (<= 0 start) 
	      (< start max)
	      (+ start (TREX-char-bytes str start))))))

(defmacro TREX-init (symbol value)
  (` (if (null (, symbol)) 
	 (setq (, symbol) (, value)))))

(defmacro TREX-push (val symbol)
  (list 'setq symbol (list 'cons val symbol)))

(defun TREX-member (elm list pred)
  (while (and list (not (funcall pred elm (car list))))
    (setq list (cdr list)))
  list)

(defun TREX-memequal (elm list)
  (while (and list (not (equal elm (car list))))
    (setq list (cdr list)))
  list)

(defun TREX-find (elm list)
  (let ((pos 0))
    (while (and list (not (equal elm (car list))))
      (setq list (cdr list))
      (TREX-inc pos))
    (if list pos
      nil)))

(defun TREX-find-if (pred list)
  (let ((pos 0))
    (while (and list (not (funcall pred (car list))))
      (TREX-inc pos)
      (setq list (cdr list)))
    (if list pos
      nil)))

(defun TREX-firstn (list n)
  (if (or (<= n 0) (null list)) nil
    (cons (car list) (TREX-firstn (cdr list) (1- n)))))

(defun TREX-delete-duplicate (list)
  (let ((result nil))
    (while list
      (let ((elm (car list)))
	(if (not (TREX-memequal elm result))
	    (TREX-push elm result)))
      (setq list (cdr list)))
    (nreverse result)))

(defun TREX-delete (elm list)
  (let ((result nil))
    (while list
      (if (not (equal elm (car list)))
	  (TREX-push (car list) result))
      (setq list (cdr list)))
    (nreverse result)))

(defun TREX-string-to-list (str)
  (let ((result nil)
	(i 0)
	(max (length str)))
    (while (< i max)
      (TREX-push (aref str i) result)
      (TREX-inc i))
    (nreverse result)))

(defun TREX-sort (list lessp &optional key)
  (if (null key)
      (sort list lessp)
    (sort list (function (lambda (x y) (funcall lessp (funcall key x) (funcall key y)))))))
  
(defun TREX-key-lessp (x y)
  (cond((symbolp x)
	(cond ((symbolp y)
	       (string-lessp x y))
	      (t;; (not (symbolp))
	       t)))
       ((numberp x)
	(cond ((numberp y)
	       (< x y))
	      ((and (consp y) (eq (car y) ':range))
	       (< x (nth 1 y)))
	      (t nil)))
       ((and (consp x) (eq (car x) ':range))
	(cond ((and (consp y) (eq (car y) ':range))
	       (< (nth 2 x) (nth 1 y)))
	      ((numberp y)
	       (< (nth 2 x) y))
	      (t nil)))
       (t nil)))

(defun TREX-lessp-car (x y)
  (let ((x (car x))
	(y (car y)))
    (TREX-key-lessp x y)))

(defmacro TREX-define-enum (&rest list)
  (list 'TREX-define-enum* (list 'quote list)))

(defun TREX-define-enum* (list)
  (let ((i 0))
    (while list
      (set (car list) i)
      (TREX-inc i)
      (setq list (cdr list)))))

;;;
;;; regexp-parse
;;;

;;;
;;; 正規表現(regular expression)
;;;
;;;  .    single character except a newline
;;;  REG* more than zero
;;;  REG+ at least once
;;;  REG? once or not at all
;;;  [...] character set
;;;  [^...]  character not set
;;;  ^    beginning of line
;;;  $    end of line
;;;  \    quote
;;;  \|   alternative
;;;  \( ... \) group and mark
;;;  \DIGIT  
;;;  \`   beginning of buffer
;;;  \'   end of buffer
;;;  \b   beginning of word or end of word
;;;  \B   not \b
;;;  \<   beginning of word
;;;  \>   end of word
;;;
;;;  \w   word-constituent character
;;;  \W   not \w
;;;  \sCODE  syntax CODE character
;;;  \SCODE  not \sCODE

;;;
;;; REG0 ::= REG1 |
;;;          REG1 "\\|" REG0
;;;
;;; REG1 ::= REG2 |
;;;          REG2 REG1
;;;
;;; REG2 ::= REG3  |
;;;          REG2 "*" |
;;;          REG2 "+" |
;;;          REG2 "?" |
;;;
;;; REG3 ::= "." |
;;;          "[" ... "]" |
;;;          "[" "^" ... "]" |
;;;          "^" |
;;;          "$" |
;;;          "\\" DIGIT |
;;;          "\\(" REG0 "\\)"

;;; 照合は正規表現の左から右へ行われる．

(defvar *regexp-word-definition* nil)

(defvar *regexp-parse-index*  nil)
(defvar *regexp-parse-end*    nil)
(defvar *regexp-parse-str*    nil)
(defvar *regexp-parse-regno*  0)

(defun regexp-error (&optional reason)
  (if (null reason) (setq reason "Bad regexp"))
    (error "Regexp-parse::%s \"%s\" * \"%s\"" reason (substring *regexp-parse-str* 0 *regexp-parse-index*)
	   (substring *regexp-parse-str* *regexp-parse-index*)))

(defun word-parse (pattern)
  (let ((*regexp-word-definition* t))
    (regexp-parse pattern)))

(defun regexp-parse (pattern)
  (let*((*regexp-parse-str* pattern)
	(*regexp-parse-index*  0)
	(*regexp-parse-end*    (length pattern))
	(*regexp-parse-regno* 0)
	(result (regexp-parse-0)))
    (if (<= *regexp-parse-end* *regexp-parse-index*)
	result
      (regexp-error))))

(defun regexp-parse-0 ()
  (let* ((result (regexp-parse-1)))
    (cond((<= *regexp-parse-end* *regexp-parse-index*)
	  result)
	 ((and (< (1+ *regexp-parse-index*) *regexp-parse-end*)
	       (= (aref *regexp-parse-str* *regexp-parse-index*) ?\\)
	       (= (aref *regexp-parse-str* (1+ *regexp-parse-index*)) ?|))
	  (TREX-inc *regexp-parse-index* 2)
	  (list ':or result (regexp-parse-0)))
	 (t result))))

(defun regexp-parse-1 ()
  (let ((results nil)
	(result2 nil))
    (while (setq result2 (regexp-parse-2))
      (TREX-push result2 results))
    (if results
	(if (cdr results)
	    (cons ':seq (nreverse results))
	  (car results))
      nil)))

(defun regexp-parse-2 ()
  (let ((result (regexp-parse-3)))
    (while (and (< *regexp-parse-index* *regexp-parse-end*)
		(TREX-memequal (aref *regexp-parse-str* *regexp-parse-index*)
			       '(?* ?+ ??)))
      (let ((ch (aref *regexp-parse-str* *regexp-parse-index*)))
	(TREX-inc *regexp-parse-index*)
	(setq result
	      (cond((= ch ?*) (list ':star result))
		   ((= ch ?+) (list ':plus result))
		   ((= ch ??) (list ':optional result))))))
    result))

(defun regexp-parse-3 ()
  (if (<= *regexp-parse-end* *regexp-parse-index*)
      nil
    (let* ((start *regexp-parse-index*)
	   (i *regexp-parse-index*)
	   (end *regexp-parse-end*)
	   (ch (aref *regexp-parse-str* i)))
      (TREX-inc *regexp-parse-index*)
      (cond ((= ch ?.) '(ANYCHAR))
	    ((= ch ?^) '(BEGLINE))
	    ((= ch ?$) '(ENDLINE))
	    ((= ch ?\[)
	     (regexp-parse-charset))
	    ((= ch ?\])
	     (setq *regexp-parse-index* start)
	     nil)
	    ((= ch ?*)
	     (setq *regexp-parse-index* start)
	     nil)
	    ((= ch ?+)
	     (setq *regexp-parse-index* start)
	     nil)
	    ((= ch ??)
	     (setq *regexp-parse-index* start)
	     nil)
	    ((and (= ch ?\\) (< (1+ i) end))
	     (setq ch (aref *regexp-parse-str* (1+ i)))
	     (TREX-inc i)
	     (TREX-inc *regexp-parse-index*)
	     (cond ((= ch ?| )
		    (setq *regexp-parse-index* start)
		    nil)
		   ((= ch ?\( )
		    (let ((result (regexp-parse-0)))
		      (cond((and (< (1+ *regexp-parse-index*) *regexp-parse-end*)
				 (= (aref *regexp-parse-str* *regexp-parse-index*) ?\\ )
				 (= (aref *regexp-parse-str* (1+ *regexp-parse-index*)) ?\) ))
			    (TREX-inc *regexp-parse-index* 2)
			    (TREX-inc *regexp-parse-regno*)
			    (if (< 9 *regexp-parse-regno*)
				(regexp-error "Too many parenth"))
			    (if *regexp-word-definition*
				result
			      (list ':mark *regexp-parse-regno* result)))
			   (t
			    (regexp-error)))))
		   ((= ch ?\) )
		    (setq *regexp-parse-index* start)
		    nil)
		   ((= ch ?` ) '(BEGBUF))
		   ((= ch ?' ) '(ENDBUF))
		   ((= ch ?b ) 
		    (if *regexp-word-definition* (regexp-error) '(WORDBOUND)))
		   ((= ch ?B ) 
		    (if *regexp-word-definition* (regexp-error) '(NOTWORDBOUND)))
		   ((= ch ?< ) 
		    (if *regexp-word-definition* (regexp-error) '(WORDBEG)))
		   ((= ch ?> ) 
		    (if *regexp-word-definition* (regexp-error) '(WORDEND)))
		   ((= ch ?w ) (list 'SYNTAXSPEC 
				     (syntax-spec-code ?w))) ;;;WORDCHAR
		   ((= ch ?W ) (list 'NOTSYNTAXSPEC
				     (syntax-spec-code ?w))) ;;;NOTWORDCHAR
		   ;;; ((= ch ?=)  'AT_DOT)
		   ((and (<= ?1 ch)
			 (<= ch ?9))
		    (if *regexp-word-definition*
			(regexp-error) (list 'DUPLICATE (- ch ?0))))
		   ((= ch ?0)
		    (regexp-error))
		   ((and (= ch ?s )
			 (< (1+ i) end))
		    (TREX-inc *regexp-parse-index*)
		    (list 'SYNTAXSPEC (syntax-spec-code (aref *regexp-parse-str* (1+ i)))))
		   ((and (= ch ?S )
			 (< (1+ i) end))
		    (TREX-inc *regexp-parse-index*)
		    (list 'NOTSYNTAXSPEC (syntax-spec-code (aref *regexp-parse-str* (1+ i)))))
		   ((and (= ch ?c )
			 (< (1+ i) end))
		    (TREX-inc *regexp-parse-index*)
		    (list 'CATEGORYSPEC (aref *regexp-parse-str* (1+ i))))
		   ((and (= ch ?C )
			 (< (1+ i) end))
		    (TREX-inc *regexp-parse-index*)
		    (list 'NOTCATEGORYSPEC (aref *regexp-parse-str* (1+ i))))
		   (t (substring *regexp-parse-str* (1+ i) (+ i 2)))))
	    (t
	     (let ((nextpos (TREX-string-forward-anychar *regexp-parse-str* i)))
	       (cond(nextpos
		     (setq *regexp-parse-index* nextpos)
		     (substring *regexp-parse-str* i nextpos))
		    (t (regexp-error)))))))))

(defun regexp-parse-charset ()
  (if (< *regexp-parse-index* *regexp-parse-end*)
      (cond((eq (aref *regexp-parse-str* *regexp-parse-index*) ?^)
	    (TREX-inc *regexp-parse-index*)
	    (regexp-parse-charset0 'CHARSET_NOT nil))
	   (t (regexp-parse-charset0 'CHARSET ;;  ':or
				     nil)))
    (regexp-error)))

(defun regexp-parse-charset0 (op list)
  (if (< *regexp-parse-index* *regexp-parse-end*)
      (cond ((eq (aref *regexp-parse-str* *regexp-parse-index*) ?\])
	     (TREX-inc *regexp-parse-index*)
	     (regexp-parse-charset1 op '("\]")))
	    (t 
	     (regexp-parse-charset1 op nil)))
    (regexp-error)))

(defun regexp-parse-charset1 (op list)
  (if (< *regexp-parse-index* *regexp-parse-end*)
      (let* ((pos0 *regexp-parse-index*)
	     (pos1 (TREX-string-forward-anychar *regexp-parse-str* pos0))
	     (pos2 (TREX-string-forward-anychar *regexp-parse-str* pos1))
	     (pos3 (TREX-string-forward-anychar *regexp-parse-str* pos2)))
	(if pos0
	         ;;; ]
	    (cond((eq (aref *regexp-parse-str* pos0) ?\])
		  (setq *regexp-parse-index* pos1)
		  ;;; returns charset form
		  (cons op (sort (nreverse list) 'TREX-charset-lessp)))
		 ;;; [^]] - [^]]
		 ((and pos1 pos2 pos3
		       (eq (aref *regexp-parse-str* pos1) ?-)
		       (not (eq (aref *regexp-parse-str* pos2) ?\])))
		  (let ((from (substring *regexp-parse-str* pos0 pos1))
			(to   (substring *regexp-parse-str* pos2 pos3)))
		    (if (and (= (length from) (length to))
			     (not (TREX-comp-charp from 0))
			     (not (TREX-comp-charp to   0))
			     (or (= (length from) 1)
				 (= (aref from 0) (aref to 0)))
			     (or (string-equal from to)  ;;; by Enami 93.08.08
				 (string-lessp from to)))
			(if (string-equal from to)
			    (TREX-push from list)
			  (TREX-push (list ':range from to) list))
		      (regexp-error)))
		  (setq *regexp-parse-index* pos3)
		  (regexp-parse-charset1 op list))
		 ;;; [^]] - ] ;;; by Enami 93.08.08
		 ((and pos1 pos2
		       (eq (aref *regexp-parse-str* pos1) ?-)
		       (eq (aref *regexp-parse-str* pos2) ?\]))
		  (TREX-push (substring *regexp-parse-str* pos0 pos1) list)
		  (TREX-push (substring *regexp-parse-str* pos1 pos2) list)
		  (setq *regexp-parse-index* pos2)
		  (regexp-parse-charset1 op list))
		 (t
		  (TREX-push (substring *regexp-parse-str* pos0 pos1)  list)
		  (setq *regexp-parse-index* pos1)
		  (regexp-parse-charset1 op list)))
	  (regexp-error)))
    (regexp-error)))
	  
(defun TREX-charset-lessp (ch1 ch2)
  (cond((and (stringp ch1) (stringp ch2))
	(string-lessp ch1 ch2))
       ((and (consp ch1) (consp ch2))
	(string-lessp (nth 2 ch1) (nth 1 ch2)))
       ((consp ch1)
	(string-lessp (nth 2 ch1) ch2))
       ((consp ch2)
	(string-lessp ch1 (nth 1 ch2)))))

;;;
;;; define-regexp
;;;

(defmacro define-regexp (name &rest forms)
  (` (define-regexp* '(, name) '(, forms))))

(defun define-regexp* (name forms)
  (put name ':regexp-has-definition t)
  (put name ':regexp-definition
       (if (= (length forms) 1)
	   (nth 0 forms)
	 (` (:seq (,@ forms))))))

(defun regexp-get-definition (name)
  (get name ':regexp-definition))

(defun regexp-define-specials (names)
  (mapcar (function (lambda (name)
		      (put name ':regexp-special t)))
		    names))

(defun regexp-has-definition (name)
  (get name ':regexp-has-definition))

(defun regexp-specialp (name)
  (get name ':regexp-special))

(defun regexp-expand-definition (regexp &optional callers)
  (cond 
   ((consp regexp)
    (let ((op (car regexp)))
      (cond((eq op ':mark)
	    (` (:mark (, (nth 1 regexp))
		      (, (regexp-expand-definition (nth 2 regexp))))))
	   ((eq op ':or)
	    (` (:or (,@ (mapcar 'regexp-expand-definition (cdr regexp))))))
	   ((eq op ':seq)
	    (` (:seq (,@ (mapcar 'regexp-expand-definition (cdr regexp))))))
	   ((eq op ':optional)
	    (` (:optional (, (regexp-expand-definition (nth 1 regexp))))))
	   ((eq op ':star)
	    (` (:star (, (regexp-expand-definition (nth 1 regexp))))))
	   ((eq op ':plus)
	    (` (:plus (, (regexp-expand-definition (nth 1 regexp))))))
	   ;;;;****
	   ((eq op ':range)
	    regexp)
	   ((regexp-specialp op)
	    regexp)
	   ((memq op callers)
	    (error "regexp defs(%s)" op))
	   ((regexp-has-definition op)
	    (regexp-expand-definition (regexp-get-definition op)
				      (cons op callers)))
	   (t
	    (error "undefined regexp(%s)" op)))))
   ((stringp regexp)
    regexp)
   ((null regexp)
    regexp)
   (t
    regexp)))

;;;
;;;  regexp-*-lessp
;;;  正規形式の全順序を定義する．
;;;

;;; nil < number < string < symbol < cons

(defun regexp-lessp (exp1 exp2)
  (cond((equal exp1 exp2)
	nil)
       ((null exp1) t)
       ((numberp exp1)
	(cond((null exp2) nil)
	     ((numberp exp2)
	      (< exp1 exp2))
	     (t t)))
       ((stringp exp1)
	(cond((or (null exp2)
		  (numberp exp2))
	      nil)
	     ((stringp exp2)
	      (string< exp1 exp2))
	     (t t)))
       ((symbolp exp1)
	(cond((or (null exp2)
		  (numberp exp2)
		  (stringp exp2))
	      nil)
	     ((symbolp exp2)
	      (string< exp1 exp2))
	     (t t)))
       ((consp exp1)
	(cond ((not (consp exp2))
	       nil)
	      ((< (length exp1) (length exp2))
	       t)
	      ((= (length exp1) (length exp2))
	       (regexp-lessp-list exp1 exp2))
	      (t nil)))))

(defun regexp-lessp-list (exp1 exp2)
  (cond((null exp1) nil)
       ((regexp-lessp (car exp1) (car exp2))
	t)
       ((equal (car exp1) (car exp2))
	(regexp-lessp-list (cdr exp1) (cdr exp2)))
       (t nil)))

;;;
;;; item = list of seq-body(== list of regexp)
;;; nil < cons
;;;

(defun regexp-item-lessp (item1 item2)
  (cond((equal item1 item2)
	nil)
       ((null item2) t)
       ((consp item1)
	(cond((consp item2)
	      (cond ((regexp-key-lessp (car item1) (car item2))
		     t)
		    ((equal (car item1) (car item2))
		     (regexp-item-lessp (cdr item1) (cdr item2)))
		    (t nil)))
	     (t nil)))))


(defun regexp-key-lessp-list (sym1 sym2 list)
  (< (TREX-find sym1 list) (TREX-find sym2 list)))

(defun regexp-key-lessp (key1 key2)
  (cond ((regexp-key-class0 key1)
	 (cond((regexp-key-class0 key2)
	       (regexp-key-lessp-list (car key1) (car key2) *regexp-key-class0*))
	      (t t)))
	((regexp-key-class1 key1)
	 (cond((regexp-key-class1 key2)
	       (regexp-key-lessp-list key1 key2 *regexp-key-class1*))
	      ((or (regexp-key-class2 key2)
		   (regexp-key-class3 key2)
		   (regexp-key-class4 key2)
		   (null key2))
	       t)))
	((regexp-key-class2 key1)
	 (cond((regexp-key-class2 key2)
	       (regexp-key-lessp-list key1 key2 *regexp-key-class2*))
	      ((or (regexp-key-class3 key2)
		   (regexp-key-class4 key2)
		   (null key2))
	       t)))
	((regexp-key-class3 key1)
	 (cond((regexp-key-class3 key2)
	       (regexp-key-lessp-list (car key1) (car key2) *regexp-key-class3*))
	      ((or (regexp-key-class4 key2)
		   (null key2))
	       t)))
	((regexp-key-class4 key1)
	 (or (null key2)
	     (and (regexp-key-class4 key2) (< key1 key2))))
	(t nil)))

(defun regexp-alist-lessp (pair1 pair2)
  (regexp-key-lessp (car pair1) (car pair2)))

;;;
;;;
;;;

(defvar *regexp-key-class0* '(START_MEMORY STOP_MEMORY))

(defvar *regexp-key-class1* '(BEGLINE ENDLINE 
				;;; BEFORE_DOT AT_DOT AFTER_DOT
				BEGBUF ENDBUF 
				WORDBEG WORDEND
				WORDBOUND NOTWORDBOUND))

(defvar *regexp-key-class2* '(ANYCHAR
			      CHARSET
			      CHARSET_NOT
                                ;;;WORDCHAR NOTWORDCHAR
				))

(defvar *regexp-key-class3* '(DUPLICATE
				SYNTAXSPEC NOTSYNTAXSPEC
				CATEGORYSPEC NOTCATEGORYSPEC
))

(regexp-define-specials *regexp-key-class0*)
(regexp-define-specials *regexp-key-class1*)
(regexp-define-specials *regexp-key-class2*)
(regexp-define-specials *regexp-key-class3*)

(defun regexp-key-class0 (key)
  (and (consp key) (TREX-memequal (car key) *regexp-key-class0*)))

(defun regexp-key-class1 (key)
  (and (consp key)
       (TREX-memequal (car key) *regexp-key-class1*)))

(defun regexp-key-class2 (key)
  (and (consp key) (TREX-memequal (car key) *regexp-key-class2*)))

(defun regexp-key-class3 (key)
  (and (consp key)
       (TREX-memequal (car key) *regexp-key-class3*)))

(defun regexp-key-class4 (key)
  (or (and (consp key) (eq (car key) ':range))
      (numberp key) (symbolp key)))

(defun regexp-item-key-class0 (item)
  (regexp-key-class0 (car item)))

(defun regexp-item-key-class1 (item)
  (regexp-key-class1 (car item)))

(defun regexp-item-key-class2 (item)
  (regexp-key-class2 (car item)))

(defun regexp-item-key-class3 (item)
  (regexp-key-class3 (car item)))

(defun regexp-item-key-class4 (item)
  (regexp-key-class4 (car item)))

;;;
;;; regexp-sort
;;; 正規表現の標準形式を求めるために整列を行う．
;;;

(defvar *regexp-sort-flag* t)
(defvar *regexp-debug* nil)

(defun regexp-sort (list pred)
  (if *regexp-sort-flag* 
      (progn
	(if *regexp-debug* (princ (format "(regexp-sort %s %s)\n" list pred)))
	(let ((result (sort list pred)))
	  (if *regexp-debug* (princ (format "<== %s\n" result)))
	  result))
    list))

;;;
;;; regexp-inverse
;;;

(defun regexp-inverse (regexp)
  (if (consp regexp)
      (let ((op (car regexp)))
	(cond((eq op ':mark)
	      (list ':mark (nth 1 regexp)
		    (regexp-inverse (nth 2 regexp))))
	     ((eq op 'DUPLICATE)
	      regexp)
	     ((eq op ':or)
	      (cons ':or (mapcar 'regexp-inverse (cdr regexp))))
	     ((eq op ':seq)
	      (cons ':seq (nreverse (mapcar 'regexp-inverse (cdr regexp)))))
	     ((eq op ':optional)
	      (list ':optional (regexp-inverse (nth 1 regexp))))
	     ((eq op ':star)
	      (list ':star (regexp-inverse (nth 1 regexp))))
	     ((eq op ':plus)
	      (list ':plus (regexp-inverse (nth 1 regexp))))
	     (t regexp)))
    (if (stringp regexp)
	(TREX-string-reverse regexp)
      regexp)))

;;;
;;; regexp-remove-infinite-loop
;;;

(defun regexp-remove-infinite-loop (regexp)
  (cond((consp regexp)
	(let ((op (car regexp)))
	  (cond((eq op ':mark)
		)
	       ((eq op 'DUPLICATE)
		regexp)
	       ((eq op ':or)
		)
	       ((eq op ':seq)
		)
	       ((eq op ':optional)
		)
	       ((eq op ':star)
		)
	       ((eq op ':plus)
		)
	       (t regexp))))
       ((stringp regexp)
	)
       ((null regexp)
	)
       (t
	regexp)))


;;;
;;; regexp-reform
;;;

(defvar *regexp-register-definitions* nil)
(defvar *regexp-registers* nil)

(defun regexp-reform-duplication (regexp)
  (let* ((*regexp-register-definitions* nil)
	 (newregexp (regexp-reform-duplication-1 regexp)))
    (let ((*regexp-registers* nil))
      (regexp-reform-duplication-2 newregexp))))

(defun regexp-reform-duplication-1 (regexp)
  (if (not (consp regexp)) regexp
    (let ((mop (car regexp)))
      (cond((eq mop ':or)
	    (cons ':or (mapcar 'regexp-reform-duplication-1
			       (cdr regexp))))
	   ((eq mop ':seq)
	    (cons ':seq (mapcar 'regexp-reform-duplication-1
				(cdr regexp))))
	   ((TREX-memequal mop '(:star :plus :optional))
	    (list mop (regexp-reform-duplication-1 (nth 1 regexp))))
	   ((eq mop ':mark)
	    (TREX-push (cons (nth 1 regexp) (nth 2 regexp))
		       *regexp-register-definitions*)
	    (list 'DUPLICATE (nth 1 regexp)))
	   (t regexp)))))

(defun regexp-reform-duplication-2 (regexp)
  (if (not (consp regexp)) regexp
    (let ((mop (car regexp)))
      (cond((eq mop ':or)
	    (let ((registers *regexp-registers*)
		  (newregisters nil)
		  (result nil)
		  (or-body (cdr regexp)))
	      (while or-body
		(setq *regexp-registers* registers)
		(TREX-push (regexp-reform-duplication-2 (car or-body)) result)
		(setq newregisters (TREX-delete-duplicate (append *regexp-registers* newregisters)))
		(setq or-body (cdr or-body)))
	      (setq *regexp-registers* newregisters)
	      (cons ':or (nreverse result))))
	   ((eq mop ':seq)
	    (cons ':seq (mapcar 'regexp-reform-duplication-2
				(cdr regexp))))
	   ((TREX-memequal mop '(:star :plus :optional))
	    (list mop (regexp-reform-duplication-2 (nth 1 regexp))))
	   ((eq mop 'DUPLICATE)
	    (let ((regno (nth 1 regexp)))
	      (if (TREX-memequal regno *regexp-registers*)
		  regexp
		(let ((def (assoc regno *regexp-register-definitions*)))
		  (TREX-push regno *regexp-registers*)
		  (if def
		      (list ':mark regno (cdr def))
		    regexp)))))
	   (t regexp)))))

;;;
;;; regexp-expand
;;; 

;;;
;;; <ISLAND> ::= ( <ITEM> ...)
;;; <ITEM>   ::= ( <SEQ-BODY> ... )
;;;

(defun regexp-expand-regexp (regexp)
  ;;; returns island
  (if (consp regexp)
      (let ((mop (car regexp)))
	(cond
      ;;;((eq mop 'CHARSET)
      ;;; (regexp-expand-charset t (cdr regexp)))
      ;;;((eq mop 'CHARSET_NOT)
      ;;; (regexp-expand-charset nil (cdr regexp)))
	 ((eq mop ':or)
	  (regexp-expand-or (cdr regexp)))
	 ((eq mop ':seq)
	  (regexp-expand-seq (cdr regexp)))
	 ((eq mop ':star)
	  (let ((arg (nth 1 regexp)))
	    (if arg
		(append  (regexp-expand-seq (list arg regexp)) (list nil))
	      (list nil))))
	 ((eq mop ':plus)
	  (let ((arg (nth 1 regexp)))
	    (if arg
		(regexp-expand-seq (list arg (list ':star arg)))
	      (list nil))))
	 ((eq mop ':optional)
	  (append (regexp-expand-regexp (nth 1 regexp)) (list nil)))
	 ((eq mop ':mark)
	  (let ((regno (nth 1 regexp))
		(arg (nth 2 regexp)))
	    (if arg
		(list (list (list 'START_MEMORY regno)
			    arg
			    (list 'STOP_MEMORY  regno)))
	      (list (list (list 'START_MEMORY regno)
			  (list 'STOP_MEMORY regno))))))
	 (t (list (list regexp)))))
    (cond((null regexp) (list nil))
	 ((symbolp regexp) (list (list regexp)))
	 ((numberp regexp) (list (list regexp)))
	 ((stringp regexp)
	  (let ((result nil))
	    (let ((i 0) (max (length regexp)))
	      (while (< i max)
		(TREX-push  (aref regexp i) result)
		(TREX-inc i))
	      (list (nreverse result)))))
	 (t (list (list regexp))))))

;;;
;;; (CHARSET "abc" ... ) == (:or (:seq "a" "b" "c") .... )
;;;
;;;  (:range "abc" "ade") == (:seq "a" (:range "bc" "de"))
;;;  (:range "bc"  "de" ) == (:or  (:seq "b" (:range "c" 0xFF))
;;;                                (:seq (:range "b"+1 "d"-1) (:range 0xA0 0xFF))
;;;                                (:seq "d" (:range 0xA0 "e")))
;;;

;;; charset::

(defun charset-member-elt (ch elt)
  (if (consp elt)
      (if (eq (nth 0 elt) ':range)
	  (and (<= ch (nth 1 elt))
	       (<= (nth 2 elt) ch))
	nil)
    (equal ch elt)))

(defun charset-member-P (ch or-form)
  (let ((result) (l (cdr or-form)))
    (while (and l (null result))
      (if (charset-membership-elt ch (car l))
	  (setq result t))
      (setq l (cdr l)))
    result))

(defun charset-member-N (ch nor-form)
  (not (charset-member+ ch nor-form)))

(defun charset-norp (form)
  (and (consp form) (eq (car form) 'CHARSET_NOT)))

(defun charset-and (form1 form2)
  (if (charset-norp form1)
      (if (charset-norp form2)
	  (cons ':or (charset-or-PP (cdr form1) (cdr form2)))
	(charset-and-PN form2 form1))
    (if (charset-norp form2)
	(charset-and-pn form1 form2)
      (charset-and-PP form1 form2))))

(defun charset-or-PP (or-body1 or-body2)
  (append or-body1 or-body2))




(defun regexp-charset-to-regexp (charsets)
  (cons ':or (mapcar 'regexp-charset-to-regexp* charsets)))

(defun regexp-charset-to-regexp* (elm)
  (cond((consp elm) (regexp-charset-range-to-regexp (nth 1 elm) (nth 2 elm)))
       ((stringp elm) (cons ':seq (TREX-string-to-list elm)))
       (t elm)))

(defun regexp-charset-range-to-regexp (str1 str2)
  (let ((result (regexp-charset-range-to-regexp* (TREX-string-to-list str1)
						 (TREX-string-to-list str2))))
    (if (= (length result) 1) (car result) (cons ':seq result))))

  
(defun regexp-charset-range-to-regexp* (nums1 nums2)
  (let ((len (length (cdr nums1)))
	(ch1 (car nums1))
	(ch2 (car nums2)))
    (if (= len 0)
	(if (= ch1 ch2) (list ch1)
	  (list (regexp-charset-range-1 ch1 ch2)))
      (if (= ch1 ch2)
	  (cons ch1 (regexp-charset-range-to-regexp* (cdr nums1) (cdr nums2)))
	(let ((part1 (cons ch1 (regexp-charset-range-to-regexp* (cdr nums1) (make-list (length (cdr nums1)) 255))))
	      (part2 (if (<= (1+ ch1) (1- ch2))
			 (cons (regexp-charset-range-1 (1+ ch1) (1- ch2))
			       (regexp-charset-range-to-regexp* (make-list len 160) (make-list len 255)))
		       nil))
	      (part3 (cons ch2 (regexp-charset-range-to-regexp* (make-list len 160) (cdr nums2)))))
	  (if part2
	      (list (list ':or (cons ':seq part1) (cons ':seq part2) (cons ':seq part3)))
	    (list (list ':or (cons ':seq part1) (cons ':seq part3)))))))))

(defun regexp-charset-range-1 (from to) (list ':range from to))

(defun regexp-charset-range-1 (from to)
  (let ((result nil))
    (while (<= from to)
      (TREX-push to result)
      (TREX-dec to))
    (cons ':or result)))

(defun regexp-charset-range-1* (from to)
  (if (not (<= from to)) nil
    (cons from (regexp-charset-range-1* (1+ from) to))))

(defvar *regexp-charset-vector* nil)

(defun regexp-expand-charset (mode charsets)
  (TREX-init *regexp-charset-vector* (make-vector 256 nil))
  (let ((i 0))
    (while (< i 256)
      (aset *regexp-charset-vector* i nil)
      (TREX-inc i)))
  (while charsets
    (cond((numberp (car charsets))
	  (aset *regexp-charset-vector* (car charsets) t))
	 ((stringp (car charsets))
	  (if (= (length (car charsets)) 1)
	      (aset *regexp-charset-vector* (aref (car charsets) 0) t)
	    (let ((list (TREX-string-to-list (car charsets))))
	      (aset *regexp-charset-vector* (car list)
		    (regexp-expand-charset-set-mark (cdr list)
						    (aref *regexp-charset-vector* (car list)))))))
	 ((and (consp (car charsets))
	       (eq (car (car charsets)) ':range))
	  (let ((from (aref (nth 1 (car charsets)) 0))
		(to   (aref (nth 2 (car charsets)) 0)))
	    (if (<= from to)
		(if (< to 128)
		    (let ((char from))
		      (while (<= char to)
			(aset *regexp-charset-vector* char t)
			(TREX-inc char)))
		  (let ((from-list (TREX-string-to-list (nth 1 (car charsets))))
			(to-list   (TREX-string-to-list (nth 2 (car charsets)))))
		    ;;; どうすんの！
		    ))))))
    (setq charsets (cdr charsets)))
  (let ((result nil)
	(i 0))
    (while (< i 256)
      (if (eq (aref *regexp-charset-vector* i) mode)
	  (TREX-push (list i) result))
      (TREX-inc i))
    (nreverse result)))


(defun regexp-expand-charset-set-mark (chars alist)
  (if (null chars) t
    (let ((place (assoc (car chars) alist)))
      (cond((null place)
	    (cons 
	     (cons (car chars)
		   (regexp-expand-charset-set-mark (cdr chars) nil))
	     alist))
	   (t
	    (setcdr place
		    (regexp-expand-charset-set-mark (cdr chars) (cdr place)))
	    alist)))))

(defun regexp-expand-or (regexps)
  (if regexps
      (append (regexp-expand-regexp (car regexps))
	      (regexp-expand-or (cdr regexps)))
    nil))

(defun regexp-expand-seq (regexps)
  (if (null regexps)
      (list nil)
    (let ((result (regexp-expand-regexp (car regexps))))
      (if (TREX-memequal nil result)
	  (let ((newresult (regexp-expand-seq (cdr regexps))))
	    (setq result (TREX-delete nil result))
	    (while result
	      (TREX-push (append (car result) (cdr regexps)) newresult)
	      (setq result (cdr result)))
	    newresult)
	(let ((newresult nil))
	  (while result
	    (TREX-push (append (car result) (cdr regexps)) newresult)
	    (setq result (cdr result)))
	  newresult)))))

(defun regexp-expand-items (items)
  (if items
      (append (regexp-expand-seq (car items))
	      (regexp-expand-items (cdr items)))
    nil))

;;;
;;; regexp-
;;;

(defun regexp-make-island (items)
  (let ((result (TREX-delete-duplicate (regexp-expand-items items))))
    (let ((l result))
      (while l
	(cond((null (car l))
	      (setcdr l nil)
	      (setq l nil))
	     (t (setq l (cdr l))))))
    result))

(defun regexp-make-island-parallel (items)
    (regexp-sort (TREX-delete-duplicate (regexp-expand-items items))
		 'regexp-item-lessp))


;;; Finate state Automaton:
;;;
;;;    FA : Non-deterministic FA
;;;  EFFA : Epsilon Free FA
;;;   DFA : Deterministic FA
;;;
;;;
;;;  DFA-optimize <- DFA <- EFFA <- NDFA <- regexp


;;;
;;; Table structure
;;;  <FA>     ::= ( <START> . <TransTables> )
;;;  <TransTables> ::= ( <Node> . <TransTable> ) ...
;;;  <TransTable> ::= ( <Key> . <Next> ) ...
;;;  <Key>    ::= <Char> | <Condition> | :epsilon
;;;

(defvar *regexp-node-to-transtable* nil)
(defvar *regexp-island-to-node* nil)
(defvar *regexp-counter* 0)

(defun FA-make (regexp)
  (setq *regexp-island-to-node* nil)
  (let ((*regexp-node-to-transtable* nil)
;;;	(*regexp-island-to-node*  nil)
	(*regexp-counter* 0))
    (let ((island (regexp-make-island (regexp-expand-regexp regexp))))
      (cons (FA-make-closure island) (nreverse *regexp-node-to-transtable*)))))

(defun FA-make-closure (island)
  (if *regexp-debug*  (princ (format "FA-make-closure %s\n" island)))
  (if (null island) nil
    (let ((place (assoc island *regexp-island-to-node*))
	  (pos nil))
      (cond(place (cdr place))
	   ;;; START_MEMORY and STOP_MEMORY （無条件，最優先で遷移するもの）
	   ((setq pos (TREX-find-if 'regexp-item-key-class0 island))
	    (let ((pre (TREX-firstn island pos))
		  (item (nth pos island))
		  (post (nthcdr (1+ pos) island)))
	      (let* ((number (TREX-inc *regexp-counter*))
		     (pair (cons (car item) nil))
		     (alist (list pair))
		     (place (cons number alist)))
		(TREX-push (cons island number) *regexp-island-to-node*)
		(TREX-push place *regexp-node-to-transtable*)
		(setcdr pair 
			(FA-make-closure 
			 (regexp-make-island (append pre (list (cdr item)) post))))
		number)))
	   ;;; BEGLINE, ENDLINE, WORDBEG, ....（長さ０のもの）
	   ;;; 遷移は 
           ;;;   KEY  --> TRUE+FALSE
           ;;;  :epsilon --> FALSE となる．
	   ((setq pos (TREX-find-if 'regexp-item-key-class1 island))
	    (let((key (car (nth pos island)))
		 (items island)
		 (result-true nil)
		 (result-false nil))
	      (while items
		(let ((item (car items)))
		  (if (equal key (car item))
		      (TREX-push (cdr item) result-true)
		    (progn
		      (TREX-push item result-true)
		      (TREX-push item result-false))))
		(setq items (cdr items)))
	      (setq result-true (nreverse result-true)
		    result-false (nreverse result-false))
	      (if (null result-false)
		  (let* ((number (TREX-inc *regexp-counter*))
			 (pair-true (cons key nil))
			 (alist (list pair-true))
			 (place (cons number alist)))
		    (TREX-push (cons island number) *regexp-island-to-node*)
		    (TREX-push place *regexp-node-to-transtable*)
		    (setcdr pair-true (FA-make-closure (regexp-make-island result-true)))
		    number)
		(let* ((number (TREX-inc *regexp-counter*))
		       (pair-true (cons key nil))
		       (pair-false (cons ':epsilon nil))
		       (alist (list pair-true pair-false))
		       (place (cons number alist)))
		  (TREX-push (cons island number) *regexp-island-to-node*)
		  (TREX-push place *regexp-node-to-transtable*)
		  (setcdr pair-true (FA-make-closure (regexp-make-island result-true)))
		  (setcdr pair-false (FA-make-closure (regexp-make-island result-false)))
		  number))))
	   (t
	    (FA-make-closure* island (FA-make-pre-alist island)))))))

;;;
;;; ここで扱うのは class2,3,4 のみ
;;;
(defun FA-make-closure* (island pre-alist)
  (if *regexp-debug* (princ (format "\nregexp-make-clousre* %s" pre-alist)))
  (let* ((number (TREX-inc *regexp-counter*))
	 (place (cons number pre-alist)))
    (TREX-push (cons island number) *regexp-island-to-node*)
    (TREX-push place *regexp-node-to-transtable*)
    (while pre-alist
      (let ((pair (car pre-alist)))
	(setcdr pair
		(FA-make-closure (regexp-make-island (cdr pair)))))
      (setq pre-alist (cdr pre-alist)))
    number))

;;;
;;; PRE-ALIST ::= ( (key . items) ... )
;;;

(defun FA-make-pre-alist (items)
  (let ((pre-alist nil))
    (while items
      (let ((item (car items)))
	(cond((or (regexp-key-class2 (car item))
		  (regexp-key-class3 (car item)))
	      (let ((key (car item))
		    (newitems nil))
		(while (and items (equal key (car (car items))))
		  (TREX-push (cdr (car items)) newitems)
		  (setq items (cdr items)))
		(setq newitems (nreverse newitems))
		(TREX-push (cons key newitems) pre-alist)))
	     ((null item)
	      (TREX-push (list nil) pre-alist)
	      (setq items (cdr items)))
	     ((regexp-key-class4 (car item))
	      (let((alist nil))
		(while (and items (regexp-key-class4 (car (car items))))
		  (let* ((newitem (car items))
			 (place (assoc (car newitem) alist)))
		    (if place
			(setcdr place
				(cons (cdr newitem) (cdr place)))
		      (TREX-push (cons (car newitem) (list (cdr newitem))) alist)))
		  (setq items (cdr items)))
		(setq alist (sort alist 'TREX-lessp-car))
		(let ((list alist))
		  (while list
		    (setcdr (car list) (nreverse (cdr (car list))))
		    (setq list (cdr list)))
		  (setq pre-alist (append alist pre-alist))
		  )))
	     (t (error "undefined items(%s)" item)))))
    (nreverse pre-alist)))

;;;
;;; FA-inverse
;;;

(defun FA-inverse (FA)
  (let ((invFA nil)
	(start (car FA))
	(table (cdr FA))
	(minnode 10000)
	(maxnode 0)
	(newtable nil)
	(newstart nil)
	(newfinal nil))
    (let ((l table))
      (while l
	(let ((n (car (car l))))
	  (if (< n minnode) (setq minnode n))
	  (if (< maxnode n) (setq maxnode n)))
	(setq l (cdr l))))
    (setq newstart (1- minnode))
    (setq newfinal (1+ maxnode))
    (setq newtable (FA-link newfinal nil nil newtable))
    (while table
      (let* ((Snode (car table))
	     (Snumber (car Snode))
	     (Salist (cdr Snode)))
	(while Salist
	  (let* ((pair (car Salist))
		 (key  (car pair))
		 (Tnumber (cdr pair)))
	    (cond((null key)
		  (setq newtable (FA-link newstart ':epsilon Snumber newtable)))
		 (t
		  (setq newtable (FA-link Tnumber key Snumber newtable))))
	    (setq Salist (cdr Salist)))))
      (setq table (cdr table)))
    (setq newtable (FA-link start ':epsilon newfinal newtable))
    ;;;; FA の final へ invFA の start から :epsilon link を張る．
    (let ((l newtable))
      (while l
	(setcdr (car l)  (reverse (cdr(car l))))
	(setq l (cdr l))))
    (setq newtable (sort newtable 'TREX-lessp-car))
    (cons newstart newtable)))

(defun FA-link (from key to table)
  (let ((place (assoc from table)))
    (cond ((null place )
	   (setq place (cons from nil))
	   (TREX-push place table)))
    (setcdr place (cons (cons key to) (cdr place)))
    table))

;;;
;;; FA-dump 
;;;

(defun FA-dump (table)
  (let ((start (car table))
	(l (cdr table)))
    (princ (format "\nstart = %d\n" start))
    (while l
      (princ (format "%3d: " (car (car l))))
      (let ((alist (cdr (car l))))
	  (cond ((numberp (car (car alist)))
		 (princ (format "%c -> %s\n" (car (car alist)) (cdr (car alist)))))
		((and (consp (car (car alist))) (TREX-memequal (car (car (car alist))) '(CATEGORYSPEC NOTCATEGORYSPEC)))
		 (princ (format "(%s %c) -> %s\n" (car (car (car alist))) (nth 1 (car (car alist))) (cdr (car alist)))))
		(t
		 (princ (format "%s -> %s\n" (car (car alist)) (cdr (car alist))))))
	  (setq alist (cdr alist))
	(while alist
	  (cond ((numberp (car (car alist)))
		 (princ (format "     %c -> %s\n" (car (car alist)) (cdr (car alist)))))
		((and (consp (car (car alist))) (TREX-memequal (car (car (car alist))) '(CATEGORYSPEC NOTCATEGORYSPEC)))
		 (princ (format "     (%s %c) -> %s\n" (car (car (car alist))) (nth 1 (car (car alist))) (cdr (car alist)))))
		(t
		 (princ (format "     %s -> %s\n" (car (car alist)) (cdr (car alist))))))
	  (setq alist (cdr alist))))
      (setq l (cdr l)))))

;;;
;;; EFFA:  Epsilon Free Finate Automaton
;;;

(defvar *FA-table* nil)
(defvar *EFFA-table* nil)

(defun EFFA-make (FA)
  (let* ((start (car FA))
	 (*FA-table* (cdr FA))
	 (newstart start)
	 (*EFFA-table* nil))
    (cons newstart (reverse (EFFA-make* start)))))

(defun EFFA-make* (node)
  (let ((place (assoc node *EFFA-table*)))
    (cond((null place)
	  (let ((place (cons node nil)))
	    (TREX-push place *EFFA-table*)
	    (setcdr place
		    (reverse (EFFA-make-alist nil (cdr (assoc node *FA-table*))
						     (list node))))
	    (let ((alist (cdr place)))
	      (while alist
		(cond((car (car alist))
		      (EFFA-make* (cdr (car alist)))))
		(setq alist (cdr alist))))))))
  *EFFA-table*)
    
(defun EFFA-make-alist (newalist alist set)
  (while alist
    (let ((node (cdr (car alist))))
      (cond((eq (car (car alist)) ':epsilon)
	    (cond((not (TREX-memequal node set))
		  (TREX-push node set)
		  (setq newalist 
			(EFFA-make-alist newalist (cdr (assoc node *FA-table*)) set)))))
	   (t
	    (TREX-push (car alist) newalist))))
    (setq alist (cdr alist)))
  newalist)
      
;;;
;;;  DFA:  Deterministic Finate Automata
;;;
  
(defvar *DFA-node-counter* nil)

(defvar *DFA-node-definitions* nil
  "List of FD-nodes to node number")

(defvar *DFA-table* nil
  "node number to alist")

(defun DFA-make (EFFA)
  (let ((start (car EFFA))
	(*EFFA-table* (cdr EFFA))
	(*DFA-node-counter* 0)
	(*DFA-node-definitions* nil )
	(*DFA-table* nil))
    (DFA-make-1 (list start))
    (cons (cdr (assoc (list start) *DFA-node-definitions*)) *DFA-table*)))

(defun DFA-make-1 (states)
  (let ((place (assoc states *DFA-node-definitions*)))
    (cond((null place)
	  (TREX-inc *DFA-node-counter*)
	  (setq place (cons states *DFA-node-counter*))
	  (TREX-push place *DFA-node-definitions*)
	  (let ((pair (cons *DFA-node-counter* nil)))
	    (TREX-push pair *DFA-table*)
	    (setcdr pair (DFA-make-pre-alist (DFA-collect-alist states)))
	    (let ((alist (cdr pair)))
	      (while alist
		(let ((top (car alist)))
		  (if (car top)
		      (setcdr top
			      (DFA-make-1 (cdr top)))))
		(setq alist (cdr alist))))
	    )))
    (cdr place)))

(defun DFA-collect-alist (states)
  (let ((result nil))
    (while states
      (setq result (append (cdr (assoc (car states) *EFFA-table*)) result))
      (setq states (cdr states)))
    result))
	    	    
(defun DFA-make-pre-alist (oldAlist)
  (let ((pre-alist nil))
    (while oldAlist
      (let ((oldKey (car (car oldAlist))))
	(cond((or (regexp-key-class0 oldKey)
		  (regexp-key-class1 oldKey)
		  (regexp-key-class2 oldKey)
		  (regexp-key-class3 oldKey))
	      (let ((key oldKey)
		    (newAlist nil))
		(while (and oldAlist (equal key (car (car oldAlist))))
		  (TREX-push (cdr (car oldAlist)) newAlist)
		  (setq oldAlist (cdr oldAlist)))
		(setq newAlist (nreverse newAlist))
		(TREX-push (cons key newAlist) pre-alist)))
	     ((regexp-key-class4 oldKey)
	      (let((alist nil))
		(while (and oldAlist (regexp-key-class4 (car (car oldAlist))))
		  (let ((place (assoc (car (car oldAlist)) alist)))
		    (if place
			(setcdr place
				(cons (cdr (car oldAlist)) (cdr place)))
		      (TREX-push (cons (car (car oldAlist)) (list(cdr (car oldAlist)))) alist)))
		  (setq oldAlist (cdr oldAlist)))
		(setq alist (sort alist 'TREX-lessp-car))
		(let ((list alist))
		  (while list
		    (setcdr (car list) (reverse (cdr (car list))))
		    (setq list (cdr list)))
		  (setq pre-alist (append alist pre-alist))
		  )))
	     ((null oldKey)
	      (TREX-push (list nil) pre-alist)
	      (setq oldAlist (cdr oldAlist)))
	     (t 
	      (setq oldAlist (cdr oldAlist))))))
    (nreverse pre-alist)))

;;;
;;; DFA-optimize
;;; ここでの最適化は照合順序を保存する．
;;; longer match などをする場合は変更する必要がある．

(defvar *DFA-optimize-debug* nil)

(defvar *DFA-optimize-groups* nil)
(defvar *DFA-optimize-node*    1)

(defun DFA-optimize (FA)
  (if *DFA-optimize-debug* (terpri))
  (let* ((start (car FA))
	 (table (cdr FA))
	 (*DFA-optimize-node* 1)
	 (*DFA-optimize-groups*
	  (list (cons *DFA-optimize-node*  (mapcar 'car table)))))
    (while
	(catch 'DFA-optimize-changed
	  (let ((groups *DFA-optimize-groups*))
	    (while groups
	      (if *DFA-optimize-debug*
		  (princ (format "\nGroups to be checked: %s\n" groups)))
	      (let* ((Sgroup (car groups))
		     (Sgroup-number (car Sgroup))
		     (oldgroup (cdr Sgroup))
		     (newgroup nil)
		     (Smembers oldgroup))
		(if *DFA-optimize-debug*
		    (princ (format " Sgroup-number: %s = %s\n" Sgroup-number Smembers)))
		(while Smembers
		  (let* ((Snumber (car Smembers))
			 (Salist (cdr (assoc Snumber table))))
		    (if *DFA-optimize-debug*
			(princ (format "  Snumber: %s\n" Snumber)))
		    (let ((Tmembers (cdr Smembers)))
		      (while Tmembers
			(if (not (eq Snumber (car Tmembers)))
			    (let* ((Tnumber (car Tmembers))
				   (Talist (cdr (assoc Tnumber table)))
				   (Salist Salist))
			      (if *DFA-optimize-debug*
				  (princ (format "   Tnumber: %s\n" Tnumber)))
			      (while (and Talist Salist
					  (equal (car (car Talist))
						 (car (car Salist))) ;;; key
					  (equal (DFA-optimize-group-number 
						  (cdr (car Talist)))
						 (DFA-optimize-group-number
						  (cdr (car Salist))) ;;; next group
						 ))
				(if *DFA-optimize-debug*
				    (progn
				      (princ (format "   Skey: %s -> %s(%s)\n"
						     (car (car Salist))
						     (cdr (car Salist))
						     (DFA-optimize-group-number (cdr (car Salist)))))
				      (princ (format "   Tkey: %s -> %s(%s)\n"
						     (car (car Talist))
						     (cdr (car Talist))
						     (DFA-optimize-group-number (cdr (car Talist)))))))
				(setq Talist (cdr Talist)
				      Salist (cdr Salist)))
			      (cond((or Talist Salist)
				    (setq newgroup (cons Tnumber newgroup)
					  oldgroup (TREX-delete Tnumber oldgroup))
				    (if *DFA-optimize-debug*
					(princ(format "     oldGroup : %s\n     newGroup : %s\n" oldgroup newgroup)))))
			      ))
			(setq Tmembers (cdr Tmembers)))))
		  (cond (newgroup
			 (if *DFA-optimize-debug*
			     (princ (format "Changed :%s --> " Sgroup)))
			 (setcdr Sgroup oldgroup)
			 (if *DFA-optimize-debug*
			     (princ (format "%s" Sgroup)))
			 (TREX-inc *DFA-optimize-node*)
			 (if *DFA-optimize-debug*
			     (princ (format "+%s\n" (cons *DFA-optimize-node* newgroup))))
			 (TREX-push (cons *DFA-optimize-node* newgroup) *DFA-optimize-groups*)
			 (throw 'DFA-optimize-changed t)))
		  (setq Smembers (cdr Smembers))))
	      (setq groups (cdr groups))))))
    ;;;
    ;;; 
    (if *DFA-optimize-debug*
	(princ (format "table: %s\n" table)))
    (if *DFA-optimize-debug*
	(princ (format "groups: %s\n" *DFA-optimize-groups*)))
    (let ((newtable nil)
	  (newstart nil)
	  (groups *DFA-optimize-groups*))

      ;;; start node を探す
      (let ((l *DFA-optimize-groups*))
	(while l
	  (cond((TREX-memequal start (cdr (car l)))
		(setq newstart (car (car l)))
		(setq l nil))
	       (t
		(setq l (cdr l))))))

      ;;; 新しい transTable を作る．
      (while groups
	(let* ((group (car groups))
	       (group-number (car group))
	       (member-number (car (cdr group)))
	       (member-alist (cdr (assoc member-number table))))
	  (TREX-push (cons group-number
				(let ((group-alist nil))
				  (while member-alist
				    (let ((Mkey (car (car member-alist)))
					  (Mnext (cdr (car member-alist))))
				      (TREX-push  (cons Mkey (DFA-optimize-group-number Mnext))
						  group-alist))
				    (setq member-alist (cdr member-alist)))
				  (nreverse group-alist)))
		     newtable)
	  (setq groups (cdr groups))))
      (cons newstart newtable))))

(defun DFA-optimize-group-number (node)
  (let ((l *DFA-optimize-groups*) (result nil))
    (while l
      (cond((TREX-memequal node (cdr (car l)))
	    (setq result (car (car l))
		  l nil))
	   (t (setq l (cdr l)))))
    result))

(defun DFA-optimize-parallel (FA)
  (if *DFA-optimize-debug* (terpri))
  (let* ((start (car FA))
	 (table (cdr FA))
	 (*DFA-optimize-node* 1)
	 (*DFA-optimize-groups*
	  (list (cons *DFA-optimize-node*  (mapcar 'car table)))))
    (while
	(catch 'DFA-optimize-changed
	  (let ((groups *DFA-optimize-groups*))
	    (while groups
	      (if *DFA-optimize-debug*
		  (princ (format "\nGroups to be checked: %s\n" groups)))
	      (let* ((Sgroup (car groups))
		     (Sgroup-number (car Sgroup))
		     (oldgroup (cdr Sgroup))
		     (newgroup nil)
		     (Smembers oldgroup))
		(if *DFA-optimize-debug*
		    (princ (format " Sgroup-number: %s = %s\n" Sgroup-number Smembers)))
		(while Smembers
		  (let* ((Snumber (car Smembers))
			 (Salist (cdr (assoc Snumber table))))
		    (if *DFA-optimize-debug*
			(princ (format "  Snumber: %s\n" Snumber)))
		    (while Salist
		      (let* ((Spair (car Salist))
			     (Skey (car Spair))
			     (Snext (cdr Spair))
			     (Snext-group (DFA-optimize-group-number Snext))
			     (Tmembers oldgroup))
			(if *DFA-optimize-debug*
			    (princ (format "   Skey: %s -> %s(%s)\n" Skey Snext-group Snext)))
			(while Tmembers
			  (if (not (eq Snumber (car Tmembers)))
			      (let* ((Tnumber (car Tmembers))
				     ;;; 要再検討
				     (Tpair (assoc Skey (cdr (assoc Tnumber table))))
				     (Tnext (cdr Tpair))
				     (Tnext-group (DFA-optimize-group-number (cdr Tpair))))
				(if *DFA-optimize-debug*
				    (princ (format "    Tnumber: %s :  %s -> %s(%s)\n" Tnumber (car Tpair)
						   (DFA-optimize-group-number (cdr Tpair))(cdr Tpair))))
				(cond((and (equal Spair '(nil))
					   (equal Tpair '(nil))))
				     ((and Skey (equal Snext-group Tnext-group)))
				     (t
				      (TREX-push Tnumber newgroup)
				      (setq oldgroup (TREX-delete Tnumber oldgroup))
				      (if *DFA-optimize-debug*
					  (princ(format (format "     oldGroup : %s\n     newGroup : %s\n" oldgroup newgroup))))
				      ))))
			  (setq Tmembers (cdr Tmembers)))
			(cond (newgroup
			       (if *DFA-optimize-debug*
				   (princ (format "Changed :%s --> " Sgroup)))
			       (setcdr Sgroup oldgroup)
			       (if *DFA-optimize-debug*
				   (princ (format "%s" Sgroup)))
			       (TREX-inc *DFA-optimize-node*)
			       (if *DFA-optimize-debug*
				   (princ (format "+%s\n" (cons *DFA-optimize-node* newgroup))))
			       (TREX-push (cons *DFA-optimize-node* newgroup) *DFA-optimize-groups*)
			       (throw 'DFA-optimize-changed t))))
		      (setq Salist (cdr Salist))))
		  (setq Smembers (cdr Smembers))))
	      (setq groups (cdr groups))))))
    ;;;
    ;;; 
    (if *DFA-optimize-debug*
	(princ (format "table: %s\n" table)))
    (if *DFA-optimize-debug*
	(princ (format "groups: %s\n" *DFA-optimize-groups*)))
    (let ((newtable nil)
	  (newstart nil)
	  (groups *DFA-optimize-groups*))

      ;;; start node を探す
      (let ((l *DFA-optimize-groups*))
	(while l
	  (cond((TREX-memequal start (cdr (car l)))
		(setq newstart (car (car l)))
		(setq l nil))
	       (t
		(setq l (cdr l))))))

      ;;; 新しい transTable を作る．
      (while groups
	(let* ((group (car groups))
	       (group-number (car group))
	       (member-number (car (cdr group)))
	       (member-alist (cdr (assoc member-number table))))
	  (TREX-push   (cons group-number
				(let ((group-alist nil))
				  (while member-alist
				    (let ((Mkey (car (car member-alist)))
					  (Mnext (cdr (car member-alist))))
				      (TREX-push  (cons Mkey 
							(if (consp Mnext)
							    (cons (DFA-optimize-group-number (car Mnext))
								  (DFA-optimize-group-number (cdr Mnext)))
							  (DFA-optimize-group-number Mnext)))
						  group-alist))
				    (setq member-alist (cdr member-alist)))
				  group-alist))
		       newtable)
	  (setq groups (cdr groups))))
      (cons newstart newtable))))



;;;
;;; Non Empty Finite Automata
;;;

(defun NEFA-make (EFFA)
  (let* ((start (car EFFA))
	 (table (cdr EFFA))
	 (Salist (cdr (assoc start table))))
    (cond((equal Salist '((nil)))
	  nil)
	 ((and (assoc nil Salist)
	       (progn
		 (while (and Salist (not (equal start (cdr (car Salist)))))
		   (setq Salist (cdr Salist)))
		 Salist))
	  (let ((min 10000)
		(max -10000)
		(l table))
	    (while l
	      (if (< (car (car l)) min)
		  (setq min (car (car l))))
	      (if (< max (car (car l)))
		  (setq max (car (car l))))
	      (setq l (cdr l)))
	    (let* ((newstart (1- min))
		   (newtable (copy-alist table))
		   (oldSalist (cdr (assoc start table)))
		   (newSalist (TREX-delete '(nil) (copy-alist  oldSalist))))
	      (cons newstart
		    (cons (cons newstart newSalist) newtable)))))
	 (t
	  EFFA))))

;;;
;;; Simplify FA
;;;

(defvar *FA-simplify-table* nil)

(defun FA-simplify (FA)
  (let ((start (car FA))
	(table (cdr FA))
	(newtable nil)
	(*FA-simplify-table* nil))
    (FA-simplify-mark start table)
    (while *FA-simplify-table*
      (TREX-push  (assoc (car *FA-simplify-table*) table) newtable)
      (setq *FA-simplify-table* (cdr *FA-simplify-table*)))
    (cons start newtable)))
    
(defun FA-simplify-mark (node table)
  (cond ((not (TREX-memequal node *FA-simplify-table*))
	 (TREX-push node *FA-simplify-table*)
	 (let ((alist (cdr (assoc node table))))
	   (while alist
	     (cond((car (car alist))
		   (FA-simplify-mark (cdr (car alist)) table)))
	     (setq alist (cdr alist)))))))

;;;
;;;  Shortest match DFA
;;;

(defun DFA-shortest-match (DFA)
  (let ((start (car DFA))
	(table (cdr DFA))
	(newtable nil))
    (while table
      (cond ((assoc nil (cdr (car table)))
	     (TREX-push  (cons (car (car table)) '((nil))) newtable))
	    (t
	     (TREX-push (car table) newtable)))
      (setq table (cdr table)))
    (cons start newtable)))

;;;
;;;  Fastmap computation
;;;

(defvar *DFA-fastmap-chars*    nil)
(defvar *DFA-fastmap-syntax*   nil)
(defvar *DFA-fastmap-category* nil)
(defvar *DFA-fastmap-init* 0 )
(defvar *DFA-fastmap-pos*  1 ) ;;; SYNTAXSPEC or CATEGORYSPEC
(defvar *DFA-fastmap-neg*  2 ) ;;; NOTSYNTAXSPEC or NOTCATEGORYSPEC

;;;; すべての char は只一つの syntaxspec に属する
;;;; ==> syntaxspec(ch) and notsyntaxspec(ch) --> all char
;;;; ==> notsyntaxspec(ch1) and notsyntaxspec(ch2) --> all char
;;;; ==> notsyntaxspec(ch1) and syntaxspec(ch2) == notsyntaxspec(ch1)
;;;; つまり notsyntaxspec は高々１つしかない．

(defun DFA-code-with-fastmap (DFA)
  (TREX-init *DFA-fastmap-chars* (make-vector 256 nil))
  (TREX-init *DFA-fastmap-syntax* (make-vector 256 nil))
  (TREX-init *DFA-fastmap-category* (make-vector 256 nil))
  (let ((code (regexp-code-gen DFA))
	(start (car DFA))
	(*DFA-fastmap-table* (cdr DFA))
	(*DFA-fastmap-mark* nil)
	(*DFA-fastmap-special* nil))
    (let ((i 0))
      (while (< i 256)
	(aset *DFA-fastmap-chars* i    nil)
	(aset *DFA-fastmap-syntax* i   nil)
	(aset *DFA-fastmap-category* i nil)
	(TREX-inc i)))
    (DFA-fastmap-collect start)
    (let ((fastmap (if *DFA-fastmap-special* 
		       nil ;;;(make-string 256 1)
		     (make-string 256 0)))
	  (fastmap-entries 0)
	  (syntax (if *DFA-fastmap-special* 
		      nil 
		    (make-string 256 0)))
	  (syntax-entries 0)
	  (notsyntax-entries 0)
	  (category (if *DFA-fastmap-special*
			nil
		      (make-string 256 0)))
	  (category-entries 0))
      (let ((result (make-vector 4 nil)))
	(aset result 0 code)
	(if *DFA-fastmap-special*
	    (progn
	      (aset result 1 fastmap)
	      (aset result 2 syntax)
	      (aset result 3 category))
	  (progn
	    (let ((i 0))
	      (while (< i 256)
		(if (aref *DFA-fastmap-chars* i)
		    (progn
		      (TREX-inc fastmap-entries)
		      (aset fastmap i 1)))
		(aset syntax i
		      (cond((null (aref *DFA-fastmap-syntax* i))
			    *DFA-fastmap-init*)
			   ((eq (aref *DFA-fastmap-syntax* i) 'SYNTAXSPEC)
			    (TREX-inc syntax-entries)
			    *DFA-fastmap-pos*)
			   ((eq (aref *DFA-fastmap-syntax* i) 'NOTSYNTAXSPEC)
			    (TREX-inc notsyntax-entries)
			    (TREX-inc syntax-entries)
			    *DFA-fastmap-neg*)))
		(aset category i
		      (cond((null (aref *DFA-fastmap-category* i))
			    *DFA-fastmap-init*)
			   ((eq (aref *DFA-fastmap-category* i) 'CATEGORYSPEC)
			    (TREX-inc category-entries)
			    *DFA-fastmap-pos*)
			   ((eq (aref *DFA-fastmap-category* i) 'NOTCATEGORYSPEC)
			    (TREX-inc category-entries)
			    *DFA-fastmap-neg*)))
		(TREX-inc i)))

	    (cond((<= 2 notsyntax-entries)
		  (setq fastmap (make-string 256 1)
			syntax nil
			category nil))
		 ((= 1 notsyntax-entries)
		  (let ((ch 0))
		    (while (< ch 256)
		      (if (= (aref syntax ch) *DFA-fastmap-neg*)
			  (aset syntax ch *DFA-fastmap-init*)
			(aset syntax ch *DFA-fastmap-pos*))
		      (TREX-inc ch)))))
	    (aset result 1 fastmap)
	    (aset result 2 syntax)
	    (aset result 3 category)))
	result))))

(defun DFA-fastmap-collect (node)
  (if (TREX-memequal node *DFA-fastmap-mark*) nil
    (let ((alist (cdr (assoc node *DFA-fastmap-table*))))
      (TREX-push node *DFA-fastmap-mark*)
      (while alist
	(let ((key (car (car alist))))
	  (cond((numberp key)
		(aset *DFA-fastmap-chars* key t))
	       ((symbolp key);;; can be null
		(setq *DFA-fastmap-special* t))
	       (t
		(let ((op (car key)))
		  (cond
		   ((TREX-memequal op '(START_MEMORY STOP_MEMORY))
		    (DFA-fastmap-collect (cdr (car alist))))
		   ((TREX-memequal op '(SYNTAXSPEC NOTSYNTAXSPEC))
		    (let ((specch (syntax-code-spec (nth 1 key))))
		      (cond((null (aref *DFA-fastmap-syntax* (nth 1 key)))
			    (aset *DFA-fastmap-syntax* specch op))
			   ((not (eq (aref *DFA-fastmap-syntax* specch) op))
			    (setq *DFA-fastmap-special* t)))))
		   ((TREX-memequal op '(CATEGORYSPEC NOTCATEGORYSPEC))
		    (let ((specch (nth 1 key)))
		      (cond((null (aref *DFA-fastmap-category* specch))
			    (aset *DFA-fastmap-category* specch op))
			   ((not (eq (aref *DFA-fastmap-category* specch) op))
			    (setq *DFA-fastmap-special* t)))))
		   ((TREX-memequal op '(CHARSET CHARSET_NOT))
		    (let ((list (cdr key)))
		      (while list
			(let ((from nil) (to nil))
			  (cond((stringp (car list))
				(setq from (aref (car list) 0)
				      to   (aref (car list) 0)))
			       (t ;;; :range
				(setq from (aref (nth 1 (car list)) 0)
				      to   (aref (nth 2 (car list)) 0))))
			  (while (<= from to)
			    (cond((null (aref *DFA-fastmap-chars* from))
				  (aset *DFA-fastmap-chars* from 
					(if (eq op 'CHARSET_NOT) 'CHARSET_NOT
					  t))))
			    (TREX-inc from)))
			(setq list (cdr list))))
		    (if (eq op 'CHARSET_NOT)
			(let ((i 0))
			  (while (< i 256)
			    (cond((null (aref *DFA-fastmap-chars* i))
				  (aset *DFA-fastmap-chars* i t))
				 ((eq (aref *DFA-fastmap-chars* i) 'CHARSET_NOT)
				  (aset *DFA-fastmap-chars* i nil)))
			    (TREX-inc i)))))
		   (t
		    (setq *DFA-fastmap-special* t)))))))
	(setq alist (cdr alist))))))

;;;
;;; 正規表現コードの命令表
;;;

(TREX-define-enum 
  UNUSED
  EXACTN
  BEGLINE
  ENDLINE
  JUMP     
  ON_FAILURE_JUMP
  FINALIZE_JUMP
  MAYBE_FINALIZE_JUMP
  DUMMY_FAILURE_JUMP
  ANYCHAR
  CHARSET
  CHARSET_NOT
  START_MEMORY
  STOP_MEMORY
  DUPLICATE
  BEFORE_DOT  ;;; not used
  AT_DOT      ;;; not used
  AFTER_DOT   ;;; not used
  BEGBUF
  ENDBUF
  WORDCHAR    ;;; not used
  NOTWORDCHAR ;;; not used
  WORDBEG
  WORDEND
  WORDBOUND
  NOTWORDBOUND
  SYNTAXSPEC
  NOTSYNTAXSPEC
;;;
;;; extended instructions
;;;
  EXACT1
  EXACT2
  EXACT3
  CHARSET_M
  CHARSET_M_NOT
  CASE
  SUCCESS_SHORT ;;; == ON_FAILURE_SUCCESS
  SUCCESS
  POP
  EXECPT0 ;;; ALLCHAR
  EXECPT1
  CATEGORYSPEC
  NOTCATEGORYSPEC
  )

(defvar ON_FAILURE_SUCCESS SUCCESS_SHORT)

;;;
;;; ANYCHAR = EXECPT1 \n
;;; ALLCHAR = EXECPT0


;;;
;;;  正規表現照合器の命令体系
;;;
;;;  UNUSED
;;;  EXACTN n ch1 ch2 ... chn
;;;  BEGLINE
;;;  ENDLINE
;;;  JUMP disp[2]
;;;  ON_FAILURE_JUMP disp[2]
;;;  FINALIZE_JUMP disp[2]
;;;  MAYBE_FINALIZE_JUMP disp[2]
;;;  DUMMY_FAILURE_JUMP disp[2]
;;;  ANYCHAR
;;;  CHARSET n b1 b2 ... bn
;;;**CHARSET 0xff l1 l2 cf1 ct1 cf2 ct2 ... cfn ctn
;;;  CHARSET_NOT n b1 b2 ... bn
;;;**CHARSET_NOT 0xff l1 l2 cf1 ct1 cf2 ct2 ... cfn ctn
;;; 以下はえなみ氏の提案による新たなセマンティックス
;;
;;;  CHARSET n      b1 b2 ... bn  (n < 0x80)
;;;  CHARSET n+0x80 b1 b2 ...     bn  
;;;                |<-- n bytes -->|
;;;         lh lo CHARF1 CHART1 ....  CHARFm CHARTm 
;;;               |<-  lh << 8 + lo bytes         ->|
;;	CHARSET n b1 b2 ... bn lh lo cf1 ct1 cf2 ct2 ... cfn ctn
;;	         |<- bitmap ->|     |<-     range table       ->|
;;	CHARSET_NOT n b1 b2 ... bn lh lo cf1 ct1 cf2 ct2 ... cfn ctn
;;	CHARSETM m n b1 b2 ... bn lh lo cf1 ct1 cf2 ct2 ... cfn ctn
;;	CHARSETM_NOT m n b1 b2 ... bn lh lo cf1 ct1 cf2 ct2 ... cfn ctn
;;
;;	  o cfx, ctx 以外はすべて 1byte.  cfx, ctx は multi byte
;;	    character.
;;
;;	  o CHARSET(_NOT) と CHARSETM(_NOT) との違いは, CHARSETM(_NOT) 
;;	    の場合には bitmap の先頭の m bytes が省かれている点.
;;
;;	  o b1 ... bn (つまり bitmapの長さ)は, (n & 0x7f) bytes.  n の
;;	    分 1byte は含まない.
;;
;;	  o lh 以下は n & 0x80 が 0 なら存在しない.
;;
;;	  o lh から ctn までの長さ(つまり range table の長さ) は ((lh
;;	    << 8) + lo) byte.  lh と lo の 2byte を含む.  (上の n の場
;;	    合と違いますが, 統一したほうがいいかな?).
;;
;; 	  o cfx は multi byte character で, cfx と ctx の leading char 
;;	    は同じでないといけない.  また, cfx の leading char は 0 で
;;	    あってはいけない(range table に leading char が 0 (ASCIIと
;;	    か) の文字があっても, 現在は fastmap に反映されないから).
;;
;;;  START_MEMORY regno
;;;  STOP_MEMORY regno
;;;  DUPLICATE regno
;;;  BEFORE_DOT   ;;; not used
;;;  AT_DOT       ;;; not used
;;;  AFTER_DOT    ;;; not used
;;;  BEGBUF
;;;  ENDBUF
;;;  WORDCHAR     ;;; not used
;;;  NOTWORDCHAR  ;;; not used
;;;  WORDBEG
;;;  WORDEND
;;;  WORDBOUND
;;;  NOTWORDBOUND
;;;  SYNTAXSPEC ch
;;;  NOTSYNTAXSPEC ch

;;;
;;;  拡張命令（TREXで使用するもの）
;;;
;;;  EXACT1 ch
;;;  EXACT2 ch1 ch2
;;;  EXACT3 ch1 ch2 ch3
;;;  CHARSETM m n b1 b2 .. bn
;;;    charset の bitmaps のうち先頭の m bytes を省いたもの
;;;  CHARSETM_NOT m n b1 b2 .. bn
;;;    charset_not の bitmaps のうち先頭の m bytes を省いたもの
;;;  CASE n disp[1] disp[2] ... disp[n] l u ind[l] ... ind[u]
;;;    最初に n 個の jump relative address(2bytes) が続き，
;;;    次にcharacter code l から m までの分のindex(1byte)が続く．
;;;  ON_FAILURE_SUCCESS
;;;    alternative stack を空にし，pend を push する．
;;;  SUCCESS
;;;    pend へジャンプする．
;;;  POP
;;;    alternative stack を pop する．

;;;  RANGE ch1 ch2
;;;  RANGE_A == RANGE 0xA0 0xFF  


;;;  [^α]β\|γ の意味：
;;;     on_failure_jump L1
;;;     on_failure_jump L2
;;;     α
;;;     pop
;;;     fail
;;; L1: ALLCHAR
;;;     β
;;; L2: pop
;;;     γ

;;;
;;;  regexp-code-*
;;;

(defvar *regexp-code-buffer* (get-buffer-create " *regexp-code-buffer*"))

(defun regexp-code-gen (FA)
  (let ((start (car FA))
	(table (cdr FA))
	(*table* (cdr FA))
	(*labels* nil)
	(*final* nil)
	(*counter* 0))
    (let ((list table))
      (while (and list (null *final*))
	(if (equal '((nil)) (cdr (car list)))
	    (setq *final* (car (car list))))
	(setq list (cdr list))))
    (cond((null *final*)
	  (setq *final* (1+ (length table)))
	  (setq *counter* (1+ *final*)))
	 (t 
	  (setq *counter* (1+ (length table)))))
    (save-excursion
      (set-buffer *regexp-code-buffer*)
      (let ((kanji-flag nil)
	    (mc-flag nil))
	(erase-buffer)
	(regexp-code-gen* start)
	(buffer-substring (point-min) (point-max)))
      )))

(defun regexp-code-gen* (node)
  (cond((= node *final*)
	(if (null (assoc node *labels*))
	    (TREX-push  (cons node (point)) *labels*))
	(insert SUCCESS))
       ((null (assoc node *labels*))
	(TREX-push (cons node (point)) *labels*)
	(let ((alist (cdr (assoc node *table*))))
	  (cond((equal '((nil)) alist)
		(insert SUCCESS))
	       (t (regexp-code-gen-alist alist)))))
       (t
	(let ((disp (- (cdr (assoc node *labels*)) (+ (point) 3))))
	  (insert JUMP
		  (logand disp 255)
		  (/ (logand disp (* 255 256)) 256))))))

(defvar *regexp-charset-table* nil)
(defvar *regexp-case-table* nil)

(defun regexp-code-gen-alist (alist)
  (TREX-init *regexp-charset-table* (make-vector 256 nil))
  (TREX-init *regexp-case-table* (make-vector 256 nil))
  (if (eq (car (car alist)) nil)
      nil
    (let ((nextalist alist)
	  (numberkey nil)
	  (point nil)
	  (min 256) (max -1) (nexts nil) (nodealist nil))
      (cond((numberp (car (car alist)))
	    (setq numberkey t)
	    (let ((i 0))
	      (while (< i 256)
		(aset *regexp-case-table* i nil)
		(TREX-inc i)))

	    (while (and nextalist
			(numberp (car (car nextalist))))
	      (let ((ch (car (car nextalist)))
		    (next (cdr (car nextalist))))
		(let ((place (assoc next nodealist)))
		  (if place
		      (setcdr place
			      (cons ch (cdr place)))
		    (TREX-push  (cons ch (list next)) nodealist)))
		(aset *regexp-case-table* ch next)
		(if (< ch min) (setq min ch))
		(if (< max ch) (setq max ch))
		(if (not (TREX-memequal next nexts))
		    (TREX-push next nexts)))
	      (setq nextalist (cdr nextalist))))
	   (t (setq nextalist (cdr alist))))

      (if nextalist
	  (cond((eq (car (car nextalist)) nil)
		(insert ON_FAILURE_SUCCESS )) ;;; SUCCESS_SHORT
	       (t
		(insert ON_FAILURE_JUMP 0 0)
		(setq point (point)))))

      (cond(numberkey
	    (cond((= min max)
                ;;; exact1
		  (regexp-code-gen-exact (list min) (car nexts)))

		 ((= (length nexts) 1)
                ;;; charset or charset_not
		  (if (= (length alist) 256)
		      (insert EXECPT0)	;92.10.26 by T.Saneto
		    (let ((not_min 256)
			  (not_max -1)
			  (ch 0)
			  (mode (car nexts)))
		      (while (< ch 256)
			(cond((null (aref *regexp-case-table* ch))
			      (if (< ch not_min) (setq not_min ch))
			      (if (< not_max ch) (setq not_max ch))))
			(TREX-inc ch))
		      (if (<= (- not_max not_min) (- max min))
			  (setq min not_min
				max not_max
				mode nil))
		      (let ((minb (/ min 8))
			    (maxb (1+ (/ max 8))))
			(insert (if mode CHARSET_M CHARSET_M_NOT) minb (- maxb minb))
			(let ((b minb))
			  (while (< b maxb)
			    (let ((i 7) (bits 0))
			      (while (<= 0 i)
				(if (eq (aref *regexp-case-table* (+ (* 8 b) i))
					mode)
				    ;;;; bits tableの順序は次の通り
				    (TREX-inc bits (aref [1 2 4 8 16 32 64 128] i)))
				(TREX-dec i))
			      (insert bits))
			    (TREX-inc b))))))
		  (regexp-code-gen* (car nexts)))
		 (t
                ;;; case
		  (let ((point nil))
		    (insert CASE)
		    (insert (length nexts))
		    (setq point (point))
		    (let ((list nexts))
		      (while list
			(insert 0 0)
			(setq list (cdr list))))
		    (insert min max)
		    (let ((ch min))
		      (while (<= ch max)
			(if (aref *regexp-case-table* ch)
			    (insert (1+ (TREX-find (aref *regexp-case-table* ch) nexts)))
			  (insert 0))
			(TREX-inc ch)))
		    (let ((list nexts))
		      (while list
			(if (null (assoc (car list) *labels*))
			    (regexp-code-gen* (car list)))
			(setq list (cdr list))))
		    (save-excursion
		      (goto-char point)
		      (let ((list nexts))
			(while list
			  (delete-char 2)
			  (let ((disp (- (cdr (assoc (car list) *labels*)) (+ (point) 2))))
			    (insert (logand disp 255)
				    (/ (logand disp (* 255 256)) 256)))
			  (setq list (cdr list)))))
		    ))))
	   ((eq (car (car alist)) ':epsilon)
	    (regexp-code-gen* (cdr (car alist))))
	   (t
	    (let ((key (car (car alist)))
		  (next (cdr (car alist))))
	      (cond ((symbolp key)
		     (insert (eval key)))
		    ((TREX-memequal (car key) '(CHARSET CHARSET_NOT))
		     (let ((charset (cdr key))
			   (min 128) (max -1)
			   (mcbytes 0)
			   (mcchars nil))
		       (let ((i 0))
			 (while (< i 256)
			   (aset *regexp-charset-table* i nil)
			   (TREX-inc i)))
		       (while charset
			 (cond((stringp (car charset))
			       (cond((eq (length (car charset)) 1)
				     (aset *regexp-charset-table* (aref (car charset) 0) t)
				     (if (< (aref (car charset) 0) min)
					 (setq min (aref (car charset) 0)))
				     (if (< max (aref (car charset) 0))
					 (setq max (aref (car charset) 0)))
				     )
				    (t
				     (TREX-inc mcbytes  (* 2 (length (car charset))))
				     (if (null mcchars) (setq mcchars charset))
				     )))
			      ((consp (car charset)) ;;; range
			       (cond ((eq (length (nth 1 (car charset))) 1)
				      (let ((from (aref (nth 1 (car charset)) 0))
					    (to   (aref (nth 2 (car charset)) 0)))
					(if (< from min) (setq min from))
					(if (< max to) (setq max to))
					(while (<= from to)
					  (aset *regexp-charset-table* from t)
					  (TREX-inc from)))
				      )
				     (t
				      (TREX-inc mcbytes 
						(+ (length (nth 1 (car charset))) (length (nth 2 (car charset)))))
				      (if (null mcchars) (setq mcchars charset))))))
			 (setq charset (cdr charset)))
		       (cond ((< max min)
			      (insert (if (eq (car key) 'CHARSET) CHARSET CHARSET_NOT)
				      (if (< 0 mcbytes) 128 0)))
			     (t
			      (let ((minb (/ min 8))
				    (maxb (1+ (/ max 8))))
				(insert (if (eq (car key) 'CHARSET) CHARSET_M CHARSET_M_NOT)
					minb (+ (if (< 0 mcbytes) 128 0)  (- maxb minb)))
				(let ((b minb))
				  (while (< b maxb)
				    (let ((i 7) (bits 0))
				      (while (<= 0 i)
					(if (aref *regexp-charset-table* (+ (* 8 b) i))
				            ;;;; bits tableの順序は次の通り
					    (TREX-inc bits (aref [1 2 4 8 16 32 64 128] i)))
					(TREX-dec i))
				      (insert bits))
				    (TREX-inc b))))))

		       (cond( (< 0 mcbytes)
			      (TREX-inc mcbytes 2)
			      (insert (/ mcbytes 256) (mod mcbytes 256))
			      (while mcchars
				(cond((stringp (car mcchars))
				      (insert (car mcchars) (car mcchars)))
				     ((consp (car mcchars))
				      (insert (nth 1 (car mcchars)) (nth 2 (car mcchars)))))
				(setq mcchars (cdr mcchars)))))
		       ))
		    ((= (length key) 1)
		     (insert (eval (car key))))
		    (t
		     (insert (eval (car key)) (nth 1 key))))
	      (regexp-code-gen* next))))
      (if point
	  (let ((disp (- (point) point)))
	    (save-excursion
	      (goto-char point)
	      (delete-char -2)
	      (insert (logand disp 255)
		      (/ (logand disp (* 255 256)) 256)))
	    (regexp-code-gen-alist nextalist))))))

(defun regexp-code-gen-exact (chars node)
  (let ((alist (cdr (assoc node *table*))))
    (cond((and (null (assoc node *labels*))
	       (= (length alist) 1)
	       (numberp (car (car alist))))
	  (regexp-code-gen-exact (cons (car (car alist)) chars)
				 (cdr (car alist))))
	 (t
	  (regexp-code-gen-exact* (reverse chars))
	  (regexp-code-gen* node)))))
    
(defun regexp-code-gen-exact* (chars)
  (cond((= (length chars) 1)
	(insert EXACT1 (car chars)))
       ((= (length chars) 2)
	(insert EXACT2 (car chars) (nth 1 chars)))
       ((= (length chars) 3)
	(insert EXACT3 (car chars) (nth 1 chars) (nth 2 chars)))
       (t
	(insert EXACTN (length chars))
	(let ((list chars))
	  (while list
	    (insert (car list))
	    (setq list (cdr list)))))))

;;;
;;; regexp-code-dump
;;; 正規表現のコードを表示する．
;;;

(defvar *regexp-code-dump* nil)
(defvar *regexp-code-index* nil)

(defun regexp-code-dump (*regexp-code-dump*)
  (terpri)
  (let ((*regexp-code-index* 0)
	(max (length *regexp-code-dump*)))
    (while (< *regexp-code-index* max)
      (princ (format "%4d:" *regexp-code-index*))
      (let((op (aref *regexp-code-dump* *regexp-code-index*)))
	(cond((= op UNUSED) (regexp-code-dump-0 "unused"))
	     ((= op EXACTN) 
	      (princ (format "exactn(%d) " (aref *regexp-code-dump* (1+ *regexp-code-index*))))
	      (let ((j (+ *regexp-code-index* 2)) 
		    (max (+ *regexp-code-index* 2 (aref *regexp-code-dump* (1+ *regexp-code-index*)))))
		(while (< j max)
		  (princ (format "%c" (aref *regexp-code-dump* j)))
		  (TREX-inc j))
		(setq *regexp-code-index* j))
	      (terpri)
	      )
	     ((= op BEGLINE) (regexp-code-dump-0 "begline"))
	     ((= op ENDLINE) (regexp-code-dump-0 "endline"))
	     ((= op JUMP) (regexp-code-dump-jump "jump"))
	     ((= op ON_FAILURE_JUMP ) (regexp-code-dump-jump "on_failure_jump"))
	     ((= op MAYBE_FINALIZE_JUMP) (regexp-code-dump-jump "maybe_finalize_jump"))
	     ((= op DUMMY_FAILURE_JUMP) (regexp-code-dump-jump "dummy_failure_jump"))
	     ((= op ANYCHAR) (regexp-code-dump-0 "anychar"))
	     ((= op CHARSET) (regexp-code-dump-charset "charset"))
	     ((= op CHARSET_NOT) (regexp-code-dump-charset "charset_not"))
	     ((= op START_MEMORY) (regexp-code-dump-1 "start_memory"))
	     ((= op STOP_MEMORY) (regexp-code-dump-1 "stop_memory"))
	     ((= op DUPLICATE) (regexp-code-dump-1 "duplicate"))
	     ((= op BEFORE_DOT) (regexp-code-dump-0 "before_dot"))
	     ((= op AT_DOT) (regexp-code-dump-0 "at_dot"))
	     ((= op AFTER_DOT) (regexp-code-dump-0 "after_dot"))
	     ((= op BEGBUF) (regexp-code-dump-0 "begbuf"))
	     ((= op ENDBUF) (regexp-code-dump-0 "endbuf"))
	     ((= op WORDCHAR) (regexp-code-dump-0 "wordchar"))
	     ((= op NOTWORDCHAR) (regexp-code-dump-0 "notwordchar"))
	     ((= op WORDBEG) (regexp-code-dump-0 "wordbeg"))
	     ((= op WORDEND) (regexp-code-dump-0 "wordend"))
	     ((= op WORDBOUND) (regexp-code-dump-0 "wordbound"))
	     ((= op NOTWORDBOUND) (regexp-code-dump-0 "notwordbound"))
	     ((= op SYNTAXSPEC) (regexp-code-dump-syntax "syntaxspec"))
	     ((= op NOTSYNTAXSPEC) (regexp-code-dump-syntax "notsyntaxspec"))
	     ((= op EXACT1) (regexp-code-dump-1ch "EXACT1"))
	     ((= op EXACT2)
	      (princ (format "EXACT2 %c%c\n" (aref *regexp-code-dump* (1+ *regexp-code-index*))
			     (aref *regexp-code-dump* (+ *regexp-code-index* 2))))
	      (TREX-inc *regexp-code-index* 3))
	     ((= op EXACT3)
	      (princ (format "EXACT3 %c%c%c\n" 
			     (aref *regexp-code-dump* (1+ *regexp-code-index*))
			     (aref *regexp-code-dump* (+ *regexp-code-index* 2))
			     (aref *regexp-code-dump* (+ *regexp-code-index* 3))))
	      (TREX-inc *regexp-code-index* 4))
	     ((= op CHARSET_M) (regexp-code-dump-charset-m "CHARSET_M"))
	     ((= op CHARSET_M_NOT) (regexp-code-dump-charset-m "CHARSET_M_NOT"))
	     ((= op CASE)
	      (princ (format "CASE %d\n" (aref *regexp-code-dump* (1+ *regexp-code-index*))))
	      (let ((j (+ *regexp-code-index* 2))
		    (max (+ *regexp-code-index* 2 (* 2 (aref *regexp-code-dump* (1+ *regexp-code-index*))))))
		(while (< j max)
		  (princ (format "[%d]::%d\n" (1+ (/ (- j (+ *regexp-code-index* 2)) 2))
				 (regexp-get-absolute-address
				  (+ j 2) (aref *regexp-code-dump* j)
				  (aref *regexp-code-dump* (1+ j)))))
		  (TREX-inc j 2))
		(let ((ch (aref *regexp-code-dump* j)) (chmax (aref *regexp-code-dump* (1+ j))))
		  (princ (format "%c::%c\n" ch chmax))
		  (TREX-inc j 2)
		  (while (<= ch chmax)
		    (princ (format "%c=>[%d]\n" ch (aref *regexp-code-dump* j)))
		    (TREX-inc j)
		    (TREX-inc ch)))
		(setq *regexp-code-index* j)))
	     ((= op ON_FAILURE_SUCCESS) (regexp-code-dump-0 "ON_FAILURE_SUCCESS"))
	     ((= op SUCCESS) (regexp-code-dump-0 "SUCCESS"))
	     ((= op POP) (regexp-code-dump-0 "POP"))
	     ((= op EXECPT0) (regexp-code-dump-0 "EXECPT0"))
	     ((= op EXECPT1) (regexp-code-dump-1ch "EXECPT1"))
	     ((= op CATEGORYSPEC) (regexp-code-dump-1ch "CATEGORYSPEC"))
	     ((= op NOTCATEGORYSPEC) (regexp-code-dump-1ch "NOTCATEGORYSPEC"))
	     (t (princ (format "unknown op=%d\n" op))
		(TREX-inc *regexp-code-index*)))))
    (princ (format "%4d:\n" *regexp-code-index*)))
  nil
  )

(defun regexp-code-dump-0 (op)
  (princ op) (terpri)
  (TREX-inc *regexp-code-index*))

(defun regexp-code-dump-1 (op)
  (princ (format "%s %d\n" op (aref *regexp-code-dump* (1+ *regexp-code-index*))))
  (TREX-inc *regexp-code-index* 2))

(defun regexp-code-dump-syntax (op)
  (princ (format "%s %c\n" op (syntax-code-spec (aref *regexp-code-dump* (1+ *regexp-code-index*)))))
  (TREX-inc *regexp-code-index* 2))

(defun regexp-code-dump-1ch (op)
  (princ (format "%s %c\n" op (aref *regexp-code-dump* (1+ *regexp-code-index*))))
  (TREX-inc *regexp-code-index* 2))

(defun regexp-get-absolute-address (point b1 b2)
  (cond ((< b2 128)
	 (+ point (+ (* 256 b2) b1)))
	(t
	 (+ point (logior (logxor -1 (+ (* 255 256) 255)) (* 256 b2) b1)))))

(defun regexp-code-dump-jump (op)
  (let* ((b1 (aref *regexp-code-dump* (1+ *regexp-code-index*)))
	 (b2 (aref *regexp-code-dump* (+ *regexp-code-index* 2)))
	(p (regexp-get-absolute-address (+ *regexp-code-index* 3) b1 b2)))
    (princ (format "%s %d\n" op p)))
  (TREX-inc *regexp-code-index* 3))

(defun regexp-code-dump-charset (op)
  (let ((n (aref *regexp-code-dump* (1+ *regexp-code-index*))))
    (princ (format "%s %d " op n))
    (let ((j (+ *regexp-code-index* 2))
	  (max (+ *regexp-code-index* 2 (if (<= 128 n) (- n 128) n))))
      (while (< j max)
	(princ (format "0x%2x " (aref *regexp-code-dump* j)))
	(TREX-inc j))
      (cond((<= 128 n)
	    (let* ((len (+ (* 256 (aref *regexp-code-dump* j)) 
			   (aref *regexp-code-dump* (1+ j))))
		   (last (+ j len)))
	      (princ (format "\n      range list[%d-2 bytes]" len))
	      (TREX-inc j 2)
	      (while (< j last)
		(let ((ch (sref *regexp-code-dump* j)))
		  (princ (format " %c" ch))
		  (TREX-inc j (char-bytes ch))
		  (setq ch (sref *regexp-code-dump* j))
		  (princ (format "-%c" ch))
		  (TREX-inc j (char-bytes ch))))
	      )))
      (setq *regexp-code-index* j)
      (terpri))
    ))
  
(defun regexp-code-dump-charset-m (op)
  (let ((m (aref *regexp-code-dump* (1+ *regexp-code-index*)))
	(n (aref *regexp-code-dump* (+ *regexp-code-index* 2))))
    (princ (format "%s %d %d " op m n))
    (let ((j (+ *regexp-code-index* 3))
	  (max (+ *regexp-code-index* 3 (if (<= 128 n) (- n 128) n))))
      (while (< j max)
	(princ (format "0x%02x " (aref *regexp-code-dump* j)))
	(TREX-inc j))
      (cond((<= 128 n)
	    (let* ((len (+ (* 256 (aref *regexp-code-dump* j)) 
			   (aref *regexp-code-dump* (1+ j))))
		   (last (+ j len)))
	      (princ (format "\n      range list[%d-2 bytes]" len))
	      (TREX-inc j 2)
	      (while (< j last)
		(let ((ch (sref *regexp-code-dump* j)))
		  (princ (format " %c" ch))
		  (TREX-inc j (char-bytes ch))
		  (setq ch (sref *regexp-code-dump* j))
		  (princ (format "-%c" ch))
		  (TREX-inc j (char-bytes ch))))
	      )))
      (setq *regexp-code-index* j)
      (terpri)
      )))

;;;
;;; Compile functions
;;;

(defun TREX-simple-test1 ()
  (regexp-word-compile 
	    "\\cA+\\cH*\\|\\cK+\\cH*\\|\\cC+\\cH*\\|\\cH+\\|\\sw+"))

(defun TREX-test1 (pattern)
  (let* ((regexp (regexp-parse pattern))
	 (fFA (EFFA-make (FA-make regexp)))
	 (bFA (EFFA-make (FA-inverse fFA)))
	 (l (cdr fFA))
	 (result nil))
    (TREX-push  (cons (DFA-optimize (DFA-make fFA))
			     (DFA-optimize (DFA-make bFA)))
		result)
    (while l
      (let* ((forward  (NEFA-make (EFFA-make (cons (car (car l)) (cdr fFA)))))
	     (backward (NEFA-make (EFFA-make (cons (car (car l)) (cdr bFA))))))
	       (cond((and forward backward)
		     (TREX-push  (cons (DFA-optimize (FA-simplify (DFA-shortest-match (DFA-make forward))))
					    (DFA-optimize (FA-simplify (DFA-shortest-match (DFA-make backward)))))
				 result))))
      (setq l (cdr l)))
    (setq result (reverse result))
    (let ((count 0))
      (while result
	(princ (format "\nForward[%2d]:" count)) (FA-dump (car (car result)))
	(princ (format "\nBackward[%2d]:" count)) (FA-dump (cdr (car result)))
	(TREX-inc count)
	(setq result (cdr result))))))
    
(defun TREX-test2 (pattern)
  (let* ((regexp (regexp-parse pattern))
	 (fFA (EFFA-make (FA-make regexp)))
	 (l (cdr fFA))
	 (result nil))
    (regexp-code-dump (setq result (regexp-code-gen (DFA-optimize (DFA-make fFA)))))
    result))

(defun regexp-compile (pattern)
  (regexp-compile-internal pattern nil))

(defun regexp-word-compile (pattern)
  (regexp-compile-internal pattern t))

(defun regexp-compile-internal (pattern &optional word)
  (let* ((*regexp-word-definition* word)
	 (regexp (regexp-parse pattern))
	 (fFA (EFFA-make (FA-make (regexp-reform-duplication regexp))))
	 (bFA (EFFA-make (FA-make (regexp-reform-duplication (regexp-inverse regexp)))))
	 (result nil))
    (let ((ofFA (DFA-optimize (DFA-make fFA)))
	  (obFA (DFA-optimize (DFA-make bFA))))
      (TREX-push (cons (DFA-code-with-fastmap ofFA)
		       (let* ((START_MEMORY STOP_MEMORY)
			      (STOP_MEMORY START_MEMORY))
			 (DFA-code-with-fastmap obFA)))
		 result))
    (if word
	(let ((l (cdr fFA))
	      (bFA (EFFA-make (FA-inverse fFA))))
	  (while l
	    (let* ((forward  (NEFA-make (EFFA-make (cons (car (car l)) (cdr fFA)))))
		   (backward (NEFA-make (EFFA-make (cons (car (car l)) (cdr bFA))))))
	      (cond((and forward backward)
		    (let ((fFA (DFA-optimize (FA-simplify (DFA-shortest-match (DFA-make forward)))))
			  (bFA (DFA-optimize (FA-simplify (DFA-shortest-match (DFA-make backward))))))
		      (TREX-push  (cons (DFA-code-with-fastmap fFA)
					(DFA-code-with-fastmap bFA))
				  result)))))
	    (setq l (cdr l)))
	  (setq result (nreverse result))))
    result))

(defun regexp-compile-dump (code)
  (let ((Fcode (aref (car (car code)) 0))
	(Bcode (aref (cdr (car code)) 0))
	(words (cdr code)))
    (princ (format "\nRegular Expression Compiler Dump:\n"))
    (princ (format "Forward Search:"))
    (regexp-code-dump Fcode)
    (princ (format "Backward Search:"))
    (if Bcode (regexp-code-dump Bcode)
      (princ (format "\n Use the interpreter\n")))
    (if words
	(let ((i 1))
	  (princ (format "In word conditions:\n"))
	  (while words
	    (princ (format "Forward[%d]" i))
	    (regexp-code-dump (aref  (car (car words)) 0))
	    (princ (format "Backward[%d]" i))
	    (regexp-code-dump (aref  (cdr (car words)) 1))
	    (TREX-inc i)
	    (setq words (cdr words)))))))

;;;
;;; Coding system 
;;;

(defmacro define-coding-systems (&rest rest)
  (` (define-coding-systems*  '(, rest))))

(defun define-coding-systems* (names)
  (let ((systems 
	 (` (:or (,@ (mapcar (function (lambda (name) (` (:seq (, (regexp-get-definition name))
						      (, name)))))
			     names))))))
    systems))

(defun oct (str) (aref str 0))

(defvar *TREX-range-from* nil)
(defvar *TREX-range-to* nil)

(defun TREX-range-make-jisjoint (regexp)
  (TREX-init *TREX-range-from* (make-vector 256 nil))
  (TREX-init *TREX-range-to*   (make-vector 256 nil))
  (let ((i 0))
    (while (< i 256)
      (aset *TREX-range-from* i nil)
      (aset *TREX-range-to*   i nil)
      (TREX-inc i)))
  (aset *TREX-range-from* 0 t)
  (aset *TREX-range-to*   255 t)
  (TREX-range-mark regexp)
  (TREX-range-replace regexp))

(defun TREX-range-mark (regexp)
  (cond 
   ((consp regexp)
    (let ((op (car regexp)))
      (cond((eq op ':mark)
	    (TREX-range-mark (nth 2 regexp)))
	   ((eq op ':or)
	    (mapcar 'TREX-range-mark (cdr regexp)))
	   ((eq op ':seq)
	    (mapcar 'TREX-range-mark (cdr regexp)))
	   ((eq op ':optional)
	    (TREX-range-mark (nth 1 regexp)))
	   ((eq op ':star)
	    (TREX-range-mark (nth 1 regexp)))
	   ((eq op ':plus)
	    (TREX-range-mark (nth 1 regexp)))
	   ((eq op ':range)
	    (TREX-range-mark2 (nth 1 regexp) (nth 2 regexp))))))
   ((stringp regexp)
    (TREX-range-mark2 regexp regexp))
   ((numberp regexp)
    (TREX-range-mark2 regexp regexp))))

(defun TREX-range-mark2 (from to)
  (if (stringp from) (setq from (aref from 0)))
  (if (stringp to)   (setq to (aref to 0)))
  (if (< 0 from) (aset *TREX-range-to*     (1- from) t))
  (if (< to 255) (aset *TREX-range-from*   (1+ to) t))
  (aset *TREX-range-from* from t)
  (aset *TREX-range-to*   to t))

(defun TREX-range-replace (regexp)
  (cond 
   ((consp regexp)
    (let ((op (car regexp)))
      (cond((eq op ':mark)
	    (` (:mark (, (nth 1 regexp))
		      (, (TREX-range-replace (nth 2 regexp))))))
	   ((eq op ':or)
	    (` (:or (,@ (mapcar 'TREX-range-replace (cdr regexp))))))
	   ((eq op ':seq)
	    (` (:seq (,@ (mapcar 'TREX-range-replace (cdr regexp))))))
	   ((eq op ':optional)
	    (` (:optional (,(TREX-range-replace (nth 1 regexp))))))
	   ((eq op ':star)
	    (` (:star (,(TREX-range-replace (nth 1 regexp))))))
	   ((eq op ':plus)
	    (` (:plus (,(TREX-range-replace (nth 1 regexp))))))
	   ((eq op ':range)
	    (let ((from (nth 1 regexp))
		  (to   (nth 2 regexp))
		  i j
		  (result nil))
	      (if (stringp from) (setq from (aref from 0)))
	      (if (stringp to  ) (setq to   (aref to   0)))
	      (setq i from
		    j from)
	      (while (<= i to)
		(while (not (aref *TREX-range-to* j))
		  (TREX-inc j))
		(if (not (= i j)) (TREX-push (` (:range (, i) (, j))) result)
		  (TREX-push i result))
		(TREX-inc j)
		(setq i j))
	      (if (= (length result) 1) (car result)
		(` (:or (,@ (nreverse result))))))))))
   ((stringp regexp)
    (if (= (length regexp) 1)
	(aref regexp 0)
      regexp))
   ((numberp regexp)
    regexp)
   (t regexp)))

(defun FA-sort (FA)
  (let ((start (car FA))
	(alist (cdr FA)))
    (setq alist (sort alist 'TREX-lessp-car))
    (while alist
      (setcdr (car alist) (sort (cdr (car alist)) 'TREX-lessp-car))
      (setcdr (car alist ) (TREX-sort (cdr (car alist)) 'TREX-key-lessp 'cdr))
      (setq alist (cdr alist)))
    FA))

;;;
;;; CHARSET functions:
;;;
;;;  CHARSET ::= RANGE |
;;;              (:or RANGE+) |
;;;              (:nor RANGE+)
;;;  RANGE+   ::= CHAR |
;;;              (:range CHAR CHAR)
;;;

(defun CHARSET-rangep (charset)
  (or (numberp charset)
      (and (consp charset) (eq (car charset) ':range))))

(defun CHARSET-orp (charset)
  (and (consp charset) (eq (car charset) ':or)))

(defun CHARSET-range-from (range)
  (if (numberp range) range
    (nth 1 range)))

(defun CHARSET-range-to  (range)
  (if (numberp range) range
    (nth 2 range)))

(defun CHARSET-range-make (from to)
  (if (= from to) from
    (list ':range from to)))

(defun CHARSET-membership (range charset)
  (let ((from (CHARSET-range-from range))
	(to   (CHARSET-range-to   range))
	(flag nil))
    (while (and charset flag1)
      (if (< from (CHARSET-range-from (car charset)))
	  (setq charset (cdr charset))
	(setq flag t)))
    (and flag1 (<= to (CHARSET-range-to (car charset))))))
	    
(defun CHARSET-not (charset)
  (cond((CHARSET-rangep charset)
	(list ':nor charset))
       ((CHARSET-orp charset)
	(cons ':nor (cdr charset)))
       (t
	(cons ':or (cdr charset)))))

(defun CHARSET-union (charset1 charset2)
  (cond((CHARSET-rangep charset1)
	(cond ((CHARSET-rangep charset2)
	       (CHARSET-union-range-range charset1 charset2))
	      ((CHARSET-orp charset2)
	       (CHARSET-union-range-or charset1 charset2))
	      (t
	       (CHARSET-union-range-nor charset1 charset2))))
       ((CHARSET-orp charset1)
	(cond ((CHARSET-rangep charset2)
	       (CHARSET-union-range-or charset2 charset1))
	      ((CHARSET-orp charset2)
	       (CHARSET-union-or-or charset1 charset2))
	      (t
	       (CHARSET-union-or-nor charset1 charset2))))
       (t ;;; (CHARSET-norp charset1)
	(cond((CHARSET-rangep charset2)
	      (CHARSET-union-range-nor charset2 charset1))
	     ((CHARSET-orp charset2)
	      (CHARSET-union-or-nor charset2 charset1))
	     (t
	      (CHARSET-union-nor-nor charset1 charset2))))))
	
(defun CHARSET-union-range-range (range1 range2)
  (let ((from1  (CHARSET-range-from range1))
	(to1    (CHARSET-range-to   range1))
	(from2  (CHARSET-range-from range2))
	(to2    (CHARSET-range-to   range2)))
    (cond((< to1 from2)
	  (list ':or range1 range2))
	 (t ;;; (<= from2 (1+ to1))
	  (cond((<= to1 to2) ;;; (<= from2 to1 to2)
		(CHARSET-range-make (min from1 from2) to2))
	       ((<= from1 to2) ;;; (<= from1 to2 to1)
		(CHARSET-range-make (min from1 from2) to1))
	       (t ;;; (<= to2 from1 to1)
		(list ':or range2 range1)))))))

(defun CHARSET-union-range-or (range or)
  (cons ':or (CHARSET-union-range-or* range (cdr or))))

(defun CHARSET-union-range-or* (range or-body)
  (let ((from (CHARSET-range-from range))
	(to   (CHARSET-range-to   range))
	(part1 nil))
    (let ((flag nil))
      (while (and or-body (null flag))
	(let ((next (car or-body)))
	  (if (< (CHARSET-range-from next) from)
	      ;;; from[i] < from
	      (if (< (CHARSET-range-to next) from)
		  ;;; to[i] < from
		  (setq part1 (cons next part1)
			or-body (cdr or-body))
		;;; from[i] < from <= to[i]
		(setq from (CHARSET-range-from next)
		      flag t))
	    ;;; from <= from[1]
	    ;;; to[i-1] < from <= from[i]
	    (setq flag t)))))
    ;;; part1 < from <= from[i]
    (if (and part1 (<= (1+ (CHARSET-range-to (car part1))) from))
	(setq from (CHARSET-range-from (car part1))
	      part1 (cdr part1)))
    ;;; part1 << from <= from[i]
    (let ((flag nil))
      (while (and or-body (null flag))
	(let ((next (car or-body)))
	  (if (< (CHARSET-range-from next) to)
	      ;;; from[j] < from
	      (if (< (CHARSET-range-to next) to)
		  ;;; to[j] < to
		  (setq or-body (cdr or-body))
		;;; from[j] < to <= to[j]
		(setq to (CHARSET-range-to next)
		      flag t))
	    ;;; to <= from[1]
	    ;;; to[j-1] < to <= from[j]
	    (setq flag t)))))
    ;;; part2 < to <= from[j]
    (if (and or-body (<= (CHARSET-range-from (car or-body)) (1+ to)))
	(setq to (CHARSET-range-to (car or-body))
	      or-body (cdr or-body)))
    ;;; part2 <= to << from[j]
    (nconc (reverse part1)
	   (cons (CHARSET-range-make from to)
		 or-body))))
		      

(defun CHARSET-union-range-nor (range nor)
  (let ((from (CHARSET-range-from range))
	(to   (CHARSET-range-to   range))
	(nor-body (cdr nor)))

    ))

(defun CHARSET-union-or-or (or1 or2)
  (cons ':or (CHARSET-union-or*-or* (cdr or1) (cdr or2))))

(defun CHARSET-union-or*-or* (or1-body or2-body)
  (let ((result-body or2-body))
    (while or1-body
      (setq result-body
	    (CHARSET-union-range-or* (car or1-body) result-body))
      (setq or1-body (cdr or1-body)))
    result-body))

(defun CHARSET-union-or-nor (or nor)
  )

(defun CHARSET-union-nor-nor (nor1 nor2)
  (cons ':nor (CHARSET-intersection-or*-or* (cdr nor1) (cdr nor2))))

(defun CHARSET-intersection (charset1 charset2)
  (cond((CHARSET-rangep charset1)
	(cond ((CHARSET-rangep charset2)
	       (CHARSET-intersection-range-range charset1 charset2))
	      ((CHARSET-orp charset2)
	       (CHARSET-intersection-range-or charset1 charset2))
	      (t
	       (CHARSET-intersection-range-nor charset1 charset2))))
       ((CHARSET-orp charset1)
	(cond ((CHARSET-rangep charset2)
	       (CHARSET-intersection-range-or charset2 charset1))
	      ((CHARSET-orp charset2)
	       (CHARSET-intersection-or-or charset1 charset2))
	      (t
	       (CHARSET-intersection-or-nor charset1 charset2))))
       (t ;;; (CHARSET-norp charset1)
	(cond((CHARSET-rangep charset2)
	      (CHARSET-intersection-range-nor charset2 charset1))
	     ((CHARSET-orp charset2)
	      (CHARSET-intersection-or-nor charset2 charset1))
	     (t
	      (CHARSET-intersection-nor-nor charset1 charset2))))))

(defun CHARSET-intersection-range-or (range or)
  (CHARSET-intersection-range-or* range (cdr or)))

(defun CHARSET-intersection-range-or* (range or-body)
  (let ((from (CHARSET-range-from range))
	(to   (CHARSET-range-to   range))
	(part2 nil))
    (let ((flag nil))
      (while (and or-body (null flag))
	(let ((next (car or-body)))
	  (if (< (CHARSET-range-from next) from)
	      ;;; from[i] < from
	      (if (< (CHARSET-range-to next) from)
		  ;;; to[i] < from
		  (setq or-body (cdr or-body))
		;;; from[i] < from <= to[i]
		(setq flag t))
	    ;;; from <= from[1]
	    ;;; to[i-1] < from <= from[i]
	    (setq flag t)))))
    ;;; from[i] < from <= to[i]
    ;;; from <= from[1]
    ;;; to[i-1] < from <= from[i]
    (let ((flag nil))
      (while (and or-body (null flag))
	(let ((next (car or-body)))
	  (if (<= (CHARSET-range-from next) to)
	      ;;; from[j] <= to
	      (if (<= (CHARSET-range-to next) to)
		  ;;; to[j] <= to
		  (setq part2 (cons next part2)
			or-body (cdr or-body))
		;;; from[j] <= to < to[j]
		(setq part2 (cons next part2)
		      or-body (cdr or-body)
		      flag t)
	    ;;; to < from[1]
	    ;;; to[j-1] <= to < from[j]
	    (setq flag t)))))
    ;;; from[j] <= to < to[j]
    ;;;            to < from[1]
    ;;; to[j-1] <= to < from[j]
      (cond ((null part2) nil)
	    ((= (length part2) 1)
	     (list (CHARSET-range-make (max from (CHARSET-range-from (car part2)))
				       (min to   (CHARSET-range-to   (car part2))))))
	    (t
	     (setcar part2 (CHARSET-range-make (CHARSET-range-from (car part2))
					       (min to (CHARSET-range-to (car part2)))))
	     (setq part2 (nreverse part2))
	     (setcar part2 (CHARSET-range-make (max from (CHARSET-range-from (car part2)))
					       (CHARSET-range-to (car part2))))
	     part2)))))

(defun CHARSET-intersection-range-nor (range nor)
  (CHARTSET-intersection-range-nor* range (cdr nor)))

(defun CHARSET-intersecion-range-nor* (range nor-body)
  (let ((from (CHARSET-range-from range))
	(to   (CHARSET-range-to   range)))
    ))

;;; (and (or a b) c) == (or (and a c) (and b c))

(defun CHARSET-intersection-or-or (or1 or2)
  (let ((result nil)
	(or1-body (cdr or1))
	(or2-body (cdr or2)))
    (while or1-body
      (setq result (CHARSET-union-or*-or*
		    (CHARSET-intersection-range-or* (car or1-body) or2-body)
		    result))
      (setq or1-body (cdr or1-body)))
    (if (= (length result) 1) (car result)
      (cons ':or result))))

(defun CHARSET-intersection-or-nor (or nor)
  )

;;; (and (not or1) (not or2)) == (not (or or1 or2))

(defun CHARSET-intersection-nor-nor (nor1 nor2)
  (cons ':nor (CHARSET-union-or*-or* (cdr nor1) (cdr nor2))))

(defun FA-compaction (FA)
  (let ((start (car FA))
	(alist (cdr FA)))
    (setq alist (TREX-sort alist 'TREX-key-lessp 'car))
    (while alist
      (let ((table (cdr (car alist)))
	    (newtable nil)
	    (keys nil)  (next nil))
	(setq table (TREX-sort table '< 'car))
	(while table
	  (setq next (cdr (car table)))
	  (TREX-push (car (car table)) keys)
	  (setq table (cdr table))
	  (while (and table (eq next (cdr (car table))))
	    (TREX-push (car (car table)) keys)
	    (setq table (cdr table)))
	  (setq keys (reverse (sort keys 'TREX-key-lessp)))
	  (let ((newkeys nil))
	    (setq newkeys (car keys)
		  keys    (cdr keys))
	    (while keys
	      (cond((numberp (car keys))
		    (cond((numberp (car newkeys))
			  (if (= (1+ (car keys)) (car newkeys))
			      (setcar newkeys (list ':range (car keys) (car newkeys)))
			    (TREX-push (car keys) newkeys)))
			 ((and (consp (car newkeys)) (eq (car (car newkeys)) ':range)))))))))))))
			  
	    

(defun FA-dump2 (table)
  (let ((start (car table))
	(l (cdr table)))
    (princ (format "\nstart = %d\n" start))
    (while l
      (princ (format "%3d: " (car (car l))))
      (let ((alist (cdr (car l))))
	  (cond ((numberp (car (car alist)))
		 (princ (format "\\%03o(%c) -> %s\n" (car (car alist))(car (car alist)) (cdr (car alist)))))
		((and (consp (car (car alist))) (TREX-memequal (car (car (car alist))) '(CATEGORYSPEC NOTCATEGORYSPEC)))
		 (princ (format "(%s %c) -> %s\n" (car (car (car alist))) (nth 1 (car (car alist))) (cdr (car alist)))))
		((and (consp (car (car alist))) (eq (car (car (car alist))) ':range))
		 (princ (format "(:range \\%03o \\%03o) -> %s\n"
				(nth 1 (car (car alist))) (nth 2 (car (car alist)))
				(cdr (car alist)))))
		(t
		 (princ (format "%s -> %s\n" (car (car alist)) (cdr (car alist))))))
	  (setq alist (cdr alist))
	(while alist
	  (cond ((numberp (car (car alist)))
		 (princ (format "     \\%03o(%c) -> %s\n" (car (car alist))(car (car alist)) (cdr (car alist)))))
		((and (consp (car (car alist))) (TREX-memequal (car (car (car alist))) '(CATEGORYSPEC NOTCATEGORYSPEC)))
		 (princ (format "     (%s %c) -> %s\n" (car (car (car alist))) (nth 1 (car (car alist))) (cdr (car alist)))))
		((and (consp (car (car alist))) (eq (car (car (car alist))) ':range))
		 (princ (format "     (:range \\%03o \\%03o) -> %s\n"
				(nth 1 (car (car alist))) (nth 2 (car (car alist)))
				(cdr (car alist)))))
		(t
		 (princ (format "     %s -> %s\n" (car (car alist)) (cdr (car alist))))))
	  (setq alist (cdr alist))))
      (setq l (cdr l)))))