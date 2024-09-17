#!/bin/bash

# wget -O installation_commands_auto.sh https://raw.githubusercontent.com/vitirover/academic_robot/main/installation/installation_commands_auto.sh && chmod +x installation_commands_auto.sh && ./installation_commands_auto.sh
set -e

# Ensure the script is not run as root
if [ "$EUID" -eq 0 ]; then
  echo "Please do not run this script as root or with sudo."
  exit 1
fi

# Install Python 3 (Jetson Nano has 2.7 by default)
echo "Updating package lists..."
sudo apt-get update -y

echo "Installing Python 3 and pip..."
sudo apt-get install -y python3-pip

# Install prerequisites for Code-OSS
echo "Installing prerequisites for Code-OSS..."
sudo apt-get install -y software-properties-common apt-transport-https wget

# Dowmload vs code for arm64 at https://github.com/headmelted/codebuilds/releases
# a problem in libc (used in jetson nano) does not allow us to install the official vscode
echo "Downloading Code-OSS for ARM64..."
wget -O ~/Downloads/code-oss_1.44.0-1585531075_arm64.deb https://github.com/headmelted/codebuilds/releases/download/30-Mar-20/code-oss_1.44.0-1585531075_arm64.deb
# Install VS Code
echo "Installing Code-OSS"
sudo dpkg -i ~/Downloads/code-oss_1.44.0-1585531075_arm64.deb || true
sudo apt-get install -f -y

# one wrong repo installed for code-oss makes sudo apt-get update fail, so we fix it first
# Remove any problematic repositories (if they exist)
echo "Removing invalid repositories installed for code oss..."
sudo rm -f /etc/apt/sources.list.d/headmelted_vscode.list
sudo apt-get update -y

# Install ROS
echo "Adding ROS repository..."
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

echo "Adding ROS keys..."
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 'C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'

echo "Updating package lists..."
sudo apt-get update -y

echo "Installing ROS Melodic desktop full..."
sudo apt-get install -y ros-melodic-desktop-full

# Add Environment Variables and Install ROS Dependencies
echo "Adding ROS environment variables to .bashrc..."
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "Installing ROS dependencies..."
sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential

# Initialize rosdep
echo "Installing rosdep..."
sudo apt-get install -y python-rosdep

echo "Initializing rosdep..."
sudo rosdep init || true
rosdep update

# Install teleop-twist-keyboard
echo "Installing teleop-twist-keyboard..."
sudo apt-get install -y ros-melodic-teleop-twist-keyboard

# Add Environment Variables and Install ROS Dependencies
echo "Reexecuting bashrc now that install is complete"
source ~/.bashrc

# Change the default wallpaper
echo "Changing the default wallpaper..."
mkdir -p ~/Images
wget -O ~/Images/in_factory.webp "https://raw.githubusercontent.com/vitirover/academic_robot/main/img/in_factory.webp"

echo "Installing webp tools..."
sudo apt-get install -y webp

echo "Converting wallpaper to JPG..."
dwebp ~/Images/in_factory.webp -o ~/Images/in_factory.jpg

echo "Setting new wallpaper..."
dconf write /org/gnome/desktop/background/picture-uri "'file:///home/$USER/Images/in_factory.jpg'"
dconf write /org/gnome/desktop/background/picture-options "'scaled'"
dconf write /org/gnome/desktop/background/primary-color "'#FFFFFF'"

# Clone repositories
echo "Cloning academic_robot repository..."
mkdir -p ~/Desktop
git clone https://github.com/vitirover/academic_robot.git ~/Desktop/academic_robot

echo "Cloning vitirover_ws repository..."
git clone https://github.com/vitirover/vitirover_ws.git ~/Desktop/vitirover_ws

# Copy README to Desktop
echo "Copying README to Desktop..."
cp ~/Desktop/academic_robot/README.md ~/Desktop/README_vitirover.md

# Install protobuf and rospkg
echo "Installing protobuf..."
pip3 install --user protobuf==3.19.6

echo "Installing rospkg..."
pip3 install --user rospkg

# Add Environment Variables and Install ROS Dependencies
echo "Reexecuting bashrc once again now that install is complete"
source ~/.bashrc

# Build catkin workspace
echo "Building catkin workspace..."
cd ~/Desktop/vitirover_ws
catkin_make

# Return to home directory
cd ~

# adding code-oss icon to the dock
sudo cp /usr/share/code-oss/resources/app/resources/linux/code.png /usr/share/pixmaps/code-oss.png
gsettings set com.canonical.Unity.Launcher favorites "$(gsettings get com.canonical.Unity.Launcher favorites | sed -e "s/]/, 'code-oss.desktop']/")"

echo "Installation completed successfully."
