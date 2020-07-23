FROM albus/pg11-dist1c AS pg11-dist1c
FROM phusion/baseimage:0.10.2

ENV TZ=Europe/Moscow \
    DEBIAN_FRONTEND=noninteractive \
    KILL_PROCESS_TIMEOUT=300 KILL_ALL_PROCESSES_TIMEOUT=300 \
    DEBIAN_PRIORITY=critical \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    DEBCONF_NOWARNINGS=yes DEBCONF_TERSE=yes DEBCONF_NONINTERACTIVE_SEEN=true \
    LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8 LANGUAGE=ru_RU:en

RUN echo $TZ > /etc/timezone && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
 && locale-gen --purge en_US.UTF-8 ru_RU.UTF-8 ru_UA.UTF-8 \
 && update-locale --reset LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8 LANGUAGE=ru_RU:en

WORKDIR /bd_build

COPY --from=pg11-dist1c /*.deb ./deb/
COPY --from=pg11-dist1c /addon/ /root/addon/

ADD http://repo.postgrespro.ru/pgpro-11/keys/apt-repo-add.sh ./scripts/
ADD https://salsa.debian.org/postgresql/postgresql-common/raw/master/pgdg/apt.postgresql.org.sh ./scripts/

RUN chmod +x ./scripts/apt-repo-add.sh && ./scripts/apt-repo-add.sh \
 && chmod +x ./scripts/apt.postgresql.org.sh && ./scripts/apt.postgresql.org.sh -y \
 && apt-get install --no-install-recommends --no-upgrade --arch-only -yqq language-pack-ru tzdata \
 postgresql-client-common postgresql-common libicu55 libllvm6.0 libxml2 libxslt1.1 \
 && dpkg -i deb/libpq5_11.*.deb && dpkg -i deb/postgresql-client-11_11.*.deb \
 && apt-mark hold `find . -iname "*.deb" -exec dpkg-deb --field {} package \; | xargs` \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set create_main_cluster false \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set start_conf manual \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set ssl off \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set log_destination syslog \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set autovacuum on \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set autovacuum_max_workers 4 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set autovacuum_naptime 5s \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set bgwriter_delay 20ms \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set bgwriter_lru_multiplier 4.0 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set bgwriter_lru_maxpages 400 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set synchronous_commit off \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set fsync on \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set commit_delay 1000 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set commit_siblings 5 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set row_security off \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set temp_tablespaces 'TempTableSpace' \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set max_files_per_process 10000 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set standard_conforming_strings off \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set max_locks_per_transaction 256 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set max_connections 300 \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set plantuner.fix_empty_table 'on' \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set online_analyze.table_type 'temporary' \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set online_analyze.verbose 'off' \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set data_directory '/var/lib/postgresql/data/%v/%c' \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set waldir '/var/lib/postgresql/pg_wal/%v/%c' \
 && pg_conftool -v /etc/postgresql-common/createcluster.conf set stats_temp_directory '/var/lib/postgresql/pg_stat_tmp/%v/%c' \
 && dpkg -i deb/postgresql-11_11.*.deb && chmod -x /etc/init.d/postgresql \
 && apt-mark hold `find . -iname "*.deb" -exec dpkg-deb --field {} package \; | xargs` \
 && apt-get install --no-install-recommends --no-upgrade --arch-only -y -qq \
    man bash-completion ssh-import-id mc htop wget pg-probackup-std-11 \
 && apt-get install --no-install-recommends --no-upgrade --arch-only -f -y -qq

WORKDIR /root
EXPOSE 5432/tcp 22/tcp
HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=5s CMD ["pg_isready"]
STOPSIGNAL SIGTERM

RUN rm -f /etc/service/sshd/down \
    && chmod 755 /etc/container_environment \
    && chmod 644 /etc/container_environment.sh /etc/container_environment.json \
    && /etc/my_init.d/00_regen_ssh_host_keys.sh && ssh-import-id gh:albus \
    && /bd_build/cleanup.sh > /dev/null 2>&1 && apt-cache policy `apt-mark showhold | xargs`

CMD ["/sbin/my_init"]
