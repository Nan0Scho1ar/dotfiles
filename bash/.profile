export NREPOS="$HOME/repos/me"
export NCORE="$NREPOS/n0s1.core"
export NDOT="$NREPOS/dotfiles"
export NSCR="$NREPOS/scripts"

if [[ $- == *i* ]]; then
    source $NREPOS/n0s1.core/out/colours
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
#export GNUPGHOME="$XDG_DATA_HOME"/gnupg
#export MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
#export VIMINIT='source $MYVIMRC'
export EDITOR="vim"
export READER="zathura"
export VISUAL="vim"
export CODEEDITOR="emacs"
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#export MANPAGER="n0s1vim -c 'set ft=man' -"
export TERMINAL="alacritty"
export BROWSER="brave"
export COLORTERM="truecolor"
# export PAGER="less"
if command -v termux-setup-storage > /dev/null 2>&1; then
    export TERM=xterm-24bits
else
    export TERM='xterm-256color'
fi
export WM="bspwm"

SCRIPT_PATHS="$($NCORE/out/mkpath $NSCR)"
export PATH="$PATH:$SCRIPT_PATHS:$NREPOS/n0s1.core/out:$HOME/.cargo/bin:$HOME/.config/emacs/bin:$HOME/.local/bin"

READ_PROFILE=true
[ "$READ_RCFILE" != "true" ] && [[ -f $HOME/.bashrc ]] && . $HOME/.bashrc
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

. "$HOME/.cargo/env"
