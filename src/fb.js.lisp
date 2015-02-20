(in-package :task.compile)

(compile

  (funcall
    (lambda ()

      (defun dispatch-login (user)
        (chain document (dispatch-event
                          (new (-custom-event "login" (create detail (@ user name)))))))

      (defun get-user ()
        (chain *fb* (api "/me" (lambda (response)
                                 (if (@ response error)
                                   (alert "Permission denied. Refresh to try again.")
                                   (dispatch-login response))))))

      (setf (@ window fb-async-init)
            (lambda ()
              (chain *fb* (init
                            (create
                              app-id "1614637535426228"
                              xfbml false
                              version "v2.2"
                              status t)))
              (chain *fb*
                     (get-login-status
                       (lambda (response)
                         (if (= (@ response status) "connected")
                           (get-user)
                           (chain *fb* (login get-user))))))))

      (let ((id "facebook-jssdk")
            (fjs (chain document (get-elements-by-tag-name "script") 0)))
        (unless (chain document (get-element-by-id id))
          (let ((js (chain document (create-element "script"))))
            (setf (@ js id) id)
            (setf (@ js src) "//connect.facebook.net/en_US/sdk.js")
            (chain fjs parent-node (insert-before js fjs))))))))
