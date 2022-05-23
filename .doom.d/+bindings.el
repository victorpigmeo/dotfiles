;;; +bindings.el --- Description -*- lexical-binding: t; -*-
;;; Code:

(map! :nv

      :desc "Comment selected lines"
      "C-/" #'comment-line

      :desc "Evil multiword edit"
      "M-r" #'evil-multiedit-match-all)

(map! :nvi
      :desc "Expand region"
      "M-=" #'er/expand-region

      :desc "Reverse expand region"
      "M--" (lambda () (interactive) (er/expand-region -1)))

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader

      :desc "Cider jack in CLJ"
      "s" #'cider-jack-in-clj)

;;; +bindings.el ends here
