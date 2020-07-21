FROM phusion/baseimage:latest-arm64
ENV KILL_PROCESS_TIMEOUT=300, KILL_ALL_PROCESSES_TIMEOUT=300
ENV DEBIAN_FRONTEND=noninteractive, NOTVISIBLE="in users profile", APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN locale-gen --purge en_US.UTF-8 ru_RU.UTF-8 ru_UA.UTF-8
RUN update-locale --reset LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8 LANGUAGE=ru_RU:en
ENV LANG=ru_RU.UTF-8, LC_ALL=ru_RU.UTF-8, LANGUAGE=ru_RU:en

WORKDIR /tmp
ADD https://salsa.debian.org/postgresql/postgresql-common/raw/master/pgdg/apt.postgresql.org.sh .
RUN chmod +x ./apt.postgresql.org.sh && ./apt.postgresql.org.sh -y && rm -f ./apt.postgresql.org.sh
RUN apt-get install -y -qq language-pack-ru bash-completion p7zip-full mc
#RUN apt-get upgrade -y -o Dpkg::Options::="--force-confold"

WORKDIR /deb
ADD https://github.com/Albus/linux-works/raw/master/postgres/11.7/postgres.zip .
RUN 7z e postgres.zip && dpkg -R -i * 2>/dev/null || exit 0
RUN apt-mark hold `find . -iname "*\.deb" -exec dpkg-deb --field {} package \; | xargs`
RUN apt-get install -f -y -qq

WORKDIR /root
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN apt-get clean -qq && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]
