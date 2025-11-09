(setq home-config t
      work-config nil)

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
tabs              ; a tab bar for Emacs
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
editorconfig
docker
direnv
ein               ; tame Jupyter notebooks with emacs
(eval +overlay)     ; run code, run (also, repls)
(lookup +dictionary +offline)              ; navigate your code and its documentation
lsp               ; M-x vscode
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
(beancount +lsp)         ; mind the GAAP
(cc +lsp +tree-sitter)                ; C > C++ == 1
(clojure +lsp +tree-sitter)           ; java with a lisp
(common-lisp +lsp +tree-sitter)       ; if you've seen one lisp, you've seen them all
(coq)               ; proofs-as-programs
(csharp +lsp +dotnet +unity +tree-sitter)            ; unity, .NET, and mono shenanigans
(data +lsp +tree-sitter)              ; config/data formats
(elixir +lsp +tree-sitter)            ; erlang done right
(emacs-lisp +lsp +tree-sitter)        ; drown in parentheses
(erlang +lsp +tree-sitter)            ; an elegant language for a more civilized age
(ess +lsp +tree-sitter)               ; emacs speaks statistics
(gdscript +lsp +tree-sitter)          ; the language you waited for
(go +lsp +tree-sitter)         ; the hipster dialect
(haskell +dante +tree-sitter)  ; a language that's lazier than I am
(json +lsp +tree-sitter)              ; At least it ain't XML
(java +meghanada +lsp +tree-sitter) ; the poster child for carpal tunnel syndrome
(javascript +lsp +tree-sitter)        ; all(hope(abandon(ye(who(enter(here))))))
(julia +lsp +tree-sitter)             ; a better, faster MATLAB
(latex +lsp)             ; writing papers in Emacs has never been so fun
(lua +lsp +tree-sitter)               ; one-based indices? one-based indices
(markdown +grip +tree-sitter)          ; writing docs for people to ignore
(org +dragndrop
     +gnuplot +hugo
     +jupyter +pandoc
     +pomodoro +present
     +pretty +roam2 +tree-sitter)               ; organize your plain life in plain text
(php +lsp +tree-sitter)               ; perl's insecure younger brother
(plantuml)          ; diagrams for confusing people more
(python +lsp +pyright +pyenv +black +tree-sitter)            ; beautiful is better than ugly
(qt)                ; the 'cutest' gui framework ever
(racket +lsp +tree-sitter)            ; a DSL for DSLs
(rest)              ; Emacs as a REST client
(ruby +rails +tree-sitter)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
(rust +lsp +tree-sitter)              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
(scheme +guile +tree-sitter)   ; a fully conniving family of lisps
(sh +lsp +tree-sitter)                ; she sells {ba,z,fi}sh shells on the C xor
(web +lsp +tree-sitter)               ; the tubes
(yaml +lsp +tree-sitter)              ; JSON, but readable

:email
(mu4e +gmail)

:app
calendar
emms
everywhere        ; *leave* Emacs!? You must be joking
irc               ; how neckbeards socialize
(rss +org)        ; emacs as an RSS reader

:config
literate
(default +bindings +smartparens)

)
