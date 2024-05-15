## Power Board Overview 🌐

The power board features four terminal blocks, each providing a different maximum output voltage and current. Here are the specifications and maximum power calculations for each:

- **12V, 2A**  
  Maximum Power: `24W`
- **5V, 2A**  
  Maximum Power: `10W`
- **5V, 4A** (dedicated for powering the Jetson Nano)  
  Maximum Power: `20W`
- **Battery Voltage (24V nominal), 6A**  
  Maximum Power: `144W`

Additionally, links to the EAGLE files for the power board are provided. These files include all necessary schematics and board designs in EAGLE format, ideal for modification or further development.

[![Power Card](../img/power_card_photo.jpg)](../img/power_card_photo.jpg)

### Safety Warning ⚠️

**Current Limitation:** The total current consumption across all systems connected to the board must not exceed 6A. Exceeding this limit will trigger a protective fuse, rendering the power board unusable.

**Connection Precautions:** It is crucial to follow the markings on the PCB. Ensure that the positive and negative terminals (GND) are not reversed when connecting any system to the terminal blocks.

