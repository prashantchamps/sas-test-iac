resource "azurerm_resource_group" "main" {
  name     = var.rg-name
  location = var.location
}
