module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

data "azurerm_client_config" "current" {}


#### According to the documentation : https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin.
#### You should assign the "Directory Readers" Microsoft Entra role to this User Assigned Identity.
resource "azurerm_user_assigned_identity" "mysql_entra" {
  location            = module.azure_region.location
  name                = format("mysql-entra-%s", var.environment)
  resource_group_name = module.rg.resource_group_name
}

module "mysql_flex" {
  source  = "claranet/db-mysql-flexible/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  allowed_cidrs = {
    "peered-vnet"     = "10.0.0.0/24"
    "customer-office" = "12.34.56.78/32"
  }

  tier                         = "GeneralPurpose"
  backup_retention_days        = 10
  geo_redundant_backup_enabled = true

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  identity_ids = [azurerm_user_assigned_identity.mysql_entra.id]

  entra_authentication = {
    object_id                 = data.azurerm_client_config.current.object_id
    user_assigned_identity_id = azurerm_user_assigned_identity.mysql_entra.id
    login                     = "myusername"
  }

  databases = {
    "documents" = {
      "charset"   = "utf8"
      "collation" = "utf8_general_ci"
    }
  }

  mysql_options = {
    interactive_timeout = "600"
    wait_timeout        = "260"
  }
  mysql_version = "8.0.21"

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

provider "mysql" {
  endpoint = format("%s:3306", module.mysql_flex.mysql_flexible_fqdn)
  username = var.administrator_login
  password = var.administrator_password

  tls = true
}

module "mysql_users" {
  source  = "claranet/users/mysql"
  version = "x.x.x"

  for_each = toset(module.mysql_flex.mysql_flexible_databases_names)

  user_suffix_enabled = true
  user                = each.key
  database            = each.key
}
