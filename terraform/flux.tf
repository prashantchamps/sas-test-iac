resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

data "gitlab_project" "main" {
  path_with_namespace = "${var.gitlab_group}/${var.gitlab_project}"
}

resource "gitlab_deploy_key" "main" {
  project  = data.gitlab_project.main.id
  title    = "Flux"
  key      = tls_private_key.flux.public_key_openssh
  can_push = true
}

resource "flux_bootstrap_git" "main" {
  depends_on = [gitlab_deploy_key.main]
  path = "clusters/sas-test-aks"
}
