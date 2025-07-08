resource "azurerm_resource_group" "tfstate_rg" {
  name     = "tfstate-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                     = "tfstatesa${random_string.sa_suffix.result}"
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = azurerm_resource_group.tfstate_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate_sc" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}

resource "random_string" "sa_suffix" {
  length  = 8
  special = false
  upper   = false
}