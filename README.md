# JenkinsNetwork

JenkinsNetwork is a comprehensive self-hosted infrastructure and services stack designed to provide a full suite of network, media, storage, and application services in a single, easy-to-manage repository. This project manages a complex network setup with Docker Compose configurations for various services including a reverse proxy, DNS server, media servers, storage management, and more.

## Overview

This repository serves as a central management system for a home server network infrastructure, containing multiple Docker service stacks organized in a modular architecture:

- **Network Stack**: Contains the reverse proxy (nginx-proxy-manager), DNS server (Technitium), and search engine (SearxNG)
- **Media Stack**: Includes media servers for audiobooks, music, and video content
- **Storage Stack**: Contains the main storage services including file synchronization, databases, containers, and more
- **ARR Stack**: Includes all the *arr* applications (Sonarr, Radarr, Lidarr, etc.) for media automation

## Current Setup

The system currently runs on the following services:

### Network Services
- nginx-proxy-manager: Reverse proxy for managing domain routing
- Technitium DNS Server: Local DNS resolver
- SearxNG: Private search engine

### Media Services
- Jellyfin: Media server for videos
- Navidrome: Music server
- Audiobookshelf: Audiobook management
- Bazarr: Subtitle manager
- Aural: Audio streaming
- Seerr: Media request system

### Storage Services
- Immich: Photo and video management
- Vaultwarden: Bitwarden password manager
- Gluetun: VPN tunneling
- Dispatcharr: Multi-plexing for arr applications
- OpenCloud: File sharing and collaboration
- Keycloak: Identity management
- LDAP: Lightweight Directory Access Protocol
- MariaDB: Database server
- Valkey: In-memory data structure store

### Application Services
- Docker containers using host networking
- Various tools for automation and monitoring

## Static IP Configuration

The server has been configured with a static IP address (192.168.1.111) to ensure consistent access. This is a critical configuration that was manually accomplished.

## System Architecture

The repository uses a modular structure with multiple compose files that can be managed in isolation or together:

```
jenkins-network/
├── arr/                     # *arr* applications (Sonarr, Radarr, Lidarr, etc.)
├── media/                   # Media server applications
├── network/                 # Network infrastructure (nginx, DNS, search)
├── storage/                 # Storage and database applications
├── server.sh                # Central management script for Docker stacks
└── README.md                # This documentation file
```

## Management Script

The `server.sh` script provides a simple interface for managing the Docker containers:

```bash
./server.sh <command> [stack]
```

### Commands:
- **start**: Start one or all stacks
- **stop**: Stop one or all stacks  
- **status**: Check status of one or all stacks
- **update**: Update one or all stacks

### Stacks:
- **arr**: Start/stop/status/update arr stack
- **media**: Start/stop/status/update media stack
- **network**: Start/stop/status/update network stack
- **storage**: Start/stop/status/update storage stack
- **all**: Start/stop/status/update all stacks

### Examples:
```bash
./server.sh start arr
./server.sh stop all  
./server.sh status media
```

## Setup Instructions

### Prerequisites:

1. **Docker and Docker Compose** must be installed on the system:
   ```bash
   sudo apt update
   sudo apt install docker.io docker-compose
   ```

2. **System Requirements**:
   - Linux system (the setup is tested on CachyOS)
   - At least 8GB RAM
   - 100GB+ storage space

### Initial Setup Steps:

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd jenkins-network
   ```

2. **Make the Script Executable**
   ```bash
   chmod +x server.sh
   ```

3. **Set Up Static IP**
   The server should be configured with a static IP address. On a CachyOS system, this can be achieved by:
   - Modifying the network configuration (often `/etc/systemd/network/`)
   - Or using NetworkManager CLI:
   ```bash
   nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.1.111/24 ipv4.gateway 192.168.1.1 ipv4.method manual
   nmcli connection up "Wired connection 1"
   ```
   
   Or configure via systemd-networkd:
   ```bash
   sudo nano /etc/systemd/network/20-wired.network
   ```

4. **Configure Environment Files**
   Each stack (arr, media, network, storage) contains a `.env` file that needs to be configured with appropriate environment variables for your setup.

5. **Start All Services**
   ```bash
   ./server.sh start all
   ```

6. **Verify Installation**
   ```bash
   ./server.sh status all
   ```

## Security Considerations

- All services are configured with appropriate security measures including:
  - No-new-privileges for containers
  - Capabilities drop and add where necessary
  - tmpfs for temporary files
  - Container restart policies
  - Host networking used for specific applications that require direct access

## Maintenance

To update all services:
```bash
./server.sh update all
```

To check the status of individual stacks:
```bash
./server.sh status network
./server.sh status media
./server.sh status arr
./server.sh status storage
```

## Contributing

This project is designed for personal use but contributions in the form of improvements or bug fixes are welcome. Please submit a pull request with your changes.

## License

This project is a personal repository and does not carry an explicit license, as it is a private infrastructure setup. Please use the content with consideration of any local laws and regulations.