;; CCL -- Code Convert Language
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

;;; 93.5.26  created for Mule Ver.0.9.8 by K.Handa <handa@etl.go.jp>
;;; 94.3.8   modified for Mule Ver.1.1
;;;				by M.Yamamoto <mituharu@is.s.u-tokyo.ac.jp>
;;;	Several bug fixed.

(provide 'ccl)

(defconst ccl-operator-list
  '(restart				; dummy
    jump sjump tjump fjump sfjump	; internal use
    clear pop dup exch			; stack operators
    read				; read from a buffer into a stack
    wstr				; write a string to a buffer
    end					; internal use
    ++ -- ** //				; arithmetic unary operators
    + - * / % & |			; arithmetic binary operators
    << >>				; arithmetic shift operators
    !					; logical unary operator
    < > = <= >= /=			; logical binary operator
    l0 l1 l2 l3 l4 l5 l6 l7 l8 l9	; load register
    s0 s1 s2 s3 s4 s5 s6 s7 s8 s9	; store register
    byte1 byte2				; constant value
    )
  "List of symbols for normal operator of CCL program")

(let (l i)
  (setq l ccl-operator-list i 0)
  (while l
    (put (car l) 'ccl-code i)
    (setq l (cdr l) i (1+ i))))

(defmacro ccl-get-code (sym) (list 'get sym '(quote ccl-code)))

(defun ccl-insert-address (pos addr &optional short)
  (let ((dist (- addr pos)))
    (if (>= dist 65536)
	(error "CCL: too long distance (%d)." dist))
    (if (and short (< dist 256))
	(insert dist 0)
      (insert (/ dist 256) (% dist 256)))))

(defun ccl-compile (ccl-program)
  "Return a comiled code of CCL-PROGRAM."
  (let ((regs (aref ccl-program 0))
	(body-prog (aref ccl-program 1))
	(tail-prog (aref ccl-program 2))
	(buf (get-buffer-create " *ccl-compiler-work*"))
	pos)
    (save-excursion
      (set-buffer buf)
      (setq mc-flag nil)
      (erase-buffer)
      (insert-char 0 4)
      (let ((len (length regs))
	    (i 0)
	    reg)
	(while (< i len)
	  (setq reg (aref regs i))
	  (insert (/ reg 256) (% reg 256))
	  (setq i (1+ i)))
	(while (< i 10)
	  (insert-char 0 2)
	  (setq i (1+ i))))
      (setq pos (point))
      (goto-char 1)
      (delete-char 2)
      (ccl-insert-address 1 pos)
      (goto-char pos)
      (insert (ccl-get-code 'restart))
      (if body-prog
	  (ccl-compile-1 body-prog 'end)
	(insert (ccl-get-code 'restart)))
      (setq pos (point))
      (goto-char 3)
      (delete-char 2)
      (ccl-insert-address 1 pos)
      (goto-char pos)
      (ccl-compile-1 tail-prog)
      (insert (ccl-get-code 'end))
      (if (> (point-max) 65536)
	  (error "CCL: program size %d exceeds limit of 64K." (point-max)))
      (buffer-substring (point-min) (point-max)))))

(defun ccl-compile-1 (cmd-list &optional endflag)
  (let (cmd)
    (if (listp cmd-list)
	(while cmd-list
	  (setq cmd (car cmd-list) cmd-list (cdr cmd-list))
	  (ccl-compile-2 cmd (and endflag (null cmd-list))))
      (ccl-compile-2 cmd-list endflag))))

(defun ccl-compile-2 (cmd &optional endflag)
  (cond ((null cmd) (if endflag (insert (ccl-get-code 'restart))))
	((integerp cmd)
	 (cond ((< cmd 0)
		(error "CCL: Can't handle a negative constant (%d)." cmd))
	       ((< cmd 256)
		(if (> cmd (length ccl-operator-list))
		    (insert cmd)
		  (insert (ccl-get-code 'byte1) cmd)))
	       ((< cmd 65536)
		(insert (ccl-get-code 'byte2) (/ cmd 256) (% cmd 256)))
	       (t
		(error "CCL: Can't handle a constant 'ge' 65536 (%d)." cmd)))
	 (if endflag (insert (ccl-get-code 'restart))))
	((stringp cmd)
	 (if (> (length cmd) 256)
	     (error "CCL: Can't write a string longer than 256 bytes.")
	   (if (= (length cmd) 0)
	       (error "CCL: Can't write a string of length 0.")
	     (insert (ccl-get-code 'wstr) (1- (length cmd)) cmd)))
	 (if endflag (insert (ccl-get-code 'restart))))
	((symbolp cmd)
	 (if (memq cmd ccl-operator-list)
	     (insert (ccl-get-code cmd))
	   (error "CCL: Invalid command (%s)." cmd))
	 (if endflag (insert (ccl-get-code 'restart))))
	((consp cmd)
	 (let (pos1 pos2)
	   (setq pos1 (point))
	   (insert-char 0 3)
	   (if (car cmd)
	       (ccl-compile-1 (car cmd) endflag)
	     (if endflag (insert (ccl-get-code 'restart))) ; added
	     )
	   (if (and (null endflag) (car (cdr cmd)))
	       (insert-char 0 3))
	   (setq pos2 (point))
	   (goto-char pos1)
	   (delete-char 3)
	   (insert (ccl-get-code
		    (if (< (- pos2 (1+ (point))) 256) 'sfjump 'fjump)))
	   (ccl-insert-address (point) pos2 'short)
	   (goto-char pos2)
	   (if (car (cdr cmd))
	       (progn
		 (ccl-compile-1 (car (cdr cmd)) endflag)
		 (if (null endflag)
		     (progn
		       (setq pos1 (point))
		       (goto-char pos2)
		       (delete-char -3)
		       (insert (ccl-get-code
				(if (< (- pos1 (1+ (point))) 256)
				    'sjump 'jump)))
		       (ccl-insert-address (point) pos1 'short))))
	     (if endflag (insert (ccl-get-code 'restart))) ; added
	     )))
	((vectorp cmd)
	 (let* ((len (length cmd))
		(adrs (make-vector len 0))
		null-command-list
		pos1 pos2 i last-i)
	   (if (> len 256)
	       (error "CCL: Too many branches (%s)." cmd))
	   (insert (ccl-get-code 'tjump) (1- len))
	   (setq pos1 (point))
	   (insert-char 0 (* len 2))
	   (setq i 0)
	   (while (< i len)
	     (aset adrs i (point))
	     (if (aref cmd i)
		 (progn
		   (setq last-i i)
		   (ccl-compile-1 (aref cmd i) endflag)
		   (if (null endflag) (insert-char 0 3))))
	     (setq i (1+ i)))
	   (if (aref cmd last-i)
	       (delete-char (if endflag -1 -3)))
	   (setq pos2 (point))
	   (save-excursion
	     (goto-char pos1)
	     (delete-char (* len 2))
	     (setq i 0)
	     (while (< i len)
	       (if (aref cmd i)
		   (ccl-insert-address pos1 (aref adrs i))
		 (ccl-insert-address pos1 pos2))
	       (setq i (1+ i))))
	   (if endflag (insert (ccl-get-code 'restart))
	     (setq i 1)
	     (while (< i len)
	       (if (and (aref cmd (1- i)) (/= (1- i) last-i)) ; modified
		   (progn
		     (goto-char (aref adrs i))
		     (delete-char -3)
		     (insert (ccl-get-code
			      (if (< (- pos2 (1+ (point))) 256) 'sjump 'jump)))
		     (ccl-insert-address (point) pos2 'short)))
	       (setq i (1+ i))))
	   )))
  (goto-char (point-max))
  )

(defun ccl-two-byte (str i)
  (+ (* (aref str i) 256) (aref str (1+ i))))

(defun ccl-dump (str)
  (let ((len (length str))
	i cmd mc-flag)
    (insert
     (format "\nBody start at %d:" (ccl-two-byte str 0))
     (format "\nTail start at %d:" (ccl-two-byte str 2))
     "\nInitial register values:")
    (setq i 4)
    (while (< i 24)
      (insert ? )
      (prin1 (ccl-two-byte str i))
      (setq i (+ i 2)))
    (insert (format "\n%3d: restart\nRestart from here:" i))
    (setq i 25)
    (while (< i len)
      (insert (format "\n%3d: " i))
      (setq cmd (aref str i))
      (setq i (1+ i))
      (if (> cmd (length ccl-operator-list))
	  (insert (format "%d" cmd))
	(setq cmd (nth cmd ccl-operator-list))
	(insert (symbol-name cmd))
	(cond ((eq cmd 'byte1)
	       (insert (format " %d" (aref str i)))
	       (setq i (1+ i)))
	      ((eq cmd 'byte2)
	       (insert (format " %d" (+ (* (aref str i) 256)
					 (aref str (1+ i)))))
	       (setq i (+ i 2)))
	      ((eq cmd 'wstr)
	       (let ((len (1+ (aref str i))))
		 (setq i (1+ i))
		 (insert (format " %d " len))
		 (prin1 (substring str i (+ i len)))
		 (setq i (+ i len))))
	      ((memq cmd '(jump fjump))
	       (insert (format " %d:" (+ (* (aref str i) 256)
					 (aref str (1+ i))
					 i)))
	       (setq i (+ i 2)))
	      ((memq cmd '(sjump sfjump))
	       (insert (format " %d:" (+ (aref str i) i)))
	       (setq i (+ i 2)))
	      ((eq cmd 'tjump)
	       (let ((count (1+ (aref str i)))
		     base)
		 (insert (format " %d" count))
		 (setq i (1+ i))
		 (setq base i)
		 (while (> count 0)
		   (insert (format " %d:" (+ (* (aref str i) 256)
					     (aref str (1+ i))
					     base)))
		   (setq i (+ i 2))
		   (setq count (1- count)))))
	      ))
	)))


;; CCL emulation staffs 

(defconst ccl-stack-size 200)
(defconst ccl-stack (make-vector ccl-stack-size 0))
(defconst ccl-register-count 10)
(defconst ccl-register (make-vector ccl-register-count 0))
(defconst ccl-stack-idx 0)

(defun ccl-push (val)
  (if (>= ccl-stack-idx ccl-stack-size)
      (error "CCL-Emulator: Stack overflow")
    (aset ccl-stack ccl-stack-idx val)
    (setq ccl-stack-idx (1+ ccl-stack-idx))))

(defun ccl-pop ()
  (if (<= ccl-stack-idx 0)
      (error "CCL-Emulator: Stack underflow")
    (setq ccl-stack-idx (1- ccl-stack-idx))
    (aref ccl-stack ccl-stack-idx)))

(defconst ccl-command-table
  '[ccl-restart
    ccl-jump ccl-sjump ccl-tjump ccl-fjump ccl-sfjump
    ccl-clear ccl-pop ccl-dup ccl-exch
    ccl-read
    ccl-wstr
    ccl-end
    ccl-inc ccl-dec ccl-twice ccl-half
    ccl-add ccl-sub ccl-mul ccl-div ccl-mod ccl-and ccl-or
    ccl-lshift ccl-rshift
    ccl-not ccl-lt ccl-gt ccl-eq ccl-le ccl-ge ccl-ne
    ccl-r0 ccl-r1 ccl-r2 ccl-r3 ccl-r4 ccl-r5 ccl-r6 ccl-r7 ccl-r8 ccl-r9 
    ccl-s0 ccl-s1 ccl-s2 ccl-s3 ccl-s4 ccl-s5 ccl-s6 ccl-s7 ccl-s8 ccl-s9
    ccl-byte1 ccl-byte2])

(defun ccl-restart () (setq cmd (1- cmd)))
(defun ccl-jump ()
  (setq cmd (+ cmd (* (aref cmds cmd) 256) (aref cmds (1+ cmd)))))
(defun ccl-sjump () (setq cmd (+ cmd (aref cmds cmd))))
(defun ccl-tjump ()
  (let ((i (ccl-pop))
	(j (aref cmds cmd)))
    (setq cmd (1+ cmd))
    (if (or (< i 0) (>= i (1+ j))) (setq i j))
    (setq i (* i 2))
    (setq cmd (+ cmd (* (aref cmds (+ cmd i)) 256) (aref cmds (+ cmd i 1))))))
(defun ccl-fjump ()
  (if (/= (ccl-pop) 0)
      (setq cmd (+ cmd 2))
    (setq cmd (+ cmd (* (aref cmds cmd) 256) (aref cmds (1+ cmd))))))
(defun ccl-clear () (setq ccl-stack-idx 0))
;; (defun ccl-pop () ) -- already defined
(defun ccl-dup ()
  (let ((i (ccl-pop))) (ccl-push i) (ccl-push i)))
(defun ccl-exch ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push i) (ccl-push j)))
(defun ccl-read ()
  (cond ((< s send)
	 (ccl-push (aref src s))
	 (setq s (1+ s)))
	((null endflag)
	 (setq cmd (1- cmd))
	 nil)
	(t
	 (setq cmd (+ (* (aref cmds 2) 256) (aref cmds 3))))))
(defun ccl-wstr ()
  (let ((i (1+ (aref cmds cmd))))
    (setq cmd (1+ cmd))
    (insert (substring cmds cmd (+ cmd i)))
    (setq cmd (+ cmd i))))
(defun ccl-end ()
  (let ((i 0))
    (while (< i ccl-stack-idx)
      (insert (aref ccl-stack i))
      (setq i (1+ i)))
    (setq ccl-stack-idx 0)
    nil))
(defun ccl-inc () (let ((i (ccl-pop))) (ccl-push (1+ i))))
(defun ccl-dec () (let ((i (ccl-pop))) (ccl-push (1- i))))
(defun ccl-twice () (let ((i (ccl-pop))) (ccl-push (* i 2))))
(defun ccl-half () (let ((i (ccl-pop))) (ccl-push (/ i 2))))
(defun ccl-add () (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (+ i j))))
(defun ccl-sub () (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (- j i))))
(defun ccl-mul () (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (* i j))))
(defun ccl-div () (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (/ j i))))
(defun ccl-mod () (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (% j i))))
(defun ccl-and () (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (logand i j))))
(defun ccl-lshift ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (ash j i))))
(defun ccl-rshift ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (ash j (- i)))))
(defun ccl-not () (let ((i (ccl-pop))) (ccl-push (if (= i 0) 0 1))))
(defun ccl-lt ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (if (< j i) 1 0))))
(defun ccl-gt ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (if (> j i) 1 0))))
(defun ccl-eq ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (if (= j i) 1 0))))
(defun ccl-le ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (if (<= j i) 1 0))))
(defun ccl-ge ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (if (>= j i) 1 0))))
(defun ccl-ne ()
  (let ((i (ccl-pop)) (j (ccl-pop))) (ccl-push (if (/ j i) 1 0))))

(defun ccl-interpreter (src dst nsrc ndst cmds ip endflag)
  (let ((cmd ip) (s 0) (send (length src))
	i j p c
	(ccl-restart-code (ccl-get-code 'restart))
	(ccl-l0-code (ccl-get-code 'l0))
	(ccl-s0-code (ccl-get-code 's0))
	(ccl-byte1-code (ccl-get-code 'byte1))
	(ccl-byte2-code (ccl-get-code 'byte2))
	(continue t))
    (if (>= s send)
	nil
      (while continue
	(setq c (aref cmds cmd) cmd (1+ cmd))
	(if (= c ccl-restart-code)
	    (let ((i 0))
	      (while (< i ccl-stack-idx)
		(insert (aref ccl-stack i))
		(setq i (1+ i)))
	      (setq ccl-stack-idx 0)
	      (cond ((< s send)
		     (ccl-push (aref src s))
		     (setq c (aref cmds 25) cmd 26 s (1+ s)))
		    ((null endflag)
		     (setq cmd 24))
		    (t
		     (setq cmd (+ (* (aref cmds 2) 256) (aref cmds 3)))
		     (setq c (aref cmds cmd) cmd (1+ cmd))))))
	(cond ((< c ccl-l0-code)
	       (setq continue (funcall (aref ccl-command-table c))))
	      ((< c ccl-s0-code)
	       (ccl-push (aref ccl-register (- c ccl-l0-code))))
	      ((< c ccl-byte1-code)
	       (aset ccl-register (- c ccl-s0-code) (ccl-pop)))
	      ((= c ccl-byte1-code)
	       (ccl-push (aref cmds cmd))
	       (setq cmd (1+ cmd)))
	      ((= c ccl-byte2-code)
	       (ccl-push (+ (* (aref cmds cmd) 256) (aref cmds (1+ cmd))))
	       (setq cmd (+ cmd 2)))
	      (t
	       (ccl-push c)))))
    ))

(defun ccl-driver (src ccl-prog)
  "Convert SRC string by CCL-PROGRAM (should be a compiled one)."
  (let ((nsrc (length src))
	(dst (get-buffer-create "*ccl-work-buf*"))
	(i 0) ip)
    (save-excursion
      (set-buffer dst)
      (erase-buffer)
      (while (< i ccl-register-count)
	(aset ccl-register i
	      (+ (* (aref ccl-prog (+ (* i 2) 4)) 256)
		 (aref ccl-prog (+ (* i 2) 5))))
	(setq i (1+ i)))
      (setq stack-idx 0)
      (setq ip 24)
      (ccl-interpreter src dst nsrc 0 ccl-prog ip t)
      )))

