data "azurecaf_name" "mysql_flexible_server" {
  name          = var.stack
  resource_type = "azurerm_mysql_flexible_server"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
