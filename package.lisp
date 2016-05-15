
(defpackage story-js
  (:use common-lisp parenscript)
  (:export js-file id set-html console))

(defpackage story
  (:use common-lisp cl-who iterate hunchentoot local-time split-sequence)
  (:import-from story-js id set-html console)
  (:import-from parenscript ps ps* @ new create)
  (:import-from ppcre scan do-scans create-scanner)
  (:import-from alexandria with-output-to-file when-let if-let with-input-from-file assoc-value with-gensyms ensure-list once-only)
  (:import-from cl-ansi-text with-color black red green yellow blue magenta cyan white)
  (:import-from uiop directory-files subdirectories directory-exists-p)
  (:export initialize-story define-story story toggle-production html *deploy-changed-stories* *story*
           script script* starts-with-char))

(require 'story-modules)
