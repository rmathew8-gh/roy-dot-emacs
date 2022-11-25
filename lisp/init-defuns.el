(defalias 'g  'goto-line)
(defalias 'dt 'delete-trailing-whitespace)
(defalias 'o  'occur)
(defalias 'eb 'ediff-buffers)
(defalias 'er 'erase-buffer)
(defalias 'rr 'replace-regexp)
(defalias 'rs 'replace-string)
(defalias 'sl 'sort-lines)
(defalias 'tt 'toggle-truncate-lines)

(defalias 'ms 'magit-status)
(defalias 'sbke  'save-buffers-kill-emacs)

(defalias 'fs 'roy-grep-for-fb-info)
(defalias 'ss 'roy-grep-for-info)
(defalias 'ks 'roy-grep-for-kust-info)
(defalias 'kcs 'kustomer-code-search)

(provide 'init-defuns)


(defun gf(&optional arg)
  "search; w/prefix, does keas search only; always prunes .git"
  (interactive "p")

   (let*
       ((template "find %s %s -prune -o %s -type f -print0 | xargs -0 grep -in -e " )
    (prunes "\\( -name \".git\" -o -name \"ext-2.2\" -o -name \"Twisted*\" -o -name \"slave*\" -o -name \"external*\" \\)")
    (specifics "\\( -name \"*.py\" -o -name \"*.html\" -o -name \"*.js\" -o -name \"*.txt\" -o -name \"*.pt\" -o -name \"*.zcml\" \\) ")
    (big (format template "*" prunes specifics ))
    (small (format template "."  "-name \".git\" " "" ""))
    (command (cond ((eq 1 arg) small) (t big)))
    (command (cons command (+ 1 (length command))))
    (command (read-from-minibuffer "Run find (like this): " command nil nil 'grep-find-history)))
     (grep-find command)))

;; -I: ignore binaries
;; \":(exclude)localization\": ignore dirs (recursive)
(defun gg(arg1)
  "git-grep on code"
  (interactive "spattern: ")
  (grep (concat "git grep -iIn -e \"" arg1 "\" \":(exclude)localization\" .")))

(defun ie-get-bare-name (filename)
  (let ((file-re "\\.?\\(.*\\).nw$"))
    (string-match file-re filename)
    (match-string-no-properties 1 filename)))

(defun ie()
  "Does an info-edit on the argument"
  (interactive)

  (setq roy-info-keys

    (let* ((dir-1 (expand-file-name "~/git-dir/Noweb-Files/Literate-Programming"))
           (dir-2 (expand-file-name "~/git-dir/Noweb-Files.Personal/Literate-Programming"))
           (files-1 (directory-files dir-1 nil "nw$"))
           (files-2 (directory-files dir-2 nil "nw$"))
           (map-fn   (apply-partially (lambda(d f) (cons (ie-get-bare-name f) (concat d "/" f)))))
           (map-fn-1 (apply-partially map-fn dir-1))
           (map-fn-2 (apply-partially map-fn dir-2)))

      (nconc (mapcar map-fn-1 files-1)
         (mapcar map-fn-2 files-2))))

  (let* ((roy-ie-key
          (completing-read "Enter info-edit key: " roy-info-keys nil t nil)))
    (find-file (cdr (assoc roy-ie-key roy-info-keys)))))


(defun kustomer-code-search(arg ss)
  "code-search: kustomer (prefix->filenames; else->contents)"
  (interactive "P\nMsearch for: ")

  (cd "~/git-dir/Kustomer/kustomer/")
  (let
      ((cmd (if arg
        (concat "rg --files -i --iglob \"\*" ss "\*\"")
        (concat "rg --no-heading -0iHL -g \"*\" \"" ss "*\""))))

       (grep (concat cmd " ."))))

(defun rb()
  (interactive)
  (let ((new-name (read-string "rename-to: " (buffer-name))))
    (rename-buffer new-name)))

 (defun roy-erase-comint-buffer()
    (interactive)
    (let ((comint-buffer-maximum-size 0))
      (comint-truncate-buffer)))
(defun roy-grep-for-fb-info(arg ss)
  "search thru fb .nw files; prefix arg == chunk defns only"
  (interactive "P\nMsearch for: ")

  (let
      ((ss (if arg (concat ss ".*=") ss)))
    (cd "~/git-dir/Facebook/Literate-Programming")
    (grep (concat "rg --no-heading -0HL -g \"*.nw\" -g \"x.*\" -i " ss " ."))))

(defun roy-grep-for-info(ss)
  "Function that searches thru my noweb repositories (case insensitively)"
  (interactive "Msearch for: ")

  (cd "~/git-dir")
  ;; (grep (concat "grep -ni " ss " Noweb-Files/Literate-Programming/*.nw Noweb-Files.Personal/Literate-Programming/.*.nw" )))
  (grep (concat "egrep \"" ss "\" -rni --include=\"*.nw\" ./Noweb-Files/Literate-Programming ./Noweb-Files.Personal/Literate-Programming")))

(defun roy-grep-for-kust-info(arg ss)
  "search thru fb .nw files; prefix arg == chunk defns only"
  (interactive "P\nMsearch for: ")

  (let
      ((ss (if arg (concat ss ".*=") ss)))
    (cd "~/git-dir/Kustomer/Literate-Programming")
    (grep (concat "rg --no-heading -0HL -g \"*.nw\" -g \"x.*\" -i " ss " ."))))

(defun roy-show-multiple-windows(elems)

  (delete-other-windows)
  (switch-to-buffer (elt elems 0))

  (split-window-right)
  (other-window 1)
  (switch-to-buffer (elt elems 1))

  (cond ((> (length elems) 2)
         (progn
           (split-window-below)
           (other-window 1)
           (switch-to-buffer (elt elems 2)))))

  (cond ((> (length elems) 3)
         (progn
           (other-window 1)
           (split-window nil 10 'above)
           (switch-to-buffer (elt elems 3))
           (other-window 2))))

  (other-window 1))

(defun roy-table-to-csv()
  (interactive)
  (save-excursion
    (set-mark (re-search-forward "</table>" nil t))
    (re-search-backward "<table>" nil t)
    (shell-command-on-region (region-beginning) (region-end) "table-to-csv.sh" :replace t)))

(defun slu(args)=
  "sort and make lines unique in a region; if no mark, operates on whole region"
  (interactive "sargs to uniq (eg: -c): \n")
  (let
      ((beg (if mark-active (region-beginning) 1))
       (end (if mark-active (region-end) (buffer-size))))
    ;;(message "beg: %s; end: %s; args: %s" beg end args)
    (sort-lines nil beg end)
    (shell-command-on-region beg end (concat "uniq " args) nil t)))


