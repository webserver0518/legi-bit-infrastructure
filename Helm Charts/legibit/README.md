# Legi-Bit Application Chart 📦

This Helm chart deploys the core microservices for the Legi-Bit SaaS platform.

## Architecture

The chart orchestrates the following components (defined as sub-charts):

| Component | Chart Name | Description |
| :--- | :--- | :--- |
| **Web** | `web` | Nginx frontend and reverse proxy. |
| **Backend** | `backend` | Flask-based main API server. |
| **MongoDB** | `mongodb` | Dedicated database microservice. |
| **S3** | `s3` | Object storage microservice (interfacing with S3/MinIO). |
| **SES** | `ses` | Email delivery microservice (interfacing with SES). |
| **Redis** | `redis` | Session management and caching layer. |
| **Cloudflared** | `cloudflared` | Daemon that creates a secure tunnel to Cloudflare Edge. |

## Configuration

The `values.yaml` file controls the configuration for all services. Key sections include:

- **`global`**: Shared settings like environment (dev/prod) and domain names.
- **`web`, `backend`, `mongodb`, `s3`, `ses`**: Service-specific settings (image tags, replicas, resources).
- **`secrets`**: References to external secrets.

## Deployment

This chart is deployed via **Argo CD** using the `legibit-app.yaml` manifest in the infrastructure repository.

```bash
# Manual install (for testing only)
helm install legibit . -n legibit --create-namespace
```
