;; preamble
(setq debug-on-error t)

;; (require 'package)
(package-initialize)
(setq use-package-always-ensure t)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


;; customization
;; <:common:use-package: use use-package>

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
  :config
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
  :config (unicode-fonts-setup))


;; <:common:use-package: org>
;; <:common:use-package: org-download>

(use-package flycheck
  :config (global-flycheck-mode t))

(use-package flycheck-pycheckers
  :config
  (with-eval-after-load 'flycheck
    (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup)))



(use-package restclient)
(use-package ob-restclient)

(use-package rg
  :after rg-menu
  :config
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

(use-package python
  :mode (("\\.py\\'" . python-ts-mode))
  :hook ((python-ts-mode . eglot-ensure)
         (python-ts-mode . abbrev-mode)
         (python-ts-mode . company-mode)
         (python-ts-mode . (lambda ()
                         (add-hook 'before-save-hook 'python-black-buffer nil t))))
  :bind
  (:map python-mode-map
    ("C-c p" . (lambda()
               (interactive)
               (insert "import pdb; pdb.set_trace() # roy")))
    ("C-c C-k" . (lambda()
                       (interactive)
               (with-current-buffer (process-buffer (python-shell-get-process))
             (roy-erase-comint-buffer)))))
  (:map inferior-python-mode-map
    ("C-c C-k" . (lambda()
               (interactive)
               (comint-clear-buffer))))
  :mode (("\\.py\\'" . python-ts-mode)))

(use-package pyvenv
  :config
  ;; Set correct Python interpreter
  ;; (pyvenv-activate "~/.virtualenvs/py/")

  ;; This works as well.
  (setenv "WORKON_HOME" "~/.virtualenvs")
  (pyvenv-workon "py")

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
  :config
  (setq pytest-cmd-flags "-x -s")
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

;; <:common:use-package: lsp-pyright>

;; <:common:use-package: w3m>
(use-package disk-usage)


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
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1))

(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c d" . eldoc)
              ("C-c a" . eglot-code-actions)
              ;; ("C-c f" . flymake-show-buffer-diagnostics)
              ("C-c r" . eglot-rename)))

;; nice - makes eglot work w/flycheck
(use-package flycheck-eglot
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package marginalia
  :config (marginalia-mode))

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

  :config
  (projectile-mode)

  :bind-keymap
  ("C-c p" . projectile-command-map))

;; <:common:use-package: lsp-mode>
;; <:common:use-package: lsp-ui>

(use-package yaml-mode
    :after prettier
    :hook ((yaml-mode . (lambda ()
                         (add-hook 'before-save-hook 'prettier-prettify nil t)))))

;; <:common:use-package: flymake>
;; <:common:use-package: flycheck>>

;; <:common:use-package: clojure>

(use-package multiple-cursors
  :bind
  ("C-M-j" . mc/mark-all-dwim))

(use-package which-key
  :config
  (which-key-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :config
  (savehist-mode t))

(use-package spaceline
  :config
  (require 'spaceline-config)
  ;; (spaceline-spacemacs-theme)
  (spaceline-emacs-theme))

(use-package password-generator)
;; (password-generator-strong)

(use-package nodejs-repl

  :config
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


(use-package js
    :after prettier
    :hook ((js-ts-mode . eglot-ensure)
           (js-ts-mode . company-mode)
           (js-ts-mode . (lambda ()
                         (add-hook 'before-save-hook 'prettier-prettify  nil t))))
    :config (setq javascript-indent-level 2)
    :mode (("\\.jsx\\'" . js-ts-mode)
           ("\\.jsx\\'" . js-ts-mode)))

(use-package typescript-mode
    :after prettier
    :hook ((typescript-ts-mode . eglot-ensure)
           (typescript-ts-mode . company-mode)
           (tsx-ts-mode . (lambda ()
                         (add-hook 'before-save-hook 'prettier-prettify  nil t)))
           (typescript-ts-mode . (lambda ()
                         (add-hook 'before-save-hook 'prettier-prettify  nil t))))
    :config (setq typescript-indent-level 2)
    :mode (("\\.ts\\'" . typescript-ts-mode)
           ("\\.tsx\\'" . tsx-ts-mode)))

;; <:common:use-package: elisp-format>
(use-package elisp-autofmt)
  ;; :hook (emacs-lisp-mode . (lambda ()
  ;;                            (add-hook 'before-save-hook 'elisp-autofmt-buffer  nil t))))

;; <:common:use-package: js2-mode>
;; <:common:use-package: typescript-mode>
;; <:common:use-package: json-mode>
(use-package json
  :after prettier
  :mode (("\\.json\\'" . json-ts-mode))
  :hook ((json-ts-mode . lsp-deferred)
         (json-ts-mode . (lambda ()
                       (add-hook 'before-save-hook 'prettier-prettify nil t)))))

(use-package dockerfile-mode)

(use-package docker
  :config
  (defalias 'dc 'docker-containers)
  (defalias 'di 'docker-images))

;; (use-package docker-tramp)

(use-package lata-antlr-noweb-mode
  :commands lata-antlr-noweb-mode
  :load-path "lisp"
  :mode "\\.nw$")

;; <:common:use-package: go-mode>
;; <:common:use-package: rust-mode>

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
  :config
  (setq alert-default-style 'libnotify)
  (run-with-timer 0 (* 20 60) (lambda() (alert "Take a break!"))))

(use-package init-org-mode
  :ensure nil
  :config
  (defun org-image-resize (frame)
    (when (derived-mode-p 'org-mode)
      (setq org-image-actual-width (- (window-pixel-width) 80))
      (org-redisplay-inline-images)))

  (add-hook 'window-size-change-functions 'org-image-resize))

(use-package prettier
  :config
  (setq prettier-args '(
                        "--print-width" "120"
                        "--single-quote" "true"
                        )))


;; (use-package ox-gfm)
;; (use-package prettier-js)
;; (use-package ob-rust)

(use-package git-timemachine)

(use-package init-emacs
  :ensure nil)

(use-package init-defuns
  :ensure nil)

(use-package treesit-auto
  :commands (treesit-install-language-grammar nf/treesit-install-all-languages)
  :init
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
          ;; (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          ;; (julia . ("https://github.com/tree-sitter/tree-sitter-julia"))
          ;; (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
          (make . ("https://github.com/alemuller/tree-sitter-make"))
          ;; (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "master" "ocaml/src"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          ;; (php . ("https://github.com/tree-sitter/tree-sitter-php"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
          (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
          ;; (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
          ;; (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
          (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
          ;; (zig . ("https://github.com/GrayJack/tree-sitter-zig"))
          ))

  :config
  (defun nf/treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
        (treesit-install-language-grammar lang)
        (message "`%s' parser was installed." lang)
        (sit-for 0.75)))))



