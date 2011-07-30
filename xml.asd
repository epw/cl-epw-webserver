;;;; -*- Mode: Lisp -*-

(defpackage #:xml-asd
  (:use :cl :asdf))

(in-package :xml-asd)

(defsystem xml
  :name "XML"
  :version "1.0"
  :maintainer "Eric Willisson"
  :description "SXML with slight modifications"
  :components ((:file "xml")))
