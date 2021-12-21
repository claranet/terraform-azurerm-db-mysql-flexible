output "mysql_administrator_login" {
  description = "Administrator login for MySQL server"
  value       = local.administrator_login
}

output "mysql_administrator_password" {
  description = "Administrator password for mysql server"
  value       = local.administrator_password
  sensitive   = true
}

output "mysql_flexible_databases" {
  description = "Map of databases infos"
  value       = azurerm_mysql_flexible_database.mysql_flexible_db
}

output "mysql_flexible_databases_names" {
  description = "List of databases names"
  value       = [for db in azurerm_mysql_flexible_database.mysql_flexible_db : db.name]
}

output "mysql_flexible_database_ids" {
  description = "The list of all database resource ids"
  value       = [for db in azurerm_mysql_flexible_database.mysql_flexible_db : db.id]
}

output "mysql_flexible_firewall_rule_ids" {
  description = "Map of MySQL created rules"
  value       = azurerm_mysql_flexible_server_firewall_rule.firewall_rules
}

output "mysql_flexible_fqdn" {
  description = "FQDN of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
}

output "mysql_flexible_server_id" {
  description = "MySQL server ID"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.id
}

output "mysql_flexible_server_name" {
  description = "MySQL server name"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.name
}

output "mysql_flexible_vnet_rules" {
  description = "The map of all vnet rules"
  value       = azurerm_mysql_virtual_network_rule.vnet_rules
}

output "mysql_flexible_server_users" {
  description = "List of created users"
  value       = { for db, c in var.databases : db => mysql_user.users[db].user if length(mysql_user.users) > 0 }
}

output "mysql_flexible_server_users_passwords" {
  description = "List of created users' passwords"
  value       = { for db, c in var.databases : db => random_password.db_passwords[db].result if length(random_password.db_passwords) > 0 }
  sensitive   = true
}

output "mysql_flexible_server_replica_capacity" {
  description = "The maximum number of replicas that a primary MySQL Flexible Server can have"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.replica_capacity
}

output "mysql_flexible_server_public_network_access_enabled" {
  description = "Is the public network access enabled"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.public_network_access_enabled

}