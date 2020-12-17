set -l DIR (dirname (realpath (status --current-filename)))

if test $FIRSTRUN = "true"
    cross_install firefox

    switch (uname)
        case Linux
            set FIREFOX_CONFIG $HOME"/.mozilla/firefox"
        case Darwin
            set FIREFOX_CONFIG $HOME"/Library/Application Support/Firefox"
        case '*'
            exit 1
    end

    # backup old profiles config file
    if not test -f $FIREFOX_CONFIG"/profiles.ini.bkup"
        if test -f $FIREFOX_CONFIG"/profiles.ini"
            cp $FIREFOX_CONFIG"/profiles.ini" $FIREFOX_CONFIG"/profiles.ini.bkup"
        end
    end

    # replace profiles config file
    rm -rf $FIREFOX_CONFIG"/profiles.ini"
    cp -r $DIR"/configs/firefox/profiles.ini" $FIREFOX_CONFIG"/profiles.ini"

    # decode and replace firefox profile
    rm -rf $FIREFOX_CONFIG"/spxqclgh.default-release"
    cp -r $DIR"/configs/firefox/spxqclgh.default-release.tar.br.gpg" $FIREFOX_CONFIG"/spxqclgh.default-release.tar.br.gpg"
    gpg --pinentry loopback -o $FIREFOX_CONFIG"/spxqclgh.default-release.tar.br" -d $FIREFOX_CONFIG"/spxqclgh.default-release.tar.br.gpg"
    brotli -d $FIREFOX_CONFIG"/spxqclgh.default-release.tar.br"
    tar -xf $FIREFOX_CONFIG"/spxqclgh.default-release.tar" -C $FIREFOX_CONFIG
    rm -rf $FIREFOX_CONFIG"/spxqclgh.default-release.tar.br.gpg" $FIREFOX_CONFIG"/spxqclgh.default-release.tar.br" $FIREFOX_CONFIG"/spxqclgh.default-release.tar"
end
