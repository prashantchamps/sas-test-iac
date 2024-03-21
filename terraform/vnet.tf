resource "azurerm_virtual_network" "main" {
  name                = "sas-test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg-name

  depends_on = [
    azurerm_resource_group.main
  ]
}
