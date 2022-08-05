set nocompatible           " Vim defaults rather than vi ones. Keep at top.

if has("nvim")
    set runtimepath+=$XDG_CONFIG_HOME/nvim,$XDG_DATA_HOME/nvim,$XDG_DATA_HOME/nvim/after
    set viewdir=$XDG_DATA_HOME/nvim/view | call mkdir(&viewdir, 'p')
    if !isdirectory(&viewdir)   | call mkdir(&viewdir, 'p', 0700)   | endif
    set viminfofile=$XDG_DATA_HOME/nvim/viminfo

    set backupdir=$XDG_CACHE_HOME/nvim/backup | call mkdir(&backupdir, 'p')
    if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p', 0700) | endif
    set directory=$XDG_CACHE_HOME/nvim/swap   | call mkdir(&directory, 'p')
    " Persist undo history between nVim sessions.
    set undodir=$XDG_CACHE_HOME/nvim/undo     | call mkdir(&undodir,   'p')
    set undofile


    if empty(glob("$XDG_DATA_HOME/nvim/autoload/plug.vim"))
        silent !curl -fLo $XDG_DATA_HOME/nvim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    set fcs=eob:\ "
    call plug#begin("$XDG_DATA_HOME/nvim/autoload/plugged")
else
    set runtimepath+=$XDG_CONFIG_HOME/vim,$XDG_DATA_HOME/vim,$XDG_DATA_HOME/vim/after
    set viewdir=$XDG_DATA_HOME/vim/view | call mkdir(&viewdir, 'p')
    if !isdirectory(&viewdir)   | call mkdir(&viewdir, 'p', 0700)   | endif
    set viminfofile=$XDG_DATA_HOME/vim/viminfo

    set backupdir=$XDG_CACHE_HOME/vim/backup | call mkdir(&backupdir, 'p')
    if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p', 0700) | endif
    set directory=$XDG_CACHE_HOME/vim/swap   | call mkdir(&directory, 'p')
    " Persist undo history between Vim sessions.
    set undodir=$XDG_CACHE_HOME/vim/undo     | call mkdir(&undodir,   'p')
    set undofile



    if empty(glob("$XDG_DATA_HOME/vim/autoload/plug.vim"))
        silent !curl -fLo $XDG_DATA_HOME/vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin("$XDG_DATA_HOME/vim/autoload/plugged")
endif

Plug 'junegunn/vim-peekaboo'                          "View contents of registers when pasting or using macros
Plug 'junegunn/goyo.vim'                              "No distractions mode
Plug 'dhruvasagar/vim-table-mode'                     "Make tables easily
Plug 'vimwiki/vimwiki'                                "Your own personal wiki
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }   "FZF
Plug 'junegunn/fzf.vim'                               "Fuzzy search everything
Plug 'junegunn/limelight.vim'                         "Dim all but the current paragraph
Plug 'easymotion/vim-easymotion'                      "Jump around the document quickly
Plug 'shapeoflambda/dark-purple.vim'                  "Purple theme
Plug 'mbbill/undotree'                                "Undo tree visualiser
Plug 'tpope/vim-repeat'                               "Fix repeat motions with plugins
Plug 'zirrostig/vim-schlepp'                          "Move visual blocks
Plug 'psliwka/vim-smoothie'                           "Smooth scrolling

" Plug 'reedes/vim-pencil'                            "Smarter word wrapping
" Plug 'ron89/thesaurus_query.vim'                    "Thesaurus (also uncomment tq_openoffice_en_file)

"Plug 'airblade/vim-gitgutter'                         "Show git modifications in gutter
"Plug 'OmniSharp/omnisharp-vim'                        "C# intellisense server
"Plug 'yuezk/vim-js'                                   "Javascript stuff
"Plug 'maxmellon/vim-jsx-pretty'                       "React stuff
"Plug 'HerringtonDarkholme/yats.vim'                   "Typescript stuff
"Plug 'w0rp/ale'                                       "Linter
"Plug 'neoclide/coc.nvim', {'branch': 'release'}       "Vim intellisense
"Plug 'puremourning/vimspector'
"Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
"Plug 'pappasam/coc-rls'                               "Rust intellisense
"Plug 'pappasam/coc-json'                              "Json for rust intellisense
"Plug 'powerman/vim-plugin-AnsiEsc'                    "Colour names and ansi escapes
call plug#end()


" ###########
" ## Setup ##
" ###########


" use 256 colors in terminal
set t_Co=256
set term=xterm-256color

syntax enable
colorscheme dark_purple
" transparent bg
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
" For Vim<8, replace EndOfBuffer by NonText
autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
filetype plugin indent on  " Enable filetype-specific settings.
filetype plugin on

set autoindent             " Use current indent for new lines.
set background=dark
set backspace=2            " Make the backspace behave as most applications.
set display=lastline       " Show as much of the line as will fit.
set expandtab              " Use spaces instead of tabs for indentation.
set formatoptions+=ncroqlj " Control automatic formatting.
set hlsearch               " Highlight the last used search pattern.
set ignorecase             " Searching with / is case-insensitive.
set incsearch              " Jump to search match while typing.
set laststatus=2           " Always show the statusline.
set mouse=a                " Allows mouse stuff to work (Not supported in all terminals)
set nrformats-=octal       " Remove octal support from 'nrformats'.
set rtp+=~/.fzf
set ruler                  " Show the ruler in the statusline.
set scrolloff=5            " Minimum number of lines to keep above/below cursor.
set shiftwidth=0           " Use same value as 'tabstop'.
set showcmd                " Show (partial) command in bottom-right.
set smartcase              " Disable 'ignorecase' if the term contains upper-case.
set smarttab               " Backspace removes 'shiftwidth' worth of spaces.
set softtabstop=-1         " Use same value as 'shiftwidth'.
set tabstop=4              " Size of a Tab character.
set title
set wildmenu               " Better tab completion in the commandline.
set wildmode=list:longest  " List all matches and complete to the longest match.
set wrap                   " Wrap long lines.
set number                 " Show line numbers
set relativenumber         " Show relative numbers for easier jumping


" Set statusline, shown here a piece at a time
"
" If you change the status line colour make sure you also reapply the status bar on
" goyo exit
"
highlight User1 ctermbg=green guibg=green ctermfg=black guifg=black
"highlight User1 ctermbg=grey guibg=purple ctermfg=black guifg=black

set statusline=%1*            " Switch to User1 color highlight
set statusline+=%<%F          " file name, cut if needed at start
set statusline+=%M            " modified flag
set statusline+=%y            " file type
set statusline+=%=            " separator from left to right justified
"set statusline+=\ %{WordCount()}\ words, " Add wordcount
set statusline+=\ %l/%L\ lines,\ %P      " percentage through the file

let s:fontsize = 12
let g:goyo_width = 80
let g:camelchar = "A-Z0-9.,;:{([`'\""
let mapleader = "\<Space>"
let g:vimspector_enable_mappings='HUMAN'

" ##############
" ## Mappings ##
" ##############

" Allow write as sudo
cmap w!! w !sudo tee > /dev/null %<cr>

" Set leader to space
nnoremap <Space> <Nop>


"Colour text
nnoremap <silent> <Leader>ct :AnsiEsc<CR>

vnoremap <silent> <Leader>cr :s/\%V.*\%V./<C-V><Esc>[31m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>cg :s/\%V.*\%V./<C-V><Esc>[32m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>cy :s/\%V.*\%V./<C-V><Esc>[33m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>cb :s/\%V.*\%V./<C-V><Esc>[34m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>cm :s/\%V.*\%V./<C-V><Esc>[35m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>cc :s/\%V.*\%V./<C-V><Esc>[36m&<C-V><Esc>[m/<CR>

vnoremap <silent> <Leader>hr :'<,'>s/\%V.*\%V./<C-V><Esc>[41m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>hg :'<,'>s/\%V.*\%V./<C-V><Esc>[42m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>hy :'<,'>s/\%V.*\%V./<C-V><Esc>[43m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>hb :'<,'>s/\%V.*\%V./<C-V><Esc>[44m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>hm :'<,'>s/\%V.*\%V./<C-V><Esc>[45m&<C-V><Esc>[m/<CR>
vnoremap <silent> <Leader>hc :'<,'>s/\%V.*\%V./<C-V><Esc>[46m&<C-V><Esc>[m/<CR>


" {F2} Toggles line numbers
nnoremap <silent> <F2> :call ToggleLineNumbers()<CR>
vnoremap <silent> <F2> :call ToggleLineNumbers()<CR>
inoremap <silent> <F2> <C-o>:call ToggleLineNumbers()<CR>

" {F3} Hide search highlighting
nmap <silent> <F3> :noh<CR>
vmap <silent> <F3> :noh<CR>
imap <silent> <F3> <C-o>:noh<CR>

" {F4} Toggles line numbers
nnoremap <silent> <F4> :GitGutterToggle<CR>
vnoremap <silent> <F4> :GitGutterToggle<CR>
inoremap <silent> <F4> <C-o>:GitGutterToggle<CR>

" {F5} Toggles ALE
"nnoremap <silent> <F5> :ALEToggle<CR>
"vnoremap <silent> <F5> :ALEToggle<CR>
"inoremap <silent> <F5> <C-o>:ALEToggle<CR>

" FZF Things
nnoremap <silent> <Leader><Space> :Files<CR>
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
nnoremap <silent> <Leader>B :Buffers<CR>
nnoremap <silent> <Leader>G :GFiles?<CR>
nnoremap <silent> <Leader>c  :Commits<CR>
nnoremap <silent> <Leader>C :BCommits<CR>
nnoremap <silent> <Leader>M :Marks<CR>
nnoremap <silent> <Leader>F :BLines<CR>
nnoremap <silent> <Leader>T :Filetypes<CR>
nnoremap <silent> <Leader>W :Windows<CR>
nnoremap <silent> <Leader>H :History<CR>
nnoremap <silent> <Leader>: :History:<CR>
nnoremap <silent> <Leader>/ :History/<CR>
nnoremap <silent> <Leader>? :Maps<CR>
nnoremap <Leader>rg :Rg<Space>
nnoremap <Leader>RG :Rg!<Space>

" Reload vim config while editing it
nnoremap <silent> <Leader>r :source %<CR>

" Easy leave insert mode
imap jj <Esc>

" {Shift+Enter} insert empty line above
nnoremap <silent><S-CR> :call append(line('.')-1, '')<CR>
inoremap <silent><S-CR> <Esc>:call append(line('.')-1, '')<CR>a

" {Enter} insert line below in normal mode
nnoremap <silent><CR> :call append(line('.'), '')<CR>

" {Space+zz} toggle keep curson in center of screen
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
vnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" Easymotion
map <Leader> <Plug>(easymotion-prefix)
map <Leader>s <Plug>(easymotion-bd-f)
nmap <Leader>s <Plug>(easymotion-overwin-f)
map <Leader>S <Plug>(easymotion-bd-f2)
nmap <Leader>S <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" {Space+Enter} No distractions mode
nnoremap <silent> <Leader><CR> :Goyo<CR>

" Allow repeat action on selected lines
vnoremap <silent> . :norm .<cr>

" ##COPY/Paste
" {Leader+y} yanks the current word to default  buffer
nnoremap <Leader>y viwy
" {Leader+Ctrl+y} yanks the current word to system buffer
nnoremap <Leader><C-y> viw"*y
" {Leader+p} pastes over current word overwritting buffer
" {Leader+Ctrl+p} pastes over current word from system buffer, overwritting default buffer
nnoremap <Leader>p viwp
nnoremap <Leader><C-p> viw"*p
" {Leader+P} pastes over current word without overwritting buffer
" {Leader+Ctrl+P} pastes over current word from system buffer without overwritting default buffer
nnoremap <Leader>P viw"_dp
nnoremap <Leader><C-P> viw"_d"*p
" Use system clipboard
"vnoremap <C-c> "*y
"vnoremap <C-v> "*p
"nnoremap <C-v> "*p
"inoremap <C-v> <Esc>"*pa
vnoremap <C-y> "*y
vnoremap <C-p> "*p
nnoremap <C-p> "*p
inoremap <C-p> <Esc>"*pa

" {Ctrl-Z} Undo in insert mode
inoremap <C-z> <Esc>u

" CamelCase subword movement
" Include '.' for class member, ',' for separator, ';' end-statement, and <[< bracket starts and "'` quotes.
nnoremap <silent><C-h> :<C-u>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
nnoremap <silent><C-l> :<C-u>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
inoremap <silent><C-h> <C-o>:call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
inoremap <silent><C-l> <C-o>:call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
vnoremap <silent><C-h> :<C-U>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>v`>o
vnoremap <silent><C-l> :<C-U>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>v`<o

" Swap lines up and down by holdiung Ctrl
nnoremap <silent> <C-Up> <Esc>:call MoveLine(-1)<CR>
nnoremap <silent> <C-Down> <Esc>:call MoveLine(+1)<CR>
nnoremap <silent> <C-k> <Esc>:call MoveLine(-1)<CR>
nnoremap <silent> <C-j> <Esc>:call MoveLine(+1)<CR>
inoremap <silent> <C-Up> <Esc>:call MoveLineAndInsert(-1)<CR>
inoremap <silent> <C-Down> <Esc>:call MoveLineAndInsert(+1)<CR>
inoremap <silent> <C-k> <Esc>:call MoveLineAndInsert(-1)<CR>
inoremap <silent> <C-j> <Esc>:call MoveLineAndInsert(+1)<CR>

" {Alt+Movement} Switch windows
nnoremap <A-Left> <C-w>h
vnoremap <A-Left> <C-w>h
inoremap <A-Left> <C-o><C-w>h
nnoremap <A-Down> <C-w>j
vnoremap <A-Down> <C-w>j
inoremap <A-Down> <C-o><C-w>j
nnoremap <A-Up> <C-w>k
vnoremap <A-Up> <C-w>k
inoremap <A-Up> <C-o><C-w>k
nnoremap <A-Right> <C-w>l
vnoremap <A-Right> <C-w>l
inoremap <A-Right> <C-o><C-w>l
nnoremap <A-h> <C-w>h
vnoremap <A-h> <C-w>h
inoremap <A-h> <C-o><C-w>h
nnoremap <A-j> <C-w>j
vnoremap <A-j> <C-w>j
inoremap <A-j> <C-o><C-w>j
nnoremap <A-k> <C-w>k
vnoremap <A-k> <C-w>k
inoremap <A-k> <C-o><C-w>k
nnoremap <A-l> <C-w>l
vnoremap <A-l> <C-w>l
inoremap <A-l> <C-o><C-w>l

" Adjust fontsize
nnoremap <silent> <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
nnoremap <silent> <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
vnoremap <silent> <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
vnoremap <silent> <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <silent> <C-ScrollWheelUp> <C-o>:call AdjustFontSize(1)<CR>
inoremap <silent> <C-ScrollWheelDown> <C-o>:call AdjustFontSize(-1)<CR>

" Adjust goyo size
nnoremap <silent> <S-ScrollWheelUp> :call AdjustGoyoSize(10)<CR>
nnoremap <silent> <S-ScrollWheelDown> :call AdjustGoyoSize(-10)<CR>
vnoremap <silent> <S-ScrollWheelUp> :call AdjustGoyoSize(10)<CR>
vnoremap <silent> <S-ScrollWheelDown> :call AdjustGoyoSize(-10)<CR>
inoremap <silent> <S-ScrollWheelUp> <C-o>:call AdjustGoyoSize(10)<CR>
inoremap <silent> <S-ScrollWheelDown> <C-o>:call AdjustGoyoSize(-10)<CR>

" {Alt-r} Rotate window positions
vmap <silent> <A-r> <C-w><C-r>
nmap <silent> <A-r> <C-w><C-r>
imap <silent> <A-r> <C-o> <C-w><C-r>



" {Alt+Shift+Movement} Resize window
vnoremap <silent> <A-S-Up>         :call WindowHeight("-")<CR>
nnoremap <silent> <A-S-Up>         :call WindowHeight("-")<CR>
inoremap <silent> <A-S-Up>    <C-o>:call WindowHeight("-")<CR>
vnoremap <silent> <A-K>            :call WindowHeight("-")<CR>
nnoremap <silent> <A-K>            :call WindowHeight("-")<CR>
inoremap <silent> <A-K>       <C-o>:call WindowHeight("-")<CR>
vnoremap <silent> <A-S-Down>       :call WindowHeight("+")<CR>
nnoremap <silent> <A-S-Down>       :call WindowHeight("+")<CR>
inoremap <silent> <A-S-Down>  <C-o>:call WindowHeight("+")<CR>
vnoremap <silent> <A-J>            :call WindowHeight("+")<CR>
nnoremap <silent> <A-J>            :call WindowHeight("+")<CR>
inoremap <silent> <A-J>       <C-o>:call WindowHeight("+")<CR>
vnoremap <silent> <A-S-Left>       :call WindowWidth("-") <CR>
nnoremap <silent> <A-S-Left>       :call WindowWidth("-") <CR>
inoremap <silent> <A-S-Left>  <C-o>:call WindowWidth("-") <CR>
vnoremap <silent> <A-H>            :call WindowWidth("-") <CR>
nnoremap <silent> <A-H>            :call WindowWidth("-") <CR>
inoremap <silent> <A-H>       <C-o>:call WindowWidth("-") <CR>
vnoremap <silent> <A-S-Right>      :call WindowWidth("+") <CR>
nnoremap <silent> <A-S-Right>      :call WindowWidth("+") <CR>
inoremap <silent> <A-S-Right> <C-o>:call WindowWidth("+") <CR>
vnoremap <silent> <A-L>            :call WindowWidth("+") <CR>
nnoremap <silent> <A-L>            :call WindowWidth("+") <CR>
inoremap <silent> <A-L>       <C-o>:call WindowWidth("+") <CR>

" {Alt+s/S} Split windows
vmap <silent> <A-s> :vsplit<CR>
nmap <silent> <A-s> :vsplit<CR>
imap <silent> <A-s> <C-o>:vsplit<CR>
vmap <silent> <A-S> :split<CR>
nmap <silent> <A-S> :split<CR>
imap <silent> <A-S> <C-o>:split<CR>

" {Alt-q} Close window without closing buffer
vmap <silent> <A-q> :close<CR>
nmap <silent> <A-q> :close<CR>
imap <silent> <A-q> <C-o>:close<CR>

" {Alt-f} Close window without closing buffer
vmap <silent> <A-f> :call ToggleNetrw()<CR>
nmap <silent> <A-f> :call ToggleNetrw()<CR>
imap <silent> <A-f> <C-o>:call ToggleNetrw()<CR>

" {Alt-u} Toggle the undo tree
vmap <silent> <A-u> :UndotreeToggle<CR>
nmap <silent> <A-u> :UndotreeToggle<CR>
imap <silent> <A-u> <C-o>:UndotreeToggle<CR>

" Move visual blocks around
vmap <S-Up>    <Plug>SchleppUp
vmap <S-Down>  <Plug>SchleppDown
vmap <S-Left>  <Plug>SchleppLeft
vmap <S-Right> <Plug>SchleppRight

" Duplicate visual block
vmap D <Plug>SchleppDup

" ###############
" ## Functions ##
" ###############

function! IsMostRight()
  let oldw = winnr()
  silent! exe "normal! \<c-w>l"
  let neww = winnr()
  silent! exe oldw.'wincmd w'
  return oldw == neww
endfunction

function! IsMostBottom()
  let oldw = winnr()
  silent! exe "normal! \<c-w>j"
  let neww = winnr()
  silent! exe oldw.'wincmd w'
  return oldw == neww
endfunction

function! WindowHeight(op)
  if (a:op == "+" && ! IsMostBottom()) || (a:op == "-" && IsMostBottom())
    exe ':resize +2'
  elseif (a:op == "+" && IsMostBottom()) || (a:op == "-" && ! IsMostBottom())
    exe ':resize -2'
  endif
endfunction

function! WindowWidth(op)
  if (a:op == "+" && ! IsMostRight()) || (a:op == "-" && IsMostRight())
    exe ':vertical resize +2'
  elseif (a:op == "+" && IsMostRight()) || (a:op == "-" && ! IsMostRight())
    exe ':vertical resize -2'
  endif
endfunction

" Swap lines up and down
function! MoveLine(n)       " -x=up x lines; +x=down x lines
    let n_move = (a:n < 0 ? a:n-1 : '+'.a:n)
    let pos = getcurpos()
    try         " maybe out of range
        exe ':move'.n_move
        call setpos('.', [0,pos[1]+a:n,pos[2],0])
    endtry
endfunction

" Swap lines up and down
function! MoveLineAndInsert(n)       " -x=up x lines; +x=down x lines
    try         " maybe out of range
        call MoveLine(a:n)
    finally
        startinsert
    endtry
endfunction

function! ToggleLineNumbers()
    if g:lineNumberState == 0
       set number                 " Show line numbers
       let g:lineNumberState=1
    elseif g:lineNumberState == 1
       set relativenumber         " Show relative numbers for easier jumping
       let g:lineNumberState=2
    else
       set nonumber               " Show line numbers
       set norelativenumber       " Show relative numbers for easier jumping
       let g:lineNumberState=0
    endif
endfunction

function! ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function! TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

function! CssMagicUnique()
	:%s/\v([^}])\n/\1/g|%sort u|%s/\v[;{]/&\r/g
endfunction

function! CollapseCss()
	:%s/\v([^}])\n/\1
endfunction

function! GrowCss()
%s/\v[;{]/&\r/g
endfunction

function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Consolas:h" . s:fontsize
endfunction

function! AdjustGoyoSize(amount)
  let g:goyo_width = g:goyo_width+a:amount
  :execute "Goyo " . g:goyo_width
endfunction

" ##Plugin stuff

" thesaurus_query dict path
"let g:tq_openoffice_en_file="~/dotfiles/windows/Packages/Neovim/MyThes-1.0/th_en_US_new"

" Easymotion settings
let g:EasyMotion_do_mapping = 0              "Remove default mappings
let g:EasyMotion_smartcase = 1               "Easymotion smartcase
" Limelight settings
let g:limelight_conceal_guifg = 'DarkGray'   "Concealed text colour
let g:limelight_default_coefficient = 0.7    "Brightness difference
let g:limelight_priority = -1                "Make search show thorough limelight
let g:lineNumberState=2    " Used to track toggling line numbers


" COC autocomplete tab
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

"""" enable 24bit true color
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

let g:word_count="<unknown>"
function! WordCount()
    return g:word_count
endfunction

function! UpdateWordCount()
    let lnum = 1
    let n = 0
    while lnum <= line('$')
        let n = n + len(split(getline(lnum)))
        let lnum = lnum + 1
    endwhile
    let g:word_count = n
endfunction
" Update the count when cursor is idle in command or insert mode.
" Update when idle for 1000 msec (default is 4000 msec).
set updatetime=1000
augroup WordCounter
    au! CursorHold,CursorHoldI * call UpdateWordCount()
augroup END


" Load matchit.vim plugin.
" Only load if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" Go to the last cursor location when opening a file.
augroup jump
	autocmd BufReadPost *
		\  if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\| exe 'normal! g`"'
		\| endif
augroup end

" Clean trailing whitespace.
fun! s:trim_whitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfun
command! TrimWhitespace call s:trim_whitespace()

" Vimwiki path and use markdown
let g:vimwiki_list = [{'path': '~/repos/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

let g:vimwiki_markdown_link_ext = 1

" FZF options
let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'alt-s': 'split',
      \ 'ctrl-v': 'vsplit'
  \ }

" ALE Lint
let g:ale_sign_error                  = '✘'
let g:ale_sign_warning                = '⚠'
highlight ALEErrorSign ctermbg        =NONE ctermfg=red
highlight ALEWarningSign ctermbg      =NONE ctermfg=yellow
let g:ale_linters_explicit            = 1
let g:ale_lint_on_text_changed        = 'never'
let g:ale_lint_on_enter               = 0
let g:ale_lint_on_save                = 1
let g:ale_fix_on_save                 = 1

let g:ale_linters = {
\   'markdown':      ['proselint', 'writegood'],
\   'text':      ['proselint', 'writegood'],
\}

let g:ale_fixers = {
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\}


" ##Goyo
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999   "Lock cursor to center of screen
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5    "Unlock cursor from center of screen
  Limelight!
  highlight User1 ctermbg=green guibg=green ctermfg=black guifg=black
  "highlight User1 ctermbg=grey guibg=purple ctermfg=black guifg=black
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


" ##Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

function! OpenToRight()
  :normal v
  let g:path=expand('%:p')
  execute 'q!'
  execute 'belowright vnew' g:path
  :normal <C-w>l
endfunction

function! OpenBelow()
  :normal v
  let g:path=expand('%:p')
  execute 'q!'
  execute 'belowright new' g:path
  :normal <C-w>l
endfunction

function! OpenTab()
  :normal v
  let g:path=expand('%:p')
  execute 'q!'
  execute 'tabedit' g:path
  :normal <C-w>l
endfunction

function! NetrwMappings()
    " Hack fix to make ctrl-l work properly
    noremap <buffer> <A-l> <C-w>l
    noremap <buffer> <C-l> <C-w>l
    noremap <buffer> s :call OpenToRight()<cr>
    noremap <buffer> S :call OpenBelow()<cr>
    noremap <buffer> t :call OpenTab()<cr>
endfunction

augroup netrw_mappings
    autocmd!
    autocmd filetype netrw call NetrwMappings()
augroup END

" Allow for netrw to be toggled
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

" Check before opening buffer on any file
function! NetrwOnBufferOpen()
  if exists('b:noNetrw')
      return
  endif
  call ToggleNetrw()
endfun

" Close Netrw if it's the only buffer open
autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif

" Make netrw act like a project Draw (Start open)
"augroup ProjectDrawer
  "autocmd!
      	" Don't open Netrw
  "autocmd VimEnter ~/vimwiki/*,*/.git/COMMIT_EDITMSG let b:noNetrw=1
  "autocmd VimEnter * :call NetrwOnBufferOpen()
"augroup END

let g:NetrwIsOpen=0

" special handling for autocomplete pairs by eluum (MIT License)
function! HandlePair(enter, key) abort
    " handle the next key press
    let nextChar = nr2char(getchar())
    if nextChar == "\<CR>" && a:enter
        :call feedkeys("i\<CR>\<esc>O")
    elseif nextChar == "\<tab>"
        :call feedkeys("xa")
    elseif nextChar == ";"
        :call feedkeys("A;")
    elseif nextChar == "{" && a:key == "("
        :call feedkeys("A {")
    elseif nextChar == "\<esc>"
        " do nothing, already in normal mode
    else
        :startinsert
        :call feedkeys(nextChar)
    endif
endfunction

finish "STOP!!!!! Don't load more


" #############
" ## Windows ## (Please Don't just leave all this on)
" #############

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

if has("clipboard")
    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>		"+gP
    map <S-Insert>		"+gP

    cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+
endif

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
" Use CTRL-G u to have CTRL-Z only undo the paste.

if 1
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
endif

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode (<C-O> doesn't work well when
" using completions).
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<Esc>:update<CR>gi

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

" Alt-Space is System menu
if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

if has("gui")
  " CTRL-F is the search dialog
  noremap  <expr> <C-F> has("gui_running") ? ":promptfind\<CR>" : "/"
  inoremap <expr> <C-F> has("gui_running") ? "\<C-\>\<C-O>:promptfind\<CR>" : "\<C-\>\<C-O>/"
  cnoremap <expr> <C-F> has("gui_running") ? "\<C-\>\<C-C>:promptfind\<CR>" : "\<C-\>\<C-O>/"

  " CTRL-H is the replace dialog,
  " but in console, it might be backspace, so don't map it there
  nnoremap <expr> <C-H> has("gui_running") ? ":promptrepl\<CR>" : "\<C-H>"
  inoremap <expr> <C-H> has("gui_running") ? "\<C-\>\<C-O>:promptrepl\<CR>" : "\<C-H>"
  cnoremap <expr> <C-H> has("gui_running") ? "\<C-\>\<C-C>:promptrepl\<CR>" : "\<C-H>"
endif

"Status-line
"set statusline=
"set statusline+=%#IncSearch#
"set statusline+=\ %y
"set statusline+=\ %r
"set statusline+=%#CursorLineNr#
"set statusline+=\ %F
"set statusline+=%= "Right side settings
"set statusline+=%#Search#
"set statusline+=\ %l/%L
"set statusline+=\ [%c]
