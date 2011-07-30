(defpackage :xml
  (:use :cl)
  (:export :xml
	   :test
	   :@
	   :*TOP*
	   :*COMMENT*
	   :{}
	   :*SEPARATOR*))

(in-package :xml)

(defun parse-attributes (out attributes)
  (if attributes
      (progn
	(if (symbolp (first attributes))
	    (format out "~(~a~)=\"~a\" " (first attributes)
		    (first attributes))
	    (format out "~(~a~)=\"~a\" " (first (first attributes))
		    (xml (first (rest (first attributes))))))
	(parse-attributes out (rest attributes)))
      ""))

(defvar *TOP* "<?xml version=\"1.0\" ?>"
  "SXML definition for XML opening header")

(defvar *SEPARATOR* "" "String to go after all > in tags")

(defun xml (sexp)
  (if sexp
      (let ((out (make-string-output-stream)))
	(typecase sexp
	  (list
	   (if (symbolp (first sexp))
	       (case (first sexp)
		 (@
		  (parse-attributes out (rest sexp)))
		 ({}
		  (format out "~a" (xml (eval (second sexp)))))
		 (*TOP*
		  (format out "~a~%~a" *TOP* (xml (rest sexp))))
		 (*COMMENT*
		  (format out "<!--~{~a~^ ~}-->~a" (rest sexp) *SEPARATOR*))
		 (t
		  (format out "<~a" (first sexp))
		  (cond ((= (length sexp) 1) (format out " />"))
			((and (= (length sexp) 2)
			      (listp (second sexp))
			      (eq (first (second sexp)) '@))
			 (format out " ~a/>~a" (xml (second sexp))
				 *SEPARATOR*))
			(t
			 (if (and (listp (second sexp))
				  (eq (first (second sexp)) '@))
			     (format out " ~a>~a~a</~a>~a"
				     (xml (second sexp)) *SEPARATOR*
				     (xml (rest (rest sexp))) (first sexp)
				     *SEPARATOR*)
			     (format out ">~a~a</~a>~a" *SEPARATOR*
				     (xml (rest sexp)) (first sexp)
				     *SEPARATOR*))))))
	       (format out "~a~a" (xml (first sexp))
		       (xml (rest sexp)))))
	  (t
	   (format out "~a" sexp)))
	(get-output-stream-string out))
      ""))

(defun test ()
  (let* ((*TOP* "<!DOCTYPE HTML>")
	 (sexp `(*TOP*
		 (html (head
			(title "Hello")
			(link (@ (rel "stylesheet")
				 (href "style.css"))))
		       (body
			(*COMMENT* "Start of page")
			(h1 "Hello")
			(p (@ (class ({} (get-universal-time)))) "Hello, world")
			(div ({} (get-universal-time)))
			"Foo, bar" (br) "Bang, baz"
			(a (@ (href "http://google.com")) "Google"))))))
    (format t "~a~%" (xml sexp))))

(provide :xml)
