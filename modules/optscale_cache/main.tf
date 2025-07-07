resource "azurerm_redis_cache" "main" {
  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 0 # C0 Basic
  family              = var.redis_cache_sku == "Premium" ? "P" : "C" # Corrected family logic
  sku_name            = var.redis_cache_sku
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"

  tags = var.tags
}
