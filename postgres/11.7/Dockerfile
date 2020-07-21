FROM phusion/baseimage:latest-arm64
ENV KILL_PROCESS_TIMEOUT=300
ENV KILL_ALL_PROCESSES_TIMEOUT=300

RUN apt-get update
RUN apt-get install -y language-pack-ru
RUN apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get install -y bash-completion p7zip-full mc

ADD https://salsa.debian.org/postgresql/postgresql-common/raw/master/pgdg/apt.postgresql.org.sh /tmp
RUN /tmp/apt.postgresql.org.sh && rm -f /tmp/apt.postgresql.org.sh

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]
