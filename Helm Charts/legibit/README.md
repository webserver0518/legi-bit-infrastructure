# Legi-Bit Application Chart 📦

This Helm chart deploys the core microservices for the Legi-Bit SaaS platform.

## Architecture

The chart orchestrates the following components:

- **Web (Nginx):** Frontend and reverse proxy.
- **Backend (Flask):** The main API server.
- **Service-MongoDB:** Database microservice managing MongoDB connections.
- **Service-S3:** File storage microservice (mocking/interfacing with S3).
- **Service-SES:** Email delivery microservice (mocking/interfacing with SES).
- **Redis:** Used for session management and caching.

## Configuration

The `values.yaml` file controls the configuration for all services. Key sections include:

- `global`: Shared settings like environment (dev/prod).
- `web`, `backend`, `mongodb`, `s3`, `ses`: Service-specific settings (image tags, replicas, resources).
- `secrets`: References to external secrets.

## Deployment

This chart is deployed via **Argo CD** using the `legibit-app.yaml` manifest.

```bash
# Manual install (for testing)
helm install legibit . -n legibit --create-namespace
```
