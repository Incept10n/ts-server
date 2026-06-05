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

# Указываем версию
ARG TS_VERSION=3.13.8

RUN groupadd -g 1000 ts3 && \
    useradd -u 1000 -g ts3 -m -d /opt/ts3 -s /bin/bash ts3

# Скачиваем и распаковываем TeamSpeak Server
WORKDIR /opt/ts3
RUN wget -q https://files.teamspeak-services.com/releases/server/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 && \
    tar xjf teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 --strip-components=1 && \
    rm teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2 && \
    chown -R ts3:ts3 /opt/ts3

# Открываем порты
# 9987: Voice (UDP)
# 10011: ServerQuery (TCP)
# 30033: FileTransfer (TCP)
EXPOSE 9987/udp 10011/tcp 30033/tcp

USER ts3

CMD ["./ts3server_startscript.sh", "start"]
