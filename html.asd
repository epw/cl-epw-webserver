;;;; -*- Mode: Lisp -*-

(defpackage #:html-asd
  (:use :cl :asdf))

(in-package :html-asd)

(defsystem html
  :name "HTML"
  :version "0.5"
  :maintainer "Eric Willisson"
  :author "Eric Willisson"
  :description "HTML functions using Eric's XML package."
  :components ((:file "html"))
  :depends-on (xml))
