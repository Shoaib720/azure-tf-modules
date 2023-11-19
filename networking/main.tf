data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "vnetmgr" {
  count = var.enableNetworkManager ? 1 : 0
  name                = var.network_manager_name
  location            = var.location
  resource_group_name = var.resource_group_name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = var.scope_accesses
}

resource "azurerm_network_manager_network_group" "netgroup" {
  count = try(var.enableNetworkManager ? 1 : 0, 0)
  name               = var.netgroupname
  network_manager_id = azurerm_network_manager.vnetmgr[0].id
}

resource "azurerm_virtual_network" "spoke-vnet" {
  for_each = {
    for name, config in var.spoke_vnets : name => config
  }
  name                = each.key
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
  location            = var.location
}

resource "azurerm_virtual_network" "hub-vnet" {
  name                = var.hub_vnet.name
  resource_group_name = var.resource_group_name
  address_space       = var.hub_vnet.address_space
  location            = var.location
}

resource "azurerm_network_manager_static_member" "nmsm" {
  for_each = {
    for k,v in azurerm_virtual_network.spoke-vnet : k => azurerm_virtual_network.spoke-vnet[k].id
    if var.enableNetworkManager
  }
  name                      = "${each.key}-nmsm"
  network_group_id          = azurerm_network_manager_network_group.netgroup[0].id
  target_virtual_network_id = each.value
}

resource "azurerm_network_manager_connectivity_configuration" "netconfig" {
  count = try(var.enableNetworkManager ? 1 : 0, 0)
  name                  = "connectivity-conf"
  network_manager_id    = azurerm_network_manager.vnetmgr[0].id
  connectivity_topology = "HubAndSpoke"
  applies_to_group {
    group_connectivity = "DirectlyConnected"
    network_group_id   = azurerm_network_manager_network_group.netgroup[0].id
  }
  hub {
    resource_id   = azurerm_virtual_network.hub-vnet.id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
}

resource "azurerm_network_manager_deployment" "connectivity_deployment" {
  count = try(var.enableNetworkManager ? 1 : 0, 0)
  network_manager_id = azurerm_network_manager.vnetmgr[0].id
  location           = var.location
  scope_access       = "Connectivity"
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.netconfig[0].id]
}