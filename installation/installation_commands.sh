# Install VScode:
sudo apt-get install python3-pip -y

sudo apt install software-properties-common apt-transport-https wget

# Dowmload vs code for arm64 at https://github.com/headmelted/codebuilds/releases
wget -O ~/Downloads/code-oss_1.44.0-1585531075_arm64.deb https://github.com/headmelted/codebuilds/releases/download/30-Mar-20/code-oss_1.44.0-1585531075_arm64.deb
cd ~/Downloads/
sudo dpkg -i code-oss_1.44.0-1585531075_arm64.deb 
sudo apt-get install -f
code-oss

# Install ros:
# Configure ROS Software Repository:
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install ROS Melodic:
sudo apt-get update

sudo apt install ros-melodic-desktop-full

# Add Environment Variables and Install ROS Dependencies:
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc #Add environment variables
source ~/.bashrc #Effective environment variables
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential #Install dependencies

# Initialize rosdep:
sudo apt install python-rosdep
sudo rosdep init
rosdep update

# Verify the ROS Environment:
roscore

# Changing the default wallpaper
# in "scaled" mode, in jpg (because webp is not supported), with background-color white
mkdir -p ~/Images && wget -O ~/Images/in_factory.webp https://raw.githubusercontent.com/vitirover/academic_robot/main/img/in_factory.webp && sudo apt-get install -y webp && dwebp ~/Images/in_factory.webp -o ~/Images/in_factory.jpg && dconf write /org/gnome/desktop/background/picture-uri "'file:///home/$USER/Images/in_factory.jpg'" && dconf write /org/gnome/desktop/background/picture-options "'scaled'" && dconf write /org/gnome/desktop/background/primary-color "'#FFFFFF'"

# Cloning this repository and ros repository in ~/Desktop
mkdir -p ~/Desktop && git clone https://github.com/vitirover/academic_robot.git ~/Desktop/academic_robot && git clone https://github.com/vitirover/vitirover_ws.git ~/Desktop/vitirover_ws

# Putting the readme of academic robot on the Desktop
cp ~/Desktop/academic_robot/README.md ~/Desktop/README_vitirover.md

# Installing protobuf, a version compatible with this Python, in order to have the basic-python-protobuf.py script working
pip3 install protobuf==3.19.6

# Installing pygame is not currently working, but this thread could help : 
# https://forums.developer.nvidia.com/t/install-pygame-on-jetson-nano/83731/5
