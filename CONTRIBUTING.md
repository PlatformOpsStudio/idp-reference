# Contributing

Thanks for helping improve the PlatformOps Studio reference IDP. This repo backs
a YouTube episode, so clarity and reproducibility matter more than cleverness.

## Ground rules

- **Keep it reproducible.** Anything you add must survive `task destroy && task up`
  on a clean machine. If it needs a manual step, document it in the README.
- **Pin versions.** No `latest` tags. Add tool versions to `.tool-versions` and
  image/chart versions inline where they are used.
- **Security by default.** New workloads must pass the `restricted` Pod Security
  Standard: non-root, no privilege escalation, read-only root filesystem, all
  capabilities dropped, seccomp `RuntimeDefault`. Grant the narrowest RBAC that
  works - never `cluster-admin`.
- **No secrets, ever.** Nothing sensitive in Git. Use generated or dummy values.
  `.gitignore` already excludes local kubeconfigs and `.env` files.

## Before you open a PR

Run the same checks CI runs:

```bash
yamllint .
shellcheck scripts/*.sh
for d in apps/demo-app kyverno; do kubectl kustomize "$d" | kubeconform -strict -ignore-missing-schemas -summary; done
```

Then prove the whole thing still comes up:

```bash
task up && task verify && task destroy
```

## Commit style

Small, focused commits with a clear message (`area: what changed`). Reference the
episode or issue when relevant. Pin any new GitHub Action to a commit SHA.
