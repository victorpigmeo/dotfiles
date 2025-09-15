;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Comentary:
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;;; Code:
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Victor Carvalho"
      user-mail-address "victor.blq@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula
      ;; If you use `org' and don't want your org files in the default location below,
      ;; change `org-directory'. It must be set before org loads!
      org-directory "~/org/"
      ;; This determines the style of line numbers in effect. If set to `nil', line
      ;; numbers are disabled. For relative line numbers, set this to `relative'.
      display-line-numbers-type t
      doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)

      projectile-project-search-path '("~/dev/")
      projectile-enable-caching nil
      evil-split-window-below t
      evil-vsplit-window-right t
      doom-localleader-key ","
      +format-on-save-enabled-modes '(dart-mode)
      lsp-ui-peek-enable nil)

(setq lsp-clojure-custom-server-command "/home/victor/dev/clojure-lsp/clojure-lsp")

(setq-default evil-kill-on-visual-paste nil)

;; cider
(set-popup-rule! "*cider-test-report*" :side 'right :width 0.4)

;; clojure-lsp
;;
(setq lsp-semantic-tokens-enable t)

(use-package! paredit
  :hook ((clojure-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)))

(use-package rainbow-delimiters
  :hook ((clojure-mode . rainbow-delimiters-mode)))

;; projectile
(after! projectile
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD")
  (add-to-list 'projectile-project-root-files-bottom-up "project.clj")
  (add-to-list 'projectile-project-root-files-bottom-up "pom.xml"))

(after! js2-mode
  (add-to-list 'projectile-globally-ignored-directories "node_modules"))

;;remove yasnippet from backends
(setq +lsp-company-backends '(:separate company-capf))

;; NodeJS
(setq node-path "/home/victor/.nvm/versions/node/v22.19.0/bin")
(after! lsp-mode
  (setq exec-path (append exec-path '(node-path))))

(setenv "PATH" (concat (getenv "PATH") (concat  ":" node-path)) )

(defun run-current-file ()
  "Run the current file using the appropriate interpreter/command."
  (interactive)
  (let* ((file-path (buffer-file-name))
         (file-extension (file-name-extension file-path))
         (command ""))
    (message file-extension)
    (cond
     ((or (string= file-extension "js") (string= file-extension "ts")) (setq command (format "node %s" file-path)))
     ;; Add more conditions for other file types
     ;;
     (t (message "No run command defined for this file type: %s" file-extension)))
    (when (not (string= command ""))
      (async-shell-command command)))) ; Use async-shell-command to run in the background

(map! :localleader
      :desc "Run current file"
      "r f" #'run-current-file)

;; Java LSP (Uncomment for java environment)
;; (setenv "JAVA_HOME"  "/usr/lib/jvm/java-21-openjdk-amd64")
;; (setq lsp-java-java-path "/usr/bin/java"

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

(load! "+bindings")
(load! "+nubank")
;;; config.el Ends here
