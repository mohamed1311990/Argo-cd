resource "kubernetes_namespace" "environment" {
  metadata {
    name = var.namespace
    labels = {
      "managed-by"  = "terraform"
      "environment" = var.namespace
    }
  }
}

module "project" {
  source    = "../../modules/argocd-project"
  name      = var.namespace
  namespace = var.namespace

  source_repos                = var.source_repos
  auto_sync                   = var.auto_sync
  auto_prune                  = var.auto_prune
  allow_all_cluster_resources = var.allow_all_cluster_resources

  roles = [
    {
      name = "qa-team"
      policies = [
        "p, proj:test:qa-team, applications, *, test/*, allow"
      ]
      groups = ["qa-team"]
    }
  ]

  depends_on = [kubernetes_namespace.environment]
}