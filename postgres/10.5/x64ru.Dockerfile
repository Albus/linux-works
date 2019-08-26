FROM albus/linux-works:ubuntu_xenial_x64ru

ENV PATH=$PATH:/usr/lib/postgresql/10/bin/ PGDATA=/var/lib/postgresql/10/main

ADD https://github.com/Albus/linux-works/raw/master/postgres/10.5/postgresql_10.5_24.1C_amd64_deb.tar.bz2 /deb/
ADD https://raw.githubusercontent.com/Albus/linux-works/master/postgres/10.5/postgresql.list /etc/apt/sources.list.d/
ADD https://www.postgresql.org/media/keys/ACCC4CF8.asc /deb/
ADD https://raw.githubusercontent.com/Albus/linux-works/master/postgres/10.5/postgresql-common.conf /etc/postgresql-common/createcluster.d/
ADD https://raw.githubusercontent.com/Albus/linux-works/master/postgres/10.5/tablespaces.conf /etc/postgresql/10/main/conf.d/

WORKDIR /deb

RUN apt-key add ACCC4CF8.asc && apt-get update \
&& apt-get install bzip2 mc --no-install-recommends -y -qq \
&& tar -v -xf postgresql_10.5_24.1C_amd64_deb.tar.bz2

RUN dpkg -R -i * 2>/dev/null || exit 0

RUN apt-mark hold `find . -iname "*\.deb" -exec dpkg-deb --field {} package \; | xargs` \
&& apt-get update -qq \
&& apt-get install -f -y -qq \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& rm -rf /deb

RUN ln -s /etc/postgresql/10/main $PGDATA/etc \
&& mkdir -p $PGDATA/index \
&& chown postgres:postgres -R /etc/postgresql \
&& chown postgres:postgres -R /var/lib/postgresql

EXPOSE 5432/tcp
HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=5s CMD ["pg_isready"]
STOPSIGNAL SIGSTOP
WORKDIR $PGDATA
CMD ["pg_ctlcluster","--foreground","10","main","start"]

USER postgres

VOLUME $PGDATA
VOLUME /etc/postgresql/10/main
