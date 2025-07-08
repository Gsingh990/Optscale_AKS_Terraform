resource_group_name = "rg-optscale-deployment"
location            = "westus2"

tags = {
  environment = "prod"
  project     = "optscale"
}

# AKS Cluster Variables
vnet_name = "vnet-optscale-aks"
vnet_address_space = ["10.20.0.0/16"]
aks_subnet_name = "snet-optscale-aks-nodes"
aks_subnet_address_prefixes = ["10.20.1.0/24"]

aks_cluster_name = "aks-optscale-cluster"
kubernetes_version = "1.32.5"
dns_prefix = "aks-optscale"
system_node_pool_vm_size = "Standard_D2s_v3"
system_node_pool_node_count = 2

user_node_pools = {
  "default_user_pool" = {
    name          = "userpool1"
    vm_size       = "Standard_D2s_v3"
    node_count    = 1
    enable_auto_scaling = true
    min_count     = 1
    max_count     = 3
  }
}

private_cluster_enabled = true
azure_policy_enabled = true
admin_group_object_ids = [] # Add your Azure AD Group Object IDs here for admin access

# OptScale Specific Variables
db_admin_login    = "optscaleadmin"
db_admin_password = "YourSecureDbPassword!123"
db_vm_size        = "Standard_B1s"

redis_cache_name = "optscale-redis-cache-new"
redis_cache_sku  = "Basic"

storage_account_name = "optscalestorage"

optscale_version = "3.0.0"

# Key Vault Variables
key_vault_name  = "optscale-kv-new"
tenant_id       = "ff355289-721e-4dd7-a663-afec62ab9d54"
agent_object_id = "94452bde-a4a8-4968-9998-1b7050706199"

# Bastion Host Variables
bastion_subnet_name = "snet-bastion"
bastion_subnet_address_prefixes = ["10.20.3.0/24"]
bastion_admin_username = "azureuser"
bastion_admin_password = "YourBastionPassword!123"