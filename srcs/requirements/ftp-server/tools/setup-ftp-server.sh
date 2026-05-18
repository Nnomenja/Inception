#!/bin/bash


set -e

CONFIG_PATH="/etc/vsftpd/vsftpd.conf"
FTP_DIR="/srv/ftpfiles"

# Default values
: "${FTP_USER:?Need FTP_USER}"
: "${FTP_PASSWORD:?Need FTP_PASSWORD}"

if [ -f "$FTP_PASSWORD" ]; then
    FTP_PASSWORD=$(cat "$FTP_PASSWORD" | tr -d '\n\r')
fi

if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser -D -h "$FTP_DIR" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Create directories
mkdir -p "$FTP_DIR"
chown -R "$FTP_USER:$FTP_USER" "$FTP_DIR"

exec "$@" "$CONFIG_PATH"