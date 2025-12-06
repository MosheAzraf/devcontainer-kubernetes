#!/usr/bin/env bash
set -e

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    KUBE_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    KUBE_ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "✔ Detected architecture: $ARCH → kubectl: linux/$KUBE_ARCH"

# Get version
KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
BASE_URL="https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/${KUBE_ARCH}"

# Download
curl -LO "${BASE_URL}/kubectl"
curl -LO "${BASE_URL}/kubectl.sha256" #download signature file for verification

# Install
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Check
if [ -f kubectl ] && [ -f kubectl.sha256 ]; then
    echo "✔ kubectl files created"
    rm kubectl kubectl.sha256 
else
    echo "✘ missing files, aborting"
    exit 1
fi

# Config folder
mkdir -p ~/.kube
touch ~/.kube/config
chmod 600 ~/.kube/config

echo "✔ Installation complete"
