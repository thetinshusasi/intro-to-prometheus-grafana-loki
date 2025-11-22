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

## Loki

Loki is a horizontally-scalable, highly-available log aggregation system inspired by Prometheus. It's designed to be cost-effective and operationally simple.

### Installation

Loki is set up using Docker Compose. The configuration files are located in the `loki/` directory.

### Running Loki

**Start Loki stack (Loki + Promtail + Grafana):**

```bash
cd loki
docker-compose up -d
```

This will start three services:

1. **Loki** - Log aggregation system (port `3100`)
2. **Promtail** - Log shipper that collects logs and sends them to Loki
3. **Grafana** - Visualization tool with Loki datasource pre-configured (port `3000`)

**Check service status:**

```bash
docker-compose ps
```

**View logs:**

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f loki
docker-compose logs -f promtail
docker-compose logs -f grafana
```

**Stop services:**

```bash
docker-compose down
```

**Stop and remove volumes (clean slate):**

```bash
docker-compose down -v
```

### Alternative: Using Loki + Promtail with Brew Grafana

If you're running Grafana via Homebrew services and want to use that instance instead of the Docker Grafana, use the alternative docker-compose file:

**Start only Loki and Promtail:**

```bash
cd loki
docker-compose -f docker-compose-loki-promtail.yaml up -d
```

This will start only two services:

1. **Loki** - Log aggregation system (port `3100`)
2. **Promtail** - Log shipper that collects logs and sends them to Loki

**Check service status:**

```bash
docker-compose -f docker-compose-loki-promtail.yaml ps
```

**View logs:**

```bash
# All services
docker-compose -f docker-compose-loki-promtail.yaml logs -f

# Specific service
docker-compose -f docker-compose-loki-promtail.yaml logs -f loki
docker-compose -f docker-compose-loki-promtail.yaml logs -f promtail
```

**Stop services:**

```bash
docker-compose -f docker-compose-loki-promtail.yaml down
```

**Configure Grafana (Brew) to connect to Loki:**

1. Open Grafana: `http://localhost:3000`
2. Go to **Configuration** → **Data Sources**
3. Click **Add data source**
4. Select **Loki**
5. Configure:
   - **URL**: `http://localhost:3100`
   - **Access**: Server (default)
6. Click **Save & Test**

The Loki datasource will now be available in Grafana Explore and dashboards.

### Accessing Services

- **Loki API**: `http://localhost:3100`
- **Loki UI**: `http://localhost:3100/ready` (health check)
- **Grafana UI**: `http://localhost:3000`
  - Default login: `admin` / `admin` (or anonymous access if enabled)
  - Loki datasource is automatically configured

### Configuration Files

The Loki stack configuration files are located in the `loki/` directory:

- `docker-compose.yaml` - Docker Compose service definitions (includes Loki, Promtail, and Grafana)
- `docker-compose-loki-promtail.yaml` - Alternative Docker Compose file (Loki + Promtail only, for use with brew Grafana)
- `loki-config.yaml` - Loki server configuration
- `promtail-config.yaml` - Promtail log collection configuration

### Loki Configuration

The main Loki configuration (`loki-config.yaml`) includes:

- **Storage**: Filesystem-based storage (for development/testing)
- **Schema**: TSDB index with filesystem object store
- **Ports**: HTTP on 3100, gRPC on 9096
- **Ruler**: Configured to send alerts to Alertmanager at `localhost:9093`

### Promtail Configuration

Promtail is configured to:

- Collect logs from `/var/log` directory (mounted as volume)
- Forward logs to Loki
- Apply labels for log organization

### Integration with Prometheus

Loki can be integrated with Prometheus for unified observability:

1. **Add Loki as a datasource in Grafana** (already configured in docker-compose)
2. **Query logs using LogQL** in Grafana Explore
3. **Correlate metrics and logs** in Grafana dashboards
4. **Set up log-based alerts** using Loki's ruler component

### Workflow

1. Start Loki stack: `cd loki && docker-compose up -d`
2. Access Grafana at `http://localhost:3000`
3. Navigate to Explore and select Loki datasource
4. Query logs using LogQL (e.g., `{job="varlogs"}`)
5. Create dashboards combining Prometheus metrics and Loki logs

### Example LogQL Queries

```logql
# All logs
{job="varlogs"}

# Filter by log level
{job="varlogs"} |= "error"

# Count logs over time
count_over_time({job="varlogs"}[5m])

# Rate of logs
rate({job="varlogs"}[5m])
```

### Troubleshooting

**Check if services are running:**

```bash
docker-compose ps
```

**View service logs:**

```bash
docker-compose logs loki
docker-compose logs promtail
```

**Check Loki health:**

```bash
curl http://localhost:3100/ready
curl http://localhost:3100/metrics
```

**Restart a specific service:**

```bash
docker-compose restart loki
```

### Production Considerations

For production deployments:

- Replace filesystem storage with object storage (S3, GCS, Azure Blob)
- Configure proper authentication and authorization
- Set up retention policies
- Use distributed deployment mode for scalability
- Configure proper resource limits in docker-compose
- Set up monitoring for Loki itself
