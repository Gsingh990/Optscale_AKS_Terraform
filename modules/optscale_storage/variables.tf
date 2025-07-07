variable "resource_group_name" {
  description = "The name of the resource group for the Storage Account."
  type        = string
}

variable "location" {
  description = "The Azure region for the Storage Account."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
