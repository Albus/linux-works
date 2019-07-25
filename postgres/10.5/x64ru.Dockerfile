FROM albus/linux-works:ubuntu_xenial_x64ru

ADD https://github.com/Albus/linux-works/raw/master/postgres/10.5/postgresql_10.5_24.1C_amd64_deb.tar.bz2 /deb/

RUN . /etc/lsb-release \
&& apt-get update \
&& apt-get install gnupg2 --no-install-recommends \
&& echo deb http://apt.postgresql.org/pub/repos/apt/ $DISTRIB_CODENAME-pgdg main > /etc/apt/sources.list.d/postgresql.list \
&& wget -q -O - http://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
&& mkdir -p /etc/postgresql-common/createcluster.d \
&& echo create_main_cluster = true >> /etc/postgresql-common/createcluster.d/settings.conf \
&& echo initdb_options = "-k" >> /etc/postgresql-common/createcluster.d/settings.conf \
&& tar -xf /deb/postgresql_10.5_24.1C_amd64_deb.tar.bz2 -C /deb \
&& dpkg -i /deb/*.deb 2>/dev/null || exit 0

RUN apt-mark hold `find /deb -iname "*\.deb" -exec dpkg-deb --field {} package \; | xargs` \
&& apt-get update && apt-get install -f -y

ENV PATH=$PATH:/usr/lib/postgresql/10/bin/ PGDATA=/var/lib/postgresql/10/main
EXPOSE 5432/tcp
HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=5s CMD ["pg_isready"]
STOPSIGNAL SIGSTOP
WORKDIR $PGDATA
USER postgres
CMD ["pg_ctlcluster","--foreground","10","main","start"]
VOLUME $PGDATA