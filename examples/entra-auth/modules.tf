data "azurerm_client_config" "current" {}

# According to the documentation : https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin,
# You should assign the "Directory Readers" Microsoft Entra role to this User Assigned Identity.
resource "azurerm_user_assigned_identity" "mysql_entra" {
  name                = "mysql-entra-${var.environment}"
  location            = module.azure_region.location
  resource_group_name = module.rg.name
}

module "mysql_flexible" {
  source  = "claranet/db-mysql-flexible/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  tier          = "GeneralPurpose"
  mysql_version = "8.0.21"

  allowed_cidrs = {
    "peered-vnet"     = "10.0.0.0/24"
    "customer-office" = "12.34.56.78/32"
  }

  backup_retention_days        = 10
  geo_redundant_backup_enabled = true

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  databases = {
    "documents" = {
      "charset"   = "utf8"
      "collation" = "utf8_general_ci"
    }
  }

  entra_authentication = {
    object_id                 = data.azurerm_client_config.current.object_id
    user_assigned_identity_id = azurerm_user_assigned_identity.mysql_entra.id
    login                     = "myusername"
  }

  identity_ids = [
    azurerm_user_assigned_identity.mysql_entra.id,
  ]

  options = {
    interactive_timeout = "600"
    wait_timeout        = "260"
  }

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

provider "mysql" {
  endpoint = "${module.mysql_flexible.fqdn}:3306"
  username = var.administrator_login
  password = var.administrator_password

  tls = true
}

module "mysql_users" {
  source  = "claranet/users/mysql"
  version = "x.x.x"

  for_each = module.mysql_flexible.databases_names

  user     = each.key
  database = each.key

  user_suffix_enabled = true
}
