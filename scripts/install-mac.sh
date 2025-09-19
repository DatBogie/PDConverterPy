#!/bin/sh
# To be placed in the .zip release.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

if [ -f ~/Applications/PDConverter.app ]; then
    rm -rf ~/Applications/PDConverter.app
fi
mv -f "./PDConverter.app" ~/Applications/PDConverter.app
echo "Moved 'PDConverter.app' to ~/Applications/PDConverter.app"
