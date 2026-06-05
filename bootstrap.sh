#!/bin/bash

set -e

SOURCE_DIR="/opt/ts3-src"
TARGET_DIR="/opt/ts3"

if [ ! -f "$TARGET_DIR/ts3server_startscript.sh" ]; then
    echo "$(date): Initializing persistent volume with TeamSpeak files..."
    cp -rv $SOURCE_DIR/* $TARGET_DIR/
    echo "$(date): Initialization complete"
else
    echo "$(date): Files already exist in persistent volume, skipping copy"
fi

echo "$(date): Starting TeamSpeak server..."
exec $TARGET_DIR/ts3server_startscript.sh start license_accepted=1
