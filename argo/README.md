# Argo CD Applications (Legi-Bit on AWS)

Argo CD `Application` manifests to bootstrap AWS cloud integration and deploy **Legi-Bit** via GitOps.

## Included apps

1) **AWS Cloud Controller Manager** (Helm)
- App: `aws-cloud-controller-manager` → namespace `kube-system`
- Chart: `aws-cloud-controller-manager` from `https://kubernetes.github.io/cloud-provider-aws` (revision `*`)
- Values:
```yaml
nodeSelector:
  node-role.kubernetes.io/control-plane: "true"

tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"

hostNetwork: true

args:
  - --v=2
  - --cloud-provider=aws
  - --configure-cloud-routes=false
  - --allocate-node-cidrs=false
```

2) **AWS Load Balancer Controller** (Helm)
- App: `aws-load-balancer-controller` → namespace `kube-system`
- Chart: `aws-load-balancer-controller` from `https://aws.github.io/eks-charts` (revision `*`)
- Params:
  - `clusterName`: `legibit-k3s`
  - `region`: `eu-north-1`
  - `serviceAccount.create`: `true`

3) **Legi-Bit** (Helm chart from Git repo)
- App: `legibit` → namespace `legibit`
- Repo: `https://github.com/webserver0518/legi-bit-infrastructure.git`
- Path: `legibit`
- Release: `legibit`

## Prereqs
- Kubernetes cluster with **Argo CD** installed (namespace `argocd`)
- AWS nodes with an **instance profile (IAM role)** granting permissions required by:
  - Cloud Controller Manager
  - AWS Load Balancer Controller
- If you want **instance target mode** for ALBs, use:
  - `alb.ingress.kubernetes.io/target-type: instance`

## Deploy
```bash
kubectl apply -f cloud-provider-aws.yaml
kubectl apply -f aws-load-balancer-controller.yaml
kubectl apply -f legibit-app.yaml
```

Verify:
```bash
kubectl -n argocd get applications
```

## Image updates (optional)
`legibit-app.yaml` includes **Argo CD Image Updater** annotations. Images configured:

```text
web=webserver0518/legi-bit-nginx,
backend=webserver0518/legi-bit-flask,
mongodb=webserver0518/legi-bit-mongodb,
s3=webserver0518/legi-bit-s3
ses=webserver0518/legi-bit-ses
```
