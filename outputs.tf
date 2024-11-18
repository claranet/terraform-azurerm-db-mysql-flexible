output "resource" {
  description = "Azure MySQL server resource object."
  value       = azurerm_mysql_flexible_server.main
}

output "resource_database" {
  description = "Azure MySQL database resource object."
  value       = azurerm_mysql_flexible_database.main
}

output "resource_configuration" {
  description = "Azure MySQL configuration resource object."
  value       = azurerm_mysql_flexible_server_configuration.main
}

output "resource_firewall_rule" {
  description = "Azure MySQL server firewall rule resource object."
  value       = azurerm_mysql_flexible_server_firewall_rule.main
}

output "module_diagnostics" {
  description = "Diagnostics settings module outputs."
  value       = module.diagnostics
}

output "id" {
  description = "ID of the Azure MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.main.id
}

output "name" {
  description = "Name of the Azure MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.main.name
}

output "fqdn" {
  description = "FQDN of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "administrator_login" {
  description = "Administrator login for MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.main.administrator_login
}

output "administrator_password" {
  description = "Administrator password for MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.main.administrator_password
  sensitive   = true
}

output "public_network_access_enabled" {
  description = "Is the public network access enabled?"
  value       = azurerm_mysql_flexible_server.main.public_network_access_enabled
}

output "replica_capacity" {
  description = "The maximum number of replicas that a primary MySQL Flexible Server can have."
  value       = azurerm_mysql_flexible_server.main.replica_capacity
}

output "databases_ids" {
  description = "Map of databases IDs."
  value       = local.databases_ids
}

output "databases_names" {
  description = "Map of databases names."
  value       = local.databases_names
}

output "firewall_rules_ids" {
  description = "Map of firewall rules IDs."
  value       = local.firewall_rules_ids
}

output "options" {
  description = "MySQL server configuration options."
  value       = local.options_output
}

output "terraform_module" {
  description = "Information about this Terraform module."
  value = {
    name       = "db-mysql-flexible"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
