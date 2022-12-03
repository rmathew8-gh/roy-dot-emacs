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
   '(arduino-mode cider clipetty company company-graphviz-dot company-lsp consult consult-dir dash-functional dired dired-rsync dired-x docker docker-tramp eglot elpy embark embark-consult go-mode google-this graphviz-dot-mode init-emacs isearch kubernetes kubernetes-tramp lata-noweb-mode lsp-mode lsp-pyright lsp-ui magit marginalia multiple-cursors mwheel nxml-mode orderless org-bullets org-download org-superstar ox-gfm plantuml-mode prettier projectile py-yapf pytest pyvenv replace restclient rg rjsx-mode rustic savehist sgml-mode spacemacs-theme use-package vertico vterm w3m wgrep which-key xclip yaml-mode yapf yapfify))
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

