
set -U EDITOR vim
set -U VISUAL code
set -U BROWSER firefox

# set -U ELECTRON_TRASH kioclient5 (<- needs fix)

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
end

function bw
    command bw $argv --session $BW_SESSION
end

function bws
    set -l DIR (dirname (realpath (status --current-filename)))

    # ask for login if session variable is missing
    if test -z $BW_SESSION
        echo "Bitwarden session expired"

        command bw logout &>/dev/null

        echo "Login to bitwarden:"
        set output (command bw login)

        while test "$output[1]" != 'You are logged in!'
            echo "Invalid login, try again:"
            set output (command bw login)
        end

        if test (string sub -l 20 $output[4]) = '$ export BW_SESSION='
            eval 'set -U BW_SESSION '(string sub -s 21 $output[4])
        end
    end

    set SEARCH_RESULTS (bw list items --search (string join ' ' $argv) | jq -r '.[] | select(.folderId == null) | @json')

    for SEARCH_RESULT in $SEARCH_RESULTS
        echo "----------------------------------------"
        echo (echo $SEARCH_RESULT | jq -r '.name')
        set CREDS (echo $SEARCH_RESULT | jq -r '[.login.username, .login.password] | @tsv')
        if not test -z (string trim $CREDS)
            echo ' ' $CREDS
        end
        set NOTES (echo $SEARCH_RESULT | jq -r '.notes')
        if test "$NOTES" != "null"
            echo ""
            for line in $NOTES
                echo ' ' $line
            end
        end
        set NOTES (echo $SEARCH_RESULT | jq -r '.login.notes')
        if test "$NOTES" != "null"
            echo ""
            for line in $NOTES
                echo ' ' $line
            end
        end
        echo "----------------------------------------"
    end
end

function resource
    source ~/.config/fish/config.fish
end

set -l BINARY_PATHS ~/.asdf/installs/*/*/bin
set -l BINARY_PATHS $BINARY_PATHS[-1..1]
set extra_paths (yarn global bin) $BINARY_PATHS ~/Packages/bin

for extra_path in $extra_paths
    if not contains $extra_path $fish_user_paths
        set -U -a fish_user_paths $extra_path
    end
end

# device specific env
if test -f ~/.fishrc.fish
    source ~/.fishrc.fish
end

# asdf
if test -f ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
end
