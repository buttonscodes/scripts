#!/bin/bash
set -e

PORT="${1:-8080}"
PASSWORD="${2:-changeme123}"

# Make sure password is treated as raw string
#PASSWORD="$(printf "%s" "$PASSWORD_RAW")"

# Wait for apt/dpkg locks
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
      fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
      fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
   echo "[*] Waiting for apt/dpkg lock to be released..."
   sleep 3
done

echo "[*] Installing code-server..."
curl -fsSL https://code-server.dev/install.sh | sh

echo "[*] Creating default config..."
mkdir -p ~/.config/code-server

cat <<EOF > ~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: changeme123
cert: false
EOF

echo "[*] Updating config with custom port and password..."
sed -i "s|bind-addr: .*|bind-addr: 0.0.0.0:$PORT|" ~/.config/code-server/config.yaml
# Escape ampersands to avoid sed backreference issues
SAFE_PASSWORD="${PASSWORD//&/\\&}"

echo "SAFE_PASSWORD=$SAFE_PASSWORD"

sed -i "s|password: .*|password: $SAFE_PASSWORD|" ~/.config/code-server/config.yaml

echo "[*] Enabling and starting code-server..."
sudo systemctl enable --now code-server@root

sudo systemctl is-active --quiet code-server@root && \
  echo "[*] Restarting code-server..." && \
  sudo systemctl restart code-server@root || \
  echo "[*] Starting code-server for the first time..." && \
  sudo systemctl start code-server@root

IP=$(curl -s ifconfig.me)
echo "[*] Done! Access it at: http://$IP:$PORT"
echo "[*] Login with password: $PASSWORD"
