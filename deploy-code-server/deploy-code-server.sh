#!/bin/bash

# Usage: ./deploy-code-server.sh root@YOUR_DROPLET_IP

REMOTE="$1"
INSTALL_SCRIPT="install-code-server.sh"

if [ -z "$REMOTE" ]; then
  echo "Usage: $0 user@host"
  exit 1
fi

echo "[*] Copying install script to $REMOTE..."
scp "$INSTALL_SCRIPT" "$REMOTE:/root/"

echo "[*] Executing script on $REMOTE..."
ssh "$REMOTE" "bash /root/$INSTALL_SCRIPT"
