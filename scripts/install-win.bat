@echo off
:: to be placed in the zip release alongside mk-shortcuts.vbs
SET SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%

mkdir %LOCALAPPDATA%\\PDConverter
move ".\PDConverter.exe" "%LOCALAPPDATA%\PDConverter"
.\\mk-shortcuts.vbs