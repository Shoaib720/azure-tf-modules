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

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "West Europe"
  tags = {}
}