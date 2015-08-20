@echo off
cd /d "%~dp0"

echo.
echo ----- load config
call config.bat
if exist config.user.bat call config.user.bat


echo.
echo ----- Preprocess install script.
powershell -ExecutionPolicy RemoteSigned -File "lib/preprocess.ps1" "install.sh" "template/install.sh"


echo.
echo ----- Please type below.
type install-message.txt


echo.
echo ----- run server
powershell -ExecutionPolicy RemoteSigned -File "lib/server.ps1" "template/install.sh"
pause
