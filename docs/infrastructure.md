# JenkinsNetwork Infrastructure Documentation

## Overview

The JenkinsNetwork is a home server infrastructure designed to provide a comprehensive suite of services including network management, media servers, storage solutions, and application hosting. This infrastructure is built using Docker Compose for containerized services and is managed through a centralized script.

## System Architecture

This repository sets up a modular home server network with the following components:

- **Network Stack**: Includes nginx-proxy-manager for reverse proxy, Technitium DNS server, and SearxNG private search engine
- **Media Stack**: Contains Jellyfin, Navidrome, Audiobookshelf, and other media management services
- **Storage Stack**: Includes Immich, Vaultwarden, Gluetun, MariaDB, Valkey, and file storage services  
- **ARR Stack**: Complete set of *arr* applications (Sonarr, Radarr, Lidarr) for media automation

## Current Configuration

### Network Interface Details
The system has the following network interfaces:
- Primary interface: enp14s0 (IPv4: 192.168.1.111/24)
- IPv6 addresses available for both local and global connectivity
- Docker bridges and virtual networks for container isolation

### Services Currently Running
Based on the docker ps output, the following services are active:
- DNS server (technitium/dns-server)
- nginx-proxy-manager (jc21/nginx-proxy-manager)
- Jellyfin (jellyfin/jellyfin)
- Bazarr (lscr.io/linuxserver/bazarr)
- qBittorrent (lscr.io/linuxserver/qbittorrent)
- Sonarr (lscr.io/linuxserver/sonarr)
- Radarr (lscr.io/linuxserver/radarr)
- Aural (ghcr.io/lklynet/aurral)
- Lidarr (lscr.io/linuxserver/lidarr)
- Flaresolverr (ghcr.io/flaresolverr/flaresolverr)
- Prowlarr (lscr.io/linuxserver/prowlarr)
- Gluetun (qmcgaw/gluetun)
- Immich (ghcr.io/immich-app/immich-server)
- Vaultwarden (vaultwarden/server)
- Redis (redis:alpine)
- DNS server (technitium/dns-server)
- Dispatcharr (ghcr.io/dispatcharr/dispatcharr)
- Navidrome (deluan/navidrome)
- Audiobookshelf (ghcr.io/advplyr/audiobookshelf)
- Seerr (ghcr.io/seerr-team/seerr)
- Youtarr (dialmaster/youtarr)
- MariaDB (mariadb:10.3)
- Windows container (ghcr.io/dockur/windows)

## Static IP Setup

The system has been configured with a static IP address of 192.168.1.111 to ensure consistent access. This is a critical configuration for a home server network. 

### IP Configuration Details
- IP Address: 192.168.1.111
- Subnet Mask: 255.255.255.0 (24)
- Gateway: 192.168.1.1
- DNS Server: 192.168.1.1

## Managing Services

The central management script `server.sh` provides a simple interface for managing all the Docker containers:

```bash
Usage: ./server.sh <command> [stack]

Commands:
  start    - Start one or all stacks
  stop     - Stop one or all stacks
  status   - Check status of one or all stacks
  update   - Update one or all stacks

Stacks:
  arr      - Start/stop/status/update arr stack
  media    - Start/stop/status/update media stack
  network  - Start/stop/status/update network stack
  storage  - Start/stop/status/update storage stack
  all      - Start/stop/status/update all stacks

Examples:
  ./server.sh start arr
  ./server.sh stop all
  ./server.sh status media
```

## Environment File Configuration

Each service stack includes appropriate environment files that need to be configured. The environment files are located in each respective stack directory:
- `network/.env`
- `storage/.env` 
- `arr/.env`
- `media/.env`

The script automatically creates default environment files with appropriate paths for each service stack.

## Security Considerations

All services follow modern security practices:
- Container isolation using Docker networks
- No-new-privileges for containers
- Capabilities drop and add where necessary
- tmpfs for temporary directories
- Restart policies for service continuity
- Host networking for specific applications that require direct access

## Service Access Points

### Network Services
- Nginx Proxy Manager: http://192.168.1.111:8080
- DNS Server: http://192.168.1.111:5380 (port 5380)
- SearxNG: http://192.168.1.111:8082

### Media Services
- Jellyfin: http://192.168.1.111:8096
- Navidrome: http://192.168.1.111:4533
- Audiobookshelf: http://192.168.1.111:13378

### Storage Services
- Immich: http://192.168.1.111:2283
- Vaultwarden: http://192.168.1.111:8000
- Gluetun: Various VPN ports
- MariaDB: Port 3306

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

## Directory Structure

```
jenkins-network/
├── arr/                     # *arr* applications (Sonarr, Radarr, Lidarr, etc.)
├── media/                   # Media server applications  
├── network/                 # Network infrastructure (nginx, DNS, search)
├── storage/                 # Storage and database applications
├── server.sh                # Central management script for Docker stacks
├── setup.sh                 # Setup script for initial configuration
└── README.md                # This documentation file
```

## Initial Setup

1. Clone the repository: `git clone <repository-url>`
2. Make the scripts executable: `chmod +x server.sh setup.sh`
3. Run the setup script: `./setup.sh`
4. Start all services: `./server.sh start all`
5. Verify installation: `./server.sh status all`

## Troubleshooting

### Common Issues

1. **Service Not Starting**: Check if the container ports are in use with `docker ps -a`
2. **Network Issues**: Ensure the static IP is properly configured
3. **Permission Problems**: Make sure the user belongs to the docker group: `sudo usermod -aG docker $USER`
4. **Docker Compose Version**: Ensure you have either `docker compose` or `docker-compose` installed

### Useful Commands

```bash
# Check container logs
docker logs <container-name>
# View container processes
docker ps -a
# Inspect container configuration
docker inspect <container-name>
# View network details
docker network ls
```

This infrastructure provides a complete home server solution that can be easily maintained and extended with additional services as needed.