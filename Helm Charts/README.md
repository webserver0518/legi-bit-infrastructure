# Legi-Bit Helm Charts ☸️

This directory contains the Helm charts used to deploy the Legi-Bit platform and its monitoring stack.

## Charts

| Chart | Description |
| :--- | :--- |
| **[legibit](./legibit)** | The main application chart. Deploys the full microservices stack (Frontend, Backend, MongoDB, S3, SES). |
| **[monitoring](./monitoring)** | The monitoring stack. Deploys `kube-prometheus-stack` (Prometheus, Alertmanager, Grafana) to monitor the cluster and application. |
