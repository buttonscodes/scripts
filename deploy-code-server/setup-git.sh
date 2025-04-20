#!/bin/bash

echo "[*] Setting up git..."

git config --global user.name "$1"
git config --global user.email "$2"

