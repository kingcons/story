(in-package :story)

;;; element

(defclass element ()
  ((parent :reader parent :initform nil :initarg :parent)
   (children :reader children :initform nil :initarg :children)))

(defmethod add-child ((parent element) (child element))
  (cond
    ((member child (children parent))
     (warn "~S is already a child of ~S." child parent))
    (t
     (when (parent child)
       (warn "Replacing parent of ~S ~S with ~S." child (parent child) parent))
     (setf (slot-value child 'parent) parent
           (slot-value parent 'children) (append (children parent) (list child))))))


;;; story

(defclass story (element)
  ((name :reader name :initarg :name)
   (title :reader title :initarg :title :initform "Unititled Story")
   (home :reader home :initarg :home)
   (modules :reader modules :initarg :modules :initform nil)
   (stylesheets :reader stylesheets :initform nil)))

(defmethod print-object ((story story) stream)
  (print-unreadable-object (story stream :type t)
    (format stream "~A" (name story))))

(defmethod initialize-instance :after ((story story) &key)
  (when (modules story)
    (ensure-story-modules (modules story))
    (setf (slot-value story 'stylesheets) (collect-module-stylesheets (modules story)))))


;;; page

(defclass page (element)
  ((path :reader path :initarg :path)
   (title :reader title :initform nil :initarg :title)
   (renderer :reader renderer :initarg :renderer)
   (body :reader body :initarg :body)))

(defmethod print-object ((page page) stream)
  (print-unreadable-object (page stream :type t)
    (format stream "~A" (path page))))
