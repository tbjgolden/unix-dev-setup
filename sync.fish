# define ROOTDIR global
set -g ROOTDIR (dirname (realpath (status --current-filename)))

# define functions
source $ROOTDIR"/functions.fish"

# install jq if not already installed
if not type -q jq
    echo "jq not installed, installing..."
    cross_install jq
end

set -l STATEFILE $ROOTDIR"/.state.json"
if test -f $STATEFILE

    set -l FILELEN (echo (cat "$STATEFILE") | string join "")
    set -l FILELEN (string trim "$FILELEN")
    set -l FILELEN (string length "$FILELEN")

    if not jq empty $STATEFILE 2>/dev/null
        # syntax error
        echo "Syntax error in state file; resetting in 5 seconds"
        sleep 5
        echo "{}" >$STATEFILE
        echo "State reinitialized"
    else if test 0 -eq $FILELEN
        # empty file
        echo "{}" >$STATEFILE
    end
else
    echo "{}" >$STATEFILE
end

for PART in terminal fonts editor runtimes browser audio repos
    # work out if it needs an update or not
    set -l MD5SUM (string split "  " (tar -cOP $ROOTDIR"/parts/"$PART | md5sum))
    set -l MD5SUM "\""$MD5SUM[1]"\""
    set -l PREVMD5SUM (jq ".$PART" $STATEFILE)

    if test $PREVMD5SUM = "null"
        set -g FIRSTRUN "true"
    else
        set -g FIRSTRUN "false"
    end

    if test $PREVMD5SUM != $MD5SUM
        set_color green
        echo "["$PART":started]"
        set_color normal

        source $ROOTDIR"/parts/"$PART"/sync.fish"

        begin
            # Manually add VS Code to menu
            set -l IFS
            set -l JSON (jq "."$PART"="$MD5SUM $STATEFILE)
            set -l JSON $JSON[1]
            echo $JSON >$STATEFILE
        end

        echo (jq "."$PART"="$MD5SUM $STATEFILE) >$STATEFILE

        set_color green
        echo "["$PART":done]"
        set_color normal
    else
        set_color brblack
        echo "["$PART":skip]"
        set_color normal
    end
end
