(setq home-config t
      work-config nil)

(when (file-exists-p! "config-local.el" doom-private-dir)
  (load! "config-local.el" doom-private-dir))

(setq user-full-name pii/user-full-name
      user-mail-address pii/user-mail-address)

(setq doom-theme 'doom-dark-purple)
(setq display-line-numbers-type 'relative)

(setq doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 14)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(use-package smooth-scroll
  :init
  (setq smooth-scroll/vscroll-step-size 4
        smooth-scroll-mode t))

(after! hl-todo
  (setq hl-todo-keyword-faces '(("TODO" warning bold)
                                ("FIXME" error bold)
                                ("ERROR" error bold)
                                ("BROKEN" error bold)
                                ("FAIL" error bold)
                                ("FAILING" error bold)
                                ("HACK" font-lock-constant-face bold)
                                ("REMEMBER" font-lock-constant-face bold)
                                ("REVIEW" font-lock-keyword-face bold)
                                ("NOTE" success bold)
                                ("DEPRECATED" font-lock-doc-face bold)
                                ("BUG" error bold)
                                ("XXX" font-lock-constant-face bold))))

(use-package! beacon)
(beacon-mode 1)

(setq whitespace-line-column 80
      whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab))

;; (defadvice! rigor/which-key-show-workspace (orig-fun &rest pages-obj)
;;   "Show my workspaces in the echo thingy"
;;   :around #'which-key--process-page
;;   (let ((out (apply orig-fun pages-obj))
;;         (prefix-title (which-key--pages-prefix-title (car pages-obj))))
;;     (if (not (string-equal prefix-title "workspace"))
;;         out
;;       (cons (car out)
;;             (lambda ()
;;               ;; (+workspace/display)
;;               (funcall (cdr out))
;;               ))
;;       )))

(setq mouse-wheel-tilt-scroll t)

(setq focus-mode nil)
(setq focus-mode-to-thing '((prog-mode . paragraph) (text-mode . paragraph)))

(defun n0s1-zen-hide ()
  (setq +word-wrap-extra-indent nil)
  ;; (if centaur-tabs-mode (call-interactively #'centaur-tabs-mode) nil)
  (if +word-wrap-mode t (call-interactively #'(+word-wrap-mode)))
  (if git-gutter-mode (call-interactively #'git-gutter-mode) nil)
  (if highlight-indent-guides-mode (call-interactively #'highlight-indent-guides-mode) nil)
  (call-interactively #'menu-bar--display-line-numbers-mode-none)
  ;; (if focus-mode nil (call-interactively #'focus-mode))
  )

(defun n0s1-zen-show ()
  (setq +word-wrap-extra-indent 'double)
  ;; (call-interactively #'centaur-tabs-mode)
  (call-interactively #'git-gutter-mode)
  (if +word-wrap-mode nil (call-interactively #'(+word-wrap-mode)))
  (call-interactively #'highlight-indent-guides-mode)
  (call-interactively #'menu-bar--display-line-numbers-mode-relative)
  ;; (call-interactively #'focus-mode)
  )

(add-hook! 'writeroom-mode-hook
  (if writeroom-mode (n0s1-zen-hide) (n0s1-zen-show)))

; Remove s for snipe binding so it reverts to substitute
(after! evil-snipe (evil-snipe-mode -1))
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(map! :n "s" #'evil-substitute)

(map! :n "gS" #'evil-surround-change)

(map! :n "S" #'evil-avy-goto-char)
(setq avy-styles-alist '((avy-goto-char . at-full)))
(setq avy-case-fold-search nil)

(setq fullscreen-toggled nil)

(defun my/toggle-fullscreen ()
  (interactive)
  (setq fullscreen-toggled
        (if fullscreen-toggled
            (progn (winner-undo) nil)
          (progn (delete-other-windows) t))))

  (map! :leader :desc "Toggle fullscreen" "w f" #'my/toggle-fullscreen)

(defun +evil/insert-newline-above-then-insert (count)
  "insert count blank line(s) above current line then change to insert mode."
  (interactive "p")
  (dotimes (_ count)
    (save-excursion (evil-insert-newline-above)))
  (evil-previous-line count)
  (evil-insert 1))

(defun +evil/insert-newline-below-then-insert (count)
  "insert count blank line(s) below current line then change to insert mode."
  (interactive "p")
  (dotimes (_ count)
    (save-excursion (evil-insert-newline-below)))
  (evil-next-line count)
  (evil-insert 1))

(map! :desc "insert-newline-above-then-insert" :leader "OO" '+evil/insert-newline-above-then-insert)
(map! :desc "insert-newline-below-then-insert" :leader "Oo" '+evil/insert-newline-below-then-insert)

(defvar my/buffer-before-messages (get-buffer "*Messages*"))

(defun my/toggle-messages ()
  (interactive)
  (if (equal (current-buffer) (get-buffer "*Messages*"))
      (switch-to-buffer my/buffer-before-messages)
    (progn
      (setq my/buffer-before-messages (current-buffer))
      (switch-to-buffer (get-buffer "*Messages*")))))

(map! :leader :desc "Open Messages" "M" #'my/toggle-messages)

(use-package! vlf-setup)
;; (use-package! vlf-setup
;;   :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)

(use-package! rebox2)

(defun toggle-buffer-exec ()
"Mark the file for the current buffer executable."
  (interactive)
    (let ((fname (buffer-file-name)))
        (when fname
          (if (= (file-modes fname) 493)
             (progn
                (set-file-modes fname #o644)
                (message "Set \"%s\" as not executable (%s)" fname "#o644"))
             (progn
                (set-file-modes fname #o755)
                (message "Set \"%s\" as executable (%s)" fname "#o755"))))))

(map! :leader :desc "Toggle file as executable" :g "fx" #'toggle-buffer-exec)

(after! tree-sitter
  (setq global-tree-sitter-mode 1))

(defun find-org-files-in-dir (dir &optional base-dir)
  "Find all org files in each of the child dirs in BASE-DIR."
    (directory-files-recursively (expand-file-name dir base-dir) "\.org$"))

(defun find-org-files-in-dirs (base-dir children)
  "Find all org files in each of the child dirs in BASE-DIR."
  (mapcan (lambda (x) (find-org-files-in-dir x base-dir)) children))

(after! org
  (setq org-directory pii/org-directory
        +org-capture-todo-file "todos/todo.org"
        +org-capture-notes-file "personal/me/notes.org"
        +org-capture-journal-file "personal/me/journal.org"
        +org-capture-changelog-file "changelog.org"
        n0s1-agenda-dirs '("personal" "projects" "todos" "work")
        org-agenda-files (find-org-files-in-dirs org-directory n0s1-agenda-dirs)))

(after! org
  (setq org-default-notes-file +org-capture-notes-file
        org-capture-journal-file +org-capture-journal-file
        org-capture-todo-file +org-capture-todo-file
        org-agenda-restore-windows-after-quit t
        org-habit-show-habits-only-for-today nil
        org-ellipsis " ▼ "
        org-log-done 'time
        org-journal-date-format "%B %d, %Y (%A) "
        org-journal-file-format "%Y-%m-%d.org"
        org-modules '(org-habit ol-bibtex)
        org-hide-emphasis-markers t
        org-id-link-to-org-use-id t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        ; This overwrites the default Doom org-link-abbrev-list
        ;; org-link-abbrev-alist '(("google" . "http://www.google.com/search?q=")
        ;;                         ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
        ;;                         ("ddg" . "https://duckduckgo.com/?q=")
        ;;                         ("wiki" . "https://en.wikipedia.org/wiki/"))
        ; This overwrites the default Doom org-todo-keywords
        org-todo-keywords '((sequence
                             "TODO(t)"
                             "NEXT(n)"
                             "IN PROGRESS(i)"
                             "SOMEDAY(s)"
                             "TO DEFINE(T)"
                             "MAYBE(m)"
                             "REMEMBER(r)"
                             "WAITING(w)"
                             "|"
                             "DONE(d)"
                             "CANCELLED(c)" ))))
(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.6))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.4))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.3))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.2))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.1)))))

  ;;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(after! org
    (org-babel-lob-ingest pii/org-babel-lob-ingest))

(use-package! org-tempo
  :after org
  :init
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("sql" . "src SQL"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

(defun build-org-capture-template-headline (state tags scheduled)
  (let ((ts "\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t) nil nil nil nil)"))
    (concat "\n** " state " %? " tags (when scheduled ts) "\n\n%a\n")))

(defun build-org-capture-template (hotkey whichkey-prompt heading state tags scheduled &optional file)
  "Create an org capture template file defaults to todofile"
  (unless file (setq file +org-capture-todo-file))
  `(,hotkey ,whichkey-prompt entry
         (file+headline ,file ,heading)
         ,(build-org-capture-template-headline state tags scheduled) :prepend t))

(defun build-org-capture-templates (param-list)
  (mapcar (lambda (x) (apply #'build-org-capture-template x)) param-list))

(defun build-org-todo-capture-template (key name)
  (let ((tags (if name (format ":%s:" (upcase name)) ""))
        (heading (if name name "Inbox"))
        (prompt (if name (concat name " ") "")))
    (list
     (build-org-capture-template
      (downcase key) (format "TODO %sScheduled" prompt) heading "TODO" tags t)
     (build-org-capture-template
      (upcase key) (format "TODO %sUnscheduled" prompt) heading "TODO" tags 'nil))))

(defun build-org-todo-capture-templates (pairs)
  (mapcan (lambda (y) (build-org-todo-capture-template (car y) (cadr y))) pairs))

(setq org-project-capture-templates
      ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
      ;; {todo,notes,changelog}.org file is found in a parent directory.
      ;; Uses the basename from `+org-capture-todo-file',
      ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
      '(("p" "Templates for projects")
        ("pt" "Project-local todo" entry  ; {project-root}/todo.org
         (file+headline +org-capture-project-todo-file "Inbox")
         "* TODO %?\n%i\n%a" :prepend t)
        ("pn" "Project-local notes" entry  ; {project-root}/notes.org
         (file+headline +org-capture-project-notes-file "Inbox")
         "* %U %?\n%i\n%a" :prepend t)
        ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org
         (file+headline +org-capture-project-changelog-file "Unreleased")
         "* %U %?\n%i\n%a" :prepend t)
        ;; Will use {org-directory}/{+org-capture-projects-file} and store
        ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
        ;; support `:parents' to specify what headings to put them under, e.g.
        ;; :parents ("Projects")
        ("o" "Centralized templates for projects")
        ("ot" "Project todo" entry
         (function +org-capture-central-project-todo-file)
         "* TODO %?\n %i\n %a"
         :heading "Tasks"
         :prepend nil)
        ("on" "Project notes" entry
         (function +org-capture-central-project-notes-file)
         "* %U %?\n %i\n %a"
         :heading "Notes"
         :prepend t)
        ("oc" "Project changelog" entry
         (function +org-capture-central-project-changelog-file)
         "* %U %?\n %i\n %a"
         :heading "Changelog"
         :prepend t)))

(setq org-someday-capture-templates
      (build-org-capture-templates
       '(("s" "SOMEDAY LIFE"     "Eventually" "SOMEDAY" ":LIFE:" nil)
         ("S" "SOMEDAY Untagged" "Eventually" "SOMEDAY" ""       nil))))

(setq org-personal-capture-templates
      '(("n" "Personal notes" entry
         (file+headline +org-capture-notes-file "Notes")
         "* %u %?\n%i\n%a" :prepend t)

        ("j" "Journal" entry
         (file+olp+datetree +org-capture-journal-file)
         "* %U %?\n%i\n%a" :prepend t)))

(setq org-paired-capture-templates
      (build-org-todo-capture-templates '(("t" nil)
                                          ("l" "Life")
                                          ("w" "Work")
                                          ("e" "Email")))
      )

(after! org
  (setq org-capture-templates
        (append org-paired-capture-templates
                org-someday-capture-templates
                org-personal-capture-templates
                org-project-capture-templates)))

(map! :leader :desc "Org babel tangle" "m B" #'org-babel-tangle)

(use-package! org-alert :config
    (setq alert-default-style 'libnotify))

(use-package! org-super-agenda)

(setq n0s1-org-super-agenda-week-config
       '((:log t)  ; Automatically named "Log"
         (:discard (:tag ("habit" "optional" "self_care")))
         (:name "Schedule" :time-grid t :order 0)
         (:name "Today" :scheduled today :order 1)
         (:name "Due today" :deadline today :order 2)
         (:name "Overdue" :deadline past :order 3)
         (:name "Due soon" :deadline future :order 5)
         (:name "Scheduled earlier" :scheduled past :order 4)
         (:name "Unimportant" :auto-tags
          (:todo ("SOMEDAY" "MAYBE" "TO-READ")) :order 100)
         (:name "Waiting..." :todo "WAITING" :order 98)))

(setq n0s1-org-super-agenda-day-config
      '((:log t)  ; Automatically named "Log"
        (:name "Due soon" :deadline future :order 7)
        (:name "Habits" :tag "habit" :order 5)
        (:name "Self Care" :tag "self_care" :order 6)
        (:name "Optional" :tag "optional" :order 8)
        (:name "Schedule" :time-grid t :order 0)
        (:name "Today" :scheduled today :order 3)
        (:name "Due today" :deadline today :order 4)
        (:name "Overdue" :deadline past :order 2)
        (:name "Scheduled earlier" :scheduled past :order 1)
        (:name "Remember" :todo "REMEMBER" :order 90)
        (:name "Unimportant" :auto-tags
         (:todo ("SOMEDAY" "MAYBE" "TO-READ")) :order 100)
        (:name "Waiting..." :todo "WAITING" :order 98)))

(setq org-super-agenda-groups n0s1-org-super-agenda-week-config)

(setq org-agenda-custom-commands
      '(("n" "n0s1 day view"
         ((agenda "" ((org-agenda-span 'day)
                      (org-agenda-start-day nil)
                      (org-super-agenda-groups
                       n0s1-org-super-agenda-day-config)))))
        ("T"  "all todos view"
         ((alltodo "" ((org-super-agenda-groups '((:auto-category t)))))))
        ("tl" "todo life view"       ((tags-todo "LIFE")))
        ("tn" "todo n0s1 view"       ((tags-todo "n0s1")))
        ("tc" "todo n0s1.core view"  ((tags-todo "n0s1_core")))
        ("tb" "todo ByteSource view" ((tags-todo "BYTESOURCE")))))

(defun n0s1-agenda-day-view (&optional arg)
  (interactive "P")
  (org-agenda arg "n"))

(defun n0s1-agenda-all-todos-view (&optional arg)
  (interactive "P")
  (org-agenda arg "T"))

(map! :desc "Org Agenda Day View" :leader "A" 'n0s1-agenda-day-view)
(map! :desc "Org Agenda Day View" :leader "T" 'n0s1-agenda-all-todos-view)

(add-hook 'after-init-hook 'org-super-agenda-mode)

(use-package! org-roam
  :custom
  (org-roam-v2-ack t)
  (org-roam-directory pii/personal-org-roam-directory)
  (personal-org-roam-directory pii/personal-org-roam-directory)
  (org-roam-capture-templates
   '(("d" "default            (general:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/default.org")))
      :if-new (file+head      "public/general/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("A" "Author             (literature:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/author.org")))
      :if-new (file+head      "public/literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Author:")
      :unnarrowed t)
     ("B" "Book               (literature:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/book.org")))
      :if-new (file+head      "public/literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Book:")
      :unnarrowed t)
     ("b" "book note          (literature:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/book_note.org")))
      :if-new (file+head      "public/literature/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :BookNote:")
      :unnarrowed t)
     ("F" "food [recipe]      (food:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/food_recipe.org")))
      :if-new (file+head      "public/food/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Food:Recipe:")
      :unnarrowed t)
     ("f" "food [ingredient]  (food:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/food_ingredient.org")))
      :if-new (file+head      "public/food/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Food:Ingredient:")
      :unnarrowed t)
     ("L" "Language           (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/language.org")))
      :if-new (file+head      "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Language:")
      :unnarrowed t)
     ("l" "language note      (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/language_note.org")))
      :if-new (file+head      "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :LanguageNote:")
      :unnarrowed t)
     ("S" "Software           (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/software.org")))
      :if-new (file+head      "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Software:")
      :unnarrowed t)
     ("s" "software note      (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/software_note.org")))
      :if-new (file+head      "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :SoftwareNote:")
      :unnarrowed t)
     ;; Private
     ("R" "Repository         (repos:private)" plain (file (file-truename (concat personal-org-roam-directory "/templates/repository.org")))
      :if-new (file+head      "private/repos/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Repository:Project:n0s1:")
      :unnarrowed t)
     ("r" "repository note    (repos:private)" plain (file (file-truename (concat personal-org-roam-directory "/templates/repository_note.org")))
      :if-new (file+head      "private/repos/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :RepositoryNote:Project:n0s1:")
      :unnarrowed t)
     ("P" "Project            (proj:private)" plain (file (file-truename (concat personal-org-roam-directory "/templates/project.org")))
      :if-new (file+head      "private/proj/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Project:n0s1:")
      :unnarrowed t)
     ("p" "project note       (proj:private)" plain (file (file-truename (concat personal-org-roam-directory "/templates/project_note.org")))
      :if-new (file+head      "private/proj/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :ProjectNote:n0s1:")
      :unnarrowed t)
     ;; TODO Fix these templates
     ("W" "Work [general] (work/general:private)" plain (file (file-truename (concat org-roam-directory "/templates/software.org")))
      :if-new (file+head  "private/work/general/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Work:")
      :unnarrowed t)
     ("w" (concat "Work [" pii/employer "]  (work/" pii/employer ":private)") plain (file (file-truename (concat org-roam-directory "/templates/software_note.org")))
      :if-new (file+head (concat "private/work/" pii/employer "/<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Work:" pii/employer ":"))
      :unnarrowed t)
     ))
  (org-roam-dailies-directory "daily/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry (file (file-truename (concat personal-org-roam-directory "/templates/default_daily.org")))
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n[[id:71cca294-dc20-4648-a5d2-bcfde321ff19][Day]]"))
     ("D" "Dream" entry (file (file-truename (concat personal-org-roam-directory "/templates/dream.org")))
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n[[id:71cca294-dc20-4648-a5d2-bcfde321ff19][Day]]"))
     ("t" "thought" entry (file (file-truename (concat personal-org-roam-directory "/templates/thought.org")))
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n[[id:71cca294-dc20-4648-a5d2-bcfde321ff19][Day]]"))
     ("i" "idea" entry (file (file-truename (concat personal-org-roam-directory "/templates/idea.org")))
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n[[id:71cca294-dc20-4648-a5d2-bcfde321ff19][Day]]"))
     ("j" "joke" entry (file (file-truename (concat personal-org-roam-directory "/templates/joke.org")))
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n[[id:71cca294-dc20-4648-a5d2-bcfde321ff19][Day]]"))))
  :config (org-roam-setup))

(after! org-roam
  (map! (:prefix ("C-c n" . "roam")
         :desc "org-roam-node-random"              "a" #'org-roam-node-random
         :desc "org-roam-node-find"                "f" #'org-roam-node-find
         :desc "org-roam-ref-find"                 "F" #'org-roam-ref-find
         :desc "org-roam-graph"                    "g" #'org-roam-graph
         :desc "org-roam-node-insert"              "i" #'org-roam-node-insert
         :desc "org-roam-capture"                  "c" #'org-roam-capture
         :desc "org-roam-buffer-toggle"            "r" #'org-roam-buffer-toggle
         :desc "org-roam-buffer-display-dedicated" "R" #'org-roam-buffer-display-dedicated
         :desc "org-roam-db-sync"                  "s" #'org-roam-db-sync))

  (map! (:prefix ("C-c n d" . "dailies")
         :desc "org-roam-dailies-find-directory"     "-" #'org-roam-dailies-find-directory
         :desc "org-roam-dailies-goto-previous-note" "b" #'org-roam-dailies-goto-previous-note
         :desc "org-roam-dailies-goto-next-note"     "f" #'org-roam-dailies-goto-next-note
         :desc "org-roam-dailies-capture-today"      "n" #'org-roam-dailies-capture-today
         :desc "org-roam-dailies-capture-date"       "d" #'org-roam-dailies-capture-date
         :desc "org-roam-dailies-goto-date"          "D" #'org-roam-dailies-goto-date
         :desc "org-roam-dailies-capture-tomorrow"   "m" #'org-roam-dailies-capture-tomorrow
         :desc "org-roam-dailies-goto-tomorrow"      "M" #'org-roam-dailies-goto-tomorrow
         :desc "org-roam-dailies-capture-today"      "t" #'org-roam-dailies-capture-today
         :desc "org-roam-dailies-goto-today"         "T" #'org-roam-dailies-goto-today
         :desc "org-roam-dailies-capture-yesterday"  "y" #'org-roam-dailies-capture-yesterday
         :desc "org-roam-dailies-goto-yesterday"     "Y" #'org-roam-dailies-goto-yesterday))

  (map! (:prefix ("C-c n o" . "organize")
         :desc "org-roam-demote-entire-buffer" "d" #'org-roam-demote-entire-buffer
         :desc "org-roam-link-replace-all"     "s" #'org-roam-link-replace-all
         :desc "org-id-get-create"             "i" #'org-id-get-create
         :desc "org-roam-refile"               "f" #'org-roam-refile
         :desc "org-roam-alias-add"            "a" #'org-roam-alias-add
         :desc "org-roam-alias-remove"         "A" #'org-roam-alias-remove
         :desc "org-roam-ref-add"              "r" #'org-roam-ref-add
         :desc "org-roam-ref-remove"           "R" #'org-roam-ref-remove
         :desc "org-roam-tag-add"              "t" #'org-roam-tag-add
         :desc "org-roam-tag-remove"           "T" #'org-roam-tag-remove)))

(use-package! websocket :after org-roam)

(use-package! org-roam-ui :after org-roam :hook (org-roam . org-roam-ui-mode) :config)

(use-package! org-modern)
(after! org-modern
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-ellipsis "…"

   ;; Agenda styling
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")

  (global-org-modern-mode))

(defun string-to-tablified-buffer (str buffer-name sep)
  (with-current-buffer (get-buffer-create buffer-name)
    (org-mode)
    (org-modern-mode -1)
    (+word-wrap-mode -1)
    (erase-buffer)
    (insert str)
    (org-table-convert-region (point-min) (point-max) sep)
    (goto-line 2)
    (insert "|-|\n")
    (goto-char (point-min))
    (insert "|-|\n")
    (goto-char (point-max))
    (insert "|-|\n")
    (org-table-align)
    (beginning-of-buffer)
    (current-buffer)))

(defun tablify-sql-results (results)
  (string-to-tablified-buffer results "*SQL Results*" "\t"))

(defun my/popup-sql-results ()
  (interactive)
  (+popup-buffer (get-buffer-create "*SQL Results*")))

(defun my/org-add-ids-to-headlines-in-file ()
  "Add ID properties to all headlines in the current file which
do not already have one."
  (interactive)
  (org-map-entries 'org-id-get-create))

(use-package! org-jira
  :custom
  (org-jira-working-dir pii/org-jira-working-dir)
  (jiralib-url pii/jiralib-url)
  (jiralib-update-issue-fields-exclude-list '(components)))

(use-package org-auto-tangle :defer t :hook (org-mode . org-auto-tangle-mode))

(defun el-secretario-daily-review ()
  (interactive)
  (el-secretario-start-session
   (lambda ()
     (list
      ;; First take care of email
      (el-secretario-mu4e-make-source "flag:unread")
      ;; Go through TODOs
      (el-secretario-org-make-source '(todo "TODO") (list (file-truename (concat org-directory "todo.org"))))
      (el-secretario-org-make-source '(todo "TODO") (list (file-truename (concat org-directory "arkmanager.org"))))
      (el-secretario-org-make-source '(todo "TODO") (list (file-truename (concat org-directory "bish.org"))))
      (el-secretario-org-make-source '(todo "TODO") (list (file-truename (concat org-directory "bytesource.org"))))
      (el-secretario-org-make-source '(todo "TODO") (list (file-truename (concat org-directory "n0s1.core.org"))))
      (el-secretario-org-make-source '(todo "TODO") (list (file-truename (concat org-directory "strifebot.org"))))))))

(use-package ox-man)

(use-package ox-confluence)

(define-minor-mode org-fancy-html-export-mode
  "Toggle my fabulous org export tweaks. While this mode itself does a little bit,
the vast majority of the change in behaviour comes from switch statements in:
 - `org-html-template-fancier'
 - `org-html--build-meta-info-extended'
 - `org-html-src-block-collapsable'
 - `org-html-block-collapsable'
 - `org-html-table-wrapped'
 - `org-html--format-toc-headline-colapseable'
 - `org-html--toc-text-stripped-leaves'
 - `org-export-html-headline-anchor'"
  :global t
  :init-value t
  (if org-fancy-html-export-mode
      (setq org-html-style-default org-html-style-fancy
            org-html-meta-tags #'org-html-meta-tags-fancy
            org-html-checkbox-type 'html-span)
    (setq org-html-style-default org-html-style-plain
          org-html-meta-tags #'org-html-meta-tags-default
          org-html-checkbox-type 'html)))

(defadvice! org-html-template-fancier (orig-fn contents info)
  "Return complete document string after HTML conversion.
CONTENTS is the transcoded contents string.  INFO is a plist
holding export options. Adds a few extra things to the body
compared to the default implementation."
  :around #'org-html-template
  (if (or (not org-fancy-html-export-mode) (bound-and-true-p org-msg-export-in-progress))
      (funcall orig-fn contents info)
    (concat
     (when (and (not (org-html-html5-p info)) (org-html-xhtml-p info))
       (let* ((xml-declaration (plist-get info :html-xml-declaration))
              (decl (or (and (stringp xml-declaration) xml-declaration)
                        (cdr (assoc (plist-get info :html-extension)
      test                              xml-declaration))
                        (cdr (assoc "html" xml-declaration))
                        "")))
         (when (not (or (not decl) (string= "" decl)))
           (format "%s\n"
                   (format decl
                           (or (and org-html-coding-system
                                    (fboundp 'coding-system-get)
                                    (coding-system-get org-html-coding-system 'mime-charset))
                               "iso-8859-1"))))))
     (org-html-doctype info)
     "\n"
     (concat "<html"
             (cond ((org-html-xhtml-p info)
                    (format
                     " xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"%s\" xml:lang=\"%s\""
                     (plist-get info :language) (plist-get info :language)))
                   ((org-html-html5-p info)
                    (format " lang=\"%s\"" (plist-get info :language))))
             ">\n")
     "<head>\n"
     (org-html--build-meta-info info)
     (org-html--build-head info)
     (org-html--build-mathjax-config info)
     "</head>\n"
     "<body>\n<input type='checkbox' id='theme-switch'><div id='page'><label id='switch-label' for='theme-switch'></label>"
     (let ((link-up (org-trim (plist-get info :html-link-up)))
           (link-home (org-trim (plist-get info :html-link-home))))
       (unless (and (string= link-up "") (string= link-home ""))
         (format (plist-get info :html-home/up-format)
                 (or link-up link-home)
                 (or link-home link-up))))
     ;; Preamble.
     (org-html--build-pre/postamble 'preamble info)
     ;; Document contents.
     (let ((div (assq 'content (plist-get info :html-divs))))
       (format "<%s id=\"%s\">\n" (nth 1 div) (nth 2 div)))
     ;; Document title.
     (when (plist-get info :with-title)
       (let ((title (and (plist-get info :with-title)
                         (plist-get info :title)))
             (subtitle (plist-get info :subtitle))
             (html5-fancy (org-html--html5-fancy-p info)))
         (when title
           (format
            (if html5-fancy
                "<header class=\"page-header\">%s\n<h1 class=\"title\">%s</h1>\n%s</header>"
              "<h1 class=\"title\">%s%s</h1>\n")
            (if (or (plist-get info :with-date)
                    (plist-get info :with-author))
                (concat "<div class=\"page-meta\">"
                        (when (plist-get info :with-date)
                          (org-export-data (plist-get info :date) info))
                        (when (and (plist-get info :with-date) (plist-get info :with-author)) ", ")
                        (when (plist-get info :with-author)
                          (org-export-data (plist-get info :author) info))
                        "</div>\n")
              "")
            (org-export-data title info)
            (if subtitle
                (format
                 (if html5-fancy
                     "<p class=\"subtitle\" role=\"doc-subtitle\">%s</p>\n"
                   (concat "\n" (org-html-close-tag "br" nil info) "\n"
                           "<span class=\"subtitle\">%s</span>\n"))
                 (org-export-data subtitle info))
              "")))))
     contents
     (format "</%s>\n" (nth 1 (assq 'content (plist-get info :html-divs))))
     ;; Postamble.
     (org-html--build-pre/postamble 'postamble info)
     ;; Possibly use the Klipse library live code blocks.
     (when (plist-get info :html-klipsify-src)
       (concat "<script>" (plist-get info :html-klipse-selection-script)
               "</script><script src=\""
               org-html-klipse-js
               "\"></script><link rel=\"stylesheet\" type=\"text/css\" href=\""
               org-html-klipse-css "\"/>"))
     ;; Closing document.
     "</div>\n</body>\n</html>")))

(defadvice! org-html-toc-linked (depth info &optional scope)
  "Build a table of contents.

Just like `org-html-toc', except the header is a link to \"#\".

DEPTH is an integer specifying the depth of the table.  INFO is
a plist used as a communication channel.  Optional argument SCOPE
is an element defining the scope of the table.  Return the table
of contents as a string, or nil if it is empty."
  :override #'org-html-toc
  (let ((toc-entries
         (mapcar (lambda (headline)
                   (cons (org-html--format-toc-headline headline info)
                         (org-export-get-relative-level headline info)))
                 (org-export-collect-headlines info depth scope))))
    (when toc-entries
      (let ((toc (concat "<div id=\"text-table-of-contents\">"
                         (org-html--toc-text toc-entries)
                         "</div>\n")))
        (if scope toc
          (let ((outer-tag (if (org-html--html5-fancy-p info)
                               "nav"
                             "div")))
            (concat (format "<%s id=\"table-of-contents\">\n" outer-tag)
                    (let ((top-level (plist-get info :html-toplevel-hlevel)))
                      (format "<h%d><a href=\"#\" style=\"color:inherit; text-decoration: none;\">%s</a></h%d>\n"
                              top-level
                              (org-html--translate "Table of Contents" info)
                              top-level))
                    toc
                    (format "</%s>\n" outer-tag))))))))

(defvar org-html-meta-tags-opengraph-image
  '(:image "https://n0s1.net/resources/org/nib.png"
    :type "image/png"
    :width "200"
    :height "200"
    :alt "Green fountain pen nib")
  "Plist of og:image:PROP properties and their value, for use in `org-html-meta-tags-fancy'.")

(defun org-html-meta-tags-fancy (info)
  "Use the INFO plist to construct the meta tags, as described in `org-html-meta-tags'."
  (let ((title (org-html-plain-text
                (org-element-interpret-data (plist-get info :title)) info))
        (author (and (plist-get info :with-author)
                     (let ((auth (plist-get info :author)))
                       ;; Return raw Org syntax.
                       (and auth (org-html-plain-text
                                  (org-element-interpret-data auth) info))))))
    (append
     (list
      (when (org-string-nw-p author)
        (list "name" "author" author))
      (when (org-string-nw-p (plist-get info :description))
        (list "name" "description"
              (plist-get info :description)))
      '("name" "generator" "org mode")
      '("name" "theme-color" "#77aa99")
      '("property" "og:type" "article")
      (list "property" "og:title" title)
      (let ((subtitle (org-export-data (plist-get info :subtitle) info)))
        (when (org-string-nw-p subtitle)
          (list "property" "og:description" subtitle))))
     (when org-html-meta-tags-opengraph-image
       (list (list "property" "og:image" (plist-get org-html-meta-tags-opengraph-image :image))
             (list "property" "og:image:type" (plist-get org-html-meta-tags-opengraph-image :type))
             (list "property" "og:image:width" (plist-get org-html-meta-tags-opengraph-image :width))
             (list "property" "og:image:height" (plist-get org-html-meta-tags-opengraph-image :height))
             (list "property" "og:image:alt" (plist-get org-html-meta-tags-opengraph-image :alt))))
     (list
      (when (org-string-nw-p author)
        (list "property" "og:article:author:first_name" (car (s-split-up-to " " author 2))))
      (when (and (org-string-nw-p author) (s-contains-p " " author))
        (list "property" "og:article:author:last_name" (cadr (s-split-up-to " " author 2))))
      (list "property" "og:article:published_time"
            (format-time-string
             "%FT%T%z"
             (or
              (when-let ((date-str (cadar (org-collect-keywords '("DATE")))))
                (unless (string= date-str (format-time-string "%F"))
                  (ignore-errors (encode-time (org-parse-time-string date-str)))))
              (if buffer-file-name
                  (file-attribute-modification-time (file-attributes buffer-file-name))
                (current-time)))))
      (when buffer-file-name
        (list "property" "og:article:modified_time"
              (format-time-string "%FT%T%z" (file-attribute-modification-time (file-attributes buffer-file-name)))))))))

(unless (functionp #'org-html-meta-tags-default)
  (defalias 'org-html-meta-tags-default #'ignore))
(setq org-html-meta-tags #'org-html-meta-tags-fancy)


(setq org-html-style-plain org-html-style-default
      org-html-htmlize-output-type 'css
      org-html-doctype "html5"
      org-html-html5-fancy t)

(after! f
  (defun org-html-reload-fancy-style ()
    (interactive)
    (setq org-html-style-fancy
          (concat "<script>\n"
                  (f-read-text "~/nextcloud/org/org-export-templates/teco-template/main.js")
                  "</script>\n<style>\n"
                  (f-read-text "~/nextcloud/org/org-export-templates/teco-template/style.min.css")
                  "</style>"))
    (when org-fancy-html-export-mode
      (setq org-html-style-default org-html-style-fancy)))
  (org-html-reload-fancy-style))

(defvar org-html-export-collapsed nil)
(eval '(cl-pushnew '(:collapsed "COLLAPSED" "collapsed" org-html-export-collapsed t)
                   (org-export-backend-options (org-export-get-backend 'html))))
(add-to-list 'org-default-properties "EXPORT_COLLAPSED")

(defadvice! org-html-src-block-collapsable (orig-fn src-block contents info)
  "Wrap the usual <pre> block in a <details>"
  :around #'org-html-src-block
  (if (or (not org-fancy-html-export-mode) (bound-and-true-p org-msg-export-in-progress))
      (funcall orig-fn src-block contents info)
    (let* ((properties (cadr src-block))
           (lang (mode-name-to-lang-name
                  (plist-get properties :language)))
           (name (plist-get properties :name))
           (ref (org-export-get-reference src-block info))
           (collapsed-p (member (or (org-export-read-attribute :attr_html src-block :collapsed)
                                    (plist-get info :collapsed))
                                '("y" "yes" "t" t "true" "all"))))
      (format
       "<details id='%s' class='code'%s><summary%s>%s</summary>
<div class='gutter'>
<a href='#%s'>#</a>
<button title='Copy to clipboard' onclick='copyPreToClipbord(this)'>⎘</button>\
</div>
%s
</details>"
       ref
       (if collapsed-p "" " open")
       (if name " class='named'" "")
       (concat
        (when name (concat "<span class=\"name\">" name "</span>"))
        "<span class=\"lang\">" lang "</span>")
       ref
       (if name
           (replace-regexp-in-string (format "<pre\\( class=\"[^\"]+\"\\)? id=\"%s\">" ref) "<pre\\1>"
                                     (funcall orig-fn src-block contents info))
         (funcall orig-fn src-block contents info))))))

(defun mode-name-to-lang-name (mode)
  (or (cadr (assoc mode
                   '(("asymptote" "Asymptote")
                     ("awk" "Awk")
                     ("C" "C")
                     ("clojure" "Clojure")
                     ("css" "CSS")
                     ("D" "D")
                     ("ditaa" "ditaa")
                     ("dot" "Graphviz")
                     ("calc" "Emacs Calc")
                     ("emacs-lisp" "Emacs Lisp")
                     ("fortran" "Fortran")
                     ("gnuplot" "gnuplot")
                     ("haskell" "Haskell")
                     ("hledger" "hledger")
                     ("java" "Java")
                     ("js" "Javascript")
                     ("latex" "LaTeX")
                     ("ledger" "Ledger")
                     ("lisp" "Lisp")
                     ("lilypond" "Lilypond")
                     ("lua" "Lua")
                     ("matlab" "MATLAB")
                     ("mscgen" "Mscgen")
                     ("ocaml" "Objective Caml")
                     ("octave" "Octave")
                     ("org" "Org mode")
                     ("oz" "OZ")
                     ("plantuml" "Plantuml")
                     ("processing" "Processing.js")
                     ("python" "Python")
                     ("R" "R")
                     ("ruby" "Ruby")
                     ("sass" "Sass")
                     ("scheme" "Scheme")
                     ("screen" "Gnu Screen")
                     ("sed" "Sed")
                     ("sh" "shell")
                     ("sql" "SQL")
                     ("sqlite" "SQLite")
                     ("forth" "Forth")
                     ("io" "IO")
                     ("J" "J")
                     ("makefile" "Makefile")
                     ("maxima" "Maxima")
                     ("perl" "Perl")
                     ("picolisp" "Pico Lisp")
                     ("scala" "Scala")
                     ("shell" "Shell Script")
                     ("ebnf2ps" "ebfn2ps")
                     ("cpp" "C++")
                     ("abc" "ABC")
                     ("coq" "Coq")
                     ("groovy" "Groovy")
                     ("bash" "bash")
                     ("csh" "csh")
                     ("ash" "ash")
                     ("dash" "dash")
                     ("ksh" "ksh")
                     ("mksh" "mksh")
                     ("posh" "posh")
                     ("ada" "Ada")
                     ("asm" "Assembler")
                     ("caml" "Caml")
                     ("delphi" "Delphi")
                     ("html" "HTML")
                     ("idl" "IDL")
                     ("mercury" "Mercury")
                     ("metapost" "MetaPost")
                     ("modula-2" "Modula-2")
                     ("pascal" "Pascal")
                     ("ps" "PostScript")
                     ("prolog" "Prolog")
                     ("simula" "Simula")
                     ("tcl" "tcl")
                     ("tex" "LaTeX")
                     ("plain-tex" "TeX")
                     ("verilog" "Verilog")
                     ("vhdl" "VHDL")
                     ("xml" "XML")
                     ("nxml" "XML")
                     ("conf" "Configuration File"))))
      mode))

(defun org-html-block-collapsable (orig-fn block contents info)
  "Wrap the usual block in a <details>"
  (if (or (not org-fancy-html-export-mode) (bound-and-true-p org-msg-export-in-progress))
      (funcall orig-fn block contents info)
    (let ((ref (org-export-get-reference block info))
          (type (pcase (car block)
                  ('property-drawer "Properties")))
          (collapsed-default (pcase (car block)
                               ('property-drawer t)
                               (_ nil)))
          (collapsed-value (org-export-read-attribute :attr_html block :collapsed))
          (collapsed-p (or (member (org-export-read-attribute :attr_html block :collapsed)
                                   '("y" "yes" "t" t "true"))
                           (member (plist-get info :collapsed) '("all")))))
      (format
       "<details id='%s' class='code'%s>
<summary%s>%s</summary>
<div class='gutter'>\
<a href='#%s'>#</a>
<button title='Copy to clipboard' onclick='copyPreToClipbord(this)'>⎘</button>\
</div>
%s\n
</details>"
       ref
       (if (or collapsed-p collapsed-default) "" " open")
       (if type " class='named'" "")
       (if type (format "<span class='type'>%s</span>" type) "")
       ref
       (funcall orig-fn block contents info)))))

(advice-add 'org-html-example-block   :around #'org-html-block-collapsable)
(advice-add 'org-html-fixed-width     :around #'org-html-block-collapsable)
(advice-add 'org-html-property-drawer :around #'org-html-block-collapsable)

(autoload #'highlight-numbers--turn-on "highlight-numbers")
(add-hook 'htmlize-before-hook #'highlight-numbers--turn-on)

(defadvice! org-html-table-wrapped (orig-fn table contents info)
  "Wrap the usual <table> in a <div>"
  :around #'org-html-table
  (if (or (not org-fancy-html-export-mode) (bound-and-true-p org-msg-export-in-progress))
      (funcall orig-fn table contents info)
    (let* ((name (plist-get (cadr table) :name))
           (ref (org-export-get-reference table info)))
      (format "<div id='%s' class='table'>
<div class='gutter'><a href='#%s'>#</a></div>
<div class='tabular'>
%s
</div>\
</div>"
              ref ref
              (if name
                  (replace-regexp-in-string (format "<table id=\"%s\"" ref) "<table"
                                            (funcall orig-fn table contents info))
                (funcall orig-fn table contents info))))))

(defadvice! org-html--format-toc-headline-colapseable (orig-fn headline info)
  "Add a label and checkbox to `org-html--format-toc-headline's usual output,
to allow the TOC to be a collapseable tree."
  :around #'org-html--format-toc-headline
  (if (or (not org-fancy-html-export-mode) (bound-and-true-p org-msg-export-in-progress))
      (funcall orig-fn headline info)
    (let ((id (or (org-element-property :CUSTOM_ID headline)
                  (org-export-get-reference headline info))))
      (format "<input type='checkbox' id='toc--%s'/><label for='toc--%s'>%s</label>"
              id id (funcall orig-fn headline info)))))

(defadvice! org-html--toc-text-stripped-leaves (orig-fn toc-entries)
  "Remove label"
  :around #'org-html--toc-text
  (if (or (not org-fancy-html-export-mode) (bound-and-true-p org-msg-export-in-progress))
      (funcall orig-fn toc-entries)
    (replace-regexp-in-string "<input [^>]+><label [^>]+>\\(.+?\\)</label></li>" "\\1</li>"
                              (funcall orig-fn toc-entries))))

(setq org-html-text-markup-alist
      '((bold . "<b>%s</b>")
        (code . "<code>%s</code>")
        (italic . "<i>%s</i>")
        (strike-through . "<del>%s</del>")
        (underline . "<span class=\"underline\">%s</span>")
        (verbatim . "<kbd>%s</kbd>")))
(appendq! org-html-checkbox-types
          '((html-span
             (on . "<span class='checkbox'></span>")
             (off . "<span class='checkbox'></span>")
             (trans . "<span class='checkbox'></span>"))))
(setq org-html-checkbox-type 'html-span)
(pushnew! org-html-special-string-regexps
          '("-&gt;" . "&#8594;")
          '("&lt;-" . "&#8592;"))
(defun org-export-html-headline-anchor (text backend info)
  (when (and (org-export-derived-backend-p backend 'html)
             (not (org-export-derived-backend-p backend 're-reveal))
             org-fancy-html-export-mode)
    (unless (bound-and-true-p org-msg-export-in-progress)
      (replace-regexp-in-string
       "<h\\([0-9]\\) id=\"\\([a-z0-9-]+\\)\">\\(.*[^ ]\\)<\\/h[0-9]>" ; this is quite restrictive, but due to `org-reference-contraction' I can do this
       "<h\\1 id=\"\\2\">\\3<a aria-hidden=\"true\" href=\"#\\2\">#</a> </h\\1>"
       text))))

(add-to-list 'org-export-filter-headline-functions
             'org-export-html-headline-anchor)
(org-link-set-parameters "Https"
                         :follow (lambda (url arg) (browse-url (concat "https:" url) arg))
                         :export #'org-url-fancy-export)

(defun org-url-fancy-export (url _desc backend)
  (let ((metadata (org-url-unfurl-metadata (concat "https:" url))))
    (cond
     ((org-export-derived-backend-p backend 'html)
      (concat
       "<div class=\"link-preview\">"
       (format "<a href=\"%s\">" (concat "https:" url))
       (when (plist-get metadata :image)
         (format "<img src=\"%s\"/>" (plist-get metadata :image)))
       "<small>"
       (replace-regexp-in-string "//\\(?:www\\.\\)?\\([^/]+\\)/?.*" "\\1" url)
       "</small><p>"
       (when (plist-get metadata :title)
         (concat "<b>" (org-html-encode-plain-text (plist-get metadata :title)) "</b></br>"))
       (when (plist-get metadata :description)
         (org-html-encode-plain-text (plist-get metadata :description)))
       "</p></a></div>"))
     (t url))))

(setq org-url-unfurl-metadata--cache nil)
(defun org-url-unfurl-metadata (url)
  (cdr (or (assoc url org-url-unfurl-metadata--cache)
           (car (push
                 (cons
                  url
                  (let* ((head-data
                          (-filter #'listp
                                   (cdaddr
                                    (with-current-buffer (progn (message "Fetching metadata from %s" url)
                                                                (url-retrieve-synchronously url t t 5))
                                      (goto-char (point-min))
                                      (delete-region (point-min) (- (search-forward "<head") 6))
                                      (delete-region (search-forward "</head>") (point-max))
                                      (goto-char (point-min))
                                      (while (re-search-forward "<script[^\u2800]+?</script>" nil t)
                                        (replace-match ""))
                                      (goto-char (point-min))
                                      (while (re-search-forward "<style[^\u2800]+?</style>" nil t)
                                        (replace-match ""))
                                      (libxml-parse-html-region (point-min) (point-max))))))
                         (meta (delq nil
                                     (mapcar
                                      (lambda (tag)
                                        (when (eq 'meta (car tag))
                                          (cons (or (cdr (assoc 'name (cadr tag)))
                                                    (cdr (assoc 'property (cadr tag))))
                                                (cdr (assoc 'content (cadr tag))))))
                                      head-data))))
                    (let ((title (or (cdr (assoc "og:title" meta))
                                     (cdr (assoc "twitter:title" meta))
                                     (nth 2 (assq 'title head-data))))
                          (description (or (cdr (assoc "og:description" meta))
                                           (cdr (assoc "twitter:description" meta))
                                           (cdr (assoc "description" meta))))
                          (image (or (cdr (assoc "og:image" meta))
                                     (cdr (assoc "twitter:image" meta)))))
                      (when image
                        (setq image (replace-regexp-in-string
                                     "^/" (concat "https://" (replace-regexp-in-string "//\\([^/]+\\)/?.*" "\\1" url) "/")
                                     (replace-regexp-in-string
                                      "^//" "https://"
                                      image))))
                      (list :title title :description description :image image))))
                 org-url-unfurl-metadata--cache)))))
;;(provide 'config)
;;; config.el ends here

(use-package! org-transclusion
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

;; This hook is now incomplete for some reason
(add-hook! 'editorconfig-after-apply-functions
  (defun +editorconfig-disable-formatter-maybe-h (props)
    (when (or (gethash 'indent_style props)
              (gethash 'indent_size props))
      (setq-local +format-with :none
                  +format-with-lsp 'nil))))

(setq +format-on-save-enabled-modes
      '(not python           ; TODO Figure out how to make black and editorconfig play nice again.
            emacs-lisp-mode  ; elisp's mechanisms are good enough
            sql-mode         ; sqlformat is currently broken
            tex-mode         ; latexindent is broken
            latex-mode))

(map! :map python-pytest-mode-map
      :n "q" #'delete-window
      :n "r" #'my/pytest
      :n "R" #'my/delete-window-then-open-repl)

(defun my/delete-window-then-open-repl ()
  (interactive)
  (delete-window)
  (split-window nil nil 'right)
  (evil-window-right 1)
  (+eval/open-repl-same-window))

(defun my/pytest ()
  "Run pytest colourful and verbose."
  (interactive)
  (python-pytest '("--color" "-v"))
  (evil-window-right 1))

(defun my/pytest-from-repl ()
  "Run pytest colourful and verbose."
  (interactive)
  (delete-window)
  (my/pytest))

(map! :mode python-mode :desc "Run pytests"
      :n "SPC T" #'my/pytest)

(map! :mode inferior-python-mode :desc "Run pytests"
      :n "SPC T" #'my/pytest-from-repl)

(add-hook 'python-mode 'tree-sitter-mode)

(setq python-prettify-symbols-alist
      '(("lambda"  . ?λ)))

(setq hs-hide-all-non-comment-function #'ignore)
(setq-hook! 'yaml-mode-hook hs-hide-comments-when-hiding-all t)

(map! :after elixir-mode
      :map elixir-mode-map
      :n "C-c C-c" #'alchemist-iex-compile-this-buffer-and-go)

(after! alchemist
  (set-repl-handler! 'elixir-mode #'alchemist-iex-run)
  (add-hook 'elixir-mode-hook
            (lambda ()
              (add-hook 'after-save-hook 'alchemist-iex-reload-module))))

;; Helpful history
(defvar lookup-documentation-history '())

(defun +lookup/documentation-back ()
  (interactive)
  (!cdr lookup-documentation-history)
  (if lookup-documentation-history
      (let* ((item (format "%S" (read (car lookup-documentation-history)))))
        (+lookup/documentation item)
        (message "Showing help for %S" item)
        (!cdr lookup-documentation-history))
    (message "No more help history remaining")))

(advice-add #'+lookup/documentation :before
            (lambda (identifier &rest _)
              (!cons identifier lookup-documentation-history)))

(map! :map helpful-mode-map :n "p" #'+lookup/documentation-back)

(setq geiser-debug-jump-to-debug-p nil)
(setq geiser-debug-show-debug-p nil)

(use-package! sqleye)
(set-eval-handler! 'sql-mode #'sqleye-send-region)

(map! :leader :desc "Open SQLeye Buffer" "o s" #'sqleye-toggle-buffer)

(map! :map sql-interactive-mode-map :v "gr" #'sqleye-send-region-and-deselect)

(add-to-list 'auto-mode-alist '("\\.cft\\'" . racket-mode))

(use-package! gitmanager)
(after! gitmanager
  (setq gitmanager-repo-source 'gitmanager-cache-file)
  ;; (setq gitmanager-repo-source 'projectile)
  (map! :mode gitmanager-mode :n "RET" #'gitmanager-run-magit)
  (map! :mode gitmanager-mode :n "q" #'gitmanager-hide)
  (map! :mode gitmanager-mode :n "r" #'gitmanager-fetch-and-state)
  (map! :leader :desc "Open Gitmanager" "g m" #'gitmanager))

(use-package! ansi-exec)
(after! ansi-exec
  (use-package! ahoy
    :config
    (map! :mode ahoy-mode :n "q" #'delete-window)
    (map! :leader (:prefix ("p A" . "Ahoy")
                   :desc "Ahoy run cmd"       "A" #'ahoy
                   :desc "Ahoy run with args" "a" #'ahoy-run-with-args
                   :desc "Ahoy help"          "h" #'ahoy-help))))

(setq-hook! 'emacs-everywhere-init-hooks doom-inhibit-local-var-hooks t)

(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))
