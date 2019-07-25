FROM i386/ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
ENV NOTVISIBLE "in users profile"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN apt-get update && apt-get install -y locales wget && rm -rf /var/lib/apt/lists/* \
    && locale-gen --purge \
    && locale-gen en_US.UTF-8 ru_RU.UTF-8 \
    && update-locale --reset LANG=ru_RU.UTF-8 LC_NUMERIC=ru_RU.UTF-8 \
    && dpkg-reconfigure locales \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
ENV LANG ru_RU.UTF-8