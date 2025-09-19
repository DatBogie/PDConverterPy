#!/bin/sh
# To be placed in the .zip release alongside PDConverterTrayIcon.png
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

mkdir -p ~/.local/share/PDConverter

mv -f ./PDConverter ~/.local/share/PDConverter/PDConverter
echo "Moved files"

# write .dekstop main
echo """[Desktop Entry]
Type=Application
Name=PDConverter
Icon=/home/$USER/.local/share/PDConverter/icon.png
Exec=/home/$USER/.local/share/PDConverter/PDConverter
Comment=Convert ADOFAI Levels Into Planets Dance Levels
Categories=Utility;
Terminal=false""" > ~/.local/share/applications/PDConverter.desktop

echo "Installed 'PDConverter' .desktop file to ~/.local/share/applications"
