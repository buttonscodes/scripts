#!/bin/bash
set -e

PORT="${1:-8080}"

echo "[*] Installing Caddy..."

# Install Caddy from official repo
sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
# Add GPG key
curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/caddy.gpg

# Add repo
echo "deb [signed-by=/usr/share/keyrings/caddy.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | \
  sudo tee /etc/apt/sources.list.d/caddy.list > /dev/null

sudo apt-get update
sudo apt-get install -y caddy

# Get public IP
PUBLIC_IP=$(curl -s ifconfig.me)

echo "[*] Configuring Caddy to proxy to localhost:$PORT..."

# Replace Caddyfile
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
echo "✅ Caddy is now running with self-signed HTTPS!"
echo "   Open: https://$PUBLIC_IP"
echo "   Reverse proxy is pointing to: http://localhost:$PORT"
echo "   You may need to click through a browser warning (self-signed cert)"
