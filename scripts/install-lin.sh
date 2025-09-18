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
Comment=Global Keyboard Shortcuts Service
Categories=Utility;
Terminal=false""" > ~/.local/share/applications/PDConverter.desktop

# write .dekstop config
echo """[Desktop Entry]
Type=Application
Name=PDConverter Config
Icon=/home/$USER/.local/share/PDConverter/icon.png
Exec=/home/$USER/.local/share/PDConverter/config
Comment=Graphical Global Keyboard Shortcuts Manager
Categories=Settings;DesktopSettings;Qt;
Terminal=false""" > ~/.local/share/applications/PDConverter\ Config.desktop

echo "Installed 'PDConverter' and 'PDConverter Config' .desktop files to ~/.local/share/applications"
