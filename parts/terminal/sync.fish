set -l DIR (dirname (realpath (status --current-filename)))

# Assume FIRSTRUN=true for install
echo ">" $FIRSTRUN

# Ensure .config exists
mkdir -p ~/.config

# Replace fish config with version controlled one
rm -rf ~/.config/fish
cp -r $DIR"/configs/fish" ~/.config/fish

# Install alacritty
cross_install alacritty

# Copy alacritty config file
rm -rf ~/.alacritty.yml
rm -rf ~/.config/alacritty
cp -r $DIR"/configs/alacritty" ~/.config/alacritty

