
def n0s1 [] {
    let $green = "\e[32m";
    let $reset = "\e[0m";

    let logo = [
        '       /\     /\        ',
        '      /  \   /  \       ',
        '     / /\ \ / /\ \      ',
        '    / /  \ X /  \ \     ',
        '   / /    X X    \ \    ',
        '  / /    / X \    \ \   ',
        ' / /    /_/_\_\    \ \  ',
        '/_/______/___\      \ \ ',
        ' /      /____________\_\',
        '/_____________________\ '
    ] | str join "\n"

    print $"($green)\n($logo)\n($reset)"
}

def cls [] { clear; n0s1 }


alias qq = exit
alias la = ls -a

# Git aliases
alias gaa = git add -A
alias gs = git status
alias gpd = git pull
alias gpu = git push
alias gsw = git switch (git branch -a | lines | str trim | str replace 'remotes/origin/' '' | uniq | sort | skip 1 | drop 1 | to text | fzf)
alias gcm = git commit -m

alias gpuu = git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)

alias clip = wl-copy
alias rec = wf-recorder
alias cap = grim -g "$(slurp)" - | swappy -f -

cls
