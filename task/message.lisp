(defpackage :task.message
  (:use :cl :cl-markup)
  (:export :render :msg-from-raw))

(in-package :task.message)

(defun split (pat str)
  (loop for i = 0 then (+ j 2)
        as j = (search pat str :start2 i)
        collect (subseq str i j)
        while j))

(defun parse (raw)
  (destructuring-bind (username date text)
    (split "::" raw)
    ; do something with text
    (list username date text)))

(defun render (username date text-or-html)
  (markup
    (:span :class "username" username)
    (:span " at ")
    (:span :class "date" date)
    (:span " in ")
    (:span :class "dir" "~")
    (:span " $ ")
    (:span (raw text-or-html))))
 
(defun msg-from-raw (raw)
  (apply #'render (parse raw)))
