# Используем Alpine Linux для минимального размера
FROM alpine:3.19

# Указываем версию
ARG TS_VERSION=3.13.8

# Устанавливаем зависимости (tar для распаковки, bash для скриптов)
RUN apk add --no-cache tar bzip2 wget bash

# Создаем пользователя для запуска (запуск от root не рекомендуется)
RUN addgroup -g 1000 ts3 && \
    adduser -D -u 1000 -G ts3 -h /opt/ts3 ts3

# Скачиваем и распаковываем TeamSpeak Server
WORKDIR /opt/ts3
RUN wget -q https://files.teamspeak-services.com/releases/server/${TS_VERSION}/teamspeak3-server_linux_alpine-${TS_VERSION}.tar.bz2 && \
    tar xjf teamspeak3-server_linux_alpine-${TS_VERSION}.tar.bz2 --strip-components=1 && \
    rm teamspeak3-server_linux_alpine-${TS_VERSION}.tar.bz2 && \
    chown -R ts3:ts3 /opt/ts3

# Копируем скрипт запуска (опционально, но полезно для принятия лицензии)
COPY --chown=ts3:ts3 entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Открываем порты
# 9987: Voice (UDP)
# 10011: ServerQuery (TCP)
# 30033: FileTransfer (TCP)
EXPOSE 9987/udp 10011/tcp 30033/tcp

USER ts3
WORKDIR /opt/ts3

ENTRYPOINT ["/entrypoint.sh"]
