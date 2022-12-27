(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (list (cons "." (concat user-emacs-directory "backups"))))
 '(create-lockfiles nil)
 '(custom-safe-themes
   '("a15bf10d72178d691b09c4bbf6d24b15c156fbae9e6fdbaf9aa5e1d9b4c27ca6" "fe36e4da2ca97d9d706e569024caa996f8368044a8253dc645782e01cd68d884" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
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
   '(autothemer dracula-theme spacegray-theme arjen-grey-theme org-auto-tangle yaml-mode xclip which-key vertico use-package spacemacs-theme spaceline rg restclient pyvenv pytest py-yapf projectile password-generator org-superstar org-download org-bullets orderless nodejs-repl multiple-cursors marginalia magit lsp-ui lsp-pyright js2-mode go-mode embark-consult docker-tramp docker dired-rsync company clojure-mode clipetty))
 '(safe-local-variable-values
   '((eval add-hook #'after-save-hook
           (lambda nil
             (org-ascii-export-as-ascii))
           nil t)
     (eval add-hook #'after-save-hook
           (lambda nil
             (progn
               (org-html-export-as-html)
               (org-ascii-export-as-ascii)))
           nil t)
     (eval add-hook #'after-save-hook
           (lambda nil
             (progn
               (org-ascii-export-as-ascii)
               (org-html-export-as-html)))
           nil t)
     (eval add-hook #'after-save-hook
           (lambda nil
             (progn
               (org-ascii-export-as-ascii)
               (org-ascii-export-as-html)))
           nil t)))
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

