## ragent
```sh
docker volume create 1c-server
docker volume create 1c-server_data
# распаковываем дистрибутив в каталог /var/lib/docker/volumes/1c-server/_data/v8.3.13.1644/i386
```
```sh
docker run --name esina_x32ru -h esina -d \
-v `docker volume inspect 1c-server | jq -r ".[].Mountpoint"`/v8.3.13.1644/i386:/opt/1C:ro \
-v `docker volume inspect 1c-server_data | jq -r ".[].Mountpoint"`:/root/.1cv8/1C/1cv8:Z \
-p 1540-1541:1540-1541/tcp -p 1560-1591:1560-1591/tcp --restart always \
albus/linux-works:esina_x32ru /opt/1C/ragent /pingTimeout 1000 /pingPeriod 300 /debugServerAddr 192.168.0.1 /debugServerPort 1550 /debug -http
```

## crserver
```sh
docker volume create crserver_data
docker run --name crserver \
-v /var/lib/docker/volumes/1c-server/_data/v8.3.13.1644/i386:/opt/1C:ro \
-v `docker volume inspect crserver_data | jq -r ".[].Mountpoint"`:/root/.1cv8/1C/1cv8:Z --net host --restart always \
--hostname crserver -d albus/linux-works:ubuntu_latest_x32ru /opt/1C/crserver
```

## dbgs
```sh
docker volume create 1c-server
# распаковываем дистрибутив в каталог /var/lib/docker/volumes/1c-server/_data/v8.3.13.1644/x86_64
```
```sh
docker run --name dbgs \
-v `docker volume inspect 1c-server | jq -r ".[].Mountpoint"`/v8.3.13.1644/x86_64:/opt/1C:ro \
--net host --restart always --hostname dbgs \
-d ubuntu /opt/1C/dbgs --addr=0.0.0.0
```

## postgresql
```sh
# корень кластера
docker volume create postgresql_main
# табличное пространство pg_default
docker volume create postgresql_rows
# табличное пространство pg_global
docker volume create postgresql_glob
# табличное пространство для индексов (задел на будущее)
docker volume create postgresql_indx
# каталог хранения журналов предзаписи
docker volume create postgresql_wal
# каталог с настройками кластера
docker volume create postgresql_etc
```
```sh
docker run --name postgres --hostname postgres --restart always -p 5432:5432 \
-v `docker volume inspect postgresql_main | jq -r ".[].Mountpoint"`:/var/lib/postgresql/10/main:Z \
-v `docker volume inspect postgresql_rows | jq -r ".[].Mountpoint"`:/var/lib/postgresql/10/main/base:Z \
-v `docker volume inspect postgresql_glob | jq -r ".[].Mountpoint"`:/var/lib/postgresql/10/main/global:Z \
-v `docker volume inspect postgresql_indx | jq -r ".[].Mountpoint"`:/var/lib/postgresql/10/main/index:Z \
-v `docker volume inspect postgresql_wal  | jq -r ".[].Mountpoint"`:/var/lib/postgresql/10/main/pg_wal:Z \
-v `docker volume inspect postgresql_etc  | jq -r ".[].Mountpoint"`:/etc/postgresql/10/main:Z \
-d albus/linux-works:postgres_10.5_x64
```

## ras
```sh
docker volume create 1c-server
# распаковываем дистрибутив в каталог /var/lib/docker/volumes/1c-server/_data/v8.3.13.1644/x86_64
```
```sh
docker run --name ras --hostname ras \
-v `docker volume inspect 1c-server | jq -r ".[].Mountpoint"`/v8.3.13.1644/x86_64:/opt/1C:ro \
--net host --restart always -d ubuntu /opt/1C/ras cluster --port=1545
```
