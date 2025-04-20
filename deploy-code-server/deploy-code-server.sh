#!/bin/bash

# Usage: ./deploy-code-server.sh root@IP [PORT] [PASSWORD]

REMOTE="$1"
PORT="${2:-8080}"
PASSWORD="${3:-changeme123}"
SCRIPT_NAME="install-code-server.sh"
CADDY_SCRIPT_NAME="setup-caddy-selfsigned.sh"

if [ -z "$REMOTE" ]; then
  echo "Usage: $0 user@host [port] [password]"
  exit 1
fi

# Escape single quotes for safe remote execution
ESCAPED_PASSWORD=$(printf "%s" "$PASSWORD" | sed "s/'/'\\\\''/g")

echo "[*] Copying install script to $REMOTE..."
scp "$SCRIPT_NAME" "$REMOTE:/root/$SCRIPT_NAME"

echo "[*] Copying caddy script to $REMOTE..."
scp "$CADDY_SCRIPT_NAME" "$REMOTE:/root/$CADDY_SCRIPT_NAME"

echo "[*] Executing script on $REMOTE with port=$PORT and password=[hidden]"
ssh "$REMOTE" "bash /root/$SCRIPT_NAME $PORT '$ESCAPED_PASSWORD'"

echo "[*] Setting up https self-signed with caddy on $REMOTE"
ssh "$REMOTE" "bash /root/$CADDY_SCRIPT_NAME $PORT"
