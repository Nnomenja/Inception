FROM alpine:3.22

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    wget \
    tar \
    curl \
    bash

# Prometheus version (change as needed)
ENV PROMETHEUS_VERSION=2.54.1

# Download and install Prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
    && tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
    && mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 /etc/prometheus \
    && mv /etc/prometheus/prometheus /usr/local/bin/ \
    && mv /etc/prometheus/promtool /usr/local/bin/ \
    && mkdir -p /etc/prometheus/data \
    && rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

# Create config directory
COPY ./config/prometheus.yml /etc/prometheus/prometheus.yml

# Expose Prometheus port
EXPOSE 9090

# Run Prometheus
CMD ["prometheus", \
     "--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/etc/prometheus/data"]