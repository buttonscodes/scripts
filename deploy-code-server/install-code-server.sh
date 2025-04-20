#!/bin/bash

set -e

echo "[*] Installing code-server..."

# Wait until apt/dpkg locks are released
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
      fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
      fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
   echo "[*] Waiting for apt/dpkg lock to be released..."
   sleep 3
done

curl -fsSL https://code-server.dev/install.sh | sh

echo "[*] Creating config..."
mkdir -p ~/.config/code-server

cat <<EOF > ~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: changeme123
cert: false
EOF

echo "[*] Enabling and starting code-server..."
sudo systemctl enable --now code-server@root

echo "[*] Done! Access at http://$(curl -s ifconfig.me):8080 with password 'changeme123'"
