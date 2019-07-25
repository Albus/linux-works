FROM albus/ubuntu:x64ru
EXPOSE 1550/tcp
WORKDIR /opt/1C
ENV PATH=/opt/1C:$PATH
STOPSIGNAL SIGINT
CMD ["dbgs"]
VOLUME /opt/1C
