#!/bin/bash
# All stdout here is redirected to /dev/null, but leave stderr alone!
set -e  # Any error will cause the script to fail

echo "Cloning submodules..."
git submodule update --init > /dev/null

echo "Building Subsystems..."
cd Subsystems/src
make >/dev/null
cd ../..

echo "Compiling the Subsystems program. This could take about 1 minute..."
cd Subsystems
dart pub get --offline > /dev/null
dart compile exe bin/subsystems.dart -o ~/subsystems.exe > /dev/null
cd ..

echo "Installing configuration files..."
sudo cp ./11-subsystems.rules /etc/udev/rules.d
sudo cp ./subsystems.service /etc/systemd/system
sudo systemctl enable subsystems > /dev/null
sudo systemctl start subsystems > /dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger

echo ""
echo "Done! Here's what just happened"
echo "- SocketCan and libserialport were built and installed as dynamic libraries"
echo "- The subsystems program was compiled to ~/subsystems.exe"
echo "- udev will auto-detect the IMU and GPS when plugged in"
echo "- systemd will auto-start the subsystems program on boot"
