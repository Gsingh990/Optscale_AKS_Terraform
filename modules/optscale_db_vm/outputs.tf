
output "db_server_fqdn" {
  value = azurerm_network_interface.db_vm_nic.private_ip_address
}

output "db_name" {
  value = "optscale"
}

output "db_admin_login" {
  value = var.db_admin_login
}

output "db_admin_password" {
  value = var.db_admin_password
  sensitive = true
}
