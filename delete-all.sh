#!/bin/bash
set -e

echo "🧨  Starting full cleanup of namespace: legibit"

# 1️⃣ Check if namespace exists
if ! kubectl get namespace legibit >/dev/null 2>&1; then
  echo "⚠️  Namespace 'legibit' not found — nothing to delete."
  exit 0
fi

# 2️⃣ Delete everything inside the namespace (workloads + configs + ingress + PVCs)
echo "🗑️  Deleting all resources in namespace 'legibit'..."
kubectl delete all,configmap,secret,ingress,pvc,serviceaccount,role,rolebinding,hpa --all -n legibit --ignore-not-found=true

# 3️⃣ Optionally delete the namespace itself for a full reset
read -p "Do you want to delete the namespace itself? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "🔥  Deleting namespace 'legibit'..."
  kubectl delete namespace legibit --wait=true
else
  echo "✅  Namespace kept. All resources inside were deleted."
fi

# 4️⃣ Show remaining namespaces (for sanity check)
echo
echo "📜 Current namespaces:"
kubectl get namespaces

echo
echo "✅  Cleanup complete."
