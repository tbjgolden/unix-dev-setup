set -l DIR (dirname (realpath (status --current-filename)))

if test $FIRSTRUN = "true"
    cross_install vim
    cross_install brotli

    # Install VS Code
    if type -q brew
        # Mac
        brew install --cask visual-studio-code
    else
        # Linux
        mkdir -p ~/Packages/.bin
        rm -rf ~/Packages/vscode-linux-x64 ~/Packages/vscode-linux-x64.tar
        brotli -d $DIR"/configs/code/vscode-linux-x64.tar.br"
        tar -xf $DIR"/configs/code/vscode-linux-x64.tar" -C ~/Packages
        rm -rf $DIR"/configs/code/vscode-linux-x64.tar"
        rm ~/Packages/.bin/code
        ln -s ~/Packages/vscode-linux-x64/.bin/code ~/Packages/.bin/code

        begin
            # Manually add VS Code to menu
            set -l IFS
            set -l CODEENTRY (cat $DIR"/configs/code/code_code.desktop")
            set -l CODEENTRY (string join $HOME (string split '$HOME' $CODEENTRY))
            mkdir -p ~/.local/share/applications
            rm -rf ~/.local/share/applications/code_code.desktop
            echo $CODEENTRY >~/.local/share/applications/code_code.desktop
        end
    end

    if type -q xdg-mime
        # set default program for plaintext to be code
        xdg-mime default code.desktop text/plain
    end

    if type -q sysctl
        if test -d /etc/sysctl.d
            # ensure file watchers limit is increased
            set PREV /etc/sysctl.d/*-max_user_watches.conf
            if count $PREV >/dev/null
                set COUNT (count $PREV)
                set LASTCFGFILE (echo $PREV[$COUNT])
                echo fs.inotify.max_user_watches=524288 | sudo tee $LASTCFGFILE
                sudo sysctl --system
            else
                echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system
            end
        end
    end
end

rm -rf ~/.vscode

set VSCODE_EXTENSIONS (cat $DIR"/configs/code/extensions.txt")
for VSCODE_EXTENSION in $VSCODE_EXTENSIONS
    echo "code --install-extension "$VSCODE_EXTENSION | fish
end

switch (uname)
    case Linux
        set VSCODE_CONFIG $HOME"/.config/Code"
    case Darwin
        set VSCODE_CONFIG $HOME"/Library/Application Support/Code"
    case '*'
        exit 1
end

mkdir -p $VSCODE_CONFIG
rm -rf $VSCODE_CONFIG"/User"
cp -r $DIR"/configs/code/User" $VSCODE_CONFIG"/User"
