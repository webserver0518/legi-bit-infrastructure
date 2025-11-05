
# Legi-Bit – DevOps & GitOps Overview

Legi-Bit is a multiservice SaaS platform designed for legal offices.  
This document focuses on the DevOps and GitOps practices powering the platform’s delivery pipeline.

---

## 🚀 Architecture Overview

Legi-Bit is deployed in a production-like environment running on:

- AWS EC2 – Kubernetes (k3s)
- Docker images hosted in Docker Hub
- GitOps workflow managed by Argo CD
- Infrastructure-as-Code using Helm

**High-level flow:**

```
Developer → GitHub → Docker Hub → Argo CD → Kubernetes
```

---

## 🧩 Repository Structure

| Repository | Purpose |
|----------|---------|
| Application repository | Flask backend + Web frontend, containerized and pushed to Docker Hub |
| Infrastructure repository | Helm chart + Argo CD application manifests |
| Secure secrets repository | Runtime credentials stored encrypted and deployed automatically |

---

## 🔁 CI/CD Workflow

| Stage | Tooling | Trigger | Result |
|------|---------|---------|--------|
| CI | GitHub Actions | Push to main | Build Docker images and publish to Docker Hub |
| CD | Argo CD + Image Updater | New image tag detected | Auto-sync new version to Kubernetes |

✅ Fully automated deployments  
✅ No manual `kubectl apply` to production

---

## 🧠 GitOps Principles in Use

- Git is the single source of truth  
- Deployment is handled by automation, not humans  
- Configuration and secrets are versioned and controlled  
- Drift detection and reconciliation run continuously  

---

## 🛠️ Tools

- Kubernetes (k3s)
- Helm
- Docker & Docker Hub
- GitHub Actions
- Argo CD + Image Updater
- AWS EC2

---

## 🎯 DevOps Goals Achieved

- Continuous Delivery into a real cluster environment
- Clear repo separation and modular architecture
- Secure lifecycle for sensitive credentials
- Production-grade deployment workflow for a student project


---

## 🧑‍💻 Author

Matan Suliman – DevOps Trainee
