(defun -show()
  (message (format "--%s" (buffer-substring (point) (+ 24 (point))))))

(defmacro with-temp-env (&rest body)
  `(let ((fn "/home/roy/git-dir/Emacs/Literate-Programming/noweb-test.nw"))
     (unwind-protect
         (let ((buf "*ert-temp*"))
           (set-buffer (get-buffer-create buf))
           (erase-buffer)
           (insert-file fn)
           ,@body)
       )))


(ert-deftest lata-next-chunk-backward()
  (with-temp-env
    ;; start from the end backward.
    (goto-char (point-max))

    (lata-next-chunk t)
    (should (looking-at D=))

    (lata-next-chunk t)
    (should (looking-at D=))

    (lata-next-chunk t)
    (should (looking-at C=))

    (lata-next-chunk t)
    (should (looking-at C))

    (lata-next-chunk t)
    (should (looking-at B=))

    (lata-next-chunk t)
    (should (looking-at A=))

    ;; stay in place at 'a'
    (lata-next-chunk t)
    (should (looking-at A=))
))

(ert-deftest lata-next-chunk-defn-backward()
  (with-temp-env
    ;; if ahead of chunk, jump to it
    (goto-char (point-max))

    (lata-next-chunk-defn t)
    (should (looking-at D=))

    (lata-next-chunk-defn t)
    (should (looking-at C=))

    (lata-next-chunk-defn t)
    (should (looking-at B=))

    (lata-next-chunk-defn t)
    (should (looking-at A=))

    ;; nowhere to go from here
    (lata-next-chunk-defn t)
    (should (looking-at A=))
))

(ert-deftest lata-next-chunk-defn()
  (with-temp-env
    ;; if ahead of chunk, jump to it
    (goto-char 1)
    (lata-next-chunk-defn)
    (should (looking-at "<<a>>=$"))

    (lata-next-chunk-defn)
    (should (looking-at "<<b>>=$"))

    (search-forward "<<d>>=")

    ;; if no more chunks left, then stay where we are
    (lata-next-chunk-defn)
    (should (looking-at "<<d>>=$"))
))

(ert-deftest lata-next-chunk-fn-backward()
  (with-temp-env
    ;; test partial match
    (goto-char (point-max))
    (re-search-backward "\\(c\\)>>=")
    (goto-char (match-beginning 1))
    (should (looking-at "c>>="))

    (lata-next-chunk-fn t)
    (should (looking-at "c>>$"))

    ;; test *exact* match
    (goto-char (point-max))
    (re-search-backward "<<c>>=")
    (goto-char (match-beginning 0))
    (should (looking-at "<<c>>="))

    (lata-next-chunk-fn t)
    (should (looking-at "<<c>>$"))

    ;; test default action (move to first chunk)
    (goto-char (point-max))
    (lata-next-chunk-fn t)
    (should (looking-at "<<d>>="))

    ;; when on same line as chunk, with whitespace separating..
    (goto-char (point-max))
    (re-search-backward "^ <<d>>=")
    (should (looking-at " <<d>>="))
    (let ((p1 (point)))
      (lata-next-chunk-fn)
      (-show)
      (should (> (point) p1)))
))

(ert-deftest lata-next-chunk-instance-backward()
  (with-temp-env
    ;; start from the end backward.
    (goto-char (point-max))

    (lata-next-chunk t)
    (should (looking-at D=))

    ;; get to the 2nd instance of 'd'
    (lata-next-chunk-instance t)
    (should (looking-at D=))

    (lata-next-chunk t)
    (should (looking-at C=))

    ;; positve case - found instance
    (lata-next-chunk-instance t)
    (should (looking-at C))

    ;; move to B
    (lata-next-chunk t)
    (should (looking-at B=))

    ;; move to A
    (lata-next-chunk t)
    (should (looking-at A=))

    ;; stay in place on 'a'
    (lata-next-chunk-instance t)
    (should (looking-at A=))
))

(ert-deftest lata-next-chunk-instance-partial()
  (with-temp-env
    ;; should not move if not at chunk
    (re-search-forward "<<\\(c\\)>>")
    (goto-char (match-beginning 1))
    (should (looking-at "c>>"))

    (lata-next-chunk-instance-partial)
    (should (looking-at "c>>="))

    (lata-next-chunk-instance-partial t)
    (should (looking-at "c>>$"))
))

(ert-deftest lata-next-chunk-instance()
  (with-temp-env
    ;; should not move if not at chunk
    (goto-char 1)
    (lata-next-chunk-instance)
    (should (equal (point) 1))

    ;; move to first chunk
    (lata-next-chunk)
    (should (looking-at A=))

    ;; no other 'a' chunks; stay in place
    (lata-next-chunk-instance)
    (should (looking-at A=))

    ;; move to chunk 'c'
    (lata-next-chunk)
    (lata-next-chunk)
    (should (looking-at C))

    ;; move to next use of 'c'
    (lata-next-chunk-instance)
    (should (looking-at C=))

    ;; no other 'c' chunks; stay in place
    (lata-next-chunk-instance)
    (should (looking-at C=))
))

(ert-deftest lata-next-chunk()
  (with-temp-env
    ;; if ahead of chunk, jump to it
    (goto-char 1)
    (lata-next-chunk)
    (should (looking-at A=))

    (lata-next-chunk)
    (should (looking-at B=))

    (lata-next-chunk)
    (should (looking-at C))

    (lata-next-chunk)
    (should (looking-at C=))

    (lata-next-chunk)
    (should (looking-at D=))

    (lata-next-chunk)
    (should (looking-at D=))
))

(ert-deftest lata-next-chunk-fn()
  (with-temp-env
    ;; test partial match
    (re-search-forward "<<\\(c\\)>>")
    (goto-char (match-beginning 1))
    (should (looking-at "c>>"))

    (lata-next-chunk-fn)
    (should (looking-at "c>>="))

    ;; test *exact* match
    (goto-char (point-min))
    (re-search-forward "<<c>>")
    (goto-char (match-beginning 0))
    (should (looking-at "<<c>>"))

    (lata-next-chunk-fn)
    (should (looking-at "<<c>>="))

    ;; test default action (move to first chunk)
    (goto-char (point-min))
    (lata-next-chunk-fn)
    (should (looking-at "<<a>>"))
))


(ert-deftest lata-noweb-electric-=()
  (with-temp-env
    (goto-char (point-max))
    (lata-next-chunk-defn t) ; find chunk 'd'
    (should (looking-at "<<d>>="))
    (forward-line)

    (lata-noweb-electric-=)
    (back-to-indentation)
    ;; check that a new chunk use was inserted
    (should (re-search-backward "<<d>>$"))))
(ert-deftest roy-rename-chunk()
  (with-temp-env
    (cl-letf (((symbol-function 'read-string) (lambda(x y) "renamed-chunk-c")))
      (re-search-forward "<<\\(c\\)>>=")
      (goto-char (match-beginning 1))
      (roy-rename-chunk)
      (should (looking-at "<<renamed-chunk-c>>=")))))


;; Local Variables:
;; eval: (roy-ert-mode)
;; End:

