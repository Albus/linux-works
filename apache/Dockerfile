FROM albus:ubuntu_latest_x64ru

RUN apt-get update && apt-get -q -y install apache2

EXPOSE 80/tcp

VOLUME ["/opt/1C"]

RUN ["/usr/sbin/apachectl","-DFOREGROUND"]
