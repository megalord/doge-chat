(in-package :task.compile)

(compile

  (:head
    (:title "Chat")
    (:link :href "http://fonts.googleapis.com/css?family=Ubuntu+Mono" :rel "stylesheet" :type "text/css")
    (:link :href "main.css" :rel "stylesheet" :type "text/css"))
  (:body
    (:pre "
                Y.                      _
                YiL                   .```. 
                Yii;                .; .;;`.
                YY;ii._           .;`.;;;; :
                iiYYYYYYiiiii;;;;i` ;;::;;;;
            _.;YYYYYYiiiiiiYYYii  .;;.   ;;;
         .YYYYYYYYYYiiYYYYYYYYYYYYii;`  ;;;;
       .YYYYYYY$$YYiiYY$$$$iiiYYYYYY;.ii;`..
      :YYY$!.  TYiiYY$$$$$YYYYYYYiiYYYYiYYii.
      Y$MM$:   :YYYYYY$!'``'4YYYYYiiiYYYYiiYY.
   `. :MM$$b.,dYY$$Yii' :'   :YYYYllYiiYYYiYY
_.._ :`4MM$!YYYYYYYYYii,.__.diii$$YYYYYYYYYYY
.,._ $b`P`     '4$$$$$iiiiiiii$$$$YY$$$$$$YiY;
   `,.`$:       :$$$$$$$$$YYYYY$$$$$$$$$YYiiYYL
    '`;$$.    .;PPb$`.,.``T$$YY$$$$YYYYYYiiiYYU:
    ;$P$;;: ;;;;i$y$'!Y$$$b;$$$Y$YY$$YYYiiiYYiYY
    $Fi$$ .. ``:iii.`-':YYYYY$$YY$$$$$YYYiiYiYYY
    :Y$$rb ````  `_..;;i;YYY$YY$$$$$$$YYYYYYYiYY:
     :$$$$$i;;iiiiidYYYYYYYYYY$$$$$$YYYYYYYiiYYYY.
      `$$$$$$$YYYYYYYYYYYYY$$$$$$YYYYYYYYiiiYYYYYY
      .i!$$$$$$YYYYYYYYY$$$$$$YYY$$YYiiiiiiYYYYYYY
     :YYiii$$$$$$$YYYYYYY$$$$YY$$$$YYiiiiiYYYYYYi'

            Such terminal. Very ascii. Wow.
            ")
    (:div :id "history" nil)
    (:form :id "chat"
           
           (raw (task.message:render "" "" (markup (:input :type "text")))))
    (map-files "compiled/**/*.js"
               (lambda (path)
                 (markup (:script :src (relative-to path #P"compiled/")
                                  nil))))))
