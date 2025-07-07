resource "azurerm_resource_group" "optscale_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "aks_networking" {
  source = "./modules/aks_networking"

  resource_group_name = azurerm_resource_group.optscale_rg.name
  location            = azurerm_resource_group.optscale_rg.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  aks_subnet_name     = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes
  db_subnet_name      = var.db_subnet_name
  db_subnet_address_prefixes  = var.db_subnet_address_prefixes
  tags                = var.tags
}

module "aks_cluster" {
  source = "./modules/aks_cluster"

  resource_group_name = azurerm_resource_group.optscale_rg.name
  location            = azurerm_resource_group.optscale_rg.location
  aks_cluster_name    = var.aks_cluster_name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  aks_subnet_id       = module.aks_networking.aks_subnet_id
  system_node_pool_vm_size = var.system_node_pool_vm_size
  system_node_pool_node_count = var.system_node_pool_node_count
  user_node_pools     = var.user_node_pools
  private_cluster_enabled = var.private_cluster_enabled
  azure_policy_enabled = var.azure_policy_enabled
  admin_group_object_ids = var.admin_group_object_ids
  tags                = var.tags
}

module "optscale_db_vm" {
  source = "./modules/optscale_db_vm"

  resource_group_name = azurerm_resource_group.optscale_rg.name
  location            = azurerm_resource_group.optscale_rg.location
  db_subnet_id        = module.aks_networking.db_subnet_id
  db_admin_login      = var.db_admin_login
  db_admin_password   = var.db_admin_password
  db_vm_size          = var.db_vm_size
  tags                = var.tags
}

module "optscale_cache" {
  source = "./modules/optscale_cache"

  resource_group_name = azurerm_resource_group.optscale_rg.name
  location            = azurerm_resource_group.optscale_rg.location
  redis_cache_name    = var.redis_cache_name
  redis_cache_sku     = var.redis_cache_sku
  tags                = var.tags
}

module "optscale_storage" {
  source = "./modules/optscale_storage"

  resource_group_name = azurerm_resource_group.optscale_rg.name
  location            = azurerm_resource_group.optscale_rg.location
  storage_account_name = var.storage_account_name
  tags                = var.tags
}

module "optscale_kubernetes_app" {
  source = "./modules/optscale_kubernetes_app"

  db_host             = module.optscale_db_vm.db_server_fqdn
  db_name             = module.optscale_db_vm.db_name
  db_user             = module.optscale_db_vm.db_admin_login
  db_password         = module.optscale_db_vm.db_admin_password
  redis_host          = module.optscale_cache.redis_host_name
  redis_password      = module.optscale_cache.redis_primary_access_key
  storage_account_name = module.optscale_storage.storage_account_name
  storage_account_key = module.optscale_storage.storage_account_primary_access_key
  tags                = var.tags
}