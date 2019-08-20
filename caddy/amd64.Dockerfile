from alpine as alpine
add https://caddyserver.com/download/linux/amd64?license=personal&telemetry=off /caddy.tar.gz
run tar -v -xf /caddy.tar.gz && touch /index.html
from scratch
copy --from=alpine /caddy /caddy
copy --from=alpine /index.html /www/index.html
volume /ssl
env CADDYPATH=/ssl
workdir /
cmd ["/caddy","-agree","-env","-root /www"]
