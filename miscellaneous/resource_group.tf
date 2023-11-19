variable "name" {
  type = string
}

variable "location" {
  type = string
  default = "East US"
}

variable "tags" {
  type = map(string)
}

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags = var.tags
}

output "name" {
  value = azurerm_resource_group.rg.name
}