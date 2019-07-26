*crserver
```sh
docker run --name crserver \
-v /var/lib/docker/volumes/1c-server/_data/v8.3.13.1644/i386:/opt/1C:ro \
-v crserver_data:/root/.1cv8/1C/1cv8:Z --net host --restart always \
--hostname crserver -d albus/linux-works:ubuntu_latest_x32ru /opt/1C/crserver
```
*dbgs
```sh
docker run --name dbgs \
-v /var/lib/docker/volumes/1c-server/_data/v8.3.13.1644/x86_64:/opt/1C:ro \
--net host --restart always --hostname dbgs \
-d ubuntu /opt/1C/dbgs --addr=0.0.0.0
```
