# Step 1 - Install package manager plus git

## (Mac only) Install homebrew:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> Note: Git is installed with homebrew

## (Linux only) Install git:

```sh
# Manjaro
sudo pacman -Syu git
```

# Step 2 - Install fish via package manager

```sh
# MacOS
brew install fish
# Manjaro
sudo pacman -Syu fish
```

# Step 3 - Downloads and starts the install script

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/tbjgolden/unix-dev-setup/main/install.sh | fish
```
