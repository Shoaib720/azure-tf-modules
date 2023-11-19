variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  type = string
}

variable "enableNetworkManager" {
  type = bool
  default = false
}

variable "network_manager_name" {
  type = string
  default = "netmgr"
}

variable "scope_accesses" {
  type = list(string)
  default = ["Connectivity", "SecurityAdmin"]
}

variable "netgroupname" {
  type = string
  default = "spoke-net-group"
}

variable "spoke_vnets" {
  type = map(object({
    address_space = list(string)
  }))
  default = {
    "spoke-vnet-1" = {
      address_space = ["10.0.0.0/16"]
    }
    "spoke-vnet-2" = {
      address_space = ["10.1.0.0/16"]
    }
  }
}

variable "hub_vnet" {
  type = object({
    name = string
    address_space = list(string)
  })
  default = {
    name = "hub-vnet-1"
    address_space = [ "172.16.0.0/24" ]
  }
}