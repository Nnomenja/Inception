

# User Documentation

This document provides instructions for end users and administrators to understand, operate, and manage the Inception.A project stack.

---

## 1. Overview of Services

This project is **Inception.A**, a 42school project designed to learn Docker. The goal is to set up a small infrastructure composed of multiple services under specific rules, all within a virtual machine using **Docker Compose**.

All services are installed in **Alpine containers** (built from scratch, not from Docker Hub).

The project includes the following services:

* **nginx** – Web server and reverse proxy.
* **WordPress + FTP Server** – Content management system with FTP access.
* **MariaDB** – Database server for WordPress.
* **Exporters** – Monitoring exporters for Prometheus:

  * `mysqld_exporter`
  * `nginx-prometheus-exporter`
  * `php-fpm-exporter`
* **Prometheus** – Monitoring and alerting system.
* **Redis** – In-memory key-value store.

---

## 2. Starting and Stopping the Project

### 2.1 Starting the Project

1. Open a terminal in your virtual machine.
2. Navigate to the project root directory.
3. Run the start command:

   ```bash
   make up
   ```
4. Verify that all services are initializing correctly using the health checks below.

### 2.2 Stopping the Project

1. Open a terminal in your virtual machine.
2. Navigate to the project root directory.
3. Run the stop command:

   ```bash
   make down
   ```
4. Ensure all services have stopped.

---

## 3. Accessing the Website and Administration Panel

### 3.1 Website

* **WordPress Home Page:** [https://nnomenja.42.fr](https://nnomenja.42.fr)
* **Resume Page:** [https://nnomenja.42.fr/resume](https://nnomenja.42.fr/resume)

### 3.2 Administration Panel

* **WordPress Admin:** [https://nnomenja.42.fr/wp-admin.php](https://nnomenja.42.fr/wp-admin.php)
* **Prometheus:** [http://localhost:9000/target](http://localhost:9000/target)

---

## 4. Locating and Managing Credentials

All credentials can be found and managed from the **project root directory**:

* **Docker Compose Config:** `srcs/docker-compose.yml`
* **Environment Variables:** `srcs/.env`
* **Secrets Folder:** `/secrets`

> **Note:** Do not commit credentials to version control. Update passwords and API keys safely in `.env` or `/secrets`.

---

## 5. Verifying Service Health

Check that services are running correctly using the following methods:

1. **Prometheus Dashboard:**

   * Open [http://localhost:9000/target](http://localhost:9000/target)
   * Each target will show **UP** or **DOWN**.

2. **Docker Status:**

   ```bash
   docker ps -a
   ```

   * Verify all containers are running and healthy.

---

## 6. Troubleshooting

### Error During Build

* **Cause:** Connection issues or server saturation.
* **Solution:** Run the build command again:

  ```bash
  make build
  ```

 Tip: Always check logs if services fail to start. Logs can be found in the container using:

```bash
docker logs <container_name>
```
