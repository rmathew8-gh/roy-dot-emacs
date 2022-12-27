(use-package org
  :init
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (setq-default prettify-symbols-alist '(
                                         ("#+begin_src" . "✤")
                                         ("#+end_src" . "")
                                         (">=" . "≥")
                                         ("=>" . "⇨")))
  (setq default-buffer-file-coding-system 'utf-8
        default-file-name-coding-system 'utf-8
        prettify-symbols-unprettify-at-point 'right-edge
        locale-coding-system 'utf-8
        utf-translate-cjk-mode nil
        line-spacing 1
        header-line-format nil ;; topmost margin => set to " "
        org-fontify-done-headline t ;; change the face of a headline if it is marked DONE
        org-hide-emphasis-markers t ;; hide markup (e.g. /.../ - italics; *...* - bold, etc.)
        org-hide-leading-stars nil ;; hide the stars
        org-image-actual-width '(300)
        ;; org-odd-levels-only t ;; odd levels only
        org-src-tab-acts-natively t
        org-pretty-entities t ;; show entities as UTF8 characters.
        org-startup-indented nil
        org-startup-with-inline-images t
        x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  (org-babel-do-load-languages 'org-babel-load-languages '((shell . t) (python t) (emacs-lisp . t)))
  (setq org-confirm-babel-evaluate nil)
  :hook
  ((org-mode . prettify-symbols-mode)
   (org-mode . org-auto-tangle-mode)))

;; (use-package org-superstar
;;   :hook (org-mode . org-superstar-mode))

(use-package org-bullets
  :init
  (setq org-bullets-face-name (quote org-bullet-face))
  (setq org-bullets-bullet-list
        ;; '("◉" "☯" "○" "☯" "✸" "☯" "✿" "☯" "✜" "☯" "◆" "☯" "▶"))
        '("◉" "○" "✸" "✿" "✜" "◆" "▶"))
  :hook
  (org-mode . (lambda () (org-bullets-mode 1))))

;; (use-package olivetti
;;   :init
;;   (setq olivetti-body-width .9)
;;  :hook (org-mode . olivetti-mode))

(provide 'init-org-mode)
