resource "random_password" "administrator_password" {
  count = var.administrator_password == null ? 1 : 0

  length           = 32
  special          = true
  override_special = "@#%&*()-_=+[]{}<>:?"
}

moved {
  from = random_password.mysql_administrator_password
  to   = random_password.administrator_password
}

resource "azurerm_mysql_flexible_server" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  administrator_login    = var.administrator_login
  administrator_password = local.administrator_password

  sku_name = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), var.size])
  version  = var.mysql_version

  public_network_access = var.delegated_subnet != null && var.private_dns_zone != null ? "Disabled" : (var.public_network_access_enabled ? "Enabled" : "Disabled")
  delegated_subnet_id   = one(var.delegated_subnet[*].id)
  private_dns_zone_id   = one(var.private_dns_zone[*].id)

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  create_mode                       = var.create_mode
  source_server_id                  = var.source_server_id
  point_in_time_restore_time_in_utc = var.point_in_time_restore_time_in_utc

  dynamic "high_availability" {
    for_each = var.high_availability[*]
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window[*]
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  dynamic "storage" {
    for_each = var.storage[*]
    content {
      auto_grow_enabled  = var.storage.auto_grow_enabled
      size_gb            = var.storage.size_gb
      io_scaling_enabled = var.storage.io_scaling_enabled
      iops               = var.storage.iops
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  zone = var.zone

  tags = merge(local.default_tags, var.extra_tags)

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone,
    ]
    precondition {
      condition     = (var.storage.io_scaling_enabled && var.storage.iops == null) || (!var.storage.io_scaling_enabled && var.storage.iops != null)
      error_message = "You have to choose between enabling storage auto-scaling IO without defining storage IOPS or disabling storage auto-scaling IO with defined storage IOPS."
    }
  }
}

moved {
  from = azurerm_mysql_flexible_server.mysql_flexible_server
  to   = azurerm_mysql_flexible_server.main
}

resource "azurerm_mysql_flexible_database" "main" {
  for_each = var.databases

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = each.value.charset
  collation           = each.value.collation
}

moved {
  from = azurerm_mysql_flexible_database.mysql_flexible_db
  to   = azurerm_mysql_flexible_database.main
}

resource "azurerm_mysql_flexible_server_firewall_rule" "main" {
  for_each = var.delegated_subnet == null ? var.allowed_cidrs : {}

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}

moved {
  from = azurerm_mysql_flexible_server_firewall_rule.firewall_rules
  to   = azurerm_mysql_flexible_server_firewall_rule.main
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule#example-usage-allow-access-to-azure-services
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  count = var.delegated_subnet == null && var.allowed_azure_services ? 1 : 0

  name                = "Azure-Services"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_flexible_server_configuration" "main" {
  for_each = local.options

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  value               = each.value
}

moved {
  from = azurerm_mysql_flexible_server_configuration.mysql_flexible_server_config
  to   = azurerm_mysql_flexible_server_configuration.main
}

resource "azurerm_mysql_flexible_server_active_directory_administrator" "main" {
  count = length(var.entra_authentication.object_id[*]) > 0 ? 1 : 0

  server_id   = azurerm_mysql_flexible_server.main.id
  identity_id = var.entra_authentication.user_assigned_identity_id
  login       = var.entra_authentication.login
  object_id   = var.entra_authentication.object_id
  tenant_id   = data.azurerm_client_config.main.tenant_id
}
