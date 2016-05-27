(in-package :story)

(define-story-module wiki
  :depends-on (:iron-request :page)
  :stylesheets (("wiki.css" wiki-css))
  :scripts ("marked.js" ("wiki.js" wiki)))

(defvar *wiki-directory* (story-modules-file "wiki/sample-wiki/"))

(defun wiki-page-filename (name)
  (format nil "~A~A.md" *wiki-directory* (substitute #\- #\space name)))

(defun wiki-page-exists (name)
  (probe-file (wiki-page-filename name)))

(defun load-wiki-page (name)
  (when (wiki-page-exists name)
    (slurp-file (wiki-page-filename name))))

(defun list-wiki-links (name)
  (let (rtn (text (load-wiki-page name)))
    (do-scans (start end rstart rend "\\[\\[([a-zA-Z0-9\\s]*)\\]\\]" text)
      (push (subseq text (aref rstart 0) (aref rend 0)) rtn))
    (nreverse rtn)))

(defun list-wiki-pages ()
  (sort (mapcar #L((substitute #\space #\- (pathname-name %)))
                (remove-if-not #L(equal (pathname-type %) "md")
                               (directory-files *wiki-directory*)))
        #'string<))

(defun build-wiki-tree (&optional (root "Home"))
  (let ((hash (make-hash-table :test 'equal)))
    (labels ((recur (el &optional ignore)
               (setf (gethash el hash) t)
               (cons
                (if (wiki-page-exists el) el (format nil "* ~A" el))
                (let ((links (list-wiki-links el)))
                  (iter (for link in links)
                        (unless (or
                                 (member link ignore :test #'string=)
                                 (gethash link hash))
                          (collect (recur link links))))))))
      (nconc (recur root)
             (when-let (unliked
                        (mapcar #'list (sort (set-difference (list-wiki-pages)
                                                             (iter (for (k v) in-hashtable hash) (collect k)) :test 'equal)
                                             #'string<)))
               (cons (list :hr) unliked))))))

(defun render-wiki-tree-row (stream level name)
  (if (eq name :hr)
      (html (:hr))
      (let ((missing (equal (char name 0) #\*)))
        (when missing (setf name (subseq name 2)))
        (html
          (:div
           :class (when missing "wiki-missing")
           :onclick (format nil "selectIlink(\"~A\");" name)
           (:span :style (format nil "display:inline-block;width:~Apx;" (* (max 0 (1- level)) 20)))
           (esc name))))))

(in-package :story-js)

(define-script wiki

  (define-story-module-parameters wiki (title url home title-id body-id page)
    (fetch-wiki-page home))

  (defun setup-wiki (title url home title-id body-id)
    (setf *wiki-title* title
          *wiki-url* url
          *wiki-home* home
          *wiki-title-id* title-id
          *wiki-body-id* body-id)
    (fetch-wiki-page home))

  (defun fetch-wiki-page (page)
    (request (+ *wiki-url* "/" page ".md") handle-wiki-response)
    (setf *wiki-page* page)
    (let ((text (+ *wiki-title* " — " ((@ page replace) (regex "/-/g") " "))))
      (setf (@ document title) text)
      (set-html (id *wiki-title-id*) text)))

  (defun handle-wiki-response (val)
    (set-html (id *wiki-body-id*) (marked (@ val response))))

  (defun select-ilink (ilink)
    (page (+ "/" ((@ ilink replace) (regex "/ /g") "-"))))

  (defun reload-wiki () (fetch-wiki-page *wiki-page*))

  (defun view-wiki-home ()
    (page "/Home"))

  (defun view-wiki-source ()
    (visit-url (+ *wiki-url* *wiki-page*)))

  (defun edit-wiki ()
    (visit-url (+ *wiki-url* *wiki-page* "/_edit")))

  )

;; (defun toggle-wiki-view ()
;;   (let ((listing (get-by-id "wiki-listing"))
;;         (button (get-by-id "wiki-view-toggle")))
;;     (setf (@ button icon) (if (= (@ listing selected) 0) "toc" "list"))
;;     (setf (@ listing selected) (if (= (@ listing selected) 0) 1 0))))


(in-package :story-css)

(defun wiki-css () "a.ilink {cursor:pointer;color:blue;}")
