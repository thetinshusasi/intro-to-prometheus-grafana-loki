#!/bin/bash

# Script to run Alertmanager
# Alertmanager listens on port 9093 by default

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ALERTMANAGER_DIR="$SCRIPT_DIR/alertmanager-0.27.0.darwin-amd64"
CONFIG_FILE="$SCRIPT_DIR/alertmanager-0.27.0.darwin-amd64/alertmanager.yml"

if [ ! -f "$ALERTMANAGER_DIR/alertmanager" ]; then
    echo "Error: Alertmanager binary not found at $ALERTMANAGER_DIR/alertmanager"
    echo "Please ensure alertmanager-0.27.0.darwin-amd64.tar.gz is extracted"
    exit 1
fi

echo "Starting Alertmanager..."
echo "Web UI: http://localhost:9093"
echo "Config file: $CONFIG_FILE"
echo ""
echo "Press Ctrl+C to stop"
echo ""

cd "$ALERTMANAGER_DIR"
./alertmanager --config.file="$CONFIG_FILE" --storage.path="$SCRIPT_DIR/alertmanager-data"

