#!/bin/bash

# Gestionnaire WiFi automatique pour Vitirover
# Par défaut: hotspot SSH, sinon connexion à un réseau configuré

CONFIG_FILE="/etc/vitirover-wifi-config.conf"
LOG_FILE="/var/log/vitirover-wifi-manager.log"

# Configuration par défaut du hotspot
HOTSPOT_SSID="Vitirover-SSH"
HOTSPOT_PASSWORD="vitirover"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Créer le fichier de configuration s'il n'existe pas
create_config_template() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log_message "Création du fichier de configuration..."
        sudo tee "$CONFIG_FILE" > /dev/null << EOF
# Configuration WiFi Vitirover
# Laissez vide pour utiliser le hotspot par défaut

# Réseau WiFi à rejoindre (laisser vide pour hotspot uniquement)
WIFI_SSID=""
WIFI_PASSWORD=""

# IP statique souhaitée (optionnel, laisser vide pour DHCP)
STATIC_IP=""
GATEWAY=""
DNS="8.8.8.8"

# Configuration du hotspot (utilisé si WIFI_SSID est vide)
HOTSPOT_SSID="$HOTSPOT_SSID"
HOTSPOT_PASSWORD="$HOTSPOT_PASSWORD"
EOF
        sudo chmod 600 "$CONFIG_FILE"
        log_message "Fichier de configuration créé : $CONFIG_FILE"
    fi
}

# Charger la configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        log_message "Configuration chargée depuis $CONFIG_FILE"
    else
        log_message "Erreur: Fichier de configuration introuvable"
        return 1
    fi
}

# Nettoyer les connexions existantes
cleanup_connections() {
    log_message "Nettoyage des connexions existantes..."
    
    # Désactiver toutes les connexions WiFi actives
    nmcli connection show --active | grep wifi | while read line; do
        connection_name=$(echo "$line" | awk '{print $1}')
        log_message "Désactivation de la connexion: $connection_name"
        nmcli connection down "$connection_name" 2>/dev/null
    done
    
    sleep 2
}

# Créer et activer le hotspot
create_hotspot() {
    log_message "Création du hotspot: $HOTSPOT_SSID"
    
    # Supprimer un éventuel hotspot existant
    nmcli connection delete "Hotspot" 2>/dev/null
    
    # Créer le nouveau hotspot
    if nmcli device wifi hotspot ifname wlan0 ssid "$HOTSPOT_SSID" password "$HOTSPOT_PASSWORD"; then
        log_message "Hotspot créé avec succès"
        log_message "SSID: $HOTSPOT_SSID"
        log_message "Password: $HOTSPOT_PASSWORD"
        
        # Attendre que l'interface soit prête
        sleep 5
        
        # Afficher l'IP du hotspot
        hotspot_ip=$(ip addr show wlan0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
        log_message "IP du hotspot: $hotspot_ip"
        log_message "Connexion SSH disponible sur: ssh vitirover@$hotspot_ip"
        
        return 0
    else
        log_message "Erreur lors de la création du hotspot"
        return 1
    fi
}

# Se connecter au réseau WiFi configuré
connect_to_wifi() {
    log_message "Tentative de connexion au réseau: $WIFI_SSID"
    
    # Scanner pour voir si le réseau est disponible
    if ! nmcli device wifi list | grep -q "$WIFI_SSID"; then
        log_message "Réseau $WIFI_SSID non trouvé, passage en mode hotspot"
        return 1
    fi
    
    # Se connecter au réseau
    if nmcli device wifi connect "$WIFI_SSID" password "$WIFI_PASSWORD"; then
        log_message "Connexion réussie au réseau $WIFI_SSID"
        
        # Configurer l'IP statique si spécifiée
        if [ -n "$STATIC_IP" ] && [ -n "$GATEWAY" ]; then
            log_message "Configuration de l'IP statique: $STATIC_IP"
            connection_name=$(nmcli connection show --active | grep "$WIFI_SSID" | awk '{print $1}')
            
            nmcli connection modify "$connection_name" ipv4.addresses "$STATIC_IP/24"
            nmcli connection modify "$connection_name" ipv4.gateway "$GATEWAY"
            nmcli connection modify "$connection_name" ipv4.dns "$DNS"
            nmcli connection modify "$connection_name" ipv4.method manual
            nmcli connection up "$connection_name"
            
            log_message "IP statique configurée"
        fi
        
        # Afficher les informations de connexion
        current_ip=$(ip addr show wlan0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
        log_message "IP actuelle: $current_ip"
        log_message "Connexion SSH disponible sur: ssh vitirover@$current_ip"
        
        return 0
    else
        log_message "Échec de la connexion au réseau $WIFI_SSID"
        return 1
    fi
}

# Vérifier que SSH est actif
check_ssh() {
    if systemctl is-active --quiet ssh; then
        log_message "Service SSH actif"
    else
        log_message "Démarrage du service SSH..."
        sudo systemctl start ssh
        sudo systemctl enable ssh
    fi
}

# Fonction principale
main() {
    log_message "=== Démarrage du gestionnaire WiFi Vitirover ==="
    
    # Créer le fichier de configuration si nécessaire
    create_config_template
    
    # Charger la configuration
    if ! load_config; then
        log_message "Erreur fatale: impossible de charger la configuration"
        exit 1
    fi
    
    # Vérifier que SSH est actif
    check_ssh
    
    # Nettoyer les connexions existantes
    cleanup_connections
    
    # Décider du mode selon la configuration
    if [ -n "$WIFI_SSID" ] && [ -n "$WIFI_PASSWORD" ]; then
        log_message "Configuration WiFi détectée, tentative de connexion..."
        
        if connect_to_wifi; then
            log_message "Mode: Client WiFi avec SSH"
        else
            log_message "Connexion WiFi échouée, basculement en mode hotspot"
            create_hotspot
        fi
    else
        log_message "Aucune configuration WiFi, démarrage en mode hotspot"
        create_hotspot
    fi
    
    log_message "=== Gestionnaire WiFi Vitirover démarré ==="
}

# Vérifier les permissions root pour certaines opérations
if [ "$EUID" -ne 0 ]; then
    echo "Ce script nécessite des privilèges sudo pour certaines opérations."
    echo "Relancement avec sudo..."
    exec sudo "$0" "$@"
fi

# Exécuter la fonction principale
main "$@"