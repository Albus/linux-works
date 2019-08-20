from alpine as alpine
add https://caddyserver.com/download/linux/amd64?license=personal&telemetry=off /caddy.tar.gz
run tar -v -xf /caddy.tar.gz
from scratch
copy --from=alpine /caddy /caddy
volume /ssl
env CADDYPATH=/ssl
workdir /
cmd ["/caddy","-agree","-env","-root /www"]
