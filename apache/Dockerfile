FROM albus/linux-works:ubuntu_latest_x64ru
RUN apt-get update && apt-get -q -y install apache2 && a2enmod rewrite
EXPOSE 80/tcp
VOLUME ["/opt/1C","/var/www/esina"]
CMD ["/usr/sbin/apachectl","-DFOREGROUND","-c/var/www/esina/*.conf"]
