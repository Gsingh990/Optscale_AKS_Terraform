variable "resource_group_name" {
  description = "The name of the resource group for the Redis Cache."
  type        = string
}

variable "location" {
  description = "The Azure region for the Redis Cache."
  type        = string
}

variable "redis_cache_name" {
  description = "The name of the Azure Cache for Redis."
  type        = string
}

variable "redis_cache_sku" {
  description = "The SKU of the Azure Cache for Redis (e.g., Basic, Standard, Premium)."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
