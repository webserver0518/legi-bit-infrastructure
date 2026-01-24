# Legi-Bit Infrastructure 🏗️

This repository contains the complete **Infrastructure as Code (IaC)** and **GitOps** configuration for the Legi-Bit SaaS platform.  
It manages the server provisioning, Kubernetes cluster setup, and application deployment pipelines.

---

## 🚀 Architecture Overview

The infrastructure is built on **AWS EC2** running **K3s**, managed by **Argo CD** in a GitOps workflow.

### High-Level Flow

1. **Provisioning:** Ansible configures the EC2 instance, installs Docker, and bootstraps K3s & Argo CD.
2. **GitOps:** Argo CD watches this repository.
3. **Deployment:** A "Root App" manages the entire cluster state (Apps, Secrets, Monitoring).
4. **Exposure:** The application is exposed via **AWS Application Load Balancer (ALB)** using `TargetGroupBinding` (**Instance Mode**).

---

## 📂 Repository Structure

| Directory | Purpose |
| :--- | :--- |
| **`Ansible playbooks/`** | Automation scripts to provision the server (install Docker, K3s, Argo CD). |
| **`ArgoCD/`** | GitOps configuration following the **App of Apps** pattern (`bootstrap`, `apps`, `legacy`). |
| **`Helm Charts/`** | Contains Helm charts for the application (`legibit`) and monitoring (`monitoring`). |

---

## 🛠️ Setup & Provisioning (Ansible)

We use a **Dockerized Ansible Runner** to avoid dependency issues on the host machine.

### Prerequisites

- Docker installed on your local machine
- SSH key (`.pem`) for the AWS EC2 instance
- Update `production.ini` with your server IP

### Running the playbook

1. Place your SSH key in the expected path (update `docker-compose.yaml` volumes if needed).
2. Run the provisioning wrapper:

```bash
cd "Ansible playbooks"
docker compose up
```

**What this does:**

- Mounts your SSH key into the container
- Connects to the EC2 instance defined in `production.ini`
- Installs Docker & K3s
- Deploys Argo CD into the cluster

---

## 🐙 GitOps Bootstrap (Argo CD)

Once the cluster is up, initialize the GitOps loop using the **App of Apps** pattern.

### 1) Apply the Root App

Run this command **once** on the cluster to start the sync process:

```bash
kubectl apply -f ArgoCD/boostrap/root-app.yaml
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

- **Web:** Nginx acting as a reverse proxy
- **Backend:** Flask-based application server
- **MongoDB:** Dedicated database microservice
- **S3:** File storage abstraction service
- **SES:** Email delivery service
- **Redis:** Session management and caching

---

## 📡 Monitoring

Service-level monitoring is implemented using **Prometheus Operator** and Kubernetes **ServiceMonitor** resources. When `monitoring.enabled=true` is set in the Helm values, the chart conditionally deploys `ServiceMonitor` objects that instruct Prometheus to automatically discover and scrape `/metrics` endpoints from the application microservices.

- **Discovery:** Prometheus Operator watches for `ServiceMonitor` resources with a matching `release` label and dynamically adds matching Services as scrape targets.
- **Selection:** Each ServiceMonitor selects a Kubernetes `Service` using the `app.kubernetes.io/name` label.
- **Scraping:** Metrics are collected from the named Service port `http` at the `/metrics` path with a `15s` interval.
- **Monitored Services:** Backend (Flask), S3 service, SES service.

### Accessing Grafana

Grafana is exposed internally via **NodePort `31300`**. To access it securely:

1. Open an SSH tunnel:

```bash
ssh -i /path/to/key.pem -L 3000:localhost:31300 ec2-user@<SERVER_IP>
```

2. Open your browser at:

- `http://localhost:3000`

3. Login:

- **Username:** `admin`
- **Password:** `admin`

---

## ☁️ Cloud Integration (Legacy)

- **AWS Load Balancer Controller:** Manages ALBs.
- **TargetGroupBinding:** Connects the web service directly to an AWS Target Group, bypassing standard Kubernetes `LoadBalancer` Services.

---

## 🔄 CI/CD Workflow

- **CI:** Developers push code to GitHub, GitHub Actions worflow builds Docker images and pushes them to Docker Hub.
- **CD:** Argo CD Image Updater detects the new tag and updates the '.argocd-source-legibit.yaml' file with the new tags. then ArgoCD has auto-sync and updates the cluster.

---

## 🧑‍💻 Author

Matan Suliman – DevOps Trainee
