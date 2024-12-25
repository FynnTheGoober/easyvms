# EasyVMs
Easily create a QEMU VM on Windows with minimal manual setup and without admin privileges

## Requirements
- Windows 8 64x Or Newer
- At least 4 GB RAM
- Around 40 GB Storage (Assuming default storage option and Ubuntu 24.04)
- A working internet connection

## This sounds great, where do I start?
Just download the main batch file [Here!](https://github.com/TMC4345/easyvms/blob/main/EasyVMs.bat) :3

### But wait, this doesn't use any acceleration?
This project does infact not use any hardware acceleration, but this is because of VM Acceleration needing kernel module access (Which requires admin), and acceleration didn't work on my machine. However, that might be due to me having an AMD CPU. If you want to try acceleration, feel free to replace `--accel tcg` with `--accel whpx` in the batch files.

# KEEP IN MIND THAT THIS IS NOT MEANT FOR ACTUAL USE!!!
I do not recommend using this to run anything graphical, anything in the default OSList is tested and confirmed by yours truly (me) that it will be somewhat usable. (ONLY WHEN USING IT WITH ONLY THE CLI!!!)
