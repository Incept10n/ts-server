FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    libmariadb3 \
    libpq5 \
    libsqlite3-0 \
    tar \
    bzip2 \
    wget \
    bash \
    && rm -rf /var/lib/apt/lists/*

ARG TS_VERSION=3.13.8

WORKDIR /opt/ts3
RUN wget -q https://files.teamspeak-services.com/releases/server/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 && \
    tar xjf teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 --strip-components=1 && \
    rm teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 && \
    chown -R ts3:ts3 /opt/ts3

EXPOSE 9987/udp 10011/tcp 30033/tcp

# ENTRYPOINT ["/opt/ts3/ts3server_startscript.sh"]
# CMD ["license_accepted=1"]
ENTRYPOINT ["/bin/bash", "-c", "/opt/ts3/ts3server_startscript.sh start license_accepted=1"]
