# Vitirover Academic Robot

🌿 The Vitirover Academic empowers students and researchers to operate a robot designed for complex outdoor environments, boasting exceptional energy management and a patented, uniquely engineered movement system. We provide detailed motion equations for an in-depth understanding.
    
![The Vitirover robot posing in a factory](/img/in_factory.webp "Vitirover robbot in factory")



## 🕹️ Control Options:

 - __Web Interface__: Intuitively control the robot through our [user-friendly web platform](https://cloud.vitirover.eu).
 - __Remote Scripting__: Use Scratch-like interface to program and execute remote scripts.
 - __Advanced Mode__: For the tech-savvy, dive into __Python__ coding or __ROS__ for granular control.


## 🔧 What's inside

 - Standard Vitirover Robot
 
 - Charger
 
 - Alimentation card to add you own electronics, detectors or motors. More information [here](./power_card/).

 - Jetson Nano : to operate the robot directly with your code. You could use any board (raspberry, etc.), but documentation will be provided for Jetson 

## 📡 API Features

Protobuf Technology: Utilizes Google's Protobuf for standardized, cross-language communication protocol encoding and decoding.

Data Frames:
 - __Telemetry Data__: Broadcasted by the robot at 10Hz, includes GPS, rear axle angle, motors status, and more.
 
 - __Control Commands__: Send direct instructions for individual motor control.

You can keep the two cameras connected to our electronics, or connect them to your board if you want to use Vision in you application.

The trame definitions with all fields are [here](protobuf/telemetry.proto)



# Getting started

## With the standard Vitirover web interface

 - Get a Vitirover robot through us or our distributors

 - Get a [Vitirover Cloud account](https://cloud.vitirover.eu) connected to this robot by first creating you account and contacting us to add the robot to your account

 - Push the Vitirover On/Off button at the back upward

 - Wait for the robot to connect. Its icon will turn yellow 🟡

 - In your robot page (click its name on the menu), you should be able to move the robot using the controller 🎮 icon on the map

  - You can activate the robot live view from its camera using the camera icon on the map 👁️ (only if cameras are connected to the main board)

 - In the Scripts section, try out Scratch-like scripts. Use Control blocks to move the robot. Experiment, but ensure the robot is on the ground to prevent falls.⚠️

 - Please consult the Vitirover help section in our cloud for using the standard robot functions ❓

## With the Jetson Nano included in the Academic robot

### Using SSH and a local network

The **VitiroverAP_[name of your robot]** network is intended for private use since it is emitted by our non-academic motherboard.

Starting at this commit, we include a **vitirover-wifi-manager** systemd service to help you getting remote access without the need to open the robot each time (see "direct access" section). When a wifi configuration is set up, it will be active even after a reboot.
The Jetson Nano, with the Wifi card we added, only supports one wifi connection at the time. But to be able to use this connection confortably, you will need to have an SSH connection and an internet access on the Jetson Nano simultaneously.
In order to accomplish this, the solution is to connect the Jetson Nano directly to your local wifi network, and get SSH access from your computer thought your local wifi network.

#### If vitirover-wifi-manager is installed (robots produced since this commit)

The "vitirover-wifi-manager" emits a hotspot network, **Vitirover-SSH**. Thought this network, you will configure the **local network** you want to use. Once this is done, you apply this configuration, SSH will cut, and you will be able to access SSH again thought your local-network.

- Start the robot and the Jetson Nano
- Connect to the **Vitirover-SSH** network. Password is **vitirover**
- use putty (on windows) or ssh on "vitirover@10.42.0.1" (port 22).
- cd ~/Desktop/academic_robot/
- sudo ./wifi_config_tools config
- follow instructions to configure your local wifi network to connect to (using a static ip address)
- reboot, the robot should be connected to your local wifi network using the IP adress you provided
- connect to the robot thought you local network with SSH (user and password are vitirover, port 22). Now you should have both a working SSH connection, AND access to internet (ping 8.8.8.8 to check)
- see python examples or ros repository (or installation folder where there are some examples) to begin

#### If vitirover-wifi-manager is not installed yet
You will have to use get direct access to the jetson nano (see next section), then : 
 - cd ~/Desktop/academic_robot/
 - git pull (or "git switch wifi-manager" if not merged yet)
 - cd vitirover-wifi-manager
 - chmod +x wifi_config_tools
 - chmod +x vitirover-wifi-manager
 - sudo ./wifi_config_tools install
 - sudo ./wifi_config_tools config
 - follow instructions to configure your local wifi network to connect to (using a static ip address)
 - reboot, the robot should be connected to your local wifi network
 - connect to the robot thought you local network with SSH (user and password are vitirover, port 22). Now you should have both SSH connection, AND access to internet (ping 8.8.8.8 to check)
- see python examples or ros repository to begin

### Direct access to the Jetson nano

If you struggle with the setup of the SSH connection and remote access, you can always connect directly on the jetson nano by : 
 - removing the ten screws with a M5 Allen Key (found on bike repair kits for example). Pay attention to not pull cables (GNSS antenna and power cable). It is practical to keep the upper hull on top, but turn it to access the Jetson Nano.
 - checking that the robot is on (button is up) and leds on the Jetson Nano are on
 - Connecting a computer screen via a Jetson HDMI port
 - Connecting a USB mouse, a keyboard to the Jetson
 - Log in : The default user and password is __vitirover__.****
 - This repository, and the [ROS repository](https://github.com/vitirover/vitirover_ws) are already present. If they are not up to date, you can do a **git pull** on them. 
 - In order to start, you can for example test python example scripts in examples, or head directly into the[ROS repository](https://github.com/vitirover/vitirover_ws)

### Network Schema
**Coming soon**


# Python example scripts

In order to control the robot directly from you code, you will need the Jetson Nano connected throught an USB/Ethernet adapter to our electronics JST ports.


See [the python basic example](/examples/basic-python-protobuf.py)


# Getting started: Jetson Nano

In the academic package you have a Jetson nano included. A Linux OS as well as some examples to use the robot are already pre-installed. 
If you want more informations on how to install your own setup you can refer to : [Nvidia](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#intro)

The password by default is "vitirover". Once you are logged in you can open Visual Studio Code (exactly : code-oss, the full open-source version) and navigate to academic_robot/examples. 


# How to use the Jetson nano remotely
## On Linux

In your package you can find a fake HDMI. This dongle allows you to visualize your Jetson Nano from your PC through the wifi card (that we added to the standard Jetson Nano). 

First, connect the Jetson Nano to your wifi. 

Install tightvnc on your PC (do it once only):
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

We would be glad to hear from you, you contact us via issues for any questions about this repo.

This repository is constently evolving with new updates and more examples. Feel free to contribute to our community on the academic robot !
