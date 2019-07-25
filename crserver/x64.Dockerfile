FROM albus/linux-works:ubuntu_latest_x64ru
EXPOSE 1542/tcp 1542/udp
WORKDIR /opt/1C
ENV PATH=/opt/1C:$PATH
STOPSIGNAL SIGINT
CMD ["crserver"]
VOLUME /root/.1cv8/1C/1cv8
VOLUME /opt/1C
