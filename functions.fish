function cross_install
    set -l CASKS firefox

    if type -q pacman
        sudo pacman -Syu --noconfirm $argv
    else if type -q apt
        sudo apt install -y $argv
    else if type -q brew
        set casks
        set other
        for arg in $argv
            if contains $arg (cat casks.txt)
                set -a casks $arg
            else
                set -a other $arg
            end
        end

        if test (count $casks) -gt 0
            brew install --cask $casks
        end

        if test (count $other) -gt 0
            brew install $other
        end
    else
        echo "Package manager or operating system not yet supported"
        exit 1
    end
end

function symlink_cask_binary
    if test (uname) = "Darwin"
        set -l FULLPATH $argv[1]
        set -l CMDNAME (string split "/" $argv[1])
        set -l CMDNAME $CMDNAME[(count $CMDNAME)]
        rm -f $HOME"/Packages/bin/"$CMDNAME
        if test -f $HOME"/Applications/"$FULLPATH
            ln -s $HOME"/Applications/"$FULLPATH $HOME"/Packages/bin/"$CMDNAME
        else if test -f "/Applications/"$FULLPATH
            ln -s "/Applications/"$FULLPATH $HOME"/Packages/bin/"$CMDNAME
        end
    end
end
