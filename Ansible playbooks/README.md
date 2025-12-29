# Ansible Provisioning – Legi-Bit Infrastructure 🛠️

This directory contains the automation scripts for server provisioning.  
We use **Ansible** (running inside a Docker container) to configure the EC2 instance from scratch, install the runtime environment, and bootstrap GitOps.

---

## 📋 What does it do? (Roles)

The master playbook (`site.yaml`) executes the following roles **in order**:

| Role | Description |
| :--- | :--- |
| **`k3s`** | Installs the lightweight Kubernetes distribution **K3s** using the official installation script. |
| **`docker`** | Installs **Docker**, enables the service, and adds the `ec2-user` to the `docker` group. |
| **`argocd`** | Creates the `argocd` namespace and installs the official **Argo CD** manifests into the cluster. |

---

## ⚙️ Prerequisites

1. Docker installed on your local machine (the machine running the playbook)
2. SSH key (`.pem`) to connect to the AWS EC2 instance
3. Updated inventory file (`production.ini`) with the new server IP address

---

## 🚀 Usage Instructions

The provisioning process runs via **Docker Compose** to avoid installing Ansible and Python dependencies on your local machine.

### Step 1: Configure SSH Key

Open `docker-compose.yaml` and ensure the path to your local SSH key (**left side**) is correct:

```yaml
volumes:
  - ./:/ansible
  # Update the path on the left to match your local key location
  - C:/Users/matan/.ssh/webserver0518.pem:/host_key.pem:ro
```

### Step 2: Set Server IP

Open `production.ini` and update the IP address under the `[webservers]` group:

```ini
[webservers]
web1 ansible_host=<YOUR_EC2_IP>
```

### Step 3: Run Provisioning

Open a terminal in this directory and run:

```bash
# New syntax (recommended)
docker compose up

# Legacy syntax (if your Docker uses it)
# docker-compose up
```

### What happens in the background?

- The container starts and mounts your SSH key.
- The key is copied to a temporary location and given `400` permissions (required for SSH).
- The command below runs automatically:

```bash
ansible-playbook -i production.ini site.yaml
```

Upon completion, your server will be ready with **K3s** and **Argo CD** running.

---

## 📂 File Structure

```text
Ansible playbooks/
├── docker-compose.yaml  # Runner configuration
├── production.ini       # Inventory file (Server IPs)
├── site.yaml            # Master playbook
├── webservers.yaml      # Webservers play definition
└── roles/
    ├── k3s/             # K3s installation tasks
    ├── docker/          # Docker installation tasks
    └── argocd/          # Argo CD bootstrapping tasks
```

---

## ⚠️ Common Troubleshooting

### `Permission denied (publickey)`

- Ensure the path to the PEM file in `docker-compose.yaml` is correct.
- Ensure you are using the correct user (`ec2-user` is the default in `production.ini`).

### `Host key verification failed`

This setup disables host key checking (e.g., `StrictHostKeyChecking=no`) to allow smooth automation on new servers.  
If you want stricter security, remove that option and manage `known_hosts` explicitly.
