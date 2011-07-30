(ql:quickload '(parenscript hunchentoot))

(defpackage :cl-epw-webserver
  (:use :cl :eric :html))

(in-package :cl-epw-webserver)

(defvar *server* nil "The web server")

(defun start ()
  (hunchentoot:start
   (setf *server* (make-instance 'hunchentoot:acceptor :port 4242))))

(defun stop ()
  (hunchentoot:stop *server*))

(provide :cl-epw-webserver)
