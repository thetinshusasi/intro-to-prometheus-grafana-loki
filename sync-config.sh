#!/bin/bash

# Script to sync Prometheus configuration files from this repo to their actual locations
# Run this script after making changes to config files in this repository

echo "Syncing Prometheus configuration files..."

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

echo ""
echo "Configuration files synced!"
echo "Note: You may need to reload Prometheus for changes to take effect."
echo "  - Reload: curl -X POST http://localhost:9090/-/reload"
echo "  - Or restart Prometheus service"

