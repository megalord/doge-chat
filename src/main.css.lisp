(defpackage :chat.main.css
  (:use :cl :task.compile)
  (:shadowing-import-from :task.compile :compile))

(in-package :chat.main.css)

(defvar *turquiose* '\#5fd7ff)
(defvar *orange* '\#d75f00)
(defvar *purple* '\#af5fff)
(defvar *hotpink* '\#d7005f)
(defvar *limegreen* '\#87ff00)

(compile
  `((body
      :margin 0px
      :padding 20px
      :background \#000000
      :color \#ffffff
      :font-family "Ubuntu Mono")
    (\#chat
      :display none)
    (input[type=text]
      :padding 0px
      :border 0px
      :background \#000000
      :color \#ffffff
      :font-family "Ubuntu Mono"
      :font-size 1em
      :outline 0px)
    (.username
      :color ,*purple*)
    (.date
      :color ,*orange*)
    (.dir
      :color ,*limegreen*)))
