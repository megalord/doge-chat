(defpackage :task
  (:use :cl)
  (:export :develop))

(in-package :task)

(defun quit ()
  (task.server:stop)
  (task.socket:stop)
  (format t "Development exited.~%"))

(defun develop ()
  (handler-bind ((sb-sys:interactive-interrupt
                   #'(lambda (c)
                       (progn
                         (format t "Caught interrupt: ~a~%" c)
                         (quit)
                         (cl-async:exit-event-loop)
                         (abort))))
                 (cell-error
                   #'(lambda (c)
                       (format t "Uncaught error: ~a~%" c))))
    (format t "Starting development tasks.~%")
    (task.server:start)
    (task.socket:start)
    (task.compile:watch)))
