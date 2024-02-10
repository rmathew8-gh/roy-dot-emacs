(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (list (cons "." (concat user-emacs-directory "backups"))))
 '(create-lockfiles nil)
 '(custom-safe-themes
   '("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
 '(ediff-diff-options "-w")
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(electric-indent-mode nil)
 '(fill-column 100)
 '(flycheck-error-list-minimum-level 'warning)
 '(grep-command "grep -niH --null -e ")
 '(grep-find-command
   '("find . -type f -exec grep -niH --null -e  \\{\\} +" . 42))
 '(ibuffer-use-other-window t)
 '(inhibit-startup-screen t)
 '(initial-major-mode 'fundamental-mode)
 '(initial-scratch-message nil)
 '(magit-ediff-dwim-show-on-hunks t)
 '(magit-repository-directories '(("~/git-dir" . 1)))
 '(markdown-command "pandoc")
 '(package-selected-packages
   '(disk-usage yasnippet yaml-mode xclip which-key vertico use-package unicode-fonts typescript-mode spaceline rust-mode rg restclient pyvenv python-pytest pytest py-yapf password-generator org-transform-tree-table org-bullets orderless ob-rust ob-async nodejs-repl multiple-cursors marginalia magit lsp-treemacs lsp-pyright lsp-docker json-mode js2-mode jq-format imenu-list go-mode git-timemachine flycheck embark-consult elisp-format elisp-autofmt docker-tramp docker dired-rsync company clojure-mode clipetty alert))
 '(require-final-newline 'ask)
 '(sort-fold-case t)
 '(split-height-threshold nil)
 '(split-width-threshold 100)
 '(tab-width 4)
 '(temporary-file-directory "/tmp/")
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(visible-bell t)
 '(warning-suppress-types '((use-package))))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'enable-recursive-minibuffers 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'eval-expression 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
