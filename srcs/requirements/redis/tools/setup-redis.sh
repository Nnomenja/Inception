#!/bin/bash

set -e

: "${REDIS_PASSWORD:?Need REDIS_PASSWORD}"

#Read from secret files if paths are provided
echo "redis pass: $REDIS_PASSWORD"
if [ -f "$REDIS_PASSWORD" ]; then
    REDIS_PASSWORD=$(cat "$REDIS_PASSWORD" | tr -d '\n\r')
fi


exec "$@" /etc/redis.conf --requirepass "$REDIS_PASSWORD"
