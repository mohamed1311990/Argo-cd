variable "name" {
  description = "Project name (dev / test / prod)"
  type        = string
}

variable "namespace" {
  description = "Target Kubernetes namespace"
  type        = string
}

variable "source_repos" {
  description = "Allowed git repos"
  type        = list(string)
  default     = ["*"]
}

variable "auto_sync" {
  description = "Enable automatic sync"
  type        = bool
  default     = true
}

variable "auto_prune" {
  description = "Enable automatic pruning"
  type        = bool
  default     = true
}

variable "allow_all_cluster_resources" {
  description = "Allow all cluster-scoped resources"
  type        = bool
  default     = false
}

variable "roles" {
  description = "RBAC roles for this project"
  type = list(object({
    name     = string
    policies = list(string)
    groups   = list(string)
  }))
  default = []
}