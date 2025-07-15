resource "azurerm_data_protection_backup_instance_mysql_flexible_server" "main" {
  count            = var.backup_vault_policy != null ? 1 : 0
  backup_policy_id = var.backup_vault_policy.policy_id
  location         = var.location
  name             = local.name
  server_id        = azurerm_mysql_flexible_server.main.id
  vault_id         = var.backup_vault_policy.backup_vault_id
}