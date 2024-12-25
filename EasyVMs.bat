@echo off
title EasyVMs

set "URL=https://tmc4345.xyz/files/Useful Software/QEMU Portable Windows/qemu.zip"
set "DEST_DIR=%cd%\resources\QEMU"
set "OS_LIST_URL=https://github.com/TMC4345/easyvms/raw/refs/heads/main/OSList.txt"
set "OS_LIST_FILE=%cd%\resources\OSList.txt"
set "ARIA2C_URL=https://tmc4345.xyz/files/Useful Software/aria2c.exe"
set "ARIA2C_EXE=%cd%\resources\aria2c.exe"
set "MACHINES_DIR=%cd%\machines"

if not exist "%cd%\resources" (
    mkdir "%cd%\resources"
)
if not exist "%MACHINES_DIR%" (
    mkdir "%MACHINES_DIR%"
)

if not exist "%ARIA2C_EXE%" (
    echo aria2c.exe not found. Downloading...
    powershell -Command "Invoke-WebRequest -Uri '%ARIA2C_URL%' -OutFile '%ARIA2C_EXE%'"
    if not exist "%ARIA2C_EXE%" (
        echo Failed to download aria2c.exe. Exiting...
        goto end
    )
    echo aria2c.exe downloaded successfully.
)

if exist "%DEST_DIR%\*" (
    echo QEMU is already unzipped. Skipping download and unzip.
) else (
    if not exist "%DEST_DIR%" (
        mkdir "%DEST_DIR%"
    )

    echo Downloading QEMU...
    "%ARIA2C_EXE%" -x 16 -s 16 -d "%cd%\resources" -o qemu.zip "%URL%"

    if exist "%cd%\resources\qemu.zip" (
        echo Download complete. Unzipping...

        powershell -Command "Expand-Archive -Path '%cd%\resources\qemu.zip' -DestinationPath '%DEST_DIR%'"

        echo Unzip complete.
        
        del "%cd%\resources\qemu.zip"
    ) else (
        echo Download failed. Please check the URL.
        goto end
    )
)

echo Downloading OS list...
powershell -Command "Invoke-WebRequest -Uri '%OS_LIST_URL%' -OutFile '%OS_LIST_FILE%'"

if not exist "%OS_LIST_FILE%" (
    echo Failed to download the OS list. Exiting...
    goto end
)

echo Available OSes:
setlocal enabledelayedexpansion
set /a index=1
for /f "tokens=1,* delims=," %%A in (%OS_LIST_FILE%) do (
    echo !index!. %%A
    set /a index=!index!+1
)

set /p choice="Enter the number of the OS you want to run: "

set /a count=0
for /f "tokens=1,* delims=," %%A in (%OS_LIST_FILE%) do (
    set /a count=!count!+1
    if !count! equ %choice% (
        set selected_os=%%A
        set selected_iso=%%B
    )
)

if defined selected_iso (
    echo Downloading ISO: %selected_iso%
    "%ARIA2C_EXE%" --allow-overwrite=true -x 16 -s 16 -d "%cd%\resources" -o "installer.iso" "%selected_iso%"
    echo ISO download complete.
) else (
    echo Invalid choice. No ISO downloaded.
)

set /p disk_size="Enter the disk size in GB (32): "
if not defined disk_size set disk_size=32

set QEMU_IMG="%DEST_DIR%\qemu-img.exe"

set "os_folder=%MACHINES_DIR%\%selected_os%"
if not exist "%os_folder%" (
    mkdir "%os_folder%"
)

set disk_name=%selected_os%.qcow2
echo Creating a %disk_size% GB QCOW2 disk for %selected_os%...
"%QEMU_IMG%" create "%os_folder%\%disk_name%" %disk_size%G
if exist "%os_folder%\%disk_name%" (
    echo QCOW2 disk %disk_name% created successfully in %os_folder%.
) else (
    echo Failed to create the disk image. Exiting...
    goto end
)

move /y "%cd%\resources\installer.iso" "%os_folder%\installer.iso"

echo Starting VM for %selected_os%...
"%DEST_DIR%\qemu-system-x86_64.exe" -m 2048 -hda "%os_folder%\%disk_name%" -cdrom "%os_folder%\installer.iso" -boot d --accel tcg

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/TMC4345/easyvms/raw/refs/heads/main/Start Machine.bat' -OutFile '%cd%\Start Machine.bat'"

:end
pause