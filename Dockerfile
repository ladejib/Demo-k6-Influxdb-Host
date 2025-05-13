FROM golang:1.24.0 AS builder

# Install git and build essentials
RUN apk add --no-cache git gcc musl-dev

# Create and set working directory
WORKDIR /build

# Clone k6 repo
RUN git clone --depth 1 https://github.com/grafana/k6.git .

# Clone the xk6 repo (the k6 extension builder)
RUN go install go.k6.io/xk6/cmd/xk6@latest

# Clone the InfluxDB 2.0 output extension 
RUN git clone --depth 1 https://github.com/grafana/xk6-output-influxdb.git /xk6-output-influxdb

# Build k6 with the InfluxDB 2.0 extension
RUN xk6 build \
  --with github.com/grafana/xk6-output-influxdb=/xk6-output-influxdb \
  --output /tmp/k6

# Create a minimal final image
FROM alpine:latest

# Install CA certificates for HTTPS requests
RUN apk add --no-cache ca-certificates

# Copy the k6 binary from the builder stage
COPY --from=builder /tmp/k6 /usr/bin/k6

# Set k6 as the entrypoint
ENTRYPOINT ["k6"]
