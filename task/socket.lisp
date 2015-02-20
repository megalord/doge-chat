(defpackage :task.socket
  (:use :cl :websocket-driver :task.message)
  (:export :start :stop))

(in-package :task.socket)

(defvar *server*)

(defun broadcast (msg wss)
  (dolist (ws wss)
    (send ws msg)))

(defun start ()
  (progn
    (format t "~%Starting socket server.~%")
    (setf *server* (clack:clackup *echo-server* :server :wookie :port 8081))))

(defun stop ()
  (progn
    (format t "Stopping socket server.~%~%")
    (clack:stop *server*)))

(defparameter *echo-server*
  (let ((wss nil)
        (msgs nil))
    (lambda (env)
      (let ((ws (make-server env)))
        (setf wss (append wss (list ws)))
        (on :open ws
            (lambda (ev)
              (declare (ignore ev))
              (dolist (msg msgs)
                (send ws msg))))
        (on :error ws
            (lambda (ev)
              (format t "~a~%" ev)))
        (on :message ws
            (lambda (ev)
              (let ((msg (task.message:msg-from-raw (event-data ev))))
                (setf msgs (append msgs (list msg)))
                (if (> (length msgs) 20)
                  (setf msgs (rest msgs)))
                (broadcast msg wss))))
        (on :close ws
            (lambda (ev)
              (declare (ignore ev))
              (setf wss (delete ws wss))))
        (lambda (responder)
          (declare (ignore responder))
          (start-connection ws))))))
