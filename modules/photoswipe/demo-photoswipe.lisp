(in-package :story)

(define-demo photoswipe (:photoswipe :sample-images)
  (:style (str ".pswp__bg {background:white;}"))
  (:div :onclick "showPhotoswipeDemo();" "Again")
  (script*
    `(progn
       (defun show-photoswipe-demo ()
         (show-image-gallery
          (ps:array
           ,@(iter (for word in (split-sequence #\space "Photoswipe is working!"))
                   (collect `(create :src ,(format nil "/sample-images/~A.png" word) :w 400 :h 200))))))
       (show-photoswipe-demo))))
