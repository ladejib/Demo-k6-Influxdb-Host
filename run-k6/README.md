https://github.com/grafana/xk6-output-influxdb?tab=readme-ov-file

docker-compose run --rm k6 run /scripts/test.js

docker-compose down -v

docker compose up -d grafana influxdb --build 

influxdb  | 2025-05-14T15:54:38.555146840Z	warn	cleaning bolt and engine files to prevent conflicts on retry	{"system": "docker", "bolt_path": "/var/lib/influxdb2/influxd.bolt", "engine_path": "/var/lib/influxdb2/engine"}

docker-compose down -v
rm -rf ./influxdb-data
rm -rf ./influxdb
docker-compose up --build


