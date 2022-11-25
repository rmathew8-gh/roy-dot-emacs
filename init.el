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


(use-package dired-x
  :ensure nil
  :bind
  ("<f3>" . (lambda() (interactive)
          (find-file (expand-file-name
              (let ((current-prefix-arg t)) (dired-x-read-filename-at-point "filename: ")))))))

;; <:common:use-package: dash-functional>
(use-package ediff
  :custom
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-diff-options "-w"))


;; <:common:use-package: turn off font-lock for large files>

(use-package lata-noweb-mode
  :commands lata-noweb-mode
  :load-path "lisp"
  :mode "\\.nw$")


(use-package magit
  :custom
  (magit-ediff-dwim-show-on-hunks t))

(use-package dired
  :ensure nil
  :hook (dired-before-readin
     . (lambda ()
         (setq default-directory dired-directory)))
  :bind ("C-x C-j" . dired-jump))

(use-package isearch
  :ensure nil
  :bind (:map isearch-mode-map
         ("C-y" . isearch-yank-line)))

(use-package shell
  :after (emacs)
  :bind (:map shell-mode-map
              ("C-c C-k" . roy-erase-comint-buffer)))


(use-package py-yapf)

(use-package python
  :after (py-yapf)
  :bind
  (:map python-mode-map
    ("C-c C-p" . (lambda()
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
  :hook ((comint-output-filter-functions . python-pdbtrack-comint-output-filter-function)
         (python-mode . py-yapf-enable-on-save)))

(use-package pyvenv
  :init
  ;; Set correct Python interpreter
  (pyvenv-activate "~/.virtualenvs/py/")
  (pyvenv-workon "py")

  :custom
   ;; python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))
   (pyvenv-post-activate-hooks
     (list (lambda ()
           (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))))
   (pyvenv-post-deactivate-hooks
     (list (lambda ()
           (setq python-shell-interpreter "python3")))))

;; <:common:use-package: elpy-mode setup>
(use-package pytest
  :defer t
  :after (pyvenv)
  :bind (("C-x p" . 'roy-ppo))
  :config (defun roy-ppo()
            (interactive)
            (let ((kill-buffer-query-functions nil)
                  (buf (get-buffer (pytest-get-temp-buffer-name))))
              (if buf (kill-buffer buf)))
            (jump-to-register ?t)
            (pytest-pdb-one)
            (end-of-buffer))
    (add-to-list 'pytest-project-root-files "pytest.ini"))


;; hoho - ibuffer
(use-package ibuffer
  :bind ([remap list-buffers] . ibuffer-other-window)
  :custom
  (ibuffer-default-sorting-mode 'recency)
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-expert t))


(use-package w3m
  :defer t)


(use-package xclip
  ;; :unless
  ;; (and (string= (system-name) "devvm2907.frc0.facebook.com") (not (window-system)))
  :init (xclip-mode 1))

;; <:common:use-package: clipetty>

;; <:common:use-package: replace (occur-mode)>
;; <:common:use-package: browse-url>

(use-package dired-rsync
  :init
  (bind-key "C-c C-r" 'dired-rsync dired-mode-map))

(use-package org
  :init
  (org-babel-do-load-languages 'org-babel-load-languages '((shell . t) (python t) (emacs-lisp . t)))
  ;; :hook ((org-mode . visual-line-mode)
  ;;        (org-mode . org-indent-mode)))
  ;; :init
  ;; (org-babel-do-load-languages 'org-babel-load-languages '((sh . t)))
  ;; (set org-confirm-babel-evaluate nil))
  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode))


;; <:common:use-package: google-this>
;; <:common:use-package: prettier (js)>
;; <:common:use-package: js2-mode>
;; <:common:use-package: rjsx-mode>
;; <:common:use-package: flymake>
;; <:common:use-package: my-docker>
;; <:common:use-package: my-minor-modes (deferred)>
;; <:common:use-package: lsp-mode>
;; <:common:use-package: company-lsp>
;; <:common:use-package: lsp-ui>
;; <:common:use-package: dap-mode>

(use-package org-download
    :custom
    (org-download-method 'directory)
    (org-download-image-dir "/tmp/images")
    (org-download-heading-lvl nil)
    (org-download-timestamp "%Y%m%d-%H%M%S_")
    (org-image-actual-width 300)
    (org-download-screenshot-method "pngpaste %s")
    :bind
    ("C-M-y" . org-download-screenshot))

;; <:common:use-package: nxml-mode>
;; <:common:use-package: mwheel>

(use-package vertico
  :custom
  (vertico-multiform-commands
        '((consult-line buffer)
          (consult-imenu reverse buffer)
          (execute-extended-command flat)))
  (vertico-multiform-categories
        '((file buffer grid)
          (imenu (:not indexed mouse))
          (symbol (vertico-sort-function . vertico-sort-alpha))))

  (vertico-mode t)
  (vertico-multiform-mode t)
  :bind (:map vertico-map
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

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode t))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind
  (("M-y" . 'consult-yank-from-kill-ring)
   ("C-x b" . 'consult-buffer)))

(use-package embark
  :bind
  ("C-." . embark-act))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :disabled t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; <:common:use-package: lsp-mode (+ui)>
;; <:common:use-package: lsp-ui>

(use-package company
  :bind
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

(use-package go-mode
  :bind (
         ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
         ;; uncomment the following lines
         ;; ("C-c C-j" . lsp-find-definition)
         ;; ("C-c C-d" . lsp-describe-thing-at-point)
         )
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)))

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

(use-package multiple-cursors
  :bind
  ("C-M-j" . mc/mark-all-like-this-dwim))

(use-package which-key
  :init
  (which-key-mode))
  

(use-package init-emacs
  :ensure nil)

(use-package init-defuns
  :ensure nil)

(use-package better-defaults)

(use-package docker
  :init
  (defalias 'dc 'docker-containers)
  (defalias 'di 'docker-images))


;; <:common:use-package: eglot>
;; <:common:use-package: rustic>
;; <:common:use-package: "org-opml">

