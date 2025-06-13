# Jetson Nano WiFi Hotspot Setup Guide

This guide will help you configure your Jetson Nano to automatically broadcast a WiFi network called "Vitirover Jetson Nano" that persists through reboots and allows SSH access.

## Prerequisites

- Jetson Nano with WiFi capability
- WiFi adapter/module installed and recognized by the system
- Root access to the device

### 1. Install Required Packages

```bash
sudo apt update
sudo apt install hostapd
```

> **Note**: NetworkManager has built-in DHCP functionality, so dnsmasq is not required.

### 2. Create the Hotspot Connection

Use NetworkManager's command-line tool to create the hotspot:

```bash
sudo nmcli con add type wifi ifname wlan0 con-name "Vitirover-Hotspot" autoconnect yes ssid "Vitirover Jetson Nano"
sudo nmcli con modify "Vitirover-Hotspot" 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
sudo nmcli con modify "Vitirover-Hotspot" wifi-sec.key-mgmt wpa-psk
sudo nmcli con modify "Vitirover-Hotspot" wifi-sec.psk "YourPasswordHere"
```

> **Note**: Replace `YourPasswordHere` with a secure password (minimum 8 characters)

### 3. Set Static IP (Optional)

If you want a specific IP address:

```bash
sudo nmcli con modify "Vitirover-Hotspot" ipv4.addresses 192.168.4.1/24
```

### 4. Enable Auto-Connect

Make sure the connection starts automatically:

```bash
sudo nmcli con modify "Vitirover-Hotspot" connection.autoconnect yes
sudo nmcli con modify "Vitirover-Hotspot" connection.autoconnect-priority 999
```

### 5. Activate the Hotspot

```bash
sudo nmcli con up "Vitirover-Hotspot"
```

### 6. Configure SSH Access

Ensure SSH is enabled and will start at boot:

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

### 7. Create Persistent Service

Create a service to ensure the hotspot starts at boot:

```bash
sudo nano /etc/systemd/system/wifi-hotspot.service
```

Add this content:

```ini
[Unit]
Description=WiFi Hotspot
After=NetworkManager.service
Wants=NetworkManager.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/nmcli con up "Vitirover-Hotspot"
ExecStop=/usr/bin/nmcli con down "Vitirover-Hotspot"

[Install]
WantedBy=multi-user.target
```

Enable the service:

```bash
sudo systemctl enable wifi-hotspot.service
```

### 8. Reboot and Test

```bash
sudo reboot
```

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
