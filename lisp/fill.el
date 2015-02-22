;; Fill commands for Emacs
;; Copyright (C) 1985, 1986, 1992 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;;  Fill Commands for Egg on Mule
;;;  This file contains Japanese characters.
;;;  Modified by Satoru Tomura (tomura@etl.go.jp)

;;;  Ver.18.58d   modified by kawamoto@ics.es.osaka-u.ac.jp 93-Aug-23
;;;               最初の語がfill-column より長い場合の虫を修正
;;;  Ver.18.58c   modified by kawamoto@ics.es.osaka-u.ac.jp 93-Aug-23
;;;               Original typo 
;;;  Ver.18.58b	  modified by M.Higashida 93-May-24 for Mule Ver.0.9.8
;;;		  We should use 'string-width' instead of 'length'.
;;;  Ver.18.58a   modified by K.Handa 92-Jun-30 for Mule Ver.0.9.5
;;;		  Bug of extra space at the end of paragraph fixed.
;;;  Ver.18.58	  modified by T.Enami 92-Apr-27 for Mule Ver.0.9.4
;;;		  Unnecessary comment deleted.
;;;		  In fill-region-as-paragraph, we might have gone back
;;;		  too much by (re-search-backward re-break-point nil 'mv)
;;;  Mule Ver.0.9.3
;;;  Ver.18.57	  modified by K.Handa 92-Apr-15 for Mule Ver.0.9.3
;;;		  Bugs in fill-region-as-paragraph fixed.
;;;  Ver.18.57    modified by T.Nakagawa 92-Mar-26 for Mule Ver.0.9.2
;;;		  In justify-current-line, multi-byte char handling fixed.
;;;  Ver.18.57    modified by M.Kuwada 92-Mar-26 for Mule Ver.0.9.2
;;;		  In fill-region-as-paragraph, multi-byte char handling fixed.
;;;  Ver.18.57    modified by K.Handa 92-Mar-2 for Mule Ver.0.9.0
;;;  Ver.18.55    modified by S. Tomura 89-Nov-15,17
;;;  Ver.18.55    created by S. Tomura 89-Nov-15
;;;  Nemacs Ver. 3.2
;;;  Ver.18.52c   modified by S. Tomura 89-Oct-19
;;;  Ver.18.52b   modified by S. Tomura 89-Oct-2
;;;  Ver.18.52a   modified by S. Tomura 89-Aug-30
;;;               kanji-kanji-* are corrected.
;;;  Ver.18.52    created  by S. Tomura 89-Mar-16
;;;  Ver.18.50f   modified by S. Tomura 88-Aug-25
;;;               See ;; 88-Aug-25
;;;  Ver.18.50e   modified by S. Tomura 88-Aug-24
;;;               constant hiragana-char and katakana-char corrected.
;;;  Ver.18.50d   modified by S. Tomura 88-Jun-30
;;;  Ver.18.50c   modified by S. Tomura 88-Jun-21
;;;  Ver.18.50b   modified by S. Tomura 88-Jun-20
;;;  Ver.18.50a   modified by S. Tomura 88-Jun-16
;;;  Ver.18.50    created by S. Tomura 88-Jun-11
;;;  Nemacs Ver.2.1
;;;  Ver.18.47e   modified by S. Tomura 88-Jun-7
;;;               Kanji justification added.
;;;  Ver.18.47d   modified by S. Tomura 88-Jun-2
;;;               In kanji-mode a space after an English word preserved.
;;;               Some codes become simpler and clearer.
;;;               Same method as simple.el adapted.
;;;  Ver.18.47c   modified by S. Tomura 88-May-25
;;;  Ver.18.47b   modified by S. Tomura 88-Feb-9
;;;; Ver.18.47a   modified by S. Tomura 88-Feb-5
;;;;              Kanji fill region added.


(defconst fill-individual-varying-indent nil
  "*Controls criterion for a new paragraph in `fill-individual-paragraphs'.
Non-nil means changing indent doesn't end a paragraph.
That mode can handle paragraphs with extra indentation on the first line,
but it requires separator lines between paragraphs.
Nil means that any change in indentation starts a new paragraph.")

(defun set-fill-prefix ()
  "Set the fill-prefix to the current line up to point.
Filling expects lines to start with the fill prefix
and reinserts the fill prefix in each resulting line."
  (interactive)
  (setq fill-prefix (buffer-substring
		     (save-excursion (beginning-of-line) (point))
		     (point)))
  (if (equal fill-prefix "")
      (setq fill-prefix nil))
  (if fill-prefix
      (message "fill-prefix: \"%s\"" fill-prefix)
    (message "fill-prefix cancelled")))

(defun fill-region-as-paragraph (from to &optional justify-flag)
  "Fill region as one paragraph: break lines to fit fill-column.
Prefix arg means justify too.
From program, pass args FROM, TO and JUSTIFY-FLAG."
  (interactive "r\nP")
  (save-restriction
    (narrow-to-region from to)
    (goto-char (point-min))
    (skip-chars-forward "\n")
    (narrow-to-region (point) (point-max))
    (setq from (point))
    (let ((fpre (and fill-prefix (not (equal fill-prefix ""))
		     (regexp-quote fill-prefix))))
      ;; Delete the fill prefix from every line except the first.
      ;; The first line may not even have a fill prefix.
      (and fpre
	   (progn
	     (if (>= (string-width fill-prefix) fill-column) ;
		 (error "fill-prefix too long for specified width"))
	     (goto-char (point-min))
	     (forward-line 1)
	     (while (not (eobp))
	       (if (looking-at fpre)
		   (delete-region (point) (match-end 0)))
	       (forward-line 1))
	     (goto-char (point-min))
	     ;; original code
	     ;; (and (looking-at fpre) (forward-char (length fill-prefix)))
	     ;; rewritten code
	     (and (looking-at fpre)
		  (goto-char (match-end 0))) ; 92.3.26 by M.Kuwada
	     ;; end of code
	     (setq from (point)))))
    ;; from is now before the text to fill,
    ;; but after any fill prefix on the first line.

    ;; Make sure sentences ending at end of line get an extra space.
    (goto-char from)
    ;;;; patch by S.Tomura 88-Jun-30
    ;;＜統合＞
    ;; . + CR             ==> . + SPC + SPC 
    ;; . + SPC + CR +     ==> . + SPC + 
    ;;(while (re-search-forward "[.?!][])""']*$" nil t)
    ;;  (insert ? ))
    (while (re-search-forward "[.?!][])\"']*$" nil t)
      (if (eobp)
	  nil
	;; replace CR by two spaces.
	(delete-char 1)			; delete newline
	(insert "  ")))
    ;; end of patch
    ;; The change all newlines to spaces.
    ;;; patched by S.Tomura 87-Dec-7
    ;;; bug fixed by S.Tomura 88-May-25
    ;;; modified by  S.Tomura 88-Jun-21
    ;;;(subst-char-in-region from (point-max) ?\n ?\ )
    ;;; modified by K.Handa 92-Mar-2
    ;;; Spacing is not necessary for charcters of no word-separater.
    ;;; The regexp word-across-newline is used for this check.
    (if (not (stringp word-across-newline))
	(subst-char-in-region from (point-max) ?\n ?\ )
      ;;;;
      ;;;; WAN     +NL+WAN       --> WAN            + WAN
      ;;;; not(WAN)+NL+WAN       --> not(WAN)       + WAN
      ;;;; WAN     +NL+not(WAN)  --> WAN            + not(WAN)
      ;;;; SPC     +NL+not(WAN)  --> SPC            + not(WAN)
      ;;;; not(WAN)+NL+not(WAN)  --> not(WAN) + SPC + not(WAN)
      ;;;;
      (goto-char from)
      (end-of-line)
      (while (not (eobp))
	(delete-char 1)
	(if (eobp) nil			; 92.6.30 by K.Handa
	  ;;; 92.8.26 , 92.8.30 by S. Tomura
	  (if (not (looking-at word-across-newline))
	      (progn
		(forward-char -1)
		(if (and (not (eq (following-char) ? ))
			 (not (looking-at word-across-newline)))
		    (progn
		      (forward-char 1)
		      (insert ? ))
		  (forward-char 1))))
	  (end-of-line))))
    ;;; After the following processing, there's two spaces at end of sentence
    ;;; and single space at end of line within sentence.
    ;;; end of patch
    ;; Flush excess spaces, except in the paragraph indentation.
    (goto-char from)
    (skip-chars-forward " \t")
    (while (re-search-forward "   *" nil t)
      (delete-region
       (+ (match-beginning 0)
	  (if (save-excursion
		(skip-chars-backward " ])\"'")
		(memq (preceding-char) '(?. ?? ?!)))
	      2 1))
       (match-end 0)))
    (goto-char (point-max))
    (delete-horizontal-space)
    (insert "  ")
    (goto-char (point-min))
    (let ((prefixcol 0)
	  ;;; patch by K.Handa 92-Mar-2
	  (re-break-point (concat "[ \t\n]\\|" word-across-newline))
	  ;;; end of patch
	  )
      (while (not (eobp))
	(move-to-column (1+ fill-column))
	(if (eobp)
	    nil
	  ;;; patched by S.Tomura 87-Jun-2
	  ;;; Big change by K.Handa 92-Mar-2
	  ;;; Move back to start of word.
	  ;;; (skip-chars-backward "^ \n")
	  ;;; (if (if (zerop prefixcol) (bolp) (>= prefixcol (current-column)))
	  ;;;    ;; Move back over whitespace before the word.
	  ;;;    (skip-chars-forward "^ \n")
	  ;;;  ;; Normally, move back over the single space between the words.
	  ;;;  (forward-char -1))

	  ;;; At first, find breaking point at the left of fill-column,
	  ;;; but after kinsoku-shori, the point may be right of fill-column.
	  ;;; 92.4.15 by K.Handa -- re-search-backward will back to prev line.
	  ;;; 92.4.27 by T.Enami -- We might have gone back too much...
	  (let ((p (point)) ch)
	    ;;; 93.8.23 by kawamoto@ics.es.osaka-u.ac.jp --- 最初の語がfill-column より長い場合
	    (if (re-search-backward re-break-point nil 'mv)
		(progn
		  (setq ch (following-char))
		  (if (or (= ch ? ) (= ch ?\t))
		      (skip-chars-backward " \t")
		    (forward-char 1)
		    (if (<= p (point))
			(forward-char -1))))))
	  (kinsoku-shori)
	  ;;; Check if current column is at the right of prefixcol.
	  ;;; If not, find break-point at the right of fill-column.
	  ;;; This time, force kinsoku-shori-nobashi.
	  (if (>= prefixcol (current-column))
	      (progn
		(move-to-column (1+ fill-column))
		;; 92.4.15 by K.Handa -- suppress error in re-search-forward
		(re-search-forward re-break-point nil t)
		(forward-char -1)
		(kinsoku-shori-nobashi))))
	;;; end of patch S.Tomura

	;; Replace all whitespace here with one newline.
	;; Insert before deleting, so we don't forget which side of
	;; the whitespace point or markers used to be on.
	;; patch by S. Tomura 88-Jun-20
	;; 92.4.27 by K.Handa
	(skip-chars-backward " \t")
	(if mc-flag
	    ;; ＜分割＞  WAN means chars which match word-across-newline.
	    ;; (0)     | SPC + SPC* <EOB>	--> NL
	    ;; (1) WAN | SPC + SPC*		--> WAN + SPC + NL
	    ;; (2)     | SPC + SPC* + WAN	--> SPC + NL  + WAN
	    ;; (3) '.' | SPC + nonSPC		--> '.' + SPC + NL + nonSPC
	    ;; (4) '.' | SPC + SPC		--> '.' + NL
	    ;; (5)     | SPC*			--> NL
	    (let ((start (point))	; 92.6.30 by K.Handa
		  (ch (following-char)))
	      (if (and (= ch ? )
		       (progn		; not case (0) -- 92.6.30 by K.Handa
			 (skip-chars-forward " \t")
			 (not (eobp)))
		       (or
			(progn		; case (1)
			  (goto-char start)
			  (forward-char -1)
			  (looking-at word-across-newline))
			(progn		; case (2)
			  (goto-char start)
			  (skip-chars-forward " \t")
			  (and (not (eobp))
			       (looking-at word-across-newline)))
			(progn		; case (3)
			  (goto-char (1+ start))
			  (and (not (eobp))
			       (/= (following-char) ? )
			       (progn
				 (skip-chars-backward " ])\"'")
				 (memq (preceding-char) '(?. ?? ?!)))))))
		  ;; We should keep one SPACE before NEWLINE. (1),(2),(3)
		  (goto-char (1+ start))
		;; We should delete all SPACES around break point. (4),(5)
		(goto-char start))))
	;;; end of patch
	(insert ?\n)
	(delete-horizontal-space)

	;; Insert the fill prefix at start of each line.
	;; Set prefixcol so whitespace in the prefix won't get lost.
	(and (not (eobp)) fill-prefix (not (equal fill-prefix ""))
	     (progn
	       (insert fill-prefix)
	       (setq prefixcol (current-column))))
	;; Justify the line just ended, if desired.
	(and justify-flag (not (eobp))
	     (progn
	       (forward-line -1)
	       (justify-current-line)
	       (forward-line 1)))))))

(defun fill-paragraph (arg)
  "Fill paragraph at or after point.
Prefix arg means justify as well."
  (interactive "P")
  (save-excursion
    (forward-paragraph)
    (or (bolp) (newline 1))
    (let ((end (point)))
      (backward-paragraph)
      (fill-region-as-paragraph (point) end arg))))

(defun fill-region (from to &optional justify-flag)
  "Fill each of the paragraphs in the region.
Prefix arg (non-nil third arg, if called from program)
means justify as well."
  (interactive "r\nP")
  (save-restriction
   (narrow-to-region from to)
   (goto-char (point-min))
   (while (not (eobp))
     (let ((initial (point))
	   (end (progn
		 (forward-paragraph 1) (point))))
       (forward-paragraph -1)
       (if (>= (point) initial)
	   (fill-region-as-paragraph (point) end justify-flag)
	 (goto-char end))))))

;;; The following code is valid only for Japanese.

;;; patch by S.Tomura 88-Jun-2, 89-Nov-15
;;; 日本語のjustificationでは、半角空白を入れられる場所は
;;; "。、"の後
;;; ""の前
;;; 英単語と日本語との間
;;; である。

(defvar ascii-char "[\40-\176]")

(defvar ascii-space "[ \t]")
(defvar ascii-symbols "[\40-\57\72-\100\133-\140\173-\176]")
(defvar ascii-numeric "[\60-\71]")
(defvar ascii-English-Upper "[\101-\132]")
(defvar ascii-English-Lower "[\141-\172]")

(defvar ascii-alphanumeric "[\60-\71\101-\132\141-\172]")

(defvar kanji-char "\\cj")
(defvar kanji-space "　")
(defvar kanji-symbols "\\cS")
(defvar kanji-numeric "[０-９]")
(defvar kanji-English-Upper "[Ａ-Ｚ]")
(defvar kanji-English-Lower  "[ａ-ｚ]")
;;; Bug fixed by Yoshida@CSK on 88-AUG-24
(defvar kanji-hiragana "[ぁ-ん]")
(defvar kanji-katakana "[ァ-ヶ]")
;;;
(defvar kanji-Greek-Upper "[Α-Ω]")
(defvar kanji-Greek-Lower "[α-ω]")
(defvar kanji-Russian-Upper "[А-Я]")
(defvar kanji-Russian-Lower "[а-я]")
(defvar kanji-Kanji-1st-Level  "[亜-腕]")
(defvar kanji-Kanji-2nd-Level  "[弌-瑤]")

(defvar kanji-kanji-char "\\(\\cH\\|\\cK\\|\\cC\\)")

(defvar aletter (concat "\\(" ascii-char "\\|" kanji-char "\\)"))

(defvar kanji-space-insertable (concat 
	   "、" aletter                   "\\|"
	   "。" aletter                   "\\|"
	   aletter "（"                   "\\|"
	   "）" aletter                   "\\|"
	   ascii-alphanumeric  kanji-kanji-char "\\|"
	   kanji-kanji-char    ascii-alphanumeric ))

(defvar space-insertable (concat
	  " " aletter                     "\\|"
	  kanji-space-insertable))

(defun find-space-insertable-point ()
  (if (re-search-backward space-insertable nil t)
      (progn (forward-char 1)
	     t)
    nil))
;;; end of patch

(defun justify-current-line ()
  "Add spaces to line point is in, so it ends at fill-column."
  (interactive)
  (save-excursion
   (save-restriction
    (let (ncols nwhites beg indent flags)
      (beginning-of-line)
      (forward-byte (length fill-prefix)) ; 92.3.26 by T.Nakagawa
      (skip-chars-forward " \t")
      (setq indent (current-column))
      (setq beg (point))
      (end-of-line)
      (narrow-to-region beg (point))
      (goto-char beg)
      (while (re-search-forward "   *" nil t)
	(delete-region
	 (+ (match-beginning 0)
	    (if (save-excursion
		 (skip-chars-backward " ])\"'")
		 (memq (preceding-char) '(?. ?? ?!)))
		2 1))
	 (match-end 0)))
      (goto-char beg)
      (while (re-search-forward "[.?!][])\"']*\n" nil t)
	(forward-char -1)
	(insert ? ))
      (goto-char (point-max))
      ;; Note that the buffer bounds start after the indentation,
      ;; so the columns counted by INDENT don't appear in (current-column).
      (setq ncols (- fill-column (current-column) indent))
      ;; Count word-boundaries in the line.
      (setq nwhites 0)
      ;;; patch for mule
      ;;; original code
      ;;; (while (search-backward " " nil t)
      ;;; (skip-chars-backward " ")
      ;;; (setq nwhites (1+ nwhites)))
      ;;; rewritten code
      (while (find-space-insertable-point)
	(skip-chars-backward " ")
	(setq nwhites (1+ nwhites)))
      ;;; end of patch
      (if (> nwhites 0)
	  (progn
	    ;; Add space uniformly as far as we can.
	    (goto-char (point-max))
	    ;;; patch for mule
	    ;;; (while (search-backward " " nil t)
	    ;;;  (insert-char ?\  (/ ncols nwhites))
	    ;;;  (skip-chars-backward " "))
	    ;;; rewritten code
	    (while (find-space-insertable-point)
	      (insert-char ?\  (/ ncols nwhites))
	      (skip-chars-backward " ")) ; skip inserted SPC.
	    ;;; end of patch
	    ;; Make a bit vector for where to add the rest.
	    (setq ncols (% ncols nwhites))
	    (setq flags (make-string nwhites 0))
	    ;; Randomly set NCOLS different bits.
	    (while (> ncols 0)
	      (let ((where (% (logand 262143 (random)) nwhites)))
		(or (> (aref flags where) 0)
		    (progn
		      (aset flags where 1)
		      (setq ncols (1- ncols))))))
	    ;; Insert a space at the boundaries flagged in the vector.
	    (goto-char (point-max))
	    (let ((where 0))
	      (while
	          ;;; original code
		  ;;; (search-backward " " nil t)
		  ;;; rewritten code
		  (find-space-insertable-point)
		  ;; end of patch
		(if (> (aref flags where) 0)
		    (insert " "))
		(setq where (1+ where))
		(skip-chars-backward " ")))))))))

(defun fill-individual-paragraphs (min max &optional justifyp mailp)
  "Fill each paragraph in region according to its individual fill prefix.
Calling from a program, pass range to fill as first two arguments.
Optional third and fourth arguments JUSTIFY-FLAG and MAIL-FLAG:
JUSTIFY-FLAG to justify paragraphs (prefix arg),
MAIL-FLAG for a mail message, i. e. don't fill header lines."
  (interactive "r\nP")
  (save-restriction
    (save-excursion
      (goto-char min)
      (beginning-of-line)
      (if mailp 
	  (while (looking-at "[^ \t\n]*:")
	    (forward-line 1)))
      (narrow-to-region (point) max)
      ;; Loop over paragraphs.
      (while (progn (skip-chars-forward " \t\n") (not (eobp)))
	(beginning-of-line)
	(let ((start (point))
	      fill-prefix fill-prefix-regexp)
	  ;; Find end of paragraph, and compute the smallest fill-prefix
	  ;; that fits all the lines in this paragraph.
	  (while (progn
		   ;; Update the fill-prefix on the first line
		   ;; and whenever the prefix good so far is too long.
		   (if (not (and fill-prefix
				 (looking-at fill-prefix-regexp)))
		       (setq fill-prefix
			     (buffer-substring (point)
					       (save-excursion (skip-chars-forward " \t") (point)))
			     fill-prefix-regexp
			     (regexp-quote fill-prefix)))
		   (forward-line 1)
		   ;; Now stop the loop if end of paragraph.
		   (and (not (eobp))
			(if fill-individual-varying-indent
			    ;; If this line is a separator line, with or
			    ;; without prefix, end the paragraph.
			    (and 
			     (not (looking-at paragraph-separate))
			     (save-excursion
			       (not (and (looking-at fill-prefix-regexp)
					 (progn (forward-char (length fill-prefix))
						(looking-at paragraph-separate))))))
			  ;; If this line has more or less indent
			  ;; than the fill prefix wants, end the paragraph.
			  (and (looking-at fill-prefix-regexp)
			       (save-excursion
				 (not (progn (forward-char (length fill-prefix))
					     (or (looking-at paragraph-separate)
						 (looking-at paragraph-start))))))))))
	  ;; Fill this paragraph, but don't add a newline at the end.
	  (let ((had-newline (bolp)))
	    (fill-region-as-paragraph start (point) justifyp)
	    (or had-newline (delete-char -1))))))))

