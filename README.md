# k6 with InfluxDB 2.0 Output Extension

This repository contains scripts to build a custom k6 load testing tool with the InfluxDB 2.0 output extension. This setup allows you to run load tests and stream the results directly to an InfluxDB 2.0 instance without installing Go on your local machine.

## Overview

[k6](https://k6.io/) is a modern load testing tool, and this project adds the [xk6-output-influxdb](https://github.com/grafana/xk6-output-influxdb) extension to enable sending test results to InfluxDB 2.0.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your system
- Internet connection for downloading dependencies

## Quick Start

1. Clone this repository or download the build script
2. Make the script executable:
   ```bash
   chmod +x build-k6.sh
   ```
3. Run the build script:
   ```bash
   ./build-k6.sh
   ```
4. Once completed, you'll find the k6 binary with InfluxDB 2.0 support in the `output` directory

## Usage

### Running a k6 Test with InfluxDB 2.0 Output

```bash
./output/k6 run your-script.js --out influxdb=http://your-influxdb-host:8086/api/v2 \
  --env INFLUXDB_TOKEN=your-token \
  --env INFLUXDB_ORG=your-org \
  --env INFLUXDB_BUCKET=your-bucket
```

### Required Environment Variables

When sending metrics to InfluxDB 2.0, you need to set the following environment variables:

- `INFLUXDB_TOKEN`: Your InfluxDB authentication token
- `INFLUXDB_ORG`: Your InfluxDB organization name
- `INFLUXDB_BUCKET`: The bucket where metrics will be stored

### Optional Environment Variables

- `INFLUXDB_TAG_<NAME>`: Add custom tags to all metrics (replace `<NAME>` with your tag name)
- `INFLUXDB_PRECISION`: Timestamp precision (default: `1ns`)

## Example k6 Script

Here's a basic example test script (`example-script.js`):

```javascript
import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  const res = http.get('https://test.k6.io');
  sleep(1);
}
```

## Building with the Docker Image Directly

If you prefer to use the Docker image directly rather than extracting the binary:

```bash
# Build the image
docker build -t k6-influxdb2 .

# Run a test with the Docker image
docker run --rm -v $(pwd):/scripts k6-influxdb2 run /scripts/your-script.js \
  --out influxdb=http://your-influxdb-host:8086/api/v2 \
  --env INFLUXDB_TOKEN=your-token \
  --env INFLUXDB_ORG=your-org \
  --env INFLUXDB_BUCKET=your-bucket
```

**Note**: When running k6 in Docker, make sure your InfluxDB instance is accessible from within the container.

## Troubleshooting

### Network Issues

If you encounter network issues during the build:

1. Try running with host network mode:
   ```bash
   docker build --network host -t k6-influxdb2 .
   ```

2. If behind a corporate proxy:
   ```bash
   docker build --build-arg HTTP_PROXY=http://your-proxy:port \
                --build-arg HTTPS_PROXY=http://your-proxy:port \
                -t k6-influxdb2 .
   ```

3. Configure Docker DNS settings by editing `/etc/docker/daemon.json`:
   ```json
   {
     "dns": ["8.8.8.8", "8.8.4.4"]
   }
   ```
   Then restart Docker: `sudo systemctl restart docker`

## How It Works

The build process:

1. Creates a multi-stage Docker build
2. Uses the Go Alpine image to compile k6 with the InfluxDB 2.0 extension
3. Creates a minimal Alpine-based final image with just the k6 binary
4. Extracts the binary to your local machine for easy use

## License

This project is distributed under the same license as k6 and the xk6-output-influxdb extension.

## Resources

- [k6 Documentation](https://k6.io/docs/)
- [xk6-output-influxdb Repository](https://github.com/grafana/xk6-output-influxdb)
- [InfluxDB 2.0 Documentation](https://docs.influxdata.com/influxdb/v2.0/)
