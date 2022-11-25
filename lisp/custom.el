(custom-set-variables
 '(auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
 ;; '(backup-directory-alist '(("." . "~/.emacs.d/backups")))
 '(backup-directory-alist (list (cons "." (concat (getenv "HOME") "/.emacs.d/backups"))))
 '(create-lockfiles nil) ;; cannot be relocated.
 '(custom-safe-themes
   '("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
 '(downcase-region 'disabled nil)
 '(ediff-diff-options "-w")
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(electric-indent-mode nil)
 '(enable-recursive-minibuffers 'disabled nil)
 '(erase-buffer 'disabled nil)
 '(eval-expression 'disabled nil)
 '(grep-command "grep -niH --null -e ")
 '(ibuffer-use-other-window t)
 '(inhibit-startup-screen t)
 '(initial-major-mode 'fundamental-mode)
 '(initial-scratch-message nil)
 '(magit-repository-directories '(("~/git-dir" . 1)))
 '(grep-find-command
   '("find . -type f -exec grep -niH --null -e  \\{\\} +" . 42))
 '(markdown-command "pandoc")
 '(magit-ediff-dwim-show-on-hunks t)
 '(narrow-to-page 'disabled nil)
 '(narrow-to-region 'disabled nil)
 '(package-selected-packages
   '(arduino-mode better-defaults cider clipetty company
     company-graphviz-dot company-lsp consult consult-dir
     dash-functional dired dired-rsync dired-x docker docker-tramp
     eglot elpy embark embark-consult go-mode google-this
     graphviz-dot-mode init-emacs isearch kubernetes kubernetes-tramp
     lata-noweb-mode lsp-mode lsp-pyright lsp-ui magit marginalia
     multiple-cursors mwheel nxml-mode orderless org-bullets
     org-download org-superstar ox-gfm plantuml-mode prettier
     projectile py-yapf pytest pyvenv replace restclient rg rjsx-mode
     rustic savehist sgml-mode spacemacs-theme use-package vertico
     vterm w3m wgrep which-key xclip yaml-mode yapf yapfify))
 '(sort-fold-case t)
 '(split-height-threshold nil)
 '(split-width-threshold 100)
 '(tab-width 4)
 '(temporary-file-directory "/tmp")
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(upcase-region 'disabled nil)
 '(visible-bell t)
 '(warning-suppress-types '((use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

