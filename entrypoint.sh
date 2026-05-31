#!/bin/bash
# entrypoint.sh

set -e

# Если инвайт-ключ (privilege key) еще не создан (первый запуск), создаем его
# TeamSpeak сам создает файл в директории, но мы можем просто запустить процесс

echo "Starting TeamSpeak 3 Server..."

# Запускаем сервер, передавая все аргументы
# Используем exec, чтобы процесс заменил bash и корректно принимал сигналы (SIGTERM)
exec ts3server "$@"
