output "bastion_host_name" {
  description = "The name of the bastion host."
  value       = azurerm_bastion_host.bastion_host.name
}
