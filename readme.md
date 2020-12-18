# unix-dev-setup

A series of scripts to set up a Unix computer with all that I\* need to get going.

> \* by its very nature, it is tailored to my own preferences, but the actual structure and framework
> is designed to be forked and recycled.

## Design

### Core aims for this script

> (plus what could be normally achieved with dotfiles)

- not a one-and-done script, but a living creature that could be updated and have those changes propagated to other devices
- that native installs (i.e. no snaps, flatpaks, containers) were used instead of sandboxed apps
- not committed to any particular architecture, desktop environment, or Linux distribution
- electron apps are not installed in this script (besides VS Code, which is basically essential)
- asdf version manager is used to install development tools

### Technical decisions

- Assume `fish` as the first-contact shell
  - Originally, I used `oh-my-zsh` in my last setup script. After oh-my-zsh runs, it throws the user into a new zsh shell, preventing the remaining commands from progressing. After I heard that `fish` includes most of the things I used oh-my-zsh for, I gave it a try and quickly discovered that it's plenty ahead of `zsh` and `bash` - albeit not fully POSIX-compliant.
- Limited-assumptions about environment - commands that aren't ubiquitous are explicitly installed in the script
  - Exceptions: `bash`, `git`, `curl`, cli package manager (`brew`)
- Written entirely in `fish` shell scripts
  - My first version of this worked by installing node, then using node to install everything else through the `child_process` module. This wasn't entirely unsuccessful, but translating it to `fish` made things easier and shorter. It also meant that node didn't have to be uninstalled afterwards to install node through asdf.
- The script is a living one, and as such needs state. It keeps it's state as a non-version controlled JSON file `<project root>/.state.json` which is mutated by `jq` and uses subtree hashes to track what needs to be synced.

### What's inside?

- [x] Installs shell functions and utilities
- [x] Installs browser (firefox) and sets it up
- [x] Installs asdf-vm; then installs node, yarn, rust, python with it
- [x] Installs custom fonts
- [x] Clones down my repos
- [ ] Sets up my credentials and password manager (securely, of course)

---

## Step 1 - Install package manager plus git

### (Mac only) Install homebrew:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> Note: Git is installed with homebrew

### (Linux only) Install git:

```sh
# Manjaro
sudo pacman -Syu git
```

## Step 2 - Install fish via package manager

```sh
# MacOS
brew install fish
# Manjaro
sudo pacman -Syu fish
```

## Step 3 - Downloads and starts the install script

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/tbjgolden/unix-dev-setup/main/install.sh | fish
```
