############################################################
# Dockerfile to build borgbackup server images
# Based on Debian
############################################################
ARG BASE_IMAGE=debian:trixie-slim
FROM $BASE_IMAGE

LABEL org.opencontainers.image.source="https://github.com/georgh93/borgserver"

# Volume for SSH-Keys
VOLUME /sshkeys

# Volume for borg repositories
VOLUME /backup

# Volume for data
VOLUME /data

RUN apt-get update && apt-get -y --no-install-recommends install borgbackup openssh-server fish git rsync ncdu duf curl wget && apt-get clean
RUN useradd -s /bin/bash -m -U borg
RUN useradd -s /bin/fish -U -d /data data
RUN	mkdir /home/borg/.ssh && chmod 700 /home/borg/.ssh && chown borg:borg /home/borg/.ssh
RUN mkdir -p /run/sshd && rm -f /etc/ssh/ssh_host*key* &&  rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY ./data/run.sh /run.sh
COPY ./data/sshd_config /etc/ssh/sshd_config

# Default SSH-Port for clients
EXPOSE 22

ENTRYPOINT ["/run.sh"]
