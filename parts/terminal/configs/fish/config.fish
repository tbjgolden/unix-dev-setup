
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
alias gs="git status"
alias grnb="git branch -m"

alias node-debug="node --inspect --debug-brk"

alias edit="code"

function gb
    set -l branches (git branch)
    set -l output
    for i in (seq (count $branches))
        echo (string repeat -n (math 5 - (string length "1")) " ") $i "  " $branches[$i]
    end
end

function is_int
    if test -z $argv[1]
        return 1
    end

    set AS_MATH_EXP (math $argv[1] 2>/dev/null)
    set AS_INT (math "floor("$argv[1]")" 2>/dev/null)

    if not test -z $AS_MATH_EXP
        if not test -z $AS_INT
            if test $AS_INT = $argv[1]
                return 0
            end
        end
    end

    return 1
end

function gdb
    if test -z $argv[1]
        git branch -D
        return $status
    end

    set -l branches (string sub -s 3 (git branch))

    if is_int $argv[1]
        set has_branch_with_number_name "false"
        for branch in $branches
            if is_int $branch
                set has_branch_with_number_name "true"
                break
            end
        end

        if test $has_branch_with_number_name = "true"
            git branch -D $argv
        else if contains $argv[1] (seq (count $branches))
            git branch -D $branches[$argv[1]]
        else
            echo "fatal: branch index out of bounds" >2
            return 69
        end
    else
        git branch -D $argv
    end

    # git branch -D
end

function resource
    source ~/.config/fish/config.fish
end

set -gx PATH ~/.yarn/bin ~/.cargo/bin ~/Packages/bin $PATH
