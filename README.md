# Azure Database for MySQL Flexible Server

Azure Managed DB - MySQL flexible

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/db-mysql-flexible/azurerm/)

This Terraform module creates an [Azure MySQL flexible server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server)
with [databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database)
and associated admin users along with logging activated and
[firewall rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule).

Following MySQL configuration options are set by default and can be overridden with the `mysql_options` variable or
fully disabled by setting the variable `mysql_recommended_options_enabled` to `false`:
```
slow_query_log: ON
long_query_time: 5
interactive_timeout: 28800
wait_timeout: 28800
innodb_change_buffering: all
innodb_change_buffer_max_size: 50
innodb_print_all_deadlocks: ON
max_allowed_packet: 1073741824 # 1GB
explicit_defaults_for_timestamp: OFF
sql_mode: ERROR_FOR_DIVISION_BY_ZERO,STRICT_TRANS_TABLES
sql_generate_invisible_primary_key: OFF # MySQL 8 only
transaction_isolation: READ-COMMITTED
```
MySQL options for SSL and audit logs can be respectively enabled with the `ssl_enforced` and `mysql_audit_logs_enabled` variables.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

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
  source  = "claranet/run/azurerm//modules/logs"
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
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.75 |
| random | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 7.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_mysql_flexible_database.mysql_flexible_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_active_directory_administrator.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_active_directory_administrator) | resource |
| [azurerm_mysql_flexible_server_configuration.mysql_flexible_server_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [random_password.mysql_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurecaf_name.mysql_flexible_databases](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.mysql_flexible_name](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_client_config.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | MySQL administrator login. Required when create\_mode is Default. | `string` | `null` | no |
| administrator\_password | MySQL administrator password. If not set, randomly generated | `string` | `null` | no |
| allowed\_cidrs | Map of authorized CIDRs | `map(string)` | `{}` | no |
| backup\_retention\_days | Backup retention days for the server, supported values are between `7` and `35` days. | `number` | `10` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| create\_mode | The creation mode which can be used to restore or replicate existing servers. | `string` | `"Default"` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_server\_name | Custom Server Name identifier | `string` | `null` | no |
| databases | Map of databases with default collation and charset. | `map(map(string))` | `{}` | no |
| delegated\_subnet\_id | The ID of the virtual network subnet to create the MySQL Flexible Server. | `string` | `null` | no |
| entra\_authentication | Azure Entra authentication configuration block for this Azure MySQL Flexible Server. You have to assign `Directory Readers` Azure Entra role to the User Assigned Identity, see [documentation](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin). See dedicated [example](examples/entra-auth/modules.tf). | <pre>object({<br/>    user_assigned_identity_id = optional(string, null)<br/>    login                     = optional(string, null)<br/>    object_id                 = optional(string, null)<br/>  })</pre> | `{}` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Map of custom tags | `map(string)` | `{}` | no |
| geo\_redundant\_backup\_enabled | Turn Geo-redundant server backups on/off. Not available for the Burstable tier. | `bool` | `true` | no |
| high\_availability | Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability | <pre>object({<br/>    mode                      = string<br/>    standby_availability_zone = optional(number)<br/>  })</pre> | <pre>{<br/>  "mode": "SameZone",<br/>  "standby_availability_zone": 1<br/>}</pre> | no |
| identity\_ids | A list of User Assigned Managed Identity IDs to be assigned to this MySQL Flexible Server. | `list(string)` | `[]` | no |
| location | Azure location | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| maintenance\_window | Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance | `map(number)` | `null` | no |
| mysql\_audit\_logs\_enabled | Whether MySQL audit logs are enabled. Categories `CONNECTION`, `ADMIN`, `CONNECTION_V2`, `DCL`, `DDL`, `DML`, `DML_NONSELECT`, `DML_SELECT`, `GENERAL` and `TABLE_ACCESS` are set by default when enabled<br/>  and can be overridden with variable `mysql_options`. See https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-audit-logs#configure-audit-logging." | `bool` | `false` | no |
| mysql\_options | Map of MySQL configuration options: https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html. See README file for defaults. | `map(string)` | `{}` | no |
| mysql\_recommended\_options\_enabled | Whether this module recommended MySQL options are set. | `bool` | `true` | no |
| mysql\_version | MySQL server version. Valid values are `5.7` and `8.0.21` | `string` | `"8.0.21"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| point\_in\_time\_restore\_time\_in\_utc | The point in time to restore from creation\_source\_server\_id when create\_mode is PointInTimeRestore. Changing this forces a new MySQL Flexible Server to be created. | `string` | `null` | no |
| private\_dns\_zone\_id | The ID of the private dns zone to create the MySQL Flexible Server. | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| size | The size for the MySQL Flexible Server. | `string` | `"Standard_D2ds_v4"` | no |
| source\_server\_id | The resource ID of the source MySQL Flexible Server to be restored. | `string` | `null` | no |
| ssl\_enforced | Enforce SSL connection on MySQL provider and set require\_secure\_transport on MySQL Server | `bool` | `true` | no |
| stack | Project stack name | `string` | n/a | yes |
| storage | Map of the storage configuration | <pre>object({<br/>    auto_grow_enabled  = optional(bool, true)<br/>    size_gb            = optional(number)<br/>    io_scaling_enabled = optional(bool, false)<br/>    iops               = optional(number)<br/>  })</pre> | `{}` | no |
| tier | Tier for MySQL flexible server SKU. Possible values are: `GeneralPurpose`, `Burstable`, `MemoryOptimized`. | `string` | `"GeneralPurpose"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_server_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_caf\_naming\_for\_databases | Use the Azure CAF naming provider to generate databases name. | `bool` | `false` | no |
| zone | Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3 | `number` | `null` | no |

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
| mysql\_options | MySQL server configuration options. |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->

## Related documentation

- Microsoft Azure documentation: [docs.microsoft.com/fr-fr/azure/mysql/flexible-server/overview](https://docs.microsoft.com/fr-fr/azure/mysql/flexible-server/overview)
- Microsoft Azure Entra authentication documentation: [learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#configure-the-microsoft-entra-admin)
