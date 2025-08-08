;;; +bindings.el --- Description -*- lexical-binding: t; -*-
;;; Code:
;;;

(define-key evil-normal-state-map (kbd "M-r") 'evil-multiedit-match-all)

(map! :nv

      :desc "Comment selected lines"
      "C-/" #'comment-line)

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

(map! :after dap-mode
      :map dap-mode-map
      :localleader

      :desc "Run"
      "s" #'mvn-clean-package-spring-boot-run

      :desc "Debug"
      "d" #'dap-debug

      :desc "Stop"
      "r q" #'dap-disconnect)

(defun scroll-up-bottom-window ()
  "Scroll up bottom window"
  (interactive)
  (save-selected-window
    (when-let ((bottom-window (-first (lambda (w)
                                        (and (window-full-width-p w)
                                             (not (eq w (get-buffer-window))))) (window-list))))
      (select-window bottom-window)
      (scroll-up-line))))

(defun scroll-down-bottom-window ()
  "Scroll down bottom window"
  (interactive)
  (save-selected-window
    (when-let ((bottom-window (-first (lambda (w)
                                        (and (window-full-width-p w)
                                             (not (eq w (get-buffer-window))))) (window-list))))
      (select-window bottom-window)
      (scroll-down-line))))

(map! :nvi

      :desc "scroll up bottom window"
      "C-M-s-<down>" #'scroll-up-bottom-window

      :desc "scroll down bottom window"
      "C-M-s-<up>" #'scroll-down-bottom-window

      :desc "increase window width"
      "C-S-<left>" (lambda () (interactive) (enlarge-window 5 t))

      :desc "decrease window width"
      "C-S-<right>" (lambda () (interactive) (enlarge-window -5 t))

      :desc "increase window height"
      "C-S-<down>" (lambda () (interactive) (enlarge-window 5))

      :desc "decrease window height"
      "C-S-<up>" (lambda () (interactive) (enlarge-window -5)))

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control up)]  'move-line-up)
(global-set-key [(control down)]  'move-line-down)
;;; +bindings.el ends here
