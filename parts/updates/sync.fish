set -l DIR (dirname (realpath (status --current-filename)))

# 0 4 * * * /usr/bin/fish -l -c 'cd $HOME/.setup/unix-dev-setup && git pull && /usr/bin/fish $HOME/.setup/unix-dev-setup/sync.fish'

