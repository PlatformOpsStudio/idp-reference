#!/usr/bin/env bash
# Preflight check. Run right before recording; every line must go green.
set -euo pipefail

KUBECONFIG_MSG="Using context: $(kubectl config current-context 2>/dev/null || echo unknown)"
echo "==> ${KUBECONFIG_MSG}"

echo "==> [Layer 3] ArgoCD server ready"
kubectl -n argocd rollout status deploy/argocd-server --timeout=180s

echo "==> [Layer 3] demo-app Application is Synced"
kubectl -n argocd wait application/demo-app \
  --for=jsonpath='{.status.sync.status}'=Synced --timeout=180s

echo "==> [Layer 3] demo-app Deployment rolled out"
kubectl -n demo rollout status deploy/demo-app --timeout=180s

echo "==> [Layer 2] Crossplane provider healthy"
kubectl wait provider.pkg.crossplane.io/provider-kubernetes \
  --for=condition=Healthy --timeout=180s

echo "==> [Layer 2] Database claim is Ready"
kubectl -n demo wait database.platform.platformops.studio/orders-db \
  --for=condition=Ready --timeout=180s

echo "==> [Layer 2] Provisioned connection ConfigMap exists"
kubectl -n demo get configmap demo-db-connection >/dev/null

echo "==> [Layer 5] Kyverno policies installed"
kubectl get clusterpolicy disallow-privileged require-run-as-nonroot require-signed-images >/dev/null

echo ""
echo "Preflight green - safe to record."
