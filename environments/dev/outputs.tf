output "namespace" {
  description = "Environment namespace"
  value       = kubernetes_namespace.environment.metadata[0].name
}

output "project_name" {
  description = "ArgoCD project name"
  value       = var.namespace
}