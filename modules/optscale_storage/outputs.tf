output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_access_key" {
  description = "The primary access key of the Storage Account."
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}
