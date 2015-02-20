(defpackage :task.server
  (:use :cl
        :clack.builder
        :clack.middleware.static
        :websocket-driver)
  (:export :start
           :stop))

(in-package :task.server)

(defvar *app* (make-instance 'ningle:<app>))
(defvar *server*)

(defun start ()
  (progn
    (format t "~%Starting development server.~%")
    (setf *server*
          (clack:clackup
            (builder
              (<clack-middleware-static>
                :path "/lib/"
                :root (make-pathname :directory '(:relative "lib")))
              (<clack-middleware-static>
                :path "/"
                :root (make-pathname :directory '(:relative "compiled")))
              *app*)
            :port 8080))))
            ;:server :wookie))))

(defun stop ()
  (progn
    (format t "~%Stopping development server.~%")
    (clack:stop *server*)))

(setf (ningle:route *app* "/")
      #'(lambda ()
          '("Hello, world!")))
