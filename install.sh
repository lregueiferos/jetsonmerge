set -e
sudo apt update
sudo apt upgrade -y
git submodule update --init
cd SubsystemsPi
bash install.sh
cd .. 
cd SecondaryPi
bash install.sh
echo "Installation is Complete"
sudo shutdown -r now