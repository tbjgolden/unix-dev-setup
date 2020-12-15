function cross_install
    if type -q pacman
        sudo pacman -Syu --noconfirm $argv
    else if type -q brew
        brew install $argv
    else
        echo "neither"
    end
end
