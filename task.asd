(asdf:defsystem task
  :version "0.0.0"
  :author "megalord"
  :license "MIT"
  :description ""
  :pathname "task"
  :depends-on (:cl-async
               :cl-ppcre
               :cl-markup
               :cl-css
               :parenscript
               :ningle
               :clack
               :websocket-driver)
  :components ((:file "server")
               (:file "compile")
               (:file "message")
               (:file "socket" :depends-on ("message"))
               (:file "main" :depends-on ("server" "compile" "socket"))))
