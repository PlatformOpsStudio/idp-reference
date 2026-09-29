#!/usr/bin/env bash
# Open the ArgoCD UI on http://localhost:8080 for the walkthrough.
# The admin password is printed to YOUR terminal only - do NOT show this on
# camera. Log in before you start recording, then hide the terminal.
set -euo pipefail

echo "ArgoCD username: admin"
echo -n "ArgoCD password: "
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d
echo ""
echo "Forwarding https://localhost:8080  (Ctrl-C to stop)"
kubectl -n argocd port-forward svc/argocd-server 8080:443
