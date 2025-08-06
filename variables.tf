variable "resource_group_name" {
  description = "The name of the resource group for OptScale deployment."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources into."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
}

# AKS Cluster Variables
variable "vnet_name" {
  description = "The name of the Virtual Network for AKS."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the AKS Virtual Network."
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

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use for the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

variable "system_node_pool_vm_size" {
  description = "The VM size for the system node pool."
  type        = string
}

variable "system_node_pool_node_count" {
  description = "The initial node count for the system node pool."
  type        = number
}

variable "user_node_pools" {
  description = "A map of user node pool configurations."
  type = map(object({
    name          = string
    vm_size       = string
    node_count    = number
    enable_auto_scaling = bool
    min_count     = number
    max_count     = number
  }))
}

variable "private_cluster_enabled" {
  description = "Enable private cluster for AKS."
  type        = bool
}

variable "azure_policy_enabled" {
  description = "Enable Azure Policy Add-on for AKS."
  type        = bool
}

variable "admin_group_object_ids" {
  description = "A list of Azure AD Group Object IDs that should have admin access to the cluster."
  type        = list(string)
}

# OptScale Specific Variables
variable "db_admin_login" {
  description = "The administrator login name for the PostgreSQL VM."
  type        = string
}

variable "db_admin_password" {
  description = "The administrator password for the PostgreSQL VM."
  type        = string
  sensitive   = true
}

variable "db_vm_size" {
  description = "The size of the database virtual machine."
  type        = string
  default     = "Standard_B1s"
}

variable "redis_cache_name" {
  description = "The name of the Azure Cache for Redis for OptScale."
  type        = string
}

variable "redis_cache_sku" {
  description = "The SKU of the Azure Cache for Redis (e.g., Basic, Standard, Premium)."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account for OptScale."
  type        = string
}

variable "optscale_version" {
  description = "The version of OptScale to deploy (e.g., 3.0.0)."
  type        = string
}

variable "db_subnet_name" {
  description = "The name of the subnet for the database VM."
  type        = string
  default     = "snet-optscale-db"
}

variable "db_subnet_address_prefixes" {
  description = "The address prefixes for the database subnet."
  type        = list(string)
  default     = ["10.10.2.0/24"]
}

# Key Vault Variables
variable "key_vault_name" {
  description = "The name of the Key Vault."
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

# Bastion Host Variables
variable "bastion_subnet_name" {
  description = "The name of the subnet for the bastion host."
  type        = string
  default     = "snet-bastion"
}

variable "bastion_subnet_address_prefixes" {
  description = "The address prefixes for the bastion host subnet."
  type        = list(string)
  default     = ["10.10.3.0/24"]
}

variable "bastion_admin_username" {
  description = "The administrator username for the bastion host."
  type        = string
  default     = "azureuser"
}

variable "bastion_admin_public_key" {
  description = "The administrator public key for the bastion host."
  type        = string
}