#!/bin/bash
set -e

# Usage: ./deploy-code-server.sh root@IP [--port PORT] [--password PASSWORD]

SCRIPT_NAME="install-code-server.sh"
THEME_SCRIPT_NAME="set-up-theme.sh"
DOCKER_SCRIPT_NAME="install-docker.sh"
EXTENSIONS_SCRIPT_NAME="install-extensions.sh"
CADDY_SCRIPT_NAME="setup-caddy-selfsigned.sh"


# Extract remote host as first argument
REMOTE="$1"
shift

if [[ -z "$REMOTE" ]]; then
  echo "Usage: $0 user@host [--port <port>] [--password <password>]"
  exit 1
fi

# Defaults
PORT="8080"
PASSWORD="changeme123"

# Parse named args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --port)
      PORT="$2"
      shift 2
      ;;
    --password)
      PASSWORD="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--port <port>] [--password <password>]"
      exit 1
      ;;
  esac
done

# Validate PORT (if specified)
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
  echo "Invalid port: '$PORT'. Must be a number between 1 and 65535."
  exit 1
fi


if [ -z "$REMOTE" ]; then
  echo "Usage: $0 user@host [port] [password]"
  exit 1
fi

# Escape single quotes for safe remote execution
ESCAPED_PASSWORD=$(printf "%s" "$PASSWORD" | sed "s/'/'\\\\''/g")

echo "[*] Copying install script to $REMOTE..."
scp "$SCRIPT_NAME" "$REMOTE:/root/$SCRIPT_NAME"

echo "[*] Copying theme script to $REMOTE..."
scp "$THEME_SCRIPT_NAME" "$REMOTE:/root/$THEME_SCRIPT_NAME"

echo "[*] Copying docker script to $REMOTE..."
scp "$DOCKER_SCRIPT_NAME" "$REMOTE:/root/$DOCKER_SCRIPT_NAME"

echo "[*] Copying extensions script to $REMOTE..."
scp "$EXTENSIONS_SCRIPT_NAME" "$REMOTE:/root/$EXTENSIONS_SCRIPT_NAME"

echo "[*] Copying caddy script to $REMOTE..."
scp "$CADDY_SCRIPT_NAME" "$REMOTE:/root/$CADDY_SCRIPT_NAME" 



echo "[*] Executing script on $REMOTE with port=$PORT and password=[hidden]"
ssh "$REMOTE" "bash /root/$SCRIPT_NAME $PORT '$ESCAPED_PASSWORD'"

echo "[*] Setting up default theme for code-server on $REMOTE"
ssh "$REMOTE" "bash /root/$THEME_SCRIPT_NAME"

echo "[*] Setting up docker on $REMOTE"
ssh "$REMOTE" "bash /root/$DOCKER_SCRIPT_NAME"

echo "[*] Setting up extensions for code-server on $REMOTE"
ssh "$REMOTE" "bash /root/$EXTENSIONS_SCRIPT_NAME"

echo "[*] Setting up https self-signed with caddy on $REMOTE"
ssh "$REMOTE" "bash /root/$CADDY_SCRIPT_NAME $PORT"

