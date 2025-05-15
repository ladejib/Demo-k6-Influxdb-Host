#!/bin/bash
# Script to install InfluxDB 2.0 on macOS using Docker

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker for Mac first."
    echo "You can download it from https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "Docker doesn't seem to be running. Please start Docker Desktop."
    exit 1
fi

echo "Docker is running. Installing InfluxDB 2.0 using Docker..."

# Create directories for persistent storage
mkdir -p ~/influxdb/data
mkdir -p ~/influxdb/config

echo "Direcotories created for persistent storage at ~/influxdb/data and ~/influxdb/config"
chmod 777 ~/influxdb/data
chmod 777 ~/influxdb/config
echo "Setting permissions for directories..."

echo "Pulling InfluxDB 2.0 Docker image and running..."

# Run InfluxDB container
docker run -d \
  --name influxdb2 \
  -p 8086:8086 \
  -v ~/influxdb/data:/var/lib/influxdb2 \
  -v ~/influxdb/config:/etc/influxdb2 \
  -e DOCKER_INFLUXDB_INIT_MODE=setup \
  -e DOCKER_INFLUXDB_INIT_USERNAME=admin \
  -e DOCKER_INFLUXDB_INIT_PASSWORD=admin#1234 \
  -e DOCKER_INFLUXDB_INIT_ORG=k6 \
  -e DOCKER_INFLUXDB_INIT_BUCKET=k6 \
  -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=my-super-secret-token \
  influxdb:2.7

# Wait a moment for the container to start
echo "Waiting for InfluxDB to start..."
sleep 5

# Check if container is running
if [ "$(docker ps -q -f name=influxdb2)" ]; then
    echo ""
    echo "InfluxDB 2.0 is now running."
    echo "You can access the web interface at: http://localhost:8086"
    echo ""
    echo "Pre-configured credentials:"
    echo "  Username: admin"
    echo "  Password: admin#1234"
    echo "  Organization: k6"
    echo "  Bucket: k6"
    echo "  API Token: my-super-secret-token"
    echo ""
    echo "To use with k6, add these to your environment:"
    echo "export INFLUXDB_TOKEN=my-super-secret-token"
    echo "export INFLUXDB_ORG=k6"
    echo "export INFLUXDB_BUCKET=k6"
    echo ""
    echo "Container management commands:"
    echo "  Start:   docker start influxdb2"
    echo "  Stop:    docker stop influxdb2"
    echo "  Remove:  docker rm influxdb2"
    echo "  Logs:    docker logs influxdb2"
else
    echo "Failed to start InfluxDB container. Check Docker logs."
fi
