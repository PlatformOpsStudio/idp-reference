#!/usr/bin/env bash
# THE MONEY MOMENT: delete part of the platform and watch GitOps put it back.
# Nobody runs a fix command. Git says demo-app should exist, so ArgoCD restores
# it. Keep the ArgoCD UI (demo-app tile) on screen while this runs.
set -euo pipefail

echo "==> Current state:"
kubectl -n demo get deploy demo-app

echo ""
echo "==> Deleting the demo-app Deployment (simulating an accident)..."
kubectl -n demo delete deployment demo-app

echo ""
echo "==> Nudging ArgoCD to re-evaluate (self-heal is already on)..."
kubectl -n argocd annotate application demo-app \
  argocd.argoproj.io/refresh=hard --overwrite >/dev/null

echo ""
echo "==> Watching ArgoCD restore it. Cut to the ArgoCD tile: OutOfSync -> Synced."
echo "    (Ctrl-C once you see Running; the rollout wait below also confirms it.)"
kubectl -n demo rollout status deploy/demo-app --timeout=180s

echo ""
echo "Restored by GitOps. That is the difference between scripts and a platform."
