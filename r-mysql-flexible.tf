resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  name = local.mysql_flexible_server_name

  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login    = var.administrator_login
  administrator_password = local.administrator_password
  version                = var.mysql_version

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  delegated_subnet_id          = var.delegated_subnet_id

  sku_name    = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), var.size])
  create_mode = var.create_mode

  source_server_id = var.source_server_id

  private_dns_zone_id = var.private_dns_zone_id


  dynamic "high_availability" {
    for_each = toset(var.high_availability != null ? [var.high_availability] : [])

    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone", 1)
    }
  }

  dynamic "maintenance_window" {
    for_each = toset(var.maintenance_window != null ? [var.maintenance_window] : [])

    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }

  dynamic "storage" {
    for_each = toset(var.storage != null ? [var.storage] : [])

    content {
      auto_grow_enabled = lookup(storage.value, "auto_grow_enabled", true)
      iops              = lookup(storage.value, "iops", 360)
      size_gb           = lookup(storage.value, "size_gb", 20)
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_mysql_flexible_database" "mysql_flexible_db" {
  for_each = var.databases

  name                = var.use_caf_naming_for_databases ? azurecaf_name.mysql_flexible_databases[each.key].result : each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  charset             = lookup(each.value, "charset", "utf8")
  collation           = lookup(each.value, "collation", "utf8_general_ci")
}

resource "azurerm_mysql_flexible_server_configuration" "mysql_flexible_server_config" {
  for_each = var.mysql_options

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  value               = each.value
}

resource "random_password" "mysql_administrator_password" {
  length           = 32
  special          = true
  override_special = "@#%&*()-_=+[]{}<>:?"
}
