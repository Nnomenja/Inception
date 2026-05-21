#!/bin/sh
set -e

if [ -z "$MYSQL_EXPORTER_PASSWORD" ]; then
  echo "ERROR: password file not set"
  exit 1
fi

if [ ! -f "$MYSQL_EXPORTER_PASSWORD" ]; then
  echo "ERROR: file not found"
  exit 1
fi

PASSWORD="$(cat "$MYSQL_EXPORTER_PASSWORD" | tr -d '\n\r ')"

if [ -z "$PASSWORD" ]; then
  echo "ERROR: empty password"
  exit 1
fi

# USER="${MARIADB_EXPORTER_USER:-exporter}"
# HOST="${MARIADB_HOST:-mariadb}"
# PORT="${MARIADB_PORT:-3306}"

# echo "Starting mysqld_exporter..."

# exec "$@" \
#   --mysqld.username="$USER" \
#   --mysqld.password="$PASSWORD" \
#   --mysqld.address="$HOST:$PORT"

# # exec "sh"

# Generate temporary my.cnf file
TMP_CNF=$(mktemp)
chmod 600 "$TMP_CNF"

cat > "$TMP_CNF" <<EOF
[client]
user=$MYSQL_EXPORTER_USER
password=$PASSWORD
host=mariadb
port=3306
EOF

# Start mysqld_exporter with generated config
exec "$@" --config.my-cnf="$TMP_CNF"