provider "azurerm" {
  features {}
}
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}
provider "github" {
  token = var.github_token
}
provider "flux" {
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
  git = {
    url = "ssh://git@github.com/${var.owner_username}/${var.github_repository}.git"
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
    flux = {
      source = "fluxcd/flux"
    }
    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.11.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "sas-test-tf"
    storage_account_name = "sastesttfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
