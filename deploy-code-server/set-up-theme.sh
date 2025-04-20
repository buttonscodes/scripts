#!/bin/bash

echo "[*] Setting default theme..."
mkdir -p ~/.local/share/code-server/User

cat <<EOF > ~/.local/share/code-server/User/settings.json
{
  "workbench.colorTheme": "Abyss"
}
EOF