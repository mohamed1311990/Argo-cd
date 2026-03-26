variable "argocd_namespace" {
  description = "Namespace to deploy ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.7.0"
}

variable "argocd_values" {
  description = "Custom values for ArgoCD Helm chart"
  type        = string
  default     = ""
}