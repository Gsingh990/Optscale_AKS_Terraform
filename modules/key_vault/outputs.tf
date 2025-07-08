output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.optscale_kv.id
}

output "db_password_secret_name" {
  description = "The name of the secret containing the database password."
  value       = azurerm_key_vault_secret.db_password_secret.name
}
