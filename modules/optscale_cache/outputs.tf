output "redis_host_name" {
  description = "The hostname of the Redis Cache."
  value       = azurerm_redis_cache.main.hostname
}

output "redis_primary_access_key" {
  description = "The primary access key of the Redis Cache."
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}
