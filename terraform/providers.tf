provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}

provider "gitlab" {
  token = var.gitlab_token
}

provider "flux" {
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.main.endpoint
    client_certificate     = azurerm_kubernetes_cluster.main.client_certificate
    client_key             = azurerm_kubernetes_cluster.main.client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.main.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@gitlab.com/${data.gitlab_project.main.path_with_namespace}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "sas-test-tf"
    storage_account_name = "sastesttfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  flux = {
    source = "fluxcd/flux"
  }
  github = {
    source  = "integrations/github"
    version = ">=5.18.0"
  }
}

data "gitlab_project" "main" {
  path_with_namespace = "${var.gitlab_group}/${var.gitlab_project}"
}

data "azurerm_client_config" "current" {}

#data "azurerm_kubernetes_cluster" "main" {
#  name                = "${local.env}-${local.eks_name}"
#  resource_group_name = local.resource_group_name
#  depends_on          = [azurerm_kubernetes_cluster.main]
#}
