resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
    labels = {
      managed-by  = "terraform"
      environment = "local"
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = var.argocd_chart_version

  wait    = true
  timeout = 600

  values = [
    <<-EOT
    server:
      service:
        type: LoadBalancer

    configs:
      params:
        server.insecure: true

    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 500m
        memory: 512Mi
    EOT
  ]

  depends_on = [kubernetes_namespace.argocd]
}