# Jetson Nano WiFi Hotspot Setup Guide

This guide will help you configure your Jetson Nano to automatically broadcast a WiFi network called "Vitirover Jetson Nano" that persists through reboots and allows SSH access.

## Prerequisites

- Jetson Nano with WiFi capability
- WiFi adapter/module installed and recognized by the system
- Root access to the device

## Installation

### 1. Install Required Packages

```bash
sudo apt update
sudo apt install hostapd dnsmasq
```

### 2. Configure Access Point (hostapd)

Create the hostapd configuration file:

```bash
sudo nano /etc/hostapd/hostapd.conf
```

Add the following content:

```
interface=wlan0
driver=nl80211
ssid=Vitirover Jetson Nano
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=YourPasswordHere
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

> **Note**: Replace `YourPasswordHere` with a secure password (minimum 8 characters)

### 3. Configure DHCP Server (dnsmasq)

Backup the original configuration:
```bash
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
```

Create new configuration:
```bash
sudo nano /etc/dnsmasq.conf
```

Add the following:
```
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
```

### 4. Configure Network Interface

#### For systems using netplan (Ubuntu 18.04+):

```bash
sudo nano /etc/netplan/01-network-manager-all.yaml
```

Add or modify:
```yaml
network:
  version: 2
  renderer: NetworkManager
  wifis:
    wlan0:
      access-points: {}
      addresses: [192.168.4.1/24]
```

#### For systems using dhcpcd:

```bash
sudo nano /etc/dhcpcd.conf
```

Add at the end:
```
interface wlan0
static ip_address=192.168.4.1/24
nohook wpa_supplicant
```

### 5. Configure Hostapd Daemon

Tell hostapd where to find its configuration:
```bash
sudo nano /etc/default/hostapd
```

Uncomment and modify:
```
DAEMON_CONF="/etc/hostapd/hostapd.conf"
```

### 6. Enable IP Forwarding

```bash
sudo nano /etc/sysctl.conf
```

Uncomment the following line:
```
net.ipv4.ip_forward=1
```

### 7. Configure Firewall (Optional)

If you want to share internet connection through ethernet:

```bash
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
```

Save the iptables rules:
```bash
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
```

### 8. Enable Services

```bash
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
```

### 9. Configure SSH Access

Ensure SSH is enabled and will start at boot:
```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

### 10. Create Startup Script

Create a script to ensure everything starts correctly:
```bash
sudo nano /etc/rc.local
```

Add the following before `exit 0`:
```bash
#!/bin/bash

# Restore iptables rules
if [ -f /etc/iptables.ipv4.nat ]; then
    iptables-restore < /etc/iptables.ipv4.nat
fi

# Ensure services are started
systemctl start hostapd
systemctl start dnsmasq

exit 0
```

Make the script executable:
```bash
sudo chmod +x /etc/rc.local
```

### 11. Reboot and Test

```bash
sudo reboot
```

## Usage

After reboot, you should see the "Vitirover Jetson Nano" network available for connection.

- **Network Name**: Vitirover Jetson Nano
- **Password**: The password you set in step 2
- **Jetson IP Address**: 192.168.4.1
- **DHCP Range**: 192.168.4.2 - 192.168.4.20

### SSH Access

Once connected to the WiFi network, you can SSH into the Jetson Nano:

```bash
ssh username@192.168.4.1
```

Replace `username` with your actual username on the Jetson Nano.

## Troubleshooting

### Common Issues

1. **WiFi network not appearing**: 
   - Check if hostapd service is running: `sudo systemctl status hostapd`
   - Verify WiFi interface name: `ip addr show`

2. **Cannot connect to network**:
   - Check dnsmasq service: `sudo systemctl status dnsmasq`
   - Verify configuration files for typos

3. **No internet access** (if internet sharing is desired):
   - Check iptables rules: `sudo iptables -L -n -v`
   - Verify IP forwarding: `cat /proc/sys/net/ipv4/ip_forward`

### Useful Commands

```bash
# Check service status
sudo systemctl status hostapd
sudo systemctl status dnsmasq

# View logs
sudo journalctl -u hostapd
sudo journalctl -u dnsmasq

# Restart services
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq

# Check connected clients
cat /var/lib/dhcp/dhcpd.leases
```

## Security Considerations

- Change the default password to a strong one
- Consider using MAC address filtering if needed
- Keep the system updated with security patches
- Monitor connected devices regularly

## License

This guide is provided as-is for educational purposes.
