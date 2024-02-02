# Vitirover Academic Robot

🌿 The Vitirover Academic empowers students and researchers to operate a robot designed for complex outdoor environments, boasting exceptional energy management and a patented, uniquely engineered movement system. We provide detailed motion equations for an in-depth understanding.
    
![The Vitirover robot posing in a factory](/img/in_factory.webp "Vitirover robbot in factory")



## 🕹️ Control Options:

 - __Web Interface__: Intuitively control the robot through our [user-friendly web platform](https://cloud.vitirover.eu).
 - __Remote Scripting__: Use Scratch-like interface to program and execute remote scripts.
 - Advanced Mode: For the tech-savvy, dive into __Python__ coding or __ROS__ for granular control.


## 🔧 What's inside

 - Standard Vitirover Robot
 
 - Charger
 
 - Alimentation card to add you own electronics, detectors or motors

 - Jetson Nano : to operate the robot directly with your code. You could use any board (raspberry, etc.), but documentation will be provided for Jetson 

## 📡 API Features

Protobuf Technology: Utilizes Google's Protobuf for standardized, cross-language communication protocol encoding and decoding.

Data Frames:
 - __Telemetry Data__: Broadcasted by the robot at 10Hz, includes GPS, rear axle angle, motors status, and more.
 
 - __Control Commands__: Send direct instructions for individual motor control.

You can keep the two cameras connected to our electronis, or connect them to your board if you want to use Vision in you application.

The trames definition with all fields is [here](protobuf/telemetry.proto)



# Getting started

 - Get a Vitirover robot through us or our distributors

 - Get a [Vitirover Cloud account](https://cloud.vitirover.eu) connected to this robot by first creating you account and contacting us to add the robot to your account

 - Push the Vitirover On/Off button at the back upward

 - Wait for the robot to connect. Its icon will turn yellow 🟡

 - In your robot page (click its name on the menu), you should be able to move the robot using the controller 🎮 icon on the map

  - You can activate the robot live view from its camera using the camera icon on the map 👁️ 

 - In the Scripts section, try out Scratch-like scripts. Use Control blocks to move the robot. Experiment, but ensure the robot is on the ground to prevent falls.⚠️

 - Please consult the Vitirover help section for using the standard robot functions ❓


# Python example scripts

In order to control the robot directly from you code, you will need the Jetson Nano connected throught an USB/Ethernet adapter to our electronics JST ports.


See [the python basic example](/examples/basic-python-protobuf.py)


# Getting started: Jetson Nano

In the academic package you have a Jetson nano included. A Linux OS as well as some examples to use the robot are already pre-installed. 
If you want more informations on how to install your own setup you can refer to : [Nvidia](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#intro)

The password by default is "vitirover". Once you are logged in you can open Virtual Studio an navigate to academic_robot/examples. 

# Getting started: ROS 

ROS integration is currently only available for ROS1.
Controls are sent to the robot the /cmd_vel topic to the robot thought our protobuf API.

We share the URDF and Gazebo integration to control the robot.

 [Readme Robot Model](model/README.md)

 [Readme ROS](ROS/README.md)

To start controlling the robot using ROS, navigate to academic/examples modify the address of the robot according to your network in sock.bind(("your.ip.address", 5005)).
Start command_ROS.py using the following commands:

```
cd academic/examples
python command_ROS.py
```

In an other terminal:
```
roscore
```

In an other terminal:

```
rosrun teleop_twist_keyboard teleop_keyboard.py
```

# Getting started: Gazebo (WIP)

To start the simulation on your PC with ROS noetic:

```
git clone vitirover_ws
```
Open a terminal and type

```
cd vitirover_ws
source devel/setup.bash
roslaunch mobile_robot gazebo_sim.launch
```

The simulation starts. You can try sending velocity command to the right rear wheel in an other terminal with:

```
rostopic pub  -1 /vitirover/right_rear_wheel_velocity_controller/command std_msgs/Float64 "data: 1.0"
```

# How to use the Jetson nano remotely
## On Linux

In your package you can find a fake HDMI. This dongle allows you to command your Jetson Nano from your PC through the wifi. 

First, install tightvnc on your PC (do it once only):
```
sudo apt install xtightvncviewer
```

Then start the server (modify your.ip.address with your IP address):

```
xtightvncserver your.ip.address
```
or 
```
/usr/bin/xtightvncserver your.ip.address
```

Connect to the jetson nano:
```
xtightvncviewer your.ip.address -compresslevel 9 -quality 4
```

Type your password, and you are logged into the Jetson Nano ;)

## Counter EMF to measure motor's rpm

The agricultural standards require high robustness due to operation in chaotic terrain. To measure the RPM of the wheels, we have utilized Back Electromotive Force (BEMF), which provides accurate RPM measurements suitable for outdoor environments. For academic purposes, an encoder kit is available, offering even more precise RPM measurements. For more information about the encoder kit, please visit [encoder kit](/encoder_kit).

# Contributing

We would be glade to hear from you, you contact us via e-mail or issues for any questions about this repo.

This repository is constently evolving with new updates and more examples. Feel free to contribute to our community on the academic robot !
