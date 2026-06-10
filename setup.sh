#!/bin/bash

# JenkinsNetwork Setup Script
# This script automates the setup of the JenkinsNetwork infrastructure
# with proper static IP configuration and service initialization

set -e  # Exit on any error

echo "=== JenkinsNetwork Setup Script ==="

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "This script should not be run as root"
   exit 1
fi

# Get current user
USER=$(whoami)
echo "Running as user: $USER"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo pacman -Syu --noconfirm docker
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    echo "Docker installed and added to user group"
else
    echo "Docker is already installed"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo pacman -Syu --noconfirm docker-compose
    echo "Docker Compose installed"
else
    echo "Docker Compose is already installed"
fi

# Check if ip command is available
if ! command -v ip &> /dev/null; then
    echo "ip command not found. Installing iproute2..."
    sudo pacman -Syu --noconfirm iproute2
fi

# Get the primary network interface (excluding loopback and docker interfaces)
INTERFACE=$(ip route | grep '^default' | head -1 | awk '{print $5}' | grep -v docker | head -1)
if [ -z "$INTERFACE" ]; then
    INTERFACE=$(ip link show | grep 'state UP' | head -1 | awk '{print $2}' | sed 's/://')
fi

echo "Primary network interface: $INTERFACE"

# Check current IP address
CURRENT_IP=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
echo "Current IP address: $CURRENT_IP"

# Ask user for static IP configuration
read -p "Do you want to configure a static IP address for this server? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter static IP address (e.g., 192.168.1.111): " STATIC_IP
    read -p "Enter subnet mask (e.g., 24 for 255.255.255.0): " SUBNET
    read -p "Enter gateway address (e.g., 192.168.1.1): " GATEWAY
    read -p "Enter primary DNS server (e.g., 192.168.1.1): " DNS_SERVER
    
    # Check if we're using systemd-networkd or NetworkManager
    if [ -d "/etc/systemd/network/" ]; then
        echo "Configuring with systemd-networkd..."
        # Create network configuration file
        NETWORK_DIR="/etc/systemd/network"
        if [ ! -d "$NETWORK_DIR" ]; then
            sudo mkdir -p $NETWORK_DIR
        fi
        
        # Create network configuration file
        CONFIG_FILE="$NETWORK_DIR/20-wired.network"
        echo "[Match]" > $CONFIG_FILE
        echo "Name=$INTERFACE" >> $CONFIG_FILE
        echo "[Network]" >> $CONFIG_FILE
        echo "Address=$STATIC_IP/$SUBNET" >> $CONFIG_FILE
        echo "Gateway=$GATEWAY" >> $CONFIG_FILE
        echo "DNS=$DNS_SERVER" >> $CONFIG_FILE
        echo "DHCP=no" >> $CONFIG_FILE
        
        echo "Network configuration created in $CONFIG_FILE"
        echo "Please reboot the system to apply the changes"
        echo "Or run: sudo systemctl restart systemd-networkd"
    else
        echo "Using NetworkManager for IP configuration"
        # Configure with NetworkManager
        echo "Setting static IP with NetworkManager..."
        sudo nmcli connection modify "$INTERFACE" ipv4.addresses "$STATIC_IP/$SUBNET" 
        sudo nmcli connection modify "$INTERFACE" ipv4.gateway "$GATEWAY"
        sudo nmcli connection modify "$INTERFACE" ipv4.dns "$DNS_SERVER"
        sudo nmcli connection modify "$INTERFACE" ipv4.method manual
        sudo nmcli connection up "$INTERFACE"
    fi
else
    echo "Skipping static IP configuration"
fi

# Make server.sh executable
chmod +x server.sh

# Create required directories
echo "Setting up required directories..."
mkdir -p storage/network/nginx/data
mkdir -p storage/network/nginx/data/letsencrypt
mkdir -p storage/network/technitium/config
mkdir -p storage/arr
mkdir -p storage/media
mkdir -p storage/storage

echo "Creating default .env files..."

# Create default network environment file
cat > network/.env << EOF
# Environment variables for network stack
NETWORK_DATA=${PWD}/storage/network
SEARXNG_BASE_URL=http://localhost:8082
SEARXNG_PORT=8082
EOF

# Create default storage environment file
cat > storage/.env << EOF
# Environment variables for storage stack  
STORAGE_DATA=${PWD}/storage/storage
EOF

# Create default arr environment file
cat > arr/.env << EOF
# Environment variables for arr stack
ARR_DATA=${PWD}/storage/arr
EOF

# Create default media environment file
cat > media/.env << EOF
# Environment variables for media stack
MEDIA_DATA=${PWD}/storage/media
EOF

# Display current status
echo ""
echo "=== System Setup Summary ==="
echo "1. Docker and Docker Compose are installed"
echo "2. Static IP configuration was handled (if requested)"
echo "3. Required directories have been created"
echo "4. Environment files have been generated"
echo ""
echo "To start all services:"
echo "  ./server.sh start all"
echo ""
echo "To check the status:"
echo "  ./server.sh status all"
echo ""
echo "Please note: You may need to reboot the system if you configured a static IP address."