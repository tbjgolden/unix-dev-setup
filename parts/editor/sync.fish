set -l DIR (dirname (realpath (status --current-filename)))

# Assume FIRSTRUN=true for install
echo ">" $FIRSTRUN

cross_install vim
cross_install brotli

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
    ln -s ~/Packages/vscode-linux-x64/code ~/Packages/.bin/code

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
