(defsystem "story-module-wiki"
  :defsystem-depends-on ("story-module-system")
  :class :story-module-system
  :category "none"
  :icon :puzzle-piece
  :description "none"
  :version "0.1"
  :author "unknown"
  :license "unknown"
  :serial t
  :depends-on ("story-modules" "story-module-polymer" "story-module-page")
  :components ((:static-file "story-module-wiki.asd")
               (:file "wiki")
               (:file "demo-wiki")))
