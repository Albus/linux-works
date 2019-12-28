FROM albus/linux-works:ubuntu_latest_x64ru
ENV NOTVISIBLE "in users profile"
RUN apt-get update && apt-get upgrade -y \
&& apt-get install software-properties-common -y \
&& add-apt-repository ppa:ondrej/php -y \
&& apt-get install openssh-server php-gearman php-xdebug bash-completion mc -y \
&& mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd \
&& sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& echo Ciphers aes256-ctr,aes128-ctr,aes256-cbc,aes128-cbc >> /etc/ssh/sshd_config \
&& echo KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1 >> /etc/ssh/sshd_config \
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
&& echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
