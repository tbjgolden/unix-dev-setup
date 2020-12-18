set -l DIR (dirname (realpath (status --current-filename)))

if test $FIRSTRUN = "true"
    # could transcribe below function to fish and remove the sudo calls
    curl https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash
end

switch (uname)
  case "Linux"
    set FONTS_DIR ~/.fonts
  case "Darwin"
    set FONTS_DIR ~/Library/Fonts
end

mkdir -p $FONTS_DIR
cp -f $DIR/configs/*.ttf $FONTS_DIR

switch (uname)
  case "Linux"
    sudo fc-cache -f -v
  case "Darwin"
    sudo atsutil databases -remove
    atsutil server -shutdown
    atsutil server -ping
end
