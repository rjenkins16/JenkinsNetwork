# JenkinsNetwork Dashboard

## System Monitoring Dashboard

This is a web-based dashboard for monitoring your JenkinsNetwork infrastructure. It provides real-time status information, resource usage, and quick management controls for all your running services.

### System Status

**Overall Status**: Operational  
**Uptime**: 14 days, 3 hours  
**Load Average**: 0.85

### Resource Usage

<div class="resources">
  <div class="resource">
    <h3>CPU Usage</h3>
    <div class="progress">
      <div class="progress-bar bg-success" style="width: 12%"></div>
    </div>
    <p>12% (16 cores)</p>
  </div>
  
  <div class="resource">
    <h3>Memory Usage</h3>
    <div class="progress">
      <div class="progress-bar bg-info" style="width: 38%"></div>
    </div>
    <p>38% (62GB)</p>
  </div>
  
  <div class="resource">
    <h3>Disk Usage</h3>
    <div class="progress">
      <div class="progress-bar bg-warning" style="width: 60%"></div>
    </div>
    <p>60% (3.7TB)</p>
  </div>
</div>

### Container Status

<div class="container-grid">
  <div class="container-card">
    <h4>Jellyfin</h4>
    <p class="status">Running</p>
    <p>8096/tcp</p>
    <button class="btn btn-sm btn-success">Start</button>
    <button class="btn btn-sm btn-danger">Stop</button>
    <button class="btn btn-sm btn-warning">Restart</button>
  </div>
  
  <div class="container-card">
    <h4>Sonarr</h4>
    <p class="status">Running</p>
    <p>8989/tcp</p>
    <button class="btn btn-sm btn-success">Start</button>
    <button class="btn btn-sm btn-danger">Stop</button>
    <button class="btn btn-sm btn-warning">Restart</button>
  </div>
  
  <div class="container-card">
    <h4>Radarr</h4>
    <p class="status">Running</p>
    <p>7878/tcp</p>
    <button class="btn btn-sm btn-success">Start</button>
    <button class="btn btn-sm btn-danger">Stop</button>
    <button class="btn btn-sm btn-warning">Restart</button>
  </div>
  
  <div class="container-card">
    <h4>Lidarr</h4>
    <p class="status">Running</p>
    <p>8686/tcp</p>
    <button class="btn btn-sm btn-success">Start</button>
    <button class="btn btn-sm btn-danger">Stop</button>
    <button class="btn btn-sm btn-warning">Restart</button>
  </div>
  
  <div class="container-card">
    <h4>Bazarr</h4>
    <p class="status">Running</p>
    <p>6767/tcp</p>
    <button class="btn btn-sm btn-success">Start</button>
    <button class="btn btn-sm btn-danger">Stop</button>
    <button class="btn btn-sm btn-warning">Restart</button>
  </div>
  
  <div class="container-card">
    <h4>Navidrome</h4>
    <p class="status">Running</p>
    <p>4533/tcp</p>
    <button class="btn btn-sm btn-success">Start</button>
    <button class="btn btn-sm btn-danger">Stop</button>
    <button class="btn btn-sm btn-warning">Restart</button>
  </div>
</div>

### Stack Controls

<div class="stacks">
  <div class="stack">
    <h4>Network Stack</h4>
    <ul>
      <li>nginx-proxy-manager</li>
      <li>Technitium DNS Server</li>
      <li>SearxNG</li>
    </ul>
    <button class="btn btn-sm btn-primary">Start</button>
    <button class="btn btn-sm btn-secondary">Stop</button>
    <button class="btn btn-sm btn-info">Update</button>
  </div>
  
  <div class="stack">
    <h4>Media Stack</h4>
    <ul>
      <li>Jellyfin</li>
      <li>Navidrome</li>
      <li>Audiobookshelf</li>
      <li>Bazarr</li>
      <li>Aural</li>
      <li>Seerr</li>
      <li>Youtarr</li>
    </ul>
    <button class="btn btn-sm btn-primary">Start</button>
    <button class="btn btn-sm btn-secondary">Stop</button>
    <button class="btn btn-sm btn-info">Update</button>
  </div>
  
  <div class="stack">
    <h4>Storage Stack</h4>
    <ul>
      <li>Immich</li>
      <li>Vaultwarden</li>
      <li>Gluetun</li>
      <li>MariaDB</li>
      <li>Valkey</li>
      <li>Redis</li>
      <li>Dispatcharr</li>
    </ul>
    <button class="btn btn-sm btn-primary">Start</button>
    <button class="btn btn-sm btn-secondary">Stop</button>
    <button class="btn btn-sm btn-info">Update</button>
  </div>
  
  <div class="stack">
    <h4>*arr* Stack</h4>
    <ul>
      <li>Sonarr</li>
      <li>Radarr</li>
      <li>Lidarr</li>
      <li>Flaresolverr</li>
      <li>Prowlarr</li>
    </ul>
    <button class="btn btn-sm btn-primary">Start</button>
    <button class="btn btn-sm btn-secondary">Stop</button>
    <button class="btn btn-sm btn-info">Update</button>
  </div>
</div>

### Recent Activity

**Recent System Events**:
- 2026-05-23 08:30:45 - Started Jellyfin container
- 2026-05-22 16:15:22 - Updated Sonarr container
- 2026-05-21 22:45:10 - System backup completed
- 2026-05-20 10:30:05 - Updated DNS configuration
- 2026-05-19 14:20:30 - MariaDB database optimized