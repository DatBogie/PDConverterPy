@echo off
SET SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%
SET SCRIPT_DIR_UP=%SCRIPT_DIR%\\..

:: venv
IF NOT EXIST ..\\.venv\\Scripts\\activate.bat (
    call .\\mk-venv.bat
)
call ..\\.venv\\Scripts\\activate.bat

:: build
pyinstaller %SCRIPT_DIR_UP%\\main.py -n "PDConverter" -w --onefile --noconfirm

:: install / create shortcuts
mkdir %LOCALAPPDATA%\\PDConverter
xcopy ".\\dist\\PDConverter.exe" "%LOCALAPPDATA%\\PDConverter"
.\\mk-shortcuts.vbs
