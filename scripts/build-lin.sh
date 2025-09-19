#!/bin/sh
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

# venv
if [ ! -f "../.venv/bin/activate" ]; then
    "./mk-venv.sh"
fi
source "../.venv/bin/activate"

# build
pyinstaller ../main.py -n "PDConverter" --onefile --noconfirm

# make .local/share folder
mkdir -p ~/.local/share/PDConverter

# copy files
cp -f "./dist/PDConverter" ~/.local/share/PDConverter/PDConverter
echo "Copied resources to ~/.local/share/PDConverter"

# write .dekstop main
echo """[Desktop Entry]
Type=Application
Name=PDConverter
Exec=/home/$USER/.local/share/PDConverter/PDConverter
Comment=Convert ADOFAI Levels Into Planets Dance Levels
Categories=Utility;
Terminal=false""" > ~/.local/share/applications/PDConverter.desktop

echo "Installed 'PDConverter' .desktop file to ~/.local/share/applications"