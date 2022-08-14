FROM debian:bullseye-slim
LABEL maintainer "Chihiro Hasegawa"

RUN apt-get update -y && \
    apt-get install -y openssh-server git less vim sudo iproute2 procps curl tcpdump wget rsyslog && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd && \
    useradd -m chihiro -s /bin/bash && \
    usermod -aG sudo chihiro && \
    echo 'chihiro    ALL=NOPASSWD: ALL' > /etc/sudoers.d/chihiro && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

WORKDIR /home/chihiro/
USER chihiro

RUN mkdir -m 700 .ssh && \
    wget https://github.com/owlinux1000.keys -O .ssh/authorized_keys && \
    chmod 600 .ssh/authorized_keys

ENTRYPOINT ["sudo", "/usr/sbin/sshd"]
CMD ["-D", "-e"]