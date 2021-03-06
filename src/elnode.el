(defun orgtrello-elnode/compute-entity-level-dir (level) "Given a level, compute the folder onto which the file will be serialized."
  (format "%s%s/%s/" elnode-webserver-docroot "org-trello" level))

(defun orgtrello-elnode/archived-scanning-dir (dir-name) "Given a filename, return the archived scanning directory"
  (format "%s.scanning" dir-name))

(defun orgtrello-elnode/--dictionary-lessp (str1 str2) "return t if STR1 is < STR2 when doing a dictionary compare (splitting the string at numbers and doing numeric compare with them)"
  (orgtrello-elnode/--dict-lessp (orgtrello-elnode/--dict-split str1) (orgtrello-elnode/--dict-split str2)))

(defun orgtrello-elnode/--dict-lessp (slist1 slist2) "compare the two lists of strings & numbers"
  (cond ((null slist1)                                       (not (null slist2)))
        ((null slist2)                                       nil)
        ((and (numberp (car slist1)) (stringp (car slist2))) t)
        ((and (numberp (car slist2)) (stringp (car slist1))) nil)
        ((and (numberp (car slist1)) (numberp (car slist2))) (or (< (car slist1) (car slist2))
                                                                 (and (= (car slist1) (car slist2))
                                                                      (orgtrello-elnode/--dict-lessp (cdr slist1) (cdr slist2)))))
        (t                                                   (or (string-lessp (car slist1) (car slist2))
                                                                 (and (string-equal (car slist1) (car slist2))
                                                                      (orgtrello-elnode/--dict-lessp (cdr slist1) (cdr slist2)))))))

(defun orgtrello-elnode/--dict-split (str) "split a string into a list of number and non-number components"
  (save-match-data
    (let ((res nil))
      (while (and str (not (string-equal "" str)))
        (let ((p (string-match "[0-9]*\\.?[0-9]+" str)))
          (cond ((null p) (setq res (cons str res))
                          (setq str nil))
                ((= p 0)  (setq res (cons (string-to-number (match-string 0 str)) res))
                          (setq str (substring str (match-end 0))))
                (t        (setq res (cons (substring str 0 (match-beginning 0)) res))
                          (setq str (substring str (match-beginning 0)))))))
      (reverse res))))

(defun orgtrello-elnode/list-files (directory &optional sort-lexicographically) "Compute list of regular files (no directory . and ..). List is sorted lexicographically if sort-flag-lexicographically is set, naturally otherwise."
  (let ((orgtrello-elnode/--list-files-result (--filter (file-regular-p it) (directory-files directory t))))
    (unless sort-lexicographically
            orgtrello-elnode/--list-files-result
            (sort orgtrello-elnode/--list-files-result 'orgtrello-elnode/--dictionary-lessp))))

(defun orgtrello-elnode/remove-file (file-to-remove) "Remove metadata file."
  (when (file-exists-p file-to-remove) (delete-file file-to-remove)))


