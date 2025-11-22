#!/bin/bash

# Setup script to create Loki data directories with proper permissions
# This ensures Loki can write to the directories without running as root

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${SCRIPT_DIR}/loki-data"

echo "Setting up Loki data directory..."

# Create data directory if it doesn't exist
mkdir -p "${DATA_DIR}/chunks"
mkdir -p "${DATA_DIR}/rules"

# Set permissions (readable/writable by all, but owned by current user)
# Loki typically runs as UID 10001, but we'll make it world-writable for simplicity
# In production, you'd want to match the exact UID/GID
chmod -R 777 "${DATA_DIR}"

echo "Loki data directory created at: ${DATA_DIR}"
echo "Directories:"
ls -la "${DATA_DIR}"

