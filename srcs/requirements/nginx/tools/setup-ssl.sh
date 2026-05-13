#!/bin/bash

# Certificate subject variables
COUNTRY="US"
STATE="State"
CITY="City"
ORGANIZATION="Development"
COMMON_NAME="nnomenja"

# Create SSL directory
mkdir -p /etc/nginx/ssl

# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt \
  -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${ORGANIZATION}/CN=${COMMON_NAME}"

# Set permissions
chmod 600 /etc/nginx/ssl/nginx.key
chmod 644 /etc/nginx/ssl/nginx.crt

exec "$@"