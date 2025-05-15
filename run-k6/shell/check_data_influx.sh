#!/bin/bash

# Configuration
INFLUXDB_HOST="localhost"
INFLUXDB_PORT="8086"
INFLUXDB_ORG="k6org"
INFLUXDB_BUCKET="k6"
INFLUXDB_TOKEN="rHhei2clcpvMXZT3EciA6-NMc9yhYKTNsFQE14i4K5ybDY8vdnEV44_gIaHbWKHsKJdtoOR5FYDZC6FKJH0-lg=="

# Flux query to fetch the first few records
QUERY=$(cat <<EOF
from(bucket: "$INFLUXDB_BUCKET")
  |> range(start: -1h)
  |> limit(n: 10)
EOF
)

# Make a POST request to InfluxDB
RESPONSE=$(curl -s -X POST \
  "http://${INFLUXDB_HOST}:${INFLUXDB_PORT}/api/v2/query?org=${INFLUXDB_ORG}" \
  --header "Authorization: Token ${INFLUXDB_TOKEN}" \
  --header "Accept: application/csv" \
  --header "Content-type: application/vnd.flux" \
  --data "$QUERY")

# Check if data exists
if [[ -z "$RESPONSE" || "$RESPONSE" == *",,,"* ]]; then
  echo "❌ No data found in InfluxDB bucket '$INFLUXDB_BUCKET'."
  echo "Check if:"
  echo "1. The bucket exists."
  echo "2. k6 is correctly configured to write to InfluxDB."
  echo "3. The test has run and sent metrics."
else
  echo "✅ Data found in InfluxDB!"
  echo "Sample data (first 5 rows):"
  echo "$RESPONSE"
fi
