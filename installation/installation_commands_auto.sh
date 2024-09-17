#!/bin/bash

# wget -O installation_commands.sh https://raw.githubusercontent.com/vitirover/academic_robot/main/installation/installation_commands_auto.sh && chmod +x installation_commands_auto.sh && ./installation_commands_auto.sh
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

# Install prerequisites for VS Code
echo "Installing prerequisites for VS Code..."
sudo apt-get install -y software-properties-common apt-transport-https wget

# Download the official VS Code for ARM64
echo "Downloading VS Code for ARM64..."
wget -O ~/Downloads/code_arm64.deb "https://update.code.visualstudio.com/latest/linux-deb-arm64/stable"

# Install VS Code
echo "Installing VS Code..."
sudo dpkg -i ~/Downloads/code_arm64.deb || true
sudo apt-get install -f -y

# Remove any problematic repositories (if they exist)
echo "Removing invalid repositories..."
sudo rm -f /etc/apt/sources.list.d/headmelted_codebuilds.list
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

# Build catkin workspace
echo "Building catkin workspace..."
cd ~/Desktop/academic_robot
catkin_make

# Return to home directory
cd ~

echo "Installation completed successfully."
