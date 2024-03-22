resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
resource "github_repository_deploy_key" "main" {
  title      = "Flux"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "true"
}
resource "flux_bootstrap_git" "main" {
  depends_on       = [github_repository_deploy_key.main]
  path             = "clusters/sas-test-aks"
  components_extra = ["image-reflector-controller", "image-automation-controller"]
  depends_on = [
    azurerm_resource_group.main,
    azurerm_kubernetes_cluster.main
  ]
}
