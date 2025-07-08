variable "resource_group_name" {
  description = "The name of the resource group for the database VM."
  type        = string
}

variable "location" {
  description = "The Azure region for the database VM."
  type        = string
}

variable "db_vm_name" {
  description = "The name of the database virtual machine."
  type        = string
  default     = "optscale-db-vm"
}

variable "db_vm_size" {
  description = "The size of the database virtual machine."
  type        = string
}

variable "db_subnet_id" {
  description = "The ID of the subnet for the database VM."
  type        = string
}

variable "db_admin_login" {
  description = "The admin username for the database VM and PostgreSQL."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Key Vault containing the database password."
  type        = string
}

variable "db_password_secret_name" {
  description = "The name of the secret containing the database password."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the database VM resources."
  type        = map(string)
}
