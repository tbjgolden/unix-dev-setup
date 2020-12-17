
set -U EDITOR vim
set -U VISUAL code
set -U BROWSER firefox
set -U ELECTRON_TRASH kioclient5

if test -f ~/.fishrc.fish
    source ~/.fishrc.fish
end

alias ga="git add"
alias gcl="git clone"
alias gc="git commit"
alias gr="git reset"
alias gch="git checkout"
alias gpl="git pull origin"
alias gph="git push origin"
alias gnb="git checkout -b"
alias gdb="git branch -D"
alias gs="git status"
alias grnb="git branch -m"

alias edit="code"

function gb
    set -l branches (git branch)
    set -l output
    for i in (seq (count $branches))
        echo (string repeat -n (math 5 - (string length "1")) " ") $i "  " $branches[$i]
    end
end

function resource
    source ~/.config/fish/config.fish
end

set -gx PATH ~/.yarn/bin ~/.cargo/bin ~/Packages/bin $PATH
