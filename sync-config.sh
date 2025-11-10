#!/bin/bash

# Script to sync Prometheus configuration files from this repo to their actual locations
# Run this script after making changes to config files in this repository

echo "Syncing Prometheus configuration files..."

# Copy prometheus.yml
sudo cp config/prometheus.yml /usr/local/etc/prometheus.yml
echo "✓ Copied prometheus.yml to /usr/local/etc/"

# Copy alerts.yml
sudo cp config/rule/alerts.yml /usr/local/etc/rule/alerts.yml
echo "✓ Copied alerts.yml to /usr/local/etc/rule/"

# Copy recording_rule.yml
sudo cp config/recording_rule.yml /usr/local/etc/rule/recording_rule.yml
echo "✓ Copied recording_rule.yml to /usr/local/etc/rule/"

echo ""
echo "Configuration files synced!"
echo "Note: You may need to reload Prometheus for changes to take effect."
echo "  - Reload: curl -X POST http://localhost:9090/-/reload"
echo "  - Or restart Prometheus service"

