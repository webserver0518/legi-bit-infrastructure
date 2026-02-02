# Monitoring Chart 📊

This chart deploys the monitoring stack for the Legi-Bit platform, utilizing **kube-prometheus-stack**.

## Components

- **Prometheus:** Collects metrics from the cluster and application services.
- **Grafana:** Visualizes metrics in dashboards.
- **Alertmanager:** Handles alerting.

## Application Monitoring

The `legibit` application services expose metrics at `/metrics`. This chart (along with the `ServiceMonitor` definitions in the `legibit` chart) ensures these metrics are scraped automatically.

## Accessing Grafana

Grafana is exposed securely via Cloudflare Access.

**URL:** [`https://grafana.legi-bit.com`](https://grafana.legi-bit.com)

- **Default User:** `admin`
- **Default Password:** `admin` (Please change this in production!)
