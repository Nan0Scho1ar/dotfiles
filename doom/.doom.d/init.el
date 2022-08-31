(setq work-config t
      home-config nil)

(doom!

       :completion
       company           ; the ultimate code completion backend
       vertico             ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       doom-quit         ; DOOM quit-message prompts when you quit Emacs
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides     ; highlighted indent columns
       ligatures         ; ligatures and symbols to make your code pretty again
       minimap           ; show a map of the code on the side
       modeline          ; snazzy, Atom-inspired modeline, plus API
       nav-flash         ; blink cursor line after big motions
       ophints           ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       ;; tabs              ; a tab bar for Emacs
       treemacs          ; a project drawer, like neotree but cooler
       unicode           ; extended unicode support for various languages
       vc-gutter         ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       window-select     ; visually switch windows
       workspaces        ; tab emulation, persistence & separate workspaces
       zen               ; distraction-free coding or writing

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettiness
       lispy             ; vim for lisp, for people who don't like vim
       snippets          ; my elves. They type so I don't have to
       word-wrap         ; soft wrapping with language-aware indent

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       ibuffer         ; interactive buffer management
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       eshell            ; the elisp shell that works everywhere
       vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax              ; tasing you for every semicolon you forget
       (spell +flyspell) ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake every you make

       :tools
       direnv
       editorconfig
       (docker +lsp)
       (eval +overlay)
       (lookup +dictionary +offline)              ; navigate your code and its documentation
       (lsp +peek)               ; M-x vscode
       magit             ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       pass              ; password manager for nerds
       pdf               ; pdf enhancements
       rgb               ; creating color strings
       tree-sitter       ; syntax and parsing, sitting in a tree...

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       (cc +lsp +tree-sitter)                ; C > C++ == 1
       (data)              ; config/data formats
       (elixir +lsp +tree-sitter)            ; erlang done right
       (emacs-lisp +tree-sitter)        ; drown in parentheses
       (go +lsp +tree-sitter)         ; the hipster dialect
       (json +lsp +tree-sitter)              ; At least it ain't XML
       (javascript +lsp +tree-sitter)        ; all(hope(abandon(ye(who(enter(here))))))
       (markdown +grip +tree-sitter)          ; writing docs for people to ignore
       (org +dragndrop +gnuplot
            +hugo +jupyter
            +pandoc +pomodoro
            +present +pretty
            +roam2 +tree-sitter)               ; organize your plain life in plain text
       (php +lsp +tree-sitter)               ; perl's insecure younger brother
       (python +lsp +pyright
               +pyenv +tree-sitter)            ; beautiful is better than ugly
       (rest)              ; Emacs as a REST client
       (sh +lsp +tree-sitter)                ; she sells {ba,z,fi}sh shells on the C xor
       (web)               ; the tubes
       (yaml +lsp +tree-sitter)              ; JSON, but readable

       :app
       calendar
       everywhere        ; *leave* Emacs!? You must be joking

       :config
       literate
       (default +bindings +smartparens)

)
