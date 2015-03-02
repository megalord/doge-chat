(in-package :task.compile)

(compile

  (funcall
    (lambda ()

      (let* ((socket)
             (username)
             (history (chain document (get-element-by-id "history")))
             (chat (chain document (get-element-by-id "chat")))
             (date (chain chat (query-selector ".date"))))

        (defun write-history (html)
          (let ((div (chain document (create-element "div"))))
            (setf (@ div inner-h-t-m-l) html)
            (chain history (append-child div))))

        (defun send (message)
          (chain socket (send (+ username
                                 "::"
                                 (@ date text-content)
                                 "::"
                                 message))))

        (defun handle-chat (event)
          (chain event (prevent-default))
          (let* ((input (chain event target elements 0))
                 (text (@ input value)))
            (unless (string= text "")
              (send text)
              (setf (@ input value) ""))))

        (defun start-chat ()
          (flet ((update-time ()
                              (setf (@ date text-content)
                                    (chain (new (-date)) (to-locale-string)))))
            (update-time)
            (set-interval update-time 1000))
          (setf (@ chat style display) "block")
          (chain chat (query-selector "input[type=text]") (focus)))

        (defun activate-socket ()
          (chain chat (add-event-listener "submit" handle-chat))
          (setf (@ socket onmessage) (lambda (event)
                                       (write-history (@ event data))))
          (chain window (add-event-listener "beforeunload" (lambda ()
                                                             (chain socket (close)))))
          (start-chat))

        (defun deactivate-socket ()
          (chain chat (remove-event-listener "submit" handle-chat)))

        (defun handle-login (event)
          (setf username (@ event detail))
          (setf (chain chat (query-selector ".username") text-content) username)
          (setf socket
                (new (-web-socket
                       (+ "ws://"
                          (@ location hostname)
                          ":"
                          (or (1+ (parse-int (@ location port))) "")
                          "/doge-chat/socket"))))
          (setf (@ socket onopen) activate-socket)
          (setf (@ socket onclose) deactivate-socket))

        (chain document (add-event-listener "login" handle-login))))))
