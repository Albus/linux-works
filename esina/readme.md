** ragent
```sh
docker run --name esina_x32ru -h esina -d \
-v `docker volume inspect 1c-server | jq -r ".[].Mountpoint"`/v8.3.13.1644/i386:/opt/1C:ro \
-v 1c-server_data:/root/.1cv8/1C/1cv8:Z \
-p 1540-1541:1540-1541/tcp -p 1560-1591:1560-1591/tcp \
albus/linux-works:esina_x32ru /opt/1C/ragent /pingTimeout 1000 /pingPeriod 300 /debugServerAddr 192.168.0.1 /debugServerPort 1550 /debug -http
```
