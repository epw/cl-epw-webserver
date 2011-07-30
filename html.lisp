(defpackage :html
  (:use :cl :xml)
  (:export :styles
	   :css
	   :html))

(in-package :html)

(defun interpret-arg (arg)
	   (typecase arg
	     (keyword (format nil "~(#~a~)" arg))
	     (list (format nil "~(~{~a~^ ~}~)" arg))
	     (symbol (substitute #\: #\= (symbol-name arg)))
	     (t arg)))

(defun styles (styles)
  (if styles
      (let ((style (first styles)))
	(format nil "~(~a: ~{~a~^ ~}~); ~a" (first style) (rest style)
		(styles (rest styles))))
      ""))

(defun css (rules)
  (if rules
    (let ((rule (first rules)))
      (format nil "~(~a~) { ~a}~%~a" (interpret-arg (first rule))
	      (styles (rest rule))
	      (css (rest rules))))
    ""))

(defun style-tag (rules)
  `(style (@ (type "text/css"))
	  ,(css rules)))

(defun html (sexp)
  (let ((*TOP* "<!DOCTYPE HTML>"))
    (xml sexp)))

(provide :html)
