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
: "${MYSQL_ROOT_PASSWORD:?Need MYSQL_ROOT_PASSWORD}"
: "${MYSQL_USER_NAME:?Need MYSQL_USER_NAME}"
: "${MYSQL_USER_PASSWORD:?Need MYSQL_USER_PASSWORD}"

# Read from secret files if paths are provided
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

# Final validation - ensure passwords are not empty
[ -z "$MYSQL_ROOT_PASSWORD" ] && { echo_error "MYSQL_ROOT_PASSWORD is empty"; exit 1; }
[ -z "$MYSQL_USER_PASSWORD" ] && { echo_error "MYSQL_USER_PASSWORD is empty"; exit 1; }

echo_success "All required environment variables validated and loaded"

echo_info "Starting temporary MariaDB..."

mariadbd-safe \
    --datadir="$DATADIR" \
    --skip-networking &

MYSQL_PID=$!

# Wait until server is ready
echo_warn "Waiting for MariaDB to be ready..."

TIMEOUT=30
COUNTER=0

until mariadb-admin ping --silent; do
    if [ $COUNTER -ge $TIMEOUT ]; then
        echo_error "Timeout waiting for MariaDB to start"
        exit 1
    fi
    
    echo -n "."
    sleep 1
    COUNTER=$((COUNTER + 1))
done

echo_success "MariaDB started"

echo_info "Setting up root and application user..."
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

echo_success "Root user setup completed."
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
"CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}'; GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER_NAME}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"


echo_info "Stopping temporary MariaDB..."

mariadb-admin  shutdown -u root -p"${MYSQL_ROOT_PASSWORD}"

wait "$MYSQL_PID"

echo_success "Starting MariaDB in foreground..."

exec "$@"  --datadir="$DATADIR" "--user=mysql"