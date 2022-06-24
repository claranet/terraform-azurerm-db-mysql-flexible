resource "azurerm_mysql_flexible_server_firewall_rule" "firewall_rules" {
  for_each = var.delegated_subnet_id != null ? var.allowed_cidrs : {}

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}
