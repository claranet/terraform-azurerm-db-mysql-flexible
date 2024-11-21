locals {
  databases_ids = {
    for key, value in azurerm_mysql_flexible_database.main : key => value.id
  }

  databases_names = {
    for key, value in azurerm_mysql_flexible_database.main : key => value.name
  }

  firewall_rules_ids = {
    for key, value in azurerm_mysql_flexible_server_firewall_rule.main : key => value.id
  }

  options_output = {
    for key, value in azurerm_mysql_flexible_server_configuration.main : key => value.value
  }
}
