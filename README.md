# intro-to-prometheus-grafana-loki

## Configuration Files

This repository tracks Prometheus configuration files that are stored in `/usr/local/etc/` on the system.

### Directory Structure

- `config/prometheus.yml` - Main Prometheus configuration file
- `config/rule/alerts.yml` - Prometheus alert rules

### Syncing Configuration Files

After making changes to configuration files in this repository, you need to sync them to their actual locations where Prometheus reads them from.

**To sync configuration files to Prometheus:**

```bash
./sync-config.sh
```

This script will:

- Copy `config/prometheus.yml` to `/usr/local/etc/prometheus.yml`
- Copy `config/rule/alerts.yml` to `/usr/local/etc/rule/alerts.yml`

**After syncing, reload Prometheus:**

```bash
curl -X POST http://localhost:9090/-/reload
```

Or restart the Prometheus service if reload is not enabled.

### Workflow

1. Edit configuration files in the `config/` directory
2. Commit changes to git: `git add config/ && git commit -m "Update config"`
3. Sync to Prometheus: `./sync-config.sh`
4. Reload Prometheus to apply changes

### Original File Locations

- Prometheus config: `/usr/local/etc/prometheus.yml`
- Alert rules: `/usr/local/etc/rule/alerts.yml`
