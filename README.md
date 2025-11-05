
# Legi-Bit – DevOps & GitOps Overview

Legi-Bit is a modular SaaS platform built with a microservices architecture for legal offices.  

---

## 🚀 Architecture Overview

Legi-Bit is deployed in a production-like environment running on:

- AWS EC2 with Kubernetes (k3s) installed
- Docker images hosted in Docker Hub
- GitOps workflow managed by Argo CD
- IaC using Helm

**High-level flow:**

```
Developer → GitHub → Docker Hub → Argo CD → Kubernetes
```

---

## 🧩 Repository Structure

| Repository     | Purpose                                                    |
|----------------|------------------------------------------------------------|
| Application    | backend & frontend, containerized and pushed to Docker Hub |
| Infrastructure | Helm chart + Argo CD application manifests                 |
| Secure secrets | Runtime credentials stored encrypted & Argo CD manifest    |

---

## 🔁 CI/CD Workflow

| Stage | Tooling                 | Trigger                | Result                                        |
|-------|-------------------------|------------------------|-----------------------------------------------|
| CI    | GitHub Actions          | Push / PR to main      | Build Docker images and publish to Docker Hub |
| CD    | Argo CD + Image Updater | New image tag detected | Auto-sync new version to Kubernetes           |

✅ Fully automated deployments

---

## 🧠 GitOps Principles in Use

- Git is the single source of truth  
- Deployment is handled by automation
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

- Continuous Delivery into a cluster environment
- Clear repo separation and modular architecture
- Secure lifecycle for sensitive credentials
- Production-grade deployment workflow


---

## 🧑‍💻 Author

Matan Suliman – DevOps Trainee
