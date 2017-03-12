(defsystem "story-module-files"
  :defsystem-depends-on ("story-module-system")
  :class :story-module-system
  :category "none"
  :icon :puzzle-piece
  :description "none"
  :version "0.1"
  :author "unknown"
  :license "unknown"
  :serial t
  :depends-on ("story-modules" "story-module-images" "story-module-polymer" "cl-json")
  :components ((:static-file "story-module-files.asd")
               (:file "files")
               (:file "demo-files")))
