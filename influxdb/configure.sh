#!/bin/bash
# Script to install InfluxDB 2.0 on macOS using Homebrew

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install InfluxDB
echo "Installing InfluxDB 2.0..."
brew install influxdb

# Start InfluxDB service
echo "Starting InfluxDB service..."
brew services start influxdb

# Verify installation
echo "Verifying installation..."
sleep 5 # Give it a moment to start
influx version

echo ""
echo "InfluxDB 2.0 has been installed and started."
echo "Open http://localhost:8086 in your browser to complete setup."
echo ""
echo "Initial setup will require you to:"
echo "1. Create an organization"
echo "2. Create a username and password"
echo "3. Create an initial bucket for data storage"
echo "4. Generate an API token for your k6 tests"
echo ""
echo "After setup, you can use the following commands:"
echo "- Start: brew services start influxdb"
echo "- Stop: brew services stop influxdb"
echo "- Restart: brew services restart influxdb"
echo "- Status: brew services list | grep influxdb"
