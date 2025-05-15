curl -i -X POST "http://localhost:8086/api/v2/write?org=k6org&bucket=k6" \
  --header "Authorization: Token rHhei2clcpvMXZT3EciA6-NMc9yhYKTNsFQE14i4K5ybDY8vdnEV44_gIaHbWKHsKJdtoOR5FYDZC6FKJH0-lg==" \
  --data-raw "test,host=localhost value=1"

curl http://localhost:8086/api/v2/orgs -H "Authorization: Token rHhei2clcpvMXZT3EciA6-NMc9yhYKTNsFQE14i4K5ybDY8vdnEV44_gIaHbWKHsKJdtoOR5FYDZC6FKJH0-lg=="
