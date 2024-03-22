resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}
resource "flux_bootstrap_git" "main" {
  depends_on = [gitlab_deploy_key.main]
  path = "clusters/sas-test-aks"
}
