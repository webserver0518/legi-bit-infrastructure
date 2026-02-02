# Legi-Bit Infrastructure 🏗️

This repository contains the complete **Infrastructure as Code (IaC)** and **GitOps** configuration for the Legi-Bit SaaS platform.  
It manages server provisioning, Kubernetes cluster setup, and application deployment pipelines.

---

## 🌐 Global Access Points

All services are exposed securely via **Cloudflare Zero Trust** (Email Authentication):

- **App:** [`https://legi-bit.com`](https://legi-bit.com)
- **ArgoCD:** [`https://argocd.legi-bit.com`](https://argocd.legi-bit.com)
- **Grafana:** [`https://grafana.legi-bit.com`](https://grafana.legi-bit.com)
- **SSH:** `ssh.legi-bit.com`

---

## 🚀 Architecture Overview

The infrastructure is built on **AWS EC2** running **K3s**, managed by **Argo CD** in a GitOps workflow.

### High-Level Flow

1.  **Provisioning:** Ansible configures the EC2 instance, installs Docker, and bootstraps K3s & Argo CD.
2.  **GitOps:** Argo CD watches this repository.
3.  **Deployment:** A "Root App" manages the entire cluster state (Apps, Secrets, Monitoring).
4.  **Exposure:** The application is exposed via **Cloudflare subdomains** (secured by email) using Cloudflare Tunnel.

---

## 📂 Repository Structure

| Directory | Purpose |
| :--- | :--- |
| **[`Ansible playbooks/`](./Ansible%20playbooks)** | Automation scripts to provision the server (install Docker, K3s, Argo CD). |
| **[`ArgoCD/`](./ArgoCD)** | GitOps configuration following the **App of Apps** pattern (`bootstrap`, `apps`, `legacy`). |
| **[`Helm Charts/`](./Helm%20Charts)** | Contains Helm charts for the application (`legibit`) and monitoring (`monitoring`). |

---

## 🛠️ Setup & Provisioning (Ansible)

We use a **Dockerized Ansible Runner** to avoid dependency issues on the host machine.

### Prerequisites

- Docker installed on your local machine.
- SSH key (`.pem`) for the AWS EC2 instance.
- Update `production.ini` with your server IP.

### Running the playbook

1.  Place your SSH key in the expected path (update `docker-compose.yaml` volumes if needed).
2.  Run the provisioning wrapper:

```bash
cd "Ansible playbooks"
docker compose up
```

**What this does:**
- Mounts your SSH key into the container.
- Connects to the EC2 instance defined in `production.ini`.
- Installs Docker & K3s.
- Deploys Argo CD into the cluster.

---

## 🐙 GitOps Bootstrap (Argo CD)

Once the cluster is up, initialize the GitOps loop using the **App of Apps** pattern.

### 1) Apply the Root App

Run this command **once** on the cluster to start the sync process:

```bash
kubectl apply -f ArgoCD/bootstrap/root-app.yaml
```

### 2) What gets deployed?

The root app automatically syncs all manifests found in `ArgoCD/apps/`:

| Application | Description | Source |
| :--- | :--- | :--- |
| **Legi-Bit** | Main application stack (Nginx, Flask, MongoDB, Redis, etc.) | `apps/legibit-app.yaml` |
| **Monitoring** | Prometheus & Grafana stack | `apps/monitoring.yaml` |
| **Secrets** | External secrets management | `apps/legibit-secrets.yaml` |

---

## 📦 Microservices Stack

The `legibit` Helm chart deploys the following services:

- **Web:** Nginx acting as a reverse proxy.
- **Backend:** Flask-based application server.
- **MongoDB:** Dedicated database microservice.
- **S3:** File storage abstraction service.
- **SES:** Email delivery service.
- **Redis:** Session management and caching.
- **Cloudflared:** Secure tunnel daemon for external access.

---

## 📡 Monitoring

Service-level monitoring is implemented using **Prometheus Operator** and Kubernetes **ServiceMonitor** resources.

- **Discovery:** Prometheus Operator watches for `ServiceMonitor` resources.
- **Scraping:** Metrics are collected from the named Service port `http` at the `/metrics` path.
- **Monitored Services:** Backend (Flask), S3 service, SES service.

---

## 🔄 CI/CD Workflow

- **CI:** Developers push code to GitHub. GitHub Actions workflow builds Docker images and pushes them to Docker Hub.
- **CD:** Argo CD Image Updater detects the new tag and updates the Argo CD application, automatically syncing the cluster.

---

## 🧑‍💻 Author

Matan Suliman – DevOps Trainee
