variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "The name of the subnet for AKS nodes."
  type        = string
}

variable "aks_subnet_address_prefixes" {
  description = "The address prefixes for the AKS subnet."
  type        = list(string)
}

variable "db_subnet_name" {
  description = "The name of the subnet for the database VM."
  type        = string
}

variable "db_subnet_address_prefixes" {
  description = "The address prefixes for the database subnet."
  type        = list(string)
}

variable "bastion_subnet_name" {
  description = "The name of the subnet for the bastion host."
  type        = string
  default     = "snet-bastion"
}

variable "bastion_subnet_address_prefixes" {
  description = "The address prefixes for the bastion host subnet."
  type        = list(string)
  default     = ["10.20.3.0/24"]
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}