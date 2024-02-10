;; preamble
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)


;; customization
(use-package package
  :custom
  (use-package-always-ensure t)
  (use-package-expand-minimally t)
  :init
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp")))


;; <:common:use-package: init-iterm2 (macbook)>

(use-package dired-x
  :ensure nil
  :bind
  ("<f3>" . (lambda() (interactive)
          (find-file (expand-file-name
              (let ((current-prefix-arg t)) (dired-x-read-filename-at-point "filename: ")))))))

(use-package dired
  :ensure nil
  :hook (dired-before-readin
     . (lambda ()
         (setq default-directory dired-directory)))
  :bind ("C-x C-j" . dired-jump))

(use-package dired-rsync
  :init
  (bind-key "C-c C-r" 'dired-rsync dired-mode-map))


(use-package isearch
  :ensure nil
  :bind (:map isearch-mode-map
         ("C-y" . isearch-yank-line)))

;; hoho - ibuffer
(use-package ibuffer
  :bind ([remap list-buffers] . ibuffer-other-window)
  :custom
  (ibuffer-default-sorting-mode 'recency)
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-expert t))


(use-package shell
  :after (emacs)

  :hook
  ;; ls assumes tab='8 spaces'
  (shell-mode . (lambda () 
    (setq tab-width 8)
    (company-mode -1)))

  :bind (:map shell-mode-map
              ("C-c C-k" . roy-erase-comint-buffer)))

(use-package ediff
  :custom
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-diff-options "-w"))


(use-package magit
  :custom
  (magit-ediff-dwim-show-on-hunks t))

(use-package unicode-fonts
  :if (string= (system-name) "roy-arch")
  :init (unicode-fonts-setup))


;; <:common:use-package: org>
;; <:common:use-package: org-download>

(use-package restclient)

(use-package rg
  :after rg-menu
  :init
  (plist-put (symbol-plist 'rg-menu) 'transient--layout
             (append
              (list [2 transient-column
                       (:description "More Switches")
                       (
                        (4 transient-switch
                           (:key "!"
                                 :description "Files without match"
                                 :argument "--files-without-match"
                                 :command transient:rg-menu:--files-without-match
                                 ))
                        )])
              (plist-get (symbol-plist 'rg-menu) 'transient--layout))))


(use-package jq-format
  :demand t
  :after json-mode)

(use-package py-yapf)

(use-package python
  :after (py-yapf)

  :bind
  (:map python-mode-map
    ("C-c p" . (lambda()
               (interactive)
               (insert "import pdb; pdb.set_trace() # roy")))
    ("C-c C-k" . (lambda()
                       (interactive)
               (with-current-buffer (process-buffer (python-shell-get-process))
             (roy-erase-comint-buffer))))
    ("C-c C-r" . (lambda(beg end)
                       (interactive "r")
               (display-buffer "*Python*")
               (python-shell-send-region beg end)))
    ("C-c C-p" . (lambda()
                       (interactive)
               (run-python)
               (display-buffer "*Python*"))))
  :bind
  (:map inferior-python-mode-map
    ("C-c C-k" . (lambda()
               (interactive)
               (comint-clear-buffer))))

  :custom
  (python-indent-guess-indent-offset-verbose nil)

  :config
  (add-hook 'comint-output-filter-functions 'python-pdbtrack-comint-output-filter-function t)

  :hook
  (python-mode . py-yapf-enable-on-save))

(use-package pyvenv
  :init
  ;; Set correct Python interpreter
  ;; (pyvenv-activate "~/.virtualenvs/py/")

  ;; This works as well.
  (setenv "WORKON_HOME" "~/.virtualenvs")
  (pyvenv-workon "sdxl")

  :custom
  ;; python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))
  (pyvenv-post-activate-hooks
    (list (lambda ()
          (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))))
  (pyvenv-post-deactivate-hooks
    (list (lambda ()
          (setq python-shell-interpreter "python3")))))

(use-package pytest
  :defer t
  :after (pyvenv)
  :bind (("C-x p" . 'roy-ppo))
  :init
  (setq pytest-cmd-flags "-x -s -n0")
  :config (defun roy-ppo()
            (interactive)
            (let ((kill-buffer-query-functions nil)
                  (buf (get-buffer (pytest-get-temp-buffer-name))))
              (if buf (kill-buffer buf)))
            (jump-to-register ?t)
            (pytest-pdb-one)
            (end-of-buffer))
    (add-to-list 'pytest-project-root-files "pytest.ini"))

(use-package python-pytest)

;; mainly use this: M-x python-pytest-dispatch

;; python-pytest
;; python-pytest-file
;; python-pytest-file-dwim
;; python-pytest-files
;; python-pytest-function
;; python-pytest-function-dwim
;; python-pytest-last-failed
;; python-pytest-repeat

(use-package lsp-pyright
  :hook ((python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred)
                          (add-hook 'before-save-hook 'lsp-format-buffer nil t)))))


;; <:common:use-package: w3m>

(use-package xclip
  :init
  (setq select-enable-clipboard t)
  (setq select-enable-primary t)
  (xclip-mode 1))

(use-package clipetty
  :if
  (getenv "SSH_TTY")
  :init
  (global-clipetty-mode))


(use-package vertico
  :custom
  (vertico-multiform-categories
        '((file buffer grid)
          (imenu (:not indexed mouse))
          (symbol (vertico-sort-function . vertico-sort-alpha))))
  ;; vertico-multiform-commands trumps vertico-multiform-categories
  (vertico-multiform-commands
        '((consult-line buffer)
          (consult-imenu reverse buffer)
          (execute-extended-command flat)))

  (vertico-mode t)
  (vertico-multiform-mode t)
  (setq completion-cycle-threshold nil)

  :bind (:map vertico-map
          ("TAB" . #'minibuffer-complete)
          ("M-V" . #'vertico-multiform-vertical)
          ("M-G" . #'vertico-multiform-grid)
          ("M-F" . #'vertico-multiform-flat)
          ("M-R" . #'vertico-multiform-reverse)
          ("M-U" . #'vertico-multiform-unobtrusive)))

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package company
  :bind
  ("M-SPC" . 'company-complete)
  ("C-c C-/" . #'company-other-backend)
  ("C-c C-_" . #'company-other-backend) ;; for text terminals

  :custom
  (company-idle-delay 0.1)
  (company-selection-wrap-around t) ;; wrap to beginning from last
  ;; company-tooltip-limit 50
  ;; company-backends '(company-capf)
  (company-minimum-prefix-length 2)
  (company-tooltip-align-annotations t)

  :init
  (company-tng-mode)
  (company-tng-configure-default)
  (global-company-mode t))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind
  (("M-y" . 'consult-yank-from-kill-ring)
   ([remap apropos] . consult-apropos)
   ("C-x b" . 'consult-buffer)))

(use-package embark
  :bind
  ("C-." . embark-act))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package projectile
  :custom
  (projectile-current-project-on-switch 'keep) ;; or 'remove
  (projectile-switch-project-action #'projectile-dired)
  ;; projectile-project-search-path '("~/git-dir" "/Users/rmathew8/Downloads/Planning/")
  (projectile-require-project-root 'prompt)

  :init
  (projectile-mode)

  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package 
  lsp-mode 
  :init
  (setq
    lsp-headerline-breadcrumb-enable nil ;; avoids "Error running timer 'lsp--on-idle' issues"
    lsp-enable-file-watchers nil
    lsp-file-watch-threshold 100) 
  :hook (lsp-mode . lsp-enable-which-key-integration) 
  :commands (lsp lsp-deferred))

;; <:common:use-package: lsp-ui>

(use-package yaml-mode)

;; <:common:use-package: flymake>
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(use-package clojure-mode
  :hook
  ;; (clojure-mode . #'paredit-mode)
  ((clojure-mode . lsp-deferred))
  (clojure-mode . smartparens-strict-mode))


(use-package multiple-cursors
  :bind
  ("C-M-j" . mc/mark-all-dwim))

(use-package which-key
  :init
  (which-key-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode t))

(use-package spaceline
  :config
  (require 'spaceline-config)
  ;; (spaceline-spacemacs-theme)
  (spaceline-emacs-theme))

(use-package password-generator)
;; (password-generator-strong)

(use-package nodejs-repl

  :init
  (defun roy/nodejs-repl-send-para ()
    (interactive)
    (save-excursion
      (nodejs--erase-buffer)
      (mark-paragraph)
      (nodejs-repl-send-region  (region-beginning) (region-end))
      (deactivate-mark)))

  ;; this is faster; I've modified it from the default.
  (defun nvm--which ()
    (let ((output (shell-command-to-string (concat "source " (getenv "HOME") "/.nvm/nvm.sh; nvm which current"))))
      (car (split-string output "[\n]+" t))))

  (setq nodejs-repl-command #'nvm--which)

  (defun nodejs--erase-buffer ()
    "Erase the associated buffer"
    (interactive)
    (let ((buf (process-buffer (nodejs-repl--get-or-create-process))))
      (with-current-buffer buf
        (progn
          (erase-buffer)
          (comint-send-input)))))

  :bind
  (:map js2-mode-map
        ("C-x C-e" . nodejs-repl-send-last-expression)
        ("C-c C-j" . nodejs-repl-send-line)
        ("C-c C-r" . nodejs-repl-send-region)
        ("C-c C-p" . roy/nodejs-repl-send-para)
        ("C-c C-c" . nodejs-repl-send-buffer)
        ("C-c C-l" . nodejs-repl-load-file)
        ;; ("C-c C-k" . nodejs--erase-buffer)
        ("C-c C-k" . (lambda ()
                       (interactive)
                       (nodejs-repl-switch-to-repl)
                       (nodejs--erase-buffer)
                       (other-window 1)))
        ("C-c C-z" . (lambda ()
                       (interactive)
                       (nodejs-repl-switch-to-repl)
                       (other-window 1))))

  :hook
  (nodejs-repl-mode
   .
   (lambda ()
     (remove-hook 'comint-output-filter-functions 'nodejs-repl--delete-prompt t))))


;; <:common:use-package: elisp-format>
(use-package elisp-autofmt)
  ;; :hook (emacs-lisp-mode . (lambda ()
  ;;                            (add-hook 'before-save-hook 'elisp-autofmt-buffer  nil t))))

(use-package
    js2-mode
    :mode "\\.js$"
    :config
    (setq js-indent-level 2)
    :hook ((js2-mode . lsp-deferred)
           (js2-mode . (lambda ()
                         (add-hook 'before-save-hook 'lsp-format-buffer  nil t)))))

(use-package
    typescript-mode
    :mode "\\.ts$"
    :config
    (require 'dap-node) ;; subpackage of dap-mode
    (dap-node-setup)
    :hook ((typescript-mode . lsp-deferred)
           (typescript-mode . (lambda ()
                         (add-hook 'before-save-hook 'lsp-format-buffer  nil t)))))

(use-package json-mode
  :hook ((json-mode . lsp-deferred)
         (json-mode . (lambda ()
                       (add-hook 'before-save-hook 'json-pretty-print-buffer nil t)))))

(use-package docker
  :init
  (defalias 'dc 'docker-containers)
  (defalias 'di 'docker-images))

(use-package docker-tramp)

(use-package lata-antlr-noweb-mode
  :commands lata-antlr-noweb-mode
  :load-path "lisp"
  :mode "\\.nw$")

(use-package go-mode
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ;; ("C-c C-j" . lsp-find-definition)
         ;; ("C-c C-d" . lsp-describe-thing-at-point)
         )
  :hook (go-mode . (lambda ()
                             (lsp-deferred)
                             (add-hook 'before-save-hook 'lsp-format-buffer  nil t)
                             (add-hook 'before-save-hook 'lsp-organize-imports  nil t))))

(use-package rust-mode
  :hook (rust-mode . lsp-deferred)
  :bind
  ("C-c g" . rust-run)
  ("C-c t" . rust-test)
  ("C-c b" . cargo-process-build)
  :init
  (which-function-mode 1)
  (setq compilation-error-regexp-alist-alist
      (cons '(cargo "^\\([^ \n]+\\):\\([0-9]+\\):\\([0-9]+\\): \\([0-9]+\\):\\([0-9]+\\) \\(?:[Ee]rror\\|\\([Ww]arning\\)\\):" 1 (2 . 4) (3 . 5) (6))
        compilation-error-regexp-alist-alist))
  :config
  (setq rust-format-on-save t))


(use-package ob-async)

(use-package yasnippet
    :config
  (yas-global-mode 1))

(use-package ansi-color
    :hook (compilation-filter . ansi-color-compilation-filter)) 

(use-package antlr-mode 
  :ensure nil
  :mode "\\.g4$")

(use-package sql
    :bind
  (:map sql-mode-map
        ("C-c C-k" . (lambda()
                       (interactive)
                       (with-current-buffer sql-buffer 
                         (progn 
                           (erase-buffer)))))))
(use-package imenu-list
  :bind (("C-c C-o" . 'imenu-list-smart-toggle)))

(use-package alert
  :init
  (setq alert-default-style 'libnotify)
  (run-with-timer 0 (* 20 60) (lambda() (alert "Take a break!"))))




;; (use-package ox-gfm)

(use-package ob-rust)
(use-package git-timemachine)

(use-package init-emacs
  :ensure nil)

(use-package init-defuns
  :ensure nil)

(use-package init-org-mode
  :ensure nil)
(put 'scroll-left 'disabled nil)
