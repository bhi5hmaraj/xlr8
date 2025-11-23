# Self-Hosting: BookStack + Nginx Proxy Manager

A Docker-based self-hosting recipe for running two BookStack instances (personal + public) with Nginx Proxy Manager.

## Overview

- **BookStack**: Knowledge base / wiki
- **Nginx Proxy Manager**: Reverse proxy + TLS termination
- **MariaDB**: Database for each BookStack instance
- **Architecture**: Each instance has its own DB; shared proxy network

## Prerequisites

- Domain & DNS: Two DNS A records (personal.example.com, public.example.com)
- Ports: 80, 443, 81 (NPM admin)
- Docker + Compose v2

## Step 1: Install Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
docker version
```

## Step 2: Shared Docker Network

```bash
docker network create proxy
```

## Step 3: Deploy Nginx Proxy Manager

Create `/opt/nginx-proxy-manager/docker-compose.yml`:

```yaml
version: "3.8"

services:
  npm:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    networks:
      - proxy

networks:
  proxy:
    external: true
```

Launch:
```bash
cd /opt/nginx-proxy-manager
docker compose up -d
```

Initial login: admin@example.com / changeme

