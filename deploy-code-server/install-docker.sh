echo "[*] Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker