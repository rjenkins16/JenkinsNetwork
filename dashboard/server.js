const express = require('express');
const Docker = require('dockerode');
const path = require('path');
const app = express();
const port = process.env.PORT || 80;

// Initialize Docker API
const docker = new Docker({ socketPath: '/var/run/docker.sock' });

// Set EJS as template engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files
app.use(express.static('public'));

// Route for the main dashboard
app.get('/', async (req, res) => {
  try {
    // Get list of containers
    const containers = await docker.listContainers({ all: true });
    
    // Get system info
    const systemInfo = await getSystemInfo();
    
    // Render dashboard with data
    res.render('index', { 
      containers: containers,
      systemInfo: systemInfo 
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).send('Error loading dashboard');
  }
});

// API endpoint to get container status
app.get('/api/containers', async (req, res) => {
  try {
    const containers = await docker.listContainers({ all: true });
    res.json(containers);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Failed to retrieve containers' });
  }
});

// API endpoint to start a container
app.post('/api/containers/:id/start', async (req, res) => {
  try {
    const container = docker.getContainer(req.params.id);
    await container.start();
    res.json({ success: true });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Failed to start container' });
  }
});

// API endpoint to stop a container
app.post('/api/containers/:id/stop', async (req, res) => {
  try {
    const container = docker.getContainer(req.params.id);
    await container.stop();
    res.json({ success: true });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Failed to stop container' });
  }
});

// API endpoint to restart a container
app.post('/api/containers/:id/restart', async (req, res) => {
  try {
    const container = docker.getContainer(req.params.id);
    await container.restart();
    res.json({ success: true });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Failed to restart container' });
  }
});

// Function to get system information
async function getSystemInfo() {
  try {
    // This is a simplified version - in a real implementation
    // you would gather actual system metrics
    return {
      cpu: '12%',
      memory: '38%',
      disk: '60%',
      uptime: '14 days, 3 hours'
    };
  } catch (error) {
    console.error('Error getting system info:', error);
    return {
      cpu: 'N/A',
      memory: 'N/A',
      disk: 'N/A',
      uptime: 'N/A'
    };
  }
}

// Start the server
app.listen(port, () => {
  console.log(`JenkinsNetwork Dashboard listening at http://localhost:${port}`);
});

module.exports = app;