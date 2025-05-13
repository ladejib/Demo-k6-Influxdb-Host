#!/bin/bash
# Shell script to build k6 with InfluxDB 2.0 extension using Docker with Go version compatibility fix

# Create a Docker build context directory
mkdir -p k6-influxdb-build
cd k6-influxdb-build

# Create Dockerfile with explicit repository configuration and xk6 version pinning
cat > Dockerfile << 'EOF'
FROM golang:1.21-alpine3.19 AS builder

# Configure Alpine repositories and install git and build essentials
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache git gcc musl-dev

# Create and set working directory
WORKDIR /build

# Clone k6 repo
RUN git clone --depth 1 https://github.com/grafana/k6.git .

# Install a specific version of xk6 compatible with Go 1.21
RUN go install go.k6.io/xk6/cmd/xk6@v0.9.2

# Clone the InfluxDB 2.0 output extension 
RUN git clone --depth 1 https://github.com/grafana/xk6-output-influxdb.git /xk6-output-influxdb

# Build k6 with the InfluxDB 2.0 extension
RUN xk6 build \
  --with github.com/grafana/xk6-output-influxdb=/xk6-output-influxdb \
  --output /tmp/k6

# Create a minimal final image
FROM alpine:3.19 AS final

# Configure Alpine repositories and install CA certificates
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache ca-certificates

# Copy the k6 binary from the builder stage
COPY --from=builder /tmp/k6 /usr/bin/k6

# Set k6 as the entrypoint
ENTRYPOINT ["k6"]
EOF

echo "Building k6 with InfluxDB 2.0 extension..."
docker build -t k6-influxdb2 .

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "Build failed. Trying alternative approach with network mode..."
    
    # Try with host network mode
    docker build --network host -t k6-influxdb2 .
    
    # If still failing, provide guidance
    if [ $? -ne 0 ]; then
        echo "Build is still failing. This might be due to network connectivity issues."
        echo "Please check your internet connection and try again."
        echo "You may also try building with a proxy if you're behind a corporate firewall:"
        echo "docker build --build-arg HTTP_PROXY=http://your-proxy:port --build-arg HTTPS_PROXY=http://your-proxy:port -t k6-influxdb2 ."
        exit 1
    fi
fi

echo "Extracting the built k6 binary..."
mkdir -p output
docker create --name temp-k6-container k6-influxdb2
docker cp temp-k6-container:/usr/bin/k6 ./output/k6
docker rm temp-k6-container

echo "Done! The k6 binary with InfluxDB 2.0 extension is available in the 'output' directory."
echo "You can run it using: ./output/k6 run your-script.js --out influxdb=http://your-influxdb-host:8086/api/v2"