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

## Alertmanager

Alertmanager handles alerts sent by Prometheus. It provides grouping, inhibition, silencing, and routing of alerts.

### Installation

Alertmanager is included in this repository as a pre-built binary. The binary is located in:

- `alertmanager-0.27.0.darwin-amd64/alertmanager`

### Running Alertmanager

**Start Alertmanager:**

```bash
./run-alertmanager.sh
```

This will:

- Start Alertmanager on port `9093`
- Use the default configuration from `alertmanager-0.27.0.darwin-amd64/alertmanager.yml`
- Store data in `alertmanager-data/` directory

**Access Alertmanager UI:**

- Web UI: `http://localhost:9093`

### Configuration

The default Alertmanager configuration is located at:

- `alertmanager-0.27.0.darwin-amd64/alertmanager.yml`

You can customize this file to:

- Configure notification receivers (email, Slack, PagerDuty, etc.)
- Set up routing rules
- Configure inhibition rules
- Set up grouping and timing

### Integration with Prometheus

Prometheus is already configured to send alerts to Alertmanager. The configuration in `prometheus.yml` includes:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - localhost:9093
```

**To apply the Alertmanager configuration to Prometheus:**

1. Sync the config: `./sync-config.sh`
2. Reload Prometheus: `curl -X POST http://localhost:9090/-/reload`

### Workflow

1. Start Alertmanager: `./run-alertmanager.sh`
2. Ensure Prometheus is running and configured to send alerts to Alertmanager
3. When alerts fire in Prometheus, they will be sent to Alertmanager
4. View alerts in Alertmanager UI at `http://localhost:9093`
5. Configure notification receivers in `alertmanager.yml` to send alerts via email, Slack, etc.

### Alertmanager Tools

The `amtool` command-line tool is included in the Alertmanager directory:

- `alertmanager-0.27.0.darwin-amd64/amtool`

Use it to:

- Check alert status
- Silence alerts
- Test alert configurations
