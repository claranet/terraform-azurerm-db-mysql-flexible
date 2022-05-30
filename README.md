# Azure Database for MySQL Flexible Server

Azure Managed DB - MySQL flexible

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/db-mysql-flexible/azurerm/)

This Terraform module creates an [Azure MySQL flexible server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server)
with [databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) and associated admin users along with logging activated and
[firewall rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
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
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | >= 1.2.12 |
| azurerm | >= 3.0 |
| mysql.users\_mgmt | >=1.10.4 |
| random | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.mysql_flexible_databases](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.mysql_flexible_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_mysql_flexible_database.mysql_flexible_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_configuration.mysql_flexible_server_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [azurerm_mysql_virtual_network_rule.vnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_virtual_network_rule) | resource |
| [mysql_grant.roles](https://registry.terraform.io/providers/winebarrel/mysql/latest/docs/resources/grant) | resource |
| [mysql_user.users](https://registry.terraform.io/providers/winebarrel/mysql/latest/docs/resources/user) | resource |
| [random_password.db_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mysql_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | MySQL administrator login | `string` | n/a | yes |
| administrator\_password | MySQL administrator password. If not set, randomly generated | `string` | `null` | no |
| allowed\_cidrs | Map of authorized CIDRs | `map(string)` | n/a | yes |
| allowed\_subnets | Map of authorized subnet IDs | `map(string)` | `{}` | no |
| backup\_retention\_days | Backup retention days for the server, supported values are between `7` and `35` days. | `number` | `10` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| create\_databases\_users | True to create a user named <db>(\_user) per database with generated password. | `bool` | `true` | no |
| create\_mode | The creation mode which can be used to restore or replicate existing servers. | `string` | `"Default"` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_server\_name | Custom Server Name identifier | `string` | `null` | no |
| databases | Map of databases with default collation and charset. | `map(map(string))` | n/a | yes |
| delegated\_subnet\_id | The ID of the virtual network subnet to create the MySQL Flexible Server. | `string` | `null` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Map of custom tags | `map(string)` | `{}` | no |
| geo\_redundant\_backup\_enabled | Turn Geo-redundant server backups on/off. Not available for the Basic tier. | `bool` | `true` | no |
| high\_availability | Map of high availability configuration: https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-high-availability. | <pre>object({<br>    mode                      = string<br>    standby_availability_zone = optional(number)<br>  })</pre> | <pre>{<br>  "mode": "SameZone",<br>  "standby_availability_zone": 1<br>}</pre> | no |
| location | Azure location | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| maintenance\_window | Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance | `map(number)` | `null` | no |
| mysql\_options | Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters. | `map(string)` | `{}` | no |
| mysql\_version | MySQL server version. Valid values are `5.7` and `8.0.21` | `string` | `"8.0.21"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| private\_dns\_zone\_id | The ID of the private dns zone to create the MySQL Flexible Server. | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| size | The size for the MySQL Flexible Server. | `string` | `"Standard_D2ds_v4"` | no |
| source\_server\_id | The resource ID of the source MySQL Flexible Server to be restored. | `string` | `null` | no |
| ssl\_enforced | Enforce SSL connection | `bool` | `true` | no |
| stack | Project stack name | `string` | n/a | yes |
| storage | Map of the storage configuration | <pre>object({<br>    auto_grow_enabled = optional(bool)<br>    iops              = optional(number)<br>    size_gb           = optional(number)<br>  })</pre> | `null` | no |
| tier | Tier for MySQL flexible server SKU. Possible values are: `GeneralPurpose`, `Basic`, `MemoryOptimized`. | `string` | `"GeneralPurpose"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_server_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_caf\_naming\_for\_databases | Use the Azure CAF naming provider to generate databases name. | `bool` | `false` | no |
| user\_suffix | Suffix to append to the created users | `string` | `"_user"` | no |
| zone | Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3 | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| mysql\_administrator\_login | Administrator login for MySQL server |
| mysql\_administrator\_password | Administrator password for MySQL server |
| mysql\_flexible\_database\_ids | The list of all database resource IDs |
| mysql\_flexible\_databases | Map of databases infos |
| mysql\_flexible\_databases\_names | List of databases names |
| mysql\_flexible\_firewall\_rule\_ids | Map of MySQL created firewall rules |
| mysql\_flexible\_fqdn | FQDN of the MySQL server |
| mysql\_flexible\_server\_id | MySQL server ID |
| mysql\_flexible\_server\_name | MySQL server name |
| mysql\_flexible\_server\_public\_network\_access\_enabled | Is the public network access enabled |
| mysql\_flexible\_server\_replica\_capacity | The maximum number of replicas that a primary MySQL Flexible Server can have |
| mysql\_flexible\_server\_users | List of created users |
| mysql\_flexible\_server\_users\_passwords | List of created users passwords |
| mysql\_flexible\_vnet\_rules | The map of all VNet rules |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/fr-fr/azure/mysql/flexible-server/overview](https://docs.microsoft.com/fr-fr/azure/mysql/flexible-server/overview)
