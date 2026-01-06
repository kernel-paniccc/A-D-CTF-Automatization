#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="docker-compose.yml"
COMPOSE_CMD="docker compose"

ssh-keygen -R '[127.0.0.1]:5001'
ssh-keygen -R '[127.0.0.1]:5002'

ssh-keygen -R 172.28.0.11
ssh-keygen -R 172.28.0.12

echo "[*] Building image and starting ctf1/ctf2 containers..."
${COMPOSE_CMD} -f "${COMPOSE_FILE}" up -d --build

echo "[*] Active containers:"
${COMPOSE_CMD} -f "${COMPOSE_FILE}" ps

echo "[*] Container IPs on ctf_net:"
${COMPOSE_CMD} -f "${COMPOSE_FILE}" ps -q | xargs -r docker inspect -f '{{ .Name }} -> {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

cat <<'EOF'
    ssh root@172.28.0.11         # ctf1
    ssh root@172.28.0.12         # ctf2
EOF
