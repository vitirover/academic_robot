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

## With the standard Vitirover web interface

 - Get a Vitirover robot through us or our distributors

 - Get a [Vitirover Cloud account](https://cloud.vitirover.eu) connected to this robot by first creating you account and contacting us to add the robot to your account

 - Push the Vitirover On/Off button at the back upward

 - Wait for the robot to connect. Its icon will turn yellow 🟡

 - In your robot page (click its name on the menu), you should be able to move the robot using the controller 🎮 icon on the map

  - You can activate the robot live view from its camera using the camera icon on the map 👁️ 

 - In the Scripts section, try out Scratch-like scripts. Use Control blocks to move the robot. Experiment, but ensure the robot is on the ground to prevent falls.⚠️

 - Please consult the Vitirover help section for using the standard robot functions ❓

## With the Jetson Nano included in the Academic robot

### Using SSH and a local network

The **VitiroverAP_[name of your robot]** network is intended for private use since is emitted by our non-academic motherboard.

Starting at this commit, we include a **vitirover-wifi-manager** to help you getting remote access without the need to open the robot (see next section).
The Jetson Nano, with the Wifi card we added, only supports one wifi connection at the time. But to be able to use this connection confortably, you will need to have an SSH connection and an internet access on the Jetson Nano.
In order to accomplish this, the solution is to connect the Jetson Nano directly to your local wifi network, and get SSH access from your computer thought your local wifi network.

The "vitirover-wifi-manager" emits a hotspot network, **Vitirover-SSH**. Thought this network, you will configure the **local network** you want to use. Once this is done, you apply this configuration, SSH will cut, and you will be able to access SSH again thought your local-network.

Here are the steps

### Direct access to the Jetson nano

If you struggle with the setup of the SSH connection and remote access, you can always connect directly on the jetson nano by : 
 - removing the ten screws with a M5 Allen Key (found on bike repair kits for example). Pay attention to not pull cables (GNSS antenna and power cable). It is practical to keep the upper hull on top, but turn it to access the Jetson Nano.
 - checking that the robot is on (button is up) and leds on the Jetson Nano are on
 - Connecting a computer screen via a Jetson HDMI port
 - Connecting a USB mouse, a keyboard to the Jetson
 - Log in : The default user and password is __vitirover__.****
 - This repository, and the [ROS repository](https://github.com/vitirover/vitirover_ws) are already present. If they are not up to date, you can do a **git pull** on them. 
 - In order to start, you can for example test python example scripts in examples, or head directly into the[ROS repository](https://github.com/vitirover/vitirover_ws)

# Python example scripts

In order to control the robot directly from you code, you will need the Jetson Nano connected throught an USB/Ethernet adapter to our electronics JST ports.


See [the python basic example](/examples/basic-python-protobuf.py)


# ROS integration

ROS integration is currently only available for ROS1.
Telemetry and control are sent from standard topics to the robot thought our protobuf API.

We share URDF files, Gazebo integration and the mathematical model to control the robot

 [Readme Robot Model](model/README.md)

 [Readme ROS](ROS/README.md)

## No precise encoders 
The robot is currently sold __without standard encoders__ for its wheels (and mowers) due to the agricultural/industrial terrain it typically operates in. Odometry is ineffective in these conditions, leading to our decision to omit them. Instead, we use the back electromotive force generated by the motor, which provides an accurate enough approximation for wheel control. 

However, for academic purposes where precision is key, you might require more accuracy. To address this, we have developed an in-house [encoder kit](/encoder_kit) to add encoders to the robot. We can provide this kit if necessary for your application.


# Contributing

Please tell us via e-mail or issues if anything is missing from this repo or if you see any errors.

The goal of this repository is to progressively enrich it with more examples of successful robot integrations. If you choose to share your work on the academic robot with other users, we could offer you some Saint-Emilion wine to thank you !
