set -l DIR (dirname (realpath (status --current-filename)))

# Ensure .config exists
mkdir -p ~/.config

# Replace fish config with version controlled one
rm -rf ~/.config/fish
cp -r $DIR"/configs/fish" ~/.config/fish

# Change default shell to fish
if test $FIRSTRUN = "true"
    chsh -s (which fish)
end

# Install alacritty
# Note: alacritty is intentionally reinstalled with updates every sync
cross_install alacritty

# Copy alacritty config file
rm -rf ~/.alacritty.yml
rm -rf ~/.config/alacritty
cp -r $DIR"/configs/alacritty" ~/.config/alacritty

source ~/.config/fish/config.fish
