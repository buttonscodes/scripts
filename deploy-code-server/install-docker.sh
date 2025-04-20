#!/bin/bash

echo "[*] Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

## Install buildx

# Step 1: Download the latest release
BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep tag_name | cut -d '"' -f 4)
mkdir -p ~/.docker/cli-plugins
curl -SL "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o ~/.docker/cli-plugins/docker-buildx

# Step 2: Make it executable
chmod +x ~/.docker/cli-plugins/docker-buildx