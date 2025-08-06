variable "resource_group_name" {
  description = "The name of the resource group for the bastion host."
  type        = string
}

variable "location" {
  description = "The Azure region for the bastion host."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network to connect the bastion to."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the bastion host resources."
  type        = map(string)
}
