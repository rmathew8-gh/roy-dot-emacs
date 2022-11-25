(use-package emacs
  :load-path "lisp"
  :after (dired-x)

  :init
  (global-hl-line-mode 1)
  (setenv "PAGER" "/bin/cat")
  (setenv "EDITOR" "/usr/bin/emacsclient")
  (setq custom-file  (expand-file-name "~/.emacs.d/lisp/custom.el"))
  (load custom-file)

  ;; (load-library "roy-minor-modes")

  (windmove-default-keybindings 'meta) ;; bind motions to M-[<arrow-keys>]

  (prefer-coding-system       'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  :bind
  ("C-<f11>" . highlight-changes-mode)
  ("<f12>" . call-last-kbd-macro)
  ("<home>" . beginning-of-buffer)
  ("<end>" . end-of-buffer))

(use-package emacs
  :hook
  (window-setup
   . (lambda ()
       ;; this shows window frame.. 
       (add-to-list 'initial-frame-alist '(fullscreen . fullboth)) ; was maximized
       (add-to-list 'default-frame-alist '(fullscreen . fullboth))

       (tool-bar-mode -1)
       (menu-bar-mode -1)
       (scroll-bar-mode -1)

       (when (or (eq system-type 'darwin) (eq system-type 'gnu/linux))
     (set-face-attribute 'default nil :family "Monaco" :height 145)))))

;; on x11
(use-package emacs
  :if
  (eq window-system 'x)
  :bind
  (("M-<up>" . #'scroll-other-window-down)
   ("M-<down>" . #'scroll-other-window)))

;; home pc
(use-package emacs
  :if
  (string= (system-name) "manjaro")
  :init
  (load-theme 'modus-operandi t))

;; work macbook
(use-package emacs
  :if
  (string= (system-name) "rmathew8-mbp")

  :init
  (load-theme 'leuven t)
  (setq dired-use-ls-dired nil) ;; macOS: ls doesn't support --dired option
  (global-unset-key (kbd "s-n"))
  (global-unset-key (kbd "s-w")))

(use-package emacs
  :if
  (string= (system-name) "devvm2907.frc0.facebook.com")
  :init
  (add-to-list 'auto-mode-alist '("\\.buckconfig" . shell-script-mode))
  (add-to-list 'auto-mode-alist '("\\.bcfg$" . shell-script-mode))
  (setq url-proxy-services
    '(("no_proxy" . "^\\(localhost\\|10.*\\)")
      ("http" . "fwdproxy:8080")
      ("https" . "fwdproxy:8080"))))

(use-package emacs
  :init
  (set-default 'truncate-lines t)
  (recentf-mode t)
  (setq completion-ignore-case t)
  (setq read-file-name-completion-ignore-case t))


(provide 'init-emacs)

