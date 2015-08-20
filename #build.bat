@echo off

cd /d "%~dp0"

echo.
echo ----- load config
call config.bat
if exist config.user.bat call config.user.bat


echo.
echo ----- create vm disk
if not exist template mkdir template
if exist template\%VM_DISK% del template\%VM_DISK%
%QEMU_IMG_EXE% create -f vmdk template\%VM_DISK% %VM_DISK_SIZE%


echo.
echo ----- copy vmx
powershell -ExecutionPolicy RemoteSigned -File "lib/replace-vmx.ps1" %VM_VMX% template\%VM_VMX%


echo.
echo ----- run vmx
start /b "" "template\%VM_VMX%"


Call server.bat

echo.
echo.
pause
