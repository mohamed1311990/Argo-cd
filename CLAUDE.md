# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Terraform project that deploys ArgoCD on a local minikube cluster and configures per-environment ArgoCD `AppProject` resources (dev, test, prod) with tiered RBAC and sync policies. Each environment has its own Terraform root and state.

## Prerequisites

- Terraform >= 1.5.0
- minikube running with `~/.kube/config` context set to `minikube`
- kubectl available for post-deploy operations

## Common Commands

Each environment is a separate Terraform root. Always `cd` into the target directory first.

```bash
# Deploy ArgoCD (must be applied first)
cd environments/base && terraform init && terraform apply

# Deploy an environment (after base is up)
cd environments/dev && terraform init && terraform apply
cd environments/test && terraform init && terraform apply
cd environments/prod && terraform init && terraform apply

# Standard Terraform workflow (from any environment directory)
terraform plan
terraform fmt
terraform validate
terraform destroy
```

### Access ArgoCD UI

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

## Architecture

```
environments/
  base/       # Shared ArgoCD: namespace + Helm release (kubernetes + helm providers)
  dev/        # Dev namespace + AppProject (kubernetes provider only)
  test/       # Test namespace + AppProject
  prod/       # Prod namespace + AppProject
modules/
  argocd-project/  # Reusable module: creates a kubernetes_manifest of kind AppProject
```

- **`environments/base/`** — Creates the `argocd` namespace and deploys the ArgoCD Helm chart with local-dev settings (LoadBalancer, TLS disabled, reduced resources). Must be applied before any environment.
- **`environments/{dev,test,prod}/`** — Each creates its own Kubernetes namespace and instantiates the `argocd-project` module with environment-specific settings. Each has independent state and can be planned/applied/destroyed independently.
- **`modules/argocd-project/`** — Reusable module that creates an ArgoCD `AppProject` manifest. Accepts variables for source repos, sync/prune toggles, cluster resource access, and RBAC roles.

## Key Design Decisions

- **Separate state per environment**: Each directory under `environments/` is an independent Terraform root. No cross-state references — deployment order (base first) handles dependencies.
- **Graduated permissions**: dev allows all repos and cluster resources; test restricts to org repos with no cluster resources; prod locks to a single repo with manual-only sync, no prune, and read/sync-only RBAC.
- **Prod safety**: `auto_sync = false` and `auto_prune = false` — changes require explicit sync. Ops team role is limited to sync and get (no create/delete).
