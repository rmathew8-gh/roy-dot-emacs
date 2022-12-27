(use-package emacs
  :load-path "lisp"
  :after (dired-x)

  :init
  (global-hl-line-mode 1)
  (setenv "PAGER" "/bin/cat")
  (setenv "EDITOR" "/usr/bin/emacsclient")

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

;; TODO: move all this to better places.
(use-package emacs
  :config
  (autoload 'zap-up-to-char "misc"
    "Kill up to, but not including ARGth occurrence of CHAR." t)

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

  ;; https://www.emacswiki.org/emacs/SavePlace
  (save-place-mode 1)

  (global-set-key (kbd "M-/") 'hippie-expand)
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  (global-set-key (kbd "M-z") 'zap-up-to-char)

  (show-paren-mode 1)
  (setq-default indent-tabs-mode nil)
  (savehist-mode 1)

  (setq save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t
        require-final-newline t
        load-prefer-newer t
        frame-inhibit-implied-resize t
        custom-file (expand-file-name "lisp/custom.el" user-emacs-directory))

  (load custom-file))

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
  (load-theme 'modus-operandi t)
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

(use-package emacs
  :init
  (setq
    ;; '(auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
    auto-save-default t               ;; auto-save every buffer that visits a file
    auto-save-interval 200            ;; number of keystrokes between auto-saves (default: 300)
    auto-save-timeout 20              ;; number of seconds idle time before auto-save (default: 30)
    backup-by-copying t               ;; Copy all files, don't rename; don't clobber symlinks
    delete-by-moving-to-trash t
    delete-old-versions t             ;; delete excess backup files silently
    kept-new-versions 4               ;; Number of newest versions to keep.
    kept-old-versions 2               ;; oldest versions to keep when a new numbered backup is made (default: 2)
    make-backup-files t               ;; backup of a file the first time it is saved.
    version-control t                 ;; version numbers for backup files
    vc-make-backup-files t))


(provide 'init-emacs)

