# Installing and Configuring InfluxDB 2.0 on macOS

This guide provides step-by-step instructions for installing InfluxDB 2.0 on macOS and configuring it to work with k6 for load testing metrics.

## Installation Options

Choose one of the following methods to install InfluxDB:

### Option 1: Using Homebrew (Recommended)

1. Save the installation script to a file named `install-influxdb-homebrew.sh`:
   ```bash
   chmod +x install-influxdb-homebrew.sh
   ./install-influxdb-homebrew.sh
   ```

2. Follow the on-screen instructions to complete the initial setup at http://localhost:8086

### Option 2: Using Docker

If you prefer using Docker instead:

1. Save the Docker installation script to a file named `install-influxdb-docker.sh`:
   ```bash
   chmod +x install-influxdb-docker.sh
   ./install-influxdb-docker.sh
   ```

2. This will create a pre-configured InfluxDB instance with credentials provided in the script output.

## Setting Up InfluxDB for k6

After installing InfluxDB, you need to configure it for use with k6:

1. Save the configuration script to a file named `setup-influxdb-for-k6.sh`:
   ```bash
   chmod +x setup-influxdb-for-k6.sh
   ./setup-influxdb-for-k6.sh
   ```

2. Follow the prompts to:
   - Create a dedicated k6-metrics bucket
   - Generate an API token for k6
   - Create a configuration file for your k6 tests

## Using InfluxDB with k6

To use your newly configured InfluxDB with k6:

1. Load the environment variables:
   ```bash
   source k6-influxdb-config.env
   ```

2. Run a k6 test with InfluxDB output:
   ```bash
   ./output/k6 run your-script.js --out influxdb=http://localhost:8086/api/v2
   ```

3. View the results in the InfluxDB UI at http://localhost:8086

## Common InfluxDB Management Commands

### For Homebrew Installation:
```bash
# Start InfluxDB
brew services start influxdb

# Stop InfluxDB
brew services stop influxdb

# Restart InfluxDB
brew services restart influxdb

# Check status
brew services list | grep influxdb
```

### For Docker Installation:
```bash
# Start container
docker start influxdb2

# Stop container
docker stop influxdb2

# View logs
docker logs influxdb2

# Remove container
docker rm influxdb2
```

## Accessing the InfluxDB CLI

For advanced configuration, you can use the InfluxDB command-line interface:

```bash
# For Homebrew installation
influx

# For Docker installation
docker exec -it influxdb2 influx
```

## Troubleshooting

1. **Cannot connect to InfluxDB**:
   - Check if the service is running (`brew services list` or `docker ps`)
   - Verify that port 8086 is not being used by another application

2. **Authentication errors with k6**:
   - Verify that your token has write permissions to the bucket
   - Check that environment variables are correctly set

3. **Data not appearing in dashboard**:
   - Confirm that bucket names match between InfluxDB and k6 configuration
   - Check for any errors in the k6 output

## Creating Sample Dashboard for k6 Metrics

After running some tests, create a dashboard in InfluxDB:

1. Go to http://localhost:8086
2. Navigate to "Dashboards" → "Create Dashboard"
3. Add panels for:
   - HTTP Request Duration
   - VU (Virtual User) Count
   - Error Rate
   - Requests Per Second

## Next Steps

- Set up Grafana for more advanced visualization options
- Configure alerts based on performance thresholds
- Create automated test pipelines with k6 and InfluxDB
