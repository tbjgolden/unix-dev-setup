set -l DIR (dirname (realpath (status --current-filename)))

if test $FIRSTRUN = "true"
    yarn global add @bitwarden/cli

    # should create initial files so that doesn't find it's way into $output
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
