#!/bin/bash

# Script to sync Prometheus and Alloy configuration files from this repo to their actual locations
# Run this script after making changes to config files in this repository

echo "Syncing configuration files..."

# Copy prometheus.yml
sudo cp config/prometheus.yml /usr/local/etc/prometheus.yml
echo "✓ Copied prometheus.yml to /usr/local/etc/"

# Copy web.config.yml
sudo cp config/web.config.yml /usr/local/etc/web.config.yml
echo "✓ Copied web.config.yml to /usr/local/etc/"

# Copy prometheus.args
sudo cp config/prometheus.args /usr/local/etc/prometheus.args
echo "✓ Copied prometheus.args to /usr/local/etc/"

# Copy alerts.yml
sudo cp config/rule/alerts.yml /usr/local/etc/rule/alerts.yml
echo "✓ Copied alerts.yml to /usr/local/etc/rule/"

# Copy recording_rule.yml
sudo cp config/recording_rule.yml /usr/local/etc/rule/recording_rule.yml
echo "✓ Copied recording_rule.yml to /usr/local/etc/rule/"

# Copy grafana.ini
sudo cp config/grafana.ini /usr/local/etc/grafana/grafana.ini
echo "✓ Copied grafana.ini to /usr/local/etc/grafana/"

# Create Alloy config directory if it doesn't exist
sudo mkdir -p /usr/local/etc/alloy
echo "✓ Created /usr/local/etc/alloy directory (if needed)"

# Copy Alloy config
sudo cp config/alloy/config.alloy /usr/local/etc/alloy/config.alloy
echo "✓ Copied config.alloy to /usr/local/etc/alloy/"

# Copy Alloy extra-args.txt
sudo cp config/alloy/extra-args.txt /usr/local/etc/alloy/extra-args.txt
echo "✓ Copied extra-args.txt to /usr/local/etc/alloy/"

echo ""
echo "Configuration files synced!"
echo "Note: You may need to reload services for changes to take effect."
echo "  - Prometheus reload: curl -X POST http://localhost:9090/-/reload"
echo "  - Or restart Prometheus service"
echo "  - Alloy reload: Send SIGHUP to Alloy process or restart Alloy service"

