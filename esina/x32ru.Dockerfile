FROM albus/linux-works:ubuntu_latest_x32ru

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer \
	&& fc-cache -f -v
	
EXPOSE 1540-1541/tcp 1560-1591/tcp
WORKDIR /opt/1C
ENV PATH=/opt/1C:$PATH
STOPSIGNAL SIGINT
CMD ["ragent"]
VOLUME /root/.1cv8/1C/1cv8
VOLUME /opt/1C
