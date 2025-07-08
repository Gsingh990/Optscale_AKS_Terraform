variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources into."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Key Vault."
  type        = string
}

variable "agent_object_id" {
  description = "The object ID of the service principal or user that will access the Key Vault."
  type        = string
}

variable "db_admin_password" {
  description = "The administrator password for the PostgreSQL VM."
  type        = string
  sensitive   = true
}
