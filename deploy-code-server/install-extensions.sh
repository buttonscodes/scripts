#!/bin/bash

EXTENSIONS=(
  ms-azuretools.vscode-docker
)

for ext in "${EXTENSIONS[@]}"; do
  echo "[*] Installing $ext..."
  code-server --install-extension "$ext"
done