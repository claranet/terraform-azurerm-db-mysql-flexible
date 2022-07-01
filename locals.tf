locals {

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  administrator_login    = azurerm_mysql_flexible_server.mysql_flexible_server.administrator_login
  administrator_password = coalesce(var.administrator_password, random_password.mysql_administrator_password.result)

  user_suffix = var.user_suffix != null ? var.user_suffix : ""

  tier_map = {
    "GeneralPurpose"  = "GP"
    "Burstable"       = "B"
    "MemoryOptimized" = "MO"
  }
  default_mysql_options = {
    require_secure_transport = var.ssl_enforced ? "ON" : "OFF"
  }
}
