variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  type = string
}

variable "network_manager_name" {
  type = string
}

variable "scope_accesses" {
  type = list(string)
}