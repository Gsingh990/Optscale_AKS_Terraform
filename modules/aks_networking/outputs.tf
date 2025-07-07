output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}