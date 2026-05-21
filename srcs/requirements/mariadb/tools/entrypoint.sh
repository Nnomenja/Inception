#!/bin/bash
set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Colored echo function
echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

DATADIR="/var/lib/mysql"


if [ -d "${DATADIR}/mysql" ]; then
    echo_success "DATADIR already initialized, running directly..."
    exec "$@" --datadir="$DATADIR" --user=mysql
fi

# Initialize database if not exists
if [ ! -d "${DATADIR}/mysql" ]; then
    echo_info "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --ldata="${DATADIR}"

fi

# Require env vars
: "${MYSQL_ROOT_PASSWORD:?Need MYSQL_ROOT_PASSWORD}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"
: "${MYSQL_DB:?Need MYSQL_DB}"
: "${MYSQL_EXPORTER_PASSWORD:?Need MYSQL_EXPORTER_PASSWORD}"
: "${MYSQL_EXPORTER_USER:?Need MYSQL_EXPORTER_USER}"

#Read from secret files if paths are provided
if [ -f "$MYSQL_ROOT_PASSWORD" ]; then
    echo_info "Reading MYSQL_ROOT_PASSWORD from file: $MYSQL_ROOT_PASSWORD"
    MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD" | tr -d '\n\r')
    [ -z "$MYSQL_ROOT_PASSWORD" ] && { echo_error "MYSQL_ROOT_PASSWORD file is empty"; exit 1; }
    echo_success "MYSQL_ROOT_PASSWORD loaded from file"
fi

if [ -f "$MYSQL_USER_PASSWORD" ]; then
    echo_info "Reading MYSQL_USER_PASSWORD from file: $MYSQL_USER_PASSWORD"
    MYSQL_USER_PASSWORD=$(cat "$MYSQL_USER_PASSWORD" | tr -d '\n\r')
    [ -z "$MYSQL_USER_PASSWORD" ] && { echo_error "MYSQL_USER_PASSWORD file is empty"; exit 1; }
    echo_success "MYSQL_USER_PASSWORD loaded from file"
fi

if [ -f "$MYSQL_EXPORTER_PASSWORD" ]; then
    echo_info "Reading MYSQL_EXPORTER_PASSWORD from file: $MYSQL_EXPORTER_PASSWORD"
    MYSQL_EXPORTER_PASSWORD=$(cat "$MYSQL_EXPORTER_PASSWORD" | tr -d '\n\r')
    [ -z "$MYSQL_EXPORTER_PASSWORD" ] && { echo_error "MYSQL_EXPORTER_PASSWORD file is empty"; exit 1; }
    echo_success "MYSQL_EXPORTER_PASSWORD loaded from file"
fi

# Final validation - ensure passwords are not empty
[ -z "$MYSQL_ROOT_PASSWORD" ] && { echo_error "MYSQL_ROOT_PASSWORD is empty"; exit 1; }
[ -z "$MYSQL_USER_PASSWORD" ] && { echo_error "MYSQL_USER_PASSWORD is empty"; exit 1; }
[ -z "$MYSQL_EXPORTER_PASSWORD" ] && { echo_error "MYSQL_EXPORTER_PASSWORD is empty"; exit 1; }

echo_success "All required environment variables validated and loaded"

echo_info "Starting MariaDB in bootstrap mode..."

mariadbd --bootstrap --datadir=/var/lib/mysql --user=mysql << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER_NAME}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DB};
GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER_NAME}'@'%';
FLUSH PRIVILEGES;
CREATE USER IF NOT EXISTS '${MYSQL_EXPORTER_USER}'@'%' IDENTIFIED BY '${MYSQL_EXPORTER_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_EXPORTER_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo_success "Starting MariaDB in foreground..."

exec "$@"  --datadir="$DATADIR" "--user=mysql"

# exec /bin/bash
