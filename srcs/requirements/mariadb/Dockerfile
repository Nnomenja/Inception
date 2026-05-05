# Use Alpine as base image
FROM alpine:3.21

# Prevent interactive prompts and update repositories
ENV MYSQL_ROOT_PASSWORD=root

# Install MariaDB server and client
RUN apk update && apk add --no-cache \
    mariadb mariadb-client bash \
    su-exec \
    openrc \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld

# Expose MariaDB default port
EXPOSE 3306

# Copy a simple entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default command
CMD ["/entrypoint.sh"]