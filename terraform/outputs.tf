output "admin_host" {
  description = "The `host` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. The Kubernetes cluster server host."
  sensitive   = true
  value       = try(azurerm_kubernetes_cluster.main.kube_admin_config[0].host, "")
}
