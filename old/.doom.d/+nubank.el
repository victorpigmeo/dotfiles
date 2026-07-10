;;; +nubank.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Victor Carvalho
;;
;; Author: Victor Carvalho <victor.blq@gmail.com>
;; Maintainer: Victor Carvalho <victor.blq@gmail.com>
;; Created: maio 30, 2022
;; Modified: maio 30, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/victor/+nubank
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu nil t)))

(add-to-list 'projectile-project-search-path "~/dev/nu/" "~/dev/nu/mini-meta-repo/packages")
;;; +nubank.el ends here
