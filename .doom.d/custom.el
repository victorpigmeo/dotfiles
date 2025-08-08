(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(cider-font-lock-dynamically nil)
 '(cider-print-options nil)
 '(company-minimum-prefix-length 3)
 '(ignored-local-variable-values '((eval setenv "NU_COUNTRY" "br")))
 '(lsp-auto-guess-root nil)
 '(lsp-dart-flutter-sdk-dir "/home/victor/flutter")
 '(lsp-dart-line-length 80)
 '(lsp-dart-sdk-dir "/home/victor/flutter/bin/cache/dart-sdk")
 '(lsp-enable-snippet nil)
 '(lsp-idle-delay 0.05)
 '(lsp-log-io nil)
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(package-selected-packages '(mvn lsp-java))
 '(projectile-globally-ignored-directories
   '("^flow-typed$" "^node_modules$" "~/.emacs.d/.local/" "^\\.idea$" "^\\.vscode$" "^\\.ensime_cache$" "^\\.eunit$" "^\\.git$" "^\\.hg$" "^\\.fslckout$" "^_FOSSIL_$" "^\\.bzr$" "^_darcs$" "^\\.pijul$" "^\\.tox$" "^\\.svn$" "^\\.stack-work$" "^\\.ccls-cache$" "^\\.cache$" "^\\.clangd$" "^\\node_modules"))
 '(safe-local-variable-values
   '((eval setenv "NU_COUNTRY" "co")
     (cider-clojure-cli-aliases . "dev:test")
     (cider-lein-parameters . "catalyst-repl :headless :host localhost"))))

;; TODO remove after lsp fix
(map! :after lsp-mode
      :leader

      :desc "Format workaround"
      "c f" #'lsp-format-buffer)

;; Plantuml
(setq plantuml-default-exec-mode 'jar)
(setq plantuml-jar-args '("-tpng"))
(setq plantuml-output-type "png")
(setq plantuml-java-args (list "-Djava.awt.headless=true" "-jar"))
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

;; Java Setup
(setq lsp-java-vmargs '("-XX:+UseG1GC" "-XX:+UseStringDeduplication" "-javaagent:/home/victor/.m2/repository/org/projectlombok/lombok/1.18.38/lombok-1.18.38.jar" "-Xbootclasspath/a:/home/victor/.m2/repository/org/projectlombok/lombok/1.18.38/lombok-1.18.38.jar"))

(defun mvn-clean-package-spring-boot-run ()
  (interactive)
  (mvn "spring-boot:run -DskipTests"))


;; (require 'protobuf-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
