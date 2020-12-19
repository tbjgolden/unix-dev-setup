set -l DIR (dirname (realpath (status --current-filename)))

if test $FIRSTRUN = "true"
    # close open firefox
    killall firefox
    sleep 1

    # clean out previous install of firefox, if it exists
    if type -q brew
        brew uninstall --cask --force --zap firefox
    else if type -q pacman
        sudo pacman -R --noconfirm firefox
        sudo pacman -R --noconfirm manjaro-browser-settings
    end

    # find firefox config directory
    switch (uname)
        case Linux
            set FIREFOX_CONFIG $HOME"/.mozilla/firefox"
        case Darwin
            set FIREFOX_CONFIG $HOME"/Library/Application Support/Firefox"
        case '*'
            exit 1
    end

    rm -rf $FIREFOX_CONFIG

    # install it
    cross_install firefox

    # open firefox to generate the default config
    firefox &>/dev/null &

    # and close it again after configs have been generated
    if not test -f $FIREFOX_CONFIG/$ACTIVE_PROFILE/places.sqlite
        sleep 1
    end
    sleep 1

    killall firefox

    # find the active profile
    set PROFILES (cat $FIREFOX_CONFIG/profiles.ini)
    for PROFILE in $PROFILES
        if test (string sub -s 1 -l 8 $PROFILE) = 'Default='
            set ACTIVE_PROFILE (string sub -s 9 $PROFILE)
            break
        end
    end

    if test -d $FIREFOX_CONFIG/$ACTIVE_PROFILE
        # Remove default firefox bookmarks
        sqlite3 $FIREFOX_CONFIG/$ACTIVE_PROFILE/places.sqlite 'delete from moz_bookmarks where guid not like "%\_" escape "\";'
        echo "Deleted default bookmarks"

        # Add preferred layout and configuration
        cp -rf $DIR/configs/firefox/prefs.js $FIREFOX_CONFIG/$ACTIVE_PROFILE/prefs.js
        echo "Installed preferred layout and configuration"
    end
end
