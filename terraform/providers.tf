provider "azurerm" {
  features {}
}
provider "azuread" {}
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--environment",
        "AzurePublicCloud",
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630", # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
        "--client-id",
        "0c1f4e62-611a-42f1-8f3d-9c23b62598bf", # SPN App Id created via terraform
        "--client-secret",
        "yFK8Q~.XKoA9DcLCcJfd7h3TKT6vtisDLZBDdaNx",
        "--tenant-id",
        "d5c750a2-41db-45f0-9332-2e0679e9d40b", # AAD Tenant Id
        "--login",
        "spn"
      ]
    }
    #host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    #client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    #client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    #cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}
provider "github" {
  token = var.github_token
}
provider "flux" {
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--environment",
        "AzurePublicCloud",
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630", # Note: The AAD server app ID of AKS Managed AAD is always 6dae42f8-4368-4678-94ff-3960e28e3630 in any environments.
        "--client-id",
        "0c1f4e62-611a-42f1-8f3d-9c23b62598bf", # SPN App Id created via terraform
        "--client-secret",
        "yFK8Q~.XKoA9DcLCcJfd7h3TKT6vtisDLZBDdaNx",
        "--tenant-id",
        "d5c750a2-41db-45f0-9332-2e0679e9d40b", # AAD Tenant Id
        "--login",
        "spn"
      ]
    }
    #host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    #client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    #client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    #cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
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
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "sas-test-tf"
    storage_account_name = "sastesttfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
