#!/bin/sh
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

# venv
if [ ! -f "../.venv/bin/activate" ]; then
    "./mk-venv.sh"
fi
source "../.venv/bin/activate"

# build config
pyinstaller ../ui.py -n "PDConverter" -w --noconfirm

rm -rf "./dist/PDConverter"

cp -rf "./dist/PDConverter.app" ~/Applications

echo "Built 'PDConverter.app' to ~/Applications/PDConverter.app"