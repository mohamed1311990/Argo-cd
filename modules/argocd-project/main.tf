resource "kubernetes_manifest" "argocd_project" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = var.name
      namespace = "argocd"
      labels = {
        "managed-by"  = "terraform"
        "environment" = var.name
      }
    }
    spec = {
      description = "Project for ${var.name} environment"

      # Which git repos are allowed as sources
      sourceRepos = var.source_repos

      # Which clusters and namespaces apps can deploy to
      destinations = [
        {
          server    = "https://kubernetes.default.svc"
          namespace = var.namespace
        }
      ]

      # Cluster-scoped resources (CRDs, ClusterRoles etc.)
      clusterResourceWhitelist = var.allow_all_cluster_resources ? [
        { group = "*", kind = "*" }
      ] : [
        { group = "", kind = "Namespace" }
      ]

      # Namespace-scoped resources always allowed
      namespaceResourceWhitelist = [
        { group = "*", kind = "*" }
      ]

      # Warn on resources that exist in cluster but not in git
      orphanedResources = {
        warn = true
      }

      # RBAC roles scoped to this project
      roles = [
        for role in var.roles : {
          name     = role.name
          policies = role.policies
          groups   = role.groups
        }
      ]
    }
  }
}