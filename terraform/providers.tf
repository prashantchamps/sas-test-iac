provider "azurerm" {
  features {}
}

provider "azuread" {

}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
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
}

data "azurerm_client_config" "current" {}

#data "azurerm_kubernetes_cluster" "main" {
#  name                = "${local.env}-${local.eks_name}"
#  resource_group_name = local.resource_group_name
#  depends_on          = [azurerm_kubernetes_cluster.main]
#}