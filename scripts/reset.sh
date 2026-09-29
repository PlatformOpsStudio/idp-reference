#!/usr/bin/env bash
# Return to a clean, identical state between takes WITHOUT rebuilding the
# cluster. Re-asserts the developer's claim and forces ArgoCD back to Synced.
set -euo pipefail

echo "==> Re-applying the Database claim (idempotent)..."
kubectl apply -f crossplane/claim.yaml

echo "==> Forcing ArgoCD to reconcile demo-app back to desired state..."
kubectl -n argocd annotate application demo-app \
  argocd.argoproj.io/refresh=hard --overwrite >/dev/null

echo "==> Waiting for demo-app to be healthy again..."
kubectl -n demo rollout status deploy/demo-app --timeout=180s

echo "==> Running preflight to confirm a clean slate..."
./scripts/verify.sh
