variable "db_host" {
  description = "The hostname of the PostgreSQL database."
  type        = string
}

variable "db_name" {
  description = "The name of the PostgreSQL database."
  type        = string
}

variable "db_user" {
  description = "The username for the PostgreSQL database."
  type        = string
}

variable "db_password" {
  description = "The password for the PostgreSQL database."
  type        = string
  sensitive   = true
}

variable "redis_host" {
  description = "The hostname of the Redis cache."
  type        = string
}

variable "redis_password" {
  description = "The password for the Redis cache."
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account."
  type        = string
}

variable "storage_account_key" {
  description = "The primary access key for the Azure Storage Account."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
