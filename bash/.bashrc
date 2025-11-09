READ_RCFILE=true

if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    echo "Remember to start tmux"
    #tt;
fi

[ "$READ_PROFILE" != "true" ] && [[ -f $HOME/.profile ]] && . $HOME/.profile

if [[ $- == *i* ]]; then
    setfont /usr/share/kbd/consolefonts/Lat2-Terminus16.psfu.gz > /dev/null 2>&1

    if command -v n0s1 >/dev/null; then
	    n0s1 -g
    fi

    green=`tput setaf 2`
    red=`tput setaf 1`
    yellow=`tput setaf 3`
    blue=`tput setaf 4`
    magenta=`tput setaf 5`
    cyan=`tput setaf 6`
    white=`tput setaf 7`
    blink=`tput blink`
    reset=`tput sgr0`
fi

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

branch_with_status() {
    is_in_git_repo || return
    stat="$(git status)"
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo $stat | grep -q "nothing to commit, working tree clean" && \
        echo $stat | grep -q "Your branch is up to date" && \
        echo "(${green}${branch}${reset})" && return
    echo $stat | grep -Eq "both added|both modified" && \
        echo "(${red}${branch}${reset}) ${red}$(git diff --name-only --diff-filter=U | wc -l) CONFLICTS${reset}" && return
    new="${green}$(echo $stat | grep -o 'new file:' | wc -l)${reset}"
    modified="${yellow}$(echo $stat | grep -o 'modified:' | wc -l)${reset}"
    deleted="${red}$(echo $stat | grep -o 'deleted:' | wc -l)${reset}"
    echo $stat | grep -q "Your branch is up to date" && \
        echo "(${red}${branch}${reset}) ${new} ${modified} ${deleted}" || \
        echo "(${yellow}${branch}${reset})"
}


ps1() {
    if [ $? -ne 0 ]; then
        _ps1_error="[${red}✗${reset}]─"
    else
        _ps1_error=''
    fi
    _ps1_pwd="[${yellow}$(pwd | sed "s|$HOME|~|")${reset}]"
    _ps1_userhostshell="[${yellow}$(whoami)${reset}@${cyan}$(hostname)${yellow}(bash)${reset}${reset}]─"
    if [ -n "$AWS_PROFILE" ]; then
        _ps1_aws_profile="─[${magenta}$AWS_PROFILE${reset}]"
    else
        _ps1_aws_profile=''
    fi

    # # TODO Finish this
    # if [ -n "$ENV" ]; then
    #     _ps1_ENV="[${white}ENV${reset}='${magenta}$ENV${reset}']"
    # else
    #     _ps1_ENV=''
    # fi


    echo "${reset}┌─${_ps1_error}${_ps1_userhostshell}${_ps1_pwd}${_ps1_aws_profile} $(branch_with_status) $VIRTUAL_ENV_PROMPT"
    echo "└──╼ "
}
export PS1='$(ps1)'

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#eval $(thefuck --alias)

[ -d "/usr/racket" ] && export PATH="$PATH:/usr/racket/bin"

# Keychain
if command -v termux-setup-storage > /dev/null 2>&1; then
    echo "todo fix keychain"
elif [[ $- == *i* ]]; then
    which keychain 1>/dev/null 2>&1 && eval `keychain -q --eval id_rsa`
fi

export XDG_CONFIG_HOME=$HOME/.config
if [[ -f $XDG_CONFIG_HOME/.aliases ]]; then
	source $XDG_CONFIG_HOME/.aliases
fi
if [[ -f $NREPOS/gitmanager/.git_aliases ]]; then
	source $NREPOS/gitmanager/.git_aliases
fi


#This line seems to break graphical logins
#export HISTFILE="$XDG_DATA_HOME"/bash/history
export HISTCONTROL=ignoreboth
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it


set -o vi
# Stop Putty from doing XOFF/XON with Ctrl-S/Ctrl-Q
# SOURCE: http://raamdev.com/recovering-from-ctrls-in-putty (Morgy, 7/14/08)
#
# stty ixany
if [[ $- == *i* ]]; then
    stty ixoff -ixon
fi
### If needing to listen to Ctrl-S for some apps, use these two instead:
#stty stop undef
#Stty start undef

if [[ $TMUX ]]; then
    echo nan0mux init...
fi

git config --global core.editor "vim"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


#CD Bookmarks
[ -f $NREPOS/n0s1.core/out/cb ] && source $NREPOS/n0s1.core/out/cb
#Edit File Bookmarks
[ -f $NREPOS/n0s1.core/out/ef ] && source $NREPOS/n0s1.core/out/ef

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias diff='diff --color=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

if command -v direnv >/dev/null; then
	eval "$(direnv hook bash)"
fi

if command -v pyenv >/dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"
