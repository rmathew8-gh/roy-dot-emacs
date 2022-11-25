(provide 'lata-noweb-mode)

(defconst A  "<<a>>")
(defconst A= (concat A "="))
(defconst B  "<<b>>")
(defconst B= (concat B "="))
(defconst C  "<<c>>")
(defconst C= (concat C "="))
(defconst D= "<<d>>=")

(defconst CHK    "<<\\(.*?\\)>>")
(defconst CHKp   "\\(.*?\\)>>")
(defconst preCHUNK  (concat ".*?" CHK))
(defconst CHUNK  (concat "[^@]" CHK))
(defconst DEFN   (concat  "^" CHK "=$"))


(defvar lata-noweb-mode-hook nil
  "list of functions to call when entering lata-noweb-mode")

(defvar lata-noweb-mode-map nil  ; Create a mode-specific keymap.
  "keymap for lata-noweb-mode major mode")

(if lata-noweb-mode-map
    ()              ; Do not change the keymap if already set up.
    (setq lata-noweb-mode-map (make-sparse-keymap))

    (define-key lata-noweb-mode-map "@" 'lata-noweb-electric-@)
    (define-key lata-noweb-mode-map "<" 'lata-noweb-electric-<)
    ;; (define-key lata-noweb-mode-map "=" 'lata-noweb-electric-=)
    (define-key lata-noweb-mode-map (kbd "C-=") 'lata-noweb-electric-=)

    ;; (define-key lata-noweb-mode-map "\C-cp"    '(lambda() (interactive) (insert "import pdb; pdb.set_trace() # roy")))
    ;; (define-key lata-noweb-mode-map "\C-c>" 'lata-noweb-electric->)
    ;; (define-key lata-noweb-mode-map "\C-c<" 'lata-noweb-indent)

    (defun lata-noweb-backward-chunk-defn()
      (interactive)
      (roy-find-next-chunk-occurence nil t))

    (defun lata-noweb-forward-chunk-defn()
      (interactive)
      (roy-find-next-chunk-occurence t t))

    (defun lata-noweb-forward-chunk-instance()
      (interactive)
      (mnf t))

    (defun lata-noweb-backward-chunk-instance()
      (interactive)
      (mnf nil))

    ;; (require 'cl)
    ;; (require 'roy-minor-modes)

    (defun open-last-changed-file-from-nw()
      "open last changed nw file"
      (interactive)
      (with-current-buffer "*notangle.sh (output)*"
        (let* ((sample-output (buffer-substring-no-properties (point-min) (point-max)))
               (fn (get-first-changed-file-path sample-output)))
          (if (not fn)
              (message "no actionable changes!")
            (find-file-other-window fn)))))

    (define-key lata-noweb-mode-map [f4] 'notangle-python)
    (define-key lata-noweb-mode-map [S-f4] 'notangle)

    (define-key lata-noweb-mode-map [f5] 'mlp-all-python)
    (define-key lata-noweb-mode-map [S-f5] 'mlp-all)

    (define-key lata-noweb-mode-map [C-f5] (lambda() (interactive )(roy-new-rearrange "topLevel" "rearrange")))
    (define-key lata-noweb-mode-map [C-S-f5] 'roy-new-rearrange)

    (define-key lata-noweb-mode-map [f6] 'open-last-changed-file-from-nw)

    (define-key lata-noweb-mode-map [left]
      (lambda()
        (interactive)
        (lata-next-chunk-fn t)))

    (define-key lata-noweb-mode-map [right]
      (lambda()
        (interactive)
        (lata-next-chunk-fn)))

    (define-key lata-noweb-mode-map [(shift left)]
      (lambda()
        (interactive)
        (lata-next-chunk-defn t)))

    (define-key lata-noweb-mode-map [(shift right)]
      (lambda()
        (interactive)
        (lata-next-chunk-defn)))


    (define-key lata-noweb-mode-map  [(f9)] 'roy-name-code-chunk)
    (define-key lata-noweb-mode-map  [(f10)] 'roy-rename-code-chunk)
    (define-key lata-noweb-mode-map  [(shift f12)] 'roy-shellex-on-chunk)
)
 
(defvar lata-noweb-mode-syntax-table nil
  "Syntax table used while in lata-noweb mode.")

(if lata-noweb-mode-syntax-table
    ()              ; Do not change the table if it is already set up.
    (setq lata-noweb-mode-syntax-table (make-syntax-table))
    (modify-syntax-entry ?\" ".   " lata-noweb-mode-syntax-table)
    ;(modify-syntax-entry ?\' ".   " lata-noweb-mode-syntax-table)
    (modify-syntax-entry ?\\ ".   " lata-noweb-mode-syntax-table))

(defvar lata-noweb-mode-abbrev-table nil
  "Abbrev table used while in lata-noweb mode.")
(define-abbrev-table 'lata-noweb-mode-abbrev-table ())

; ("\\<anchor\\>" (0 'lata-noweb-code-decl) ("\\<item\\>" nil nil (0 'modeline))) -- works!
; ("^@" (0 'lata-noweb-code-decl-face) (".*\\(\r\\|\n\\)" nil nil (0 'info-node)))
(defvar lata-noweb-font-lock-keywords
  '((roy-match-comment-chunk  .   'lata-noweb-comment-face)
    ("^\\(<<.*>>=\\)\W*$"     1   'lata-noweb-code-decl-face)
    ("\\(<<.*>>\\)[^=]"       1   'lata-noweb-code-instance-face))
  "Additional expressions to highlight in Shell mode.")

; This works!
; (defvar lata-noweb-font-lock-keywords
;   '(("[ \t]\\([+-][^ \t\n]+\\)" 1 font-lock-comment-face)
;     ("^[^ \t\n]+:.*" . font-lock-string-face)
;     ("^\\[[1-9][0-9]*\\]" . font-lock-string-face))
;   "Additional expressions to highlight in Shell mode.")


(defun my-turn-on-font-lock ()
  (interactive "")

  ;<:common:my-turn-on-font-lock: bold/italic>
  (make-face 'lata-noweb-code-decl-face)
  (make-face 'lata-noweb-code-instance-face)
  (make-face 'lata-noweb-comment-face)

  (set-face-foreground 'lata-noweb-code-decl-face "DarkGreen")
  ;(set-face-background 'lata-noweb-code-decl-face "white")
  (set-face-bold     'lata-noweb-code-decl-face t)

  (set-face-foreground 'lata-noweb-code-instance-face "medium blue")
  ; (set-face-bold-p     'lata-noweb-code-instance-face nil)
  ; (invert-face         'lata-noweb-code-instance-face)

  (set-face-foreground 'lata-noweb-comment-face "FireBrick")
  ; (set-face-font 'lata-noweb-comment-face "-*-Courier New-normal-i-*-*-*-*-96-96-c-*-iso8859-1")
  ; (make-face-italic 'lata-noweb-comment-face)
  (set-face-italic   'lata-noweb-comment-face t)

  ;;(if window-system
  ;;    (progn
  ;;      (add-hook  'Info-mode-hook       'my-window-setup-hook)
  ;;      (add-hook  'dired-mode-hook      'my-window-setup-hook)
  ;;      (add-hook  'sql-mode-hook       'my-window-setup-hook)
  ;;      (add-hook  'emacs-lisp-mode-hook 'my-window-setup-hook)
  ;;      (add-hook  'java-mode-hook       'my-window-setup-hook)
  ;;      (add-hook  'lisp-mode-hook       'my-window-setup-hook)
  ;;      (add-hook  'lata-noweb-mode-hook  'my-window-setup-hook)
  ;;      (add-hook  'sgml-mode-hook       'my-window-setup-hook)
  ;;      ;;(add-hook 'sgml-mode-hook       'font-lock-fontify-buffer)
  ;;      ))

  ;<:common:my-turn-on-font-lock: info faces>

  (set-face-background 'region '"LightGrey") ; region color in transient mark mode
  (set-face-foreground 'region '"black"))
  
(my-turn-on-font-lock)
; function to invoke this major mode
(defun lata-noweb-mode ()
  "Major mode for editing lata-noweb intended for humans to read.
  Special commands: \\{lata-noweb-mode-map}

  Turning on lata-noweb-mode runs the hook `lata-noweb-mode-hook'."
  (interactive)
  (kill-all-local-variables)

  (setq major-mode 'lata-noweb-mode)     ; `describe-mode' uses this string
  (setq mode-name "Lata-Noweb")      ; This name goes into the mode line.

  (setq local-abbrev-table lata-noweb-mode-abbrev-table)
  (set-syntax-table lata-noweb-mode-syntax-table)
  (use-local-map lata-noweb-mode-map)

  (make-local-variable 'paragraph-start)
  (make-local-variable 'paragraph-separate)
  (setq paragraph-start    "^<<.*>>=\\|^@\\s-\\|^@$")
  (setq paragraph-separate "^<<.*>>=\\s-*$\\|^@\\s-\\|^@$")


  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(lata-noweb-font-lock-keywords t))

  (run-hooks 'lata-noweb-mode-hook))     ; Finally, this permits the user to
;   customize the mode with a hook.


(defconst A  "<<a>>")
(defconst A= (concat A "="))
(defconst B  "<<b>>")
(defconst B= (concat B "="))
(defconst C  "<<c>>")
(defconst C= (concat C "="))
(defconst D= "<<d>>=")

(defconst CHK    "<<\\(.*?\\)>>")
(defconst CHKp   "\\(.*?\\)>>")
(defconst preCHUNK  (concat ".*?" CHK))
(defconst CHUNK  (concat "[^@]" CHK))
(defconst DEFN   (concat  "^" CHK "=$"))


;; motion
(defun lata-next-chunk-defn(&optional backward)
  "find next DEFN"
  (if backward
      (if (re-search-backward DEFN nil t)
          nil
        (message "no defn backward!"))
    (let ((count 1))
      (if (looking-at CHK) (setq count 2))
      (if (re-search-forward DEFN nil t count)
          (search-backward "<<")
        (message "no defn ahead")))))

(defun lata-next-chunk-instance(&optional backward)
  "find next USE"

  (if (not (looking-at CHK))
      (message "--[not at chunk]")

    (if backward
        (if (search-backward (concat "<<" (match-string-no-properties 1) ">>") nil t)
            nil
          (message "no instance backward"))
      (if (search-forward (concat "<<" (match-string-no-properties 1) ">>") nil t 2)
          (search-backward "<<")
        (message "no instance ahead")))))

(defun lata-next-chunk-instance-partial(&optional backward)
  "find next *partial* USE"

  (if (not (looking-at CHKp))
      (message "--not *in* chunk")

    (let ((s (concat (match-string-no-properties 1) ">>")))
      (if backward
          (if (re-search-backward s nil t)
              nil
            (message "no instance backward"))
        (if (re-search-forward s nil t 2)
            (re-search-backward s) ;; reposition cursor
          (message "no instance ahead"))))))

(defun lata-next-chunk(&optional backward)
  "find next DEFN/USE"
  (if backward
      (if (re-search-backward CHUNK nil t)
          (forward-char 1)
        (message "no use backward"))
    (if (looking-at CHK) (forward-char 1))
    (if (re-search-forward CHUNK nil t)
        (search-backward "<<")
      (message "no use ahead"))))

(defun lata-next-chunk-fn(&optional backward)
  "handles 3 cases of find next chunk"

  (if backward
      (cond
        ((looking-at CHK) (lata-next-chunk-instance t))
        ((looking-at CHKp) (lata-next-chunk-instance-partial t))
        (t (lata-next-chunk t)))
    (cond
      ((looking-at CHK) (lata-next-chunk-instance))
      ((looking-at preCHUNK) (progn (lata-next-chunk) (lata-next-chunk-instance-partial)))
      ((looking-at CHKp) (lata-next-chunk-instance-partial))
      (t (lata-next-chunk)))))


;; modification
(defun lata-noweb-electric-@ ()
  "Intelligently insert @ with a space"
  (interactive)
  (if (not (bolp))
      (self-insert-command 1)
    (beginning-of-line)
    (if (eolp) nil (kill-line))
    (insert (format-time-string "@ updated: %b/%d/%y"))))

(defun lata-noweb-electric-< ()
  "Begin chunk definition (if within doc chunk)"
  (interactive)
  (if (not (bolp))
      (self-insert-command 1)
      (insert (format-time-string "\n@ updated: %b/%d/%y\n"))
      (insert "<<")
    (save-excursion
      (insert ">>")
      (if (not (looking-at "\\s *$"))
          (newline)))))

(defun lata-noweb-electric-= ()
  "copy chunk name into kill ring"
  (interactive)

  (let ((pm (point-marker)) ; preserve position
        (name)) ; variable in scope
    (lata-next-chunk-defn t) ; find chunk we're in
    (setq name (match-string 1)) ; chunk name to clone

    (lata-next-chunk-defn t) ; find previous chunk
    (lata-next-chunk-fn t) ; move to previous instance

    (let* ((p1 (point))
           (_ (beginning-of-line 1))
           (len (- p1 (point)))
           (blanks (make-string len #x20))
           (cstr (format "%s<<%s>>" blanks name)))
      (beginning-of-line 1)
      (forward-line)
      (open-line 1)
      (insert cstr)
      (message (format "inserted: <<%s>> above" name))
      (goto-char pm))))

(defun roy-rename-chunk()
  (interactive)

  (beginning-of-line 1)
  (if (not (looking-at DEFN))
    (re-search-backward DEFN))

  (let* ((orig (match-string-no-properties 1))
         (rep (read-string "replacement: " orig)))
    (replace-string
      (format "<<%s>>" orig)
      (format "<<%s>>" rep) nil 0 (point-max))
      (beginning-of-line 1)))

(define-key lata-noweb-mode-map (kbd "C-,") 'roy-rename-chunk)


;; output
(defun notangle-python()
  "roy notangle func"
  (interactive)

  (save-excursion

    (beginning-of-line)
    (let* ((search-pattern "[^@]*?\\s-*<<\\(.*\\)>>")
           (chunk-name
            (catch 'foo
              (if (or (looking-at search-pattern) (re-search-backward search-pattern nil t))
                  (match-string-no-properties 1)
                (throw 'foo (message "no chunk found backward from point"))))))

      (shell-command-on-region
       (point-min)
       (point-max)
       (concat "notangle.sh roy \"" chunk-name "\"")))))

; expands (recursively) the code of this chunk into a buffer; default name
; used is *notangle*; this is also the return value.
(defun notangle(&optional whole-chunk out-buff )
  (interactive)

  (save-excursion
    (beginning-of-line)
    (next-line 1)

    (catch 'foo

      (let* ((search-pattern (concat "[^@]<<\\(.*\\)>>" (if whole-chunk "=")))
             (chunk-name
              (or
               (and (re-search-backward search-pattern nil t)
                    (match-string-no-properties 1))
               (throw 'foo (message "no chunk found backward from point"))))
             (my-bufname (or out-buff "*notangle*")))

        (shell-command-on-region
         (point-min) (point-max)
         (concat "markup -t - | nt -t8 -R\"" chunk-name "\"")
         my-bufname)

                (set-buffer my-bufname)
                (untabify (point-min) (point-max))

        ; return the buffer name
        my-bufname))))

(defun mlp-all-python()
  ""
  (interactive)

  (let ((buf (current-buffer))
        (outbuf (get-buffer-create  "*notangle.sh (output)*"))
        (errbuf (get-buffer-create "*notangle.sh (errors)*")))
    (save-buffer)
    (with-current-buffer outbuf (erase-buffer))
    (with-current-buffer errbuf (erase-buffer))
    (let ((res (shell-command-on-region
                (point-min) (point-max)
                "notangle.sh roy" outbuf nil errbuf t)))
      (let ((bufs (list outbuf errbuf)))
        (cond
         ((equal res 0)
          (roy-show-multiple-windows (--filter (> (buffer-size it) 0) bufs)))
         (t (throw :err nil))))
      ;; now return the status as well.
      res)))

; This is so much nicer than the makefile scheme I used before.
(defun mlp-all()
  (interactive)
  (save-buffer)

  (beginning-of-buffer)
  (if (not (re-search-forward ":file: gen-files.py" nil t))
      (message "no gen-files.py chunk defined")

    (shell-command-on-region
     (point-min) (point-max)
     (concat "notangle.sh norman"))))

;; <:lata-noweb-mode:defun: mlp-rearrange (C-F5)>
(defun roy-new-rearrange(&optional action)
  "call nw funcs"
  (interactive "P")
  (let*
      ((choices
        '(("rearrange") ("drop") ("copy")))
       (_action
	(cond
	 ((eq action nil) "rearrange")
	 (t (completing-read "action [rearrange]: " choices nil t nil nil "rearrange"))))
       (out-buf (not (equal _action "copy"))))

    (save-excursion
      (shell-command-on-region
       (point-min) (point-max)
       (concat "notangle.sh expand \"topLevel\" " _action) out-buf out-buf nil t))))


(defun mnf( &optional my-go-forward-p )

  (setq my-msg-string "EMPTY MESSAGE")
  (if my-go-forward-p
      ;; set to go ahead in search
         (progn
       (fset 'my-search-fn 'search-forward)
       (fset 'my-re-search-fn 're-search-forward))
         ;; set to go backward in search
         (fset 'my-search-fn 'search-backward)
         (fset 'my-re-search-fn 're-search-backward))

  ;; (interactive "aEnter func-name: ")
  ;; (interactive "xWanna look ahead?(t/nil): ")

  (catch 'foo
    ;; (beginning-of-line)

    (if (or
         ;; am I looking at a whole chunk
         (looking-at ".*\\(<<.*>>\\)")
         ;; else, am I looking at a partial chunk
         (looking-at "\\(.*>>\\)"))

        (progn
          (setq my-msg-string "at next chunk")
          (if my-go-forward-p
          ;; regexp is right on the same line
             ;; jump (once backward/twice forward) to next pattern.
             (setq my-num-matches 2)
             (setq my-num-matches 1)))

      ;; no chunk on this line; look for the next chunk in file
      (if (roy-find-next-chunk-occurence my-go-forward-p nil)
          ;; we are where we want to be next. Dont go anywhere from here.
         (setq my-num-matches 0 my-msg-string "Found new chunk")

         ;; no more chunks in file ahead
         (setq my-num-matches 0 my-msg-string "no more chunks in file")
         (progn
           (beep)
           (message my-msg-string)
           (throw 'foo nil))))

    (let
    ((myStr
      (buffer-substring
       (match-beginning 1)
       (match-end 1))))
    (let ((case-fold-search nil))
      (if (my-search-fn myStr nil t my-num-matches)
          (progn
        (goto-char (match-beginning 0))
        (message (format "--%s at %d" my-msg-string (match-beginning 0))))
        (setq my-msg-string
          (format "no more occurrences of %s" myStr))
        (progn
          (beep)
          (message my-msg-string)
          (throw 'foo nil))))
)))

(defun roy-shellex-on-chunk ()

  "run shell on the entire region of a chunk; default to using bash on UNIX and
  NT if none else specified. Choices are: \":python:\\|:jython:\\|:jy:\\|:py:\\|:perl:\\|:sh:\\|:cmd:\\|:sql:\""

  (interactive)

  (let*
      ((chunk-name  (lata-noweb-current-chunk-name))
       (chunk-type
        (cond
         ;; for these, chunk-type is the full name
         ((string-match ":perl:\\|:el:\\|:sh:\\|:cmd:\\|:sql:" chunk-name)
          (substring (match-string-no-properties 0 chunk-name) 1 -1))
         ;; for these, chunk-type is jy or py
         ((string-match ":python:\\|:jython:\\|:jy:\\|:py:" chunk-name)
          (substring (match-string-no-properties 0 chunk-name) 1 3))
         (t "bash"))))

    (cond

     ((equal chunk-type "py")
      (save-excursion
        ;; (elpy-shell-switch-to-shell)
        (python-shell-switch-to-shell)
        (comint-clear-buffer)
        (other-window 1)
        (mark-paragraph)
        (python-shell-send-region (mark) (point))
	    (deactivate-mark)))

     ((equal chunk-type "el")
      (mark-paragraph)
      (eval-region (region-beginning) (region-end))
      (deactivate-mark))

     (t
	  (let* ((buf-name "*Shell Command Output (Async)*")
			 (buf
			  (progn (and (get-buffer buf-name) (kill-buffer buf-name))
					 (get-buffer-create buf-name))))
        (message (format "--running (%s) chunk..." chunk-type))
		(save-excursion
		  (switch-to-buffer-other-window buf)
          (grep-mode))
		(mark-paragraph)
		(start-process "async-bash" buf-name "bash" "-c" (buffer-substring-no-properties (region-beginning) (region-end)))
		(deactivate-mark)
        (sleep-for 0.1)
        (switch-to-buffer buf-name)
        (beginning-of-buffer)
        (other-window 1))))))


(defun roy-find-next-chunk-occurence( my-is-forward-p my-is-definition )
  (if my-is-forward-p
      (fset 'my-s-fn 're-search-forward)
    (fset 'my-s-fn 're-search-backward))

  ;; if am at the start of a chunk already, then jump 2 matches in the forward direction.
  (if (and my-is-forward-p (looking-at ".*\\(<<.*>>\\)"))
      (setq my-num-matches 2)
    (setq my-num-matches 1))

  (if my-is-definition
      ;; we are looking for a chunk definition only
      (setq my-chunk-re "^\\(<<.*>>=\\)")
    ;; we are looking for any chunk
    (setq my-chunk-re "[^@]\\(<<.*>>\\)"))

  (catch 'foo2
    (if (my-s-fn my-chunk-re nil t my-num-matches)
    ;; found it, return true
       (goto-char (match-beginning 1))
       ;; didn't find re. throw exception
       (throw 'foo2 nil))))

; Use this func to determine the region for the comment chunk pattern, since
; we can't use an emacs regexp (they are greedy and don't work right).
(defun roy-match-comment-chunk(bound)
  "my fun"
  (let*
      ((p1 (and (re-search-forward "^@$\\|^@\\s-" bound t)  (match-beginning 0)))
       (p2 (and (re-search-forward "^<<" bound t) (match-beginning 0))))

    (if (not (and p1 p2))
    nil             ; return nil if RE not found
      (set-match-data (list p1 p2))
      t)))              ; return t to indicate success (match is set)

;; returns the unadorned name of the chunk we are in.
(defun lata-noweb-current-chunk-name()
  (save-excursion
    (end-of-line)
    (re-search-backward "^<<.*>>=\\s-*$")
    (roy-get-chunk-defn-name-on-line t)))

(defun roy-get-chunk-defn-name-on-line(verbose)
  (beginning-of-line)
  (if (not (looking-at ".*<<\\(.*\\)>>"))
      ;; spit message and return nil
     (if verbose
         (progn (message "%s" "= char not in chunk defn") nil)
       nil)
     (match-string-no-properties 1)))


;; <:DO-I-NEED-THIS:lata-noweb-mode:defun: roy-name-code-chunk>
;; <:DO-I-NEED-THIS:lata-noweb-mode:defun: roy-move-chunk-to-end>

