variable "bastion_host_name" {
  description = "The name of the bastion host."
  type        = string
  default     = "optscale-bastion"
}

variable "resource_group_name" {
  description = "The name of the resource group for the bastion host."
  type        = string
}

variable "location" {
  description = "The Azure region for the bastion host."
  type        = string
}

variable "vm_size" {
  description = "The size of the bastion host virtual machine."
  type        = string
  default     = "Standard_B1s"
}

variable "subnet_id" {
  description = "The ID of the subnet for the bastion host."
  type        = string
}

variable "admin_username" {
  description = "The administrator username for the bastion host."
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The administrator password for the bastion host."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the bastion host resources."
  type        = map(string)
}
