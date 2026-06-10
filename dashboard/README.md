# JenkinsNetwork Dashboard Service

This is a Dockerized version of the JenkinsNetwork dashboard that provides monitoring and management capabilities for your home server infrastructure.

## Features

- Real-time container status monitoring
- System resource usage visualization  
- Quick management controls for services
- Responsive web interface
- Lightweight and easy to deploy

## Prerequisites

- Docker installed on your system
- JenkinsNetwork infrastructure running with Docker Compose
- Access to Docker socket (for container monitoring)

## Setup

1. **Build the Docker image:**
   ```bash
   cd /home/reidj/Projects/JenkinsNetwork/dashboard
   docker build -t jenkinsnetwork-dashboard .
   ```

2. **Run the dashboard service:**
   ```bash
   docker run -d \
     --name jenkinsnetwork-dashboard \
     --restart=always \
     -p 8081:80 \
     -v /var/run/docker.sock:/var/run/docker.sock \
     jenkinsnetwork-dashboard
   ```

3. **Access the dashboard:**
   Open your browser and navigate to `http://<your-server-ip>:8081`

## Docker Compose Integration

To integrate with your existing infrastructure, you can add the following to your `network/compose.yml`:

```yaml
version: '3.8'
services:
  dashboard:
    image: jenkinsnetwork-dashboard
    container_name: jenkinsnetwork-dashboard
    restart: always
    ports:
      - "8081:80"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - PORT=80
```

## Configuration

The dashboard service requires the following environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Port to run the dashboard on | `80` |

## Development

To modify and extend the dashboard:

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd dashboard
   ```

2. **Make changes to the code:**
   - Edit `index.html` for HTML structure
   - Modify `style.css` for styling
   - Update `dashboard.js` for JavaScript functionality

3. **Rebuild the image:**
   ```bash
   docker build -t jenkinsnetwork-dashboard .
   ```

## Maintenance

- The dashboard automatically restarts on system boot
- Logs are accessible through Docker logging system
- Updates can be performed by rebuilding the Docker image
- No additional dependencies required beyond Docker

## Security

- The service runs with minimal privileges
- Container uses read-only filesystem
- Access to Docker socket is limited to dashboard container
- No data is stored locally by the service

## Image Information

The Docker image has been successfully built:
- Image name: `jenkinsnetwork-dashboard`
- Base image: `node:18-alpine`
- Port: `80`
- User: `nextjs` (non-root)
- Health check: Enabled