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

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo_info "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --ldata=/var/lib/mysql
fi

# Require env vars
: "${ROOT_PASSWORD:?Need ROOT_PASSWORD}"
: "${USER_NAME:?Need USER_NAME}"
: "${USER_PASSWORD:?Need USER_PASSWORD}"

echo_info "Starting temporary MariaDB..."

mariadbd-safe \
    --datadir="$DATADIR" \
    --skip-networking &

MYSQL_PID=$!

# Wait until server is ready
echo_warn "Waiting for MariaDB to be ready..."

until mariadb-admin \
    ping --silent; do
    sleep 1
done

echo_success "MariaDB started"

echo_info "Setting up root and application user..."
mariadb -u root -p"${ROOT_PASSWORD}" << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

echo_success "Root user setup completed."
mariadb -u root -p"${ROOT_PASSWORD}" -e \
"CREATE USER IF NOT EXISTS '${USER_NAME}'@'%' IDENTIFIED BY '${USER_PASSWORD}'; GRANT ALL PRIVILEGES ON *.* TO '${USER_NAME}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"


echo_info "Stopping temporary MariaDB..."

mariadb-admin  shutdown -u root -p"${ROOT_PASSWORD}"

wait "$MYSQL_PID"

echo_success "Starting MariaDB in foreground..."

exec "$@"   