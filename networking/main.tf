data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "vnetmgr" {
  name                = var.network_manager_name
  location            = var.location
  resource_group_name = var.resource_group_name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = ["Connectivity", "SecurityAdmin"]
}

resource "azurerm_network_manager_network_group" "netgroup" {
  name               = "example-group"
  network_manager_id = azurerm_network_manager.vnetmgr.id
  description        = "example network group"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  resource_group_name = var.resource_group_name
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.example.location
}

resource "azurerm_network_manager_static_member" "example" {
  name                      = "example-nmsm"
  network_group_id          = azurerm_network_manager_network_group.netgroup.id
  target_virtual_network_id = azurerm_virtual_network.example.id
}