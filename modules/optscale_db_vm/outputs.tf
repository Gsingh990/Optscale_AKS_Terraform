output "db_server_fqdn" {
  description = "The fully qualified domain name of the database server."
  value       = azurerm_linux_virtual_machine.db_vm.private_ip_address
}

output "db_name" {
  description = "The name of the database."
  value       = "optscale"
}

output "db_admin_login" {
  description = "The admin username for the database."
  value       = var.db_admin_login
}