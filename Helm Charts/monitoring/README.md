# Monitoring Chart 📊

This chart deploys the monitoring stack for the Legi-Bit platform, utilizing **kube-prometheus-stack**.

## Components

- **Prometheus:** Collects metrics from the cluster and application services.
- **Grafana:** Visualizes metrics in dashboards.
- **Alertmanager:** Handles alerting (optional configuration).

## Application Monitoring

The `legibit` application services expose metrics at `/metrics`. This chart (along with the `ServiceMonitor` definitions in the `legibit` chart) ensures these metrics are scraped automatically.

## Accessing Grafana

Grafana is exposed via a **NodePort** service for easy internal access.

- **Port:** `31300`
- **Default User:** `admin`
- **Default Password:** `admin` (change immediately in production!)

### Connect via SSH Tunnel
```bash
ssh -L 3000:localhost:31300 user@server-ip
# Access at http://localhost:3000
```
