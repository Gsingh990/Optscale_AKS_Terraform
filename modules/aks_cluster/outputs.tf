output "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.name
}

output "kube_config" {
  description = "The KubeConfig block to connect to the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.kube_config
  sensitive   = true
}