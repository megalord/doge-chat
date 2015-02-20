(defpackage :task.compile
  (:use :cl :cl-async :cl-ppcre :cl-markup :parenscript)
  (:import-from :cl-css :css)
  (:shadow :compile)
  (:export :watch
           :compile
           :map-files
           :relative-to))

(in-package :task.compile)

(defmacro switch (operator operand &rest clauses)
  `(cond
     ,@(mapcar #'(lambda (clause)
                   (let* ((operand2 (car clause))
                          (form (car (last clause)))
                          (test-form (if (eql t operand2)
                                       t
                                       (list operator operand operand2))))
                     (list test-form form)))
               clauses)))

(defun change-extension (path extension)
  (make-pathname
    :directory (pathname-directory path)
    :name (pathname-name path)
    :type extension))

(defun drop-extension (path)
  (pathname (concatenate 'string (directory-namestring path) (pathname-name path))))

(defun relative-to (path dir)
  (enough-namestring path (merge-pathnames dir (truename "."))))

(defun replace-directory (path src target)
  (pathname (regex-replace
              (format nil "~a/" src)
              (namestring path)
              (format nil "~a/" target))))
 
(defun get-compiler (lang)
  (switch string= lang
          ("html" 'markup)
          ("js" 'ps)
          ("css" 'css)
          (t 'eval)))

(defun transform-file (source target compiler)
  (let ((compiled-content (with-open-file (stream source)
                            (funcall compiler (read stream)))))
    (with-open-file (stream target :direction :output :if-exists :supersede)
      (format stream compiled-content))))

(defmacro compile (&rest body)
  (let* ((compiled-path (drop-extension (replace-directory *load-pathname* "src" "compiled")))
         (compiler (get-compiler (pathname-type compiled-path))))
     `(with-open-file (stream ,compiled-path :direction :output :if-exists :supersede)
        (write-string (,compiler ,@body) stream))))

(defun map-files (glob fn)
  (mapcar fn (directory (pathname glob))))

(defun watch-files (glob interval fn)
  (with-interval (interval)
                 (map-files glob (lambda (path)
                   (when (>= interval (- (get-universal-time)
                                         (file-write-date path)))
                     (format t "File changed: ~a~%" (namestring path))
                     (funcall fn path))))))

(defun watch ()
  (progn
    (format t "~%Watching project files.~%~%")
    (start-event-loop
      (lambda ()
        (watch-files "src/**/*.lisp" 1 #'load)))))
