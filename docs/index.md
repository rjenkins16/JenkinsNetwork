# JenkinsNetwork Infrastructure

## System Overview

JenkinsNetwork is a comprehensive home server infrastructure built using Docker Compose that provides a full suite of network, media, storage, and application services. This repository contains the complete configuration for managing a self-hosted server with modern, containerized services.

## Current Infrastructure Status

The system is currently running 29 active Docker containers across 98 images with the following components:

### Network Infrastructure
- nginx-proxy-manager (reverse proxy)
- Technitium DNS server (local DNS resolver)
- SearxNG (private search engine)

### Media Services
- Jellyfin (media server)
- Navidrome (music server)
- Audiobookshelf (audiobooks)
- Bazarr (subtitle manager)
- Aural (audio streaming)
- Seerr (media request system)
- Youtarr (YouTube content management)

### Storage & Database Services
- Immich (photo/video management)
- Vaultwarden (password manager)
- Gluetun (VPN tunneling)
- MariaDB (database server)
- Valkey (in-memory data store)
- Redis (cache/database)
- Dispatcharr (multi-plexing for arr applications)

### *arr* Applications
- Sonarr (TV shows)
- Radarr (movies)
- Lidarr (music)
- Flaresolverr (resolver)
- Prowlarr (indexer manager)

### Other Services
- qBittorrent (torrent client)
- Windows container (for Windows applications)
- OpenCloud (file sharing)
- Keycloak (identity management)
- LDAP (directory access)

## Network Configuration

The system has been configured with a static IP address:
- IP Address: 192.168.1.111
- Subnet: 255.255.255.0 (24)
- Gateway: 192.168.1.1
- DNS Server: 192.168.1.1

This static IP configuration allows consistent access to services from within the home network and enables proper routing of incoming requests.

## Service Management

The infrastructure is managed through a central script that controls multiple Docker Compose stacks:

### Commands Available:
1. **start** - Start one or all stacks
2. **stop** - Stop one or all stacks  
3. **status** - Check status of one or all stacks
4. **update** - Update one or all stacks

### Stacks Available:
- **arr** - *arr* applications for media automation (Sonarr, Radarr, Lidarr)
- **media** - Media server applications
- **network** - Network infrastructure (nginx, DNS, search)
- **storage** - Storage and database applications
- **all** - All stacks

### Examples:
```bash
./server.sh start arr
./server.sh stop all
./server.sh status media
./server.sh update all
```

## Directory Structure

```
jenkins-network/
├── arr/                     # *arr* applications (Sonarr, Radarr, Lidarr, etc.)
├── media/                   # Media server applications
├── network/                 # Network infrastructure (nginx, DNS, search)
├── storage/                 # Storage and database applications
├── server.sh                # Central management script for Docker stacks
├── setup.sh                 # Initial setup script
└── README.md                # This documentation file
```

## Setup Instructions

### Prerequisites

1. **Install Docker and Docker Compose**
   ```bash
   sudo pacman -Syu --noconfirm docker docker-compose
   sudo systemctl enable --now docker
   sudo usermod -aG docker $USER
   ```

2. **System Requirements**
   - CachyOS Linux system
   - 62GB RAM
   - 3.7TB storage space
   - Static IP address configured (192.168.1.111)

### Initial Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd jenkins-network
   ```

2. Make scripts executable:
   ```bash
   chmod +x server.sh setup.sh
   ```

3. Run the setup script to prepare directories and default configuration:
   ```bash
   ./setup.sh
   ```

4. Start all services:
   ```bash
   ./server.sh start all
   ```

5. Verify installation:
   ```bash
   ./server.sh status all
   ```

## Configuration Files

Each stack has its own configuration directory with:
- `compose.yml` - Docker Compose definition
- `.env` - Environment variables

### Environment Variables

- `NETWORK_DATA=/home/reidj/Projects/JenkinsNetwork/storage/network`
- `SEARXNG_BASE_URL=http://localhost:8082`
- `SEARXNG_PORT=8082`

## Maintenance

### Updating Services
```bash
./server.sh update all
```

### Checking Status
```bash
./server.sh status all
```

### Service Access Points

- **Nginx Proxy Manager**: http://192.168.1.111:8080
- **DNS Server**: http://192.168.1.111:5380
- **Jellyfin**: http://192.168.1.111:8096
- **Navidrome**: http://192.168.1.111:4533
- **Audiobookshelf**: http://192.168.1.111:13378
- **Immich**: http://192.168.1.111:2283
- **Vaultwarden**: http://192.168.1.111:8000

## Security Considerations

All services follow the principle of least privilege:
- Containers run without unnecessary privileges
- Capabilities are properly dropped and added where needed
- Temporary files are stored in tmpfs
- Services use restart policies for reliability
- Host networking is used selectively for services needing direct access

## Troubleshooting

### Common Issues

1. **Container fails to start**: Check logs with `docker logs <container-name>`
2. **Port conflicts**: Ensure no other services use the same ports
3. **Permission issues**: Verify user is in docker group
4. **Network configuration**: Check static IP setup in system configuration

### Useful Docker Commands

```bash
# View running containers
docker ps

# View all containers
docker ps -a

# View container logs
docker logs <container-name>

# Inspect container configuration
docker inspect <container-name>

# View network details
docker network ls
```

## Extending Infrastructure

To add new services:
1. Create a new directory for the stack
2. Add a compose.yml file with your service definitions and appropriate networking
3. Create a .env file with required environment variables
4. Update your server.sh script to include the new stack in the management commands

## Backup Strategy

Regular backups should include:
- Configuration files
- Volume data (important for media and databases)
- Environment variables

## Notes

This infrastructure is designed for personal home server use and is configured with a static IP address for consistent access. The modular approach allows individual stacks to be managed independently, making it easy to update, stop, or start services without affecting others.

The system is actively monitoring and managing Docker containers with all services running under proper isolation and appropriate security measures.