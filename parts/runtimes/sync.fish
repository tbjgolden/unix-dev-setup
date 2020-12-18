set -l DIR (dirname (realpath (status --current-filename)))

if test $FIRSTRUN = "true"
    rm -rf ~/.asdf
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
    mkdir -p ~/.config/fish/completions
    cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    resource

    asdf plugin add nodejs
    asdf plugin add yarn
    asdf plugin add python

    NODEJS_CHECK_SIGNATURES=no asdf install nodejs latest
    set NODE_VERSION (string trim (asdf list nodejs))

    asdf install yarn latest
    set YARN_VERSION (string trim (asdf list yarn))

    asdf install python latest
    set PYTHON_VERSION (string trim (asdf list python))

    asdf install rust latest
    set RUST_VERSION (string trim (asdf list rust))

    rm -rf ~/.tool-versions
    echo "nodejs $NODE_VERSION" > ~/.tool-versions
    echo "yarn $YARN_VERSION" >> ~/.tool-versions
    echo "python $PYTHON_VERSION" >> ~/.tool-versions
    echo "rust $RUST_VERSION" >> ~/.tool-versions

    cross_install octave
else
    asdf update
end
