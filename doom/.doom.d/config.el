(setq home-config nil
      work-config t)

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
        org-agenda-files (find-org-files-in-dir org-directory)))

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
      (upcase key) (format "TODO %sUnscheduled" prompt) heading "TODO" tags t))))

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

(after! org
  (setq org-capture-templates
        (append (build-org-todo-capture-templates '(("t" nil)))
                org-someday-capture-templates
                org-project-capture-templates)))

(map! :leader :desc "Org babel tangle" "m B" #'org-babel-tangle)

(use-package! org-alert :config
    (setq alert-default-style 'libnotify))

(use-package! org-roam
  :custom
  (org-roam-v2-ack t)
  (org-roam-directory pii/org-roam-directory)
  (personal-org-roam-directory pii/personal-org-roam-directory)
  (org-roam-capture-templates
   '(("d" "default        (general:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/default.org")))
      :if-new (file+head  "public/general/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("L" "Language       (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/language.org")))
      :if-new (file+head  "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Language:")
      :unnarrowed t)
     ("l" "language note  (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/language_note.org")))
      :if-new (file+head  "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :LanguageNote:")
      :unnarrowed t)
     ("S" "Software       (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/software.org")))
      :if-new (file+head  "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Software:")
      :unnarrowed t)
     ("s" "software note  (technology:public)" plain (file (file-truename (concat personal-org-roam-directory "/templates/software_note.org")))
      :if-new (file+head  "public/technology/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :SoftwareNote:")
      :unnarrowed t)
     ;; Private
     ;; TODO Fix these templates
     ("W" "Work [general] (work/general:private)" plain (file (file-truename (concat org-roam-directory "/templates/software.org")))
      :if-new (file+head  "private/work/general/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Work:")
      :unnarrowed t)
     ("w" (concat "Work [" pii/employer "]  (work/" pii/employer ":private)" plain (file (file-truename (concat org-roam-directory "/templates/software_note.org")))
      :if-new (file+head  (concat "private/work/" pii/employer "/<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Work:" pii/employer ":"))
      :unnarrowed t)
     )))
  (org-roam-dailies-directory "daily/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry (file (file-truename (concat personal-org-roam-directory "/templates/default_daily.org")))
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
  (jiralib-url jiralib-url)
  (jiralib-update-issue-fields-exclude-list '(components)))

(use-package org-auto-tangle :defer t :hook (org-mode . org-auto-tangle-mode))

(use-package ox-man)

(use-package ox-confluence)

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

(use-package! gitmanager)
(after! gitmanager
  (setq gitmanager-repo-source 'gitmanager-cache-file)
  ;; (setq gitmanager-repo-source 'projectile)
  (map! :mode gitmanager-mode :n "RET" #'gitmanager-run-magit)
  (map! :mode gitmanager-mode :n "q" #'gitmanager-hide)
  (map! :mode gitmanager-mode :n "r" #'gitmanager-fetch-and-state)
  (map! :leader :desc "Open Gitmanager" "g m" #'gitmanager))

(after! gitmanager
  (setq gitmanager-cache-dir "~/.config/gitmanager/"))

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
