resource_group_name = "optscale-rg-optscale-infra"
location            = "eastus"
tags                = {
  project = "optscale"
  env     = "dev"
  managed_by = "optscale-infra"
}

vnet_name           = "optscale-vnet-optscale-infra"
vnet_address_space  = ["10.10.0.0/16"]

aks_subnet_name           = "optscale-aks-subnet"
aks_subnet_address_prefixes = ["10.10.1.0/24"]

aks_cluster_name    = "optscale-aks-cluster-optscale-infra"
kubernetes_version  = "1.33.2"
dns_prefix          = "optscale-aks-optscale-infra"

system_node_pool_vm_size    = "Standard_B2s"
system_node_pool_node_count = 1

user_node_pools = {
  default = {
    name                = "userpool"
    vm_size             = "Standard_B2s"
    node_count          = 2
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }
}

private_cluster_enabled = true
azure_policy_enabled    = true
admin_group_object_ids  = []

db_admin_login      = "optscaleadmin"
db_admin_password   = "Dboptscale@672495"
db_vm_size          = "Standard_B2s"

redis_cache_name    = "optscale-redis-cache-optscale-infra"
redis_cache_sku     = "Standard"

storage_account_name = "optscalesainfra"

optscale_version = "latest"

key_vault_name    = "opt-kv-a1b2c3d4"
tenant_id         = "ff355289-721e-4dd7-a663-afec62ab9d54"
agent_object_id   = "94452bde-a4a8-4968-9998-1b7050706199"

bastion_admin_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8Yo6GiThyrqJDxTm8+zaqqTHCZaUBhQQdBtMKBjYbhwhbZaRXGN+TqAVoi41u6Kj6b6nCvXnnVTmkbsKRugrAnNkvwU+5nTt/Fj4CYKwf7zxWjucffiiy7YYlGRPaU2GFBcCF6RN0pkJJm82L8VGlsj+gwiPoCWQuFAwXd4/vRmft4c1yGce9ig/UE21fv0G9rXcydh5YnGL3PYt3PQEAq4tRd/w7r2Wh/45ONYVUYhg1KJemqbBQ8+PXe66SeK0tyYhk5bQJy6WTGivd7FhYpIb1Lbxr+e9rFXZ4tXkSwBjf4MnmgchGDE/GZIJgUektQpV+sbduHVbfMAd9QPHaBRAoNLh28NfO4+xunaqUQjW0PUWj9LvVatT1o8/hAy52X74AUHP85ZRPVTde9tuG2Me7woxQ6rKty/NO/lMunRdofygux1X4EOB2TbRm5EGjoKKAAYERGNxwSNf5GoMPPMnzChunt7UGmjCYn/6X4qEYck/eEo4UTfgIFmU78QNxEY47O2GHaGPrLMYLlg8un4TKS58+O3N330mhaLOKWJDsJh4+yh1l65sSznaaH3nwDHqtcatMPJMD2kSacOlqwcEx1TcuoQkuMO3LAL9K7GxveYq4gkdODQqmliKkqib9DWhDhhkCU168bZ+tW9ARDojRQ5F0vAs+/R8nH2vQEQ== gauravsingh@Gauravs-MacBook-Air.local"
