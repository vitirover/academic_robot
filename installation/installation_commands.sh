# Install VScode:
sudo apt-get install python3-pip -y

sudo apt install software-properties-common apt-transport-https wget

# Dowmload vs code for arm64 at https://github.com/headmelted/codebuilds/releases

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

# Cloning this repository in /Desktop




