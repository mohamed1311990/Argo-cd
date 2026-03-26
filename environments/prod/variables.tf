variable "namespace" {
  description = "Target Kubernetes namespace"
  type        = string
  default     = "prod"
}

variable "source_repos" {
  description = "Allowed git repos"
  type        = list(string)
  default     = ["https://github.com/yourorg/app"]
}

variable "auto_sync" {
  description = "Enable automatic sync"
  type        = bool
  default     = false
}

variable "auto_prune" {
  description = "Enable automatic pruning"
  type        = bool
  default     = false
}

variable "allow_all_cluster_resources" {
  description = "Allow all cluster-scoped resources"
  type        = bool
  default     = false
}