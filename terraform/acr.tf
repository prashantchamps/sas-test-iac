resource "azurerm_container_registry" "main" {
  location            = var.location
  name                = var.acr-name
  resource_group_name = var.rg-name
  sku                 = "Standard"
  admin_enabled       = true
}
