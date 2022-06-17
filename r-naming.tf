resource "azurecaf_name" "mysql_flexible_name" {
  name          = var.stack
  resource_type = "azurerm_mysql_flexible_server"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "mysql_flexible"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "mysql_flexible_databases" {
  for_each = var.databases

  name          = var.stack
  resource_type = "azurerm_mysql_flexible_server_database"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, each.key, var.use_caf_naming ? "" : "mysqlf"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "_"
}
