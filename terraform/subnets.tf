resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  address_prefixes     = ["10.0.0.0/19"]
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.main.name

  depends_on = [
    azurerm_resource_group.main,
    azurerm_virtual_network.main
  ]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  address_prefixes     = ["10.0.32.0/19"]
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.main.name

  depends_on = [
    azurerm_resource_group.main,
    azurerm_virtual_network.main
  ]
}
