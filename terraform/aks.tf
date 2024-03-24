resource "azurerm_kubernetes_cluster" "main" {
  name                              = var.cluster-name
  location                          = azurerm_resource_group.main.location
  resource_group_name               = azurerm_resource_group.main.name
  dns_prefix                        = var.cluster-name
  kubernetes_version                = var.aks-version
  automatic_channel_upgrade         = "stable"
  private_cluster_enabled           = false
  sku_tier                          = "Free"
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  role_based_access_control_enabled = true
  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }
  default_node_pool {
    name                 = "default"
    vm_size              = "Standard_D2_v2"
    vnet_subnet_id       = azurerm_subnet.subnet1.id
    orchestrator_version = var.aks-version
    os_disk_size_gb      = 30
    enable_auto_scaling  = true
    node_count           = 1
    min_count            = 1
    max_count            = 1
  }
  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }
  depends_on = [
    azurerm_resource_group.main,
    azurerm_container_registry.main,
    azurerm_subnet.subnet1,
    azurerm_virtual_network.main
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_DS2_v2"
  vnet_subnet_id        = azurerm_subnet.subnet1.id
  orchestrator_version  = var.aks-version
  enable_auto_scaling   = true
  node_count            = 1
  min_count             = 1
  max_count             = 1
  depends_on = [
    azurerm_resource_group.main,
    azurerm_kubernetes_cluster.main,
    azurerm_subnet.subnet1,
    azurerm_virtual_network.main
  ]
}

data "azuread_service_principal" "main" {
  display_name = "sas-test-sp"
}

#data "azurerm_container_registry" "main" {
#  name                = "sasaksacrtest"
#  resource_group_name = var.rg-name
#}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = azurerm_container_registry.main.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.main.object_id
  skip_service_principal_aad_check = true
  depends_on = [
    azurerm_resource_group.main,
    azurerm_kubernetes_cluster.main,
    azurerm_container_registry.main
  ]
}

#resource "azurerm_role_assignment" "acrpull_role" {
#  scope                = azurerm_container_registry.main.id
#  role_definition_name = "AcrPull"
#  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
#  depends_on = [
#    azurerm_resource_group.main,
#    azurerm_kubernetes_cluster.main,
#    azurerm_container_registry.main
#  ]
#}
