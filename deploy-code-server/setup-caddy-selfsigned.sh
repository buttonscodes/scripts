#!/bin/bash
set -e

PORT="${1:-8080}"

echo "[*] Installing Caddy..."

# Install pre-requisites
sudo apt-get update
sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl gnupg

# Add GPG key (safely, only if it doesn't exist)
if [ ! -f /usr/share/keyrings/caddy.gpg ]; then
  echo "[*] Importing Caddy GPG key..."
  curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/gpg.key | \
    sudo gpg --dearmor --batch --yes | sudo tee /usr/share/keyrings/caddy.gpg > /dev/null
fi

# Add Caddy repo (safely, only if it doesn't exist)
if [ ! -f /etc/apt/sources.list.d/caddy.list ]; then
  echo "[*] Adding Caddy APT repo..."
  echo "deb [signed-by=/usr/share/keyrings/caddy.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | \
    sudo tee /etc/apt/sources.list.d/caddy.list > /dev/null
fi

# Install Caddy
sudo apt-get update
sudo apt-get install -y caddy

# Get public IP
PUBLIC_IP=$(curl -s ifconfig.me)

echo "[*] Configuring Caddy to reverse proxy code-server on port $PORT..."

# Replace Caddyfile with new config
sudo tee /etc/caddy/Caddyfile > /dev/null <<EOF
https://$PUBLIC_IP {
    tls internal
    reverse_proxy localhost:$PORT
}
EOF

# Restart Caddy
echo "[*] Restarting Caddy..."
sudo systemctl restart caddy

echo
echo "Caddy is now running with self-signed HTTPS!"
echo "   Open: https://$PUBLIC_IP"
echo "   Reverse proxy is pointing to: http://localhost:$PORT"
echo "   You may need to click through a browser warning (self-signed cert)"
