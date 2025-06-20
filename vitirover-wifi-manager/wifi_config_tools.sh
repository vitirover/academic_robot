#!/bin/bash

# Scripts utilitaires pour la gestion WiFi Vitirover

# Messages multilingues
declare -A MSG_FR MSG_EN

# Messages français
MSG_FR[LANG_CHOICE]="Choisissez votre langue / Choose your language:"
MSG_FR[INSTALL_TITLE]="=== Installation du gestionnaire WiFi Vitirover ==="
MSG_FR[INSTALL_SUCCESS]="Installation terminée !"
MSG_FR[INSTALL_AUTO]="Le service se lancera automatiquement au démarrage."
MSG_FR[INSTALL_COMMANDS]="Commandes utiles :"
MSG_FR[CONFIG_TITLE]="=== Configuration WiFi Vitirover ==="
MSG_FR[MODE_CHOICE]="Choisissez le mode de fonctionnement :"
MSG_FR[MODE_HOTSPOT]="Hotspot uniquement (par défaut)"
MSG_FR[MODE_CLIENT]="Connexion à un réseau WiFi existant"
MSG_FR[YOUR_CHOICE]="Votre choix"
MSG_FR[CLIENT_CONFIG]="=== Configuration Client WiFi ==="
MSG_FR[AVAILABLE_NETWORKS]="Réseaux WiFi disponibles :"
MSG_FR[WIFI_SSID]="SSID du réseau WiFi :"
MSG_FR[WIFI_PASSWORD]="Mot de passe WiFi :"
MSG_FR[IP_CONFIG]="Configuration IP :"
MSG_FR[DHCP_AUTO]="DHCP (automatique)"
MSG_FR[STATIC_IP]="IP statique"
MSG_FR[STATIC_IP_ADDR]="Adresse IP statique (ex: 192.168.1.100):"
MSG_FR[GATEWAY]="Passerelle (ex: 192.168.1.1):"
MSG_FR[DNS_CONFIG]="DNS [8.8.8.8]:"
MSG_FR[HOTSPOT_CONFIG]="=== Configuration Hotspot de Secours ==="
MSG_FR[HOTSPOT_SSID]="SSID du hotspot [Vitirover-SSH]:"
MSG_FR[HOTSPOT_PASSWORD]="Mot de passe du hotspot [vitirover]:"
MSG_FR[DISCONNECT_WARNING]="⚠️  ATTENTION: La configuration va interrompre votre connexion SSH actuelle!"
MSG_FR[DISCONNECT_MSG]="Le robot va se déconnecter pour rejoindre le nouveau réseau."
MSG_FR[RECONNECT_MSG]="Reconnectez-vous ensuite avec: ssh vitirover@[nouvelle_IP]"
MSG_FR[CHECK_BOX_MSG]="Vérifiez l'IP sur votre box si DHCP est utilisé."
MSG_FR[SEE_YOU_LATER]="À bientôt sur le nouveau réseau!"
MSG_FR[CONTINUE_QUESTION]="Voulez-vous continuer? [y/N]"
MSG_FR[CONFIG_SAVED]="Configuration sauvegardée dans"
MSG_FR[APPLY_NOW]="Voulez-vous appliquer la configuration maintenant ? [y/N]"
MSG_FR[APPLYING_CONFIG]="Application de la configuration..."
MSG_FR[CHECK_LOGS]="Fait ! Vérifiez les logs avec : sudo tail -f /var/log/vitirover-wifi-manager.log"
MSG_FR[STATUS_TITLE]="=== Statut du Gestionnaire WiFi Vitirover ==="
MSG_FR[SERVICE]="Service :"
MSG_FR[ACTIVE]="✓ Actif"
MSG_FR[INACTIVE]="✗ Inactif"
MSG_FR[ACTIVE_CONNECTIONS]="Connexions réseau actives :"
MSG_FR[IP_ADDRESSES]="Adresses IP :"
MSG_FR[NO_WLAN0]="Aucune interface wlan0"
MSG_FR[CURRENT_CONFIG]="Configuration actuelle :"
MSG_FR[NO_CONFIG]="Aucune configuration trouvée"
MSG_FR[RECENT_LOGS]="Derniers logs :"
MSG_FR[NO_LOGS]="Aucun log trouvé"

# Messages anglais
MSG_EN[LANG_CHOICE]="Choisissez votre langue / Choose your language:"
MSG_EN[INSTALL_TITLE]="=== Vitirover WiFi Manager Installation ==="
MSG_EN[INSTALL_SUCCESS]="Installation completed!"
MSG_EN[INSTALL_AUTO]="The service will start automatically at boot."
MSG_EN[INSTALL_COMMANDS]="Useful commands:"
MSG_EN[CONFIG_TITLE]="=== Vitirover WiFi Configuration ==="
MSG_EN[MODE_CHOICE]="Choose operating mode:"
MSG_EN[MODE_HOTSPOT]="Hotspot only (default)"
MSG_EN[MODE_CLIENT]="Connect to existing WiFi network"
MSG_EN[YOUR_CHOICE]="Your choice"
MSG_EN[CLIENT_CONFIG]="=== WiFi Client Configuration ==="
MSG_EN[AVAILABLE_NETWORKS]="Available WiFi networks:"
MSG_EN[WIFI_SSID]="WiFi network SSID:"
MSG_EN[WIFI_PASSWORD]="WiFi password:"
MSG_EN[IP_CONFIG]="IP configuration:"
MSG_EN[DHCP_AUTO]="DHCP (automatic)"
MSG_EN[STATIC_IP]="Static IP"
MSG_EN[STATIC_IP_ADDR]="Static IP address (ex: 192.168.1.100):"
MSG_EN[GATEWAY]="Gateway (ex: 192.168.1.1):"
MSG_EN[DNS_CONFIG]="DNS [8.8.8.8]:"
MSG_EN[HOTSPOT_CONFIG]="=== Backup Hotspot Configuration ==="
MSG_EN[HOTSPOT_SSID]="Hotspot SSID [Vitirover-SSH]:"
MSG_EN[HOTSPOT_PASSWORD]="Hotspot password [vitirover]:"
MSG_EN[DISCONNECT_WARNING]="⚠️  WARNING: Configuration will interrupt your current SSH connection!"
MSG_EN[DISCONNECT_MSG]="The robot will disconnect to join the new network."
MSG_EN[RECONNECT_MSG]="Reconnect afterwards with: ssh vitirover@[new_IP]"
MSG_EN[CHECK_BOX_MSG]="Check the IP on your router if DHCP is used."
MSG_EN[SEE_YOU_LATER]="See you later on the new network!"
MSG_EN[CONTINUE_QUESTION]="Do you want to continue? [y/N]"
MSG_EN[CONFIG_SAVED]="Configuration saved in"
MSG_EN[APPLY_NOW]="Do you want to apply the configuration now? [y/N]"
MSG_EN[APPLYING_CONFIG]="Applying configuration..."
MSG_EN[CHECK_LOGS]="Done! Check logs with: sudo tail -f /var/log/vitirover-wifi-manager.log"
MSG_EN[STATUS_TITLE]="=== Vitirover WiFi Manager Status ==="
MSG_EN[SERVICE]="Service:"
MSG_EN[ACTIVE]="✓ Active"
MSG_EN[INACTIVE]="✗ Inactive"
MSG_EN[ACTIVE_CONNECTIONS]="Active network connections:"
MSG_EN[IP_ADDRESSES]="IP addresses:"
MSG_EN[NO_WLAN0]="No wlan0 interface"
MSG_EN[CURRENT_CONFIG]="Current configuration:"
MSG_EN[NO_CONFIG]="No configuration found"
MSG_EN[RECENT_LOGS]="Recent logs:"
MSG_EN[NO_LOGS]="No logs found"

# Variable globale pour la langue
LANG_SELECTED=""

# Fonction pour afficher un message dans la langue sélectionnée
msg() {
    local key="$1"
    if [ "$LANG_SELECTED" = "fr" ]; then
        echo "${MSG_FR[$key]}"
    else
        echo "${MSG_EN[$key]}"
    fi
}

# Choix de la langue
choose_language() {
    echo "${MSG_FR[LANG_CHOICE]}"
    echo "1) Français"
    echo "2) English"
    echo ""
    read -p "> " lang_choice
    
    case $lang_choice in
        1)
            LANG_SELECTED="fr"
            ;;
        2|*)
            LANG_SELECTED="en"
            ;;
    esac
}

# ============================================================================
# SCRIPT D'INSTALLATION
# ============================================================================

install_wifi_manager() {
    choose_language
    
    msg INSTALL_TITLE
    
    # Copier le script principal
    sudo cp vitirover-wifi-manager.sh /usr/local/bin/
    sudo chmod +x /usr/local/bin/vitirover-wifi-manager.sh
    
    # Créer le service systemd avec délai de 20 secondes
    sudo tee /etc/systemd/system/vitirover-wifi-manager.service > /dev/null << 'EOF'
[Unit]
Description=Vitirover WiFi Manager
After=network.target
Wants=network.target

[Service]
Type=oneshot
# Attendre 20 secondes pour que NetworkManager soit complètement prêt
ExecStartPre=/bin/sleep 20
ExecStart=/usr/local/bin/vitirover-wifi-manager.sh
RemainAfterExit=yes
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Activer le service
    sudo systemctl enable vitirover-wifi-manager.service
    
    msg INSTALL_SUCCESS
    msg INSTALL_AUTO
    echo ""
    msg INSTALL_COMMANDS
    echo "  sudo vitirover-wifi-config config    # $(msg CONFIG_TITLE | sed 's/=== //g' | sed 's/ ===//')"
    echo "  sudo systemctl start vitirover-wifi-manager  # Démarrer maintenant / Start now"
    echo "  sudo systemctl status vitirover-wifi-manager # Voir le statut / See status"
    echo "  sudo tail -f /var/log/vitirover-wifi-manager.log # Voir les logs / See logs"
}

# ============================================================================
# SCRIPT DE CONFIGURATION INTERACTIVE
# ============================================================================

configure_wifi() {
    choose_language
    
    msg CONFIG_TITLE
    echo ""
    
    CONFIG_FILE="/etc/vitirover-wifi-config.conf"
    
    # Créer une sauvegarde
    if [ -f "$CONFIG_FILE" ]; then
        sudo cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
        echo "Backup created / Sauvegarde créée : $CONFIG_FILE.backup"
    fi
    
    msg MODE_CHOICE
    echo "1) $(msg MODE_HOTSPOT)"
    echo "2) $(msg MODE_CLIENT)"
    echo ""
    read -p "$(msg YOUR_CHOICE) [1-2]: " choice
    
    case $choice in
        2)
            echo ""
            msg CLIENT_CONFIG
            
            # Scanner les réseaux disponibles
            msg AVAILABLE_NETWORKS
            nmcli device wifi list | head -10
            echo ""
            
            read -p "$(msg WIFI_SSID) " wifi_ssid
            read -s -p "$(msg WIFI_PASSWORD) " wifi_password
            echo ""
            
            echo ""
            msg IP_CONFIG
            echo "1) $(msg DHCP_AUTO)"
            echo "2) $(msg STATIC_IP)"
            read -p "$(msg YOUR_CHOICE) [1-2]: " ip_choice
            
            static_ip=""
            gateway=""
            dns="8.8.8.8"
            
            if [ "$ip_choice" = "2" ]; then
                read -p "$(msg STATIC_IP_ADDR) " static_ip
                read -p "$(msg GATEWAY) " gateway
                read -p "$(msg DNS_CONFIG) " dns_input
                [ -n "$dns_input" ] && dns="$dns_input"
            fi
            
            # Configuration du hotspot de secours
            echo ""
            msg HOTSPOT_CONFIG
            read -p "$(msg HOTSPOT_SSID) " hotspot_ssid
            read -p "$(msg HOTSPOT_PASSWORD) " hotspot_password
            
            [ -z "$hotspot_ssid" ] && hotspot_ssid="Vitirover-SSH"
            [ -z "$hotspot_password" ] && hotspot_password="vitirover"
            
            # Avertissement de déconnexion
            echo ""
            msg DISCONNECT_WARNING
            msg DISCONNECT_MSG
            msg RECONNECT_MSG
            msg CHECK_BOX_MSG
            msg SEE_YOU_LATER
            echo ""
            read -p "$(msg CONTINUE_QUESTION) " continue_setup
            
            if [ "$continue_setup" != "y" ] && [ "$continue_setup" != "Y" ]; then
                echo "Configuration annulée / Configuration cancelled"
                exit 0
            fi
            
            # Écrire la configuration
            sudo tee "$CONFIG_FILE" > /dev/null << EOF
# Configuration WiFi Vitirover
# Généré le $(date)

# Réseau WiFi à rejoindre
WIFI_SSID="$wifi_ssid"
WIFI_PASSWORD="$wifi_password"

# Configuration IP
STATIC_IP="$static_ip"
GATEWAY="$gateway"
DNS="$dns"

# Configuration du hotspot de secours
HOTSPOT_SSID="$hotspot_ssid"
HOTSPOT_PASSWORD="$hotspot_password"
EOF
            ;;
        
        1|*)
            echo ""
            msg HOTSPOT_CONFIG
            read -p "$(msg HOTSPOT_SSID) " hotspot_ssid
            read -p "$(msg HOTSPOT_PASSWORD) " hotspot_password
            
            [ -z "$hotspot_ssid" ] && hotspot_ssid="Vitirover-SSH"
            [ -z "$hotspot_password" ] && hotspot_password="vitirover"
            
            # Écrire la configuration
            sudo tee "$CONFIG_FILE" > /dev/null << EOF
# Configuration WiFi Vitirover
# Généré le $(date)

# Réseau WiFi à rejoindre (vide = hotspot uniquement)
WIFI_SSID=""
WIFI_PASSWORD=""

# Configuration IP
STATIC_IP=""
GATEWAY=""
DNS="8.8.8.8"

# Configuration du hotspot
HOTSPOT_SSID="$hotspot_ssid"
HOTSPOT_PASSWORD="$hotspot_password"
EOF
            ;;
    esac
    
    sudo chmod 600 "$CONFIG_FILE"
    
    echo ""
    echo "$(msg CONFIG_SAVED) $CONFIG_FILE"
    echo ""
    read -p "$(msg APPLY_NOW) " apply_now
    
    if [ "$apply_now" = "y" ] || [ "$apply_now" = "Y" ]; then
        msg APPLYING_CONFIG
        sudo systemctl restart vitirover-wifi-manager
        msg CHECK_LOGS
    fi
}

# ============================================================================
# SCRIPT DE STATUT
# ============================================================================

show_status() {
    choose_language
    
    msg STATUS_TITLE
    echo ""
    
    # Statut du service
    echo "$(msg SERVICE)"
    systemctl is-active vitirover-wifi-manager.service >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  $(msg ACTIVE)"
    else
        echo "  $(msg INACTIVE)"
    fi
    
    echo ""
    echo "$(msg ACTIVE_CONNECTIONS)"
    nmcli connection show --active
    
    echo ""
    echo "$(msg IP_ADDRESSES)"
    ip addr show wlan0 2>/dev/null | grep 'inet ' || echo "  $(msg NO_WLAN0)"
    
    echo ""
    echo "$(msg CURRENT_CONFIG)"
    if [ -f "/etc/vitirover-wifi-config.conf" ]; then
        grep -v "^#" /etc/vitirover-wifi-config.conf | grep -v "^$"
    else
        echo "  $(msg NO_CONFIG)"
    fi
    
    echo ""
    echo "$(msg RECENT_LOGS)"
    tail -5 /var/log/vitirover-wifi-manager.log 2>/dev/null || echo "  $(msg NO_LOGS)"
}

# ============================================================================
# MENU PRINCIPAL
# ============================================================================

case "$1" in
    "install")
        install_wifi_manager
        ;;
    "config")
        configure_wifi
        ;;
    "status")
        show_status
        ;;
    *)
        echo "Vitirover WiFi Configuration Tools / Outils de Configuration WiFi Vitirover"
        echo ""
        echo "Usage: $0 {install|config|status}"
        echo ""
        echo "  install  - Install WiFi manager / Installer le gestionnaire WiFi"
        echo "  config   - Configure WiFi interactively / Configurer le WiFi de manière interactive"
        echo "  status   - Show current status / Afficher le statut actuel"
        echo ""
        exit 1
        ;;
esac