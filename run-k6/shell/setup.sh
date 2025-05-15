#!/bin/bash

# Wait for InfluxDB to be ready
echo "Waiting for InfluxDB to be ready..."
until curl -s "http://localhost:8086/health" > /dev/null; do
  sleep 1
done

# Create the token file for k6 to use
echo "Setting up InfluxDB for k6..."
curl -s -X POST http://localhost:8086/api/v2/setup \
  -H 'Content-Type: application/json' \
  --data '{
    "username": "admin",
    "password": "adminpassword",
    "org": "k6org",
    "bucket": "k6",
    "token": "my-super-secret-auth-token"
  }'

echo "Setup complete!"
