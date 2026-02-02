# Argo CD – GitOps Architecture (App of Apps)

This directory implements the **App of Apps** pattern to manage the Legi-Bit infrastructure and microservices.  
Instead of applying multiple manifests manually, a single `root-app` watches the `apps/` directory and automatically syncs any Argo CD `Application` manifest found there.

---

## 📂 Repository Structure

| Directory | Description |
| :--- | :--- |
| **`bootstrap/`** | Contains the `root-app` manifest. This is the entry point for the GitOps workflow. |
| **`apps/`** | The source of truth. Any Argo CD Application file placed here is automatically deployed by the root app. |
| **`legacy/`** | Contains older infrastructure manifests (e.g., AWS Controllers) that are not currently managed by the root app. |

---

## 🚀 Getting Started (Bootstrap)

To start the GitOps loop, you only need to apply **one file**. This will create the parent application, which will then spawn all child applications.

```bash
# Apply the Root App
kubectl apply -f ArgoCD/bootstrap/root-app.yaml
```

### What happens next?

- The `root-app` is created in the `argocd` namespace.
- It scans the `ArgoCD/apps/` folder in this repository.
- It automatically deploys all applications defined there (e.g., `legibit`, `monitoring`, `secrets`).

---

## 📦 Managed Applications (in `apps/`)

The following applications are currently active and managed by the `root-app`:

### 1) Legi-Bit (Main App)
- **File:** [`apps/legibit-app.yaml`](./apps/legibit-app.yaml)
- **Description:** The main microservices stack (Frontend, Backend, MongoDB, S3, SES).
- **Updates:** Configured with **Argo CD Image Updater** to track image tags from Docker Hub automatically.

### 2) Kube Prometheus Stack (Monitoring)
- **File:** [`apps/monitoring.yaml`](./apps/monitoring.yaml)
- **Description:** Full monitoring stack including **Prometheus** & **Grafana**.
- **Access:** [`https://grafana.legi-bit.com`](https://grafana.legi-bit.com)
- **Login:** `admin / admin`

### 3) Legi-Bit Secrets
- **File:** [`apps/legibit-secrets.yaml`](./apps/legibit-secrets.yaml)
- **Description:** Manages external secrets from the private `legi-bit-secrets` repository.

---

## ⚠️ Legacy Components (in `legacy/`)

The `legacy/` folder contains infrastructure components that were previously applied manually:

- AWS Load Balancer Controller
- AWS Cloud Controller Manager

**Note:** If these components need to be managed by Argo CD in the future, move their YAML files from `legacy/` into `apps/`.

---

## 🛠️ How to Add a New App

1.  Create a new YAML file for your application (e.g., `logging.yaml`).
2.  Place it inside the `ArgoCD/apps/` folder.
3.  Push to Git (`git push`).

Done — the `root-app` will detect the new file and deploy it automatically.
