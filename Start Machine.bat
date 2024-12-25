@echo off
title EasyVMs: Start VM

set "DEST_DIR=%cd%\resources\QEMU"
set "MACHINES_DIR=%cd%\machines"

if not exist "%MACHINES_DIR%" (
    echo Machines directory not found. Exiting...
    goto end
)

echo Available VMs:
setlocal enabledelayedexpansion
set /a index=1

for /d %%A in ("%MACHINES_DIR%\*") do (
    echo !index!. %%~nxA
    set /a index=!index!+1
)

set /p choice="Enter the number of the VM to boot: "

set /a count=0
for /d %%A in ("%MACHINES_DIR%\*") do (
    set /a count=!count!+1
    if !count! equ %choice% (
        set selected_vm=%%~nxA
    )
)

if not defined selected_vm (
    echo Invalid choice. Exiting...
    goto end
)

set "disk_image=%MACHINES_DIR%\%selected_vm%\%selected_vm%.qcow2"
if not exist "%disk_image%" (
    echo Disk image for %selected_vm% not found. Exiting...
    goto end
)

echo Starting %selected_vm%...
"%DEST_DIR%\qemu-system-x86_64.exe" -m 4096 -hda "%disk_image%" -boot c

:end
